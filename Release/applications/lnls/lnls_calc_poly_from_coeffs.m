function by = lnls_calc_poly_from_coeffs(coeffs, x, n)

Xn = repmat(x(:), 1, length(n)) .^ repmat(n(:)',length(x),1);
by = Xn * coeffs(:);
