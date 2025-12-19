% Cross-synthesize two signals together with LPC
% Written by Hugo (Jin Huang) in Nov 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is a version derived from the book DAFX: Digital Audio Effects
% Basically, for each time frame (size = hopLen):
% - Calculate LPC with a slice of length windowLen (>= hopLen)
% - Calculate the modulated signal for each sample in this frame
%   - Extract excitation from carrier
%   - Use carrier excitation * gain, modulator LPC in a feedback loop
% - Trim the padded zeros and return the output
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulator - the modulating signal (we extract features from it)
% Carrier   - the carrier signal (we impress the features onto it)

function modulatedCarrier = CrossSynthLPC(modulator, modOrder, carrier, carrierOrder, windowLen, hopLen)
    % Record original length of signals
    originalSignalLen = size(modulator, 1);

    % Pad the signals to prevent array out of bounds
    pad1 = zeros(carrierOrder, 1); pad2 = zeros(windowLen + hopLen, 1);    
    modulator = [pad1; modulator; pad2];
    carrier = [pad1; carrier; pad2];
    paddedsignalLen = size(modulator, 1);
    modulatedCarrier = zeros(paddedsignalLen, 1);

    % N = number of time frames
    N = floor(originalSignalLen / hopLen);

    % Create the window
    window = hanning(windowLen, 'periodic');

    % For each frame
    for i = 1:N
        % Calculate the starting position of this frame
        frameStart = carrierOrder + hopLen * (i - 1);
        % Calculate LP coefficients for the two signals of this frame
        % Use the variance of the prediction error as gain factor
        [modLPC, gain] = calc_lpc(modulator(frameStart+1:frameStart+windowLen) .* window, modOrder);
        [carLPC, carGain] = calc_lpc(carrier(frameStart+1:frameStart+windowLen) .* window, carrierOrder);
        % LP cofficients for excitation
        excLPC = - modLPC(2:end);

        % Hop is like no-overlap or (window_size - overlap) for stft
        for j = 1:hopLen
            pos = frameStart + j;
            % The excitation of carrier signal
            carrierExc = (carLPC / carGain) * carrier(pos:-1:(pos - carrierOrder));
            % Feedback loop
            modulatedCarrier(pos) = excLPC * modulatedCarrier((pos - 1):-1:(pos - modOrder)) + gain * carrierExc;
        end
    end

    % Trim the padded zeros
    modulatedCarrier = modulatedCarrier((carrierOrder + 1):(carrierOrder + originalSignalLen));
end