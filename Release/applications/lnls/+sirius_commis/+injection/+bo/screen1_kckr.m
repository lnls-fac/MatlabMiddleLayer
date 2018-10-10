function [r_scrn1, param] = screen1_kckr(machine, param, n_part, n_pulse, scrn1, kckr)

    fprintf('SCREEN 1 ON - KICKER ON \n')
    fprintf('=================================================\n');
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
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
        param.kckr_sist = param.kckr_sist - dtheta_kckr;
        [eff1, r_scrn1] = sirius_commis.injection.bo.multiple_pulse(machine1, param, n_part, n_pulse, scrn1, kckr);
        
        if mean(eff1) < 0.75
            param = screen_low_intensity(machine1, param, n_part, n_pulse, scrn1, kckr, mean(eff1), 1, 0.75);
            [~, r_scrn1] = sirius_commis.injection.bo.multiple_pulse(machine1, param, n_part, n_pulse, scrn1, kckr);
        end
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end

        dtheta_kckr = r_scrn1(1) / d_kckr_scrn1;
        dx = r_scrn1(1);
        fprintf('(KICKER ON) Screen 1 position: %f mm \n', r_scrn1(1)*1e3);
        fprintf('=================================================\n');
    end
end