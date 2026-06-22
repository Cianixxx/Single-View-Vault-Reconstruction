function H_R = rectify_plane_from_vanishing_line(lInf, ~)
% RECTIFY_PLANE_FROM_VANISHING_LINE
% Projective rectification of a plane from its vanishing line.
%
% INPUT:
%   lInf : 3x1 vanishing line of the plane in the image
%   ~    : (dummy K, not used here)
%
% OUTPUT:
%   H_R  : 3x3 homography that maps the given plane so that its vanishing
%          line becomes the line at infinity in the rectified image.
%
% The homography has the form:
%   H = [ 1  0  0
%         0  1  0
%        -a/c  -b/c  1 ]
% where lInf = (a, b, c)^T.

lInf = lInf(:);

% normalize line so that c != 0
if abs(lInf(3)) < eps
    error('Vanishing line has lInf(3) = 0, cannot normalize.');
end
lInf = lInf / lInf(3);

a = lInf(1);
b = lInf(2);
c = lInf(3); %#ok<NASGU> % just for clarity

H_R = [ 1      0      0;
        0      1      0;
       -a     -b      1];

end
