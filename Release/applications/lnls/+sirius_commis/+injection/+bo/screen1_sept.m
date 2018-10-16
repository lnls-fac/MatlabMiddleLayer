function [r_scrn1, param] = screen1_sept(machine, param, param_errors, n_part, n_pulse, scrn1, kckr)
    fprintf('=================================================\n');
    fprintf('SCREEN 1 ON - KICKER OFF \n')
    fprintf('=================================================\n');
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
    dxf_e = 1;
    dtheta0 = 0;
    res_scrn = param_errors.sigma_scrn;
    s = findspos(machine, 1:length(machine));

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_scrn = s(scrn1) - s(injkckr) - L_kckr/2; % Adjustment to particles reach x=0 at kicker center
    x_kckr_scrn = tan(-param.kckr0) * d_kckr_scrn;

    while dxf_e > res_scrn
        param.offset_xl_sist = param.offset_xl_sist + dtheta0;
        [eff1, r_scrn1] = sirius_commis.injection.bo.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr);
        
        if mean(eff1) < 0.75
            param = sirius_commis.injection.bo.screen_low_intensity(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr, mean(eff1), 1, 0.75);
            [~, r_scrn1] = sirius_commis.injection.bo.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr);
        end
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
        
        dxf = r_scrn1(1) - x_kckr_scrn;
        dtheta0 = scrn_septum_corresp(machine1, dxf, scrn1);
        dxf_e = abs(dxf);
        fprintf('(KICKER OFF) Screen 1 - x position: %f mm, error %f mm \n', r_scrn1(1)*1e3, dxf_e*1e3);
        fprintf('=================================================\n');    
    end
end

function dtheta = scrn_septum_corresp(machine, dxf, scrn)
    s = findspos(machine, 1:length(machine));

    qf = findcells(machine, 'FamName', 'QF');
    qf_struct = machine(qf(1));
    qf_struct = qf_struct{1};

    K_QF = qf_struct.PolynomB;
    K_QF = K_QF(2);
    L_QF = qf_struct.Length; % It corresponds to half quadrupole length
    
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