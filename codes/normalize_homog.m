function x = normalize_homog(x)
% NORMALIZE_HOMOG  Normalise homogeneous vector (last component = 1 when possible).
x = x(:);
if abs(x(end)) > eps
    x = x / x(end);
end
end
