function [freq, phase, freq0, phase0, fail] = adjust_rf(machine, n_mach, param, param_errors, n_part, n_turns, n)

    sirius_commis.common.initializations();
    
    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
    end
    
    freq = zeros(n_mach, 1);
    phase = zeros(n_mach, 1);
    fail = zeros(n_mach, 1);
    
    for j = 1:n_mach
        
        fprintf('MACHINE NUMBER %i \n', j);
        machine = machine_cell{j};
        param = param_cell{j};

        machine = setcavity('on', machine);
        machine = setradiation('on', machine);
        param.beam.sigmae = param.beam.sigmae/2;
        param.beam.sigmaz = 3e-3;
        param_errors.phase_sist = 23e-2;
        param.phase_sist = param_errors.phase_sist;
        lambda_rf = 0.6;

        % figure;
        cavity_ind = findcells(machine, 'Frequency');
        cavity = machine{cavity_ind};
        V0 = cavity.Voltage;
        p_i = 3;
        machine{cavity_ind}.Voltage = p_i * V0;

        f_rf0 = cavity.Frequency;
        error = 5e-6; % THIS ERROR CORRESPONDS TO A BOOSTER LENGTH ERROR OF 2.5mm
        df_erro = error * f_rf0;
        f_rf = f_rf0 + df_erro;
        alpha = 7.21025937429492e-4;
        de = - 1 / alpha * error;
        machine{cavity_ind}.Frequency = f_rf;
        f_new(1) = f_rf;

        ph_lag_old = 0;
        ph_lag_new = 1;
        f_pass = 2e3;
        step = 0.75;
        tol_ph = 1e-2 / 6;
        dif_ph = 1;

        while abs(dif_ph) > tol_ph
            fail(j) = 0;

            if ph_lag_new == 1
                fprintf('VARREDURA NA FASE DE RF \n');
                [~, ~, ~, ~, ~, ph_max_old] = test(machine, param, param_errors, n_part, n_turns, n);
                ph_lag_old = 2 * pi * ph_max_old / n;
                fprintf('FASE DE RF ÓTIMA %f cm \n', lambda_rf * ph_max_old / n * 1e2);
            else
                ph_lag_old = ph_lag_new;
                f_pass = f_pass * step ;
            end

            machine{cavity_ind}.Voltage = machine{cavity_ind}.Voltage / p_i;


            fact_old = test(machine, param, param_errors, n_part, n_turns, 1, ph_lag_old);
            k = 1;
            fact_new(k) = fact_old;

            n_change = 0;
            p = 1;
            inv = 0;

            while fact_new(k) >= fact_old
                fprintf('MUDANDO FREQUENCIA DE RF \n');

                fact_old = fact_new(k);

                f_new(k+1) = f_new(k) + (-1)^p * f_pass;
                machine{cavity_ind}.Frequency = f_new(k+1);

                fact_new(k+1) = test(machine, param, param_errors, n_part, n_turns, 1, ph_lag_old);
                df_found = f_new(k+1) - f_rf;
                fprintf('DELTA DE FREQUÊNCIA: %f kHz \n', df_found * 1e-3);

                n_change = n_change + 1;

                if fact_new(k+1) < fact_old && n_change == 1
                    if inv == 1
                        warning('Not able to find best frequency');
                        fail(j) = 1;
                        break                        
                    end
                    f_new(k+1) = f_new(k) - (-1)^p * abs(f_pass);
                    machine{cavity_ind}.Frequency = f_new(k+1);
                    p = 0;
                    fact_new(k+1) = fact_old;
                    n_change = 0;
                    inv = 1;
                end
                k = k+1;
            end
            
            [~, ind_max_f] = max(fact_new);
            
            f_max = f_new(ind_max_f);
%             if fact_new(ind_max_f + 1) > fact_new(ind_max_f - 1)
%                 f_max = (b * f_new(ind_max_f) + f_new(ind_max_f + 1)) / (b + 1) ;
%             else
%                 f_max = (b * f_new(ind_max_f) + f_new(ind_max_f - 1)) / (b + 1) ;
%             end
                
            machine{cavity_ind}.Frequency = f_max;
            f_new(1) = f_max;
            

            % machine{cavity_ind}.Frequency = machine{cavity_ind}.Frequency - (-1)^p * abs(f_pass);

            machine{cavity_ind}.Voltage = p_i * V0;

            fprintf('VARREDURA NA FASE DE RF \n');
            n = round(n / step);
            [~, ~, ~, ~, ~, ph_max_new] = test(machine, param, param_errors, n_part, n_turns, n);
            fprintf('FASE DE RF ÓTIMA %f cm \n', lambda_rf * ph_max_new / n * 1e2);

            ph_lag_new = 2 * pi * ph_max_new / n ;

            dif_ph = (ph_lag_new - ph_lag_old) * lambda_rf / 2 / pi;
        end

        % machine{cavity_ind}.Frequency = machine{cavity_ind}.Frequency - (-1)^p * abs(f_pass);
        f_final = machine{cavity_ind}.Frequency;
        df_found = abs(f_final - f_rf); % n_change * freq_pass;
        
        freq(j) = f_final;
        freq0 = f_rf;
        phase(j) = ph_lag_new;
        phase0 = param_errors.phase_sist;
        
        fprintf('df gerado %f kHz, df aplicado %f kHz, concordancia %f %% \n', df_erro*1e-3, df_found*1e-3, sirius_commis.common.prox_percent(df_erro, df_found));
        dz_found = ph_lag_new * lambda_rf / 2 / pi;
        fprintf('dz gerado %f cm, dz aplicado %f cm, concordancia %f %% \n', param_errors.phase_sist*1e2, dz_found * 1e2, sirius_commis.common.prox_percent(param_errors.phase_sist, dz_found));
    end
