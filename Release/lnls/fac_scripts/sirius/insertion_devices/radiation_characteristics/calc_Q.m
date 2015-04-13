function Q = calc_Q(n,K)

% J. Clarke, pg.71,

F = calc_F(n,K);
Q = F .* (1 + K.^2/2) / n;