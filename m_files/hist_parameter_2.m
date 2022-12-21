classdef hist_parameter_2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        FileMenu                        matlab.ui.container.Menu
        EditMenu                        matlab.ui.container.Menu
        currentmodulehistogrammatchingPanel  matlab.ui.container.Panel
        imageButtonGroup                matlab.ui.container.ButtonGroup
        imagetohistogrammatchingButton  matlab.ui.control.ToggleButton
        image_to_histogram_matching_EditField  matlab.ui.control.EditField
        pathofsaveimageButton           matlab.ui.control.ToggleButton
        path_of_save_image_EditField    matlab.ui.control.EditField
        startButton                     matlab.ui.control.Button
        parametersPanel                 matlab.ui.container.Panel
        outputfilenameEditFieldLabel    matlab.ui.control.Label
        filename_prefix_EditField       matlab.ui.control.EditField
        saveallButton                   matlab.ui.control.Button
        set_the_target_hist_EditField   matlab.ui.control.EditField
        setthetargethistogramButton     matlab.ui.control.Button
        helponhistogrammatchingPanel    matlab.ui.container.Panel
        TextAreaLabel                   matlab.ui.control.Label
        TextArea                        matlab.ui.control.TextArea
    end

    
    properties (Access = private)
        Calling_app % ÿÿÿAPP
        target_hist
        input_img_path
        output_img
        output_prefix
        output_path
    end
    
    methods (Access = public)
        
        function results = get_target_hist(app,value)
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            app.Calling_app=mainapp;
            app.filename_prefix_EditField.Value="Please enter the prefix of the saved file";
            
        end

        % Selection changed function: imageButtonGroup
        function imageButtonGroupSelectionChanged(app, event)
            selectedButton = app.imageButtonGroup.SelectedObject;
