function [corr_goal_respm, R_b_final, R_c_final] = fit_gains(goal_respm, respm_modelo, bpm_then_corr, corr_then_bpm)

n_bpm = size(goal_respm, 1)/2; 
n_ch = (size(goal_respm, 2) - 1)/2;
n_cv = (size(goal_respm, 2) - 1) - n_ch;

f_merit_old = sirius_commis.meas_fitting.calc_merit(goal_respm, respm_modelo, 0, 0, 0, 0, 0);
f_merit_new = f_merit_old;
corr_goal_respm = goal_respm;
corr_goal_respm_bpm_corr = goal_respm;
count = 1;
I2 = eye(2);
R_b_final = repmat(I2, [1, 1, n_bpm]);
R_c_final = repmat(I2, [1, 1, n_ch + n_cv]);

while count < 100 % f_merit_new <= f_merit_old
    corr_goal_respm = corr_goal_respm_bpm_corr;
    f_merit_old = f_merit_new;
    if bpm_then_corr
        [~, R_b] = sirius_commis.meas_fitting.calc_gains(corr_goal_respm, respm_modelo, 0, 1);
        corr_goal_respm_bpm = sirius_commis.meas_fitting.correct_meas_respm(corr_goal_respm, [], R_b);
        R_c = sirius_commis.meas_fitting.calc_gains(corr_goal_respm_bpm, respm_modelo, 1, 0);
        corr_goal_respm_bpm_corr = sirius_commis.meas_fitting.correct_meas_respm(corr_goal_respm_bpm, R_c, []);
        f_merit_new = sirius_commis.meas_fitting.calc_merit(corr_goal_respm_bpm_corr, respm_modelo, 0, 0, 0, 0, 0);
    elseif corr_then_bpm
        R_c = sirius_commis.meas_fitting.calc_gains(corr_goal_respm, respm_modelo, 1, 0);
        corr_goal_respm_bpm = sirius_commis.meas_fitting.correct_meas_respm(corr_goal_respm, R_c, []);
        [~, R_b] = sirius_commis.meas_fitting.calc_gains(corr_goal_respm_bpm, respm_modelo, 0, 1);
        corr_goal_respm_bpm_corr = sirius_commis.meas_fitting.correct_meas_respm(corr_goal_respm_bpm, [], R_b);
        f_merit_new = sirius_commis.meas_fitting.calc_merit(corr_goal_respm_bpm_corr, respm_modelo, 0, 0, 0, 0, 0);
    end
    fprintf('Trial # %i: %f --> %f \n', count, f_merit_old, f_merit_new)
    
    for i = 1:size(R_b, 3)
        R_b_final(:, :, i) = R_b(:, :, i) * R_b_final(:, :, i);
    end
    
    for i = 1:size(R_c, 3)
        R_c_final(:, :, i) = R_c(:, :, i) * R_c_final(:, :, i);
    end
    
    Corr_Step(:, :, :, count) = R_c_final;
    BPM_Step(:, :, :, count) = R_b_final;
    count = count + 1;
end

figure; 
plot(squeeze(Corr_Step(2, 2, 1, :)), 'o');
figure;
plot(squeeze(BPM_Step(2, 2, 32, :)), 'o');


end