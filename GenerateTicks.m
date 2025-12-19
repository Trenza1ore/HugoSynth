function [Ticks, TickLabels] = GenerateTicks(trackAudioLen, trackFs)
    % Set tick value according to the length of loaded track
    trackLenInSec = trackAudioLen / trackFs;
    if (trackAudioLen < 10 * trackFs)
        Ticks = 1:(trackFs / 2):trackAudioLen;
        TickLabels = string(0:0.5:trackLenInSec);
    elseif (trackAudioLen < 100 * trackFs)
        Ticks = 1:(5 * trackFs):trackAudioLen;
        TickLabels = string(0:5:trackLenInSec);
    else
        Ticks = 1:(10 * trackFs):trackAudioLen;
        TickLabels = string(0:10:trackLenInSec);
    end
end