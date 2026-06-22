function K = estimate_K_from_orthogonal_VPs(v1, v2, v3)
% ESTIMATE_K_FROM_ORTHOGONAL_VPS
% Estimate the camera intrinsic matrix K (zero skew) from three
% mutually orthogonal vanishing points.
%
%   v1, v2, v3 : vanishing points of three orthogonal scene directions
%   K          : 3x3 intrinsic matrix with structure
%                [fx  0  u0;
%                 0  fy v0;
%                 0   0  1]

% Normalize vanishing points
v1 = normalize_homog(v1);
v2 = normalize_homog(v2);
v3 = normalize_homog(v3);

V = [v1.'; v2.'; v3.'];

% Omega structure with zero skew:
% omega = [w1 0  w3
%          0  w2 w4
%          w3 w4 w5]
pairs = [1 2; 1 3; 2 3];
A = [];

for k = 1:size(pairs,1)
    i = pairs(k,1); j = pairs(k,2);
    vi = V(i,:).';
    vj = V(j,:).';

    xi=vi(1); yi=vi(2); wi=vi(3);
    xj=vj(1); yj=vj(2); wj=vj(3);

    row = [ ...
        xi*xj, ...               % w1
        yi*yj, ...               % w2
        xi*wj + wi*xj, ...       % w3
        yi*wj + wi*yj, ...       % w4
        wi*wj  ...               % w5
    ];
    A = [A; row];
end

[~,~,VV] = svd(A);
w = VV(:,end);

w1=w(1); w2=w(2); w3=w(3); w4=w(4); w5=w(5);

omega = [w1 0  w3;
         0  w2 w4;
         w3 w4 w5];

% omega_inv = K K^T  => K from Cholesky
omega_inv = inv(omega);

% IMPORTANT: use chol WITHOUT transpose, so K is upper-triangular
R = chol(omega_inv);    % R upper-triangular, R'R = omega_inv
K = R;                  % this already has the correct structure

% Normalize so that K(3,3) = 1
K = K / K(3,3);

end
