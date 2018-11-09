function mach_perf = twiss_inj_eff(machine, n_mach, param, param_errors, n_part, n_pulse, n_points, max, twiss, plot)

sirius_commis.common.initializations();

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end

mach_perf = cell(n_mach, 1);

if ~exist('plot', 'var')
    flag_plot = false;
elseif strcmp(plot, 'plot')
    flag_plot = true;
end


for j = 1:n_mach
    
    fprintf('MACHINE NUMBER %i \n', j);
    machine = machine_cell{j};
    param = param_cell{j};

    eff_x = zeros(n_points, 1);
    eff_y = eff_x;

    if strcmp(twiss, 'beta')
        name_x = 'Beta x [m]';
        name_y = 'Beta y [m]';
        betax0 = param.twiss.betax0;
        betay0 = param.twiss.betay0;
        tx = linspace(0, betax0 * max,  n_points);
        ty = linspace(0, betay0 * max,  n_points);

        for k = 1:n_points
            param.twiss.betax0 = tx(k);
            eff_pulses_x = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot');
            eff_x(k) = mean(eff_pulses_x);
        end
        
        if mean(eff_x) < 1e-5
            continue
        end

        param.twiss.betax0 = betax0;

        for k = 1:n_points
            param.twiss.betay0 = ty(k);
            eff_pulses_y = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot');
            eff_y(k) = mean(eff_pulses_y);
        end

    elseif strcmp(twiss, 'alpha')
        name_x = 'Alpha x';
        name_y = 'Alpha y';
        alphax0 = param.twiss.alphax0;
        alphay0 = param.twiss.alphay0;
        tx = linspace(alphax0 * max, -alphax0 * max,  n_points);
        ty = linspace(-alphay0 * max,  alphay0 * max,  n_points);

        for k = 1:n_points
            param.twiss.alphax0 = tx(k);
            eff_pulses_x = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot');
            eff_x(k) = mean(eff_pulses_x);
        end

        param.twiss.alphax0 = alphax0;

        for k = 1:n_points
            param.twiss.alphay0 = ty(k);
            eff_pulses_y = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot');
            eff_y(k) = mean(eff_pulses_y);
        end

    elseif strcmp(twiss, 'eta')
        name_x = 'Dispersion x [m]';
        name_y = 'Dispersion x Derivative';
        etax0 = param.twiss.etax0;
        etaxl0 = param.twiss.etaxl0;
        tx = linspace(-etax0 * max, etax0 * max,  n_points);
        ty = linspace(-etaxl0 * max,  etaxl0 * max,  n_points);

        for k = 1:n_points
            param.twiss.etax0 = tx(k);
            eff_pulses_x = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot');
            eff_x(k) = mean(eff_pulses_x);
        end

        param.twiss.etax0 = etax0;

        for k = 1:n_points
            param.twiss.etaxl0 = ty(k);
            eff_pulses_y = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot');
            eff_y(k) = mean(eff_pulses_y);
        end
    end
    
    if flag_plot
        figure; 
        px = plot(tx, 100 * eff_x); 
        xlabel(name_x); 
        ylabel('Efficiency [%]'); 
        px.LineWidth = 0.1; 
        px.Marker = '*'; 
        grid on;

        figure; 
        py = plot(ty, 100 * eff_y); 
        xlabel(name_y); 
        ylabel('Efficiency [%]'); 
        py.LineWidth = 0.1; 
        py.Marker = '*'; 
        grid on;
    end
    
    eff_mach.tx = tx; eff_mach.eff_x = eff_x; eff_mach.ty = ty; eff_mach.eff_y = eff_y;
    mach_perf{j} = eff_mach;
end