end

function [fact, r_6d, r_init, r_bpm_turns, phase_max, ph_max] =  test(machine, param, param_errors, n_part, n_turns, n, ph_lag)

        eff_lim = 0.25;
        lambda_rf = 0.6;
        
        if ~exist('ph_lag', 'var')
            ph_pass = 2 * pi / n;
        else
            ph_pass = ph_lag;
        end

        injkckr = findcells(machine, 'FamName', 'InjKckr');
        bpm = findcells(machine, 'FamName', 'BPM');

        r_init = zeros(n, n_turns, 6, n_part);
        RBPM = zeros(n, n_turns, 2, size(bpm, 2));
        INTBPM = zeros(n, n_turns, size(bpm, 2));
        r_bpm_turns = zeros(n, 2, size(bpm, 2));
        fact = zeros(1, n);
        
        for m = 1:n
            
            cavity_ind = findcells(machine, 'Frequency');
            machine{cavity_ind}.PhaseLag = m * ph_pass;          
            
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

            [~, r_init(m, 1, :, :), r_bpm] = sirius_commis.injection.bo.single_pulse(machine, param, n_part, length(machine));
            eff = sirius_commis.common.calc_eff(n_part, squeeze(r_init(m, 1, :, :)));
            fact(m) = fact(m) + 1 * eff;

            machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

            [sigma_bpm, int_bpm] = sirius_commis.common.bpm_error_inten(r_bpm, n_part, param_errors.sigma_bpm);
        
            if n_part == 1
                r_bpm = r_bpm + sigma_bpm;
            else
                r_bpm = squeeze(nanmean(r_bpm, 2)) + sigma_bpm;
            end

            orbit0 = findorbit6(machine, 1:size(machine, 2));

            RBPM(m, 1, :, :) = r_bpm;
            INTBPM(m, 1, :) = int_bpm;

            param.orbit = orbit0;
            sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);

            count_turns = 1;
            fprintf('Turn number 1 \n');

            for i = 1:n_turns-1
                [r_init(m, i+1, :, :), eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init(m, i, :, :), i+1, 'bpm', param, param_errors);

                RBPM(m, i+1, :, :) = r_bpm;
                INTBPM(m, i+1, :) = int_bpm;

                if eff <= eff_lim
                    r_bpm_turns(m, :, :) = squeeze(nansum(RBPM(m, :, :, :), 2) / count_turns);
                    sirius_commis.common.plot_bpms(machine, param.orbit, squeeze(r_bpm_turns(m, :, :)), int_bpm);
                    RBPM(m, :, :, :) = zeros(n_turns, 2, size(bpm, 2));
                    break
                end
                count_turns = count_turns + 1;
                fact(m) = fact(m) + count_turns * eff;
            end

            r_bpm_turns(m, :, :) = squeeze(nansum(RBPM(m, :, :, :), 2) / count_turns);
            sirius_commis.common.plot_bpms(machine, param.orbit, squeeze(r_bpm_turns(m, :, :)), int_bpm);

%             gcf();
%             plot(squeeze(mean(INTBPM(m, :, :), 3)));
            INTBPM(m, :, :) = zeros(n_turns, size(bpm, 2));            
            % fprintf('PHASE: %f cm \n', lambda_rf * m / n * 1e2);
        end
        
    [~, ph_max] = max(fact);
    phase_max = lambda_rf * ph_max / n;
    machine{cavity_ind}.PhaseLag = ph_max * ph_pass;
    r_6d = squeeze(nanmean(r_init(ph_max, 1:count_turns, :, :), 4));
    r_bpm_turns = squeeze(r_bpm_turns(ph_max, :, :));
    % figure;
    % plot(r_6d(:, 6), r_6d(:, 5)); 
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

function [df, de_f, delta_medio] = energy_bpm(machine, param, r_bpm_turns, f_rf0, df, j, alpha)
    cavity_ind = findcells(machine, 'Frequency');
    % sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm_turns, int_bpm);
    x_bpm = squeeze(r_bpm_turns(1, :));
    delta_bpm = x_bpm / mean(param.etax_bpms);
    delta_medio = mean(delta_bpm);
    ddf = sum(df(1:j-1));
    df(j) = - alpha * delta_medio * (f_rf0 + ddf);
    de_f = - 1/alpha * df(j)/machine{cavity_ind}.Frequency;
    machine{cavity_ind}.Frequency = machine{cavity_ind}.Frequency - abs(df(j));
end