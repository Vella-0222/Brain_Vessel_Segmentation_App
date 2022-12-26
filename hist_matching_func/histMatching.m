%histMatching - Description
%
% Syntax: ImageT = HistMatching(ImageT,targetDS)
%Tran_Image_NoGauss
% Long description
function [Trans_Image] = HistMatching(MRA_brain,targetHist)
    % Histogram matching for MRA image after preprocessing.

    % INPUT:
    %   - MRA_brain : MRA image after preprocessing, including skull
    %                 stripping, denoising and bias field Correction.
    %   - targetHist: target histogram, chosen based on MRI scanner.
    
    % load image and its header 
    Image = double(MRA_brain);
    hdr = MRA_data.hdr;

%     二值化
    Mask=Image>0;
    Mask=double(Mask);
    Mask(Mask>0)=1;

    g_kernel = fspecial3('gaussian',3,0.4);%高斯滤波
    FImage=imfilter(Image,g_kernel).*Mask;

    load(targetHist,'target_hist')
    [Trans_Image] = Hist_match3D(target_hist,FImage);
%     FImage_NoGauss=ImageT.*Mask;
%     [Tran_Image_NoGauss]=Hist_match3D(Target_Hist,FImage_NoGauss);

%     t=toc;%显示时间
%     disp(['calculate the hist of the Final Image---runtime = ' num2str(t)]);pause(0.1);
%     img = Trans_Image((Trans_Image>0));
%     LengthIMG = numel(img);
%     Max_img = max(img(:));
%     [N,~] = hist(img(:),0:Max_img); 
%     Trans_Hist=N'/LengthIMG;
%     subplot(2,1,1);plot(0:length(Trans_Hist)-1,Trans_Hist,'-k','LineWidth',2);
%     
% %     未作高斯平滑
%     img_nogauss = Tran_Image_NoGauss((Tran_Image_NoGauss>0));
%     LengthIMG_nogauss = numel(img_nogauss);
%     Max_img_nogauss = max(img_nogauss(:));
%     [N_nogauss,~] = hist(img_nogauss(:),0:Max_img_nogauss); 
%     Trans_Hist_nogauss=N_nogauss'/LengthIMG_nogauss;
%     subplot(2,1,2);plot(0:length(Trans_Hist_nogauss)-1,Trans_Hist_nogauss,'-b','LineWidth',2);
% 
%     
%     tic;
    
    Trans_Image = Trans_Image.*Mask;
%     Tran_Image_NoGauss=Tran_Image_NoGauss.*Mask;
    
    % save transformed image
%     output = make_nii(Trans_Image);
%     output.hdr = hdr;
%     save_nii(output, 'Output/Output097-MRA.nii.gz')
end