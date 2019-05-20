function [param, x_bpm, delta_bpm] = bpm2_energy(machine, param, param_errors, n_part, n_pulse, bpm, kckr)

    fprintf('=================================================\n');
    fprintf('BPM 2 and 3 \n')
    fprintf('=================================================\n');

    % etax_bpm2 = 0.077651808646934; %QUAD + SEXT ligados
    % etax_bpm3 = 0.046709848283303;

    etax_bpm2 = 0.087369551883561;
    etax_bpm3 = 0.152064321770701;
    a = round(etax_bpm2 * 100); b = round(etax_bpm3 * 100);
    param.delta_ave_i = param.delta_ave_f;

    r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm, kckr, 'plot');
    eff = r_particles.efficiency;
    r_bpms = r_particles.r_point;
    eff_lim = 0.75;

    if mean(eff) < eff_lim
        param = sirius_commis.injection.si.bpm_low_intensity(machine, param, param_errors, n_part, n_pulse, bpm, kckr, mean(eff), 3, eff_lim);
        r_particles = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, bpm, kckr, 'plot');
        r_bpms = r_particles.r_point;
    end

    if isnan(r_bpms(1, 2))
       error('PARTICLES ARE LOST BEFORE BPM 2');
    end

    if isnan(r_bpms(1, 3))
       error('PARTICLES ARE LOST BEFORE BPM 3');
    end


    res_bpm = param_errors.sigma_bpm;

    x_bpm2 = r_bpms(1, 2) - r_bpms(1, 1);
    x_bpm3 = r_bpms(1, 3) - r_bpms(1, 1);
    y_bpm1 = r_bpms(2, 1); y_bpm2 = r_bpms(2, 2); y_bpm3 = r_bpms(2, 3);
    dy12 = y_bpm2 - y_bpm1; dy23 = y_bpm3 - y_bpm2;
    x_bpm = [x_bpm2, x_bpm3];
    difs = abs(abs(x_bpm3) - abs(x_bpm2));

    res2 = sqrt(res_bpm * res_bpm / n_pulse + (0.05 / 100 * etax_bpm2)^2);
    res3 = sqrt(res_bpm * res_bpm / n_pulse + (0.05 / 100 * etax_bpm3)^2);

    if abs(x_bpm3) < res_bpm || difs < res_bpm % abs(x_bpm2) < res2 && abs(x_bpm3) < res3
        fprintf('BPM 2 - x position %f mm \n', x_bpm2*1e3);
        fprintf('BPM 3 - x position %f mm \n', x_bpm3*1e3);
        fprintf('=================================================\n');
        fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave_f*1e2);
        agr = sirius_commis.common.prox_percent(param.delta_ave_f, param_errors.delta_error_syst);
        fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_syst*1e2, agr);
        fprintf('=================================================\n');
        return
    end

    delta_bpm2 = x_bpm2 / etax_bpm2; % sign(x_bpm2) * abs(x2) / etax_bpm2;
    delta_bpm3 = x_bpm3 / etax_bpm3; % sign(x_bpm3) * abs(x3) / etax_bpm3;
    delta_bpm = [delta_bpm2, delta_bpm3];
    param.delta_energy_bpm23 = delta_bpm3; % (a * delta_bpm2 + b * delta_bpm3) / (a + b);
    param.delta_ave_f = param.delta_ave_i + param.delta_energy_bpm23;
    dtheta_kckr = param.kckr_syst * ((param.delta_ave_i + 1) / (param.delta_ave_f + 1) - 1);
    % dtheta_sept = param.offset_xl_syst * (param.delta_ave_f - param.delta_ave_i) / (1 + param.delta_ave_f);
    % fprintf('DELTA THETA KICKER %f urad \n', dtheta_kckr * 1e6)
    param.kckr_syst = param.kckr_syst + dtheta_kckr;
    % param.offset_xl_syst = param.offset_xl_syst - dtheta_sept;
    fprintf('BPM 2 - x position %f mm \n', x_bpm2*1e3);
    fprintf('BPM 3 - x position %f mm \n', x_bpm3*1e3);
    fprintf('=================================================\n');
    fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave_f*1e2);
    agr = sirius_commis.common.prox_percent(param.delta_ave_f, param_errors.delta_error_syst);
    fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_syst*1e2, agr);
    fprintf('=================================================\n');

end
