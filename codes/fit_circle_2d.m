function [center, radius] = fit_circle_2d(pts)
% FIT_CIRCLE_2D
% Fit a circle to 2D points using a simple algebraic least squares method.
%
% INPUT:
%   pts : Nx2 matrix of 2D points [x_i, y_i]
%
% OUTPUT:
%   center : 2x1 vector [cx; cy]
%   radius : scalar radius

x = pts(:,1);
y = pts(:,2);

% Build linear system A * p = b with
% p = [a; b; c], center = (a, b), radius^2 = c + a^2 + b^2
A = [2*x, 2*y, ones(size(x))];
b = x.^2 + y.^2;

p = A \ b;
a = p(1);
b0 = p(2);
c = p(3);

center = [a; b0];
radius = sqrt(max(c + a^2 + b0^2, 0));

end
