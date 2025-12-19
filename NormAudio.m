function normSignal = NormAudio(signal)
    normSignal = 0.95 * signal ./ max(abs(signal));
end

