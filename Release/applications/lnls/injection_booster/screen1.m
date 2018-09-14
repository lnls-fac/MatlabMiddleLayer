function [r_scrn1, param] = screen1(machine, param, n_part, n_pulse, scrn1, kckr)
    xl_inicial = param.xl_sept_inicial;
    fprintf('=================================================\n');
    fprintf('SCREEN 1 ON \n')
    fprintf('=================================================\n');
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
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
        [~, r_final_pulse1, sigma_scrn1] = bo_pulses(machine1, param, n_part, n_pulse, 0, scrn1, kckr);
        r_scrn1 = r_final_pulse1(:, :, scrn1);
        r_scrn1 = r_scrn1 + sigma_scrn1;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        
        r_scrn1 = compares_vchamb(machine1, r_scrn1, scrn1);
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
        
        dxf = r_scrn1(1) - x_kckr_scrn;
        dtheta0 = scrn_septum_corresp(machine1, dxf, scrn1);
        dxf_e = abs(dxf);

        fprintf('Screen 1 - x position: %f mm KICKER ON, error %f mm \n', r_scrn1(1)*1e3, dxf_e*1e3);
        % fprintf('Posicao y da Screen: %f mm\n', r_scrn(2)*1e3); 
    end
    fprintf('=================================================\n');    
    erro = abs(xl_inicial - param.offset_xl_erro); 
    fprintf('SEPTUM ANGLE ADJUSTED TO %f mrad, THE ERROR WAS %f mrad \n', param.offset_xl_erro*1e3, erro*1e3);
    agr = (1-abs(erro - param.xl_error_sist)/param.xl_error_sist)*100;
    fprintf('THE GENERATED ERROR WAS %f mrad, EFF %f %% \n', param.xl_error_sist*1e3, agr);
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