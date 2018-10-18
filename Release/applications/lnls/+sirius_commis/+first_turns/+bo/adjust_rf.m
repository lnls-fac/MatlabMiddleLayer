function [r_6d_cent, r_bpm_turns] = adjust_rf(machine, param, param_errors, n_part, n_turns)

    sirius_commis.common.initializations();

    machine = setcavity('off', machine);
    machine = setradiation('off', machine);
    eff_lim = 0.5;
    % alpha = 0.000721025937429492;
    
    cavity_ind = findcells(machine, 'Frequency');
    cavity = machine{cavity_ind};
    V0 = cavity.Voltage;    
    machine{cavity_ind}.Voltage = V0;
    
    f_rf0 = cavity.Frequency;
    error = 2e-5; % THIS ERROR CORRESPONDS TO A BOOSTER LENGTH ERROR OF 10mm
    f_rf = f_rf0 * (1 + error);
    machine{cavity_ind}.Frequency = f_rf;
    
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    bpm = findcells(machine, 'FamName', 'BPM');
    
    r_init = zeros(n_turns, 6, n_part);
    RBPM = zeros(n_turns, 2, size(bpm, 2));
    
    error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.x_error_pulse;
    param.offset_x = param.offset_x_sist + error_x_pulse;

    error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.xl_error_pulse;
    param.offset_xl = param.offset_xl_sist + error_xl_pulse;
    % Peak to Peak values from measurements - cutoff = 1;

    error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.kckr_error_pulse;
    param.kckr = param.kckr_sist + error_kckr_pulse;
    % machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
    
    error_delta_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.delta_error_pulse;
    param.delta = param.delta_sist + error_delta_pulse;
    
    error_jitter = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * 3e-2;    
    error_phase_sist = 30e-2; % param_errors.phase_offset;
    
    param.phase = error_phase_sist + 0 * error_jitter;
    count_turns = 1;
    
    while count_turns < n_turns    
        machine{cavity_ind}.Frequency = cavity.Frequency - f_rf0 * 2e-6;
        machine{cavity_ind}.PhaseLag = machine{cavity_ind}.PhaseLag + 180/pi;

        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');

        [~, r_init(1, :, :), r_bpm] = sirius_commis.injection.bo.single_pulse(machine, param, n_part, length(machine));

        if n_part == 1
            RBPM(1, :, :) = r_bpm;
        else
            RBPM(1, :, :) = squeeze(nanmean(r_bpm, 2));
        end

        machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

        [sigma_bpm, int_bpm] = sirius_commis.common.bpm_error_inten(RBPM(1, :, :), 1, param_errors.sigma_bpm);
        r_bpm = squeeze(RBPM(1, :, :)) + sigma_bpm;
        % orbit0 = findorbit6(machine, 1:size(machine, 2));
        orbit0 = findorbit4(machine, 0, 1:size(machine, 2));
        param.orbit = orbit0;
        sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);

        count_turns = 1;
        fprintf('Turn number 1 \n');

        machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

        for i = 1:n_turns-1
            [r_init(i+1, :, :), eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init(i, :, :), i+1, 'bpm', param, param_errors);

            if n_part
                RBPM(i+1, :, :) = r_bpm;
            else
                RBPM(i+1, :, :) = squeeze(nanmean(r_bpm, 2));
            end

            if eff < eff_lim
                r_bpm_turns = squeeze(nansum(RBPM, 1) / count_turns);
                sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm_turns, int_bpm);
                break
            end

            count_turns = count_turns + 1;
        end
    end
    r_bpm_turns = squeeze(sum(RBPM, 1) / count_turns);
    r_6d_cent = squeeze(nanmean(r_init, 3));
    r_6d_cent = r_6d_cent(1:count_turns, :);
    sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm_turns, int_bpm);
end
    
function [r_init, eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init, turn_n, bpm, param, param_errors)
    r_init = squeeze(r_init);
    if(exist('bpm','var'))
        if(strcmp(bpm,'bpm'))
            flag_bpm = true;
        end
    elseif(~exist('bpm','var'))
            flag_bpm = false;
    end

    if n_part ~= 1
        if turn_n == 2
            r_out = linepass(machine, r_init, 1:size(machine, 2));
        else
            r_out = linepass(machine, r_init, 1:size(machine, 2), 'reuse');
        end
        r_out = reshape(r_out, 6, size(r_init, 2), size(machine, 2));
    else
        if turn_n == 2
            r_out = linepass(machine, r_init', 1:size(machine, 2));
        else
            r_out = linepass(machine, r_init', 1:size(machine, 2), 'reuse');
        end
        r_out = reshape(r_out, 6, [], size(machine, 2));
    end
    r_out_xy = sirius_commis.common.compares_vchamb(machine, r_out([1,3], :, :), 1:size(machine));
    r_out([1,3], :, :) = r_out_xy;
    r_init = squeeze(r_out(:, :, end));
    loss_ind = ~isnan(r_out(1, :, size(machine, 2)));
    % r_init = r_init(:, loss_ind);
    eff = sirius_commis.common.calc_eff(n_part, r_init);
    
    if n_part ~= 1
        fprintf('Turn number %i , Efficiency %f %% \n', turn_n, eff*100);
    else
        fprintf('Turn number %i \n', turn_n);
        if ~loss_ind
            fprintf('Particle lost at turn number %i \n', turn_n);
        end
    end
    
    if flag_bpm
        sigma_bpm0 = param_errors.sigma_bpm;
        bpm = findcells(machine, 'FamName', 'BPM');
        r_out_bpm = r_out_xy(:, :, bpm);
        [sigma_bpm, int_bpm] = sirius_commis.common.bpm_error_inten(r_out_bpm, n_part, sigma_bpm0);
        r_diag_bpm = squeeze(nanmean(r_out_bpm, 2)) + sigma_bpm;
        r_bpm = sirius_commis.common.compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);
    end
end