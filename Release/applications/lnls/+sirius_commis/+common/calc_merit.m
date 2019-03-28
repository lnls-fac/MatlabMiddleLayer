function [f_merit, corr_goal_respm, ratio] = calc_merit(goal_respm, respm_modelo, corr_gain, R_c, bpm_gain, R_b, flag_ratio)

n_bpm = size(goal_respm, 1)/2;
% n_ch = (size(goal_respm, 2) - 1)/2;
% n_cv = size(goal_respm, 2) - 1 - n_ch;
corr_goal_respm = goal_respm;

if corr_gain
    for j = 1:(size(goal_respm, 2)-1)
        for i = 1:2*n_bpm
            if j <= (size(goal_respm, 2)-1) / 2
               goal_v = [goal_respm(i,j); 0];
               goal_v_corrected = R_c(:, :, j) * goal_v;
               corr_goal_respm(i, j) = goal_v_corrected(1);
            else
               goal_v = [0; goal_respm(i,j)];
               goal_v_corrected = R_c(:, :, j) * goal_v;
               corr_goal_respm(i, j) = goal_v_corrected(2);
            end
        end
    end
end

for i = 1:n_bpm
    for j = 1:size(goal_respm, 2)-1
        goal_v = [corr_goal_respm(i,j); corr_goal_respm(i+n_bpm,j)];
        modelo_v = [respm_modelo(i,j); respm_modelo(i+n_bpm,j)];
        
        if j <= (size(goal_respm, 2)-1)/2
            rms_goal = rms(corr_goal_respm(1:n_bpm, j));
            rms_modelo = rms(respm_modelo(1:n_bpm, j));
        else
            rms_goal = rms(corr_goal_respm(n_bpm+1:2*n_bpm, j));
            rms_modelo = rms(respm_modelo(n_bpm+1:2*n_bpm, j));
        end
        
        if flag_ratio
            ratio(j) = rms_modelo/rms_goal;
        else
            ratio(j) = 1;
        end
        
        if bpm_gain
            goal_corr = R_b(:, :, i) * goal_v;
        else
            goal_corr = goal_v;
        end
        d1x(j) = (goal_corr(1) * ratio(j) - modelo_v(1)).^2;
        d1y(j) = (goal_corr(2) * ratio(j) - modelo_v(2)).^2;
    end
    d2(i) = sum(d1x + d1y);
end
    
    f_merit = sum(d2);
end