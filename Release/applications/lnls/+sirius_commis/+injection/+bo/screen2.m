function [r_scrn2, param] = screen2(machine, param, param_errors, n_part, n_pulse, scrn2, kckr)

    machine2 = setcellstruct(machine, 'VChamber', scrn2+1:length(machine), 0, 1, 1);
    fprintf('=================================================\n');
    fprintf('SCREEN 2 ON \n')
    fprintf('=================================================\n');

    dx12 = 10; dyf_new = 0;
    dtheta_kckr = 0;
    dthetay = 0;
    p = 1;
    eff_lim = 0.5;
    res_scrn = param_errors.sigma_scrn;
    s = findspos(machine, 1:length(machine));

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    d_kckr_scrn2 = s(scrn2) - s(injkckr) - L_kckr/2;
    dyf_old = 1;

    while abs(dx12) > res_scrn || abs(dyf_new) > res_scrn
        param.kckr_syst = param.kckr_syst - dtheta_kckr;
        param.offset_yl_syst = param.offset_yl_syst - dthetay;
        % param.offset_y_syst = param.offset_y_syst - p * dyf_new;
        r_particles = sirius_commis.injection.bo.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, scrn2, kckr);

        eff2 = r_particles.efficiency;
        r_scrn2 = r_particles.r_screen;

        dyf_new = r_scrn2(2);
        [~, dthetay] = sirius_commis.injection.bo.scrn_septum_corresp(machine2, 0, dyf_new, scrn2);

        if abs(dyf_new) > abs(dyf_old)
           p = 0;
           param.offset_y_syst = param.offset_y_syst + dyf_old;
        end

        if mean(eff2) < eff_lim
            param = sirius_commis.injection.bo.screen_low_intensity(machine2, param, param_errors, n_part, n_pulse, scrn2, kckr, mean(eff2), 2, 0.75);
            r_particles = sirius_commis.injection.bo.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, scrn2, kckr);
            r_scrn2 = r_particles.r_screen;
        end

        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end

        dtheta_kckr = r_scrn2(1) / d_kckr_scrn2;
        dx12 = r_scrn2(1);
        fprintf('Screen 2 - x position: %f mm \n', r_scrn2(1)*1e3);
        fprintf('Screen 2 - y position: %f mm \n', r_scrn2(2)*1e3);
        fprintf('=================================================\n');

        dyf_old = dyf_new;
    end
end
