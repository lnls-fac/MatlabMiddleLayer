function [param, x_scrn3] = screen3(machine, param, param_errors, n_part, n_pulse, scrn3, kckr)
    
    fprintf('=================================================\n');
    fprintf('SCREEN 3 ON \n')
    fprintf('=================================================\n');
    machine3 = setcellstruct(machine, 'VChamber', scrn3+1:length(machine), 0, 1, 1);      
        
    [eff3, r_scrn3] = sirius_commis.injection.bo.multiple_pulse(machine3, param, param_errors, n_part, n_pulse, scrn3, kckr); 
    eff_lim = 0.50;
    
    if mean(eff3) < eff_lim
        param = sirius_commis.injection.bo.screen_low_intensity(machine3, param, param_errors, n_part, n_pulse, scrn3, kckr, mean(eff3), 3, eff_lim);
        [~, r_scrn3] = sirius_commis.injection.bo.multiple_pulse(machine3, param, param_errors, n_part, n_pulse, scrn3, kckr); 
    end

    if isnan(r_scrn3(1))
       warning('PARTICLES ARE LOST BEFORE SCREEN 3');
       x_scrn3 = r_scrn3(1);
       return
    end
    
    res_scrn = param_errors.sigma_scrn;

    x_scrn3 = r_scrn3(1);
    y_scrn3 = r_scrn3(2);
    
    if abs(x_scrn3) < res_scrn % / sqrt(n_pulse)
        fprintf('Screen 3 - x position %f mm \n', x_scrn3*1e3);
        fprintf('Screen 3 - y position %f mm \n', y_scrn3*1e3);
        fprintf('=================================================\n');    
        fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave*1e2);
        agr = sirius_commis.common.prox_percent(param.delta_ave, param_errors.delta_error_sist);
        fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_sist*1e2, agr);
        fprintf('=================================================\n');
        return
    end
    
    param.delta_energy_scrn3 = x_scrn3 / param.etax_scrn3;
    param.delta_ave = param.delta_ave * (1 + param.delta_energy_scrn3) + param.delta_energy_scrn3;
    param.kckr_sist = param.kckr_sist / (1 + param.delta_ave);
    dyf = r_scrn3(2);
    [~, dthetay] = sirius_commis.injection.bo.scrn_septum_corresp(machine3, 0, dyf, scrn3);
    param.offset_yl_sist = param.offset_yl_sist - dthetay;
    fprintf('Screen 3 - x position %f mm \n', x_scrn3*1e3);
    fprintf('=================================================\n');    
    fprintf('DELTA ENERGY ADJUSTED TO %f %% \n', param.delta_ave*1e2);
    agr = sirius_commis.common.prox_percent(param.delta_ave, param_errors.delta_error_sist);
    fprintf('THE GENERATED ERROR WAS %f %%, Conf. %f %% \n', param_errors.delta_error_sist*1e2, agr);
    fprintf('=================================================\n');
end

