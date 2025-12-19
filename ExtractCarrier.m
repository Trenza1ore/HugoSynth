% Extract the flattened spectrum of a carrier signal for cross-synthesis
% Written by Hugo (Jin Huang) in Nov 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Useful when performing cross-synthesis with a looped carrier signal
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulator - the modulating signal (we extract features from it)
% Carrier   - the carrier signal (we impress the features onto it)

function [padded, pad, paddedLen, carrierSTFT] = ExtractCarrier(carrier, Fs, window, order)
    % Zero-pad the input signal so that the reconstructed signal has
    % correct length: (signalLength - noverlap) / (1024 - noverlap) must be
    % an integer for the reconstructed signal to be of correct size
    signalLen = size(carrier, 1);
    if (mod(signalLen, 1024) > 0)
        paddedLen = ceil(signalLen / 1024) * 1024;
        paddedLen = paddedLen - signalLen;
        pad = zeros(paddedLen, 1);
        carrier = [pad; carrier];
        padded = true;
    else
        padded = false;
    end

    % Perform short-time fourier transform to the carrier signal
    carrierSTFT = stft(carrier, Fs, Window = window, FFTLength = 1024, OverlapLength = 768);

    % Calculate the amplitude spectrum
    carrierSTFTAmp = abs(carrierSTFT) + eps;

    % Extract spectral envelope via the Linear Prediction method (LPC)
    carrierLPC = lpc(carrierSTFTAmp, order);
    carrierEnv = smoothdata(filter([0 -carrierLPC(2:end)], 1, carrierSTFTAmp)) - eps;

    % Find the points where NaN / Inf can happen
    errorPoints = (carrierSTFT == 0);

    % Flatten the carrier signal's spectrum
    carrierSTFT = carrierSTFT ./ carrierEnv;

    % Fix the error points
    carrierSTFT(errorPoints) = 0;
end