function mach_perf = twiss_inj_eff(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns, n_points, max, twiss, plot)
% Studies of how the changes in nominal twiss function values at the end
% of booster injection septum affects the machine performance and 
% comissioning algorithms
%
% Input: - machine: struct with random machines for the booster lattice
%        - n_mach: number of random machines simulated
%        - param: injection parameters
%        - param_errors: errors associated with injection parameters
%        - n_part: number of particles
%        - n_pulses: number of pulses to average
%        - n_points: number of points to vary the twiss functions
%        - max: maximum multiple of nominal twiss function to test
%        - twiss: twiss function type: 'beta', 'alpha' or 'eta'
%        - plot: 'plot' if one wants to plot the first turn efficiency in
%        function of twiss function variation, empty if does not.
%
% Output: - mach_perf: cell with length equal number of random machines
% containing for each line a struct with the following parameters:
%         tx and ty: vector with horizontal and vertical values of twiss
%         functions used (Note: for the dispersion function 'eta', the
%         vertical value ty corresponds to the derivative of horizontal
%         dispersion
%         eff_x and eff_y: vector with correspondent first turns efficiency
%         for each tx and ty.
% 
% Version 1 - Murilo B. Alves - November, 2018.

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
    
    machine = setcavity('on', machine);
    machine = setradiation('on', machine);

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
            fprintf('=======================================\n');
            fprintf('Beta x - %i of %i \n', k, n_points);
            fprintf('=======================================\n');
            param.twiss.betax0 = tx(k);
            [~, ~, ~, eff_pulses_x] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, param, param_errors, n_part, n_pulse, n_turns);
            eff_x(k) = eff_pulses_x;
        end
        
        if mean(eff_x) < 1e-5
            continue
        end

        param.twiss.betax0 = betax0;

        for k = 1:n_points
            fprintf('=======================================\n');
            fprintf('Beta y - %i of %i \n', k, n_points);
            fprintf('=======================================\n');
            param.twiss.betay0 = ty(k);
            [~, ~, ~, eff_pulses_y]  = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, param, param_errors, n_part, n_pulse, n_turns);
            eff_y(k) = eff_pulses_y;
        end

    elseif strcmp(twiss, 'alpha')
        name_x = 'Alpha x';
        name_y = 'Alpha y';
        alphax0 = param.twiss.alphax0;
        alphay0 = param.twiss.alphay0;
        tx = linspace(alphax0 * max, -alphax0 * max,  n_points);
        ty = linspace(-alphay0 * max,  alphay0 * max,  n_points);

        for k = 1:n_points
            fprintf('=======================================\n');
            fprintf('Alpha x- %i of %i \n', k, n_points);
            fprintf('=======================================\n');
            param.twiss.alphax0 = tx(k);
            [~, ~, ~, eff_pulses_x]  = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
            eff_x(k) = eff_pulses_x;
        end

        param.twiss.alphax0 = alphax0;

        for k = 1:n_points
            fprintf('=======================================\n');
            fprintf('Alpha y - %i of %i \n', k, n_points);
            fprintf('=======================================\n');
            param.twiss.alphay0 = ty(k);
            [~, ~, ~, eff_pulses_y]  = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
            eff_y(k) = eff_pulses_y;
        end

    elseif strcmp(twiss, 'eta')
        name_x = 'Dispersion x [m]';
        name_y = 'Dispersion x Derivative';
        etax0 = param.twiss.etax0;
        etaxl0 = param.twiss.etaxl0;
        % tx = linspace(-etax0 * max, etax0 * max,  n_points);
        % ty = linspace(-etaxl0 * max,  etaxl0 * max,  n_points);
        
        tx = linspace(0, etax0 * max,  n_points);
        ty = linspace(0,  etaxl0 * max,  n_points);

        for k = 1:n_points
            fprintf('=======================================\n');
            fprintf('Dispersion x - %i of %i \n', k, n_points);
            fprintf('=======================================\n');
            param.twiss.etax0 = tx(k);
            [~, ~, ~, eff_pulses_x] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
            eff_x(k) = eff_pulses_x;
        end

        param.twiss.etax0 = etax0;

        for k = 1:n_points
            fprintf('=======================================\n');
            fprintf('Dispersion derivative x - %i of %i \n', k, n_points);
            fprintf('=======================================\n');
            param.twiss.etaxl0 = ty(k);
            [~, ~, ~, eff_pulses_y]  = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
            eff_y(k) = eff_pulses_y;
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