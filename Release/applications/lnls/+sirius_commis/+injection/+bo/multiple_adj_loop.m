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
%  - param_error: injection systematic/pulsed errors for each machine before the adjustments
%
% OUTPUTS:
%  - param_adjusted: cell with structs of corrected injection parameters

sirius_commis.common.initializations();
param_adjusted = cell(n_mach, 1);

    if n_mach == 1
        res_scrn = param_error.sigma_scrn_pulse / sqrt(n_pulse);
        res_x = sqrt(res_scrn^2 + (param.etax_scrn3 * param_error.delta_error_pulse)^2) / sqrt(n_pulse);
        param_error.offset_scrn_mach{1} = reshape(lnls_generate_random_numbers(1, 6, 'norm', 1) .* 1e-3, 2, 3);
        param_error.offset_scrn = param_error.offset_scrn_mach{1};
        [param_adjusted, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine, n_part, n_pulse, param, param_error);

        while abs(r_scrn3(1)) > res_x  || abs(r_scrn3(2)) > res_scrn
            fprintf('ADJUSTING ENERGY \n');
            [param_adjusted, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine, n_part, n_pulse, param_adjusted, param_error);
        end

    param_adjusted.orbit = findorbit4(machine, 0, 1:length(machine));
    else
        for j = 1:n_mach
            fprintf('=================================================\n');
            fprintf('MACHINE NUMBER %i \n', j)
            fprintf('=================================================\n');

            res_scrn = param_error{j}.sigma_scrn_pulse / sqrt(n_pulse);
            res_x = sqrt(res_scrn^2 + (param.etax_scrn3 * param_error.delta_error_pulse)^2) / sqrt(n_pulse);
            param_error{j}.offset_scrn_mach{j} = reshape(lnls_generate_random_numbers(1, 6, 'norm', 1) .* 1e-3, 2, 3);
            param_error{j}.offset_scrn = param_error{j}.offset_scrn_mach{j};
            [param_adjusted{j}, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine{j}, n_part, n_pulse, param{j}, param_error{j});

            n_corr_energy = 0;

            while abs(r_scrn3(1)) > res_x  || abs(r_scrn3(2)) > res_scrn
                fprintf('ADJUSTING ENERGY \n');
                [param_adjusted{j}, r_scrn3] = sirius_commis.injection.bo.single_adj_loop(machine{j}, n_part, n_pulse, param_adjusted{j}, param_error{j});

                if n_corr_energy > 5
                    break
                end

                n_corr_energy = n_corr_energy + 1;
            end

            param_adjusted{j}.orbit = findorbit4(machine{j}, 0, 1:length(machine{j}));

            save param_adjusted.mat param_adjusted
        end
    end
end
