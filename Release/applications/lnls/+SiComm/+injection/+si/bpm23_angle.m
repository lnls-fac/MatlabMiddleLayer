function bpm23_angle(machine, param, param_errors, n_part, n_pulse, bpm, kckr)

    fprintf('=================================================\n');
    fprintf('BPM 2 and 3 \n')
    fprintf('=================================================\n');

    r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm, kckr, 'plot');
    eff = r_particles.efficiency;
    r_bpms = r_particles.r_point;
    eff_lim = 0.75;
    bpms = findcells(machine, 'FamName', 'BPM');

    if mean(eff) < eff_lim
        param = sirius_commis.injection.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm, kckr, mean(eff), 3, eff_lim);
        r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm, kckr, 'plot');
        r_bpms = r_particles.r_point;
    end

    if isnan(r_bpms(1, 1))
       error('PARTICLES ARE LOST BEFORE BPM 2');
    end

    if isnan(r_bpms(1, 2))
       error('PARTICLES ARE LOST BEFORE BPM 3');
    end


    res_bpm = param_errors.sigma_bpm;

    x_bpm2 = r_bpms(1, 1); x_bpm3 = r_bpms(1, 2);
    y_bpm2 = r_bpms(2, 1); y_bpm3 = r_bpms(2, 2);
    dx23 = x_bpm3 - x_bpm2; dy23 = y_bpm3 - y_bpm2;
    s = findspos(machine, 1:length(machine));
    ds = s(bpms(3)) - s(bpms(2));
    delta2 = x_bpm2 / param.etax_bpms(2);
    delta3 = x_bpm3 / param.etax_bpms(3);
    
    p23 = sirius_commis.common.prox_percent(delta2, delta3);
    
    fprintf('BPM 2 - x position %f mm \n', x_bpm2*1e3);
    fprintf('BPM 3 - x position %f mm \n', x_bpm3*1e3);
    fprintf('=================================================\n');
    fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave_f*1e2);
    agr = sirius_commis.common.prox_percent(param.delta_ave_f, param_errors.delta_error_syst);
    fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_syst*1e2, agr);
    fprintf('=================================================\n');

end
