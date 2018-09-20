function param = screen_low_intensity(machine, param, n_part, n_pulse, scrn, kckr, eff, n, eff_lim)
dtheta0 = 0;
dtheta_kckr = 0;
delta_energy = 0;
i = 0;
j = 0;
n_times = 20;

if n == 1;
    fprintf('LOW INTENSITY ON SCREEN 1 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        dtheta0 = dtheta0 + param.offset_xl_sist * 0.1;
        param.offset_xl_sist = param.offset_xl_sist + dtheta0;
        [eff, ~] = bo_pulses(machine, param, n_part, n_pulse, scrn, kckr);
        eff = mean(eff); 
        i = i + 1;
        if i > n_times
            dtheta0 = 0;
            param.offset_xl_sist = param.xl_sept_init;
            while eff < eff_lim
            dtheta0 = dtheta0 - param.offset_xl_sist * 0.1;
            param.offset_xl_sist = param.offset_xl_sist + dtheta0;
            [eff, ~] = bo_pulses(machine, param, n_part, n_pulse, scrn, kckr);
            eff = mean(eff); 
            j = j + 1;
            if j > n_times
                error('INCREASING INTENSITY PROBLEMS ON SCREEN 1!!!')
            end
            end
        end
    end
end

if n == 2;
    fprintf('LOW INTENSITY ON SCREEN 2 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        dtheta_kckr = dtheta_kckr + param.kckr_sist * 0.1;
        param.kckr_sist = param.kckr_sist - dtheta_kckr;
        [eff, ~] = bo_pulses(machine, param, n_part, n_pulse, scrn, kckr);
        eff = mean(eff); 
        i = i + 1;
        if i > n_times
            dtheta_kckr = 0;
            param.kckr_sist = param.kckr_init;
            while eff < eff_lim
            dtheta_kckr = dtheta_kckr - param.kckr_sist * 0.1;
            param.kckr_sist = param.kckr_sist - dtheta_kckr;
            [eff, ~] = bo_pulses(machine, param, n_part, n_pulse, scrn, kckr);
            eff = mean(eff); 
            j = j + 1;
            if j > n_times
                error('INCREASING INTENSITY PROBLEMS ON SCREEN 2!!!')
            end
            end
        end
    end
end

if n == 3;
    fprintf('LOW INTENSITY ON SCREEN 3 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        delta_energy = delta_energy + param.delta_sist * 0.1;
        param.delta_ave = param.delta_ave + delta_energy;
        [eff, ~] = bo_pulses(machine, param, n_part, n_pulse, scrn, kckr);
        eff = mean(eff); 
        i = i + 1;
        if i > n_times
            delta_energy = 0;
            param.delta_ave = 0;
            while eff < eff_lim
            delta_energy = delta_energy - param.delta_sist * 0.1;
            param.delta_ave = param.delta_ave + delta_energy;
            [eff, ~] = bo_pulses(machine, param, n_part, n_pulse, scrn, kckr);
            eff = mean(eff); 
            j = j + 1;
            if j > n_times
                error('INCREASING INTENSITY PROBLEMS ON 3!!!')
            end
            end
        end
    end
end
end

