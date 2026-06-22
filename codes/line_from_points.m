function l = line_from_points(p1, p2)
% LINE_FROM_POINTS
% Build a 2D homogeneous line passing through two image points.
%
% INPUT:
%   p1, p2 : 1x2 points in image coordinates
%
% OUTPUT:
%   l : 3x1 homogeneous line, defined as l = p1 × p2

p1h = [p1(:); 1];
p2h = [p2(:); 1];

l = cross(p1h, p2h);

if norm(l(1:2)) > 0
    l = l / norm(l(1:2));
end

end
