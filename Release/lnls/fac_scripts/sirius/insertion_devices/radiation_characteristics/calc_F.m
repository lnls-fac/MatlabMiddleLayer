function F = calc_F(n,K)

% J. Clarke, pg.69

Y = n * K.^2 ./ (4*(1 + K.^2/2)); % pg 67
Jp = besselj((n+1)/2, Y);
Jn = besselj((n-1)/2, Y);
F = ((n*K).^2 ./(1+K.^2/2).^2) .* (Jp - Jn).^2;