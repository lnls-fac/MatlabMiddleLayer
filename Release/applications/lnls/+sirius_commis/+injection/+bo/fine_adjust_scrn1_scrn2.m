function [r_scrn2, param, thetax12] = fine_adjust_scrn1_scrn2(machine, param, param_errors, n_part, n_pulse, kckr, scrn1, scrn2, r_scrn2)

    res_scrn = param_errors.sigma_scrn_pulse;
    s = findspos(machine, 1:length(machine));
    dx12 = 1; dy12 = 1;
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
    machine2 = setcellstruct(machine, 'VChamber', scrn2+1:length(machine), 0, 1, 1);

    if isempty(r_scrn2)
        error('It is necessary a screen 2 measurement as input');
    end

    while abs(dx12) > res_scrn || abs(dy12) > res_scrn
        if isnan(r_scrn2(1))
           error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end

        fprintf('=================================================\n');
        fprintf('SCREEN 1 ON \n')
        fprintf('=================================================\n');

        r_particles1 = sirius_commis.injection.bo.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr);

        eff1 = r_particles1.efficiency;
        r_scrn1 = r_particles1.r_screen;

        if mean(eff1) < 0.75
            param = sirius_commis.injection.bo.screen_low_intensity(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr, mean(eff1), 1, 0.75);
            r_particles1 = sirius_commis.injection.bo.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, scrn1, kckr);
            r_scrn1 = r_particles1.r_screen;
        end

        if isnan(r_scrn1(1))
           error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end

        dx12 = r_scrn2(1) - r_scrn1(1);
        dy12 = r_scrn2(2) - r_scrn1(2);
        d12 = s(scrn2) - s(scrn1);
        thetax12 = atan(dx12 / d12);
        thetay12 = atan(dy12 / d12);

        if abs(dx12) < res_scrn && abs(dy12) < res_scrn % / sqrt(n_pulse)
            fprintf('SCREEN 1 AND 2 X DIFFERENCE: %f mm, ANGLE X AFTER KICKER: %f mrad \n', abs(dx12)*1e3, abs(thetax12)*1e3);
            fprintf('SCREEN 1 AND 2 Y DIFFERENCE: %f mm, ANGLE Y AFTER KICKER: %f mrad \n', abs(dy12)*1e3, abs(thetay12)*1e3);
            break
        end

        param.kckr_syst = param.kckr_syst - thetax12;
        param.offset_yl_syst = param.offset_yl_syst - thetay12;

        fprintf('=================================================\n');
        fprintf('SCREEN 2 ON \n')
        fprintf('=================================================\n');

        r_particles2 = sirius_commis.injection.bo.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, scrn2, kckr);
        eff2 = r_particles2.efficiency;
        r_scrn2 = r_particles2.r_screen;

        if mean(eff2) < 0.75
            param = sirius_commis.injection.bo.screen_low_intensity(machine2, param, param_errors, n_part, n_pulse, scrn1, kckr, mean(eff2), 2, 0.75);
            r_particles2 = sirius_commis.injection.bo.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, scrn2, kckr);
            r_scrn2 = r_particles2.r_screen;
        end
    end
end
