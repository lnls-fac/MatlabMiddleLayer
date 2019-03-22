function [best_ring, best_respm, best_kl_qf, best_kl_qd, Lambda_best, R_best] = find_machine(bo_ring, p_qf, p_qd, goal_respm, input_respm, corr_gain,  bpm_gain)

% sirius_commis.common.initializations();

fam = sirius_bo_family_data(bo_ring);
ch = fam.CH.ATIndex;
% cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
n_bpm = length(bpm);
T0 = 0;
T_rate = 0;
Lambda_old = zeros(size(goal_respm, 2)-1, 1);
R_old = zeros(2, 2, n_bpm);
Lambda_new = zeros(size(goal_respm, 2)-1, 1);
R_new = zeros(2, 2, n_bpm);

idx_qf = findcells(bo_ring, 'FamName', 'QF');
idx_qd = findcells(bo_ring, 'FamName', 'QD');
kl_qf = getcellstruct(bo_ring, 'PolynomB', idx_qf, 1, 2);
kl_qd = getcellstruct(bo_ring, 'PolynomB', idx_qd, 1, 2);
ring_rand = bo_ring;

twiss = calctwiss(bo_ring);
tunex = twiss.mux(end)/2/pi;
tuney = twiss.muy(end)/2/pi;
% respm_modelo = sirius_commis.common.calc_respm_sofb('BO', bo_ring, '4D');

if isempty(input_respm)
    respm_modelo = sirius_commis.first_turns.bo.calc_respm_tracking(bo_ring, fam);
else
    respm_modelo = input_respm;
end

goal_respm = sirius_commis.common.change_bpm(19, 20, goal_respm);
goal_respm = sirius_commis.common.change_bpm(31, 32, goal_respm);

goal_respm = sirius_commis.common.edit_meas_respm(bo_ring, goal_respm, true);

T = T0;
flag_accept = false;

if corr_gain
    Lambda_old = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
end

if bpm_gain
    [~, R_old] = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
end

[f_merit_old] = calc_merit(goal_respm, respm_modelo, corr_gain, Lambda_old, bpm_gain, R_old);

count = 0;
kl_qf_old = kl_qf;
kl_qd_old = kl_qd;
k = 1;
qf_max = 1.865;
qd_max = 0.525;

while k < 100
    delta_kl_qf = 2 * p_qf * rand() - p_qf;
    delta_kl_qd = 2 * p_qd * rand() - p_qd;
    kl_qf_new = kl_qf_old + delta_kl_qf;
    kl_qd_new = kl_qd_old + delta_kl_qd;
    
    if abs(kl_qf_new) > qf_max
        kl_qf_new = sign(kl_qf_new) * qf_max;
        warning('Maximum K in QF');
    end
    
    if abs(kl_qd_new) > qd_max
        kl_qd_new = sign(kl_qd_new) * qd_max;
        warning('Maximum K in QD');
    end    
    ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_qf, kl_qf_new, 1, 2);
    ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_qd, kl_qd_new, 1, 2);
    
    % respm_rand = sirius_commis.common.calc_respm_sofb('BO', ring_rand, '4D');
    respm_rand = sirius_commis.first_turns.bo.calc_respm_tracking(ring_rand, fam);
    
    if sum(isnan(respm_rand(:))) > 0
        continue
    end
    
    ring_rand = sirius_commis.common.shift_ring(ring_rand, 'InjSept');
    respm_rand = sirius_commis.first_turns.bo.calc_respm_tracking(ring_rand, fam);

    if corr_gain
        Lambda_new = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
    end

    if bpm_gain
        [~, R_new] = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
    end

    f_merit_new = calc_merit(goal_respm, respm_rand, corr_gain, Lambda_new, bpm_gain, R_new);

    count = count + 1;
    
    if f_merit_new <= f_merit_old
        flag_accept = true;
    else
        delta_f = f_merit_new - f_merit_old;
        p = exp(- delta_f / T);
        r = rand();
        if r < p
            flag_accept = true;
        end
    end
    
    if flag_accept
        kl_qf_old = kl_qf_new;
        kl_qd_old = kl_qd_new;
        fprintf('Trial # %i: %f --> %f \n', count, f_merit_old, f_merit_new)
        f_merit_old = f_merit_new;
        count = 0;
        flag_accept = false;
        best_kl_qf = kl_qf_new(1);
        best_kl_qd = kl_qd_new(1);
        best_ring = ring_rand;
        best_respm = respm_rand;
        R_best = R_new;
        Lambda_best = Lambda_new;
    else         
        fprintf('Trial # %i \n', count)
        fprintf('Temperature %f \n', T)
    end
    T = T * (1 - T_rate);
    k = k+1;
end

twiss_best = calctwiss(best_ring);
best_tunex = twiss_best.mux(end)/2/pi;
best_tuney = twiss_best.muy(end)/2/pi;

fprintf('Tune x: %f --> %f \n', tunex, best_tunex)
fprintf('Tune y: %f --> %f \n', tuney, best_tuney)

fprintf('K QF: %f --> %f \n', kl_qf(1), best_kl_qf)
fprintf('K QD: %f --> %f \n', kl_qd(1), best_kl_qd)
end

function [Lambda, R] = calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain)
    e1 = [1, 0; 0, 0];
    e2 = [0, 0; 0, 1];
    od = [0, 1; -1, 0];
    At = zeros(3, 3);
    Bt = zeros(3, 1);
    n_bpm = size(goal_respm, 1)/2;
    lambda1 = zeros(n_bpm, 1);
    Lambda = zeros(size(goal_respm, 2)-1, 1);
    d1x = zeros(size(goal_respm, 2)-1, 1);
    d1y = zeros(size(goal_respm, 2)-1, 1);
    d2 = zeros(n_bpm, 1);
    R = zeros(2, 2, n_bpm);
    
    if corr_gain
            for j = 1:size(goal_respm, 2)-1
                for i = 1:n_bpm
                    lambda1(i) = respm_modelo(i, j)/goal_respm(i, j);
                    if isnan(lambda1(i)) || isinf(lambda1(i))
                        lambda1(i) = 1;
                    end
                end
                Lambda(j) = nanmean(lambda1(lambda1 ~= 1));
                if isnan(Lambda(j))
                    Lambda(j) = 1;
                end
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
            R(:, :, i) = [r(1), r(3); -r(3), r(2)];
        end
    end
end

function f_merit = calc_merit(goal_respm, respm_modelo, corr_gain, Lambda, bpm_gain, R)

n_bpm = size(goal_respm, 1)/2;

if corr_gain
   Lambda(end+1) = 1;
   Lambda_matrix = repmat(Lambda, 1, 2 * n_bpm)';
   corr_goal_respm = Lambda_matrix .* goal_respm;
else
    corr_goal_respm = goal_respm;
end

for i = 1:n_bpm
    for j = 1:size(goal_respm, 2)-1
        goal_v = [corr_goal_respm(i,j); corr_goal_respm(i+n_bpm,j)];
        modelo_v = [respm_modelo(i,j); respm_modelo(i+n_bpm,j)];
        if bpm_gain
            goal_corr = R(:, :, i) * goal_v;
        else
            goal_corr = goal_v;
        end
        d1x(j) = (goal_corr(1) - modelo_v(1)).^2;
        d1y(j) = (goal_corr(2) - modelo_v(2)).^2;
    end
    d2(i) = sum(d1x + d1y);
end
    
    f_merit = sum(d2);
end

