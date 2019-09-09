function best = find_machine(bo_ring, p_qf, p_qd, p_dip, n_max, goal_respm, input_respm, change_k, change_k_dip, corr_gain, bpm_gain)

% sirius_commis.common.initializations();

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
    k_dip = getcellstruct(bo_ring, 'PolynomB', idx_dip, 1, 2);
    kdip_old = k_dip;
end

ring_rand = bo_ring;
twiss = calctwiss(bo_ring);
tunex = twiss.mux(end)/2/pi;
tuney = twiss.muy(end)/2/pi;

if isempty(input_respm)
    respm_modelo = sirius_commis.first_turns.bo.calc_respm_tracking(bo_ring, fam);
else
    respm_modelo = input_respm;
end

goal_respm = sirius_commis.meas_fitting.edit_meas_respm(bo_ring, goal_respm, true);

flag_accept = false;

if corr_gain
    Rc_old = sirius_commis.meas_fitting.calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
end

if bpm_gain
    [~, Rb_old] = sirius_commis.meas_fitting.calc_gains(goal_respm, respm_modelo, corr_gain, bpm_gain);
end

f_merit_old = sirius_commis.meas_fitting.calc_merit(goal_respm, respm_modelo, 0, Rc_old, 0, Rb_old, 0);

count = 0;
n_accept = 0;
klqf_old = kl_qf;
klqd_old = kl_qd;
% Maximum K values from Wiki
qf_max = 1.865 * L_qf; 
qd_max = 0.525 * L_qd;
warning on

while count < n_max
    if change_k
        deltakl_qf = 2 * p_qf * rand() - p_qf;
        deltakl_qd = 2 * p_qd * rand() - p_qd;
    else
        deltakl_qf = 0;
        deltakl_qd = 0;
    end
    
    if change_k_dip
        deltak_dip = 2 * p_dip * rand() - p_dip;
    else
        deltak_dip = 0;
    end
    
    klqf_new = klqf_old + deltakl_qf;
    klqd_new = klqd_old + deltakl_qd;
    
    if change_k_dip
        kdip_new = kdip_old .* (1 + deltak_dip/100);
        ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_dip, kdip_new', 1, 2);
    end
    
    if abs(klqf_new(1)) > qf_max
        klqf_new = sign(klqf_new) * qf_max;
        warning('Maximum K set in QF');
    end
    
    if abs(klqd_new(1)) > qd_max
        klqd_new = sign(klqd_new) * qd_max;
        warning('Maximum K set in QD');
    end    
    
    ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_qf, klqf_new/L_qf, 1, 2);
    ring_rand = setcellstruct(ring_rand, 'PolynomB', idx_qd, klqd_new/L_qd, 1, 2);
    
    respm_rand = sirius_commis.first_turns.bo.calc_respm_tracking(ring_rand, fam);

    if corr_gain
        Rc_new = sirius_commis.meas_fitting.calc_gains(goal_respm, respm_rand, corr_gain, bpm_gain);
    end

    if bpm_gain
        [~, Rb_new] = sirius_commis.meas_fitting.calc_gains(goal_respm, respm_rand, corr_gain, bpm_gain);
    end

    [f_merit_new, corr_goal_respm, ratio_new] = sirius_commis.meas_fitting.calc_merit(goal_respm, respm_rand, corr_gain, Rc_new, bpm_gain, Rb_new, 0);

    count = count + 1;
    
    if f_merit_new <= f_merit_old && abs(f_merit_new - f_merit_old) > 1e-10
        flag_accept = true;
    end
    
    if flag_accept
        klqf_old = klqf_new;
        klqd_old = klqd_new;
        
        if change_k_dip
            kdip_old = kdip_new;
            best.k_dip_perc = deltak_dip;
            best.k_dip = kdip_new;
        end
        
        fprintf('Trial # %i: %f --> %f \n', count, f_merit_old, f_merit_new)
        goal_respm = corr_goal_respm;
        count = 1;
        n_accept = n_accept + 1;
        fprintf('Number of good changes: %i \n', n_accept);
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
        best.good_changes = n_accept;
        reduction(n_accept) = f_merit_new/f_merit_old*100;
        best.reduction = reduction;
        f_merit_old = f_merit_new;
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