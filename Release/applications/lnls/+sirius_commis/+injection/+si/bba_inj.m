function bba_inj(machine, param, param_errors, n_part, n_pulse, n_point, kckr)
    fam = sirius_si_family_data(machine);
    theta_kckr0 = param.kckr_syst;
    r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
    r_bpm = r_particles.r_bpm;
    sum_bpm = r_particles.sum_bpm;
    eff_lim = 0.10;
    ind_bpm = sum_bpm > eff_lim;
    last_bpm = find(ind_bpm);
    last_bpm = fam.BPM.ATIndex(last_bpm(end));
    r_bpm = r_bpm(:, ind_bpm);
    r0bpm = zeros(n_point, 2, size(r_bpm, 2));
    rdkbpm = r0bpm;
    
    QFA_idx = fam.QFA.ATIndex(1);
    QDA_idx = fam.QDA.ATIndex(1);
    Q1_idx = fam.Q1.ATIndex(1);
    Q2_idx = fam.Q2.ATIndex(1);
 
    dk = 5e-2;
    pb_QFA = getcellstruct(machine, 'PolynomB', QFA_idx, 1, 2);
    pb_QDA = getcellstruct(machine, 'PolynomB', QDA_idx, 1, 2);
    pb_Q1 = getcellstruct(machine, 'PolynomB', Q1_idx, 1, 2);
    pb_Q2 = getcellstruct(machine, 'PolynomB', Q2_idx, 1, 2);
    
    machineQFA = setcellstruct(machine, 'PolynomB', QFA_idx, pb_QFA * (1 - dk), 1, 2);
    machineQDA = setcellstruct(machine, 'PolynomB', QDA_idx, pb_QDA * (1 - dk), 1, 2);
    machineQ1 = setcellstruct(machine, 'PolynomB', Q1_idx, pb_Q1 * (1 - dk), 1, 2);
    machineQ2 = setcellstruct(machine, 'PolynomB', Q2_idx, pb_Q2 * (1 - dk), 1, 2);
    
    dt = 50e-6; % 1mrad
    dtheta = sort(linspace(theta_kckr0 - dt, theta_kckr0 + dt, n_point));
    
    for i = 1:n_point
       param.kckr_syst = dtheta(i);
       r0 = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
       rdk = sirius_commis.injection.si.multiple_pulse(machineQFA, param, param_errors, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
       r0bpm(i, :, :) = r0.r_bpm(:, ind_bpm);
       rdkbpm(i, :, :) = rdk.r_bpm(:, ind_bpm);
    end
    
    r1 = squeeze(r0bpm(:, 1, 1));
    dr = rdkbpm - r0bpm;
    figure; 
    hold all
    
    for j = 2:size(dr, 3)
        lin = polyfit(r1, squeeze(dr(:, 1, j)), 1);
        plot(r1, squeeze(dr(:, 1, j)), 'o');
        p1 = polyval(lin, r1);
        plot(r1, p1);
    end
    
    
end