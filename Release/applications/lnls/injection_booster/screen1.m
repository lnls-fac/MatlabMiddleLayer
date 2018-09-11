function [r_scrn1, param] = screen1(machine, param, n_part, n_pulse, scrn1)

    fprintf('=================================================\n');
    fprintf('SCREEN 1 ON \n')
    fprintf('=================================================\n');
    dxf_e = 1;
    dtheta0 = 0;
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_scrn = s(scrn1) - s(injkckr) - L_kckr/2; % posicao s é no inicio do elemento // PASSA EM X=0 NO CENTRO DO KICKER
    x_kckr_scrn = tan(-param.kckr0) * d_kckr_scrn;

    while dxf_e > res_scrn
        param.offset_xl_erro = param.offset_xl_erro + dtheta0;
        error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_erro + error_inj_pulse;
        
        % r_final = sirius_booster_injection(machine, param, n_part);
        
        % sigma_scrn = scrn_error_inten(r_final, n_part, scrn1, param.sigma_scrn);
        [~, r_final_pulse1, sigma_scrn1] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn1, 0);
        r_scrn1 = r_final_pulse1(:, [1,3], :, scrn1);
        r_scrn1 = squeeze(nanmean(r_scrn1, 3));
        r_scrn1 = r_scrn1 + sigma_scrn1;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
        
        dxf = r_scrn1(1) - x_kckr_scrn;
        dtheta0 = scrn_septum_corresp(machine, dxf, scrn1);
        dxf_e = abs(dxf);

        fprintf('Screen 1 - x position: %f mm SEM KICKER, error %f mm \n', r_scrn1(1)*1e3, dxf_e*1e3);
        % fprintf('Posicao y da Screen: %f mm\n', r_scrn(2)*1e3); 
    end
    fprintf('=================================================\n');    
    fprintf('SEPTUM ANGLE ADJUSTED TO %f mrad \n', param.offset_xl_erro*1e3);
    fprintf('=================================================\n');
end

function dtheta = scrn_septum_corresp(machine, dxf, scrn)
    s = findspos(machine, 1:length(machine));

    qf = findcells(machine, 'FamName', 'QF');
    qf_struct = machine(qf(1));
    qf_struct = qf_struct{1};

    K_QF = qf_struct.PolynomB;
    K_QF = K_QF(2);
    L_QF = qf_struct.Length; % metade do tamanho do quadrupolo
    
    KL_QF =  2 * K_QF * L_QF;
    
    mqf = findcells(machine, 'FamName', 'mQF');

    d1 = s(mqf(1));
    d2 = s(scrn) - d1; 

    % Drift from the end inj sept to the center of QF, then apply QF, and one
    % more drift from the center of QF to the first screen (relation
    % between x_scrn and x'_septum
    
    factor = d1 + d2  - d1 * d2 / KL_QF;
    
    dtheta = 1 / factor * dxf;
end