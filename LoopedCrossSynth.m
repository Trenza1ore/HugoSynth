% Cross-synthesize two signals together with LP spectral envelopes
% Written by Hugo (Jin Huang) in Nov 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This version expects the pre-calculated flattened carrier spectrum to be
% passed in as an argument, useful when the carrier signal is looped.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulator - the modulating signal (we extract features from it)
% Carrier   - the carrier signal (we impress the features onto it)

function modulatedCarrier = LoopedCrossSynth(modulator, Fs, window, flattenedCarrierSTFT, order, padded, paddedLen)
    % Perform short-time fourier transform to the modulating signal
    modulatorSTFT = stft(modulator, Fs, Window = window, FFTLength = 1024, OverlapLength = 768);

    % Calculate the amplitude spectrum
    modulatorSTFTAmp = abs(modulatorSTFT) + eps;

    % Extract spectral envelope via the Linear Prediction method (LPC)
    modulatorLPC = lpc(modulatorSTFTAmp, order);
    modulatorEnv = smoothdata(filter([0 -modulatorLPC(2:end)], 1, modulatorSTFTAmp)) - eps;

    % Apply the modulating signal's spectral envelope onto the flattened spectrum
    modulatedCarrierSTFT = modulatorEnv .* flattenedCarrierSTFT;

    % Just to be safe
    modulatedCarrierSTFT(isnan(modulatedCarrierSTFT)) = 0;
    modulatedCarrierSTFT(isinf(modulatedCarrierSTFT)) = 0;

    % Reconstruct the modulated carrier signal
    modulatedCarrier = istft( ...
        modulatedCarrierSTFT, Fs, Window = window, FFTLength = 1024, OverlapLength = 768);

    % Trim the padded part
    if (padded)
        modulatedCarrier = modulatedCarrier(paddedLen + 1:end, 1);
    end
end