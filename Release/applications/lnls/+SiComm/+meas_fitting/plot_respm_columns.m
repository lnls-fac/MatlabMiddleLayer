function delta_m = plot_respm_columns(respm_meas, respm_theory, respm_correct, n_bpm, fam, plane)

ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
bpm_idx = bpm(n_bpm);

if strcmp(plane, 'x')
    before = ch < bpm_idx;
    ch_before = ch(before);
    range = find(ch == ch_before(1)):find(ch == ch_before(end));
    n = 1;
elseif strcmp(plane, 'y')
    before = cv < bpm_idx;
    cv_before = cv(before);
    range = find(cv == cv_before(1)):find(cv == cv_before(end));
    range = length(ch) + range;
    n = 2;
end




for i=range
    % sirius_commis.common.plot_respm(respm_meas, respm_theory, respm_correct, i);
    v_bpm_meas(1, i) = respm_meas(n_bpm, i);
    v_bpm_meas(2, i) = respm_meas(n_bpm + 50, i);
    v_bpm_theory(1, i) = respm_theory(n_bpm, i);
    v_bpm_theory(2, i) = respm_theory(n_bpm + 50, i);
    v_bpm_correct(1, i) = respm_correct(n_bpm, i);
    v_bpm_correct(2, i) = respm_correct(n_bpm + 50, i);
end

dif_meas_theory = v_bpm_meas; % v_bpm_theory - v_bpm_meas;
dif_corr_theory = v_bpm_correct; %  - v_bpm_theory;
figure; 
[v_sort1, ord1] = sort(v_bpm_theory(n, range));
plot(v_sort1, dif_meas_theory(n, ord1+range(1)-1), 'o');

[p1, S1] = polyfit(v_sort1, dif_meas_theory(n, ord1+range(1)-1), 1);
[y1, delta1] = polyval(p1, v_sort1, S1);
hold on;
plot(v_sort1, y1, 'r');
grid on;
delta_m1 = mean(delta1);
fprintf('======================================= \n');
fprintf('MEASURE MATRIX WITHOUT CORRECTION \n');
fprintf('======================================= \n');
fprintf('MEAN ERROR FITTING %f \n', delta_m1);
title(['Error Analysis w/o correction for BPM LABEL ', num2str(n_bpm + 1)])
xlabel('Matrix value from model [m/rad]')
ylabel('Matrix value measured [m/rad]')
xlim([-15, 15])
ylim([-15, 15])
if p1(2) < 0
    fprintf('Linear fit: y(x) = %f x - %f \n', p1(1), -p1(2));
else
    fprintf('Linear fit: y(x) = %f x + %f \n', p1(1), p1(2));
end

figure; 
plot(v_sort1, dif_corr_theory(n, ord1+range(1)-1), 'o');

[p2, S2] = polyfit(v_sort1, dif_corr_theory(n, ord1+range(1)-1), 1);
[y2, delta2] = polyval(p2, v_sort1, S2);
hold on;
plot(v_sort1, y2, 'r');
grid on;
delta_m2 = mean(delta2);
fprintf('======================================= \n');
fprintf('MEASURE MATRIX WITH CORRECTION \n');
fprintf('======================================= \n');
fprintf('MEAN ERROR FITTING %f \n', delta_m2);
title(['Error Analysis with correction for BPM LABEL ', num2str(n_bpm + 1)])
xlabel('Matrix value from model [m/rad]')
ylabel('Matrix value measured [m/rad]')
xlim([-15, 15])
ylim([-15, 15])
if p2(2) < 0
    fprintf('Linear fit: y(x) = %f x - %f \n', p2(1), -p2(2));
else
    fprintf('Linear fit: y(x) = %f x + %f \n', p2(1), p2(2));
end


% T = table(v_sort',dif_meas_theory(2, ord+range(1)-1)',y',dif_meas_theory(2, ord+range(1)-1)'-y','VariableNames',{'V_theory','Delta_M','Fit','FitError'})
%{
figure;
plot(abs(dif_meas_theory(1, range)), '-o');
hold on
plot(abs(dif_corr_theory(1, range)), '-o');
figure;
plot(abs(dif_meas_theory(2, range)), '-o');
hold on
plot(abs(dif_corr_theory(2, range)), '-o');
%}