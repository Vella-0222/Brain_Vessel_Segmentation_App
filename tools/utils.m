% Some useful codes.

%% FCM clustering main part.
% IMG is histogram matched TOF-MRA image
% K is the number of class for FCM clustering, K=4
% m is fuzzy weighting exponent, m <= 1.8

% FastFCM clustering
img = int32(IMG(IMG > 0));
[C, U, LUT, H] = FastFCMeans(img(:), K, m, false); % perform FCM segmentation
L = LUT2label(img, LUT);

% get FCM clustering results
FCM_seg = zeros(size(IMG)); 
OriginId = find(IMG > 0);
FCM_seg(OriginId(L(:) == K)) = 1;

if K > 3
    FCM_seg(OriginId(L(:) == K - 1)) = 1;
end

% get ratio of each class
W = zeros(1,K);
for c = 1:4
    W(c) = length(find(L(:) == c)) / numel(IMG(IMG ~= 0));
end

%% MRF refinement main part
% FCM_seg is FastFCM clustering result
% vesselness is vessel enhancement result
% U is fuzzy membership matrix from FastFCMeans
% beta = 0.2 derived from tunning experiments
% W is ratio of each class
% The number of MRF iterations is typically 10
beta = 0.2;
IL = 10;
[MRF_seg] = MRF(FCM_seg, IMG, vesselness, U, beta, W, IL);

%% remove little islands
[MRF_seg_refine, ~, ~] = Connection_Judge_3D(MRF_seg, 0, [], 20, 3);

