classdef data_process < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        imagepreprocessingPanel         matlab.ui.container.Panel
        skullstrippingButton            matlab.ui.control.Button
        imagedenoiseButton              matlab.ui.control.Button
        N4FieldCorrectionButton         matlab.ui.control.Button
        BatchpreprocessingPanel         matlab.ui.container.Panel
        histogrammatchingDropDownLabel  matlab.ui.control.Label
        histogrammatchingDropDown       matlab.ui.control.DropDown
        vesselsegmentationPanel         matlab.ui.container.Panel
        MarkovRandomFieldButton         matlab.ui.control.Button
        vesselenhancePanel              matlab.ui.container.Panel
        vesselenhanceButton             matlab.ui.control.Button
        fastfuzzyCmeansButton           matlab.ui.control.Button
    end

    
    properties (Access = private)
        hist_app % ÿÿhistÿapp
        FCM_app% ÿÿFCMÿapp
        skull_stripping_app% ÿÿskull_strippingÿapp
        VE_app% ÿÿvessel enhanceÿapp
    end
    
    methods (Access = public)
        
        function results = update_hist_param(app)
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: skullstrippingButton
        function skullstrippingButtonPushed(app, event)
            app.skull_stripping_app=HD_BET_parameter(app);
        end

        % Value changed function: histogrammatchingDropDown
        function histogrammatchingDropDownValueChanged(app, event)
            value = app.histogrammatchingDropDown.Value;
            switch value
                case 'provided target hist'
                    app.hist_app=hist_parameter(app);
                case'user-defined target hist'
                    app.hist_app=hist_parameter_2(app); 
            end
        end

        % Button pushed function: fastfuzzyCmeansButton
        function fastfuzzyCmeansButtonPushed(app, event)
            app.FCM_app=FCM_parameter(app);
        end

        % Button pushed function: vesselenhanceButton
        function vesselenhanceButtonPushed(app, event)
            app.VE_app=VE_parameter(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create imagepreprocessingPanel
            app.imagepreprocessingPanel = uipanel(app.UIFigure);
            app.imagepreprocessingPanel.Title = 'image pre-processing';
            app.imagepreprocessingPanel.Position = [20 346 605 113];

            % Create skullstrippingButton
            app.skullstrippingButton = uibutton(app.imagepreprocessingPanel, 'push');
            app.skullstrippingButton.ButtonPushedFcn = createCallbackFcn(app, @skullstrippingButtonPushed, true);
            app.skullstrippingButton.Position = [41 31 125 41];
            app.skullstrippingButton.Text = 'skull-stripping';

            % Create imagedenoiseButton
            app.imagedenoiseButton = uibutton(app.imagepreprocessingPanel, 'push');
            app.imagedenoiseButton.Position = [238 31 125 41];
            app.imagedenoiseButton.Text = 'image denoise';

            % Create N4FieldCorrectionButton
            app.N4FieldCorrectionButton = uibutton(app.imagepreprocessingPanel, 'push');
            app.N4FieldCorrectionButton.Position = [437 31 125 41];
            app.N4FieldCorrectionButton.Text = 'N4FieldCorrection';

            % Create BatchpreprocessingPanel
            app.BatchpreprocessingPanel = uipanel(app.UIFigure);
            app.BatchpreprocessingPanel.Title = 'Batch pre-processing';
            app.BatchpreprocessingPanel.Position = [20 256 605 78];

            % Create histogrammatchingDropDownLabel
            app.histogrammatchingDropDownLabel = uilabel(app.BatchpreprocessingPanel);
            app.histogrammatchingDropDownLabel.HorizontalAlignment = 'right';
            app.histogrammatchingDropDownLabel.Position = [166 17 110 22];
            app.histogrammatchingDropDownLabel.Text = 'histogram matching';

            % Create histogrammatchingDropDown
            app.histogrammatchingDropDown = uidropdown(app.BatchpreprocessingPanel);
            app.histogrammatchingDropDown.Items = {'none', 'user-defined target hist', 'provided target hist'};
            app.histogrammatchingDropDown.ValueChangedFcn = createCallbackFcn(app, @histogrammatchingDropDownValueChanged, true);
            app.histogrammatchingDropDown.Position = [291 17 148 22];
            app.histogrammatchingDropDown.Value = 'none';

            % Create vesselsegmentationPanel
            app.vesselsegmentationPanel = uipanel(app.UIFigure);
            app.vesselsegmentationPanel.Title = 'vessel segmentation';
            app.vesselsegmentationPanel.Position = [20 12 605 90];

            % Create MarkovRandomFieldButton
            app.MarkovRandomFieldButton = uibutton(app.vesselsegmentationPanel, 'push');
            app.MarkovRandomFieldButton.Position = [166 16 273 41];
            app.MarkovRandomFieldButton.Text = 'Markov Random Field';

            % Create vesselenhancePanel
            app.vesselenhancePanel = uipanel(app.UIFigure);
            app.vesselenhancePanel.Title = 'vessel enhance';
            app.vesselenhancePanel.Position = [20 121 605 113];

            % Create vesselenhanceButton
            app.vesselenhanceButton = uibutton(app.vesselenhancePanel, 'push');
            app.vesselenhanceButton.ButtonPushedFcn = createCallbackFcn(app, @vesselenhanceButtonPushed, true);
            app.vesselenhanceButton.Position = [362 21 125 41];
            app.vesselenhanceButton.Text = 'vessel enhance';

            % Create fastfuzzyCmeansButton
            app.fastfuzzyCmeansButton = uibutton(app.vesselenhancePanel, 'push');
            app.fastfuzzyCmeansButton.ButtonPushedFcn = createCallbackFcn(app, @fastfuzzyCmeansButtonPushed, true);
            app.fastfuzzyCmeansButton.Position = [114 21 125 41];
            app.fastfuzzyCmeansButton.Text = 'fast fuzzy C-means';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = data_process

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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