%             app.filename_prefix_EditField.Value="ÿÿÿÿÿÿÿÿÿÿ,ÿÿÿ'filename prefix'";
            switch selectedButton.Text
                case 'image to histogram matching'
                    [filename,path]=uigetfile({'*.nii.gz;*.nii'},'ÿÿÿÿÿÿ');
                    app.image_to_histogram_matching_EditField.Value=[path,filename];
                    app.input_img_path=app.image_to_histogram_matching_EditField.Value;
                    app.TextArea.Value="ÿÿÿÿÿ'image to histogram matching'ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿNIFTIÿÿÿÿ";
                case 'path of save image'
                    app.output_path = uigetdir('C:\Users\86133\Documents\MATLAB');
                    app.path_of_save_image_EditField.Value=app.output_path;
            end
        end

        % Button pushed function: startButton
        function startButtonPushed(app, event)
            Trans_Image=histMatching(app.input_img_path,app.target_hist);
            app.output_img = make_nii(Trans_Image);
            input_data=load_untouch_nii(app.input_img_path);
            app.output_img.hdr = input_data.hdr;
            path=[app.output_path,'\',app.output_prefix,'.nii.gz'];
            save_nii(app.output_img, path);
            uialert(app.UIFigure,['Histogram matching is complete,' ...
                'and the output image is saved to the corresponding path.'],'Notice','Icon','success')
            
        end

        % Button pushed function: saveallButton
        function saveallButtonPushed(app, event)
            app.target_hist=importdata(app.set_the_target_hist_EditField.Value);
            app.output_prefix=app.filename_prefix_EditField.Value;
            uialert(app.UIFigure,'Input parameters have been saved!','Notice','Icon','success') 
        end

        % Button pushed function: setthetargethistogramButton
        function setthetargethistogramButtonPushed(app, event)
            [filename,path]=uigetfile({'*.mat'},'ÿÿmatÿÿ');
            app.set_the_target_hist_EditField.Value=[path,filename];
                    
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

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Text = 'File';

            % Create EditMenu
            app.EditMenu = uimenu(app.UIFigure);
            app.EditMenu.Text = 'Edit';

            % Create currentmodulehistogrammatchingPanel
            app.currentmodulehistogrammatchingPanel = uipanel(app.UIFigure);
            app.currentmodulehistogrammatchingPanel.Title = 'current module:histogram matching';
            app.currentmodulehistogrammatchingPanel.Position = [26 140 573 318];

            % Create imageButtonGroup
            app.imageButtonGroup = uibuttongroup(app.currentmodulehistogrammatchingPanel);
            app.imageButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @imageButtonGroupSelectionChanged, true);
            app.imageButtonGroup.Title = 'image';
            app.imageButtonGroup.Position = [18 193 538 86];

            % Create imagetohistogrammatchingButton
            app.imagetohistogrammatchingButton = uitogglebutton(app.imageButtonGroup);
            app.imagetohistogrammatchingButton.Text = 'image to histogram matching';
            app.imagetohistogrammatchingButton.Position = [11 33 170 22];
            app.imagetohistogrammatchingButton.Value = true;

            % Create image_to_histogram_matching_EditField
            app.image_to_histogram_matching_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.image_to_histogram_matching_EditField.Position = [238 33 277 22];

            % Create pathofsaveimageButton
            app.pathofsaveimageButton = uitogglebutton(app.imageButtonGroup);
            app.pathofsaveimageButton.Text = 'path of save image';
            app.pathofsaveimageButton.Position = [11 12 170 22];

            % Create path_of_save_image_EditField
            app.path_of_save_image_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.path_of_save_image_EditField.Position = [238 12 277 22];

            % Create startButton
            app.startButton = uibutton(app.currentmodulehistogrammatchingPanel, 'push');
            app.startButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.Position = [436 14 100 22];
            app.startButton.Text = 'start';

            % Create parametersPanel
            app.parametersPanel = uipanel(app.currentmodulehistogrammatchingPanel);
            app.parametersPanel.Title = 'parameters';
            app.parametersPanel.Position = [18 79 538 88];

            % Create outputfilenameEditFieldLabel
            app.outputfilenameEditFieldLabel = uilabel(app.parametersPanel);
            app.outputfilenameEditFieldLabel.HorizontalAlignment = 'right';
            app.outputfilenameEditFieldLabel.Position = [15 12 88 22];
            app.outputfilenameEditFieldLabel.Text = 'output filename';

            % Create filename_prefix_EditField
            app.filename_prefix_EditField = uieditfield(app.parametersPanel, 'text');
            app.filename_prefix_EditField.Position = [164 12 235 22];

            % Create saveallButton
            app.saveallButton = uibutton(app.parametersPanel, 'push');
            app.saveallButton.ButtonPushedFcn = createCallbackFcn(app, @saveallButtonPushed, true);
            app.saveallButton.Position = [418 23 100 22];
            app.saveallButton.Text = 'save all';

            % Create set_the_target_hist_EditField
            app.set_the_target_hist_EditField = uieditfield(app.parametersPanel, 'text');
            app.set_the_target_hist_EditField.Position = [164 33 235 22];

            % Create setthetargethistogramButton
            app.setthetargethistogramButton = uibutton(app.parametersPanel, 'push');
            app.setthetargethistogramButton.ButtonPushedFcn = createCallbackFcn(app, @setthetargethistogramButtonPushed, true);
            app.setthetargethistogramButton.Position = [15 33 142 22];
            app.setthetargethistogramButton.Text = 'set the target histogram';

            % Create helponhistogrammatchingPanel
            app.helponhistogrammatchingPanel = uipanel(app.UIFigure);
            app.helponhistogrammatchingPanel.Title = 'help on histogram matching';
            app.helponhistogrammatchingPanel.Position = [26 9 573 116];

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.helponhistogrammatchingPanel);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.Position = [21 51 56 22];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.helponhistogrammatchingPanel);
            app.TextArea.Position = [92 15 444 60];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = hist_parameter_2(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

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