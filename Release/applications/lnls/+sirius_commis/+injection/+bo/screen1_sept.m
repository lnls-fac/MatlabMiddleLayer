function [r_scrn1, param] = screen1_sept(machine, param, param_errors, n_part, n_pulse, scrn1, kckr)

    fprintf('=================================================\n');
    fprintf('SCREEN 1 ON - KICKER OFF \n')
    fprintf('=================================================\n');

    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
    dxf_e = 1; dyf_e = 1;
    dthetax = 0; dthetay = 0; dyf = 0;
    eff_lim = 0.50;
    res_scrn = param_errors.sigma_scrn / sqrt(n_pulse);
    s = findspos(machine, 1:length(machine));

    kckr_ind = findcells(machine, 'FamName', 'InjKckr');
    L_kckr = machine{kckr_ind}.Length;
    d_kckr_scrn = s(scrn1) - s(kckr_ind) - L_kckr/2; % Adjustment to particles reach x=0 at kicker center
    x_kckr_scrn = tan(-param.kckr0) * d_kckr_scrn;

    while dxf_e > res_scrn || dyf_e > res_scrn
        param.offset_xl_syst = param.offset_xl_syst + dthetax;
        param.offset_yl_syst = param.offset_yl_syst - dthetay;
        % param.offset_y_syst = param.offset_y_syst - dyf;
        r_particles = sirius_commis.injection.bo.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr);
        eff1 = r_particles.efficiency;
        r_scrn1 = r_particles.r_screen;

        if mean(eff1) < eff_lim
            param = sirius_commis.injection.bo.screen_low_intensity(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr, mean(eff1), 1, 0.75);
            [~, r_scrn1] = sirius_commis.injection.bo.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr);
        end

        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end

        dxf = r_scrn1(1) - x_kckr_scrn;
        dyf = r_scrn1(2);
        [dthetax, dthetay] = sirius_commis.injection.bo.scrn_septum_corresp(machine1, dxf, dyf, scrn1);
        dxf_e = abs(dxf);
        dyf_e = abs(dyf);
        fprintf('(KICKER OFF) Screen 1 - x position: %f mm, error %f mm \n', r_scrn1(1)*1e3, dxf_e*1e3);
        fprintf('(KICKER OFF) Screen 1 - y position: %f mm, error %f mm \n', r_scrn1(2)*1e3, dyf_e*1e3);
        fprintf('=================================================\n');
    end
end
