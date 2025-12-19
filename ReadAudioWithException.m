% Wrap the audioread function to return errors
function [trackAudio, trackFs, error] = ReadAudioWithException(app, fullPath)
    [trackAudio, trackFs] = audioread(fullPath, 'double');
    if (trackFs == 0 || size(trackAudio, 1) < 441)
%         uialert(app.UIFigure, 'Audio file is empty', 'This does not seem to be a valid audio file?', ...
%             'Icon', 'error');
        error = true;
    else
        error = false;
    end
end