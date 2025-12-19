% Cross-synthesize two signals together with LP spectral envelopes
% Written by Hugo (Jin Huang) in Nov 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the wrapper version that processes the two signals in a
% multi-processing way, it splits long signals into small slices and
% pre-calculates the flattened spectrum of the carrier signal if it is a
% looped signal.
%
% Looped carrier is (functionally) the same as:
% carrier(start:end) + N * carrier(loopBegin:loopEnd) + (1:tailEnd).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arguments:
% Modulator - (pos 1) the modulating signal (we extract features from it)
% order 1   - (pos 2) the linear prediction order of modulator (high)
% Carrier   - (pos 3) the carrier signal (we impress the features onto it)
% order 2   - (pos 4) the linear prediction order of carrier (low)
% Fs        - (pos 5) the sampling frequency
% poolOpt   - (pos 6) pool option if required, value: none/para/init
% p         - (pos 7) pool object, pass in anything if poolOpt = none/init
% normOpt   - (pos 8) normalization option, value: none/clip/scal
% extraOpt  - (varargin 1) extra option, 'looped' means carrier's looped
% start     - (varargin 2) start position of the looped carrier's header part
% loopBegin - (varargin 3) start position of the carrier's loop
% loopEnd   - (varargin 4) end position of the carrier's loop
% extraOpt  - (varargin 1) extra option, 'vocode' means to use the better vocoder option
% winLen    - (varargin 2) window length for calculating LPC
% hopLen    - (varargin 3) length of each time frame, defaults to winLen / 4
%
% These should be arguments but are not for simplicity:
% (Since this coursework is already complex enough...)
% value     = 1024      the n for N-point FFT
% windowSize= 1024      the window size to use for STFT
% windowFcn = hanning   the window function
% envelope  = lpc       the method for extracting spectral envelope
% (My Cepstral Envelope implementation doesn't work so it's deleted)

