% Convolves two signals together with Convolution Theorem
% Written by Hugo (Jin Huang) in Nov 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = MyConv(signal, grain, signalLen, grainLen)
    % Perform fast fourier transform to the two signals
    F = fft(grain);
    H = fft(signal);

    % Find out how many full loop is needed
    n = floor(signalLen / grainLen);

    % Calculate the full loops
    startPos = 1:grainLen:signalLen-grainLen+1;
    endPos = grainLen:grainLen:signalLen;
    for i = 1:n
        H(startPos(i):endPos(i), 1) = H(startPos(i):endPos(i), 1) .* F;
    end
    
    % Finish up the remaining part
    remainderLen = signalLen - endPos(n);
    H(endPos(n)+1:end, 1) = H(endPos(n)+1:end, 1) .* F(1:remainderLen, 1);

    h = real(ifft(H));
end