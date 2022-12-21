classdef VE_parameter < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        EditMenu                      matlab.ui.container.Menu
        currentmodulevesselenhancePanel  matlab.ui.container.Panel
        imageButtonGroup              matlab.ui.container.ButtonGroup
        imagetovesselenhanceButton    matlab.ui.control.ToggleButton
        image_to_vesselenhance_EditField  matlab.ui.control.EditField
        pathofsaveimageButton         matlab.ui.control.ToggleButton
        path_of_save_image_EditField  matlab.ui.control.EditField
        startButton                   matlab.ui.control.Button
        saveparametersPanel           matlab.ui.container.Panel
        saveallButton                 matlab.ui.control.Button
        outputfilenameEditFieldLabel  matlab.ui.control.Label
        filename_prefix_EditField     matlab.ui.control.EditField
        helponvesselenhancePanel      matlab.ui.container.Panel
        TextAreaLabel                 matlab.ui.control.Label
        TextArea                      matlab.ui.control.TextArea
    end

    
    properties (Access = private)
        Calling_app % ÿÿÿAPP

        input_img_path
        output_img
        output_prefix
        output_path

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
                case 'image to vessel enhance'
                    [filename,path]=uigetfile({'*.nii.gz;*.nii'},'ÿÿÿÿÿÿ');
                    app.image_to_vesselenhance_EditField.Value=[path,filename];
                    app.input_img_path=app.image_to_vesselenhance_EditField.Value;
                case 'path of save image'
                    app.output_path = uigetdir('C:\Users\86133\Documents\MATLAB');
                    app.path_of_save_image_EditField.Value=app.output_path;
               
            end
        end

        % Button pushed function: startButton
        function startButtonPushed(app, event)
            info=load_untouch_nii(app.input_img_path);
            IMG=info.img;
            hdr=info.hdr;
%             ÿÿÿÿÿÿ
            spacing=hdr.dime.pixdim(2:4);%ÿÿÿ
%             disp(spacing)
            I = IMG - min(IMG(:));
            I = I / prctile(I(I(:) > 0.5 * max(I(:))),90);
            I(I>1) = 1;
            voxSpace=min(spacing);%ÿÿÿÿ
        %     scales=[voxSpace:voxSpace:10*voxSpace]; %For Human
        %     scales=[voxSpace:voxSpace:5*voxSpace]; % For External dataset        
            tau = 1;
            vesselness = vesselness3D(I, [0.5:0.5:3], [1;1;1], tau, true);
        %     vesselness = vesselness3D(I, [0.5:0.5:3], spacing, tau, true);
            Mask=imbinarize(IMG);
            Mask=double(Mask);
            
            vesselness=vesselness.*Mask;

            app.output_img=make_nii(vesselness);
            app.output_img.hdr = hdr; 
            path=[app.output_path,'\',app.output_prefix,'.nii.gz'];
            save_nii(app.output_img, path);
            uialert(app.UIFigure,"Vascular enhancement is complete," + ...
                " and the output image is saved to the corresponding path.",'Notice','Icon','success')
            
            
        end

        % Button pushed function: saveallButton
        function saveallButtonPushed(app, event)
            app.output_prefix=app.filename_prefix_EditField.Value;        
            uialert(app.UIFigure,'Input parameters have been saved!','Notice','Icon','success')
                
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

            % Create currentmodulevesselenhancePanel
            app.currentmodulevesselenhancePanel = uipanel(app.UIFigure);
            app.currentmodulevesselenhancePanel.Title = 'current module:vessel enhance';
            app.currentmodulevesselenhancePanel.Position = [26 140 573 333];

            % Create imageButtonGroup
            app.imageButtonGroup = uibuttongroup(app.currentmodulevesselenhancePanel);
            app.imageButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @imageButtonGroupSelectionChanged, true);
            app.imageButtonGroup.Title = 'image';
            app.imageButtonGroup.Position = [21 203 538 93];

            % Create imagetovesselenhanceButton
            app.imagetovesselenhanceButton = uitogglebutton(app.imageButtonGroup);
            app.imagetovesselenhanceButton.Text = 'image to vessel enhance';
            app.imagetovesselenhanceButton.Position = [11 40 170 22];
            app.imagetovesselenhanceButton.Value = true;

            % Create image_to_vesselenhance_EditField
            app.image_to_vesselenhance_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.image_to_vesselenhance_EditField.Position = [238 40 277 22];

            % Create pathofsaveimageButton
            app.pathofsaveimageButton = uitogglebutton(app.imageButtonGroup);
            app.pathofsaveimageButton.Text = 'path of save image';
            app.pathofsaveimageButton.Position = [11 19 170 22];

            % Create path_of_save_image_EditField
            app.path_of_save_image_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.path_of_save_image_EditField.Position = [238 19 277 22];

            % Create startButton
            app.startButton = uibutton(app.currentmodulevesselenhancePanel, 'push');
            app.startButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.Position = [436 23 100 22];
            app.startButton.Text = 'start';

            % Create saveparametersPanel
            app.saveparametersPanel = uipanel(app.currentmodulevesselenhancePanel);
            app.saveparametersPanel.Title = 'save parameters';
            app.saveparametersPanel.Position = [21 103 538 79];

            % Create saveallButton
            app.saveallButton = uibutton(app.saveparametersPanel, 'push');
            app.saveallButton.ButtonPushedFcn = createCallbackFcn(app, @saveallButtonPushed, true);
            app.saveallButton.Position = [415 18 100 22];
            app.saveallButton.Text = 'save all';

            % Create outputfilenameEditFieldLabel
            app.outputfilenameEditFieldLabel = uilabel(app.saveparametersPanel);
            app.outputfilenameEditFieldLabel.HorizontalAlignment = 'right';
            app.outputfilenameEditFieldLabel.Position = [11 18 88 22];
            app.outputfilenameEditFieldLabel.Text = 'output filename';

            % Create filename_prefix_EditField
            app.filename_prefix_EditField = uieditfield(app.saveparametersPanel, 'text');
            app.filename_prefix_EditField.Position = [125 18 234 22];

            % Create helponvesselenhancePanel
            app.helponvesselenhancePanel = uipanel(app.UIFigure);
            app.helponvesselenhancePanel.Title = 'help on vessel enhance';
            app.helponvesselenhancePanel.Position = [26 9 573 116];

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.helponvesselenhancePanel);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.Position = [21 51 56 22];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.helponvesselenhancePanel);
            app.TextArea.Position = [92 15 444 60];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = VE_parameter(varargin)

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