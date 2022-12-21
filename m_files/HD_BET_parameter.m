classdef HD_BET_parameter < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        EditMenu                      matlab.ui.container.Menu
        currentmoduleskullstrippingPanel  matlab.ui.container.Panel
        imageButtonGroup              matlab.ui.container.ButtonGroup
        imagetoskullstrippingButton   matlab.ui.control.ToggleButton
        image_to_skull_stripping_EditField  matlab.ui.control.EditField
        pathofsaveimageButton         matlab.ui.control.ToggleButton
        path_of_save_image_EditField  matlab.ui.control.EditField
        startButton                   matlab.ui.control.Button
        saveparametersPanel           matlab.ui.container.Panel
        saveallButton                 matlab.ui.control.Button
        outputprefixLabel             matlab.ui.control.Label
        filename_prefix_EditField     matlab.ui.control.EditField
        save_maskDropDownLabel        matlab.ui.control.Label
        save_maskDropDown             matlab.ui.control.DropDown
        helponskullstrippingPanel     matlab.ui.container.Panel
        TextAreaLabel                 matlab.ui.control.Label
        TextArea                      matlab.ui.control.TextArea
    end

    
    properties (Access = private)
        Calling_app % ÿÿÿAPP
        input_img_path
        output_img
        output_prefix
        output_path
        
        is_save_mask
        
        
    end
    
    methods (Access = public)
        
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
%             app.k_means_param_EditField.Value="ÿÿÿÿÿÿÿÿÿÿ,ÿÿÿ'filename prefix'";
            switch selectedButton.Text
                case 'image to skull stripping'
                    [filename,path]=uigetfile({'*.nii.gz;*.nii'},'ÿÿÿÿÿÿ');
                    app.image_to_skull_stripping_EditField.Value=[path,filename];
                    app.input_img_path=app.image_to_skull_stripping_EditField.Value;
                case 'path of save image'
                    app.output_path = uigetdir('C:\Users\86133\Documents\MATLAB');
                    app.path_of_save_image_EditField.Value=app.output_path;
               
            end
        end

        % Button pushed function: startButton
        function startButtonPushed(app, event)
            device=py.str('cpu');
            mode=py.str('fast');
            pp=py.int(1);
            overwrite_existing=py.int(1);
            input_path=py.str(app.input_img_path);
            app.output_img=[app.output_path,'\',app.output_prefix,'.nii.gz'];
            app.output_img=py.str(app.output_img);
            py.HD_BET_start.HD_BET_run(input_path,app.output_img,mode,device,tta,app.is_save_mask,overwrite_existing,pp);
% ÿÿÿÿÿÿ
            switch app.save_maskDropDown.Value
                case 'yes'
                    uialert(app.UIFigure,"Skull stripping is complete and the brain image and mask are saved in the folder!",'Notice','Icon','success')
                case 'no'
                    uialert(app.UIFigure,"Skull stripping is complete and the brain image is saved in the folder!",'Notice','Icon','success')
            end 
             
            
        end

        % Button pushed function: saveallButton
        function saveallButtonPushed(app, event)
            app.output_prefix=app.filename_prefix_EditField.Value;   
            value = app.save_maskDropDown.Value;
            switch value
                case 'yes'
                    app.is_save_mask=py.int(1);
                case 'no'
                    app.is_save_mask=py.int(0);
            end
            uialert(app.UIFigure,'Input parameters have been saved!','Notice','Icon','success')
                
        end

        % Value changed function: save_maskDropDown
        function save_maskDropDownValueChanged(app, event)
            value = app.save_maskDropDown.Value;
            switch value
                case 'yes'
                    app.is_save_mask=py.int(1);
                case 'no'
                    app.is_save_mask=py.int(0);
            end
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

            % Create currentmoduleskullstrippingPanel
            app.currentmoduleskullstrippingPanel = uipanel(app.UIFigure);
            app.currentmoduleskullstrippingPanel.Title = 'current module:skull-stripping';
            app.currentmoduleskullstrippingPanel.Position = [26 140 573 333];

            % Create imageButtonGroup
            app.imageButtonGroup = uibuttongroup(app.currentmoduleskullstrippingPanel);
            app.imageButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @imageButtonGroupSelectionChanged, true);
            app.imageButtonGroup.Title = 'image';
            app.imageButtonGroup.Position = [21 221 538 86];

            % Create imagetoskullstrippingButton
            app.imagetoskullstrippingButton = uitogglebutton(app.imageButtonGroup);
            app.imagetoskullstrippingButton.Text = 'image to skull stripping';
            app.imagetoskullstrippingButton.Position = [11 33 170 22];
            app.imagetoskullstrippingButton.Value = true;

            % Create image_to_skull_stripping_EditField
            app.image_to_skull_stripping_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.image_to_skull_stripping_EditField.Position = [238 33 277 22];

            % Create pathofsaveimageButton
            app.pathofsaveimageButton = uitogglebutton(app.imageButtonGroup);
            app.pathofsaveimageButton.Text = 'path of save image';
            app.pathofsaveimageButton.Position = [11 12 170 22];

            % Create path_of_save_image_EditField
            app.path_of_save_image_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.path_of_save_image_EditField.Position = [238 12 277 22];

            % Create startButton
            app.startButton = uibutton(app.currentmoduleskullstrippingPanel, 'push');
            app.startButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.Position = [436 24 100 22];
            app.startButton.Text = 'start';

            % Create saveparametersPanel
            app.saveparametersPanel = uipanel(app.currentmoduleskullstrippingPanel);
            app.saveparametersPanel.Title = 'save parameters';
            app.saveparametersPanel.Position = [21 73 538 116];

            % Create saveallButton
            app.saveallButton = uibutton(app.saveparametersPanel, 'push');
            app.saveallButton.ButtonPushedFcn = createCallbackFcn(app, @saveallButtonPushed, true);
            app.saveallButton.Position = [415 36 100 22];
            app.saveallButton.Text = 'save all';

            % Create outputprefixLabel
            app.outputprefixLabel = uilabel(app.saveparametersPanel);
            app.outputprefixLabel.HorizontalAlignment = 'right';
            app.outputprefixLabel.Position = [11 47 72 22];
            app.outputprefixLabel.Text = 'output prefix';

            % Create filename_prefix_EditField
            app.filename_prefix_EditField = uieditfield(app.saveparametersPanel, 'text');
            app.filename_prefix_EditField.Position = [125 47 269 22];

            % Create save_maskDropDownLabel
            app.save_maskDropDownLabel = uilabel(app.saveparametersPanel);
            app.save_maskDropDownLabel.HorizontalAlignment = 'right';
            app.save_maskDropDownLabel.Position = [11 26 66 22];
            app.save_maskDropDownLabel.Text = 'save_mask';

            % Create save_maskDropDown
            app.save_maskDropDown = uidropdown(app.saveparametersPanel);
            app.save_maskDropDown.Items = {'yes', 'no'};
            app.save_maskDropDown.ValueChangedFcn = createCallbackFcn(app, @save_maskDropDownValueChanged, true);
            app.save_maskDropDown.Position = [125 26 269 22];
            app.save_maskDropDown.Value = 'yes';

            % Create helponskullstrippingPanel
            app.helponskullstrippingPanel = uipanel(app.UIFigure);
            app.helponskullstrippingPanel.Title = 'help on skull-stripping';
            app.helponskullstrippingPanel.Position = [26 9 573 116];

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.helponskullstrippingPanel);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.Position = [21 51 56 22];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.helponskullstrippingPanel);
            app.TextArea.Position = [92 15 444 60];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HD_BET_parameter(varargin)

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