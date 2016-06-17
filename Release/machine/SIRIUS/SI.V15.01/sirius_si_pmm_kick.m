function [x, integ_field, kickx, LPolyB] = sirius_si_pmm_kick(strength, fit_monomials, plot_flag)

if ~exist('plot_flag','var')
    plot_flag = false;
end

maxfield = [ ...
% posx[mm] field[T.m]
-12.0,	-0.02739751;
-11.5,	-0.036091191;
-11.0,	-0.045815978;
-10.5,	-0.056468018;
-10.0,	-0.067314;
-9.5,	-0.077369581;
-9.0,	-0.085662273;
-8.5,	-0.091400168;
-8.0,	-0.094065576;
-7.5,	-0.09345044;
-7.0,	-0.08964827;
-6.5,	-0.083015408;
-6.0,	-0.074112536;
-5.5,	-0.063635622;
-5.0,	-0.052343848;
-4.5,	-0.040990576;
-4.0,	-0.030261996;
-3.5,	-0.020726824;
-3.0,	-0.012799267;
-2.5,	-0.006716409;
-2.0,	-0.002530252;
-1.5,	-0.000113827;
-1.0,	 0.000819894;
-0.5,	 0.00068816;
0.0,	 0;
0.5,	-0.00068816;
1.0,    -0.000819894;
1.5,	 0.000113827;
2.0,	 0.002530252;
2.5,	 0.006716409;
3.0,	 0.012799267;
3.5,	 0.020726824;
4.0,	 0.030261996;
4.5,	 0.040990576;
5.0,	 0.052343848;
5.5,	 0.063635622;
6.0,	 0.074112536;
6.5,	 0.083015408;
7.0,	 0.08964827;
7.5,	 0.09345044;
8.0,	 0.094065576;
8.5,	 0.091400168;
9.0,	 0.085662273;
9.5,	 0.077369581;
10.0,	 0.067314;
10.5,	 0.056468018;
11.0,	 0.045815978;
11.5,	 0.036091191;
12.0,	 0.02739751;
];

if  ~exist('fit_monomials','var')
    fit_monomials = [2,3,4,5,6,7,8,9,10];
end



x = maxfield(:,1)*0.001;
[~,~,brho] = lnls_beta_gamma(3.0);
integ_field = strength * maxfield(:,2);
kickx = integ_field / brho;

[coeffs, fit_kickx] = lnls_polyfit(x, kickx, fit_monomials);
if plot_flag
    figure; hold all; plot(1000*x, 1000*kickx); plot(1000*x,1000*fit_kickx);
    xlabel('x / mm'); ylabel('kick / mrad');
    title('PMM kick'); legend({'data points', 'fitted curve'});
end

% LPolyB = PolynomB * L
LPolyB = zeros(1,1+max(fit_monomials));
LPolyB(1+fit_monomials) = -coeffs;
