function param = screen3(machine, param, n_part, n_pulse, scrn3, kckr)
    fprintf('=================================================\n');
    fprintf('SCREEN 3 ON \n')
    fprintf('=================================================\n');
    machine3 = setcellstruct(machine, 'VChamber', scrn3+1:length(machine), 0, 1, 1);      
   
    xx_scrn3 = 1;
    delta_energy = 0;
    
    while abs(xx_scrn3) > param.sigma_scrn;
        param.delta_energy_ave = delta_energy;
        [~, r_final_pulse3, sigma_scrn3] = bo_pulses(machine3, param, n_part, 5*n_pulse, 0, scrn3, kckr);            
        r_scrn3 = r_final_pulse3(:, :, scrn3);
        r_scrn3 = r_scrn3 + sigma_scrn3;
        r_scrn3 = squeeze(nanmean(r_scrn3, 1));
        r_scrn3 = compares_vchamb(machine3, r_scrn3, scrn3);
         if isnan(r_scrn3(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 3');
        end
        xx_scrn3 = r_scrn3(1);
        delta_energy = xx_scrn3 / param.etax;
        fprintf('Screen 3 - x position %f mm \n', xx_scrn3*1e3);
    end
    fprintf('=================================================\n');
    fprintf('DELTA ENERGY ERROR WAS %f %%\n', param.delta_energy_ave*1e2);
    agr = (1-abs(param.delta_energy_ave - param.energy_error_sist)/param.energy_error_sist)*100;
    fprintf('THE GENERATED ERROR WAS %f %%, EFF %f %% \n', param.energy_error_sist*1e2, agr);
    fprintf('=================================================\n');
end

