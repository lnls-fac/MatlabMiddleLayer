function [r_bpm1, param] = bpm1_sept(machine, param, param_errors, n_part, n_pulse, bpm1, kckr)
 
    fprintf('=================================================\n');
    fprintf('BPM 1 - KICKER OFF \n')
    fprintf('=================================================\n');
    dxf_e = 1;
    dtheta0 = 0;
    res_bpm = param_errors.sigma_bpm;
    s = findspos(machine, 1:length(machine));
    xl_init = param.xl_sept_init;
    xl_error = param_errors.xl_error_sist;

    injkckr = findcells(machine, 'FamName', 'InjDpKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_scrn = s(bpm1) - s(injkckr) - L_kckr/2; % Adjustment to particles reach x=0 at kicker center
    x_kckr_scrn = tan(-param.kckr0) * d_kckr_scrn;

    while dxf_e > res_bpm/sqrt(n_pulse)
        param.offset_xl_sist = param.offset_xl_sist + dtheta0;
        [eff1, r_bpm1] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');

        if mean(eff1) < 0.10
           param = sirius_commis.injection.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, mean(eff1), 1, 0.75);
           [~, r_bpm1] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm1, kckr, 'plot');
        end

        if isnan(r_bpm1(1))
            error('PARTICLES ARE LOST BEFORE BPM 1');
        end

        dxf = r_bpm1(1) - x_kckr_scrn;
        dtheta0 = - dxf / s(bpm1);
        
        dxf_e = abs(dxf);
        fprintf('(KICKER OFF) BPM 1 - x position: %f mm, error %f mm \n', r_bpm1(1)*1e3, dxf_e*1e3);
        fprintf('=================================================\n');         
        fprintf('SEPTUM ANGLE ADJUSTED TO %f mrad, GOAL %f mrad \n', param.offset_xl_sist*1e3, param.offset_xl0*1e3);
    	agr = sirius_commis.common.prox_percent(abs(xl_init - param.offset_xl_sist), xl_error);
        fprintf('THE GENERATED ERROR WAS %f mrad, CODE FOUND %f mrad, Conf. %f %% \n', xl_error*1e3, abs(xl_init - param.offset_xl_sist)*1e3, agr);
        fprintf('=================================================\n');
    end
end