function [modulatedCarrier, p] = CrossSynth(modulator, order1, carrier, order2, Fs, poolOpt, p, normOpt, varargin)
    % Normalize audio
    modulator = NormAudio(modulator);
    carrier = NormAudio(carrier);

    % Parse arguments for whether carrier's looped
    isLooped = false;
    isVocode = false;
    if (nargin > 8)
        switch (varargin{1})
            case 'looped'
                startPos = varargin{2};
                loopBegin = varargin{3};
                loopEnd = varargin{4};
                isLooped = true;
            case 'vocode'
                isVocode = true;
                winLen = varargin{2};
                if (nargin > 10)
                    hopLen = varargin{3};
                else
                    hopLen = ceil(winLen / 4);
                end
        end
    end

    % Deal with parallel computing options
    switch (poolOpt)
        case 'init'
            poolOpt = 0;
            p = parpool('local');
        case 'para'
            poolOpt = 1;
        otherwise
            poolOpt = -1;
            p = false;
    end

    % Use the better algorithm
    if (isVocode)
        modLen = size(modulator, 1); carLen = size(carrier, 1);
        if (modLen > carLen)
            n = ceil(modLen / carLen);
            carrier = repmat(carrier, n, 1);
        end
        modulatedCarrier = NormAudio(CrossSynthLPC( ...
            modulator, order1, carrier(1:modLen, 1), order2, winLen, hopLen));
        return;
    end

    % Initialize variables
    window = hanning(1024, "periodic");

    % The carrier signal's looped, can pre-calculate stuffs
    if (isLooped)
        % Slice the signals by carrier's loops
        % [Carrier signal] = [head] + N * [loop] + [tail]
        moduLen = size(modulator, 1);

        head = carrier(startPos:end, 1);
        headLen = size(head, 1);

        loopStartPos = headLen + 1;
        loopLen = loopEnd - loopBegin + 1; % in samples
        loop = carrier(loopBegin:loopEnd, 1);
        loopNum = floor((moduLen - headLen) / loopLen);
        loopTotalLen = loopNum * loopLen;

        tailStartPos = headLen + loopTotalLen + 1;
        tailLen = moduLen - tailStartPos + 1;
        tail = carrier(1:tailLen, 1);

        % Note: loopLen is expected to be > 1
        loopSta = loopStartPos:loopLen:(tailStartPos - loopLen);
        loopEnd = (loopStartPos + loopLen - 1):loopLen:tailStartPos;

        % Pre-calculate the flattened spectrum of carrier loops
        [padded, pad, paddedLen, loopSpecturm] = ExtractCarrier(loop, Fs, window, order2);

        result = cell(loopNum, 1); % use a cell array for parfor requirements

        % Cross-synthesize the loops first
        % Single-threaded workload, perhaps user doesn't own the toolbox
        if (poolOpt < 0)
            for i = 1:loopNum
                result{i} = SingleThreadLoopedCrossSynth( ...
                    modulator(loopSta(i):loopEnd(i), 1), ...
                    Fs, window, loopSpecturm, order1, padded, pad, paddedLen);
            end

        % Use a pool of threadworkers / processes for parallel computing
        else
            % Slice the modulating signal to reduce communication overhead
            % of parfor loops, as modulator is a broadcastable variable
            loops = cell(loopNum, 1);
            parfor i = 1:loopNum
                loops{i} = [pad; modulator(loopSta(i):loopEnd(i), 1)];
            end

            parfor i = 1:loopNum
                result{i} = LoopedCrossSynth( ...
                    loops{i}, Fs, window, loopSpecturm, order1, padded, paddedLen);
            end
        end

        % Put the loop slices back together
        modulatedCarrier = zeros(headLen + loopTotalLen + tailLen, 1);
        for i = 1:loopNum
            modulatedCarrier(loopSta(i):loopEnd(i), 1) = result{i};
        end
        modulatedCarrier(1:headLen, 1) = NormalCrossSynth( ...
            modulator(1:headLen, 1), head, Fs, window, order1, order2);
        modulatedCarrier(tailStartPos:end, 1) = NormalCrossSynth( ...
            modulator(tailStartPos:moduLen, 1), tail, Fs, window, order1, order2);
        modulatedCarrier = modulatedCarrier(1:moduLen, 1);

    % The carrier signal's not looped
    else
        modulatorLen = size(modulator, 1); % length of the modulating signal
        sliceLen = 1323008; % almost a length of 30 seconds if Fs = 44100
        sliceNum = ceil(modulatorLen / sliceLen); % number of slices required
        
        % No slicing required
        if (sliceNum < 2)
            modulatedCarrier = NormalCrossSynth(modulator, carrier, Fs, window, order1, order2);
        
        % Slice the signals to reduce memory requirement for FFT
        else
            sliceSta = 1:sliceLen:modulatorLen;
            sliceEnd = sliceLen:sliceLen:(modulatorLen + sliceLen);
            resultLen = sliceNum * sliceLen;
            result = cell(sliceNum, 1); % use a cell array for parfor requirements

            % Zero-pad the signals at the end and slice them
            padding = zeros(resultLen - modulatorLen, 1);
            modulator = reshape([modulator; padding], sliceLen, sliceNum);
            carrier = reshape([carrier; padding], sliceLen, sliceNum);

            % Single-threaded workload, perhaps user doesn't own the toolbox
            if (poolOpt < 0)
                for i = 1:sliceNum
                    result{i} = UnsafeCrossSynth(modulator(:, i), carrier(:, i), Fs, window, order1, order2);
                end

            % Use a pool of threadworkers / processes for parallel computing
            else
                parfor i = 1:sliceNum
                    result{i} = UnsafeCrossSynth(modulator(:, i), carrier(:, i), Fs, window, order1, order2);
                end
                delete(p);
            end

            % Put the slices back together
            modulatedCarrier = zeros(resultLen, 1);
            for i = 1:sliceNum
                modulatedCarrier(sliceSta(i):sliceEnd(i), 1) = result{i};
            end
        end
    end

    % We only need the real parts
    modulatedCarrier = real(modulatedCarrier);

    % Normalize output
    switch (normOpt)
        case 'clip'
            modulatedCarrier(modulatedCarrier > 1) = 1;
            modulatedCarrier(modulatedCarrier < -1) = -1;
        case 'scal'
            modulatedCarrier = modulatedCarrier ./ max(abs(modulatedCarrier));
    end
end