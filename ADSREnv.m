function env = ADSREnv(A, D, S, R, SLen, loopLen)
    normFactor = A + D + R + SLen;
    A = floor(A / normFactor * loopLen);
    D = floor(D / normFactor * loopLen);
    R = floor(R / normFactor * loopLen);
    SLen = loopLen - (A + D + R);

    env = [linspace(0, 1, A) linspace(1, S, D) (ones(1, SLen) .* S) linspace(S, 0, R)]';
end