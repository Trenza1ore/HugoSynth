classdef TrackOffsetAdjust < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure     matlab.ui.Figure
        TrackSlider  matlab.ui.control.Slider
    end


    properties (Access = public)
        trackID % Track ID
        caller % The main app
    end

    methods (Access = public)
        function UpdateTicks(app, Ticks, TickLabels, Limits)
            app.TrackSlider.MajorTicks = Ticks;
            app.TrackSlider.MajorTickLabels = TickLabels;
            app.TrackSlider.Limits = Limits;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, caller, trackID)
            if (trackID ~= 4 && trackID ~= 5)
                delete(app);
            end
            app.trackID = trackID;
            app.caller = caller;
            app.UIFigure.Name = strcat("Track ", string(trackID), " offset adjuster");
            app.caller.offsetAdjustOpened = true;
        end

        % Value changed function: TrackSlider
        function TrackSliderValueChanged(app, event)
            app.caller.UpdateTrackOffset(app.trackID, app.TrackSlider.Value);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            app.caller.offsetAdjustOpened = false;
            delete(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 662 53];
            app.UIFigure.Name = 'Initializing';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create TrackSlider
            app.TrackSlider = uislider(app.UIFigure);
            app.TrackSlider.MajorTicks = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100];
            app.TrackSlider.ValueChangedFcn = createCallbackFcn(app, @TrackSliderValueChanged, true);
            app.TrackSlider.MinorTicks = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100];
            app.TrackSlider.FontSize = 8;
            app.TrackSlider.Position = [17 35 629 3];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TrackOffsetAdjust(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.UIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.UIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end