classdef Looper < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        LooperUIFigure               matlab.ui.Figure
        GridLayout                   matlab.ui.container.GridLayout
        UtilitiesPanel               matlab.ui.container.Panel
        RecordSampleButton           matlab.ui.control.Button
        LoadExternalButton           matlab.ui.control.Button
        Gallery                      matlab.ui.container.Panel
        ADSREnvelopePanel            matlab.ui.container.Panel
        RSlider                      matlab.ui.control.Slider
        SLenSlider                   matlab.ui.control.Slider
        SSlider                      matlab.ui.control.Slider
        DSlider                      matlab.ui.control.Slider
        ASlider                      matlab.ui.control.Slider
        ReleaseLabel                 matlab.ui.control.Label
        SLenLabel                    matlab.ui.control.Label
        SustainLabel                 matlab.ui.control.Label
        DecayLabel                   matlab.ui.control.Label
        AttackLabel                  matlab.ui.control.Label
        LoopConfigPanel              matlab.ui.container.Panel
        RepeatSpinner                matlab.ui.control.Spinner
        RepeatSpinnerLabel           matlab.ui.control.Label
        LoopEndSlider                matlab.ui.control.Slider
        LoopStartLabel_2             matlab.ui.control.Label
        InputAudioDeviceIDEditField  matlab.ui.control.NumericEditField
        InputAudioDeviceIDEditFieldLabel  matlab.ui.control.Label
        SaveLoopButton               matlab.ui.control.Button
        PlaySampleButton             matlab.ui.control.Button
        StartPositionSlider          matlab.ui.control.Slider
        StartPositionSliderLabel     matlab.ui.control.Label
        LoopStartSlider              matlab.ui.control.Slider
        LoopStartLabel               matlab.ui.control.Label
        UIAxes                       matlab.ui.control.UIAxes
        ADSRAxes                     matlab.ui.control.UIAxes
        ADSRContextMenu              matlab.ui.container.ContextMenu
        SaveEnvelopeMenu             matlab.ui.container.Menu
        LoadEnvelopeMenu             matlab.ui.container.Menu
        GalleryContextMenu           matlab.ui.container.ContextMenu
        RefreshMenu                  matlab.ui.container.Menu
        ContextMenu                  matlab.ui.container.ContextMenu
        SaveinMenu                   matlab.ui.container.Menu
        Track1Menu                   matlab.ui.container.Menu
        Track2Menu                   matlab.ui.container.Menu
        Track3Menu                   matlab.ui.container.Menu
        Track4Menu                   matlab.ui.container.Menu
        Track5Menu                   matlab.ui.container.Menu
    end

    
    properties (Access = private)
        loop
        repeatedLoop;
        player = audioplayer([0 0 0], 44100);
        Fs
        wavePlot
        loopCursor
        startCursor

        sample
        sampleLooped;
        sampleLoaded = false;
        caller
        channel
        sampleLen;

        isRecording = false;
        recorder;

        wavetableLoaded = false;
        wavetable;
        wavetablePlugin;
    end

    properties (Access = public)
        maxGrainNum = 14;
        galleryDir = strcat(pwd, '/Grains/');
        grainExists = zeros(1, 14);
        grainAxes = cell(14, 1);
        grains = cell(14, 1);

        startCursorX = [0 0];
        startCursorY = [1 -1];
        
        loopCursorX = [0 1 1 0 0];
        loopCursorY = [1 1 -1 -1 1];
    end
    
    methods (Access = private)
        % This cannot be saved as an external function due to Matlab's limitations
        function ListGallery(app)
            for i = 1:app.maxGrainNum
                name = string(i);
                fileName = strcat(app.galleryDir, name, '.wav');
                callBackFunc = createCallbackFcn(app, str2func(strcat('Play', name)), false);
                app.grainAxes{i} = subplot(1, app.maxGrainNum, i, 'Parent', app.Gallery, 'ButtonDownFcn', callBackFunc);
                if (isfile(fileName))
                    app.grainExists(i) = true;
                    g = audioread(fileName);
                    app.grains{i} = g;
                    g = g';
                    grainLen = size(g, 2);
                    x = 1:grainLen;
                    scatter(app.grainAxes{i}, x, g, 1, 'ButtonDownFcn', callBackFunc);
                end
                xlabel(app.grainAxes{i}, '');
                ylabel(app.grainAxes{i}, '');
                xticklabels(app.grainAxes{i}, '');
                yticklabels(app.grainAxes{i}, '');
                title(app.grainAxes{i}, name);
                app.grainAxes{i}.Toolbar.Visible = 'off';
                disableDefaultInteractivity(app.grainAxes{i});
            end
        end

        function CreatePlayer(app, audioSource, pos)
            CheckAudioDevice(app.caller);
            if (size(audioSource, 1) > pos)
                app.player = audioplayer(audioSource(pos+1:end, 1), app.Fs, 24, app.caller.outputDeviceID);
            else
                app.player = audioplayer(audioSource(end:end, 1), app.Fs, 24, app.caller.outputDeviceID);
            end
        end

        function env = UpdateADSREnv(app)
            loopLen = floor(app.loopCursorX(2)) - floor(app.loopCursorX(1)) + 1;
            A = app.ASlider.Value;
            D = app.DSlider.Value;
            S = app.SSlider.Value;
            R = app.RSlider.Value;
            SLen = app.SLenSlider.Value;
            env = ADSREnv(A, D, S, R, SLen, loopLen);
            plot(app.ADSRAxes, env, 'b', LineWidth=2);
        end
        
        function CompileSampleLoop(app)
            app.loop = app.sample(floor(app.loopCursorX(1)):floor(app.loopCursorX(2)), 1);
            app.loop = app.loop .* app.UpdateADSREnv();
        end

        function success = CompileCompleteLoop(app)
            % Apply ADSR envelope to header
            A = app.ASlider.Value;
            D = app.DSlider.Value;
            S = app.SSlider.Value;
            R = app.RSlider.Value;
            SLen = app.SLenSlider.Value;
            header = app.sample(app.startCursorX(1):end, 1);
            header = header .* ADSREnv(A, D, S, R, SLen, size(header, 1));
            
            repeatNum = app.RepeatSpinner.Value;
            loopLen = size(app.loop, 1);
            if ((size(header, 1) + loopLen * repeatNum) > (app.Fs * 86400))
                uialert(app.LooperUIFigure, 'Stop it, this loop would be longer than a day', 'Cannot create a loop this long');
                success = false;
                return;
            elseif (repeatNum == 0)
                app.repeatedLoop = header;
            else
                app.repeatedLoop = [header; repmat(app.loop, repeatNum, 1)];
            end
            
            success = true;
        end

        function UpdateCursors(app)
            startPos = app.StartPositionSlider.Value;
            loopStart = app.LoopStartSlider.Value;
            loopEnd = app.LoopEndSlider.Value;
            if (loopEnd < loopStart)
                loopEnd = min(loopStart + 1, app.sampleLen);
                app.LoopEndSlider.Value = loopEnd;
            end
            
            app.loopCursorX([1 4 5]) = loopStart;
            app.loopCursorX([2 3]) = loopEnd;
            app.startCursorX(:) = startPos;

            app.RefreshCursorPlots();
        end

        function RefreshCursorPlots(app)
            refreshdata(app.startCursor, 'caller')
            refreshdata(app.loopCursor, 'caller');
        end

        function LoadFile(app, fileName, pathName)
            %[fileName, pathName] = uigetfile('*.wav;*.mp3;*.flac', 'Select a sample');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                [trackAudio, trackFs, error] = ReadAudioWithException(app, strcat(pathName, fileName));
                if (error) return; end % Stop loading if the audio file is invalid

                % Surround/stereo to mono
                [~, channelNum] = size(trackAudio);
                if (channelNum > 1)
                    if (app.channel > 2)
                        trackAudio = mean(trackAudio,2);
                    else
                        trackAudio = trackAudio(:, app.channel);
                    end
                end

                app.sample = resample(trackAudio, app.Fs, trackFs);
                app.sampleLoaded = true;
                app.sampleLen = size(app.sample, 1);

                [Ticks, TickLabels] = GenerateTicks(app.sampleLen, app.Fs);
                limit = [1 app.sampleLen];

                app.UIAxes.XLim = limit;
                app.UIAxes.YLim = [-1 1];
                title(app.UIAxes, fileName, 'Interpreter', 'none');

                app.StartPositionSlider.Limits = limit;
                app.LoopStartSlider.Limits = limit;
                app.LoopEndSlider.Limits = limit;

                app.StartPositionSlider.Value = 1;
                app.LoopStartSlider.Value = 1;
                app.LoopEndSlider.Value = app.sampleLen;
                
                xticks(app.UIAxes, Ticks);
                app.StartPositionSlider.MajorTicks = Ticks;
                app.LoopStartSlider.MajorTicks = Ticks;
                app.LoopEndSlider.MajorTicks = Ticks;

                xticklabels(app.UIAxes, TickLabels);
                app.StartPositionSlider.MajorTickLabels = TickLabels;
                app.LoopStartSlider.MajorTickLabels = TickLabels;
                app.LoopEndSlider.MajorTickLabels = TickLabels;

                app.wavePlot = scatter(app.UIAxes, 1:app.sampleLen, app.sample, 20, 'c', 'filled');
                
                hold(app.UIAxes, "on");
                app.startCursor = plot(app.UIAxes, app.startCursorX, app.startCursorY, "LineWidth", 2, "Color", 'k');
                app.startCursor.XDataSource = "app.startCursorX";
                app.startCursor.YDataSource = "app.startCursorY";

                app.loopCursor = plot(app.UIAxes, app.loopCursorX, app.loopCursorY, "LineWidth", 2, "Color", 'b');
                app.loopCursor.XDataSource = "app.loopCursorX";
                app.loopCursor.YDataSource = "app.loopCursorY";
                hold(app.UIAxes, "off");

                app.UpdateCursors();

                app.LoopConfigPanel.Enable = "on";
                app.ADSREnvelopePanel.Enable = "on";
            end
        end

        function SaveLoopToTrack(app, trackID)
            if (app.sampleLoaded)
                progressBar = uiprogressdlg(app.LooperUIFigure, Message='Creating loop');
                if (app.CompileCompleteLoop())
                    progressBar.Value = 0.8;
                    tmpName = strcat(pwd, '/HugoSynthTmp.wav');
                    audiowrite(tmpName, app.repeatedLoop, app.Fs, "Artist", "HugoSynth");
                    progressBar.Value = 1;
                    close(progressBar);
                    app.caller.AttemptToOverwriteTrack(trackID, "Looped Sample");
                else
                    close(progressBar);
                    return;
                end
            end
        end

        function PlayGrain(app, id)
            if (app.grainExists(id))
                app.CreatePlayer(app.grains{id}, 0);
                resume(app.player);
                app.LoadFile(strcat(string(id), '.wav'), app.galleryDir);
            end
        end

        function Play1(app); app.PlayGrain(1); end
        function Play2(app); app.PlayGrain(2); end
        function Play3(app); app.PlayGrain(3); end
        function Play4(app); app.PlayGrain(4); end
        function Play5(app); app.PlayGrain(5); end
        function Play6(app); app.PlayGrain(6); end
        function Play7(app); app.PlayGrain(7); end
        function Play8(app); app.PlayGrain(8); end
        function Play9(app); app.PlayGrain(9); end
        function Play10(app); app.PlayGrain(10); end
        function Play11(app); app.PlayGrain(11); end
        function Play12(app); app.PlayGrain(12); end
        function Play13(app); app.PlayGrain(13); end
        function Play14(app); app.PlayGrain(14); end
        % Unused (not enough space in the menu...)
        function Play15(app); app.PlayGrain(15); end
        function Play16(app); app.PlayGrain(16); end
        function Play17(app); app.PlayGrain(17); end
        function Play18(app); app.PlayGrain(18); end
        function Play19(app); app.PlayGrain(19); end

    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, caller, inputFs, channel)
            app.Fs = inputFs;
            app.caller = caller;
            app.channel = channel;
            disableDefaultInteractivity(app.UIAxes);
            app.maxGrainNum = 14;
            app.grainExists = zeros(1, app.maxGrainNum);
            app.grainAxes = cell(app.maxGrainNum, 1);
            app.grains = cell(app.maxGrainNum, 1);
            app.ListGallery();
            app.UpdateADSREnv();
            app.caller.looperOpened = true;
        end

        % Callback function
        function LoadDirectoryMenuSelected(app, event)
            app.LoadDir();
        end

        % Button pushed function: PlaySampleButton
        function PlaySampleButtonPushed(app, event)
            app.CompileSampleLoop();
            app.CreatePlayer(app.loop, 0);
            resume(app.player);
        end

        % Button pushed function: SaveLoopButton
        function SaveLoopButtonPushed(app, event)
            if (app.sampleLoaded)
                [fileName, pathName] = uiputfile('*.wav', 'Save the looped sample');
                if ~(isequal(fileName, 0) || isequal(pathName, 0))
                    progressBar = uiprogressdlg(app.LooperUIFigure, Message='Creating loop');
                    if (app.CompileCompleteLoop())
                        progressBar.Value = 0.8;
                        audiowrite(strcat(pathName, fileName), app.repeatedLoop, app.Fs, "Artist", "HugoSynth");
                        progressBar.Value = 1;
                        close(progressBar);
                    else
                        close(progressBar);
                        return;
                    end
                end
            end
        end

        % Callback function: LoopEndSlider, LoopEndSlider, LoopStartSlider,
        % 
        % ...and 3 other components
        function EnvelopeSliderValueChanged(app, event)
            app.UpdateCursors();
        end

        % Value changed function: InputAudioDeviceIDEditField
        function InputAudioDeviceIDEditFieldValueChanged(app, event)
            value = app.InputAudioDeviceIDEditField.Value;
            app.caller.inputDeviceID = value;
            CheckAudioDevice(app.caller);
            app.InputAudioDeviceIDEditField.Value = app.caller.inputDeviceID;
        end

        % Button pushed function: RecordSampleButton
        function RecordSampleButtonPushed(app, event)
            progressBar = uiprogressdlg(app.LooperUIFigure, Message='Creating recorder');

            CheckAudioDevice(app.caller);
            dirName = strcat(pwd, '/');
            fileName = strcat('Recording-', string(datetime('now', Format='MM-dd-yyyy-HH-mm-ss')), '.wav');
            app.recorder = audiorecorder(app.Fs, 24, 1, app.caller.inputDeviceID);

            progressBar.Value = 0.1;
            progressBar.Message = 'Recording 5-second sample';
            recordblocking(app.recorder, 5);

            progressBar.Value = 0.8;
            progressBar.Message = 'Saving recorded sample';
            recordedSample = getaudiodata(app.recorder);
            audiowrite(strcat(dirName, fileName), recordedSample, app.Fs, "Artist", "HugoSynth");
            progressBar.Value = 1;
            app.LoadFile(fileName, dirName);
            close(progressBar);
        end

        % Value changed function: ASlider, DSlider, RSlider, SLenSlider, 
        % ...and 1 other component
        function ADSRSlidersValueChanged(app, event)
            app.UpdateADSREnv();
        end

        % Menu selected function: SaveEnvelopeMenu
        function SaveEnvelopeMenuSelected(app, event)
            [fileName, pathName] = uiputfile('*.adsr', 'Save current ADSR envelope');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                A = app.ASlider.Value;
                D = app.DSlider.Value;
                S = app.SSlider.Value;
                R = app.RSlider.Value;
                SLen = app.SLenSlider.Value;
                env = [A D S R SLen];
                save(strcat(pathName, fileName), 'env', '-ascii');
            end
        end

        % Menu selected function: LoadEnvelopeMenu
        function LoadEnvelopeMenuSelected(app, event)
            [fileName, pathName] = uigetfile('*.adsr', 'Load an ADSR envelope');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                env = load(strcat(pathName, fileName), 'env', '-ascii');
                app.ASlider.Value = env(1);
                app.DSlider.Value = env(2);
                app.SSlider.Value = env(3);
                app.RSlider.Value = env(4);
                app.SLenSlider.Value = env(5);
                app.UpdateADSREnv();
            end
        end

        % Menu selected function: RefreshMenu
        function RefreshMenuSelected(app, event)
            app.ListGallery();
        end

        % Button pushed function: LoadExternalButton
        function LoadExternalButtonPushed(app, event)
            [fileName, pathName] = uigetfile('*.wav;*.mp3;*.flac', 'Load an external sample');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                app.LoadFile(fileName, pathName);
            end
        end

        % Close request function: LooperUIFigure
        function LooperUIFigureCloseRequest(app, event)
            app.caller.looperOpened = false;
            delete(app);
        end

        % Menu selected function: Track1Menu
        function Track1MenuSelected(app, event)
            app.SaveLoopToTrack(1);
        end

        % Menu selected function: Track2Menu
        function Track2MenuSelected(app, event)
            app.SaveLoopToTrack(2);
        end

        % Menu selected function: Track3Menu
        function Track3MenuSelected(app, event)
            app.SaveLoopToTrack(3);
        end

        % Menu selected function: Track4Menu
        function Track4MenuSelected(app, event)
            app.SaveLoopToTrack(4);
        end

        % Menu selected function: Track5Menu
        function Track5MenuSelected(app, event)
            app.SaveLoopToTrack(5);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create LooperUIFigure and hide until all components are created
            app.LooperUIFigure = uifigure('Visible', 'off');
            app.LooperUIFigure.Position = [100 100 674 579];
            app.LooperUIFigure.Name = 'Looper';
            app.LooperUIFigure.CloseRequestFcn = createCallbackFcn(app, @LooperUIFigureCloseRequest, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.LooperUIFigure);
            app.GridLayout.ColumnWidth = {'0.5x', '0.5x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '0.5x', '0.5x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 3;
            app.GridLayout.RowSpacing = 2;

            % Create ADSRAxes
            app.ADSRAxes = uiaxes(app.GridLayout);
            title(app.ADSRAxes, 'ADSR')
            app.ADSRAxes.Toolbar.Visible = 'off';
            app.ADSRAxes.XTickLabel = '';
            app.ADSRAxes.YTickLabel = '';
            app.ADSRAxes.XGrid = 'on';
            app.ADSRAxes.Layout.Row = [3 4];
            app.ADSRAxes.Layout.Column = 1;

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            title(app.UIAxes, 'Select a sample')
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XTickLabel = '';
            app.UIAxes.YTickLabel = '';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.Layout.Row = [2 4];
            app.UIAxes.Layout.Column = [2 4];

            % Create LoopConfigPanel
            app.LoopConfigPanel = uipanel(app.GridLayout);
            app.LoopConfigPanel.Enable = 'off';
            app.LoopConfigPanel.Title = 'Loop Config';
            app.LoopConfigPanel.Layout.Row = [5 7];
            app.LoopConfigPanel.Layout.Column = [3 4];
            app.LoopConfigPanel.FontSize = 14;

            % Create LoopStartLabel
            app.LoopStartLabel = uilabel(app.LoopConfigPanel);
            app.LoopStartLabel.FontSize = 10;
            app.LoopStartLabel.FontWeight = 'bold';
            app.LoopStartLabel.FontColor = [0 0 1];
            app.LoopStartLabel.Position = [4 176 114 22];
            app.LoopStartLabel.Text = 'Loop Start Position';

            % Create LoopStartSlider
            app.LoopStartSlider = uislider(app.LoopConfigPanel);
            app.LoopStartSlider.Limits = [10 1000];
            app.LoopStartSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.LoopStartSlider.ValueChangingFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.LoopStartSlider.FontSize = 10;
            app.LoopStartSlider.Position = [9 168 407 3];
            app.LoopStartSlider.Value = 10;

            % Create StartPositionSliderLabel
            app.StartPositionSliderLabel = uilabel(app.LoopConfigPanel);
            app.StartPositionSliderLabel.FontSize = 10;
            app.StartPositionSliderLabel.FontWeight = 'bold';
            app.StartPositionSliderLabel.Position = [4 234 98 22];
            app.StartPositionSliderLabel.Text = 'Start Position';

            % Create StartPositionSlider
            app.StartPositionSlider = uislider(app.LoopConfigPanel);
            app.StartPositionSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.StartPositionSlider.ValueChangingFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.StartPositionSlider.FontSize = 10;
            app.StartPositionSlider.Position = [9 227 407 3];

            % Create PlaySampleButton
            app.PlaySampleButton = uibutton(app.LoopConfigPanel, 'push');
            app.PlaySampleButton.ButtonPushedFcn = createCallbackFcn(app, @PlaySampleButtonPushed, true);
            app.PlaySampleButton.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.PlaySampleButton.HorizontalAlignment = 'left';
            app.PlaySampleButton.Position = [226 17 96 22];
            app.PlaySampleButton.Text = 'Play Sample';

            % Create SaveLoopButton
            app.SaveLoopButton = uibutton(app.LoopConfigPanel, 'push');
            app.SaveLoopButton.ButtonPushedFcn = createCallbackFcn(app, @SaveLoopButtonPushed, true);
            app.SaveLoopButton.Position = [326 17 100 22];
            app.SaveLoopButton.Text = 'Save Loop';

            % Create InputAudioDeviceIDEditFieldLabel
            app.InputAudioDeviceIDEditFieldLabel = uilabel(app.LoopConfigPanel);
            app.InputAudioDeviceIDEditFieldLabel.Position = [3 20 122 22];
            app.InputAudioDeviceIDEditFieldLabel.Text = 'Input Audio Device ID';

            % Create InputAudioDeviceIDEditField
            app.InputAudioDeviceIDEditField = uieditfield(app.LoopConfigPanel, 'numeric');
            app.InputAudioDeviceIDEditField.Limits = [-1 Inf];
            app.InputAudioDeviceIDEditField.RoundFractionalValues = 'on';
            app.InputAudioDeviceIDEditField.ValueDisplayFormat = '%d';
            app.InputAudioDeviceIDEditField.ValueChangedFcn = createCallbackFcn(app, @InputAudioDeviceIDEditFieldValueChanged, true);
            app.InputAudioDeviceIDEditField.HorizontalAlignment = 'center';
            app.InputAudioDeviceIDEditField.Position = [138 20 36 22];
            app.InputAudioDeviceIDEditField.Value = -1;

            % Create LoopStartLabel_2
            app.LoopStartLabel_2 = uilabel(app.LoopConfigPanel);
            app.LoopStartLabel_2.FontSize = 10;
            app.LoopStartLabel_2.FontWeight = 'bold';
            app.LoopStartLabel_2.FontColor = [0 0 1];
            app.LoopStartLabel_2.Position = [5 119 114 22];
            app.LoopStartLabel_2.Text = 'Loop End Position';

            % Create LoopEndSlider
            app.LoopEndSlider = uislider(app.LoopConfigPanel);
            app.LoopEndSlider.Limits = [10 1000];
            app.LoopEndSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.LoopEndSlider.ValueChangingFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.LoopEndSlider.FontSize = 10;
            app.LoopEndSlider.Position = [10 111 407 3];
            app.LoopEndSlider.Value = 1000;

            % Create RepeatSpinnerLabel
            app.RepeatSpinnerLabel = uilabel(app.LoopConfigPanel);
            app.RepeatSpinnerLabel.HorizontalAlignment = 'right';
            app.RepeatSpinnerLabel.Position = [281 48 44 22];
            app.RepeatSpinnerLabel.Text = 'Repeat';

            % Create RepeatSpinner
            app.RepeatSpinner = uispinner(app.LoopConfigPanel);
            app.RepeatSpinner.Limits = [0 Inf];
            app.RepeatSpinner.RoundFractionalValues = 'on';
            app.RepeatSpinner.ValueDisplayFormat = '%d times';
            app.RepeatSpinner.Position = [332 48 100 22];
            app.RepeatSpinner.Value = 1;

            % Create ADSREnvelopePanel
            app.ADSREnvelopePanel = uipanel(app.GridLayout);
            app.ADSREnvelopePanel.Enable = 'off';
            app.ADSREnvelopePanel.Title = 'ADSR Envelope';
            app.ADSREnvelopePanel.Layout.Row = [5 7];
            app.ADSREnvelopePanel.Layout.Column = [1 2];
            app.ADSREnvelopePanel.FontSize = 14;

            % Create AttackLabel
            app.AttackLabel = uilabel(app.ADSREnvelopePanel);
            app.AttackLabel.FontWeight = 'bold';
            app.AttackLabel.Position = [19 236 88 22];
            app.AttackLabel.Text = 'Attack';

            % Create DecayLabel
            app.DecayLabel = uilabel(app.ADSREnvelopePanel);
            app.DecayLabel.FontWeight = 'bold';
            app.DecayLabel.Position = [19 188 88 22];
            app.DecayLabel.Text = 'Decay';

            % Create SustainLabel
            app.SustainLabel = uilabel(app.ADSREnvelopePanel);
            app.SustainLabel.FontWeight = 'bold';
            app.SustainLabel.Position = [19 140 88 22];
            app.SustainLabel.Text = 'Sustain';

            % Create SLenLabel
            app.SLenLabel = uilabel(app.ADSREnvelopePanel);
            app.SLenLabel.FontWeight = 'bold';
            app.SLenLabel.Position = [19 92 88 22];
            app.SLenLabel.Text = 'S. Len.';

            % Create ReleaseLabel
            app.ReleaseLabel = uilabel(app.ADSREnvelopePanel);
            app.ReleaseLabel.FontWeight = 'bold';
            app.ReleaseLabel.Position = [19 44 88 22];
            app.ReleaseLabel.Text = 'Release';

            % Create ASlider
            app.ASlider = uislider(app.ADSREnvelopePanel);
            app.ASlider.Limits = [0 1];
            app.ASlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.ASlider.FontSize = 10;
            app.ASlider.Position = [7 234 202 3];

            % Create DSlider
            app.DSlider = uislider(app.ADSREnvelopePanel);
            app.DSlider.Limits = [0 1];
            app.DSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.DSlider.FontSize = 10;
            app.DSlider.Position = [7 186 202 3];

            % Create SSlider
            app.SSlider = uislider(app.ADSREnvelopePanel);
            app.SSlider.Limits = [0 1];
            app.SSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.SSlider.FontSize = 10;
            app.SSlider.Position = [7 138 202 3];
            app.SSlider.Value = 1;

            % Create SLenSlider
            app.SLenSlider = uislider(app.ADSREnvelopePanel);
            app.SLenSlider.Limits = [0.1 1.5];
            app.SLenSlider.MajorTicks = [0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5];
            app.SLenSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.SLenSlider.FontSize = 10;
            app.SLenSlider.Position = [7 90 202 3];
            app.SLenSlider.Value = 1;

            % Create RSlider
            app.RSlider = uislider(app.ADSREnvelopePanel);
            app.RSlider.Limits = [0 1];
            app.RSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.RSlider.FontSize = 10;
            app.RSlider.Position = [7 42 203 3];

            % Create Gallery
            app.Gallery = uipanel(app.GridLayout);
            app.Gallery.AutoResizeChildren = 'off';
            app.Gallery.Title = 'Gallery';
            app.Gallery.BackgroundColor = [0.902 0.902 0.902];
            app.Gallery.Layout.Row = 1;
            app.Gallery.Layout.Column = [1 4];

            % Create UtilitiesPanel
            app.UtilitiesPanel = uipanel(app.GridLayout);
            app.UtilitiesPanel.Title = 'Utilities';
            app.UtilitiesPanel.Layout.Row = 2;
            app.UtilitiesPanel.Layout.Column = 1;

            % Create LoadExternalButton
            app.LoadExternalButton = uibutton(app.UtilitiesPanel, 'push');
            app.LoadExternalButton.ButtonPushedFcn = createCallbackFcn(app, @LoadExternalButtonPushed, true);
            app.LoadExternalButton.Position = [4 42 100 22];
            app.LoadExternalButton.Text = 'Load External';

            % Create RecordSampleButton
            app.RecordSampleButton = uibutton(app.UtilitiesPanel, 'push');
            app.RecordSampleButton.ButtonPushedFcn = createCallbackFcn(app, @RecordSampleButtonPushed, true);
            app.RecordSampleButton.Position = [4 12 100 22];
            app.RecordSampleButton.Text = 'Record Sample';

            % Create ADSRContextMenu
            app.ADSRContextMenu = uicontextmenu(app.LooperUIFigure);

            % Create SaveEnvelopeMenu
            app.SaveEnvelopeMenu = uimenu(app.ADSRContextMenu);
            app.SaveEnvelopeMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveEnvelopeMenuSelected, true);
            app.SaveEnvelopeMenu.Text = 'Save Envelope';

            % Create LoadEnvelopeMenu
            app.LoadEnvelopeMenu = uimenu(app.ADSRContextMenu);
            app.LoadEnvelopeMenu.MenuSelectedFcn = createCallbackFcn(app, @LoadEnvelopeMenuSelected, true);
            app.LoadEnvelopeMenu.Text = 'Load Envelope';
            
            % Assign app.ADSRContextMenu
            app.ADSREnvelopePanel.ContextMenu = app.ADSRContextMenu;
            app.AttackLabel.ContextMenu = app.ADSRContextMenu;
            app.DecayLabel.ContextMenu = app.ADSRContextMenu;
            app.SustainLabel.ContextMenu = app.ADSRContextMenu;
            app.SLenLabel.ContextMenu = app.ADSRContextMenu;
            app.ReleaseLabel.ContextMenu = app.ADSRContextMenu;
            app.ASlider.ContextMenu = app.ADSRContextMenu;
            app.DSlider.ContextMenu = app.ADSRContextMenu;
            app.SSlider.ContextMenu = app.ADSRContextMenu;
            app.SLenSlider.ContextMenu = app.ADSRContextMenu;
            app.RSlider.ContextMenu = app.ADSRContextMenu;
            app.ADSRAxes.ContextMenu = app.ADSRContextMenu;

            % Create GalleryContextMenu
            app.GalleryContextMenu = uicontextmenu(app.LooperUIFigure);

            % Create RefreshMenu
            app.RefreshMenu = uimenu(app.GalleryContextMenu);
            app.RefreshMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshMenuSelected, true);
            app.RefreshMenu.Text = 'Refresh';
            
            % Assign app.GalleryContextMenu
            app.Gallery.ContextMenu = app.GalleryContextMenu;

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.LooperUIFigure);

            % Create SaveinMenu
            app.SaveinMenu = uimenu(app.ContextMenu);
            app.SaveinMenu.Text = 'Save in...';

            % Create Track1Menu
            app.Track1Menu = uimenu(app.SaveinMenu);
            app.Track1Menu.MenuSelectedFcn = createCallbackFcn(app, @Track1MenuSelected, true);
            app.Track1Menu.Text = 'Track 1';

            % Create Track2Menu
            app.Track2Menu = uimenu(app.SaveinMenu);
            app.Track2Menu.MenuSelectedFcn = createCallbackFcn(app, @Track2MenuSelected, true);
            app.Track2Menu.Text = 'Track 2';

            % Create Track3Menu
            app.Track3Menu = uimenu(app.SaveinMenu);
            app.Track3Menu.MenuSelectedFcn = createCallbackFcn(app, @Track3MenuSelected, true);
            app.Track3Menu.Text = 'Track 3';

            % Create Track4Menu
            app.Track4Menu = uimenu(app.SaveinMenu);
            app.Track4Menu.MenuSelectedFcn = createCallbackFcn(app, @Track4MenuSelected, true);
            app.Track4Menu.Text = 'Track 4';

            % Create Track5Menu
            app.Track5Menu = uimenu(app.SaveinMenu);
            app.Track5Menu.MenuSelectedFcn = createCallbackFcn(app, @Track5MenuSelected, true);
            app.Track5Menu.Text = 'Track 5';
            
            % Assign app.ContextMenu
            app.UIAxes.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.LooperUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Looper(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.LooperUIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.LooperUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.LooperUIFigure)
        end
    end
end