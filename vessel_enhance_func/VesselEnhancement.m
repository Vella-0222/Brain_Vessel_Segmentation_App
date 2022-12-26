function [vesselness] = VesselEnhancement(MRA_brain, MRA_brain_match)
    % Vessel enhancement for preprocesse MRA image.

    % INPUT:
    %   - MRA_brain       : TOF-MRA image after preprocess, including
    %                       skullstripping, denoise and bias field correction.
    %   - MRA_brain_match : TOF-MRA image after histogram specification.
    
    MRA_brain = double(MRA_brain);
    MRA_brain_match = double(MRA_brain_match);
    mask = double(MRA_brain_match > 0); % new mask instead of original mask
    img = MRA_brain .* mask;

    % some preprocess to remove border false enhanced region
    % the contrast between the vessels and liver tissue is improved.
    % For example, we remove all values bellow the 10th percentile
    % lower_thr = prctile(img(mask(:) == 1), 1);
    % img = img - lower_thr;
    % img(img < 0) = 0;

    % Similarly we equalize the values of some remaining bones and vessels
    upper_thr = prctile(img(mask(:) == 1), 99.9);
    img(img > upper_thr) = upper_thr;

    % remove the border of the brain so it can't be enhanced. This can probably be improved.
    img(mask(:) == 0) = median(img(mask(:) == 1));

    % just normalize the values (not really needed)
    % img_norm = img / max(img(:));

    % specify params and do vessel enhance
    sigmas = [0.5:0.5:3];
    spacing = [1 1 1];

    tau = 0.75; % tau chosen from validation results of tunning subs
    [vesselness] = vessel_enhance_3d(img, mask, sigmas, spacing, tau);
end

function [vesselness] = vessel_enhance_3d(img, mask, sigmas, spacing, tau)
    % enhance 3d image with jerman's method for dilated version in order of
    % avoiding border false positives

    I = img - min(img(:));
    I = I / prctile(I(I(:) > 0.5 * max(I(:))), 90);
    I(I > 1) = 1;

    vesselness = vesselness3D(I, sigmas, spacing, tau, true);
    vesselness = vesselness .* mask;

end