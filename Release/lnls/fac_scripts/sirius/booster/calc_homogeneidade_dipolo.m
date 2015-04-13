x = (1:0.05:10)'*1e-3;
x0 = 2e-2;
xn = x/x0;
coef = [0*2.7E-05 4.0E-04 2.3E-03 2.7E-03 0.9e-3 1.5e-3]'; 
coef(3:end)=coef(3:end)*2;
mat = [xn xn.^2 xn.^3 xn.^4 xn.^5 xn.^6];
poli = mat*coef;
plot(x, poli)
clear poli mat coef xn x0 x