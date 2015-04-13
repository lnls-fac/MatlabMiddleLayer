function D = lnls_d_touschek(ksi)
%   D = lnls_d_touschek(ksi) is a function that calculates the 'density' function used for beam Touschek lifetime estimates
for i=1:length(ksi)
    I1(i) = quad(@(x) exp(-x)./x,ksi(i),1e9*ksi(i));
    I2(i) = quad(@(x) exp(-x).*log(x)./x,ksi(i),1e9*ksi(i));
end

D1 = -1.5*exp(-ksi) + 0.5*(3*ksi - ksi.*log(ksi) + 2).*I1 + 0.5*ksi.*I2;
D = sqrt(ksi).*D1;
