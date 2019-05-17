function param_adjusted = multiple_adj_loop(machine, n_mach, n_part, n_pulse, param, param_error)
% Algorithm of injection parameters adjustments using screens.
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of random machines
%  - n_part: number of particles
%  - n_pulse: number of pulses to average the measurements
%  - param: nominal injection parameters with systematic/pulsed errors
%  before the adjustments
%
% OUTPUTS:
%  - param_adjusted: cell with structs of corrected injection parameters
%
% Version 1 - Murilo B. Alves - October 4th, 2018

sirius_commis.common.initializations();
param_adjusted = cell(n_mach, 1);
res_scrn = param_error{1}.sigma_scrn_pulse;

    if n_mach == 1
        param_error{1}.offset_scrn_mach{1} = reshape(lnls_generate_random_numbers(1, 6, 'norm', 1) .* 1e-3, 2, 3);
        param_error{1}.offset_scrn = param_error{1}.offset_scrn_mach{1};
        [param_adjusted, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine, n_part, n_pulse, 'no', param, param_error{1});

        while abs(r_scrn3(1)) > res_scrn  || abs(r_scrn3(2)) > res_scrn
            fprintf('ADJUSTING ENERGY \n');
            [param_adjusted, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine, n_part, n_pulse, 'no', param_adjusted, param_error{1});
        end

    param_adjusted{1}.orbit = findorbit4(machine, 0, 1:length(machine));
    else
        for j = 1:n_mach
            fprintf('=================================================\n');
            fprintf('MACHINE NUMBER %i \n', j)
            fprintf('=================================================\n');

            param_error{j}.offset_scrn_mach{j} = reshape(lnls_generate_random_numbers(1, 6, 'norm', 1) .* 1e-3, 2, 3);
            param_error{j}.offset_scrn = param_error{j}.offset_scrn_mach{j};
            [param_adjusted{j}, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine{j}, n_part, n_pulse, 'no', param{j}, param_error{j});

            while abs(r_scrn3(1)) > res_scrn  || abs(r_scrn3(2)) > res_scrn
                fprintf('ADJUSTING ENERGY \n');
                [param_adjusted{j}, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine{j}, n_part, n_pulse, 'no', param_adjusted{j}, param_error{j});
            end

            param_adjusted{j}.orbit = findorbit4(machine{j}, 0, 1:length(machine{j}));

            save param_adjusted.mat param_adjusted
        end
    end
end
