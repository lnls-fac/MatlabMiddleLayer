function [r_bpm1, param] = bpm1_kckr(machine, param, param_errors, n_part, n_pulse, bpm1, kckr)

    fprintf('BPM 1 - KICKER ON \n')
    fprintf('=================================================\n');
    dx = 1;
    dtheta_kckr = 0;
    res_bpm = param_errors.sigma_bpm;
    s = findspos(machine, 1:length(machine));
    kckr_init = param.kckr_init;
    kckr_error = param_errors.kckr_error_syst;

    injkckr = findcells(machine, 'FamName', 'InjDpKckr');
    L_kckr = machine{injkckr}.Length;
    d_kckr_bpm1 = s(bpm1) - s(injkckr) - L_kckr/2;
    res = res_bpm/sqrt(n_pulse);

    r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
    eff1 = r_particles.efficiency;
    r_bpm1 = r_particles.r_point;

    if mean(eff1) < 0.75
        param = sirius_commis.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, mean(eff1), 2, 0.75);
        r_particles = sirius_commis.injection.si.multiple_pulse(machine,  param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
        r_bpm1 = r_particles.r_point;

    end

    if isnan(r_bpm1(1))
        error('PARTICLES ARE LOST BEFORE BPM 1');
    end

    dx = r_bpm1(1);
    dy = r_bpm1(2);

    while abs(dx) > res || abs(dy) > res
        dtheta_kckr = dx / d_kckr_bpm1;
        fprintf('DELTA THETA KICKER %f urad \n', dtheta_kckr * 1e6)
        param.kckr_syst = param.kckr_syst - dtheta_kckr;
        param.offset_y_syst= param.offset_y_syst - dy;

        r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
        eff1 = r_particles.efficiency;
        r_bpm1 = r_particles.r_point;

        if  mean(eff1) < 0.75
            param = sirius_commis.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, mean(eff1), 2, 0.75);
            r_particles = sirius_commis.injection.si.multiple_pulse(machine,  param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
            r_bpm1 = r_particles.r_point;
        end

        dx = r_bpm1(1);
        dy = r_bpm1(2);

        fprintf('(KICKER ON) BPM 1 x position: %f mm \n', dx*1e3);
        fprintf('(KICKER ON) BPM 1 y position: %f mm \n', dy*1e3);
        fprintf('=================================================\n');
        fprintf('KICKER ANGLE ADJUSTED TO %f mrad, GOAL %f mrad \n', param.kckr_syst*1e3, param.kckr0*1e3);
    	agr = sirius_commis.common.prox_percent(abs(kckr_init - param.kckr_syst), kckr_error);
        fprintf('THE GENERATED ERROR WAS %f mrad, CODE FOUND %f mrad, Conf. %f %% \n', kckr_error*1e3, abs(kckr_init - param.kckr_syst)*1e3, agr);
        fprintf('=================================================\n');
    end
end
