function plot_gains(respm, Rc, Rb, Rc2, Rb2)

n_ch = (size(respm, 2) - 1)/2;
n_cv = (size(respm, 2) - 1) - n_ch;

figure; 
plot(squeeze(Rc(1, 1, 1:n_ch)), '-o'); 
grid on; 
hold on; 
plot(squeeze(Rc2(1, 1, 1:n_ch)), '-o'); 
title('CH Gain Factors');
legend('BPM then Corr', 'Corr then BPM');
% legend('Minimum');

figure; 
plot(squeeze(Rc(2, 2, n_ch+1:n_ch+n_cv)), '-o'); 
grid on;
hold on;
plot(squeeze(Rc2(2, 2, n_ch+1:n_ch+n_cv)), '-o'); 
title('CV Gain Factors');
legend('BPM then Corr', 'Corr then BPM');
% legend('Minimum');

figure; 
plot(squeeze(Rb(1, 1, :)), '-o'); 
grid on; 
hold on; 
plot(squeeze(Rb2(1, 1, :)), '-o'); 
title('BPM X Gain Factors');
legend('BPM then Corr', 'Corr then BPM');
% legend('Minimum');

figure; 
plot(squeeze(Rb(2, 2, :)), '-o'); 
grid on;
hold on;
plot(squeeze(Rb2(2, 2, :)), '-o'); 
title('BPM Y Gain Factors');
legend('BPM then Corr', 'Corr then BPM');
% legend('Minimum');



end