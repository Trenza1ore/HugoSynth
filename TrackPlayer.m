classdef TrackPlayer < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        TrackPlayerUIFigure  matlab.ui.Figure
        GridLayout           matlab.ui.container.GridLayout
        Button               matlab.ui.control.Button
        Waveform             matlab.ui.control.UIAxes
        ContextMenu          matlab.ui.container.ContextMenu
        SaveMenu             matlab.ui.container.Menu
    end

    
    properties (Access = private)
        caller % main app
        player = audioplayer(zeros(44100, 1), 44100); % audio player object
        playerPos % position indicator for audio player
        playerPosTracker = timer(); % timer to update position indicator
        playerOffset = 0;
        trackAudio % the track
        trackAudioLen % the track's length
        trackName % the track's name
        Fs % sampling frequency
    end

    properties (Access = public)
        currentPosX = [1 1];
        currentPosY = [-1.5 1.5];
    end
    
    methods (Access = private)
        
        % Create a new audio player at the position
        function CreatePlayer(app, pos)
            % Update audio player position one last time
            if (app.player ~= false)
                app.UpdatePlayerPosIndicator();
            end
            app.playerPosTracker.stop();
            pause(app.player);

            pos = int32(max(0, pos));
            CheckAudioDevice(app.caller);
            if (app.trackAudioLen < pos)
                pos = app.trackAudioLen - 1;
            end
            app.playerOffset = pos;
            app.player = audioplayer(app.trackAudio(pos+1:end, 1), app.Fs, 24, app.caller.outputDeviceID);
            app.player.StartFcn = createCallbackFcn(app, @AudioPlayerStarts, false);
            app.player.StopFcn = createCallbackFcn(app, @AudioPlayerStops, false);
        end

        % Create the timer for tracking current position of audio player
        function CreateTimer(app)
            app.playerPosTracker = timer();
            app.playerPosTracker.Period = 0.5;
            app.playerPosTracker.TasksToExecute = inf;
            app.playerPosTracker.ExecutionMode = "fixedRate";
            app.playerPosTracker.TimerFcn = createCallbackFcn(app, @UpdatePlayerPosIndicator, false);
        end

        function AudioPlayerStops(app)
            % It's a pause if the audioplayer has already played something
            if (app.player.currentSample ~= 1)
                app.UpdatePlayerPosIndicator();
                app.playerPosTracker.stop();
            else
                app.CreatePlayer(0);
                app.UpdatePlayerPosIndicator();
            end
        end

        function AudioPlayerStarts(app)
            app.playerPosTracker.start();
        end

        function UpdatePlayerPosIndicator(app)
            current = app.player.CurrentSample + app.playerOffset;
            app.currentPosX = [current current];
            refreshdata(app.playerPos, 'caller');
        end

        function DrawWaveform(app)
            title(app.Waveform, app.trackName, 'Interpreter', 'none');

            % Clear UIAxes
            cla(app.Waveform);

            % Plot waveform
            X = 1:app.trackAudioLen;
            Y = app.trackAudio;
            plot(app.Waveform, X, Y, 'c', "ButtonDownFcn", createCallbackFcn(app, @WaveformButtonDown, false), ...
                "ContextMenu", app.ContextMenu);

            % Set limits and ticks
            app.Waveform.XLim = [1 app.trackAudioLen];
            [Ticks, TickLabels] = GenerateTicks(app.trackAudioLen, app.Fs);
            xticks(app.Waveform, Ticks);
            xticklabels(app.Waveform, TickLabels);

            % Plot current position indicator for waveform
            hold(app.Waveform, "on");
            app.playerPos = plot(app.Waveform, app.currentPosX, app.currentPosY, "LineWidth", 2, "Color", 'k');
            app.playerPos.XDataSource = "app.currentPosX";
            app.playerPos.YDataSource = "app.currentPosY";
            hold(app.Waveform, "off");
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, caller, trackAudio, trackName, trackFs)
            progressBar = uiprogressdlg(app.TrackPlayerUIFigure, "Message", "Initalizing");
            app.caller = caller;
            app.trackAudio = trackAudio;
            app.trackAudioLen = size(trackAudio, 1);
            app.trackName = trackName;
            app.Fs = trackFs;
            app.DrawWaveform();
            app.CreateTimer();
            app.CreatePlayer(0);
            app.caller.trackPlayerPluginOpened = true;
            close(progressBar);
        end

        % Button down function: Waveform
        function WaveformButtonDown(app, event)
            % Get the player's new position selected by the user
            x = app.Waveform.CurrentPoint(1);
            wasPlaying = app.player.isplaying;

            % Create a new player at that position
            app.CreatePlayer(x);
            app.UpdatePlayerPosIndicator();
            
            % Continue playing
            if (wasPlaying)
                resume(app.player);
            end
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            if (app.player.isplaying())
                pause(app.player);
            else
                resume(app.player);
            end
        end

        % Menu selected function: SaveMenu
        function SaveMenuSelected(app, event)
            [fileName, pathName] = uiputfile('*.wav', 'Save current playback');
            if ~(isequal(fileName, 0) || isequal(pathName, 0))
                audiowrite(strcat(pathName, fileName), app.trackAudio, app.Fs, "Artist", "HugoSynth");
            end
        end

        % Close request function: TrackPlayerUIFigure
        function TrackPlayerUIFigureCloseRequest(app, event)
            app.caller.trackPlayerPluginOpened = false;
            delete(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create TrackPlayerUIFigure and hide until all components are created
            app.TrackPlayerUIFigure = uifigure('Visible', 'off');
            app.TrackPlayerUIFigure.Position = [100 100 660 269];
            app.TrackPlayerUIFigure.Name = 'Track Player';
            app.TrackPlayerUIFigure.CloseRequestFcn = createCallbackFcn(app, @TrackPlayerUIFigureCloseRequest, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.TrackPlayerUIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'4x', '1x'};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.RowSpacing = 5;

            % Create Waveform
            app.Waveform = uiaxes(app.GridLayout);
            title(app.Waveform, 'Intializing')
            app.Waveform.Toolbar.Visible = 'off';
            app.Waveform.YLim = [-1 1];
            app.Waveform.YTick = [-1 0 1];
            app.Waveform.YTickLabel = '';
            app.Waveform.Layout.Row = 1;
            app.Waveform.Layout.Column = 1;
            app.Waveform.ButtonDownFcn = createCallbackFcn(app, @WaveformButtonDown, true);

            % Create Button
            app.Button = uibutton(app.GridLayout, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Icon = fullfile(pathToMLAPP, 'Icons', 'PlayIcon.png');
            app.Button.Layout.Row = 2;
            app.Button.Layout.Column = 1;
            app.Button.Text = '';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.TrackPlayerUIFigure);

            % Create SaveMenu
            app.SaveMenu = uimenu(app.ContextMenu);
            app.SaveMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveMenuSelected, true);
            app.SaveMenu.Text = 'Save';
            
            % Assign app.ContextMenu
            app.Waveform.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.TrackPlayerUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TrackPlayer(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.TrackPlayerUIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.TrackPlayerUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.TrackPlayerUIFigure)
        end
    end
end