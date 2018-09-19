function [r_scrn1, param] = screen1_kckr(machine, param, n_part, n_pulse, scrn1, kckr)
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
    kckr_inicial = param.kckr_inicial;
    fprintf('=================================================\n');
    fprintf('KICKER ON \n')
    fprintf('=================================================\n');
    dx = 1;
    dtheta_kckr = 0;
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_scrn1 = s(scrn1) - s(injkckr) - L_kckr/2;
        
    while abs(dx) > res_scrn
        param.kckr_erro = param.kckr_erro - dtheta_kckr;
        [~, r_final_pulse1, sigma_scrn2] = bo_pulses(machine1, param, n_part, n_pulse, 0, scrn1, kckr);
        r_scrn1 = r_final_pulse1(:, :, scrn1);
        r_scrn1 = r_scrn1 + sigma_scrn2;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        r_scrn1 = compares_vchamb(machine1, r_scrn1, scrn1);
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end

        dtheta_kckr = r_scrn1(1) / d_kckr_scrn1;
        dx = r_scrn1(1);
        fprintf('=================================================\n');
        fprintf('Screen 1 position: %f mm KICKER ON \n', r_scrn1(1)*1e3);
        fprintf('=================================================\n');
    end
    fprintf('=================================================\n');
    erro = abs(kckr_inicial - param.kckr_erro); 
    fprintf('KICKER ANGLE ADJUSTED TO %f mrad, THE ERROR WAS %f mrad \n', param.kckr_erro*1e3, erro*1e3);
    agr = (1-abs(erro - param.kckr_error_sist)/param.kckr_error_sist)*100;
    fprintf('THE GENERATED ERROR WAS %f mrad, EFF %f %% \n', param.kckr_error_sist*1e3, agr);
    fprintf('=================================================\n');
end