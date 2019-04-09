function [param_adjusted, param0_error, theta_aft_kckr] = multiple_adj_loop(machine, n_mach, n_part, n_pulse, param0)
% Algorithm of injection parameters adjustments using screens.
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of random machines
%  - n_part: number of particles
%  - n_pulse: number of pulses to average the measurements
%  - param0: nominal injection parameters with systematic/pulsed errors
%  before the adjustments
%
% OUTPUTS:
%  - param_adjusted: cell with structs of corrected injection parameters
%
% Version 1 - Murilo B. Alves - October 4th, 2018

sirius_commis.common.initializations();
[param0_error, param0] = sirius_commis.injection.bo.add_errors(param0);
param_adjusted = cell(n_mach, 1);
res_scrn = param0_error.sigma_scrn;
scrn_error = [0.036, 0.018, 0.018; 1.703, 0.803, 1.004].*1e-3;

if n_mach == 1
    param0_error.offset_scrn_mach{1} = scrn_error; % reshape(lnls_generate_random_numbers(1, 6, 'norm', 1) .* param0_error.sigma_scrn, 2, 3);
    param0_error.offset_scrn = param0_error.offset_scrn_mach{1};
    [param_adjusted, ~, x_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine, n_part, n_pulse, 'no', param0, param0_error);
    while abs(x_scrn3) > res_scrn
        fprintf('ADJUSTING ENERGY \n');
        [param_adjusted, ~, x_scrn3, theta_aft_kckr] = sirius_commis.injection.bo.single_adj_loop(machine, n_part, n_pulse, 'no', param_adjusted, param0_error);
    end
    param_adjusted.orbit = findorbit4(machine, 0, 1:length(machine));
else
    for j = 1:n_mach
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    param0_error.offset_scrn_mach{j} = scrn_error; % reshape(lnls_generate_random_numbers(1, 6, 'norm', 1) .* param0_error.sigma_scrn, 2, 3);
    param0_error.offset_scrn = param0_error.offset_scrn_mach{j};
    [param_adjusted{j}, ~, x_scrn3, theta_aft_kckr(j)] = sirius_commis.injection.bo.single_adj_loop(machine{j}, n_part, n_pulse, 'no', param0, param0_error);
    while abs(x_scrn3) > res_scrn % / sqrt(n_pulse)
        fprintf('ADJUSTING ENERGY \n');
        [param_adjusted{j}, ~, x_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine{j}, n_part, n_pulse, 'no', param_adjusted{j}, param0_error);
    end
    param_adjusted{j}.orbit = findorbit4(machine{j}, 0, 1:length(machine{j}));
    end
end
end
