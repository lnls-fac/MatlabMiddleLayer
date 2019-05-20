function param_adjusted = multiple_adj_loop(machine, n_mach, n_part, n_pulse, param0, param0_error, turn_off)
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
% [param0_error, param0] = sirius_commis.injection.si.add_errors(param0);
param_adjusted = cell(n_mach, 1);
% param0_error.delta_error_syst = 1e-2;
% param0.delta_syst = 1e-2;
% param0_error.sigma_bpm = 2e-3;
% etax_bpm2 = 0.087369551883561;
% etax_bpm3 = 0.152064321770701;
% a = round(etax_bpm2 * 100); b = round(etax_bpm3 * 100);

% res2 = sqrt(0 *res_bpm * res_bpm / n_pulse + (0.05 / 100 * etax_bpm2)^2);
% res3 = sqrt(0 *res_bpm * res_bpm / n_pulse + (0.05 / 100 * etax_bpm3)^2);
if n_mach == 1
    if turn_off
        machine = sirius_commis.injection.si.turn_off_magnets(machine);
    end
    param_adjusted = sirius_commis.injection.si.single_adj_loop(machine, n_part, n_pulse, param0, param0_error);
    param_adjusted.orbit = findorbit4(machine, 0, 1:length(machine));
else
    for j = 1:n_mach
        if turn_off
            machine{j} = sirius_commis.injection.si.turn_off_magnets(machine{j});
        end
        fprintf('=================================================\n');
        fprintf('MACHINE NUMBER %i \n', j)
        fprintf('=================================================\n');
        param_adjusted{j} = sirius_commis.injection.si.single_adj_loop(machine{j}, n_part, n_pulse, param0{j}, param0_error{j});
        param_adjusted{j}.orbit = findorbit4(machine{j}, 0, 1:length(machine{j}));
        
        save param_adjusted.mat param_adjusted
    end
end
end
