classdef FCM_parameter < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        FileMenu                      matlab.ui.container.Menu
        EditMenu                      matlab.ui.container.Menu
        currentmodulefastfuzzyCmeansPanel  matlab.ui.container.Panel
        imageButtonGroup              matlab.ui.container.ButtonGroup
        imagetofuzzyCmeansButton      matlab.ui.control.ToggleButton
        image_to_fuzzy_C_means_EditField  matlab.ui.control.EditField
        pathofsaveimageButton         matlab.ui.control.ToggleButton
        path_of_save_image_EditField  matlab.ui.control.EditField
        startButton                   matlab.ui.control.Button
        saveoutputButton              matlab.ui.control.Button
        FCMresultPanel                matlab.ui.container.Panel
        FCMsegmentationcentersEditFieldLabel  matlab.ui.control.Label
        FCMsegmentationcentersEditField  matlab.ui.control.EditField
        saveparametersPanel           matlab.ui.container.Panel
        FCMparammEditFieldLabel       matlab.ui.control.Label
        FCMparammEditField            matlab.ui.control.NumericEditField
        saveallButton                 matlab.ui.control.Button
        outputfilenameEditFieldLabel  matlab.ui.control.Label
        filename_prefix_EditField     matlab.ui.control.EditField
        helponfastfuzzyCmeansPanel    matlab.ui.container.Panel
        TextAreaLabel                 matlab.ui.control.Label
        TextArea                      matlab.ui.control.TextArea
    end

    
    properties (Access = private)
        Calling_app % ÿÿÿAPP
        input_img_path
        output_img
        output_prefix
        output_path
        m_value
        k_value
        membership_mat
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
                case 'image to fuzzy C-means'
                    [filename,path]=uigetfile({'*.nii.gz;*.nii'},'ÿÿÿÿÿÿ');
                    app.image_to_fuzzy_C_means_EditField.Value=[path,filename];
                    app.input_img_path=app.image_to_fuzzy_C_means_EditField.Value;
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
%             K-meansÿÿÿÿÿÿÿ
            app.k_value=4;
            [C_init] = kmeans_init(IMG,app.k_value,[],[]);
            img=int32(IMG(IMG~=0));
