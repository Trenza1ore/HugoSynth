classdef Notvum < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        NotvumUIFigure            matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        Gallery                   matlab.ui.container.Panel
        ADSREnvelopePanel         matlab.ui.container.Panel
        RSlider                   matlab.ui.control.Slider
        SLenSlider                matlab.ui.control.Slider
        SSlider                   matlab.ui.control.Slider
        DSlider                   matlab.ui.control.Slider
        ASlider                   matlab.ui.control.Slider
        ReleaseLabel              matlab.ui.control.Label
        SLenLabel                 matlab.ui.control.Label
        SustainLabel              matlab.ui.control.Label
        DecayLabel                matlab.ui.control.Label
        AttackLabel               matlab.ui.control.Label
        GrainPickerPanel          matlab.ui.container.Panel
        SaveasCustomNameLabel     matlab.ui.control.Label
        NewTrackNameEditField     matlab.ui.control.EditField
        SaveasTrackSpinner        matlab.ui.control.Spinner
        SaveasTrackSpinnerLabel   matlab.ui.control.Label
        SaveTrackButton           matlab.ui.control.Button
        PlayGrainButton           matlab.ui.control.Button
        PositionSlider            matlab.ui.control.Slider
        PositionSliderLabel       matlab.ui.control.Label
        GrainSizeSlider           matlab.ui.control.Slider
        GrainSizeinmsSliderLabel  matlab.ui.control.Label
        ADSRAxes                  matlab.ui.control.UIAxes
        UIAxes                    matlab.ui.control.UIAxes
        ADSRContextMenu           matlab.ui.container.ContextMenu
        SaveEnvelopeMenu          matlab.ui.container.Menu
        LoadEnvelopeMenu          matlab.ui.container.Menu
        GalleryContextMenu        matlab.ui.container.ContextMenu
        RefreshMenu               matlab.ui.container.Menu
    end

    
    properties (Access = private)
        loop
        player = audioplayer(zeros(44100, 1), 44100);
        Fs
        wavePlot
        loopCursor

        sample
        caller
        channel
        sampleLen;

        grainSize = 0;
        isRecording = false;
        recorder;

        modulator;
        modulatorLen;

        convTrack;
        convTrackCompiled = false;
    end

    properties (Access = public)
        modulatorLoaded = false;
        sampleLoaded = false;
        maxGrainNum = 14;
        galleryDir = strcat(pwd, '/Grains/');
        grainExists = zeros(1, 14);
        grainAxes = cell(14, 1);
        grains = cell(14, 1);
        cursorY = [1 1 -1 -1 1];
        loopCursorX = [1 1 1 0 0];
    end

    methods (Access = public)
        function ChangeHighlight(app, track, trackLen, trackFs)
            pause(app.player);
            app.modulator = track;
            app.modulatorLen = trackLen;
            app.Fs = trackFs;
            app.ListGallery();
            app.modulatorLoaded = true;
            app.convTrackCompiled = false;
        end

        function track = GetConvTrack(app)
            if (~app.convTrackCompiled)
                app.convTrack = MyConv(app.modulator, app.loop, app.modulatorLen, size(app.loop, 1));
            end
            app.convTrackCompiled = true;
            track = app.convTrack;
        end

        function compiledTrack = GetCompiledTrack(app)
            if (app.modulatorLoaded)
                if (app.sampleLoaded)
                    app.CompileSampleLoop();
                    compiledTrack = app.GetConvTrack();
                else
                    compiledTrack = app.modulator;
                end
            % There is a bug! This method shouldn't be called
            else
                app.NotvumUIFigureCloseRequest();
            end
        end
    end
    
    methods (Access = private)
        function GrainChanged(app, varargin)
            app.convTrackCompiled = false;
        end

        % This cannot be saved as an external function due to Matlab's limitations
        function ListGallery(app)
            for i = 1:app.maxGrainNum
                name = string(i);
                fileName = strcat(app.galleryDir, name, '.wav');
                callBackFunc = createCallbackFcn(app, str2func(strcat('Play', name)), false);
                app.grainAxes{i} = subplot(1, app.maxGrainNum, i, 'Parent', app.Gallery, 'ButtonDownFcn', callBackFunc);
                if (isfile(fileName))
                    app.grainExists(i) = true;
                    [g, gFs] = audioread(fileName);
                    g = resample(g, app.Fs, gFs);
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
            app.GrainChanged();

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
            app.GrainChanged();

            app.grainSize = floor(grainSize * app.Fs / 1000);
            loopEnd = min(pos + app.grainSize, app.sampleLen);

            app.loopCursorX([1 4 5]) = pos;
            app.loopCursorX([2 3]) = loopEnd;

            app.RefreshEnvelopePlots();
        end

        function MoveEnvelopePos(app, pos)
            app.GrainChanged();

            loopEnd = min(pos + app.grainSize, app.sampleLen);
            app.loopCursorX([1 4 5]) = pos;
            app.loopCursorX([2 3]) = loopEnd;
            refreshdata(app.loopCursor, 'caller');
        end

        function RefreshEnvelopePlots(app)
            refreshdata(app.loopCursor, 'caller');
        end

        function LoadFile(app, fileName, pathName)
            %[fileName, pathName] = uigetfile('*.wav;*.mp3;*.flac', 'Select a sample');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                [trackAudio, trackFs, error] = ReadAudioWithException(app, strcat(pathName, fileName));
                if (error) return; end % Stop loading if the audio file is invalid

                app.GrainChanged();

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
                app.sampleLoaded = true;
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
                if (app.caller.highlightLoaded)
                    app.caller.NewAudioPlayer(0);
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
            app.grainSize = app.Fs / 100;
            app.UpdateADSREnv();
            app.caller.notvumOpened = true;
        end

        % Button pushed function: PlayGrainButton
        function PlayGrainButtonPushed(app, event)
            app.CompileSampleLoop();
            app.CreatePlayer(app.loop, 0);
            resume(app.player);
        end

        % Button pushed function: SaveTrackButton
        function SaveTrackButtonPushed(app, event)
            if (app.caller.highlightLoaded)
                trackID = app.SaveasTrackSpinner.Value;
                progressBar = uiprogressdlg(app.NotvumUIFigure, Message='Saving Track');
                track = app.GetCompiledTrack();
                progressBar.Value = 0.8;
                tmpName = strcat(pwd, '/HugoSynthTmp.wav');
                audiowrite(tmpName, track, app.Fs, "Artist", "HugoSynth");
                progressBar.Value = 1;
                close(progressBar);
                app.caller.AttemptToOverwriteTrack(trackID, app.NewTrackNameEditField.Value);
            else
                uialert(app.NotvumUIFigure, 'No track highlighted in main app', ...
                    'Cannot export track');
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

        % Close request function: NotvumUIFigure
        function NotvumUIFigureCloseRequest(app, event)
            app.caller.notvumOpened = false;
