function [r_scrn2, param] = screen2(machine, param, n_part, n_pulse, scrn2, kckr)

    machine2 = setcellstruct(machine, 'VChamber', scrn2+1:length(machine), 0, 1, 1);
    fprintf('=================================================\n');
    fprintf('SCREEN 2 ON \n')
    fprintf('=================================================\n');
      
    dx12 = 1;
    dtheta_kckr = 0;
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));
    
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_scrn2 = s(scrn2) - s(injkckr) - L_kckr/2;
    
    while abs(dx12) > res_scrn
        param.kckr_sist = param.kckr_sist - dtheta_kckr;
        [eff2, r_scrn2] = sirius_commis.injection.bo.multiple_pulse(machine2, param, n_part, n_pulse, scrn2, kckr);
        
        if mean(eff2) < 0.75
            param = screen_low_intensity(machine2, param, n_part, n_pulse, scrn2, kckr, mean(eff2), 2, 0.75);
            [~, r_scrn2] = sirius_commis.injection.bo.multiple_pulse(machine2, param, n_part, n_pulse, scrn2, kckr);
        end
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        dtheta_kckr = r_scrn2(1) / d_kckr_scrn2;
        dx12 = r_scrn2(1);
        fprintf('Screen 2 - x position: %f mm \n', r_scrn2(1)*1e3);
        fprintf('=================================================\n');
    end
end