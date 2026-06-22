function [R_cw, R_wc, C_w] = estimate_camera_pose_from_VPs(K, vV, vWhite, vAxis)
% ESTIMATE_CAMERA_POSE_FROM_VPS
% Estimate the camera orientation relative to the vault using three
% vanishing points corresponding to mutually orthogonal scene directions.
%
% World frame definition:
%   X_w : direction of the WHITE horizontals (orthogonal to cylinder axis)
%   Y_w : VERTICAL direction
%   Z_w : direction PARALLEL to the cylinder axis
%
% Camera frame: standard pinhole convention.
%
% INPUT:
%   K      : 3x3 intrinsic matrix
%   vV     : vanishing point of vertical lines
%   vWhite : vanishing point of white horizontal lines
%   vAxis  : vanishing point of axis–parallel lines
%
% OUTPUT:
%   R_cw : 3x3 rotation matrix mapping world coords to camera coords
%   R_wc : inverse rotation (camera -> world)
%   C_w  : camera centre in world coordinates (set to [0;0;0], i.e.
%          pose is defined up to a global similarity transform)

% Invert K once
Kinv = inv(K);

% Directions in camera coordinates (up to scale):
% rX_c ~ K^{-1} vWhite   (world X_w)
% rY_c ~ K^{-1} vV       (world Y_w)
% rZ_c ~ K^{-1} vAxis    (world Z_w)
dX = Kinv * normalize_homog(vWhite);
dY = Kinv * normalize_homog(vV);
dZ = Kinv * normalize_homog(vAxis);

% Normalise to unit length
dX = dX / norm(dX);
dY = dY / norm(dY);
dZ = dZ / norm(dZ);

% Enforce orthonormality with a simple Gram–Schmidt clean–up
dY = dY - dot(dY,dX) * dX;   dY = dY / norm(dY);
dZ = cross(dX, dY);          dZ = dZ / norm(dZ);

% Assemble rotation matrix: columns are world axes expressed in camera frame
R_cw = [dX, dY, dZ];

% Ensure a proper rotation (determinant +1)
if det(R_cw) < 0
    R_cw(:,3) = -R_cw(:,3);
end

% Inverse rotation (camera -> world)
R_wc = R_cw.';

% Camera centre in world coordinates:
% without extra metric info, translation is only defined up to a
% similarity; we set the origin at an arbitrary reference point.
C_w = [0; 0; 0];

end
