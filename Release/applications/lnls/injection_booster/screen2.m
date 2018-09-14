function [r_scrn2, param] = screen2(machine, param, n_part, n_pulse, scrn2)
    %===============================SCREEN 2===============================
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
        error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
        param.kckr = param.kckr_erro + error_kckr_pulse;
        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');

        error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_erro + error_inj_pulse;
        
        [~, r_final_pulse2, sigma_scrn2] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn2, 1);
        
        r_scrn2 = r_final_pulse2(:, [1,3], :, scrn2);
        r_scrn2 = squeeze(nanmean(r_scrn2, 3));
        r_scrn2 = r_scrn2 + sigma_scrn2;
        r_scrn2 = squeeze(nanmean(r_scrn2, 1));
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        dtheta_kckr = r_scrn2(1) / d_kckr_scrn2;
        dx12 = r_scrn2(1);
        
        fprintf('Screen 2 - x position: %f mm COM KICKER \n', r_scrn2(1)*1e3);
    end
    fprintf('=================================================\n');
    fprintf('KICKER ANGLE ADJUSTED TO %f mrad \n', param.kckr_erro*1e3);
    fprintf('=================================================\n');
end