%             FCM
            [C,U,LUT,H]=FastFCMeans(img(:),C_init,app.m_value,false) ;% perform FCM segmentation
            disp('FCM segmentation centers are:' );
            disp(C);
            app.membership_mat=U;
            center='';
            for ii=1:length(C)
                center=[center,num2str(C(ii))];
                if ii~=length(C)
                    center=[center,','];
                end
            end
            app.FCMsegmentationcentersEditField.Value=center;
            L=LUT2label(img,LUT);
            % Get FCM resultsÿÿFCMÿÿÿÿÿÿ
            FCM_seg=zeros(size(IMG));
            OriginId=find(IMG~=0);
            FCM_seg(OriginId(L(:)==app.k_value))=1;
            if app.k_value>3
                FCM_seg(OriginId(L(:)==app.k_value-1))=1;
            end
            app.output_img=make_nii(FCM_seg);
            app.output_img.hdr = hdr; 
            uialert(app.UIFigure,"FCM segmentation is complete, please check the cluster" + ...
                " centre to decide whether to save the image, to save the image click the button'save output'.",'Notice','Icon','success')
            
            
        end

        % Button pushed function: saveoutputButton
        function saveoutputButtonPushed(app, event)
            path=[app.output_path,'\',app.output_prefix,'.nii.gz'];
            save_nii(app.output_img, path);
            path=[app.output_path,'\',app.output_prefix,'_membership.mat'];
            membership=app.membership_mat;
            save(path,'membership');
            uialert(app.UIFigure,'The image and the membership matrix are saved and can be viewed in the corresponding path.','Notice','Icon','success')
            
        end

        % Button pushed function: saveallButton
        function saveallButtonPushed(app, event)
            app.m_value=app.FCMparammEditField.Value;
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

            % Create currentmodulefastfuzzyCmeansPanel
            app.currentmodulefastfuzzyCmeansPanel = uipanel(app.UIFigure);
            app.currentmodulefastfuzzyCmeansPanel.Title = 'current module:fast fuzzy C-means';
            app.currentmodulefastfuzzyCmeansPanel.Position = [26 140 573 333];

            % Create imageButtonGroup
            app.imageButtonGroup = uibuttongroup(app.currentmodulefastfuzzyCmeansPanel);
            app.imageButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @imageButtonGroupSelectionChanged, true);
            app.imageButtonGroup.Title = 'image';
            app.imageButtonGroup.Position = [21 203 538 93];

            % Create imagetofuzzyCmeansButton
            app.imagetofuzzyCmeansButton = uitogglebutton(app.imageButtonGroup);
            app.imagetofuzzyCmeansButton.Text = 'image to fuzzy C-means';
            app.imagetofuzzyCmeansButton.Position = [11 40 170 22];
            app.imagetofuzzyCmeansButton.Value = true;

            % Create image_to_fuzzy_C_means_EditField
            app.image_to_fuzzy_C_means_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.image_to_fuzzy_C_means_EditField.Position = [238 40 277 22];

            % Create pathofsaveimageButton
            app.pathofsaveimageButton = uitogglebutton(app.imageButtonGroup);
            app.pathofsaveimageButton.Text = 'path of save image';
            app.pathofsaveimageButton.Position = [11 19 170 22];

            % Create path_of_save_image_EditField
            app.path_of_save_image_EditField = uieditfield(app.imageButtonGroup, 'text');
            app.path_of_save_image_EditField.Position = [238 19 277 22];

            % Create startButton
            app.startButton = uibutton(app.currentmodulefastfuzzyCmeansPanel, 'push');
            app.startButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.Position = [436 62 100 22];
            app.startButton.Text = 'start';

            % Create saveoutputButton
            app.saveoutputButton = uibutton(app.currentmodulefastfuzzyCmeansPanel, 'push');
            app.saveoutputButton.ButtonPushedFcn = createCallbackFcn(app, @saveoutputButtonPushed, true);
            app.saveoutputButton.Position = [436 21 100 22];
            app.saveoutputButton.Text = 'save output';

            % Create FCMresultPanel
            app.FCMresultPanel = uipanel(app.currentmodulefastfuzzyCmeansPanel);
            app.FCMresultPanel.Title = 'FCM result';
            app.FCMresultPanel.Position = [21 21 400 63];

            % Create FCMsegmentationcentersEditFieldLabel
            app.FCMsegmentationcentersEditFieldLabel = uilabel(app.FCMresultPanel);
            app.FCMsegmentationcentersEditFieldLabel.HorizontalAlignment = 'right';
            app.FCMsegmentationcentersEditFieldLabel.Position = [13 6 150 22];
            app.FCMsegmentationcentersEditFieldLabel.Text = 'FCM segmentation centers';

            % Create FCMsegmentationcentersEditField
            app.FCMsegmentationcentersEditField = uieditfield(app.FCMresultPanel, 'text');
            app.FCMsegmentationcentersEditField.Position = [178 6 210 22];

            % Create saveparametersPanel
            app.saveparametersPanel = uipanel(app.currentmodulefastfuzzyCmeansPanel);
            app.saveparametersPanel.Title = 'save parameters';
            app.saveparametersPanel.Position = [21 103 538 79];

            % Create FCMparammEditFieldLabel
            app.FCMparammEditFieldLabel = uilabel(app.saveparametersPanel);
            app.FCMparammEditFieldLabel.HorizontalAlignment = 'right';
            app.FCMparammEditFieldLabel.Position = [11 29 99 22];
            app.FCMparammEditFieldLabel.Text = 'FCM param:m     ';

            % Create FCMparammEditField
            app.FCMparammEditField = uieditfield(app.saveparametersPanel, 'numeric');
            app.FCMparammEditField.Position = [126 29 220 22];

            % Create saveallButton
            app.saveallButton = uibutton(app.saveparametersPanel, 'push');
            app.saveallButton.ButtonPushedFcn = createCallbackFcn(app, @saveallButtonPushed, true);
            app.saveallButton.Position = [415 18 100 22];
            app.saveallButton.Text = 'save all';

            % Create outputfilenameEditFieldLabel
            app.outputfilenameEditFieldLabel = uilabel(app.saveparametersPanel);
            app.outputfilenameEditFieldLabel.HorizontalAlignment = 'right';
            app.outputfilenameEditFieldLabel.Position = [11 8 88 22];
            app.outputfilenameEditFieldLabel.Text = 'output filename';

            % Create filename_prefix_EditField
            app.filename_prefix_EditField = uieditfield(app.saveparametersPanel, 'text');
            app.filename_prefix_EditField.Position = [125 8 221 22];

            % Create helponfastfuzzyCmeansPanel
            app.helponfastfuzzyCmeansPanel = uipanel(app.UIFigure);
            app.helponfastfuzzyCmeansPanel.Title = 'help on fast fuzzy C-means';
            app.helponfastfuzzyCmeansPanel.Position = [26 9 573 116];

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.helponfastfuzzyCmeansPanel);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.Position = [21 51 56 22];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.helponfastfuzzyCmeansPanel);
            app.TextArea.Position = [92 15 444 60];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FCM_parameter(varargin)

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