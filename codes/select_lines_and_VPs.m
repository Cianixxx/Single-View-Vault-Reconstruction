function [vV, vWhite, vAxis, lInf] = select_lines_and_VPs(imgName)
% SELECT_LINES_AND_VPS
% Manual selection of lines and computation of vanishing points.
%
% INPUT:
%   imgName : name of the image file
%
% OUTPUT:
%   vV     : vanishing point of VERTICAL direction
%   vWhite : vanishing point of WHITE horizontal direction (orthogonal to axis)
%   vAxis  : vanishing point of horizontal direction PARALLEL to cylinder axis
%   lInf   : vanishing line of vertical planes orthogonal to the axis

img = imread(imgName);

% ---------------------------------------------------------------------
% 1) Vertical lines (BLACK in the homework)
% ---------------------------------------------------------------------
fprintf('\nSelect 2 VERTICAL lines (black in the homework figure).\n');
fprintf('Click 2 points on vertical line 1, then 2 points on vertical line 2.\n');

figure; imshow(img); title('Select VERTICAL lines (2 points per line)');
[xv, yv] = ginput(4);
vert_pts = [xv(:), yv(:)];
close;

% ---------------------------------------------------------------------
% 2) Horizontal lines PARALLEL to the cylinder axis (GREEN + YELLOW)
% ---------------------------------------------------------------------
fprintf('\nSelect 2 HORIZONTAL lines PARALLEL TO THE AXIS (green/yellow).\n');
fprintf('These are the green/yellow lines in the homework figure.\n');
fprintf('Again: 2 points on line 1, then 2 points on line 2.\n');

figure; imshow(img); title('Select HORIZ. lines || axis (2 points per line)');
[xa, ya] = ginput(4);
axis_pts = [xa(:), ya(:)];
close;

% ---------------------------------------------------------------------
% 3) WHITE horizontal lines (orthogonal to the axis)
% ---------------------------------------------------------------------
fprintf('\nSelect 2 WHITE HORIZONTAL lines (orthogonal to the axis).\n');
fprintf('They connect symmetric nodal points (white lines in the homework figure).\n');

figure; imshow(img); title('Select WHITE horizontal lines (2 points per line)');
[xw, yw] = ginput(4);
white_pts = [xw(:), yw(:)];
close;

% ---------------------------------------------------------------------
% Build homogeneous lines
% ---------------------------------------------------------------------
lV1 = line_from_points(vert_pts(1,:), vert_pts(2,:));
lV2 = line_from_points(vert_pts(3,:), vert_pts(4,:));

lA1 = line_from_points(axis_pts(1,:), axis_pts(2,:)); % axis-parallel
lA2 = line_from_points(axis_pts(3,:), axis_pts(4,:));

lW1 = line_from_points(white_pts(1,:), white_pts(2,:)); % white horizontals
lW2 = line_from_points(white_pts(3,:), white_pts(4,:));

% ---------------------------------------------------------------------
% Vanishing points
% ---------------------------------------------------------------------
vV     = normalize_homog(cross(lV1, lV2));
vAxis  = normalize_homog(cross(lA1, lA2));
vWhite = normalize_homog(cross(lW1, lW2));

% Vanishing line of vertical planes ⟂ axis: span{vertical, white}
lInf = normalize_homog(cross(vV, vWhite));

% ---------------------------------------------------------------------
% Visualisation: selected lines with the SAME COLORS as in the homework
% ---------------------------------------------------------------------
figure; imshow(img); hold on;

% VERTICAL: BLACK
plot(vert_pts(1:2,1),vert_pts(1:2,2),'k.-','LineWidth',2);
plot(vert_pts(3:4,1),vert_pts(3:4,2),'k.-','LineWidth',2);

% HORIZ. || AXIS: first GREEN, second YELLOW
plot(axis_pts(1:2,1), axis_pts(1:2,2),'g.-','LineWidth',2); % green
plot(axis_pts(3:4,1), axis_pts(3:4,2),'y.-','LineWidth',2); % yellow

% WHITE HORIZONTALS: WHITE
plot(white_pts(1:2,1),white_pts(1:2,2),'w.-','LineWidth',2);
plot(white_pts(3:4,1),white_pts(3:4,2),'w.-','LineWidth',2);

title('Selected lines (vertical=black, ||axis=green/yellow, white=white)');
hold off;

imwrite(getframe(gca).cdata,'output_selected_lines.png');

% ---------------------------------------------------------------------
% Visualisation: vanishing points
% ---------------------------------------------------------------------
figure; imshow(img); hold on;

plot_vp(vV,    'k');  % vertical VP in black
plot_vp(vAxis, 'g');  % axis VP in green (one color is enough)
plot_vp(vWhite,'w');  % white VP in white

legend({'v_V (vertical)','v_{axis} (|| axis)','v_{white} (orthogonal)'}, ...
       'TextColor','w','Location','southoutside');

title('Vanishing points: vertical (black), axis (green), white (white)');
hold off;

imwrite(getframe(gca).cdata,'output_vanishing_points.png');

end

% -------------------------------------------------------------------------
% helper: plot homogeneous VP, if finite
% -------------------------------------------------------------------------
function plot_vp(vp, colorChar)
vp = vp(:);
if abs(vp(3)) < eps
    % point at infinity: cannot be plotted inside finite image
    return;
end
u = vp(1)/vp(3);
v = vp(2)/vp(3);
plot(u, v, [colorChar 'o'],'MarkerSize',8,'LineWidth',2);
end
