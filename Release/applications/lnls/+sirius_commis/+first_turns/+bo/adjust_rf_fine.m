function adjust_rf_fine(machine, param, param_errors, n_part, n_turns, ph_lag, freq_new)

sirius_commis.common.initializations();

machine = setcavity('on', machine);
machine = setradiation('on', machine);
param.beam.sigmae = param.beam.sigmae/2;
param.beam.sigmaz = 3e-3;
param_errors.phase_sist = 23e-2;
param.phase_sist = param_errors.phase_sist;
lambda_rf = 0.6;

cavity_ind = findcells(machine, 'Frequency');
cavity = machine{cavity_ind};

f_rf0 = cavity.Frequency;
error = 5e-6; % THIS ERROR CORRESPONDS TO A BOOSTER LENGTH ERROR OF 2.5mm
df_erro = error * f_rf0;
f_rf = f_rf0 + df_erro;
alpha = 7.21025937429492e-4;
de = - 1 / alpha * error;
machine{cavity_ind}.Frequency = freq_new;

machine{cavity_ind}.PhaseLag = ph_lag;

delta_bpm = 1;

while abs(delta_bpm) > 0.1e-3
    [~, r_bpm] = test(machine, param, param_errors, n_part, n_turns);

    x_bpm(:) = r_bpm(1, :);
    delta_bpm = mean(x_bpm / mean(param.etax_bpms));

    df = - alpha * delta_bpm * machine{cavity_ind}.Frequency;
    machine{cavity_ind}.Frequency = machine{cavity_ind}.Frequency - abs(df);
    fprintf('DELTA DE FREQUENCIA APLICADO %f kHz: \n', df * 1e-3);
end
machine{cavity_ind}.Frequency = machine{cavity_ind}.Frequency + abs(df);
df_found = machine{cavity_ind}.Frequency - f_rf;
fprintf('df gerado %f kHz, df aplicado %f kHz, concordancia %f %% \n', df_erro*1e-3, df_found*1e-3, sirius_commis.common.prox_percent(df_erro, df_found));
end

function [x_init, r_bpm_turns] =  test(machine, param, param_errors, n_part, n_turns)

        eff_lim = 0.25;       
       
        injkckr = findcells(machine, 'FamName', 'InjKckr');
        bpm = findcells(machine, 'FamName', 'BPM');

        r_init = zeros(n_turns, 6, n_part);
        RBPM = zeros(n_turns, 2, size(bpm, 2));
        INTBPM = zeros(n_turns, size(bpm, 2));
        r_bpm_turns = zeros(2, size(bpm, 2));

        error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.x_error_pulse;
        param.offset_x = param.offset_x_sist + error_x_pulse;

        error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.xl_error_pulse;
        param.offset_xl = param.offset_xl_sist + error_xl_pulse;

        % Peak to Peak values from measurements - cutoff = 1;

        error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.kckr_error_pulse;
        param.kckr = param.kckr_sist + error_kckr_pulse;

        error_delta_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.delta_error_pulse;
        param.delta = param.delta_sist + 0 * error_delta_pulse;

        error_jitter = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * 3e-2;
        param.phase = param.phase_sist + 0 * error_jitter;

        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');

        [~, r_init(1, :, :), r_bpm] = sirius_commis.injection.bo.single_pulse(machine, param, n_part, length(machine));
 
        machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

        [sigma_bpm, int_bpm] = sirius_commis.common.bpm_error_inten(r_bpm, n_part, param_errors.sigma_bpm);

        if n_part == 1
            r_bpm = r_bpm + sigma_bpm;
        else
            r_bpm = squeeze(nanmean(r_bpm, 2)) + sigma_bpm;
        end

        orbit0 = findorbit6(machine, 1:size(machine, 2));

        RBPM(1, :, :) = r_bpm;
        INTBPM(1, :) = int_bpm;

        param.orbit = orbit0;
        sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);

        count_turns = 1;
        fprintf('Turn number 1 \n');

        for i = 1:n_turns-1
            [r_init(i+1, :, :), eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init(i, :, :), i+1, 'bpm', param, param_errors);

            RBPM(i+1, :, :) = r_bpm;
            INTBPM(i+1, :) = int_bpm;

            if eff <= eff_lim
                r_bpm_turns(:, :) = squeeze(nansum(RBPM(:, :, :), 1) / count_turns);
                sirius_commis.common.plot_bpms(machine, param.orbit, squeeze(r_bpm_turns(:, :)), int_bpm);
                RBPM(:, :, :) = zeros(n_turns, 2, size(bpm, 2));
                break
            end
            count_turns = count_turns + 1;

        end
        
        x_init = squeeze(mean(r_init(:, 1, :), 3));
        r_bpm_turns(:, :) = squeeze(nansum(RBPM(:, :, :), 1) / count_turns);
        sirius_commis.common.plot_bpms(machine, param.orbit, squeeze(r_bpm_turns(:, :)), int_bpm);
end

    
function [r_init, eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init, turn_n, bpm, param, param_errors)
    r_init = squeeze(r_init);
    
    cavity_ind = findcells(machine, 'Frequency');
    cavity = machine{cavity_ind};    
    h = cavity.HarmNumber;
    L0 = findspos(machine,length(machine)+1); % design length [m]
    C0 = 299792458; % speed of light [m/s]
    T0 = L0/C0;
    f_rf = cavity.Frequency;
    
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
            r_out = linepass(machine, r_init, 1:size(machine, 2));
        else
            r_out = linepass(machine, r_init, 1:size(machine, 2), 'reuse');
        end
        r_out = reshape(r_out, 6, [], size(machine, 2));
    end
    [r_out_xy, ~, ind_sum] = sirius_commis.common.compares_vchamb(machine, r_out([1,3], :, :), 1:size(machine));
    % r_out([1,3], :, :) = r_out_xy;
    r_out(ind_sum >= 1) = NaN;
    r_init = squeeze(r_out(:, :, end));
    r_init(6, :) = r_init(6, :) - C0*(h/f_rf - T0);
    loss_ind = ~isnan(r_out(1, :, size(machine, 2)));
   %  r_init = r_init(:, loss_ind, :);
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

