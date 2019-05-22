function [param, r_scrn3] = screen3(machine, param, param_errors, n_part, n_pulse, scrn3, kckr)

    fprintf('=================================================\n');
    fprintf('SCREEN 3 ON \n')
    fprintf('=================================================\n');

    machine3 = setcellstruct(machine, 'VChamber', scrn3+1:length(machine), 0, 1, 1);
    y_scrn3 = 1; res_scrn = param_errors.sigma_scrn / sqrt(n_pulse);
    res_x = sqrt(res_scrn^2 + (param.etax_scrn3 * param_error.delta_error_pulse)^2) / sqrt(n_pulse);

    while abs(y_scrn3) > res_scrn
        r_particles = sirius_commis.injection.bo.multiple_pulse(machine3, param, param_errors, n_part, n_pulse, scrn3, kckr);
        eff_lim = 0.50;

        eff3 = r_particles.efficiency;
        r_scrn3 = r_particles.r_screen;

        if mean(eff3) < eff_lim
            param = sirius_commis.injection.bo.screen_low_intensity(machine3, param, param_errors, n_part, n_pulse, scrn3, kckr, mean(eff3), 3, eff_lim);
            r_particles = sirius_commis.injection.bo.multiple_pulse(machine3, param, param_errors, n_part, n_pulse, scrn3, kckr);
            r_scrn3 = r_particles.r_screen;
        end

        if isnan(r_scrn3(1))
           warning('PARTICLES ARE LOST BEFORE SCREEN 3');
           return
        end

        x_scrn3 = r_scrn3(1);
        y_scrn3 = r_scrn3(2);

        if abs(x_scrn3) < res_x && abs(y_scrn3) < res_scrn
            fprintf('Screen 3 - x position %f mm \n', x_scrn3*1e3);
            fprintf('Screen 3 - y position %f mm \n', y_scrn3*1e3);
            fprintf('=================================================\n');
            fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave*1e2);
            agr = sirius_commis.common.prox_percent(param.delta_ave, param_errors.delta_error_syst);
            fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_syst*1e2, agr);
            fprintf('=================================================\n');
            return
        end

        param.delta_energy_scrn3 = x_scrn3 / param.etax_scrn3;
        param.delta_ave = param.delta_ave * (1 + param.delta_energy_scrn3) + param.delta_energy_scrn3;
        param.kckr_syst = param.kckr_syst / (1 + param.delta_ave);
        dyf = r_scrn3(2);
        % [~, dthetay] = sirius_commis.injection.bo.scrn_septum_corresp(machine3, 0, dyf, scrn3);
        param.offset_y_syst = param.offset_y_syst - dyf;
        fprintf('Screen 3 - x position %f mm \n', x_scrn3*1e3);
        fprintf('Screen 3 - y position %f mm \n', y_scrn3*1e3);
        fprintf('=================================================\n');
        fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave*1e2);
        agr = sirius_commis.common.prox_percent(param.delta_ave, param_errors.delta_error_syst);
        fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_syst*1e2, agr);
        fprintf('=================================================\n');
    end
end
