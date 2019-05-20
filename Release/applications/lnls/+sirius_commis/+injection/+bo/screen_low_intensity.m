function param = screen_low_intensity(machine, param, param_error, n_part, n_pulse, scrn, kckr, eff, n, eff_lim)
% Applies changes in parameters as angle deflection of injection septum,
% kicker and energy to obtain good intensity reaching the screen
%
% Version 1 - Murilo B. Alves - October, 2018.

dtheta0x = 0;
dtheta0y = 0;
dtheta_kckr = 0;
delta_energy = 0;
i = 0;
j = 0;
n_times = 20;

if n == 1
    fprintf('LOW INTENSITY ON SCREEN 1 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        dtheta0x = dtheta0x + param.offset_xl_syst * 0.1;
        % dtheta0y = dtheta0y + param.offset_yl_syst * 0.1;
        param.offset_xl_syst = param.offset_xl_syst + dtheta0x;
        % param.offset_yl_syst = param.offset_yl_syst + dtheta0y;
        r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_error, n_part, n_pulse, scrn, kckr);
        eff = mean(r.efficiency); 
        i = i + 1;
        if i > n_times
            dtheta0x = 0;
            param.offset_xl_syst = param.xl_sept_init;
            param.offset_yl_syst = param.yl_sept_init;
            while eff < eff_lim
            dtheta0x = dtheta0x - param.offset_xl_syst * 0.1;
            % dtheta0y = dtheta0y - param.offset_yl_syst * 0.1;
            % param.offset_yl_syst = param.offset_yl_syst + dtheta0y;
            r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_error, n_part, n_pulse, scrn, kckr);
            eff = mean(r.efficiency); 
            j = j + 1;
            if j > n_times
                warning('INCREASING INTENSITY PROBLEMS ON SCREEN 1!!!')
                return
            end
            end
        end
    end
end

if n == 2
    fprintf('LOW INTENSITY ON SCREEN 2 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        dtheta_kckr = dtheta_kckr + param.kckr_syst * 0.1;
        param.kckr_syst = param.kckr_syst - dtheta_kckr;
        r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_error, n_part, n_pulse, scrn, kckr);
        eff = mean(r.efficiency); 
        i = i + 1;
        if i > n_times
            dtheta_kckr = 0;
            param.kckr_syst = param.kckr_init;
            while eff < eff_lim
            dtheta_kckr = dtheta_kckr - param.kckr_syst * 0.1;
            param.kckr_syst = param.kckr_syst - dtheta_kckr;
            r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_error, n_part, n_pulse, scrn, kckr);
            eff = mean(r.efficiency); 
            j = j + 1;
            if j > n_times
                warning('INCREASING INTENSITY PROBLEMS ON SCREEN 2!!!')
                return
            end
            end
        end
    end
end

if n == 3
    fprintf('LOW INTENSITY ON SCREEN 3 \n');
    fprintf('=================================================\n');
    while eff < eff_lim
        delta_energy = delta_energy + param.delta_syst * 0.1;
        param.delta_ave = param.delta_ave + delta_energy;
        r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_error, n_part, n_pulse, scrn, kckr);
        eff = mean(r.efficiency); 
        i = i + 1;
        if i > n_times
            delta_energy = 0;
            param.delta_ave = 0;
            while eff < eff_lim
            delta_energy = delta_energy - param.delta_syst * 0.1;
            param.delta_ave = param.delta_ave + delta_energy;
            r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_error, n_part, n_pulse, scrn, kckr);
            eff = mean(r.efficiency); 
            j = j + 1;
            if j > n_times
                warning('INCREASING INTENSITY PROBLEMS ON 3!!!')
                return
            end
            end
        end
    end
end
end

