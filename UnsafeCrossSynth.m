% Cross-synthesize two signals together with LP spectral envelopes
% Written by Hugo (Jin Huang) in Nov 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the unsafe version without zero-padding, it may produce an output
% of different size. Also, if the carrier signal is looped, use the looped
% version instead.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulator - the modulating signal (we extract features from it)
% Carrier   - the carrier signal (we impress the features onto it)

function modulatedCarrier = UnsafeCrossSynth(modulator, carrier, Fs, window, order1, order2)
    % Perform short-time fourier transform to the two signals
    modulatorSTFT = stft(modulator, Fs, Window = window, FFTLength = 1024, OverlapLength = 768);
    carrierSTFT = stft(carrier, Fs, Window = window, FFTLength = 1024, OverlapLength = 768);

    % Calculate the amplitude spectrums
    modulatorSTFTAmp = abs(modulatorSTFT) + eps;
    carrierSTFTAmp = abs(carrierSTFT) + eps;

    % Extract spectral envelopes via the Linear Prediction method (LPC)
    modulatorLPC = lpc(modulatorSTFTAmp, order1);
    modulatorEnv = smoothdata(filter([0 -modulatorLPC(2:end)], 1, modulatorSTFTAmp)) - eps;
    carrierLPC = lpc(carrierSTFTAmp, order2);
    carrierEnv = smoothdata(filter([0 -carrierLPC(2:end)], 1, carrierSTFTAmp)) - eps;

    % Find the points where NaN / Inf can happen
    errorPoints = (carrierSTFT == 0);

    % Flatten the carrier signal's spectrum
    carrierSTFT = carrierSTFT ./ carrierEnv;
    carrierSTFT(errorPoints) = 0;

    % Apply the modulating signal's spectral envelope onto the flattened spectrum
    modulatedCarrierSTFT = modulatorEnv .* carrierSTFT;

    % Reconstruct the modulated carrier signal
    modulatedCarrier = istft( ...
        modulatedCarrierSTFT, Fs, Window = window, FFTLength = 1024, OverlapLength = 768);
end