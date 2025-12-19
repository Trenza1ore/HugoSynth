classdef GrainPicker < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        GrainPickerUIFigure          matlab.ui.Figure
        GridLayout                   matlab.ui.container.GridLayout
        Gallery                      matlab.ui.container.Panel
        SampleFolderPanel            matlab.ui.container.Panel
        DirListBox                   matlab.ui.control.ListBox
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
        GrainPickerPanel             matlab.ui.container.Panel
        RecordSampleButton           matlab.ui.control.Button
        InputAudioDeviceIDEditField  matlab.ui.control.NumericEditField
        InputAudioDeviceIDEditFieldLabel  matlab.ui.control.Label
        SaveasGrainSpinner           matlab.ui.control.Spinner
        SaveasGrainSpinnerLabel      matlab.ui.control.Label
        SaveGrainButton              matlab.ui.control.Button
        PlayGrainButton              matlab.ui.control.Button
        PositionSlider               matlab.ui.control.Slider
        PositionSliderLabel          matlab.ui.control.Label
        GrainSizeSlider              matlab.ui.control.Slider
        GrainSizeinmsSliderLabel     matlab.ui.control.Label
        ADSRAxes                     matlab.ui.control.UIAxes
        UIAxes                       matlab.ui.control.UIAxes
        SampleDirContextMenu         matlab.ui.container.ContextMenu
        LoadDirectoryMenu            matlab.ui.container.Menu
        RefreshDirectoryMenu         matlab.ui.container.Menu
        ADSRContextMenu              matlab.ui.container.ContextMenu
        SaveEnvelopeMenu             matlab.ui.container.Menu
        LoadEnvelopeMenu             matlab.ui.container.Menu
        GalleryContextMenu           matlab.ui.container.ContextMenu
        RefreshMenu                  matlab.ui.container.Menu
    end

    
    properties (Access = private)
        loop
        player = audioplayer([0 0 0], 44100);
        Fs
        wavePlot
        loopCursor

        sample
        sampleDir 
        sampleDirLoaded = false;
        sampleLooped;
        sampleLoaded = false;
        caller
        channel
        sampleLen;

        grainSize = 0;
        isRecording = false;
        recorder;
    end

    properties (Access = public)
        maxGrainNum = 14;
        galleryDir = strcat(pwd, '/Grains/');
        grainExists = zeros(1, 14);
        grainAxes = cell(14, 1);
        grains = cell(14, 1);
        currentGrainNum = 14;
        cursorY = [1 1 -1 -1 1];
        loopCursorX = [0 1 1 0 0];
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
                else
                    app.currentGrainNum = min(app.currentGrainNum, i);
                end
                xlabel(app.grainAxes{i}, '');
                ylabel(app.grainAxes{i}, '');
                xticklabels(app.grainAxes{i}, '');
                yticklabels(app.grainAxes{i}, '');
                title(app.grainAxes{i}, name);
                app.grainAxes{i}.Toolbar.Visible = 'off';
                disableDefaultInteractivity(app.grainAxes{i});
            end
            app.SaveasGrainSpinner.Value = app.currentGrainNum;
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

        function UpdateEnvelope(app, pos, grainSize)
            app.grainSize = floor(grainSize * app.Fs / 1000);
            loopEnd = min(pos + app.grainSize, app.sampleLen);

            app.loopCursorX([1 4 5]) = pos;
            app.loopCursorX([2 3]) = loopEnd;

            app.RefreshEnvelopePlots();
        end

        function MoveEnvelopePos(app, pos)
            loopEnd = min(pos + app.grainSize, app.sampleLen);
            app.loopCursorX([1 4 5]) = pos;
            app.loopCursorX([2 3]) = loopEnd;
            refreshdata(app.loopCursor, 'caller');
        end

        function RefreshEnvelopePlots(app)
            refreshdata(app.loopCursor, 'caller');
        end

        function LoadDir(app)
            pathName = uigetdir('', 'Select a directory');
            if (isequal(pathName, 0))
            else
                app.sampleDir = pathName;
                app.ListDirSamples();
                app.sampleDirLoaded = true;
            end
        end

        function ListDirSamples(app)
            allFileNames = {dir(strcat(app.sampleDir, '/*.wav')).name 
                dir(strcat(app.sampleDir, '/*.mp3')).name 
                dir(strcat(app.sampleDir, '/*.flac')).name};
            app.DirListBox.Items = allFileNames;
        end

        function LoadFile(app, fileName)
            %[fileName, pathName] = uigetfile('*.wav;*.mp3;*.flac', 'Select a sample');
            if ~(isequal(fileName, 0) || isequal(app.sampleDir, 0))
                [trackAudio, trackFs, error] = ReadAudioWithException(app, strcat(app.sampleDir, '/', fileName));
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
                app.sampleLen = size(app.sample, 1);
                limit = [1 app.sampleLen];
                app.UIAxes.XLim = limit;
                app.UIAxes.YLim = [-1 1];
                title(app.UIAxes, fileName, 'Interpreter', 'none');

                app.PositionSlider.Limits = limit;

                app.PositionSlider.Value = 1;

                if (app.sampleLen < 10 * app.Fs)
                    xtickVal = 1:app.Fs/2:app.sampleLen;
                    xticklabelVal = string(0:0.5:app.sampleLen/app.Fs);
                elseif (app.sampleLen < 100 * app.Fs)
                    xtickVal = 1:5*app.Fs:app.sampleLen;
                    xticklabelVal = string(0:5:app.sampleLen/app.Fs);
                else
                    xtickVal = 1:10*app.Fs:app.sampleLen;
                    xticklabelVal = string(0:10:app.sampleLen/app.Fs);
                end
                
                xticks(app.UIAxes, xtickVal);
                app.PositionSlider.MajorTicks = xtickVal;

                xticklabels(app.UIAxes, xticklabelVal);
                app.PositionSlider.MajorTickLabels = xticklabelVal;

                app.wavePlot = scatter(app.UIAxes, 1:app.sampleLen, app.sample, 20, 'c', 'filled');
                
                hold(app.UIAxes, "on");
                app.loopCursor = plot(app.UIAxes, app.loopCursorX, app.cursorY, "LineWidth", 2, "Color", 'b');
                app.loopCursor.XDataSource = "app.loopCursorX";
                app.loopCursor.YDataSource = "app.cursorY";
                hold(app.UIAxes, "off");

                app.MoveEnvelopePos(1);

                app.GrainPickerPanel.Enable = "on";
                app.ADSREnvelopePanel.Enable = "on";
            end
        end

        function Play(app, id)
            if (app.grainExists(id))
                app.CreatePlayer(app.grains{id}, 0);
                resume(app.player);
            end
        end

        function Play1(app); app.Play(1); end
        function Play2(app); app.Play(2); end
        function Play3(app); app.Play(3); end
        function Play4(app); app.Play(4); end
        function Play5(app); app.Play(5); end
        function Play6(app); app.Play(6); end
        function Play7(app); app.Play(7); end
        function Play8(app); app.Play(8); end
        function Play9(app); app.Play(9); end
        function Play10(app); app.Play(10); end
        function Play11(app); app.Play(11); end
        function Play12(app); app.Play(12); end
        function Play13(app); app.Play(13); end
        function Play14(app); app.Play(14); end
        % Unused (not enough space in the menu...)
        function Play15(app); app.Play(15); end
        function Play16(app); app.Play(16); end
        function Play17(app); app.Play(17); end
        function Play18(app); app.Play(18); end
        function Play19(app); app.Play(19); end

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
            app.grainSize = app.Fs / 100;
            app.UpdateADSREnv();
            app.caller.grainPickerOpened = true;
        end

        % Menu selected function: LoadDirectoryMenu
        function LoadDirectoryMenuSelected(app, event)
            app.LoadDir();
        end

        % Value changed function: DirListBox
        function DirListBoxValueChanged(app, event)
            value = app.DirListBox.Value;
            app.LoadFile(value);
        end

        % Button pushed function: PlayGrainButton
        function PlayGrainButtonPushed(app, event)
            app.CompileSampleLoop();
            app.CreatePlayer(app.loop, 0);
            resume(app.player);
        end

        % Button pushed function: SaveGrainButton
        function SaveGrainButtonPushed(app, event)
            grainID = app.SaveasGrainSpinner.Value;
            if (app.grainExists(grainID) && isequal(questdlg( ...
                'This grain slot is already occupied, do you want to overwrite it?', ...
                'Overwrite Confirmation', 'Yes', 'No', 'No'), 'No'))
                return;
            else
                progressBar = uiprogressdlg(app.GrainPickerUIFigure, Message='Saving Grain');
                app.CompileSampleLoop();
                progressBar.Value = 0.8;
                if (~isfolder(app.galleryDir))
                    mkdir(app.galleryDir);
                end
                fileName = strcat(app.galleryDir, string(grainID), '.wav');
                audiowrite(fileName, app.loop, app.Fs, "Artist", "HugoSynth");
                app.ListGallery();
                progressBar.Value = 1;
                close(progressBar);
            end
        end

        % Value changed function: GrainSizeSlider, PositionSlider
        function EnvelopeSliderValueChanged(app, event)
            app.UpdateEnvelope(app.PositionSlider.Value, app.GrainSizeSlider.Value);
        end

        % Value changing function: PositionSlider
        function PositionSliderValueChanging(app, event)
            changingValue = event.Value;
            app.MoveEnvelopePos(changingValue);
        end

        % Value changing function: GrainSizeSlider
        function GrainSizeSliderValueChanging(app, event)
            changingValue = event.Value;
            app.UpdateEnvelope(app.PositionSlider.Value, changingValue);
        end

        % Value changed function: InputAudioDeviceIDEditField
        function InputAudioDeviceIDEditFieldValueChanged(app, event)
            value = app.InputAudioDeviceIDEditField.Value;
            app.caller.inputDeviceID = value;
            CheckAudioDevice(app.caller);
            app.InputAudioDeviceIDEditField.Value = app.caller.inputDeviceID;
        end

        % Menu selected function: RefreshDirectoryMenu
        function RefreshDirectoryMenuSelected(app, event)
            if (app.sampleDirLoaded)
                app.ListDirSamples();
            end
        end

        % Button pushed function: RecordSampleButton
        function RecordSampleButtonPushed(app, event)
            progressBar = uiprogressdlg(app.GrainPickerUIFigure, Message='Creating recorder');

            CheckAudioDevice(app.caller);
            dirName = strcat(app.sampleDir, '/');
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
            app.LoadFile(fileName);
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

        % Close request function: GrainPickerUIFigure
        function GrainPickerUIFigureCloseRequest(app, event)
            app.caller.grainPickerOpened = false;
            delete(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create GrainPickerUIFigure and hide until all components are created
            app.GrainPickerUIFigure = uifigure('Visible', 'off');
            app.GrainPickerUIFigure.Position = [100 100 672 657];
            app.GrainPickerUIFigure.Name = 'Grain Picker';
            app.GrainPickerUIFigure.CloseRequestFcn = createCallbackFcn(app, @GrainPickerUIFigureCloseRequest, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.GrainPickerUIFigure);
            app.GridLayout.ColumnWidth = {'0.5x', '0.5x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '0.5x', '0.5x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 3;
            app.GridLayout.RowSpacing = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            title(app.UIAxes, 'Select a sample')
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XTickLabel = '';
            app.UIAxes.YTickLabel = '';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.Layout.Row = [1 3];
            app.UIAxes.Layout.Column = [2 4];

            % Create GrainPickerPanel
            app.GrainPickerPanel = uipanel(app.GridLayout);
            app.GrainPickerPanel.Enable = 'off';
            app.GrainPickerPanel.Title = 'Grain Picker';
            app.GrainPickerPanel.Layout.Row = [6 8];
            app.GrainPickerPanel.Layout.Column = [3 4];
            app.GrainPickerPanel.FontSize = 14;

            % Create ADSRAxes
            app.ADSRAxes = uiaxes(app.GrainPickerPanel);
            title(app.ADSRAxes, 'ADSR')
            app.ADSRAxes.Toolbar.Visible = 'off';
            app.ADSRAxes.XTickLabel = '';
            app.ADSRAxes.YTickLabel = '';
            app.ADSRAxes.XGrid = 'on';
            app.ADSRAxes.Position = [1 8 228 128];

            % Create GrainSizeinmsSliderLabel
            app.GrainSizeinmsSliderLabel = uilabel(app.GrainPickerPanel);
            app.GrainSizeinmsSliderLabel.FontSize = 10;
            app.GrainSizeinmsSliderLabel.FontWeight = 'bold';
            app.GrainSizeinmsSliderLabel.FontColor = [0 0 1];
            app.GrainSizeinmsSliderLabel.Position = [4 169 114 22];
            app.GrainSizeinmsSliderLabel.Text = 'Grain Size (in ms)';

            % Create GrainSizeSlider
            app.GrainSizeSlider = uislider(app.GrainPickerPanel);
            app.GrainSizeSlider.Limits = [10 1000];
            app.GrainSizeSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.GrainSizeSlider.ValueChangingFcn = createCallbackFcn(app, @GrainSizeSliderValueChanging, true);
            app.GrainSizeSlider.FontSize = 10;
            app.GrainSizeSlider.Position = [9 161 407 3];
            app.GrainSizeSlider.Value = 10;

            % Create PositionSliderLabel
            app.PositionSliderLabel = uilabel(app.GrainPickerPanel);
            app.PositionSliderLabel.FontSize = 10;
            app.PositionSliderLabel.FontWeight = 'bold';
            app.PositionSliderLabel.Position = [4 227 98 22];
            app.PositionSliderLabel.Text = 'Position';

            % Create PositionSlider
            app.PositionSlider = uislider(app.GrainPickerPanel);
            app.PositionSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.PositionSlider.ValueChangingFcn = createCallbackFcn(app, @PositionSliderValueChanging, true);
            app.PositionSlider.FontSize = 10;
            app.PositionSlider.Position = [9 220 407 3];

            % Create PlayGrainButton
            app.PlayGrainButton = uibutton(app.GrainPickerPanel, 'push');
            app.PlayGrainButton.ButtonPushedFcn = createCallbackFcn(app, @PlayGrainButtonPushed, true);
            app.PlayGrainButton.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.PlayGrainButton.HorizontalAlignment = 'left';
            app.PlayGrainButton.Position = [228 10 91 22];
            app.PlayGrainButton.Text = 'Play Grain';

            % Create SaveGrainButton
            app.SaveGrainButton = uibutton(app.GrainPickerPanel, 'push');
            app.SaveGrainButton.ButtonPushedFcn = createCallbackFcn(app, @SaveGrainButtonPushed, true);
            app.SaveGrainButton.Position = [326 10 100 22];
            app.SaveGrainButton.Text = 'Save Grain';

            % Create SaveasGrainSpinnerLabel
            app.SaveasGrainSpinnerLabel = uilabel(app.GrainPickerPanel);
            app.SaveasGrainSpinnerLabel.HorizontalAlignment = 'right';
            app.SaveasGrainSpinnerLabel.Position = [339 58 80 22];
            app.SaveasGrainSpinnerLabel.Text = 'Save as Grain';

            % Create SaveasGrainSpinner
            app.SaveasGrainSpinner = uispinner(app.GrainPickerPanel);
            app.SaveasGrainSpinner.Limits = [1 14];
            app.SaveasGrainSpinner.RoundFractionalValues = 'on';
            app.SaveasGrainSpinner.ValueDisplayFormat = '%d';
            app.SaveasGrainSpinner.Position = [326 37 100 22];
            app.SaveasGrainSpinner.Value = 1;

            % Create InputAudioDeviceIDEditFieldLabel
            app.InputAudioDeviceIDEditFieldLabel = uilabel(app.GrainPickerPanel);
            app.InputAudioDeviceIDEditFieldLabel.Position = [255 81 122 22];
            app.InputAudioDeviceIDEditFieldLabel.Text = 'Input Audio Device ID';

            % Create InputAudioDeviceIDEditField
            app.InputAudioDeviceIDEditField = uieditfield(app.GrainPickerPanel, 'numeric');
            app.InputAudioDeviceIDEditField.Limits = [-1 Inf];
            app.InputAudioDeviceIDEditField.RoundFractionalValues = 'on';
            app.InputAudioDeviceIDEditField.ValueDisplayFormat = '%d';
            app.InputAudioDeviceIDEditField.ValueChangedFcn = createCallbackFcn(app, @InputAudioDeviceIDEditFieldValueChanged, true);
            app.InputAudioDeviceIDEditField.HorizontalAlignment = 'center';
            app.InputAudioDeviceIDEditField.Position = [390 81 36 22];
            app.InputAudioDeviceIDEditField.Value = -1;

            % Create RecordSampleButton
            app.RecordSampleButton = uibutton(app.GrainPickerPanel, 'push');
            app.RecordSampleButton.ButtonPushedFcn = createCallbackFcn(app, @RecordSampleButtonPushed, true);
            app.RecordSampleButton.Position = [228 37 91 22];
            app.RecordSampleButton.Text = 'Record Sample';

            % Create ADSREnvelopePanel
            app.ADSREnvelopePanel = uipanel(app.GridLayout);
            app.ADSREnvelopePanel.Enable = 'off';
            app.ADSREnvelopePanel.Title = 'ADSR Envelope';
            app.ADSREnvelopePanel.Layout.Row = [6 8];
            app.ADSREnvelopePanel.Layout.Column = [1 2];
            app.ADSREnvelopePanel.FontSize = 14;

            % Create AttackLabel
            app.AttackLabel = uilabel(app.ADSREnvelopePanel);
            app.AttackLabel.FontWeight = 'bold';
            app.AttackLabel.Position = [19 229 88 22];
            app.AttackLabel.Text = 'Attack';

            % Create DecayLabel
            app.DecayLabel = uilabel(app.ADSREnvelopePanel);
            app.DecayLabel.FontWeight = 'bold';
            app.DecayLabel.Position = [19 181 88 22];
            app.DecayLabel.Text = 'Decay';

            % Create SustainLabel
            app.SustainLabel = uilabel(app.ADSREnvelopePanel);
            app.SustainLabel.FontWeight = 'bold';
            app.SustainLabel.Position = [19 133 88 22];
            app.SustainLabel.Text = 'Sustain';

            % Create SLenLabel
            app.SLenLabel = uilabel(app.ADSREnvelopePanel);
            app.SLenLabel.FontWeight = 'bold';
            app.SLenLabel.Position = [19 85 88 22];
            app.SLenLabel.Text = 'S. Len.';

            % Create ReleaseLabel
            app.ReleaseLabel = uilabel(app.ADSREnvelopePanel);
            app.ReleaseLabel.FontWeight = 'bold';
            app.ReleaseLabel.Position = [19 37 88 22];
            app.ReleaseLabel.Text = 'Release';

            % Create ASlider
            app.ASlider = uislider(app.ADSREnvelopePanel);
            app.ASlider.Limits = [0 1];
            app.ASlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.ASlider.FontSize = 10;
            app.ASlider.Position = [7 227 202 3];

            % Create DSlider
            app.DSlider = uislider(app.ADSREnvelopePanel);
            app.DSlider.Limits = [0 1];
            app.DSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.DSlider.FontSize = 10;
            app.DSlider.Position = [7 179 202 3];

            % Create SSlider
            app.SSlider = uislider(app.ADSREnvelopePanel);
            app.SSlider.Limits = [0 1];
            app.SSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.SSlider.FontSize = 10;
            app.SSlider.Position = [7 131 202 3];
            app.SSlider.Value = 1;

            % Create SLenSlider
            app.SLenSlider = uislider(app.ADSREnvelopePanel);
            app.SLenSlider.Limits = [0.1 1.5];
            app.SLenSlider.MajorTicks = [0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5];
            app.SLenSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.SLenSlider.FontSize = 10;
            app.SLenSlider.Position = [7 83 202 3];
            app.SLenSlider.Value = 1;

            % Create RSlider
            app.RSlider = uislider(app.ADSREnvelopePanel);
            app.RSlider.Limits = [0 1];
            app.RSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.RSlider.FontSize = 10;
            app.RSlider.Position = [7 35 202 3];

            % Create SampleFolderPanel
            app.SampleFolderPanel = uipanel(app.GridLayout);
            app.SampleFolderPanel.Title = 'Sample Folder';
            app.SampleFolderPanel.Layout.Row = [1 3];
            app.SampleFolderPanel.Layout.Column = 1;
            app.SampleFolderPanel.FontSize = 14;

            % Create DirListBox
            app.DirListBox = uilistbox(app.SampleFolderPanel);
            app.DirListBox.Items = {};
            app.DirListBox.ValueChangedFcn = createCallbackFcn(app, @DirListBoxValueChanged, true);
            app.DirListBox.BackgroundColor = [0.8 0.8 0.8];
            app.DirListBox.Position = [0 0 106 250];
            app.DirListBox.Value = {};

            % Create Gallery
            app.Gallery = uipanel(app.GridLayout);
            app.Gallery.AutoResizeChildren = 'off';
            app.Gallery.Title = 'Gallery';
            app.Gallery.BackgroundColor = [0.902 0.902 0.902];
            app.Gallery.Layout.Row = [4 5];
            app.Gallery.Layout.Column = [1 4];

            % Create SampleDirContextMenu
            app.SampleDirContextMenu = uicontextmenu(app.GrainPickerUIFigure);

            % Create LoadDirectoryMenu
            app.LoadDirectoryMenu = uimenu(app.SampleDirContextMenu);
            app.LoadDirectoryMenu.MenuSelectedFcn = createCallbackFcn(app, @LoadDirectoryMenuSelected, true);
            app.LoadDirectoryMenu.Text = 'Load Directory';

            % Create RefreshDirectoryMenu
            app.RefreshDirectoryMenu = uimenu(app.SampleDirContextMenu);
            app.RefreshDirectoryMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshDirectoryMenuSelected, true);
            app.RefreshDirectoryMenu.Text = 'Refresh Directory';
            
            % Assign app.SampleDirContextMenu
            app.DirListBox.ContextMenu = app.SampleDirContextMenu;

            % Create ADSRContextMenu
            app.ADSRContextMenu = uicontextmenu(app.GrainPickerUIFigure);

            % Create SaveEnvelopeMenu
            app.SaveEnvelopeMenu = uimenu(app.ADSRContextMenu);
            app.SaveEnvelopeMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveEnvelopeMenuSelected, true);
            app.SaveEnvelopeMenu.Text = 'Save Envelope';

            % Create LoadEnvelopeMenu
            app.LoadEnvelopeMenu = uimenu(app.ADSRContextMenu);
            app.LoadEnvelopeMenu.MenuSelectedFcn = createCallbackFcn(app, @LoadEnvelopeMenuSelected, true);
            app.LoadEnvelopeMenu.Text = 'Load Envelope';
            
            % Assign app.ADSRContextMenu
            app.ADSRAxes.ContextMenu = app.ADSRContextMenu;
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

            % Create GalleryContextMenu
            app.GalleryContextMenu = uicontextmenu(app.GrainPickerUIFigure);

            % Create RefreshMenu
            app.RefreshMenu = uimenu(app.GalleryContextMenu);
            app.RefreshMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshMenuSelected, true);
            app.RefreshMenu.Text = 'Refresh';
            
            % Assign app.GalleryContextMenu
            app.Gallery.ContextMenu = app.GalleryContextMenu;

            % Show the figure after all components are created
            app.GrainPickerUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GrainPicker(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.GrainPickerUIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.GrainPickerUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.GrainPickerUIFigure)
        end
    end
end