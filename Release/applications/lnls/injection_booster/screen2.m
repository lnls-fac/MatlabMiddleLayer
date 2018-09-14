function [r_scrn2, param] = screen2(machine, param, n_part, n_pulse, scrn2, kckr)
    kckr_inicial = param.kckr_inicial;
  
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
        param.kckr_erro = param.kckr_erro - dtheta_kckr;
  
        [~, r_final_pulse2, sigma_scrn2] = bo_pulses(machine2, param, n_part, n_pulse, 0, scrn2, kckr);
        r_scrn2 = r_final_pulse2(:, :, scrn2);
        r_scrn2 = r_scrn2 + sigma_scrn2;
        r_scrn2 = squeeze(nanmean(r_scrn2, 1));
        r_scrn2 = compares_vchamb(machine2, r_scrn2, scrn2);
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        dtheta_kckr = r_scrn2(1) / d_kckr_scrn2;
        dx12 = r_scrn2(1);
        
        fprintf('Screen 2 - x position: %f mm COM KICKER \n', r_scrn2(1)*1e3);
    end
    fprintf('=================================================\n');
    erro = abs(kckr_inicial - param.kckr_erro);
    fprintf('KICKER ANGLE ADJUSTED TO %f mrad, THE ERROR WAS %f mrad \n', param.kckr_erro*1e3, erro*1e3);
    agr = (1-abs(erro - param.kckr_error_sist)/param.kckr_error_sist)*100;
    fprintf('THE GENERATED ERROR WAS %f mrad, EFF %f %% \n', param.kckr_error_sist*1e3, agr);
    fprintf('=================================================\n');
end