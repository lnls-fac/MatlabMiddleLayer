function flux = calc_flux(N, I, n, K)

% J. Clarke, pg.71, eq.(4.14)

bandwidth = 0.001; % (0.1%)
const = lnls_constants;

Q = calc_Q(n,K);
flux = const.alpha * pi * N * (I/abs(const.q0)) * bandwidth * Q;