function param_adjusted = adj_boost_times(machine, n_mach, n_part, n_pulse, param0)
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

initializations();
param0 = add_errors_injection(param0);
param_adjusted = cell(n_mach, 1);

if n_mach == 1
    [param_adjusted, ~, x_scrn3] = bo_injection_adjustment(machine, n_part, n_pulse, 'no', param0);
    res_scrn = param_adjusted.sigma_scrn;
    while abs(x_scrn3) > res_scrn
        fprintf('ADJUSTING ENERGY \n');
        [param_adjusted, ~, x_scrn3] = bo_injection_adjustment(machine, n_part, n_pulse, 'no', param_adjusted);
    end
else
    bpm = findcells(machine{1}, 'FamName', 'BPM');
    for j = 1:n_mach
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    [param_adjusted{j}, ~, x_scrn3] = bo_injection_adjustment(machine{j}, n_part, n_pulse, 'no', param0);
    res_scrn = param_adjusted{j}.sigma_scrn;
    while abs(x_scrn3) > res_scrn
        fprintf('ADJUSTING ENERGY \n');
        [param_adjusted{j}, ~, x_scrn3] = bo_injection_adjustment(machine{j}, n_part, n_pulse, 'no', param_adjusted{j});
    end
    param_adjusted{j}.orbit = findorbit4(machine{j}, 0, bpm);
    end
end
end