%             % multi-processing option removed
%             if (app.poolOpened)
%                 delete(app.pool);
%             end
            delete(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create NotvumUIFigure and hide until all components are created
            app.NotvumUIFigure = uifigure('Visible', 'off');
            app.NotvumUIFigure.Position = [100 100 673 654];
            app.NotvumUIFigure.Name = 'Notvum';
            app.NotvumUIFigure.CloseRequestFcn = createCallbackFcn(app, @NotvumUIFigureCloseRequest, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.NotvumUIFigure);
            app.GridLayout.ColumnWidth = {'0.5x', '0.5x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '0.5x', '0.5x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 3;
            app.GridLayout.RowSpacing = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            title(app.UIAxes, 'Select a grain to begin')
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XTickLabel = '';
            app.UIAxes.YTickLabel = '';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.Layout.Row = [1 3];
            app.UIAxes.Layout.Column = [1 4];

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
            app.ADSRAxes.Position = [1 7 228 128];

            % Create GrainSizeinmsSliderLabel
            app.GrainSizeinmsSliderLabel = uilabel(app.GrainPickerPanel);
            app.GrainSizeinmsSliderLabel.FontSize = 10;
            app.GrainSizeinmsSliderLabel.FontWeight = 'bold';
            app.GrainSizeinmsSliderLabel.FontColor = [0 0 1];
            app.GrainSizeinmsSliderLabel.Position = [4 168 114 22];
            app.GrainSizeinmsSliderLabel.Text = 'Grain Size (in ms)';

            % Create GrainSizeSlider
            app.GrainSizeSlider = uislider(app.GrainPickerPanel);
            app.GrainSizeSlider.Limits = [10 1000];
            app.GrainSizeSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.GrainSizeSlider.ValueChangingFcn = createCallbackFcn(app, @GrainSizeSliderValueChanging, true);
            app.GrainSizeSlider.FontSize = 10;
            app.GrainSizeSlider.Position = [9 160 407 3];
            app.GrainSizeSlider.Value = 10;

            % Create PositionSliderLabel
            app.PositionSliderLabel = uilabel(app.GrainPickerPanel);
            app.PositionSliderLabel.FontSize = 10;
            app.PositionSliderLabel.FontWeight = 'bold';
            app.PositionSliderLabel.Position = [4 226 98 22];
            app.PositionSliderLabel.Text = 'Position';

            % Create PositionSlider
            app.PositionSlider = uislider(app.GrainPickerPanel);
            app.PositionSlider.ValueChangedFcn = createCallbackFcn(app, @EnvelopeSliderValueChanged, true);
            app.PositionSlider.ValueChangingFcn = createCallbackFcn(app, @PositionSliderValueChanging, true);
            app.PositionSlider.FontSize = 10;
            app.PositionSlider.Position = [9 219 407 3];

            % Create PlayGrainButton
            app.PlayGrainButton = uibutton(app.GrainPickerPanel, 'push');
            app.PlayGrainButton.ButtonPushedFcn = createCallbackFcn(app, @PlayGrainButtonPushed, true);
            app.PlayGrainButton.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.PlayGrainButton.HorizontalAlignment = 'left';
            app.PlayGrainButton.Position = [228 9 91 22];
            app.PlayGrainButton.Text = 'Play Grain';

            % Create SaveTrackButton
            app.SaveTrackButton = uibutton(app.GrainPickerPanel, 'push');
            app.SaveTrackButton.ButtonPushedFcn = createCallbackFcn(app, @SaveTrackButtonPushed, true);
            app.SaveTrackButton.Position = [326 9 100 22];
            app.SaveTrackButton.Text = 'Save Track';

            % Create SaveasTrackSpinnerLabel
            app.SaveasTrackSpinnerLabel = uilabel(app.GrainPickerPanel);
            app.SaveasTrackSpinnerLabel.HorizontalAlignment = 'center';
            app.SaveasTrackSpinnerLabel.Position = [228 61 80 22];
            app.SaveasTrackSpinnerLabel.Text = 'Save as Track';

            % Create SaveasTrackSpinner
            app.SaveasTrackSpinner = uispinner(app.GrainPickerPanel);
            app.SaveasTrackSpinner.Limits = [1 5];
            app.SaveasTrackSpinner.RoundFractionalValues = 'on';
            app.SaveasTrackSpinner.ValueDisplayFormat = 'Track %d';
            app.SaveasTrackSpinner.Position = [228 40 80 22];
            app.SaveasTrackSpinner.Value = 1;

            % Create NewTrackNameEditField
            app.NewTrackNameEditField = uieditfield(app.GrainPickerPanel, 'text');
            app.NewTrackNameEditField.FontSize = 10;
            app.NewTrackNameEditField.Placeholder = 'Synthesised Track';
            app.NewTrackNameEditField.Position = [310 40 120 22];
            app.NewTrackNameEditField.Value = 'Synthesised Track';

            % Create SaveasCustomNameLabel
            app.SaveasCustomNameLabel = uilabel(app.GrainPickerPanel);
            app.SaveasCustomNameLabel.HorizontalAlignment = 'center';
            app.SaveasCustomNameLabel.Position = [308 61 83 22];
            app.SaveasCustomNameLabel.Text = 'Custom Name';

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
            app.AttackLabel.Position = [19 228 88 22];
            app.AttackLabel.Text = 'Attack';

            % Create DecayLabel
            app.DecayLabel = uilabel(app.ADSREnvelopePanel);
            app.DecayLabel.FontWeight = 'bold';
            app.DecayLabel.Position = [19 180 88 22];
            app.DecayLabel.Text = 'Decay';

            % Create SustainLabel
            app.SustainLabel = uilabel(app.ADSREnvelopePanel);
            app.SustainLabel.FontWeight = 'bold';
            app.SustainLabel.Position = [19 132 88 22];
            app.SustainLabel.Text = 'Sustain';

            % Create SLenLabel
            app.SLenLabel = uilabel(app.ADSREnvelopePanel);
            app.SLenLabel.FontWeight = 'bold';
            app.SLenLabel.Position = [19 84 88 22];
            app.SLenLabel.Text = 'S. Len.';

            % Create ReleaseLabel
            app.ReleaseLabel = uilabel(app.ADSREnvelopePanel);
            app.ReleaseLabel.FontWeight = 'bold';
            app.ReleaseLabel.Position = [19 36 88 22];
            app.ReleaseLabel.Text = 'Release';

            % Create ASlider
            app.ASlider = uislider(app.ADSREnvelopePanel);
            app.ASlider.Limits = [0 1];
            app.ASlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.ASlider.FontSize = 10;
            app.ASlider.Position = [7 226 202 3];

            % Create DSlider
            app.DSlider = uislider(app.ADSREnvelopePanel);
            app.DSlider.Limits = [0 1];
            app.DSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.DSlider.FontSize = 10;
            app.DSlider.Position = [7 178 202 3];

            % Create SSlider
            app.SSlider = uislider(app.ADSREnvelopePanel);
            app.SSlider.Limits = [0 1];
            app.SSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.SSlider.FontSize = 10;
            app.SSlider.Position = [7 130 202 3];
            app.SSlider.Value = 1;

            % Create SLenSlider
            app.SLenSlider = uislider(app.ADSREnvelopePanel);
            app.SLenSlider.Limits = [0.1 1.5];
            app.SLenSlider.MajorTicks = [0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5];
            app.SLenSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.SLenSlider.FontSize = 10;
            app.SLenSlider.Position = [7 82 202 3];
            app.SLenSlider.Value = 1;

            % Create RSlider
            app.RSlider = uislider(app.ADSREnvelopePanel);
            app.RSlider.Limits = [0 1];
            app.RSlider.ValueChangedFcn = createCallbackFcn(app, @ADSRSlidersValueChanged, true);
            app.RSlider.FontSize = 10;
            app.RSlider.Position = [7 34 202 3];

            % Create Gallery
            app.Gallery = uipanel(app.GridLayout);
            app.Gallery.AutoResizeChildren = 'off';
            app.Gallery.Title = 'Gallery';
            app.Gallery.BackgroundColor = [0.902 0.902 0.902];
            app.Gallery.Layout.Row = [4 5];
            app.Gallery.Layout.Column = [1 4];

            % Create ADSRContextMenu
            app.ADSRContextMenu = uicontextmenu(app.NotvumUIFigure);

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
            app.GalleryContextMenu = uicontextmenu(app.NotvumUIFigure);

            % Create RefreshMenu
            app.RefreshMenu = uimenu(app.GalleryContextMenu);
            app.RefreshMenu.MenuSelectedFcn = createCallbackFcn(app, @RefreshMenuSelected, true);
            app.RefreshMenu.Text = 'Refresh';
            
            % Assign app.GalleryContextMenu
            app.Gallery.ContextMenu = app.GalleryContextMenu;

            % Show the figure after all components are created
            app.NotvumUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Notvum(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.NotvumUIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.NotvumUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.NotvumUIFigure)
        end
    end
end