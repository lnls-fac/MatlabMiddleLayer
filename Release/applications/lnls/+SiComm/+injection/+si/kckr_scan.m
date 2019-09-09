function param = kckr_scan(machine, param, param_errors, n_part, n_pulse, n_point, kckr)
    fam = sirius_si_family_data(machine);
    theta_kckr0 = param.kckr_syst;
    theta_xl0 = param.offset_xl_syst;
    theta_yl0 = param.offset_yl_syst;
    dt = 3e-3; % 1mrad
    dtheta_kckr = sort(linspace(theta_kckr0 - dt, theta_kckr0 + dt, n_point));
    dtheta_xl = sort(linspace(theta_xl0 - dt, theta_xl0 + dt, n_point));
    dtheta_yl = sort(linspace(theta_yl0 - dt, theta_yl0 + dt, n_point));
    
    for i = 1:n_point
        param.offset_yl_syst = dtheta_yl(i);
        r0 = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
        sum_bpm = r0.sum_bpm;
        nbpm(i) = sum(sum_bpm);
    end
    
    % figure;
    % plot(dtheta_yl, nbpm);
    
    [~, imax] = max(nbpm);
    best_yl = dtheta_yl(imax);
    param.offset_yl_syst= best_yl;
    
    for i = 1:n_point
        param.kckr_syst = dtheta_kckr(i);
        r0 = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
        sum_bpm = r0.sum_bpm;
        nbpm(i) = sum(sum_bpm);
    end
    
    % figure;
    % plot(dtheta_kckr, nbpm);
    
    [~, imax] = max(nbpm);
    best_kckr = dtheta_kckr(imax);
    param.kckr_syst = best_kckr;
    
    for i = 1:n_point
        param.offset_xl_syst = dtheta_xl(i);
        r0 = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
        sum_bpm = r0.sum_bpm;
        nbpm(i) = sum(sum_bpm);
    end
    
    % figure;
    % plot(dtheta_xl, nbpm);
    
    [~, imax] = max(nbpm);
    best_xl = dtheta_xl(imax);
    param.offset_xl_syst= best_xl;
end

