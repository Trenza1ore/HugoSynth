classdef HugoSynth < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        HugoSynthUIFigure              matlab.ui.Figure
        SynthonlyTracksMenu            matlab.ui.container.Menu
        Track5Menu                     matlab.ui.container.Menu
        AdjustTrack5OffsetMenu         matlab.ui.container.Menu
        RemoveTrack5Menu               matlab.ui.container.Menu
        Track4Menu                     matlab.ui.container.Menu
        AdjustTrack4OffsetMenu         matlab.ui.container.Menu
        RemoveTrack4Menu               matlab.ui.container.Menu
        SpectralEditingMenu            matlab.ui.container.Menu
        SpectralDeleteMenu             matlab.ui.container.Menu
        SpectralReduceMenu             matlab.ui.container.Menu
        ParametricEQMenu               matlab.ui.container.Menu
        OpenParametricEQMenu           matlab.ui.container.Menu
        ApplytoSelectedMenu            matlab.ui.container.Menu
        GraphicEQ                      matlab.ui.container.Menu
        OpenEQforTrackMenu             matlab.ui.container.Menu
        ApplyEQtoTrackMenu             matlab.ui.container.Menu
        PluginsMenu                    matlab.ui.container.Menu
        GrainPickerMenu                matlab.ui.container.Menu
        LooperMenu                     matlab.ui.container.Menu
        NotvumMenu                     matlab.ui.container.Menu
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        AdvancedSettingsPanel          matlab.ui.container.Panel
        SpectrogramThresholdEditField  matlab.ui.control.NumericEditField
        SpectrogramThresholdEditFieldLabel  matlab.ui.control.Label
        OutputAudioDeviceIDEditField   matlab.ui.control.NumericEditField
        OutputAudioDeviceIDEditFieldLabel  matlab.ui.control.Label
        LPCCrossSynthorConvolutionPanel  matlab.ui.container.Panel
        ThenewimplementationofLPCisbasedontheDAFXbooksapproachLabel  matlab.ui.control.Label
        CrossSynthVersionDropDown      matlab.ui.control.DropDown
        CrossConvSwitch                matlab.ui.control.Switch
        HopBlockSizeLabel              matlab.ui.control.Label
        ModulatorCarrierOrderLabel     matlab.ui.control.Label
        HopSize                        matlab.ui.control.Spinner
        WindowSize                     matlab.ui.control.Spinner
        Order1                         matlab.ui.control.Spinner
        Order2                         matlab.ui.control.Spinner
        CompileSynth                   matlab.ui.control.Button
        SaveinSpinner                  matlab.ui.control.Spinner
        SaveinSpinnerLabel             matlab.ui.control.Label
        ModulatorSpinner               matlab.ui.control.Spinner
        ModulatorSpinnerLabel          matlab.ui.control.Label
        CarrierSpinner                 matlab.ui.control.Spinner
        CarrierSpinnerLabel            matlab.ui.control.Label
        TrackPlaybackControlPanel      matlab.ui.container.Panel
        PlayPSOLATrack                 matlab.ui.control.Button
        TracktoPlayDropDown            matlab.ui.control.DropDown
        TracktoPlayDropDownLabel       matlab.ui.control.Label
        TimeScalingSpinner             matlab.ui.control.Spinner
        TimeScalingSpinnerLabel        matlab.ui.control.Label
        PitchScalingSpinner            matlab.ui.control.Spinner
        PitchScalingSpinnerLabel       matlab.ui.control.Label
        SpectroFreqRangePanel          matlab.ui.container.Panel
        ResolutionEditField            matlab.ui.control.NumericEditField
        ResolutionEditFieldLabel       matlab.ui.control.Label
        EditSpectroSwitch              matlab.ui.control.Switch
        DisplayUpperboundSlider        matlab.ui.control.Slider
        DisplayUpperboundSliderLabel   matlab.ui.control.Label
        DisplayLowerBoundSlider        matlab.ui.control.Slider
        LowerBound                     matlab.ui.control.Spinner
        UpperBound                     matlab.ui.control.Spinner
        DisplayLowerBoundSliderLabel   matlab.ui.control.Label
        ChanneltoLoadButtonGroup       matlab.ui.container.ButtonGroup
        LeftButton                     matlab.ui.control.RadioButton
        RightButton                    matlab.ui.control.RadioButton
        CombinedButton                 matlab.ui.control.RadioButton
        FinalTrackDurationSampleRatePanel  matlab.ui.container.Panel
        SampleRateSelection            matlab.ui.control.DropDown
        SecEditField                   matlab.ui.control.NumericEditField
        SecEditFieldLabel              matlab.ui.control.Label
        MinEditField                   matlab.ui.control.NumericEditField
        MinEditFieldLabel              matlab.ui.control.Label
        RightPanel                     matlab.ui.container.Panel
        LayoutMain                     matlab.ui.container.GridLayout
        PlayHighlightedTrack           matlab.ui.control.Button
        TrackName3                     matlab.ui.control.Label
        TrackName2                     matlab.ui.control.Label
        TrackName1                     matlab.ui.control.Label
        Track3Slider                   matlab.ui.control.Slider
        Track2Slider                   matlab.ui.control.Slider
        Track1Slider                   matlab.ui.control.Slider
        Track3CheckBox                 matlab.ui.control.CheckBox
        Track2CheckBox                 matlab.ui.control.CheckBox
        Track1CheckBox                 matlab.ui.control.CheckBox
        TabGroup                       matlab.ui.container.TabGroup
        ThisisablanktabTab             matlab.ui.container.Tab
        TrimAudioButton                matlab.ui.control.Button
        TrimRangeLabel                 matlab.ui.control.Label
        TrimLower                      matlab.ui.control.Spinner
        TrimUpper                      matlab.ui.control.Spinner
        SwitchtoEditforSpectrogrameditingLabel  matlab.ui.control.Label
        EditTab                        matlab.ui.container.Tab
        TimeRangeLabel                 matlab.ui.control.Label
        TimeLower                      matlab.ui.control.Spinner
        TimeUpper                      matlab.ui.control.Spinner
        FreqRangeLabel                 matlab.ui.control.Label
        FreqLower                      matlab.ui.control.Spinner
        FreqUpper                      matlab.ui.control.Spinner
        FinalTrack                     matlab.ui.control.UIAxes
        Spectrogram                    matlab.ui.control.UIAxes
        Waveform                       matlab.ui.control.UIAxes
        Track1                         matlab.ui.control.UIAxes
        Track2                         matlab.ui.control.UIAxes
        Track3                         matlab.ui.control.UIAxes
        SpectrogramContextMenu         matlab.ui.container.ContextMenu
        ApplyChangesMenu               matlab.ui.container.Menu
        SaveinMenu                     matlab.ui.container.Menu
        SaveToTrack1Menu               matlab.ui.container.Menu
        SaveToTrack2Menu               matlab.ui.container.Menu
        SaveToTrack3Menu               matlab.ui.container.Menu
        SaveToTrack4Menu               matlab.ui.container.Menu
        SaveToTrack5Menu               matlab.ui.container.Menu
        SaveaswavMenu                  matlab.ui.container.Menu
        Track1Menu                     matlab.ui.container.ContextMenu
        Track1Highlight                matlab.ui.container.Menu
        Track1Load                     matlab.ui.container.Menu
        Track1Remove                   matlab.ui.container.Menu
        Crossfadewithtrack2Menu_1      matlab.ui.container.Menu
        Crossfadewithtrack3Menu_1      matlab.ui.container.Menu
        Track2Menu                     matlab.ui.container.ContextMenu
        Track2Highlight                matlab.ui.container.Menu
        Track2Load                     matlab.ui.container.Menu
        Track2Remove                   matlab.ui.container.Menu
        Crossfadewithtrack1Menu_2      matlab.ui.container.Menu
        Crossfadewithtrack3Menu_2      matlab.ui.container.Menu
        Track3Menu                     matlab.ui.container.ContextMenu
        Track3Highlight                matlab.ui.container.Menu
        Track3Load                     matlab.ui.container.Menu
        Track3Remove                   matlab.ui.container.Menu
        Crossfadewithtrack1Menu_3      matlab.ui.container.Menu
        Crossfadewithtrack2Menu_3      matlab.ui.container.Menu
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        trackColour = ['k' 'b' 'r', 'g', 'c'];
        trackNum = 0;
        finalTrackLen = 0; % Length of the final track (in samples, not seconds)
        trackLoaded = [false false false false false]; % Whether a track has been loaded
        trackNames = {'ERROR' 'ERROR' 'ERROR' 'Synth1' 'Synth2'};
        trackLen = [0 0 0 0 0]; % Length of a track (in samples)
        tracksPadded = [];
        highlight; % The audio of the highlighted track
        Fs = 44100; % Sample rate of all tracks

        loadingHighlightedTrack = false;
        spectroTimeRes = 0.1;
        highlightID = 0;

        % Audio player of the highlighted track
        player = audioplayer(zeros(44100, 1), 44100); % The audio player
        playerOffset = 0; % Offset of the current audio player
        highlightLength = -1; % Length of the highlighted track
        highlightOgLength; % A clean copy
        playerPos; % Current position of the audio player (in samples)
        playerPosTracker = timer(); % Timer used to update audio player position on screen
        
        trackIndexForContextMenu = -1 % Description
        editSpectroEnabled = false; % Description
        editingSpectro = false;
        editSpectroBox;

        % Plugins
        notvumPlugin;
        grainPickerPlugin;
        graphicEQPlugin;
        paramEQPlugin;
        looperPlugin;
        offsetAdjustPlugin;
        trackPlayerPlugin;

        EQ;
        paramEQ;

        savedSpectrogram;

        finalTrackCompiled = false;
        finalTrack;

        % User can select tracks to be not included in final track
        includeTrack = [true true true true true];
    end

    properties (Access = public)
        highlightLoaded = false; % Whether a hightlighted track exist
        tracks = cell(5, 1); % The audio of the tracks (not padded)
        trackOffsets = [0 0 0 0 0];

        % Plugins
        graphicEQCreated = false;
        paramEQCreated = false;
        notvumOpened = false;
        grainPickerOpened = false;
        looperOpened = false;
        offsetAdjustOpened = false;
        trackPlayerPluginOpened = false;

        outputDeviceID = -1;
        inputDeviceID = -1;
        currentPosX = [1 1];
        currentPosY = [-1.5 1.5];
        boundingBoxX = [0 0 0 0 0 0 0];
        boundingBoxY = [0 0 0 0 0 0 0];
    end

    methods (Access = public)
        function success = AttemptToOverwriteTrack(app, trackID, name)
            if (app.trackLoaded(trackID) && isequal(questdlg( ...
                strcat('Track ', string(trackID), ' is already loaded, do you want to overwrite it?'), ...
                'Overwrite Confirmation', 'Yes', 'No', 'No'), 'No'))
                success = false;
                return;
            end
            app.LoadTrack(trackID, '/HugoSynthTmp.wav', pwd, string(name));
            success = true;
            app.UpdateFinalTrackPreview();
        end

        function ChangeAudioDevice(app, i, o)
            app.outputDeviceID = o;
            app.inputDeviceID = i;
            app.OutputAudioDeviceIDEditField.Value = o;
        end

        % Create new audio player everytime since currentSample's read-only
        function NewAudioPlayer(app, pos)
            % Update audio player position one last time
            if (app.player ~= false)
                app.UpdatePlayerPosIndicator();
            end
            app.playerPosTracker.stop();
            pause(app.player);

            % Create new audio player and set correct offset from sample 1
            pos = int32(max(0, pos));
            app.playerOffset = pos;

            CheckAudioDevice(app);

            % Creates the new audioplayer
            if (app.notvumOpened && app.notvumPlugin.modulatorLoaded && app.notvumPlugin.sampleLoaded)
                progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Loading synthesised track from Notvum');
                track = app.notvumPlugin.GetCompiledTrack();
                if (size(track, 1) < 1)
                    close(progressBar);
                    return;
                end
                app.player = audioplayer(track(pos+1:app.highlightLength), app.Fs, 24, app.outputDeviceID);
                close(progressBar);
            else
                app.player = audioplayer(app.highlight(pos+1:app.highlightLength), app.Fs, 24, app.outputDeviceID);
            end
            app.player.StartFcn = createCallbackFcn(app, @AudioPlayerStarts, false);
            app.player.StopFcn = createCallbackFcn(app, @AudioPlayerStops, false);
        end

        function UpdateTrackOffset(app, trackID, value)
            % Ignore if it's not loaded yet
            if (~app.trackLoaded(trackID))
                return;
            end
            value = floor(value);
            app.trackOffsets(trackID) = value;
            app.UpdateFinalTrackPreview();
        end
    end
    
    methods (Access = private)
        % Create the timer for tracking current position of audio player
        function CreateTimer(app)
            app.playerPosTracker = timer();
            app.playerPosTracker.Period = 0.5;
            app.playerPosTracker.TasksToExecute = inf;
            app.playerPosTracker.ExecutionMode = "fixedRate";
            app.playerPosTracker.TimerFcn = createCallbackFcn(app, @UpdatePlayerPosIndicator, false);
        end

        function StartDrawingSpectroBoundingBox(app)
            app.UpdateBoundingBox();
            delete(app.editSpectroBox);
            hold(app.Spectrogram, "on");
            app.editSpectroBox = plot(app.Spectrogram, app.boundingBoxX, app.boundingBoxY, "Color", 'y', "LineWidth", 1);
            app.editSpectroBox.XDataSource = "app.boundingBoxX";
            app.editSpectroBox.YDataSource = "app.boundingBoxY";
            hold(app.Spectrogram, "off");
            app.editingSpectro = true;
        end

        function [t1, t2, f1, f2, f3] = UpdateBoundingBox(app)
            % Get the bounding box's x-axis values (time in seconds)
            t1 = app.TimeLower.Value;
            t2 = app.TimeUpper.Value;
            if (t2 < t1)
                t2 = t1;
                app.TimeUpper.Value = t2;
            end

            % Get the bounding box's y-axis values (frequency)
            f1 = app.FreqLower.Value;
            f2 = app.FreqUpper.Value;
            if (f2 < f1)
                f2 = f1 + 1000;
                app.TimeUpper.Value = f2;
            end

            % Center frequency (geometric mean like in Audacity)
            f3 = sqrt(f1 * f2);

            % Update bounding box value for drawing it
            app.boundingBoxX = [t1 t1 t2 t2 t1 t1 t2];
            app.boundingBoxY = [f3 f2 f2 f1 f1 f3 f3];
        end

        % Update sample frequency & maximum frequency that can be captured
        function SetNewFs(app, value)
            app.Fs = value;
            maxFreq = app.Fs / 2;

            % Set the sliders
            app.DisplayUpperboundSlider.Limits = [1 maxFreq];
            app.DisplayUpperboundSlider.MajorTicks = 0:4000:maxFreq;
            app.DisplayUpperboundSlider.MinorTicks = 0:1000:maxFreq;
            app.DisplayUpperboundSlider.Value = maxFreq;
            app.DisplayLowerBoundSlider.Limits = [0 maxFreq-1];
            app.DisplayLowerBoundSlider.MajorTicks = 0:4000:maxFreq;
            app.DisplayLowerBoundSlider.MinorTicks = 0:1000:maxFreq;
            app.DisplayLowerBoundSlider.Value = 0;

            % Set the spinners
            app.UpperBound.Limits = [1 maxFreq];
            app.UpperBound.Value = maxFreq;
            app.LowerBound.Limits = [0 maxFreq-1];
            app.LowerBound.Value = 0;

            % Resize the spectrogram
            app.ResizeSpectrogram();
        end

        % User selects a track to highlight
        function SelectTrackToHighlight(app, trackID)
            if (app.trackLoaded(trackID))
                app.HighlightTrack(trackID);
            else
                uialert(app.HugoSynthUIFigure, 'Cannot highlight selected track', ...
                    'This track is empty');
            end
        end

        % Load a new track at track (trackID)
        function LoadTrack(app, trackID, varargin)
            % load .wav files
            if (nargin < 3)
                [fileName, pathName] = uigetfile('*.wav;*.mp3;*.flac', 'Select the new track');
                overwriteNameNeeded = false;
            else
                fileName = varargin{1};
                pathName = varargin{2};
                overwriteName = varargin{3};
                overwriteNameNeeded = true;
            end

            app.CheckTrackOffsetAdjustPlugin(trackID);

            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                % Read in the audio file
                [trackAudio, trackFs, error] = ReadAudioWithException(app, strcat(pathName, fileName));
                if (error) return; end % Stop loading if the audio file is invalid

                % Surround/stereo to mono
                [~, channelNum] = size(trackAudio);
                if (channelNum > 1)
                    if (app.CombinedButton.Value)
                        trackAudio = mean(trackAudio,2);
                    else
                        channel = 1 + app.RightButton.Value;
                        trackAudio = trackAudio(:, channel);
                    end
                end

                % Warn user for sample rates out of bound
                if (trackFs < 44100) % Reject file with sample rate < 44.1k
                    uialert(app.HugoSynthUIFigure, strcat('Track sample rate (', string(trackFs), ') too low'), ...
                        'Please consider using tracks with at least a sample rate of 44.1k, as human hearing has a range of [20Hz, 20kHz]');
                elseif (trackFs > 192000)
                    uialert(app.HugoSynthUIFigure, strcat('Track sample rate (', string(trackFs), ') too high'), ...
                        'Please consider using tracks with at most a sample rate of 192k, as higher than this is absurd and offers no benefit');
                end

                % Resample the track's audio
                trackAudio = NormAudio(resample(trackAudio, app.Fs, trackFs));
                %trackAudio = myResample(trackAudio, trackFs, app.Fs);

                if (overwriteNameNeeded)
                    app.AddNewTrack(trackAudio, overwriteName, trackID);
                else
                    app.AddNewTrack(trackAudio, fileName, trackID);
                end
            end
        end

        % Add the newly loaded track
        function AddNewTrack(app, trackAudio, fileName, trackID)
            % Initialize all properties of this track
            trackAudioLen = size(trackAudio, 1);
            app.trackLen(trackID) = trackAudioLen;
            app.trackLoaded(trackID) = true;
            app.trackNum = sum(app.trackLoaded);
            app.trackNames{trackID} = fileName;
            app.tracks{trackID} = trackAudio;
            app.trackOffsets(trackID) = 0;
            app.includeTrack(trackID) = true;
            
            % Plot waveform
            app.DrawTrackWaveform(trackAudio, trackAudioLen, trackID, fileName, false);
            
            app.UpdateFinalTrackPreview();
        end

        function DrawTrackWaveform(app, trackAudio, trackAudioLen, trackID, fileName, edited)
            X = 1:trackAudioLen;
            Y = trackAudio;
            switch (trackID)
                case 1
                    trackGraph = app.Track1;
                    name = app.TrackName1.Text;
                    edited = edited & ~contains(name, "[Edited]");
                    if (edited)
                        app.TrackName1.Text = strcat("[Edited] ", name);
                    else
                        app.TrackName1.Text = fileName;
                    end
                    cla(trackGraph);
                    plot(app.Track1, X, Y, "Color", app.trackColour(trackID), "ContextMenu", app.Track1Menu);
                    app.Track1CheckBox.Value = true;
                case 2
                    trackGraph = app.Track2;
                    name = app.TrackName2.Text;
                    edited = edited & ~contains(name, "[Edited]");
                    if (edited)
                        app.TrackName2.Text = strcat("[Edited] ", name);
                    else
                        app.TrackName2.Text = fileName;
                    end
                    cla(trackGraph);
                    plot(app.Track2, X, Y, "Color", app.trackColour(trackID), "ContextMenu", app.Track2Menu);
                    app.Track2CheckBox.Value = true;
                case 3
                    trackGraph = app.Track3;
                    name = app.TrackName3.Text;
                    edited = edited & ~contains(name, "[Edited]");
                    if (edited)
                        app.TrackName3.Text = strcat("[Edited] ", name);
                    else
                        app.TrackName3.Text = fileName;
                    end
                    cla(trackGraph);
                    plot(app.Track3, X, Y, "Color", app.trackColour(trackID), "ContextMenu", app.Track3Menu);
                    app.Track3CheckBox.Value = true;
            end
            if (trackID < 4)
                trackGraph.XLim = [1 trackAudioLen];
                [Ticks, TickLabels] = GenerateTicks(trackAudioLen, app.Fs);
                trackGraph.XTick = Ticks;
                trackGraph.XTickLabel =TickLabels;
            end
        end

        % Remove a loaded track
        function RemoveTrack(app, trackID)
            app.CheckTrackOffsetAdjustPlugin(trackID);

            % Remove track properties
            app.trackLen(trackID) = -1;
            app.trackLoaded(trackID) = false;
            app.trackNum = sum(app.trackLoaded);
            app.trackNames{trackID} = '';
            app.tracks{trackID} = [];
            app.trackOffsets(trackID) = 0;
            
            switch (trackID)
                case 1
                    cla(app.Track1);
                    app.TrackName1.Text = '';
                    app.Track1CheckBox.Value = false;
                case 2
                    cla(app.Track2);
                    app.TrackName2.Text = '';
                    app.Track2CheckBox.Value = false;
                case 3
                    cla(app.Track3);
                    app.TrackName3.Text = '';
                    app.Track3CheckBox.Value = false;
            end

            % Remove highlight properties
            if (trackID == app.highlightID)
                app.highlightLoaded = false;
                app.NewAudioPlayer(0);
                cla(app.Waveform);
                cla(app.Spectrogram);
                app.highlightID = 0;
                app.player = false;
                app.editSpectroEnabled = false;
                app.EditSpectroSwitch.Value = 'View';
                if (app.graphicEQCreated)
                    app.DeleteGraphicEQ();
                end
            end

            if (app.offsetAdjustOpened && app.offsetAdjustPlugin.trackID == trackID)
                app.offsetAdjustOpened = false;
                delete(app.offsetAdjustPlugin);
            end
            
            % Update the final track's preview
            app.UpdateFinalTrackPreview();
        end

        function result = CompileTracks(app)
            result = zeros(app.finalTrackLen, 1);
            overlapDetection = result;
            for i = 1:5
                if (app.trackLoaded(i) && app.includeTrack(i))
                    startPos = app.trackOffsets(i) + 1;
                    endPos = app.trackOffsets(i) + app.trackLen(i);
                    result(startPos:endPos, 1) = result(startPos:endPos, 1) + app.tracks{i};
                    overlapDetection(startPos:endPos, 1) = overlapDetection(startPos:endPos, 1) + 1;
                end
            end
            overlapDetection(overlapDetection < 1) = 1;
            result = NormAudio(result ./ overlapDetection);
            app.finalTrack = result;
            app.finalTrackCompiled = true;
        end

        function UpdateFinalTrackPreview(app)
            app.finalTrackCompiled = false;
            app.finalTrackLen = max(app.trackLen + app.trackOffsets);
            sec = round(app.finalTrackLen / app.Fs);
            min = floor(sec/60);
            app.MinEditField.Value = min;
            app.SecEditField.Value = sec - min * 60;
            
            cla(app.FinalTrack);
            if (app.finalTrackLen > 0)
                hold(app.FinalTrack, "on");
                for i = 1:5
                    if (app.trackLoaded(i))
                        callBackFunc = createCallbackFcn(app, str2func(strcat('Highlight', string(i))), false);
                        yPos = (6 - i) * 2;
                        plot(app.FinalTrack, ...
                            [app.trackOffsets(i) app.trackOffsets(i)+app.trackLen(i)], ...
                            [yPos yPos], "LineWidth", 8, "Color", app.trackColour(i), ...
                            "ButtonDownFcn", callBackFunc);
                    end
                end
                hold(app.FinalTrack, "off");
    
                % Calculate the new limits/ticks/ticklabels for new final track
                Limits = [1 app.finalTrackLen];
                [Ticks, TickLabels] = GenerateTicks(app.finalTrackLen, app.Fs);
    
                % Apply the new limits/ticks/ticklabels to final track display
                % and offset sliders of the tracks
                app.FinalTrack.XLim = Limits;
                app.Track1Slider.Limits = Limits;
                app.Track2Slider.Limits = Limits;
                app.Track3Slider.Limits = Limits;
                xticks(app.FinalTrack, Ticks);
                app.Track1Slider.MajorTicks = Ticks;
                app.Track2Slider.MajorTicks = Ticks;
                app.Track3Slider.MajorTicks = Ticks;
                xticklabels(app.FinalTrack, TickLabels);
                app.Track1Slider.MajorTickLabels = TickLabels;
                app.Track2Slider.MajorTickLabels = TickLabels;
                app.Track3Slider.MajorTickLabels = TickLabels;

                % Update it for the offset adjust plugin
                if (app.offsetAdjustOpened)
                    app.offsetAdjustPlugin.UpdateTicks(Ticks, TickLabels, Limits);
                end
            end
        end
        
        % Highlight a track
        function HighlightTrack(app, trackID)
            if (~app.highlightLoaded)
                app.CreateTimer();
                app.highlightLoaded = true;
            end

            % Return Spectrogram Edit switch and EQ to initial states
            app.EditSpectroSwitch.Value = 'View';
            app.EditSpectroSwitchValueChanged(0);

            % Delete equalizers for previous highlighted track
            app.DeleteGraphicEQ();
            app.DeleteParametricEQ();

            % Initialize the audio player
            app.highlightID = trackID;
            app.highlight = app.tracks{trackID};
            app.highlightLength = length(app.highlight);
            if (app.notvumOpened)
                app.notvumPlugin.ChangeHighlight(app.highlight, app.highlightLength, app.Fs);
            end
            app.NewAudioPlayer(0);

            % Draw waveform diagram and spectrogram for the track
            app.SetupDiagrams(trackID, true);
        end
        
        function AudioPlayerStops(app)
            %app.PlayButton.Value = false;

            % It's a pause if the audioplayer has already played something
            if (app.player.currentSample ~= 1)
                %app.PlayButton.Text = 'Resume';
                app.UpdatePlayerPosIndicator();
                app.playerPosTracker.stop();
            else
                %app.PlayButton.Text = 'Play';
                app.NewAudioPlayer(0);
                app.UpdatePlayerPosIndicator();
            end
        end

        function AudioPlayerStarts(app)
            %app.PlayButton.Value = true;
            %app.PlayButton.Text = 'Playing';

            app.playerPosTracker.start();
        end

        function UpdatePlayerPosIndicator(app)
            current = app.player.CurrentSample + app.playerOffset;
            app.currentPosX = [current current];
            refreshdata(app.playerPos, 'caller');
        end
        
        function SetupDiagrams(app, trackID, recalculate)
            % Set the trim option's value
            lengthInSec = app.highlightLength / app.Fs;
            app.TrimLower.Limits = [0 lengthInSec];
            app.TrimUpper.Limits = [0 lengthInSec];
            app.TrimLower.Value = 0;
            app.TrimUpper.Value = lengthInSec;

            % Clear UIAxes
            cla(app.Waveform);
            cla(app.Spectrogram);

            % Plot waveform
            X = 1:app.highlightLength;
            Y = app.highlight;
            plot(app.Waveform, X, Y, "Color", app.trackColour(trackID), "ButtonDownFcn", ...
                createCallbackFcn(app, @WaveformButtonDown, false));
            app.Waveform.XLim = [1 app.highlightLength];
            [Ticks, TickLabels] = GenerateTicks(app.highlightLength, app.Fs);
            xticks(app.Waveform, Ticks);
            xticklabels(app.Waveform, TickLabels);

            % Plot current position indicator for waveform
            hold(app.Waveform, "on");
            app.playerPos = plot(app.Waveform, app.currentPosX, app.currentPosY, "LineWidth", 2, "Color", 'k');
            app.playerPos.XDataSource = "app.currentPosX";
            app.playerPos.YDataSource = "app.currentPosY";
            hold(app.Waveform, "off");

            if (recalculate)
                [s, f, t] = app.CalculateSpectrogram();
            else
                [s, f, t] = app.savedSpectrogram{1, :};
            end
            app.SetupSpectrogram(s, f, t);
        end

        function [s, f, t] = CalculateSpectrogram(app)
            progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Updating Spectrogram');
            [s, f, t] = pspectrum(app.highlight, app.Fs, "spectrogram", ...
                "TimeResolution", app.spectroTimeRes);
            progressBar.Value = 0.9;
            s = abs(s');
            app.savedSpectrogram = {s, f, t};
            progressBar.Value = 1;
            close(progressBar);
        end

        function SetupSpectrogram(app, s, f, t)
            % Filter out the noise by threholding
            threshold = quantile(s, app.SpectrogramThresholdEditField.Value, 'all');
            s(s < threshold) = 0;
            s = rot90(log(s));

            % Plot Spectrogram
            imagesc(app.Spectrogram, t, flipud(f), s, ContextMenu=app.SpectrogramContextMenu);
            set(app.Spectrogram,'YDir','normal');
            trackLenInSeconds = max(t);
            hfResolution = app.spectroTimeRes / 2;
            app.Spectrogram.XLim = [hfResolution trackLenInSeconds];
            if (trackLenInSeconds > 10)
                xticks(app.Spectrogram, 0:10:trackLenInSeconds);
            else
                xticks(app.Spectrogram, 0:trackLenInSeconds);
            end
            app.ResizeSpectrogram();

            % Don't forget to redraw the bounding box!!!
            if (isequal(app.EditSpectroSwitch.Value, 'Edit'))
                app.StartDrawingSpectroBoundingBox();
            end
        end
        
        function ResizeSpectrogram(app)
            app.Spectrogram.YLim = [app.LowerBound.Value app.UpperBound.Value];
        end

        function ChangeSpectroLowerBound(app, value)
            value = min(value, app.UpperBound.Value - 1);
            app.LowerBound.Value = value;
            app.DisplayLowerBoundSlider.Value = value;
            app.ResizeSpectrogram();
        end

        function ChangeSpectroUpperBound(app, value)
            value = max(value, app.LowerBound.Value + 1);
            app.UpperBound.Value = value;
            app.DisplayUpperboundSlider.Value = value;
            app.ResizeSpectrogram();
        end

        function Highlight1(app); app.HighlightTrack(1); end
        function Highlight2(app); app.HighlightTrack(2); end
        function Highlight3(app); app.HighlightTrack(3); end
        function Highlight4(app); app.HighlightTrack(4); end
        function Highlight5(app); app.HighlightTrack(5); end
        
        function SpectralReduce(app, isDelete)
            % Pause the player so it doesn't get affected by app.highlight changing
            pause(app.player);
            % Fetch current bounding box values
            [t1, t2, f1, f2, f3] = app.UpdateBoundingBox();
            t1 = max(1 + floor(t1 * app.Fs), 1);
            t2 = min(1 + floor(t2 * app.Fs), app.highlightLength);

            % Spectral delete
            % Bandstop/Lowpass/Highpass filter via Signal Processing Toolbox
            if (isDelete)
                if (f1 < 1000)
                    app.highlight(t1:t2, 1) = highpass(app.highlight(t1:t2, 1), f2, app.Fs, ...
                        Steepness=0.99);
                elseif (f2 == app.Fs / 2)
                    app.highlight(t1:t2, 1) = lowpass(app.highlight(t1:t2, 1), f1, app.Fs, ...
                        Steepness=0.99);
                else
                    app.highlight(t1:t2, 1) = bandstop(app.highlight(t1:t2, 1), [f1 f2], app.Fs, ...
                        Steepness=0.99);
                end
            
            % Spectral reduce
            % Notch filter via DSP System Toolbox
            else
                wo = f3 / app.Fs * 2;
                QFactor = f3 / (f2 - f1);
                [b, a] = iirnotch(wo, wo / QFactor);
                app.highlight(t1:t2, 1) = filter(b, a, app.highlight(t1:t2, 1));
            end

            % Update changes
            app.SetupDiagrams(app.highlightID, true);
            app.StartDrawingSpectroBoundingBox();
            app.NewAudioPlayer(0);
        end
        
        function DeleteGraphicEQ(app)
            delete(app.graphicEQPlugin);
            delete(app.EQ);
            app.graphicEQCreated = false;
        end

        function DeleteParametricEQ(app)
            delete(app.paramEQPlugin);
            delete(app.paramEQ);
            app.paramEQCreated = false;
        end

        function CheckTrackOffsetAdjustPlugin(app, trackID)
            if (app.offsetAdjustOpened && app.offsetAdjustPlugin.trackID == trackID)
                app.offsetAdjustOpened = false;
                delete(app.offsetAdjustPlugin);
            end
        end

        function UpdateParametricEQ(app)
            if (app.paramEQCreated)
                [~, ~, f1, f2, f3] = app.UpdateBoundingBox();
                app.paramEQ.Frequencies = f3;
                app.paramEQ.QualityFactors = f3 / (f2 - f1);
            end
        end

        function SaveHighlightedToTrack(app, trackID)
            if (app.highlightLoaded)
                app.tracks{trackID} = app.highlight;
                app.trackLen(trackID) = app.highlightLength;
                app.trackLoaded(trackID) = true;
                app.DrawTrackWaveform(app.highlight, app.highlightLength, trackID, "Saved hightlight track", true);
                app.UpdateFinalTrackPreview();
            end
        end

        function CrossFade(app, trackID1)
            trackID2 = app.trackIndexForContextMenu;
            if (app.trackLoaded(trackID1) && app.trackLoaded(trackID2))
                progressBar = uiprogressdlg(app.HugoSynthUIFigure);

                % Get the length of the two tracks
                trackLen1 = app.trackOffsets(trackID1) + app.trackLen(trackID1);
                trackLen2 = app.trackOffsets(trackID2) + app.trackLen(trackID2);
                trackLenMax = max(trackLen1, trackLen2);

                % Create boolean masks for finding overlap
                track1Boolean = [zeros(1, app.trackOffsets(trackID1)) ones(1, app.trackLen(trackID1)) zeros(1, trackLenMax - trackLen1)];
                track2Boolean = [zeros(1, app.trackOffsets(trackID2)) ones(1, app.trackLen(trackID2)) zeros(1, trackLenMax - trackLen2)];

                % Find the start and end of overlap
                trackOverlap = track1Boolean & track2Boolean;
                overlapStart = find(trackOverlap, 1);
                overlapEnd = find(trackOverlap, 1, 'last');

                % No overlap found
                if (length(overlapStart) + length(overlapEnd) < 2)
                    close(progressBar);
                    uialert(app.HugoSynthUIFigure, 'No overlap detected', 'Cannot perform cross-fade');
                    return;
                end

                % Create the cross-fade windows
                overlapLength = overlapEnd - overlapStart + 1;
                decreasingWindow = linspace(1, 0, overlapLength)';
                increasingWindow = linspace(0, 1, overlapLength)';

                % Track 1 -> Track 2
                if (app.trackOffsets(trackID2) > app.trackOffsets(trackID1))
                    startPos = app.trackLen(trackID1) - overlapLength + 1;
                    app.tracks{trackID1}(startPos:end, 1) = app.tracks{trackID1}( ...
                        startPos:end, 1) .* decreasingWindow;
                    app.tracks{trackID2}(1:overlapLength, 1) = app.tracks{trackID2}( ...
                        1:overlapLength, 1) .* increasingWindow;
 
                % Track 2 -> Track 1
                elseif (app.trackOffsets(trackID2) < app.trackOffsets(trackID1))
                    startPos = app.trackLen(trackID2) - overlapLength + 1;
                    app.tracks{trackID2}(startPos:end, 1) = app.tracks{trackID2}( ...
                        startPos:end, 1) .* decreasingWindow;
                    app.tracks{trackID1}(1:overlapLength, 1) = app.tracks{trackID1}( ...
                        1:overlapLength, 1) .* increasingWindow;

                % Ignore if Track 1 & 2 in parallel
                end

                app.DrawTrackWaveform(app.tracks{trackID1}, app.trackLen(trackID1), trackID1, app.trackNames{trackID1}, true);
                app.DrawTrackWaveform(app.tracks{trackID2}, app.trackLen(trackID2), trackID2, app.trackNames{trackID2}, true);

                close(progressBar);
            else
                uialert(app.HugoSynthUIFigure, 'One of the tracks is empty', 'Cannot perform cross-fade');
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            progressBar = uiprogressdlg(app.HugoSynthUIFigure);
            app.SetNewFs(48000);
            disableDefaultInteractivity(app.Track1);
            disableDefaultInteractivity(app.Track2);
            disableDefaultInteractivity(app.Track3);
            app.playerPos = plot(app.Waveform, app.currentPosX, app.currentPosY, "LineWidth", 2, "Color", 'k');
            app.playerPos.XDataSource = "app.currentPosX";
            app.playerPos.YDataSource = "app.currentPosY";
            %disableDefaultInteractivity(app.FinalTrack);
            close(progressBar);
        end

        % Button down function: Waveform
        function WaveformButtonDown(app, event)
            if (app.highlightLoaded)
                % Get the player's new position selected by the user
                x = app.Waveform.CurrentPoint(1);
                wasPlaying = app.player.isplaying;

                % Create a new player at that position
                app.NewAudioPlayer(x);
                
                % Continue playing
                if (wasPlaying)
                    resume(app.player);
                end
            end
        end

        % Drop down opening function: SampleRateSelection
        function SampleRateSelectionOpening(app, event)
            if (app.trackNum > 0)
                uialert(app.HugoSynthUIFigure, 'Sample rate cannot be changed after loading in tracks', 'Please create a new project');
            end
        end

        % Value changed function: SampleRateSelection
        function SampleRateSelectionValueChanged(app, event)
            value = app.SampleRateSelection.Value;
            if (app.trackNum > 0)
                app.SampleRateSelection.Value = string(app.Fs);
            else
                app.SetNewFs(str2double(value));
            end
        end

        % Callback function: LowerBound, LowerBound
        function LowerBoundValueChanged(app, event)
            app.ChangeSpectroLowerBound(app.LowerBound.Value);
        end

        % Value changed function: DisplayLowerBoundSlider
        function DisplayLowerBoundSliderValueChanged(app, event)
            app.ChangeSpectroLowerBound(app.DisplayLowerBoundSlider.Value);
        end

        % Callback function: UpperBound, UpperBound
        function UpperBoundValueChanged(app, event)
            app.ChangeSpectroUpperBound(app.UpperBound.Value);
        end

        % Callback function: DisplayLowerBoundSlider, 
        % ...and 2 other components
        function UpperSliderValueChanged(app, event)
            app.ChangeSpectroUpperBound(app.DisplayUpperboundSlider.Value);
        end

        % Menu selected function: Track1Highlight
        function Track1HighlightButtonDown(app, event)
            app.SelectTrackToHighlight(1);
        end

        % Menu selected function: Track2Highlight
        function Track2HighlightButtonDown(app, event)
            app.SelectTrackToHighlight(2);
        end

        % Menu selected function: Track3Highlight
        function Track3HighlightButtonDown(app, event)
            app.SelectTrackToHighlight(3);
        end

        % Value changed function: Track1Slider
        function Track1SliderValueChanged(app, event)
            app.UpdateTrackOffset(1, app.Track1Slider.Value);
        end

        % Value changed function: Track2Slider
        function Track2SliderValueChanged(app, event)
            app.UpdateTrackOffset(2, app.Track2Slider.Value);
        end

        % Value changed function: Track3Slider
        function Track3SliderValueChanged(app, event)
            app.UpdateTrackOffset(3, app.Track3Slider.Value);
        end

        % Menu selected function: Track1Load, Track2Load, Track3Load
        function TrackLoadMenuSelected(app, event)
            if (app.trackLoaded(app.trackIndexForContextMenu) && isequal(questdlg( ...
                'This track is already loaded, do you want to overwrite it?', ...
                'Overwrite Confirmation', 'Yes', 'No', 'No'), 'No'))
                return;
            end
            app.LoadTrack(app.trackIndexForContextMenu);
        end

        % Context menu opening function: Track1Menu
        function Track1MenuContextMenuOpening(app, event)
            app.trackIndexForContextMenu = 1;
        end

        % Context menu opening function: Track2Menu
        function Track2MenuContextMenuOpening(app, event)
            app.trackIndexForContextMenu = 2;
        end

        % Context menu opening function: Track3Menu
        function Track3MenuContextMenuOpening(app, event)
            app.trackIndexForContextMenu = 3;
        end

        % Menu selected function: Track4Menu
        function Track4MenuSelected(app, event)
            app.trackIndexForContextMenu = 4;
        end

        % Menu selected function: Track5Menu
        function Track5MenuSelected(app, event)
            app.trackIndexForContextMenu = 5;
        end

        % Menu selected function: RemoveTrack4Menu, Track1Remove, 
        % ...and 2 other components
        function TrackRemoveMenuSelected(app, event)
            if (~app.trackLoaded(app.trackIndexForContextMenu))
                uialert(app.HugoSynthUIFigure, 'This track cannot be removed', 'This track is already empty');
                return;
            end
            app.RemoveTrack(app.trackIndexForContextMenu);
        end

        % Value changed function: OutputAudioDeviceIDEditField
        function OutputDeviceIDSpinnerValueChanged(app, event)
            value = max(floor(app.OutputAudioDeviceIDEditField.Value), -1);
            % Detect if the earphone bug is there...
            if (audiodevinfo(0, value, 44100, 24, 1))
                app.outputDeviceID = value;
            else
                uialert(app.HugoSynthUIFigure, ['The selected audio device does not support audio ' ...
                    'playback at a sample rate of 44.1k!'], 'Audio device is unusable');
            end
        end

        % Value changed function: ResolutionEditField
        function ResolutionEditFieldValueChanged(app, event)
            value = app.ResolutionEditField.Value;
            app.spectroTimeRes = round(value, 2);
            [s, f, t] = app.CalculateSpectrogram();
            app.SetupSpectrogram(s, f, t);
        end

        % Value changed function: EditSpectroSwitch
        function EditSpectroSwitchValueChanged(app, event)
            value = app.EditSpectroSwitch.Value;
            if (app.highlightLoaded)
                if (isequal(value, 'Edit'))
                    app.editSpectroEnabled = true;
                    app.TabGroup.SelectedTab = app.EditTab;
                else
                    app.editSpectroEnabled = false;
                    app.TabGroup.SelectedTab = app.ThisisablanktabTab;
                    delete(app.editSpectroBox);
                end
                app.TabGroupSelectionChanged(0);
            else
                app.EditSpectroSwitch.Value = 'View';
                uialert(app.HugoSynthUIFigure, 'Cannot edit spectrogram if it does not exist?', 'Please highlight a track first')
            end
        end

        % Callback function: FreqLower, FreqLower, FreqUpper, FreqUpper, 
        % ...and 4 other components
        function SpectrogramEditBoxValueChanged(app, event)
            app.UpdateBoundingBox();
            refreshdata(app.editSpectroBox, 'caller');
            app.UpdateParametricEQ();
        end

        % Selection change function: TabGroup
        function TabGroupSelectionChanged(app, event)
            selectedTab = app.TabGroup.SelectedTab;
            if (selectedTab == app.EditTab)
                if (app.editSpectroEnabled)
                    lengthInSec = app.highlightLength / app.Fs;
                    maxFreq = floor(app.Fs / 2);
                    app.TimeLower.Limits = [0 lengthInSec];
                    app.TimeUpper.Limits = [0 lengthInSec];
                    app.FreqLower.Limits = [0 maxFreq];
                    app.FreqUpper.Limits = [0 maxFreq];
                    app.TimeLower.Value = 0;
                    app.TimeUpper.Value = lengthInSec;
                    app.FreqLower.Value = 10000;
                    app.FreqUpper.Value = 20000;
                    app.StartDrawingSpectroBoundingBox();
                else
                    app.TabGroup.SelectedTab = app.ThisisablanktabTab;
                end
            elseif (app.editSpectroEnabled)
                app.TabGroup.SelectedTab = app.EditTab;
            end
        end

        % Menu selected function: SpectralDeleteMenu
        function SpectralDeleteButtonPushed(app, event)
            app.SpectralReduce(true);
        end

        % Menu selected function: SpectralReduceMenu
        function SpectralReduceButtonPushed(app, event)
            app.SpectralReduce(false);
        end

        % Value changed function: SpectrogramThresholdEditField
        function SpectrogramThresholdEditFieldValueChanged(app, event)
            if (app.highlightLoaded)
                app.SetupDiagrams(app.highlightID, false);
                if (isequal(app.EditSpectroSwitch.Value, 'Edit'))
                    app.StartDrawingSpectroBoundingBox();
                end
            end
        end

        % Button pushed function: TrimAudioButton
        function TrimAudioButtonPushed(app, event)
            if (app.highlightLoaded)
                % Read user-entered values
                t1 = app.TrimLower.Value;
                t2 = app.TrimUpper.Value;
                if (t2 < t1)
                    t2 = t1 + 0.1;
                    app.TrimUpper.Value = t2;
                end

                % Convert unit from seconds to samples
                t1 = max(1 + floor(t1 * app.Fs), 1);
                t2 = min(1 + floor(t2 * app.Fs), app.highlightLength);

                % Update
                app.highlight = app.highlight(t1:t2, 1);
                app.highlightLength = size(app.highlight, 1);
                app.SetupDiagrams(app.highlightID, true);
                app.StartDrawingSpectroBoundingBox();
            end
        end

        % Button pushed function: PlayHighlightedTrack
        function PlayHighlightedTrackButtonPushed(app, event)
            if (app.highlightLoaded)
                if (app.player.isplaying())
                    pause(app.player);
                else
                    resume(app.player);
                end
            else
                uialert(app.HugoSynthUIFigure, 'No track highlighted', 'Select a track to play');
            end
        end

        % Menu selected function: NotvumMenu
        function PluginNotvumMenuSelected(app, event)
            if (app.notvumOpened)
                uialert(app.HugoSynthUIFigure, 'Plugin already opened', 'The synthesis plugin is running');
            else
                progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Opening Notvum Plugin');
                app.notvumPlugin = Notvum(app, app.Fs, 3);
                close(progressBar);
            end
            if (app.highlightLoaded)
                app.notvumPlugin.ChangeHighlight(app.highlight, app.highlightLength, app.Fs);
            end
        end

        % Menu selected function: LooperMenu
        function PluginLooperMenuSelected(app, event)
            if (app.looperOpened)
                uialert(app.HugoSynthUIFigure, 'Plugin already opened', 'The looper plugin is running');
            else
                progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Opening Looper Plugin');
                app.looperPlugin = Looper(app, app.Fs, 3);
                close(progressBar);
            end
        end

        % Menu selected function: GrainPickerMenu
        function PluginGrainPickerMenuSelected(app, event)
            if (app.grainPickerOpened)
                uialert(app.HugoSynthUIFigure, 'Plugin already opened', 'The grain picker plugin is running');
            else
                % Use this for channel instead of 3 if we want it to change dynamically
                % 1+app.RightButton.Value+3*app.CombinedButton.Value
                progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Opening Grain Picker Plugin');
                app.grainPickerPlugin = GrainPicker(app, app.Fs, 3);
                close(progressBar);
            end
        end

        % Menu selected function: AdjustTrack4OffsetMenu, 
        % ...and 1 other component
        function PluginTrackOffsetMenuSelected(app, event)
            trackID = app.trackIndexForContextMenu;
            if (app.trackLoaded(trackID))
                delete(app.offsetAdjustPlugin);
                progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Opening Offset Adjuster Plugin');
                app.offsetAdjustPlugin = TrackOffsetAdjust(app, trackID);
                close(progressBar);
                app.UpdateFinalTrackPreview();
            else
                uialert(app.HugoSynthUIFigure, 'Plugin cannot be opened', 'The track is empty');
            end
        end

        % Button pushed function: PlayPSOLATrack
        function PlayPSOLATrackButtonPushed(app, event)
            trackChoice = int32(app.TracktoPlayDropDown.Value);
            if (trackChoice > 0 && app.trackLoaded(trackChoice))
                track = app.tracks{trackChoice};
                trackName = app.trackNames{trackChoice};
            elseif (app.trackNum > 0)
                track = app.CompileTracks();
                if (sum(track, "all") == 0)
                    return;
                end
                trackName = "Final Track";
            else
                return;
            end
            progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message='Opening Track Player Plugin');
            delete(app.trackPlayerPlugin);
            alpha = app.TimeScalingSpinner.Value;
            beta = app.PitchScalingSpinner.Value;
            if ((abs(alpha - 1) + abs(beta - 1)) > 0.1)
                track = psola(track, PitchMarker(track), alpha, beta);
            end
            app.trackPlayerPlugin = TrackPlayer(app, track, trackName, app.Fs);
            close(progressBar);
        end

        % Menu selected function: ApplyEQtoTrackMenu
        function ApplyEQMenuSelected(app, event)
            if (app.highlightLoaded && app.graphicEQCreated)
                app.highlight = app.EQ(app.highlight);
                app.NewAudioPlayer(0);
                app.DeleteGraphicEQ();
                app.SetupDiagrams(app.highlightID, true);
            else
                uialert(app.HugoSynthUIFigure, 'No graphic EQ opened or no track highlighted', 'Cannot apply graphic EQ');
            end
        end

        % Menu selected function: OpenEQforTrackMenu
        function GraphicEQMenuSelected(app, event)
            if (app.highlightLoaded)
                if (~app.graphicEQCreated)
                    app.EQ = graphicEQ('SampleRate', app.Fs);
                    app.graphicEQCreated = true;
                end
                app.graphicEQPlugin = parameterTuner(app.EQ);
                app.graphicEQPlugin.Name = "Graphic EQ for selected track";
            else
                uialert(app.HugoSynthUIFigure, 'Please highlight a track first', 'Cannot create graphic EQ');
            end
        end

        % Menu selected function: SpectralEditingMenu
        function SpectralEditingMenuSelected(app, event)
            if (~isequal(app.EditSpectroSwitch.Value, 'Edit'))
                uialert(app.HugoSynthUIFigure, 'Please switch on spectrogram edit mode first', 'Cannot access spectral edit menu');
            end
        end

        % Menu selected function: OpenParametricEQMenu
        function OpenParametricEQMenuSelected(app, event)
            if (isequal(app.EditSpectroSwitch.Value, 'Edit'))
                if (~app.paramEQCreated)
                    app.paramEQ = multibandParametricEQ('NumEQBands', 1, 'SampleRate', app.Fs);
                    app.paramEQCreated = true;
                end
                app.UpdateParametricEQ();
                app.paramEQPlugin = parameterTuner(app.paramEQ);
                app.paramEQPlugin.Name = "Parametric EQ for selected frequency band";
            else
                uialert(app.HugoSynthUIFigure, 'Please highlight a track first', 'Cannot create parametric EQ');
            end
        end

        % Menu selected function: ApplytoSelectedMenu
        function ApplytoSelectedMenuSelected(app, event)
            if (isequal(app.EditSpectroSwitch.Value, 'Edit') && app.paramEQCreated)
                [t1, t2, ~, ~] = app.UpdateBoundingBox();
                t1 = max(1 + floor(t1 * app.Fs), 1);
                t2 = min(1 + floor(t2 * app.Fs), app.highlightLength);
                app.highlight(t1:t2, 1) = app.paramEQ(app.highlight(t1:t2, 1));
                app.highlight = app.paramEQ(app.highlight);
                app.NewAudioPlayer(0);
                app.DeleteParametricEQ();
                app.SetupDiagrams(app.highlightID, true);
            else
                uialert(app.HugoSynthUIFigure, 'No parametric EQ opened or spectrogram edit mode not switched on', 'Cannot apply parametric EQ');
            end
        end

        % Menu selected function: ApplyChangesMenu
        function ApplyChangesMenuSelected(app, event)
            if (app.highlightLoaded)
                app.tracks{app.highlightID} = app.highlight;
                app.trackLen(app.highlightID) = app.highlightLength;
                app.trackLoaded(app.highlightID) = true;
                app.DrawTrackWaveform(app.highlight, app.highlightLength, app.highlightID, app.trackNames{app.highlightID}, true);
                app.UpdateFinalTrackPreview();
            end
        end

        % Menu selected function: SaveToTrack1Menu
        function SaveToTrack1MenuSelected(app, event)
            app.SaveHighlightedToTrack(1);
        end

        % Menu selected function: SaveToTrack2Menu
        function SaveToTrack2MenuSelected(app, event)
            app.SaveHighlightedToTrack(2);
        end

        % Menu selected function: SaveToTrack3Menu
        function SaveToTrack3MenuSelected(app, event)
            app.SaveHighlightedToTrack(3);
        end

        % Menu selected function: SaveToTrack4Menu
        function SaveToTrack4MenuSelected(app, event)
            app.SaveHighlightedToTrack(4);
        end

        % Menu selected function: SaveToTrack5Menu
        function SaveToTrack5MenuSelected(app, event)
            app.SaveHighlightedToTrack(5);
        end

        % Menu selected function: SaveaswavMenu
        function SaveHighlightedTrackMenuSelected(app, event)
            [fileName, pathName] = uiputfile('*.wav', 'Save current highlighted track');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                audiowrite(strcat(pathName, fileName), app.highlight, app.Fs, "Artist", "HugoSynth");
            end
        end

        % Close request function: HugoSynthUIFigure
        function HugoSynthUIFigureCloseRequest(app, event)
            tmpName = strcat(pwd, '/HugoSynthTmp.wav');
            if (isfile(tmpName))
                delete(tmpName);
            end

            delete(app.notvumPlugin);
            delete(app.grainPickerPlugin);
            delete(app.looperPlugin);
            delete(app.graphicEQPlugin);
            delete(app.paramEQPlugin);
            delete(app.offsetAdjustPlugin);
            delete(app.trackPlayerPlugin);

            delete(app);
        end

        % Button pushed function: CompileSynth
        function CompileSynthButtonPushed(app, event)
            modID = app.ModulatorSpinner.Value;
            carID = app.CarrierSpinner.Value;
            if (app.trackLoaded(modID) && app.trackLoaded(carID))
                if (app.CrossConvSwitch.Value == 0)
                    msg = 'Performing cross-synthesis';
                    trackName = "Quick Cross-Synth Result";
                    isCrossSynth = true;
                    disp(msg);
                else
                    msg = 'Performing convolution';
                    trackName = "Quick Convolution Result";
                    isCrossSynth = false;
                    disp(msg);
                end

                progressBar = uiprogressdlg(app.HugoSynthUIFigure, Message=msg);
                saveID = app.SaveinSpinner.Value;
                modOffset = app.trackOffsets(modID);
                carOffset = app.trackOffsets(carID);
                modLen = app.trackLen(modID);
                carLen = app.trackLen(carID);
                modulator = [zeros(modOffset, 1); app.tracks{modID}];
                diff = (modLen + modOffset) - (carLen + carOffset);
                if (diff > 0)
                    carrier = [zeros(carOffset, 1); app.tracks{carID}; zeros(diff, 1)];
                else
                    carrier = [zeros(carOffset, 1); app.tracks{carID}];
                end

                progressBar.Value = 0.2;
                modulator = modulator((modOffset + 1):(modOffset + modLen), 1);
                carrier = carrier((modOffset + 1):(modOffset + modLen), 1);
                tmpName = strcat(pwd, '/HugoSynthTmp.wav');
                progressBar.Value = 0.3;

                if (isCrossSynth)
                    order1 = app.Order1.Value;
                    order2 = app.Order2.Value;
                    wSize = app.WindowSize.Value;
                    hSize = app.HopSize.Value;
                    if (app.CrossSynthVersionDropDown.Value == 0)
                        track = CrossSynth(modulator, order1, carrier, order2, app.Fs, 'none', 0, 'scal', 'vocode', wSize, hSize);
                    else
                        track = CrossSynth(modulator, order1, carrier, order2, app.Fs, 'none', 0, 'scal');
                    end
                else
                    track = NormAudio(MyConv(modulator, carrier, modLen, modLen));
                end

                progressBar.Value = 0.8;
                audiowrite(tmpName, track, app.Fs, "Artist", "HugoSynth");
                close(progressBar);
                if (app.AttemptToOverwriteTrack(saveID, trackName))
                    app.trackOffsets(saveID) = modOffset;
                    app.UpdateFinalTrackPreview();
                end
            end

        end

        % Value changed function: Order1
        function Order1ValueChanged(app, event)
            value = app.Order1.Value;
            carrierVal = app.Order2.Value;
            if (value > carrierVal)
                app.Order1.Value = carrierVal;
            end
        end

        % Value changed function: Order2
        function Order2ValueChanged(app, event)
            value = app.Order2.Value;
            modulatorVal = app.Order1.Value;
            if (value < modulatorVal)
                app.Order2.Value = modulatorVal;
            end
        end

        % Value changed function: HopSize
        function HopSizeValueChanged(app, event)
            value = app.HopSize.Value;
            windowSize = app.WindowSize.Value;
            if (value > windowSize)
                app.HopSize.Value = windowSize;
            end
        end

        % Value changed function: WindowSize
        function WindowSizeValueChanged(app, event)
            value = app.WindowSize.Value;
            hopSize = app.HopSize.Value;
            if (value < hopSize)
                app.WindowSize = hopSize;
            end
        end

        % Value changed function: Track1CheckBox
        function Track1CheckBoxValueChanged(app, event)
            value = app.Track1CheckBox.Value;
            app.includeTrack(1) = value;
        end

        % Value changed function: Track2CheckBox
        function Track2CheckBoxValueChanged(app, event)
            value = app.Track2CheckBox.Value;
            app.includeTrack(2) = value;
        end

        % Value changed function: Track3CheckBox
        function Track3CheckBoxValueChanged(app, event)
            value = app.Track3CheckBox.Value;
            app.includeTrack(3) = value;
        end

        % Menu selected function: Crossfadewithtrack1Menu_2, 
        % ...and 1 other component
        function CrossFadewithTrack1(app, event)
            app.CrossFade(1);
        end

        % Menu selected function: Crossfadewithtrack2Menu_1, 
        % ...and 1 other component
        function CrossFadewithTrack2(app, event)
            app.CrossFade(2);
        end

        % Menu selected function: Crossfadewithtrack3Menu_1, 
        % ...and 1 other component
        function CrossFadewithTrack3(app, event)
            app.CrossFade(3);
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.HugoSynthUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {663, 663};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create HugoSynthUIFigure and hide until all components are created
            app.HugoSynthUIFigure = uifigure('Visible', 'off');
            app.HugoSynthUIFigure.AutoResizeChildren = 'off';
            app.HugoSynthUIFigure.Position = [100 100 1078 663];
            app.HugoSynthUIFigure.Name = 'Hugo Synth';
            app.HugoSynthUIFigure.CloseRequestFcn = createCallbackFcn(app, @HugoSynthUIFigureCloseRequest, true);
            app.HugoSynthUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create SynthonlyTracksMenu
            app.SynthonlyTracksMenu = uimenu(app.HugoSynthUIFigure);
            app.SynthonlyTracksMenu.Text = 'Synth-only Tracks';

            % Create Track4Menu
            app.Track4Menu = uimenu(app.SynthonlyTracksMenu);
            app.Track4Menu.MenuSelectedFcn = createCallbackFcn(app, @Track4MenuSelected, true);
            app.Track4Menu.Text = 'Track 4';

            % Create RemoveTrack4Menu
            app.RemoveTrack4Menu = uimenu(app.Track4Menu);
            app.RemoveTrack4Menu.MenuSelectedFcn = createCallbackFcn(app, @TrackRemoveMenuSelected, true);
            app.RemoveTrack4Menu.Text = 'Remove Track 4';

            % Create AdjustTrack4OffsetMenu
            app.AdjustTrack4OffsetMenu = uimenu(app.Track4Menu);
            app.AdjustTrack4OffsetMenu.MenuSelectedFcn = createCallbackFcn(app, @PluginTrackOffsetMenuSelected, true);
            app.AdjustTrack4OffsetMenu.Text = 'Adjust Track 4 Offset';

            % Create Track5Menu
            app.Track5Menu = uimenu(app.SynthonlyTracksMenu);
            app.Track5Menu.MenuSelectedFcn = createCallbackFcn(app, @Track5MenuSelected, true);
            app.Track5Menu.Text = 'Track 5';

            % Create RemoveTrack5Menu
            app.RemoveTrack5Menu = uimenu(app.Track5Menu);
            app.RemoveTrack5Menu.Text = 'Remove Track 5';

            % Create AdjustTrack5OffsetMenu
            app.AdjustTrack5OffsetMenu = uimenu(app.Track5Menu);
            app.AdjustTrack5OffsetMenu.MenuSelectedFcn = createCallbackFcn(app, @PluginTrackOffsetMenuSelected, true);
            app.AdjustTrack5OffsetMenu.Text = 'Adjust Track 5 Offset';

            % Create SpectralEditingMenu
            app.SpectralEditingMenu = uimenu(app.HugoSynthUIFigure);
            app.SpectralEditingMenu.MenuSelectedFcn = createCallbackFcn(app, @SpectralEditingMenuSelected, true);
            app.SpectralEditingMenu.Text = 'Spectral Editing';

            % Create SpectralDeleteMenu
            app.SpectralDeleteMenu = uimenu(app.SpectralEditingMenu);
            app.SpectralDeleteMenu.MenuSelectedFcn = createCallbackFcn(app, @SpectralDeleteButtonPushed, true);
            app.SpectralDeleteMenu.Text = 'Spectral Delete';

            % Create SpectralReduceMenu
            app.SpectralReduceMenu = uimenu(app.SpectralEditingMenu);
            app.SpectralReduceMenu.MenuSelectedFcn = createCallbackFcn(app, @SpectralReduceButtonPushed, true);
            app.SpectralReduceMenu.Text = 'Spectral Reduce';

            % Create ParametricEQMenu
            app.ParametricEQMenu = uimenu(app.SpectralEditingMenu);
            app.ParametricEQMenu.Text = 'Parametric EQ';

            % Create OpenParametricEQMenu
            app.OpenParametricEQMenu = uimenu(app.ParametricEQMenu);
            app.OpenParametricEQMenu.MenuSelectedFcn = createCallbackFcn(app, @OpenParametricEQMenuSelected, true);
            app.OpenParametricEQMenu.Text = 'Open Parametric EQ';

            % Create ApplytoSelectedMenu
            app.ApplytoSelectedMenu = uimenu(app.ParametricEQMenu);
            app.ApplytoSelectedMenu.MenuSelectedFcn = createCallbackFcn(app, @ApplytoSelectedMenuSelected, true);
            app.ApplytoSelectedMenu.Text = 'Apply to Selected';

            % Create GraphicEQ
            app.GraphicEQ = uimenu(app.HugoSynthUIFigure);
            app.GraphicEQ.Text = 'Graphic EQ';

            % Create OpenEQforTrackMenu
            app.OpenEQforTrackMenu = uimenu(app.GraphicEQ);
            app.OpenEQforTrackMenu.MenuSelectedFcn = createCallbackFcn(app, @GraphicEQMenuSelected, true);
            app.OpenEQforTrackMenu.Text = 'Open EQ for Track';

            % Create ApplyEQtoTrackMenu
            app.ApplyEQtoTrackMenu = uimenu(app.GraphicEQ);
            app.ApplyEQtoTrackMenu.MenuSelectedFcn = createCallbackFcn(app, @ApplyEQMenuSelected, true);
            app.ApplyEQtoTrackMenu.Text = 'Apply EQ to Track';

            % Create PluginsMenu
            app.PluginsMenu = uimenu(app.HugoSynthUIFigure);
            app.PluginsMenu.Text = 'Plugins';

            % Create GrainPickerMenu
            app.GrainPickerMenu = uimenu(app.PluginsMenu);
            app.GrainPickerMenu.MenuSelectedFcn = createCallbackFcn(app, @PluginGrainPickerMenuSelected, true);
            app.GrainPickerMenu.Text = 'Grain Picker';

            % Create LooperMenu
            app.LooperMenu = uimenu(app.PluginsMenu);
            app.LooperMenu.MenuSelectedFcn = createCallbackFcn(app, @PluginLooperMenuSelected, true);
            app.LooperMenu.Text = 'Looper';

            % Create NotvumMenu
            app.NotvumMenu = uimenu(app.PluginsMenu);
            app.NotvumMenu.MenuSelectedFcn = createCallbackFcn(app, @PluginNotvumMenuSelected, true);
            app.NotvumMenu.Text = 'Notvum';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.HugoSynthUIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create FinalTrackDurationSampleRatePanel
            app.FinalTrackDurationSampleRatePanel = uipanel(app.LeftPanel);
            app.FinalTrackDurationSampleRatePanel.Title = 'Final Track Duration / Sample Rate';
            app.FinalTrackDurationSampleRatePanel.Position = [0 1 220 51];

            % Create MinEditFieldLabel
            app.MinEditFieldLabel = uilabel(app.FinalTrackDurationSampleRatePanel);
            app.MinEditFieldLabel.HorizontalAlignment = 'center';
            app.MinEditFieldLabel.Position = [35 5 25 22];
            app.MinEditFieldLabel.Text = 'Min';

            % Create MinEditField
            app.MinEditField = uieditfield(app.FinalTrackDurationSampleRatePanel, 'numeric');
            app.MinEditField.Limits = [0 30];
            app.MinEditField.RoundFractionalValues = 'on';
            app.MinEditField.ValueDisplayFormat = '%d';
            app.MinEditField.Editable = 'off';
            app.MinEditField.HorizontalAlignment = 'center';
            app.MinEditField.Position = [5 5 28 22];

            % Create SecEditFieldLabel
            app.SecEditFieldLabel = uilabel(app.FinalTrackDurationSampleRatePanel);
            app.SecEditFieldLabel.HorizontalAlignment = 'center';
            app.SecEditFieldLabel.Position = [91 5 26 22];
            app.SecEditFieldLabel.Text = 'Sec';

            % Create SecEditField
            app.SecEditField = uieditfield(app.FinalTrackDurationSampleRatePanel, 'numeric');
            app.SecEditField.Limits = [0 59];
            app.SecEditField.RoundFractionalValues = 'on';
            app.SecEditField.ValueDisplayFormat = '%d';
            app.SecEditField.Editable = 'off';
            app.SecEditField.HorizontalAlignment = 'center';
            app.SecEditField.Position = [61 5 28 22];

            % Create SampleRateSelection
            app.SampleRateSelection = uidropdown(app.FinalTrackDurationSampleRatePanel);
            app.SampleRateSelection.Items = {'44.1k', '48k', '88.2k', '96k', '176.4k', '192k'};
            app.SampleRateSelection.ItemsData = {'44100', '48000', '88200', '96000', '176400', '192000'};
            app.SampleRateSelection.DropDownOpeningFcn = createCallbackFcn(app, @SampleRateSelectionOpening, true);
            app.SampleRateSelection.ValueChangedFcn = createCallbackFcn(app, @SampleRateSelectionValueChanged, true);
            app.SampleRateSelection.Position = [122 5 85 22];
            app.SampleRateSelection.Value = '48000';

            % Create ChanneltoLoadButtonGroup
            app.ChanneltoLoadButtonGroup = uibuttongroup(app.LeftPanel);
            app.ChanneltoLoadButtonGroup.Title = 'Channel to Load';
            app.ChanneltoLoadButtonGroup.Position = [0 51 220 48];

            % Create CombinedButton
            app.CombinedButton = uiradiobutton(app.ChanneltoLoadButtonGroup);
            app.CombinedButton.Text = 'Combined';
            app.CombinedButton.Position = [10 2 78 22];
            app.CombinedButton.Value = true;

            % Create RightButton
            app.RightButton = uiradiobutton(app.ChanneltoLoadButtonGroup);
            app.RightButton.Text = 'Right';
            app.RightButton.Position = [135 2 50 22];

            % Create LeftButton
            app.LeftButton = uiradiobutton(app.ChanneltoLoadButtonGroup);
            app.LeftButton.Text = 'Left';
            app.LeftButton.Position = [91 2 42 22];

            % Create SpectroFreqRangePanel
            app.SpectroFreqRangePanel = uipanel(app.LeftPanel);
            app.SpectroFreqRangePanel.Title = 'Spectrogram';
            app.SpectroFreqRangePanel.Position = [0 511 220 151];

            % Create DisplayLowerBoundSliderLabel
            app.DisplayLowerBoundSliderLabel = uilabel(app.SpectroFreqRangePanel);
            app.DisplayLowerBoundSliderLabel.Position = [5 60 117 22];
            app.DisplayLowerBoundSliderLabel.Text = 'Display LowerBound';

            % Create UpperBound
            app.UpperBound = uispinner(app.SpectroFreqRangePanel);
            app.UpperBound.Step = 1000;
            app.UpperBound.ValueChangingFcn = createCallbackFcn(app, @UpperBoundValueChanged, true);
            app.UpperBound.Limits = [0 24000];
            app.UpperBound.RoundFractionalValues = 'on';
            app.UpperBound.ValueDisplayFormat = '%dHz';
            app.UpperBound.ValueChangedFcn = createCallbackFcn(app, @UpperBoundValueChanged, true);
            app.UpperBound.HorizontalAlignment = 'left';
            app.UpperBound.Position = [132 105 81 22];
            app.UpperBound.Value = 24000;

            % Create LowerBound
            app.LowerBound = uispinner(app.SpectroFreqRangePanel);
            app.LowerBound.Step = 1000;
            app.LowerBound.ValueChangingFcn = createCallbackFcn(app, @LowerBoundValueChanged, true);
            app.LowerBound.Limits = [0 24000];
            app.LowerBound.RoundFractionalValues = 'on';
            app.LowerBound.ValueDisplayFormat = '%dHz';
            app.LowerBound.ValueChangedFcn = createCallbackFcn(app, @LowerBoundValueChanged, true);
            app.LowerBound.HorizontalAlignment = 'left';
            app.LowerBound.Position = [132 60 81 22];

            % Create DisplayLowerBoundSlider
            app.DisplayLowerBoundSlider = uislider(app.SpectroFreqRangePanel);
            app.DisplayLowerBoundSlider.MajorTickLabels = {''};
            app.DisplayLowerBoundSlider.ValueChangedFcn = createCallbackFcn(app, @DisplayLowerBoundSliderValueChanged, true);
            app.DisplayLowerBoundSlider.ValueChangingFcn = createCallbackFcn(app, @UpperSliderValueChanged, true);
            app.DisplayLowerBoundSlider.Position = [6 51 194 3];

            % Create DisplayUpperboundSliderLabel
            app.DisplayUpperboundSliderLabel = uilabel(app.SpectroFreqRangePanel);
            app.DisplayUpperboundSliderLabel.Position = [6 105 116 22];
            app.DisplayUpperboundSliderLabel.Text = 'Display Upperbound';

            % Create DisplayUpperboundSlider
            app.DisplayUpperboundSlider = uislider(app.SpectroFreqRangePanel);
            app.DisplayUpperboundSlider.MajorTickLabels = {''};
            app.DisplayUpperboundSlider.ValueChangedFcn = createCallbackFcn(app, @UpperSliderValueChanged, true);
            app.DisplayUpperboundSlider.ValueChangingFcn = createCallbackFcn(app, @UpperSliderValueChanged, true);
            app.DisplayUpperboundSlider.Position = [6 97 197 3];

            % Create EditSpectroSwitch
            app.EditSpectroSwitch = uiswitch(app.SpectroFreqRangePanel, 'slider');
            app.EditSpectroSwitch.Items = {'View', 'Edit'};
            app.EditSpectroSwitch.ValueChangedFcn = createCallbackFcn(app, @EditSpectroSwitchValueChanged, true);
            app.EditSpectroSwitch.Position = [142 9 45 20];
            app.EditSpectroSwitch.Value = 'View';

            % Create ResolutionEditFieldLabel
            app.ResolutionEditFieldLabel = uilabel(app.SpectroFreqRangePanel);
            app.ResolutionEditFieldLabel.Position = [5 8 62 22];
            app.ResolutionEditFieldLabel.Text = 'Resolution';

            % Create ResolutionEditField
            app.ResolutionEditField = uieditfield(app.SpectroFreqRangePanel, 'numeric');
            app.ResolutionEditField.Limits = [0.01 1];
            app.ResolutionEditField.ValueDisplayFormat = '%.2fs';
            app.ResolutionEditField.ValueChangedFcn = createCallbackFcn(app, @ResolutionEditFieldValueChanged, true);
            app.ResolutionEditField.HorizontalAlignment = 'center';
            app.ResolutionEditField.Position = [65 8 43 22];
            app.ResolutionEditField.Value = 0.5;

            % Create TrackPlaybackControlPanel
            app.TrackPlaybackControlPanel = uipanel(app.LeftPanel);
            app.TrackPlaybackControlPanel.Title = 'Track Playback Control';
            app.TrackPlaybackControlPanel.Position = [1 404 220 107];

            % Create PitchScalingSpinnerLabel
            app.PitchScalingSpinnerLabel = uilabel(app.TrackPlaybackControlPanel);
            app.PitchScalingSpinnerLabel.Position = [5 62 76 22];
            app.PitchScalingSpinnerLabel.Text = 'Pitch Scaling';

            % Create PitchScalingSpinner
            app.PitchScalingSpinner = uispinner(app.TrackPlaybackControlPanel);
            app.PitchScalingSpinner.Step = 0.1;
            app.PitchScalingSpinner.Limits = [0.2 3];
            app.PitchScalingSpinner.ValueDisplayFormat = '%.1f';
            app.PitchScalingSpinner.Position = [86 62 60 22];
            app.PitchScalingSpinner.Value = 1;

            % Create TimeScalingSpinnerLabel
            app.TimeScalingSpinnerLabel = uilabel(app.TrackPlaybackControlPanel);
            app.TimeScalingSpinnerLabel.Position = [5 36 75 22];
            app.TimeScalingSpinnerLabel.Text = 'Time Scaling';

            % Create TimeScalingSpinner
            app.TimeScalingSpinner = uispinner(app.TrackPlaybackControlPanel);
            app.TimeScalingSpinner.Step = 0.25;
            app.TimeScalingSpinner.Limits = [0.25 2];
            app.TimeScalingSpinner.ValueDisplayFormat = '%.1f';
            app.TimeScalingSpinner.Position = [86 36 60 22];
            app.TimeScalingSpinner.Value = 1;

            % Create TracktoPlayDropDownLabel
            app.TracktoPlayDropDownLabel = uilabel(app.TrackPlaybackControlPanel);
            app.TracktoPlayDropDownLabel.Position = [5 11 75 22];
            app.TracktoPlayDropDownLabel.Text = 'Track to Play';

            % Create TracktoPlayDropDown
            app.TracktoPlayDropDown = uidropdown(app.TrackPlaybackControlPanel);
            app.TracktoPlayDropDown.Items = {'Final Track', 'Track 1', 'Track 2', 'Track 3', 'Track 4', 'Track 5'};
            app.TracktoPlayDropDown.ItemsData = [0 1 2 3 4 5];
            app.TracktoPlayDropDown.Position = [86 11 94 22];
            app.TracktoPlayDropDown.Value = 0;

            % Create PlayPSOLATrack
            app.PlayPSOLATrack = uibutton(app.TrackPlaybackControlPanel, 'push');
            app.PlayPSOLATrack.ButtonPushedFcn = createCallbackFcn(app, @PlayPSOLATrackButtonPushed, true);
            app.PlayPSOLATrack.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.PlayPSOLATrack.IconAlignment = 'top';
            app.PlayPSOLATrack.WordWrap = 'on';
            app.PlayPSOLATrack.FontSize = 10;
            app.PlayPSOLATrack.Position = [156 36 47 48];
            app.PlayPSOLATrack.Text = 'Play';

            % Create LPCCrossSynthorConvolutionPanel
            app.LPCCrossSynthorConvolutionPanel = uipanel(app.LeftPanel);
            app.LPCCrossSynthorConvolutionPanel.Title = 'LPC Cross-Synth or Convolution';
            app.LPCCrossSynthorConvolutionPanel.Position = [1 167 220 238];

            % Create CarrierSpinnerLabel
            app.CarrierSpinnerLabel = uilabel(app.LPCCrossSynthorConvolutionPanel);
            app.CarrierSpinnerLabel.Position = [5 190 42 22];
            app.CarrierSpinnerLabel.Text = 'Carrier';

            % Create CarrierSpinner
            app.CarrierSpinner = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.CarrierSpinner.Limits = [1 5];
            app.CarrierSpinner.RoundFractionalValues = 'on';
            app.CarrierSpinner.ValueDisplayFormat = 'Track %d';
            app.CarrierSpinner.Position = [62 190 100 22];
            app.CarrierSpinner.Value = 2;

            % Create ModulatorSpinnerLabel
            app.ModulatorSpinnerLabel = uilabel(app.LPCCrossSynthorConvolutionPanel);
            app.ModulatorSpinnerLabel.Position = [5 165 60 22];
            app.ModulatorSpinnerLabel.Text = 'Modulator';

            % Create ModulatorSpinner
            app.ModulatorSpinner = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.ModulatorSpinner.Limits = [1 5];
            app.ModulatorSpinner.RoundFractionalValues = 'on';
            app.ModulatorSpinner.ValueDisplayFormat = 'Track %d';
            app.ModulatorSpinner.Position = [62 165 100 22];
            app.ModulatorSpinner.Value = 1;

            % Create SaveinSpinnerLabel
            app.SaveinSpinnerLabel = uilabel(app.LPCCrossSynthorConvolutionPanel);
            app.SaveinSpinnerLabel.Position = [5 140 45 22];
            app.SaveinSpinnerLabel.Text = 'Save in';

            % Create SaveinSpinner
            app.SaveinSpinner = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.SaveinSpinner.Limits = [1 5];
            app.SaveinSpinner.RoundFractionalValues = 'on';
            app.SaveinSpinner.ValueDisplayFormat = 'Track %d';
            app.SaveinSpinner.Position = [62 140 100 22];
            app.SaveinSpinner.Value = 5;

            % Create CompileSynth
            app.CompileSynth = uibutton(app.LPCCrossSynthorConvolutionPanel, 'push');
            app.CompileSynth.ButtonPushedFcn = createCallbackFcn(app, @CompileSynthButtonPushed, true);
            app.CompileSynth.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.CompileSynth.IconAlignment = 'top';
            app.CompileSynth.WordWrap = 'on';
            app.CompileSynth.FontSize = 10;
            app.CompileSynth.Position = [164 140 53 72];
            app.CompileSynth.Text = 'Synth';

            % Create Order2
            app.Order2 = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.Order2.Limits = [1 Inf];
            app.Order2.RoundFractionalValues = 'on';
            app.Order2.ValueDisplayFormat = '%d';
            app.Order2.ValueChangedFcn = createCallbackFcn(app, @Order2ValueChanged, true);
            app.Order2.HorizontalAlignment = 'center';
            app.Order2.Position = [73 99 60 20];
            app.Order2.Value = 20;

            % Create Order1
            app.Order1 = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.Order1.Limits = [1 Inf];
            app.Order1.RoundFractionalValues = 'on';
            app.Order1.ValueDisplayFormat = '%d';
            app.Order1.ValueChangedFcn = createCallbackFcn(app, @Order1ValueChanged, true);
            app.Order1.HorizontalAlignment = 'center';
            app.Order1.Position = [7 99 60 20];
            app.Order1.Value = 6;

            % Create WindowSize
            app.WindowSize = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.WindowSize.Limits = [1 Inf];
            app.WindowSize.RoundFractionalValues = 'on';
            app.WindowSize.ValueDisplayFormat = '%d';
            app.WindowSize.ValueChangedFcn = createCallbackFcn(app, @WindowSizeValueChanged, true);
            app.WindowSize.HorizontalAlignment = 'center';
            app.WindowSize.Position = [142 73 73 20];
            app.WindowSize.Value = 400;

            % Create HopSize
            app.HopSize = uispinner(app.LPCCrossSynthorConvolutionPanel);
            app.HopSize.Limits = [1 Inf];
            app.HopSize.RoundFractionalValues = 'on';
            app.HopSize.ValueDisplayFormat = '%d';
            app.HopSize.ValueChangedFcn = createCallbackFcn(app, @HopSizeValueChanged, true);
            app.HopSize.HorizontalAlignment = 'center';
            app.HopSize.Position = [142 99 73 20];
            app.HopSize.Value = 160;

            % Create ModulatorCarrierOrderLabel
            app.ModulatorCarrierOrderLabel = uilabel(app.LPCCrossSynthorConvolutionPanel);
            app.ModulatorCarrierOrderLabel.FontSize = 11;
            app.ModulatorCarrierOrderLabel.Position = [7 119 124 22];
            app.ModulatorCarrierOrderLabel.Text = 'Modulator/Carrier Order';

            % Create HopBlockSizeLabel
            app.HopBlockSizeLabel = uilabel(app.LPCCrossSynthorConvolutionPanel);
            app.HopBlockSizeLabel.HorizontalAlignment = 'right';
            app.HopBlockSizeLabel.FontSize = 11;
            app.HopBlockSizeLabel.Position = [131 119 82 22];
            app.HopBlockSizeLabel.Text = 'Hop/Block Size';

            % Create CrossConvSwitch
            app.CrossConvSwitch = uiswitch(app.LPCCrossSynthorConvolutionPanel, 'slider');
            app.CrossConvSwitch.Items = {'Cross-Synth', 'Convolution'};
            app.CrossConvSwitch.ItemsData = [0 1];
            app.CrossConvSwitch.Position = [86 9 45 20];
            app.CrossConvSwitch.Value = 0;

            % Create CrossSynthVersionDropDown
            app.CrossSynthVersionDropDown = uidropdown(app.LPCCrossSynthorConvolutionPanel);
            app.CrossSynthVersionDropDown.Items = {'LPC (New)', 'LPC (Old)'};
            app.CrossSynthVersionDropDown.ItemsData = [0 1];
            app.CrossSynthVersionDropDown.Position = [7 72 124 22];
            app.CrossSynthVersionDropDown.Value = 0;

            % Create ThenewimplementationofLPCisbasedontheDAFXbooksapproachLabel
            app.ThenewimplementationofLPCisbasedontheDAFXbooksapproachLabel = uilabel(app.LPCCrossSynthorConvolutionPanel);
            app.ThenewimplementationofLPCisbasedontheDAFXbooksapproachLabel.WordWrap = 'on';
            app.ThenewimplementationofLPCisbasedontheDAFXbooksapproachLabel.Position = [5 31 208 38];
            app.ThenewimplementationofLPCisbasedontheDAFXbooksapproachLabel.Text = 'The new implementation of LPC is based on the DAFX book''s approach';

            % Create AdvancedSettingsPanel
            app.AdvancedSettingsPanel = uipanel(app.LeftPanel);
            app.AdvancedSettingsPanel.Title = 'Advanced Settings';
            app.AdvancedSettingsPanel.Position = [1 99 220 69];

            % Create OutputAudioDeviceIDEditFieldLabel
            app.OutputAudioDeviceIDEditFieldLabel = uilabel(app.AdvancedSettingsPanel);
            app.OutputAudioDeviceIDEditFieldLabel.Position = [5 25 132 22];
            app.OutputAudioDeviceIDEditFieldLabel.Text = 'Output Audio Device ID';

            % Create OutputAudioDeviceIDEditField
            app.OutputAudioDeviceIDEditField = uieditfield(app.AdvancedSettingsPanel, 'numeric');
            app.OutputAudioDeviceIDEditField.Limits = [-1 Inf];
            app.OutputAudioDeviceIDEditField.RoundFractionalValues = 'on';
            app.OutputAudioDeviceIDEditField.ValueDisplayFormat = '%d';
            app.OutputAudioDeviceIDEditField.ValueChangedFcn = createCallbackFcn(app, @OutputDeviceIDSpinnerValueChanged, true);
            app.OutputAudioDeviceIDEditField.HorizontalAlignment = 'center';
            app.OutputAudioDeviceIDEditField.Position = [140 25 36 22];
            app.OutputAudioDeviceIDEditField.Value = -1;

            % Create SpectrogramThresholdEditFieldLabel
            app.SpectrogramThresholdEditFieldLabel = uilabel(app.AdvancedSettingsPanel);
            app.SpectrogramThresholdEditFieldLabel.Position = [5 0 132 22];
            app.SpectrogramThresholdEditFieldLabel.Text = 'Spectrogram Threshold';

            % Create SpectrogramThresholdEditField
            app.SpectrogramThresholdEditField = uieditfield(app.AdvancedSettingsPanel, 'numeric');
            app.SpectrogramThresholdEditField.Limits = [0 1];
            app.SpectrogramThresholdEditField.ValueDisplayFormat = '%.2f';
            app.SpectrogramThresholdEditField.ValueChangedFcn = createCallbackFcn(app, @SpectrogramThresholdEditFieldValueChanged, true);
            app.SpectrogramThresholdEditField.HorizontalAlignment = 'center';
            app.SpectrogramThresholdEditField.Position = [140 0 36 22];
            app.SpectrogramThresholdEditField.Value = 0.4;

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create LayoutMain
            app.LayoutMain = uigridlayout(app.RightPanel);
            app.LayoutMain.ColumnWidth = {110, '1x'};
            app.LayoutMain.RowHeight = {22, '2x', '1x', '1.5x', '0.8x', '0.5x', '0.8x', '0.5x', '0.8x', '0.5x'};
            app.LayoutMain.ColumnSpacing = 1.66666666666667;
            app.LayoutMain.RowSpacing = 0;
            app.LayoutMain.Padding = [1.66666666666667 10 1.66666666666667 1];

            % Create Track3
            app.Track3 = uiaxes(app.LayoutMain);
            zlabel(app.Track3, 'Z')
            app.Track3.Toolbar.Visible = 'off';
            app.Track3.XLim = [0 1];
            app.Track3.YLim = [-1 1];
            app.Track3.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.Track3.XTickLabel = {'0'; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1'};
            app.Track3.XMinorTick = 'on';
            app.Track3.YTick = [0 0.5 1];
            app.Track3.YTickLabel = '';
            app.Track3.YMinorTick = 'on';
            app.Track3.TitleHorizontalAlignment = 'left';
            app.Track3.XGrid = 'on';
            app.Track3.FontSize = 8;
            app.Track3.Layout.Row = 9;
            app.Track3.Layout.Column = 2;

            % Create Track2
            app.Track2 = uiaxes(app.LayoutMain);
            zlabel(app.Track2, 'Z')
            app.Track2.Toolbar.Visible = 'off';
            app.Track2.XLim = [0 1];
            app.Track2.YLim = [-1 1];
            app.Track2.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.Track2.XTickLabel = {'0'; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1'};
            app.Track2.XMinorTick = 'on';
            app.Track2.YTick = [0 0.5 1];
            app.Track2.YTickLabel = '';
            app.Track2.YMinorTick = 'on';
            app.Track2.TitleHorizontalAlignment = 'left';
            app.Track2.XGrid = 'on';
            app.Track2.FontSize = 8;
            app.Track2.Layout.Row = 7;
            app.Track2.Layout.Column = 2;

            % Create Track1
            app.Track1 = uiaxes(app.LayoutMain);
            zlabel(app.Track1, 'Z')
            app.Track1.Toolbar.Visible = 'off';
            app.Track1.XLim = [0 1];
            app.Track1.YLim = [-1 1];
            app.Track1.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.Track1.XTickLabel = {'0'; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1'};
            app.Track1.XMinorTick = 'on';
            app.Track1.YTick = [0 0.5 1];
            app.Track1.YTickLabel = '';
            app.Track1.YMinorTick = 'on';
            app.Track1.TitleHorizontalAlignment = 'left';
            app.Track1.XGrid = 'on';
            app.Track1.FontSize = 8;
            app.Track1.Layout.Row = 5;
            app.Track1.Layout.Column = 2;

            % Create Waveform
            app.Waveform = uiaxes(app.LayoutMain);
            xlabel(app.Waveform, 'Time (in seconds)')
            zlabel(app.Waveform, 'Z')
            app.Waveform.Toolbar.Visible = 'off';
            app.Waveform.XLim = [0 1];
            app.Waveform.YLim = [-1.5 1.5];
            app.Waveform.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.Waveform.XTickLabel = {'0'; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1'};
            app.Waveform.XMinorTick = 'on';
            app.Waveform.YTick = [-1 -0.5 0 0.5 1];
            app.Waveform.YTickLabel = '';
            app.Waveform.YMinorTick = 'on';
            app.Waveform.TitleHorizontalAlignment = 'left';
            app.Waveform.XGrid = 'on';
            app.Waveform.FontSize = 8;
            app.Waveform.Layout.Row = 3;
            app.Waveform.Layout.Column = 2;
            app.Waveform.ButtonDownFcn = createCallbackFcn(app, @WaveformButtonDown, true);

            % Create Spectrogram
            app.Spectrogram = uiaxes(app.LayoutMain);
            title(app.Spectrogram, 'Frequency (Hz)')
            app.Spectrogram.XTick = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
            app.Spectrogram.XMinorTick = 'on';
            app.Spectrogram.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.Spectrogram.YTickLabel = '';
            app.Spectrogram.YMinorTick = 'on';
            app.Spectrogram.ZTick = [];
            app.Spectrogram.ZTickLabel = '';
            app.Spectrogram.TitleHorizontalAlignment = 'left';
            app.Spectrogram.XGrid = 'on';
            app.Spectrogram.FontSize = 8;
            app.Spectrogram.Layout.Row = [1 2];
            app.Spectrogram.Layout.Column = 2;
            colormap(app.Spectrogram, 'bone')

            % Create FinalTrack
            app.FinalTrack = uiaxes(app.LayoutMain);
            title(app.FinalTrack, 'Tracks')
            xlabel(app.FinalTrack, 'Time (in seconds)')
            app.FinalTrack.Toolbar.Visible = 'off';
            app.FinalTrack.YLim = [1 11];
            app.FinalTrack.XMinorTick = 'on';
            app.FinalTrack.YTick = [2 4 6 8 10];
            app.FinalTrack.YTickLabel = {'Track 5'; 'Track 4'; 'Track 3'; 'Track 2'; 'Track 1'};
            app.FinalTrack.ZTick = [];
            app.FinalTrack.TitleHorizontalAlignment = 'left';
            app.FinalTrack.XGrid = 'on';
            app.FinalTrack.FontSize = 10;
            app.FinalTrack.Layout.Row = 4;
            app.FinalTrack.Layout.Column = 2;

            % Create TabGroup
            app.TabGroup = uitabgroup(app.LayoutMain);
            app.TabGroup.SelectionChangedFcn = createCallbackFcn(app, @TabGroupSelectionChanged, true);
            app.TabGroup.Layout.Row = [1 3];
            app.TabGroup.Layout.Column = 1;

            % Create ThisisablanktabTab
            app.ThisisablanktabTab = uitab(app.TabGroup);
            app.ThisisablanktabTab.Title = 'This is a blank tab';
            app.ThisisablanktabTab.ForegroundColor = 'none';

            % Create SwitchtoEditforSpectrogrameditingLabel
            app.SwitchtoEditforSpectrogrameditingLabel = uilabel(app.ThisisablanktabTab);
            app.SwitchtoEditforSpectrogrameditingLabel.VerticalAlignment = 'bottom';
            app.SwitchtoEditforSpectrogrameditingLabel.WordWrap = 'on';
            app.SwitchtoEditforSpectrogrameditingLabel.FontSize = 11;
            app.SwitchtoEditforSpectrogrameditingLabel.Position = [3 7 106 67];
            app.SwitchtoEditforSpectrogrameditingLabel.Text = 'Switch to "Edit" for Spectrogram editing';

            % Create TrimUpper
            app.TrimUpper = uispinner(app.ThisisablanktabTab);
            app.TrimUpper.Limits = [0 1];
            app.TrimUpper.ValueDisplayFormat = '%.2fs';
            app.TrimUpper.HorizontalAlignment = 'left';
            app.TrimUpper.Position = [4 180 85 22];

            % Create TrimLower
            app.TrimLower = uispinner(app.ThisisablanktabTab);
            app.TrimLower.Limits = [0 1];
            app.TrimLower.ValueDisplayFormat = '%.2fs';
            app.TrimLower.HorizontalAlignment = 'left';
            app.TrimLower.Position = [4 154 85 22];

            % Create TrimRangeLabel
            app.TrimRangeLabel = uilabel(app.ThisisablanktabTab);
            app.TrimRangeLabel.HorizontalAlignment = 'center';
            app.TrimRangeLabel.Position = [4 200 70 22];
            app.TrimRangeLabel.Text = 'Time Range';

            % Create TrimAudioButton
            app.TrimAudioButton = uibutton(app.ThisisablanktabTab, 'push');
            app.TrimAudioButton.ButtonPushedFcn = createCallbackFcn(app, @TrimAudioButtonPushed, true);
            app.TrimAudioButton.BusyAction = 'cancel';
            app.TrimAudioButton.Position = [4 128 85 22];
            app.TrimAudioButton.Text = 'Trim Audio';

            % Create EditTab
            app.EditTab = uitab(app.TabGroup);
            app.EditTab.Title = 'Edit';

            % Create FreqUpper
            app.FreqUpper = uispinner(app.EditTab);
            app.FreqUpper.Step = 1000;
            app.FreqUpper.ValueChangingFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.FreqUpper.Limits = [0 24000];
            app.FreqUpper.RoundFractionalValues = 'on';
            app.FreqUpper.ValueDisplayFormat = '%dHz';
            app.FreqUpper.ValueChangedFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.FreqUpper.Editable = 'off';
            app.FreqUpper.HorizontalAlignment = 'left';
            app.FreqUpper.Position = [12 183 85 22];
            app.FreqUpper.Value = 24000;

            % Create FreqLower
            app.FreqLower = uispinner(app.EditTab);
            app.FreqLower.Step = 1000;
            app.FreqLower.ValueChangingFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.FreqLower.Limits = [0 24000];
            app.FreqLower.RoundFractionalValues = 'on';
            app.FreqLower.ValueDisplayFormat = '%dHz';
            app.FreqLower.ValueChangedFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.FreqLower.Editable = 'off';
            app.FreqLower.HorizontalAlignment = 'left';
            app.FreqLower.Position = [12 159 85 22];

            % Create FreqRangeLabel
            app.FreqRangeLabel = uilabel(app.EditTab);
            app.FreqRangeLabel.HorizontalAlignment = 'center';
            app.FreqRangeLabel.Position = [12 203 68 22];
            app.FreqRangeLabel.Text = 'Freq Range';

            % Create TimeUpper
            app.TimeUpper = uispinner(app.EditTab);
            app.TimeUpper.ValueChangingFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.TimeUpper.Limits = [0 1200];
            app.TimeUpper.ValueDisplayFormat = '%.2fs';
            app.TimeUpper.ValueChangedFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.TimeUpper.HorizontalAlignment = 'left';
            app.TimeUpper.Position = [12 122 85 22];
            app.TimeUpper.Value = 1200;

            % Create TimeLower
            app.TimeLower = uispinner(app.EditTab);
            app.TimeLower.ValueChangingFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.TimeLower.Limits = [0 48000];
            app.TimeLower.ValueDisplayFormat = '%.2fs';
            app.TimeLower.ValueChangedFcn = createCallbackFcn(app, @SpectrogramEditBoxValueChanged, true);
            app.TimeLower.HorizontalAlignment = 'left';
            app.TimeLower.Position = [12 98 85 22];

            % Create TimeRangeLabel
            app.TimeRangeLabel = uilabel(app.EditTab);
            app.TimeRangeLabel.HorizontalAlignment = 'center';
            app.TimeRangeLabel.Position = [12 141 70 22];
            app.TimeRangeLabel.Text = 'Time Range';

            % Create Track1CheckBox
            app.Track1CheckBox = uicheckbox(app.LayoutMain);
            app.Track1CheckBox.ValueChangedFcn = createCallbackFcn(app, @Track1CheckBoxValueChanged, true);
            app.Track1CheckBox.Text = ' Track 1';
            app.Track1CheckBox.FontSize = 15;
            app.Track1CheckBox.FontWeight = 'bold';
            app.Track1CheckBox.Layout.Row = 5;
            app.Track1CheckBox.Layout.Column = 1;

            % Create Track2CheckBox
            app.Track2CheckBox = uicheckbox(app.LayoutMain);
            app.Track2CheckBox.ValueChangedFcn = createCallbackFcn(app, @Track2CheckBoxValueChanged, true);
            app.Track2CheckBox.Text = ' Track 2';
            app.Track2CheckBox.FontSize = 15;
            app.Track2CheckBox.FontWeight = 'bold';
            app.Track2CheckBox.FontColor = [0 0 1];
            app.Track2CheckBox.Layout.Row = 7;
            app.Track2CheckBox.Layout.Column = 1;

            % Create Track3CheckBox
            app.Track3CheckBox = uicheckbox(app.LayoutMain);
            app.Track3CheckBox.ValueChangedFcn = createCallbackFcn(app, @Track3CheckBoxValueChanged, true);
            app.Track3CheckBox.Text = ' Track 3';
            app.Track3CheckBox.FontSize = 15;
            app.Track3CheckBox.FontWeight = 'bold';
            app.Track3CheckBox.FontColor = [1 0 0];
            app.Track3CheckBox.Layout.Row = 9;
            app.Track3CheckBox.Layout.Column = 1;

            % Create Track1Slider
            app.Track1Slider = uislider(app.LayoutMain);
            app.Track1Slider.Limits = [0 20];
            app.Track1Slider.MajorTicks = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100];
            app.Track1Slider.MajorTickLabels = {'0', '2', '4', '6', '8', '10', '12', '14', '16', '18', '20', '22', '24', '26', '28', '30', '32', '34', '36', '38', '40', '42', '44', '46', '48', '50', '52', '54', '56', '58', '60', '62', '64', '66', '68', '70', '72', '74', '76', '78', '80', '82', '84', '86', '88', '90', '92', '94', '96', '98', '100'};
            app.Track1Slider.ValueChangedFcn = createCallbackFcn(app, @Track1SliderValueChanged, true);
            app.Track1Slider.Layout.Row = 6;
            app.Track1Slider.Layout.Column = 2;
            app.Track1Slider.FontSize = 8;

            % Create Track2Slider
            app.Track2Slider = uislider(app.LayoutMain);
            app.Track2Slider.Limits = [0 20];
            app.Track2Slider.MajorTicks = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100];
            app.Track2Slider.MajorTickLabels = {'0', '2', '4', '6', '8', '10', '12', '14', '16', '18', '20', '22', '24', '26', '28', '30', '32', '34', '36', '38', '40', '42', '44', '46', '48', '50', '52', '54', '56', '58', '60', '62', '64', '66', '68', '70', '72', '74', '76', '78', '80', '82', '84', '86', '88', '90', '92', '94', '96', '98', '100'};
            app.Track2Slider.ValueChangedFcn = createCallbackFcn(app, @Track2SliderValueChanged, true);
            app.Track2Slider.Layout.Row = 8;
            app.Track2Slider.Layout.Column = 2;
            app.Track2Slider.FontSize = 8;

            % Create Track3Slider
            app.Track3Slider = uislider(app.LayoutMain);
            app.Track3Slider.Limits = [0 20];
            app.Track3Slider.MajorTicks = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100];
            app.Track3Slider.MajorTickLabels = {'0', '2', '4', '6', '8', '10', '12', '14', '16', '18', '20', '22', '24', '26', '28', '30', '32', '34', '36', '38', '40', '42', '44', '46', '48', '50', '52', '54', '56', '58', '60', '62', '64', '66', '68', '70', '72', '74', '76', '78', '80', '82', '84', '86', '88', '90', '92', '94', '96', '98', '100'};
            app.Track3Slider.ValueChangedFcn = createCallbackFcn(app, @Track3SliderValueChanged, true);
            app.Track3Slider.Layout.Row = 10;
            app.Track3Slider.Layout.Column = 2;
            app.Track3Slider.FontSize = 8;

            % Create TrackName1
            app.TrackName1 = uilabel(app.LayoutMain);
            app.TrackName1.WordWrap = 'on';
            app.TrackName1.FontSize = 10;
            app.TrackName1.Layout.Row = 6;
            app.TrackName1.Layout.Column = 1;
            app.TrackName1.Text = '';

            % Create TrackName2
            app.TrackName2 = uilabel(app.LayoutMain);
            app.TrackName2.WordWrap = 'on';
            app.TrackName2.FontSize = 10;
            app.TrackName2.Layout.Row = 8;
            app.TrackName2.Layout.Column = 1;
            app.TrackName2.Text = '';

            % Create TrackName3
            app.TrackName3 = uilabel(app.LayoutMain);
            app.TrackName3.WordWrap = 'on';
            app.TrackName3.FontSize = 10;
            app.TrackName3.Layout.Row = 10;
            app.TrackName3.Layout.Column = 1;
            app.TrackName3.Text = '';

            % Create PlayHighlightedTrack
            app.PlayHighlightedTrack = uibutton(app.LayoutMain, 'push');
            app.PlayHighlightedTrack.ButtonPushedFcn = createCallbackFcn(app, @PlayHighlightedTrackButtonPushed, true);
            app.PlayHighlightedTrack.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.PlayHighlightedTrack.IconAlignment = 'top';
            app.PlayHighlightedTrack.WordWrap = 'on';
            app.PlayHighlightedTrack.FontSize = 10;
            app.PlayHighlightedTrack.FontWeight = 'bold';
            app.PlayHighlightedTrack.Layout.Row = 4;
            app.PlayHighlightedTrack.Layout.Column = 1;
            app.PlayHighlightedTrack.Text = 'Play Highlight Track';

            % Create SpectrogramContextMenu
            app.SpectrogramContextMenu = uicontextmenu(app.HugoSynthUIFigure);

            % Create ApplyChangesMenu
            app.ApplyChangesMenu = uimenu(app.SpectrogramContextMenu);
            app.ApplyChangesMenu.MenuSelectedFcn = createCallbackFcn(app, @ApplyChangesMenuSelected, true);
            app.ApplyChangesMenu.Text = 'Apply Changes';

            % Create SaveinMenu
            app.SaveinMenu = uimenu(app.SpectrogramContextMenu);
            app.SaveinMenu.Text = 'Save in...';

            % Create SaveToTrack1Menu
            app.SaveToTrack1Menu = uimenu(app.SaveinMenu);
            app.SaveToTrack1Menu.MenuSelectedFcn = createCallbackFcn(app, @SaveToTrack1MenuSelected, true);
            app.SaveToTrack1Menu.Text = 'Track 1';

            % Create SaveToTrack2Menu
            app.SaveToTrack2Menu = uimenu(app.SaveinMenu);
            app.SaveToTrack2Menu.MenuSelectedFcn = createCallbackFcn(app, @SaveToTrack2MenuSelected, true);
            app.SaveToTrack2Menu.Text = 'Track 2';

            % Create SaveToTrack3Menu
            app.SaveToTrack3Menu = uimenu(app.SaveinMenu);
            app.SaveToTrack3Menu.MenuSelectedFcn = createCallbackFcn(app, @SaveToTrack3MenuSelected, true);
            app.SaveToTrack3Menu.Text = 'Track 3';

            % Create SaveToTrack4Menu
            app.SaveToTrack4Menu = uimenu(app.SaveinMenu);
            app.SaveToTrack4Menu.MenuSelectedFcn = createCallbackFcn(app, @SaveToTrack4MenuSelected, true);
            app.SaveToTrack4Menu.Text = 'Track 4';

            % Create SaveToTrack5Menu
            app.SaveToTrack5Menu = uimenu(app.SaveinMenu);
            app.SaveToTrack5Menu.MenuSelectedFcn = createCallbackFcn(app, @SaveToTrack5MenuSelected, true);
            app.SaveToTrack5Menu.Text = 'Track 5';

            % Create SaveaswavMenu
            app.SaveaswavMenu = uimenu(app.SpectrogramContextMenu);
            app.SaveaswavMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveHighlightedTrackMenuSelected, true);
            app.SaveaswavMenu.Text = 'Save as wav';
            
            % Assign app.SpectrogramContextMenu
            app.Spectrogram.ContextMenu = app.SpectrogramContextMenu;

            % Create Track1Menu
            app.Track1Menu = uicontextmenu(app.HugoSynthUIFigure);
            app.Track1Menu.ContextMenuOpeningFcn = createCallbackFcn(app, @Track1MenuContextMenuOpening, true);

            % Create Track1Highlight
            app.Track1Highlight = uimenu(app.Track1Menu);
            app.Track1Highlight.MenuSelectedFcn = createCallbackFcn(app, @Track1HighlightButtonDown, true);
            app.Track1Highlight.Text = 'Highlight';

            % Create Track1Load
            app.Track1Load = uimenu(app.Track1Menu);
            app.Track1Load.MenuSelectedFcn = createCallbackFcn(app, @TrackLoadMenuSelected, true);
            app.Track1Load.Text = 'Load';

            % Create Track1Remove
            app.Track1Remove = uimenu(app.Track1Menu);
            app.Track1Remove.MenuSelectedFcn = createCallbackFcn(app, @TrackRemoveMenuSelected, true);
            app.Track1Remove.Text = 'Remove';

            % Create Crossfadewithtrack2Menu_1
            app.Crossfadewithtrack2Menu_1 = uimenu(app.Track1Menu);
            app.Crossfadewithtrack2Menu_1.MenuSelectedFcn = createCallbackFcn(app, @CrossFadewithTrack2, true);
            app.Crossfadewithtrack2Menu_1.Text = 'Cross-fade with track 2';

            % Create Crossfadewithtrack3Menu_1
            app.Crossfadewithtrack3Menu_1 = uimenu(app.Track1Menu);
            app.Crossfadewithtrack3Menu_1.MenuSelectedFcn = createCallbackFcn(app, @CrossFadewithTrack3, true);
            app.Crossfadewithtrack3Menu_1.Text = 'Cross-fade with track 3';
            
            % Assign app.Track1Menu
            app.Track1CheckBox.ContextMenu = app.Track1Menu;
            app.TrackName1.ContextMenu = app.Track1Menu;
            app.Track1.ContextMenu = app.Track1Menu;

            % Create Track2Menu
            app.Track2Menu = uicontextmenu(app.HugoSynthUIFigure);
            app.Track2Menu.ContextMenuOpeningFcn = createCallbackFcn(app, @Track2MenuContextMenuOpening, true);

            % Create Track2Highlight
            app.Track2Highlight = uimenu(app.Track2Menu);
            app.Track2Highlight.MenuSelectedFcn = createCallbackFcn(app, @Track2HighlightButtonDown, true);
            app.Track2Highlight.Text = 'Highlight';

            % Create Track2Load
            app.Track2Load = uimenu(app.Track2Menu);
            app.Track2Load.MenuSelectedFcn = createCallbackFcn(app, @TrackLoadMenuSelected, true);
            app.Track2Load.Text = 'Load';

            % Create Track2Remove
            app.Track2Remove = uimenu(app.Track2Menu);
            app.Track2Remove.MenuSelectedFcn = createCallbackFcn(app, @TrackRemoveMenuSelected, true);
            app.Track2Remove.Text = 'Remove';

            % Create Crossfadewithtrack1Menu_2
            app.Crossfadewithtrack1Menu_2 = uimenu(app.Track2Menu);
            app.Crossfadewithtrack1Menu_2.MenuSelectedFcn = createCallbackFcn(app, @CrossFadewithTrack1, true);
            app.Crossfadewithtrack1Menu_2.Text = 'Cross-fade with track 1';

            % Create Crossfadewithtrack3Menu_2
            app.Crossfadewithtrack3Menu_2 = uimenu(app.Track2Menu);
            app.Crossfadewithtrack3Menu_2.MenuSelectedFcn = createCallbackFcn(app, @CrossFadewithTrack3, true);
            app.Crossfadewithtrack3Menu_2.Text = 'Cross-fade with track 3';
            
            % Assign app.Track2Menu
            app.Track2CheckBox.ContextMenu = app.Track2Menu;
            app.TrackName2.ContextMenu = app.Track2Menu;
            app.Track2.ContextMenu = app.Track2Menu;

            % Create Track3Menu
            app.Track3Menu = uicontextmenu(app.HugoSynthUIFigure);
            app.Track3Menu.ContextMenuOpeningFcn = createCallbackFcn(app, @Track3MenuContextMenuOpening, true);

            % Create Track3Highlight
            app.Track3Highlight = uimenu(app.Track3Menu);
            app.Track3Highlight.MenuSelectedFcn = createCallbackFcn(app, @Track3HighlightButtonDown, true);
            app.Track3Highlight.Text = 'Highlight';

            % Create Track3Load
            app.Track3Load = uimenu(app.Track3Menu);
            app.Track3Load.MenuSelectedFcn = createCallbackFcn(app, @TrackLoadMenuSelected, true);
            app.Track3Load.Text = 'Load';

            % Create Track3Remove
            app.Track3Remove = uimenu(app.Track3Menu);
            app.Track3Remove.MenuSelectedFcn = createCallbackFcn(app, @TrackRemoveMenuSelected, true);
            app.Track3Remove.Text = 'Remove';

            % Create Crossfadewithtrack1Menu_3
            app.Crossfadewithtrack1Menu_3 = uimenu(app.Track3Menu);
            app.Crossfadewithtrack1Menu_3.MenuSelectedFcn = createCallbackFcn(app, @CrossFadewithTrack1, true);
            app.Crossfadewithtrack1Menu_3.Text = 'Cross-fade with track 1';

            % Create Crossfadewithtrack2Menu_3
            app.Crossfadewithtrack2Menu_3 = uimenu(app.Track3Menu);
            app.Crossfadewithtrack2Menu_3.MenuSelectedFcn = createCallbackFcn(app, @CrossFadewithTrack2, true);
            app.Crossfadewithtrack2Menu_3.Text = 'Cross-fade with track 2';
            
            % Assign app.Track3Menu
            app.Track3CheckBox.ContextMenu = app.Track3Menu;
            app.TrackName3.ContextMenu = app.Track3Menu;
            app.Track3.ContextMenu = app.Track3Menu;

            % Show the figure after all components are created
            app.HugoSynthUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HugoSynth

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.HugoSynthUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.HugoSynthUIFigure)
        end
    end
end