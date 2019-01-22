function [r_bpm1, param] = bpm1_kckr(machine, param, param_errors, n_part, n_pulse, bpm1, kckr)

    fprintf('BPM 1 - KICKER ON \n')
    fprintf('=================================================\n');
    dx = 1;
    dtheta_kckr = 0;
    res_bpm = param_errors.sigma_bpm;
    s = findspos(machine, 1:length(machine));
    kckr_init = param.kckr_init;
    kckr_error = param_errors.kckr_error_sist;

    injkckr = findcells(machine, 'FamName', 'InjDpKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_bpm1 = s(bpm1) - s(injkckr) - L_kckr/2;

        
    while abs(dx) > res_bpm/sqrt(n_pulse)
        [eff1, r_bpm1] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
        
        if mean(eff1) < 0.75
            param = sirius_commis.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, mean(eff1), 2, 0.75);
            [~, r_bpm1] = sirius_commis.injection.si.multiple_pulse(machine,  param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
        end
        
        if isnan(r_bpm1(1))
            error('PARTICLES ARE LOST BEFORE BPM 1');
        end

        dtheta_kckr = r_bpm1(1) / d_kckr_bpm1;
        param.kckr_sist = param.kckr_sist - dtheta_kckr;
        dx = r_bpm1(1);
        fprintf('(KICKER ON) BPM 1 position: %f mm \n', r_bpm1(1)*1e3);
        fprintf('=================================================\n');
        fprintf('KICKER ANGLE ADJUSTED TO %f mrad, GOAL %f mrad \n', param.kckr_sist*1e3, param.kckr0*1e3);
    	agr = sirius_commis.common.prox_percent(abs(kckr_init - param.kckr_sist), kckr_error);
        fprintf('THE GENERATED ERROR WAS %f mrad, CODE FOUND %f mrad, Conf. %f %% \n', kckr_error*1e3, abs(kckr_init - param.kckr_sist)*1e3, agr);
        fprintf('=================================================\n');
    end
end