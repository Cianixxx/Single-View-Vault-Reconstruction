function main_vault()
% MAIN_VAULT
% Complete processing pipeline for single–view geometry reconstruction
% applied to the San Maurizio vault image.
%
% Steps:
%   (1) Feature extraction (edges, corners, line structures)
%   (2) Manual selection of lines corresponding to three orthogonal
%       scene directions and computation of their vanishing points
%   (3) Estimation of the intrinsic calibration matrix K from the
%       three orthogonal vanishing points
%   (4) Rectification of a vertical plane orthogonal to the cylinder axis
%
% All intermediate results and images are saved for documentation.

clc; close all;

imgName = 'SanMaurizio.jpg';

%% ---------------------------------------------------------------------
% 1. FEATURE EXTRACTION
% ----------------------------------------------------------------------
fprintf('\n--- FEATURE EXTRACTION ---\n');
[edges, corners, linesH] = feature_extraction(imgName);
fprintf('Feature extraction completed.\n');


%% ---------------------------------------------------------------------
% 2. LINE SELECTION + VANISHING POINTS
% ----------------------------------------------------------------------
fprintf('\n--- LINE SELECTION AND VANISHING POINTS ---\n');

% vV     : vanishing point of vertical direction
% vWhite : vanishing point of horizontal direction orthogonal to axis
% vAxis  : vanishing point of horizontal direction parallel to axis
% lInf   : vanishing line of vertical planes orthogonal to the axis
[vV, vWhite, vAxis, lInf] = select_lines_and_VPs(imgName);

fprintf('\nComputed vanishing points:\n');
fprintf('  v_V      = [%f, %f, %f]\n', vV);
fprintf('  v_white  = [%f, %f, %f]\n', vWhite);
fprintf('  v_axis   = [%f, %f, %f]\n', vAxis);
fprintf('  l_inf    = [%f, %f, %f]\n', lInf);


%% ---------------------------------------------------------------------
% 3. INTRINSIC CALIBRATION FROM ORTHOGONAL VANISHING POINTS
% ----------------------------------------------------------------------
fprintf('\n--- INTRINSIC CALIBRATION ---\n');

K = estimate_K_from_orthogonal_VPs(vV, vWhite, vAxis);

fprintf('Estimated intrinsic matrix K:\n');
disp(K);


%% ---------------------------------------------------------------------
% 4. RECTIFICATION OF A VERTICAL PLANE ORTHOGONAL TO THE AXIS
% ----------------------------------------------------------------------
fprintf('\n--- PLANE RECTIFICATION ---\n');

img = imread(imgName);
if size(img,3) == 3
    Igray = rgb2gray(img);
else
    Igray = img;
end
Igray = im2double(Igray);

% Compute rectifying homography
H_R = rectify_plane_from_vanishing_line(lInf, K);

% Apply homography to obtain the rectified view
tform = projective2d(H_R');
rectified = imwarp(Igray, tform);

figure; imshow(rectified);
title('Rectified vertical plane (up to a similarity transformation)');
imwrite(rectified, 'output_rectified_plane.png');

fprintf('Rectified plane saved as output_rectified_plane.png\n\n');

% ---------------------------------------------------------------------
% 4. RECTIFICATION OF A VERTICAL PLANE ORTHOGONAL TO THE AXIS
% ----------------------------------------------------------------------
fprintf('\n--- PLANE RECTIFICATION ---\n');

img = imread(imgName);
if size(img,3) == 3
    Igray = rgb2gray(img);
else
    Igray = img;
end
Igray = im2double(Igray);

% Compute projective rectification homography from vanishing line
H_R = rectify_plane_from_vanishing_line(lInf, K);

% Apply homography to obtain a rectified view of the chosen vertical plane
tform = projective2d(H_R');
rectified = imwarp(Igray, tform);

figure; imshow(rectified);
title('Rectified vertical plane (up to a similarity transformation)');
imwrite(rectified, 'output_rectified_plane.png');

fprintf('Rectified plane saved as output_rectified_plane.png\n');


% ---------------------------------------------------------------------
% 5. DIAGONAL ARC: NODAL POINTS AND CIRCLE FITTING
% ----------------------------------------------------------------------
fprintf('\n--- DIAGONAL ARC: NODAL POINTS AND CIRCLE FITTING ---\n');

% Known distance between two neighbouring arcs of the same family
d_known = 1.0;    % the project states d = 1

[circleParams, nodal_rect, nodal_metric, scaleFactor] = ...
    fit_diagonal_arc_circle(rectified, d_known);

fprintf('Estimated circle in rectified coordinates:\n');
fprintf('  center_rect = (%.4f , %.4f)\n', circleParams.center_rect(1), circleParams.center_rect(2));
fprintf('  radius_rect = %.4f\n', circleParams.radius_rect);

fprintf('Metric scale factor (world units per pixel): %.6f\n', scaleFactor);
fprintf('Circle in metric units (using d = 1):\n');
fprintf('  center_metric = (%.4f , %.4f)\n', circleParams.center_metric(1), circleParams.center_metric(2));
fprintf('  radius_metric = %.4f\n', circleParams.radius_metric);

fprintf('\nCircle plot saved as output_rectified_arc_circle.png\n\n');

% ---------------------------------------------------------------------
% 6. CAMERA POSE RELATIVE TO THE VAULT
% ----------------------------------------------------------------------
fprintf('--- CAMERA POSE ESTIMATION ---\n');

[Rcw, Rwc, Cw] = estimate_camera_pose_from_VPs(K, vV, vWhite, vAxis);

fprintf('Rotation (world -> camera), R_cw:\n');
disp(Rcw);

fprintf('Rotation (camera -> world), R_wc = R_cw^T:\n');
disp(Rwc);

fprintf('Camera centre in world coordinates (up to scale):\n');
disp(Cw);

end

