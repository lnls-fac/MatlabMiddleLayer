function best = find_machine(bo_ring, p_qf, p_qd, p_dip, n_max, goal_respm, input_respm, change_k, change_k_dip, corr_gain, bpm_gain)

sirius_commis.common.initializations();

fam = sirius_bo_family_data(bo_ring);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
n_bpm = length(bpm);
n_ch = length(ch);
n_cv = length(cv);

Rb_old = zeros(2, 2, n_bpm);
Rb_new = zeros(2, 2, n_bpm);
Rc_old = zeros(2, 2, n_ch + n_cv);
Rc_new = zeros(2, 2, n_ch + n_cv);

idx_qf = findcells(bo_ring, 'FamName', 'QF');
idx_qd = findcells(bo_ring, 'FamName', 'QD');
k_qf = getcellstruct(bo_ring, 'PolynomB', idx_qf, 1, 2);
k_qd = getcellstruct(bo_ring, 'PolynomB', idx_qd, 1, 2);
L_qf = 2 * getcellstruct(bo_ring, 'Length', idx_qf(1));
L_qd = getcellstruct(bo_ring, 'Length', idx_qf(1));
kl_qf = k_qf * L_qf;
kl_qd = k_qd * L_qd;

if change_k_dip
    idx_dip = findcells(bo_ring, 'FamName', 'B');
    k_dip = getcellstruct(bo_ring, 'PolynomB', idx_dip(1:20), 1, 2);
    kdip_old = k_dip;
end

ring_rand = bo_ring;
twiss = calctwiss(bo_ring);
tunex = twiss.mux(end)/2/pi;
tuney = twiss.muy(end)/2/pi;

goal_respm_in = goal_respm;

if isempty(input_respm)
    respm_modelo = sirius_commis.first_turns.bo.calc_respm_tracking(bo_ring, fam);
else
    respm_modelo = input_respm;
end

goal_respm = sirius_commis.common.edit_meas_respm(bo_ring, goal_respm, true);

flag_accept = false;

if corr_gain
    Rc_old = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
end

if bpm_gain
    [~, Rb_old] = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
end

f_merit_old = calc_merit(goal_respm, respm_modelo, 0, Rc_old, 0, Rb_old, 0);

count = 0;
klqf_old = kl_qf;
klqd_old = kl_qd;
qf_max = 1.865 * L_qf;
qd_max = 0.525 * L_qd;
warning on



while count < n_max
    if change_k
        deltakl_qf = 2 * p_qf * rand() - p_qf;
        deltakl_qd = 2 * p_qd * rand() - p_qd;
        deltak_dip = 2 * p_dip * rand() - p_dip;
    else
        deltakl_qf = 0;
        deltakl_qd = 0;
    end
    
    klqf_new = klqf_old + deltakl_qf;
    klqd_new = klqd_old + deltakl_qd;
    if change_k_dip
        kdip_new = kdip_old.*(1 + deltak_dip/100);
        ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_dip, repmat(kdip_new, 50, 1), 1, 2);
    end
    if abs(klqf_new(1)) > qf_max
        klqf_new = sign(klqf_new) * qf_max;
        warning('Maximum K in QF');
    end
    
    if abs(klqd_new(1)) > qd_max
        klqd_new = sign(klqd_new) * qd_max;
        warning('Maximum K in QD');
    end    
    
    ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_qf, klqf_new/L_qf, 1, 2);
    ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_qd, klqd_new/L_qd, 1, 2);
    
    respm_rand = sirius_commis.first_turns.bo.calc_respm_tracking(ring_rand, fam);

    if corr_gain
        Rc_new = calc_gains(goal_respm, respm_rand, corr_gain, bpm_gain);
    end

    if bpm_gain
        [~, Rb_new] = calc_gains(goal_respm, respm_rand, corr_gain, bpm_gain);
    end

    [f_merit_new, corr_goal_respm, ratio_new] = calc_merit(goal_respm, respm_rand, corr_gain, Rc_new, bpm_gain, Rb_new, 0);

    count = count + 1;
    
    if f_merit_new <= f_merit_old && abs(f_merit_new - f_merit_old) > 1e-10
        flag_accept = true;
    end
    
    if flag_accept
        klqf_old = klqf_new;
        klqd_old = klqd_new;
        kdip_old = kdip_new;
        fprintf('Trial # %i: %f --> %f \n', count, f_merit_old, f_merit_new)
        f_merit_old = f_merit_new;
        goal_respm = corr_goal_respm;
        count = 0;
        flag_accept = false;
        best.klqf = klqf_new(1);
        best.klqd = klqd_new(1);
        best.ring = ring_rand;
        best.respm = respm_rand;
        best.Rb = Rb_new;
        best.Rc = Rc_new;
        best.ratio = ratio_new;
        best.twiss = calctwiss(best.ring);
        best.tunex = best.twiss.mux(end)/2/pi;
        best.tuney = best.twiss.muy(end)/2/pi;
        best.k_dip_perc = deltak_dip;
        save best_data.mat best
    else         
        fprintf('Trial # %i \n', count)
    end
