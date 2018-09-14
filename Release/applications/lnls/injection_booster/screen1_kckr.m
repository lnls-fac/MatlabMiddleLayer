function [r_scrn1, param] = screen1_kckr(machine, param, n_part, n_pulse, scrn1)
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
        error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
        param.kckr = param.kckr_erro + error_kckr_pulse;
        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');

        error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_erro + error_inj_pulse;

        [~, r_final_pulse1, sigma_scrn2] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn1, 1);

        r_scrn1 = r_final_pulse1(:, [1,3], :, scrn1);
        r_scrn1 = squeeze(nanmean(r_scrn1, 3));
        r_scrn1 = r_scrn1 + sigma_scrn2;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        
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
    fprintf('KICKER ANGLE ADJUSTED TO %f mrad \n', param.kckr_erro*1e3);
    fprintf('=================================================\n');
end