function param = bpm_low_intensity(machine, param, param_error, n_part, n_pulse, bpm, kckr, eff, n, eff_lim)
% Applies changes in parameters as angle deflection of injection septum,
% kicker and energy to obtain good intensity reaching the BPM
%
% Version 1 - Murilo B. Alves - December, 2018.

dtheta0 = 0;
dtheta_kckr = 0;
delta_energy = 0;
i = 0;
j = 0;
n_times = 20;

if n == 1
    fprintf('LOW INTENSITY ON BPM 1 (KICKER OFF) \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        dtheta0 = dtheta0 - param.offset_xl_sist * 0.1;
        param.offset_xl_sist = param.offset_xl_sist + dtheta0;
        [eff, ~] = sirius_commis.injection.si.multiple_pulse(machine, param, param_error, n_part, n_pulse, bpm, kckr);
        eff = mean(eff); 
        i = i + 1;
        if i > n_times
            dtheta0 = 0;
            param.offset_xl_sist = param.xl_sept_init;
            while eff < eff_lim
            dtheta0 = dtheta0 + param.offset_xl_sist * 0.1;
            param.offset_xl_sist = param.offset_xl_sist + dtheta0;
            [eff, ~] = sirius_commis.injection.si.multiple_pulse(machine, param, param_error, n_part, n_pulse, bpm, kckr);
            eff = mean(eff); 
            j = j + 1;
            if j > n_times
                error('INCREASING INTENSITY PROBLEMS ON SCREEN 1!!!')
            end
            end
        end
    end
end

if n == 2
    fprintf('LOW INTENSITY ON BPM 1 (KICKER ON) \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        dtheta_kckr = dtheta_kckr + param.kckr_sist * 0.1;
        param.kckr_sist = param.kckr_sist - dtheta_kckr;
        [eff, ~] = sirius_commis.injection.si.multiple_pulse(machine, param, param_error, n_part, n_pulse, bpm, kckr);
        eff = mean(eff); 
        i = i + 1;
        if i > n_times
            dtheta_kckr = 0;
            param.kckr_sist = param.kckr_init;
            while eff < eff_lim
            dtheta_kckr = dtheta_kckr - param.kckr_sist * 0.1;
            param.kckr_sist = param.kckr_sist - dtheta_kckr;
            [eff, ~] = sirius_commis.injection.si.multiple_pulse(machine, param, param_error, n_part, n_pulse, bpm, kckr);
            eff = mean(eff); 
            j = j + 1;
            if j > n_times
                error('INCREASING INTENSITY PROBLEMS ON BPM 1!!!')
            end
            end
        end
    end
end

if n == 3
    fprintf('LOW INTENSITY ON BPM 2 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        delta_energy = delta_energy + param.delta_sist * 0.1;
        param.delta_ave = param.delta_ave + delta_energy;
        [eff, ~] = sirius_commis.injection.si.multiple_pulse(machine, param, param_error, n_part, n_pulse, bpm, kckr);
        eff = mean(eff); 
        i = i + 1;
        if i > n_times
            delta_energy = 0;
            param.delta_ave = 0;
            while eff < eff_lim
            delta_energy = delta_energy - param.delta_sist * 0.1;
            param.delta_ave = param.delta_ave + delta_energy;
            [eff, ~] = sirius_commis.injection.si.multiple_pulse(machine, param, param_error, n_part, n_pulse, bpm, kckr);
            eff = mean(eff); 
            j = j + 1;
            if j > n_times
                error('INCREASING INTENSITY PROBLEMS ON BPM 2!!!')
            end
            end
        end
    end
end
end

