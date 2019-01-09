function [param_adjusted, param0_error] = multiple_adj_loop(machine, n_mach, n_part, n_pulse, param0)
% Algorithm of injection parameters adjustments using screens.
%
% INPUTS:
%  - machine: storage ring model with errors
%  - n_mach: number of random machines
%  - n_part: number of particles
%  - n_pulse: number of pulses to average the measurements
%  - param0: nominal injection parameters with systematic/pulsed errors
%  before the adjustments
%
% OUTPUTS:
%  - param_adjusted: cell with structs of corrected injection parameters
%
% Version 1 - Murilo B. Alves - December, 2018


sirius_commis.common.initializations();
[param0_error, param0] = sirius_commis.injection.si.add_errors(param0);
param_adjusted = cell(n_mach, 1);

res_bpm = param0_error.sigma_bpm;

if n_mach == 1
    machine = sirius_commis.injection.si.turn_off_magnets(machine);
    [param_adjusted, ~, x_bpm2] = sirius_commis.injection.si.single_adj_loop(machine, n_part, n_pulse, 'no', param0, param0_error);
    while abs(x_bpm2) > res_bpm / sqrt(n_pulse)
        fprintf('ADJUSTING ENERGY \n');
        [param_adjusted, ~, x_bpm2] = sirius_commis.injection.si.single_adj_loop(machine, n_part, n_pulse, 'no', param_adjusted, param0_error);
    end
    param_adjusted.orbit = findorbit4(machine, 0, 1:length(machine));
else
    for j = 1:n_mach
    %machine{j} = sirius_commis.injection.si.turn_off_magnets(machine{j});
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    [param_adjusted{j}, ~, x_bpm2] = sirius_commis.injection.si.single_adj_loop(machine{j}, n_part, n_pulse, 'no', param0, param0_error);
    while abs(x_bpm2) > res_bpm / sqrt(n_pulse)
        fprintf('ADJUSTING ENERGY \n');
        [param_adjusted{j}, ~, x_bpm2] = sirius_commis.injection.si.single_adj_loop(machine{j}, n_part, n_pulse, 'no', param_adjusted{j}, param0_error);
    end
    param_adjusted{j}.orbit = findorbit4(machine{j}, 0, 1:length(machine{j}));
    end
end
end
