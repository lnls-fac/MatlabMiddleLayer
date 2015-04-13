function [coeffs, y_fit] = lnls_polyfit(x, y, n)

warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
warning('off', 'MATLAB:nearlySingularMatrix');

Xn = repmat(x(:), 1, length(n)) .^ repmat(n(:)',length(x),1);
b  = Xn' * y(:);
X  = Xn' * Xn;
coeffs  = X \ b;
y_fit = Xn * coeffs;
