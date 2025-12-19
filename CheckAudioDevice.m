% Detect if the earphone bug is there...
function CheckAudioDevice(app)
    inputdeviceID = app.inputDeviceID;
    outputdeviceID = app.outputDeviceID;
    if (~audiodevinfo(1, inputdeviceID, 44100, 24, 1))
        inputdeviceID = audiodevinfo(0, 44100, 24, 1);
    end
    if (~audiodevinfo(0, outputdeviceID, 44100, 24, 1))
        outputdeviceID = audiodevinfo(1, 44100, 24, 1);
    end
    app.ChangeAudioDevice(inputdeviceID, outputdeviceID);
end