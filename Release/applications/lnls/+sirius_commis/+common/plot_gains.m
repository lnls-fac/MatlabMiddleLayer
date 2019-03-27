function plot_gains(fit_data)

respm = fit_data.respm;
n_ch = (size(respm, 2) - 1)/2;
n_cv = (size(respm, 2) - 1) - n_ch;

figure; 
plot(squeeze(fit_data.Rc(1, 1, 1:n_ch)), '-o'); 
grid on; 
hold on; 
title('CH Gain Factors'); 
legend('Minimum');

figure; 
plot(squeeze(fit_data.Rc(2, 2, n_ch+1:n_ch+n_cv)), '-o'); 
grid on; 
title('CV Gain Factors'); 
legend('Minimum');

end