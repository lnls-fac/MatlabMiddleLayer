function [param, x_bpm2] = bpm2_energy(machine, param, param_errors, n_part, n_pulse, bpm2, kckr)

    fprintf('=================================================\n');
    fprintf('BPM 2 \n')
    fprintf('=================================================\n');


    [eff, r_bpm2] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm2, kckr, 'plot');
    eff_lim = 0.75;

    if mean(eff) < eff_lim
        param = sirius_commis.injection.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm2, kckr, mean(eff), 3, eff_lim);
        [~, r_bpm2] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm2, kckr, 'plot');
    end

    if isnan(r_bpm2(1))
       error('PARTICLES ARE LOST BEFORE BPM 2');
    end

    res_bpm = param_errors.sigma_bpm;

    x_bpm2 = r_bpm2(1);

    if abs(x_bpm2) < res_bpm/sqrt(n_pulse)
        fprintf('BPM 2 - x position %f mm \n', x_bpm2*1e3);
        fprintf('=================================================\n');
        fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave*1e2);
        agr = sirius_commis.common.prox_percent(param.delta_ave, param_errors.delta_error_sist);
        fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_sist*1e2, agr);
        fprintf('=================================================\n');
        return
    end
    percent = 1;
    param.delta_energy_bpm2 = x_bpm2 / param.etax_bpms(2);
    param.delta_ave = percent * (param.delta_ave * (1 + param.delta_energy_bpm2) + param.delta_energy_bpm2);
    param.kckr_sist = param.kckr_sist / (1 + param.delta_ave);
    fprintf('BPM 2 - x position %f mm \n', x_bpm2*1e3);
    fprintf('=================================================\n');
    fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave*1e2);
    agr = sirius_commis.common.prox_percent(param.delta_ave, param_errors.delta_error_sist);
    fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_sist*1e2, agr);
    fprintf('=================================================\n');
end
