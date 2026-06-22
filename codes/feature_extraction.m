function [edges, corners, linesH] = feature_extraction(imgName)

fprintf('Loading image: %s\n', imgName);

% Load image
img = imread(imgName);

figure; imshow(img); title('Original image');
imwrite(img, 'output_original.png');

% Convert to grayscale
if size(img,3) == 3
    I = rgb2gray(img);
else
    I = img;
end
I = im2double(I);

% ---------------------------------------------------------------------
% Edge detection: Canny tuned for architectural images
% ---------------------------------------------------------------------
% Slightly higher thresholds → meno rumore, bordi più stabili
edges = edge(I,'canny',[0.07 0.18], 1.0);  % last parameter = sigma
figure; imshow(edges); title('Canny edges (tuned)');
imwrite(edges,'output_edges_canny_tuned.png');

% ---------------------------------------------------------------------
% Corner detection (Harris)
% ---------------------------------------------------------------------
corners = detectHarrisFeatures(I);
figure; imshow(I); hold on;
plot(corners.selectStrongest(300));   % 300 better for rich textures
title('Harris corners');
hold off;
imwrite(getframe(gca).cdata, 'output_harris_corners.png');

% ---------------------------------------------------------------------
% Line detection (Hough transform) – OPTIMIZED
% ---------------------------------------------------------------------

% Dilate edges to strengthen line connectivity for Hough
edges2 = bwmorph(edges,'bridge');  % connect small gaps
edges2 = bwmorph(edges2,'thin');   % thin edges
edges2 = bwmorph(edges2,'spur');   % remove tiny spurious branches

% Hough transform
[H,theta,rho] = hough(edges2);

% Pick a higher number of peaks → catch all dominant directions
numPeaks = 40;
peaks = houghpeaks(H, numPeaks, ...
                   'Threshold', 0.25*max(H(:)), ...
                   'NHoodSize', [17 17]);

% Extract line candidates
linesH = houghlines(edges2, theta, rho, peaks, ...
                    'FillGap', 40, ...  % connects longer segments
                    'MinLength', 120);  % avoid tiny noisy lines

% Plot detected lines — UNIFORM STYLE
figure; imshow(img); hold on;
for k = 1:numel(linesH)
    xy = [linesH(k).point1; linesH(k).point2];
    plot(xy(:,1), xy(:,2), 'g-', 'LineWidth', 1);  % green uniform lines
end
title('Detected Hough lines (tuned)');
hold off;
imwrite(getframe(gca).cdata, 'output_hough_lines_tuned.png');

end