end

fprintf('Tune x: %f --> %f \n', tunex, best.tunex)
fprintf('Tune y: %f --> %f \n', tuney, best.tuney)
fprintf('KL QF: %f --> %f \n', kl_qf(1), best.klqf)
fprintf('KL QD: %f --> %f \n', kl_qd(1), best.klqd)
end

function [R_c, R_b] = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain)
    e1 = [1, 0; 0, 0];
    e2 = [0, 0; 0, 1];
    od = [0, 1; -1, 0];
    At = zeros(3, 3);
    Bt = zeros(3, 1);
    At_c = zeros(3, 3);
    Bt_c = zeros(3, 1);
    n_bpm = size(goal_respm, 1)/2;
    n_ch = (size(goal_respm, 2) - 1)/2;
    n_cv = size(goal_respm, 2) - 1 - n_ch;
    R_b = zeros(2, 2, n_bpm);
    R_c = zeros(2, 2, n_ch + n_cv);
    
    if corr_gain
            for j = 1:(size(goal_respm, 2)-1)
                if j <= (size(goal_respm, 2)-1) / 2
                    range = 1:n_bpm;
                    ax = 1; ay = 0;
                else
                    range = n_bpm+1:2*n_bpm;
                    ax = 0; ay = 1;
                end
                    for i = range
                        goal_v_corr = [ax * goal_respm(i,j); ay * goal_respm(i,j)];
                        model_v_corr = [ax * respm_modelo(i,j); ay * respm_modelo(i,j)];
                    
                        a_c = e1 * goal_v_corr; b_c = e2 * goal_v_corr; c_c = od * goal_v_corr;
                        ab_c = dot(a_c, b_c); ac_c = dot(a_c, c_c); bc_c = dot(b_c, c_c);
                        At_c(1, :) = At_c(1, :) + [dot(a_c, a_c), ab_c, ac_c];
                        At_c(2, :) = At_c(2, :) + [ab_c, dot(b_c, b_c), bc_c];
                        At_c(3, :) = At_c(3, :) + [ac_c, bc_c, dot(c_c, c_c)];
                        Bt_c = Bt_c + [dot(a_c, model_v_corr) ; dot(b_c, model_v_corr) ; dot(c_c, model_v_corr)];
                    end
                
                
                    if det(At_c) == 0
                       if any(At_c(:, 1))
                          r_c = Bt_c ./ At_c(:, 1);
                          r_c(isnan(r_c)) = 0;
                       else
                          r_c = Bt_c ./ At_c(:, 2);
                          r_c(isnan(r_c)) = 0;
                       end
                    else
                       r_c = linsolve(At_c, Bt_c);
                    end
                    if r_c(1) == 0 || isinf(r_c(1))
                        r_c(1) = 1;
                    end
                    if r_c(2) == 0 || isinf(r_c(2))
                        r_c(2) = 1;
                    end   
                    R_c(:, :, j) = [r_c(1), r_c(3); -r_c(3), r_c(2)];
                    At_c = zeros(3, 3);
                    Bt_c = zeros(3, 1);
            end
    end
    
    if bpm_gain
        for i = 1:n_bpm
            for j = 1:size(goal_respm, 2)-1
                goal_v = [goal_respm(i,j); goal_respm(i+n_bpm,j)];
                model_v = [respm_modelo(i,j); respm_modelo(i+n_bpm,j)];
                a = e1 * goal_v; b = e2 * goal_v; c = od * goal_v;
                ab = dot(a, b); ac = dot(a, c); bc = dot(b, c);
                At(1, :) = At(1, :) + [dot(a, a) , ab, ac];
                At(2, :) = At(2, :) + [ab , dot(b, b), bc];
                At(3, :) = At(3, :) + [ac , bc, dot(c, c)];
                Bt = Bt + [dot(a, model_v) ; dot(b, model_v) ; dot(c, model_v)];
            end

            if det(At) == 0
                r = Bt ./ At(:, 1);
                r(isnan(r)) = 0;
            else  
                r = linsolve(At, Bt);
            end
            if r(1) == 0
                r(1) = 1;
            end
            if r(2) == 0
                r(2) = 1;
            end               
            R_b(:, :, i) = [r(1), r(3); -r(3), r(2)];
        end
    end
end

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
            
            % corr_goal_respm(i, j+n_ch) = goal_v_corrected(2);
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

