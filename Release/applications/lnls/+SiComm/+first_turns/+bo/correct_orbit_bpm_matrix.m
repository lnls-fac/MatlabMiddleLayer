function ft_data = correct_orbit_bpm_matrix(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv, r_bpm, int_bpm)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with a matrix approach
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: struct with injection parameters errors and
%  measurements errors
%  - m_corr: first turn trajectory corrector matrix with 2 * #BPMs rows
%  and #CH + #CV + 1 columns
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_sv: number of singular values to use in correction
%  - r_bpm: BPM position measurements (2 x #BPMs) from previous first turn
%  tracking
%  - int_bpm: BPM sum signal (1 x #BPMs) from previous first turn tracking
%
% OUTPUTS:
%  - ft_data: first turn data struct with the following properties:
%  * first_cod: First COD solution obtained
%  * final_cod: Last COD solution when algorithm has converged
%  * machine: booster ring lattice with corrector kicks applied
%  * max_kick: vector with 0 and 1 where 1 means that the kick
%  reached the maximum value for the specific corrector
%  * n_svd: number of singular values when the algorithm converge
%  * ft_cod: data with kicks setting to obtain first COD solution, its
%  values and statistics

% Version 1 - Murilo B. Alves - October, 2018
% Version 2 - Murilo B. Alves - March, 2019

% sirius_commis.common.initializations();

    fam = sirius_bo_family_data(machine);
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;

    machine = setcellstruct(machine, 'PolynomB', fam.SD.ATIndex, 0, 1, 3);
    machine = setcellstruct(machine, 'PolynomB', fam.SF.ATIndex, 0, 1, 3);

    theta_x = lnls_get_kickangle(machine, ch, 'x')';
    theta_y = lnls_get_kickangle(machine, cv, 'y')';

    if ~exist('r_bpm', 'var') && ~exist('int_bpm', 'var')
        r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
        r_bpm = r.r_bpm;
        int_bpm = r.sum_bpm;
    end

    rms_orbit_x_bpm_old = nanstd(r_bpm(1,:));
    rms_orbit_y_bpm_old = nanstd(r_bpm(2,:));
    corr_lim = 20 * 300e-6;

    eff_lim = 0.9;
    n_cor = 1;
    tol = 0.90;

    rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
    rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;
    inc_x = true; inc_y = true;
    ft_data.error = false;

    while int_bpm(end) < eff_lim
        bpm_int_ok = bpm(int_bpm > 0.25);
        [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);

        bpm_select = zeros(length(bpm), 1);
        bpm_select(ind_ok_bpm) = 1;

        if sum(bpm_select) == 1
            warning('Only 1 BPM with good sum signal!')
            ft_data.machine = machine;
            ft_data.error = true;
            ft_data.n_svd = n_sv;
        return
        end

        m_corr_ok = m_corr([ind_ok_bpm; length(bpm) + ind_ok_bpm], :);
        [U, S, V] = svd(m_corr_ok, 'econ');
        S_inv = 1 ./ diag(S);
        S_inv(isinf(S_inv)) = 0;
        S_inv(n_sv+1:end) = 0;
        S_inv = diag(S_inv);
        m_corr_inv = V * S_inv * U';
        x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
        y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
        new_r_bpm = [x_bpm, y_bpm];
        delta_kick = - m_corr_inv * new_r_bpm';
        theta_x = theta_x + delta_kick(1:length(ch));
        theta_y = theta_y + delta_kick(length(ch)+1:end-1);

        % Particular method that works when there is no coupling, a more
        % generic method of inversion is used in accordance with SOFB

        %{
        m_corr_x_ok = m_corr_x(ind_ok_bpm, :);
        [Ux, Sx, Vx] = svd(m_corr_x_ok, 'econ');
        Sx_inv = 1 ./ diag(Sx);
        Sx_inv(isinf(Sx_inv)) = 0;
        Sx_inv(n_sv+1:end) = 0;
        % Sx_inv(Sx_inv > 5 * Sx_inv(1)) = 0;
        Sx_inv = diag(Sx_inv);
        m_corr_inv_x = Vx * Sx_inv * Ux';

        x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
        theta_x =  theta_x - m_corr_inv_x * x_bpm';

        m_corr_y_ok = m_corr_y(ind_ok_bpm, :);
        [Uy, Sy, Vy] = svd(m_corr_y_ok, 'econ');
        Sy_inv = 1 ./ diag(Sy);
        Sy_inv(isinf(Sy_inv)) = 0;
        Sy_inv(n_sv+1:end) = 0;
        % Sy_inv(Sy_inv > 5 * Sy_inv(1)) = 0;
        Sy_inv = diag(Sy_inv);
        m_corr_inv_y = Vy * Sy_inv * Uy';

        y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
        theta_y = theta_y - m_corr_inv_y * y_bpm';
        %}

        over_kick_x = abs(theta_x) > corr_lim;
        if any(over_kick_x)
            warning('Horizontal corrector kick greater than maximum')
            gr_mach_x(over_kick_x) = 1;
            theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
        end

        over_kick_y = abs(theta_y) > corr_lim;
        if any(over_kick_y)
            warning('Vertical corrector kick greater than maximum')
            gr_mach_y(over_kick_y) = 1;
            theta_y(over_kick_y) =  sign(theta_y(over_kick_y)) * corr_lim;
        end

        machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
        machine = lnls_set_kickangle(machine, theta_y, cv, 'y');

        r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
        r_bpm = r.r_bpm;
        int_bpm = r.sum_bpm;
        rms_orbit_x_bpm_new = nanstd(r_bpm(1,:)); rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));

        n_cor = n_cor + 1;
        n_sv = n_sv + 1;
    end

    x_mean = mean(r_bpm(1, :));
    delta_mean = x_mean / mean(param.etax_bpms);
    param.delta_ave = param.delta_ave * (1 + delta_mean) + delta_mean;

    kickx_ft = lnls_get_kickangle(machine, ch, 'x');
    kicky_ft = lnls_get_kickangle(machine, cv, 'y');
    orbit_ft = findorbit4(machine, 0, 1:length(machine));
    r_bpm_ft = r_bpm;

    [U, S, V] = svd(m_corr, 'econ');
    S_inv = 1 ./ diag(S);
    S_inv(isinf(S_inv)) = 0;
    n_t = n_sv;
    k = 1;
    n_inc = 0;
    stop_x = false; stop_y = false;
    sv_change = false;

    theta_x_i = kickx_ft;
    theta_y_i = kicky_ft;

    while inc_x || inc_y
        S_inv_var = S_inv;

        if ~sv_change
            if ~stop_x
                rms_orbit_x_bpm_old = rms_orbit_x_bpm_new;
            end
            if ~stop_y
                rms_orbit_y_bpm_old = rms_orbit_y_bpm_new;
            end
        end

        S_inv_var(n_t + 1:end) = 0;
        S_inv_var = diag(S_inv_var);
        m_corr_inv = V * S_inv_var * U';
        x_bpm = squeeze(r_bpm(1, :));
        y_bpm = squeeze(r_bpm(2, :));
        new_r_bpm = [x_bpm, y_bpm];
        delta_kick = - m_corr_inv * new_r_bpm';
        theta_x_f = theta_x_i + delta_kick(1:length(ch));
        theta_y_f = theta_y_i + delta_kick(length(ch)+1:end-1);

        if inc_x
            over_kick_x = abs(theta_x_f) > corr_lim;

            if any(over_kick_x)
                warning('Horizontal corrector kick greater than maximum')
                gr_mach_x(over_kick_x) = 1;
                theta_x_f(over_kick_x) =  sign(theta_x_f(over_kick_x)) * corr_lim;
            end

            machine = lnls_set_kickangle(machine, theta_x_f, ch, 'x');
            fprintf('HORIZONTAL CORRECTION \n');
        end

        if inc_y
            over_kick_y = abs(theta_y_f) > corr_lim;

            if any(over_kick_y)
                warning('Vertical corrector kick greater than maximum')
                gr_mach_y(over_kick_y) = 1;
                theta_y_f(over_kick_y) =  sign(theta_y_f(over_kick_y)) * corr_lim;
            end

            machine = lnls_set_kickangle(machine, theta_y_f, cv, 'y');
            fprintf('VERTICAL CORRECTION \n');
        end

        param.orbit = findorbit4(machine, 0, 1:length(machine));
        ft_data.finalcod.bpm_pos = r_bpm;

        r = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
        r_bpm = r.r_bpm;
        int_bpm = r.sum_bpm;

        if int_bpm(end) < eff_lim
            machine = lnls_set_kickangle(machine, kickx_ft, ch, 'x');
            machine = lnls_set_kickangle(machine, kicky_ft, cv, 'y');
            ft_data.machine = machine;
            ft_data.n_svd = n_t;
            ft_data.ftcod.kickx = kickx_ft;
            ft_data.ftcod.kicky = kicky_ft;
            ft_data.ftcod.orbit = orbit_ft;
            ft_data.param = param;
            rms_x = nanstd(orbit_ft(1, :));   rms_y = nanstd(orbit_ft(3, :));
            ft_data.ftcod.rms_x = rms_x;      ft_data.ftcod.rms_y = rms_y;
            ft_data.ftcod.bpm_pos = r_bpm_ft;
            return
        end

        rms_orbit_x_bpm_new = nanstd(r_bpm(1,:));
        rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));

        if ~stop_x
            ratio_x = rms_orbit_x_bpm_new / rms_orbit_x_bpm_old;
            inc_x = ratio_x < tol;
            if ~inc_x
                machine = lnls_set_kickangle(machine, theta_x_i, ch, 'x');
                stop_x = true;
            else
                theta_x_i = theta_x_f;
                fprintf('X - OLD: %f -->> NEW: %f mm \n', rms_orbit_x_bpm_old*1e3, rms_orbit_x_bpm_new*1e3);
            end
        end

        if ~stop_y
            ratio_y = rms_orbit_y_bpm_new / rms_orbit_y_bpm_old;
            inc_y = ratio_y < tol;
            if ~inc_y
                machine = lnls_set_kickangle(machine, theta_y_i, cv, 'y');
                stop_y = true;
            else
                theta_y_i = theta_y_f;
                fprintf('Y - OLD: %f -->> NEW: %f mm \n', rms_orbit_y_bpm_old*1e3, rms_orbit_y_bpm_new*1e3);
            end
        end

        if ~inc_x && ~inc_y
            if n_inc == 0
                ft_data.machine = machine;
                ft_data.param = param;
                ft_data.n_svd = n_t;
                ft_data.ftcod.kickx = kickx_ft;
                ft_data.ftcod.kicky = kicky_ft;
                ft_data.ftcod.orbit = orbit_ft;
                rms_x = nanstd(orbit_ft(1, :));   rms_y = nanstd(orbit_ft(3, :));
                ft_data.ftcod.rms_x = rms_x;      ft_data.ftcod.rms_y = rms_y;
                ft_data.ftcod.bpm_pos = r_bpm_ft;
                return
            else
                n_t = n_sv + k * 10;
                if n_t > 50
                    n_t = 50;
                end
                inc_x = true; inc_y = true;
                stop_x = false; stop_y = false;
                k = k+1;
                n_inc = 0;
                sv_change = true;
                fprintf('Number of Singular Values: %i \n', n_t);
                continue
            end
        end
        n_inc = n_inc + 1;

        if n_inc > 10
            n_t = n_sv + k * 10;
            if n_t > 50
                n_t = 50;
            end
            inc_x = true; inc_y = true;
            stop_x = false; stop_y = false;
            k = k+1;
            n_inc = 0;
            sv_change = true;
            fprintf('Number of Singular Values: %i \n', n_t);
            continue
        end
        sv_change = false;
    end
end

function [param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data)
        if first_cod
            orbit = findorbit4(machine, 0, 1:length(machine));
            param.orbit = orbit;
            return
        end
        orbit = findorbit4(machine, 0, 1:length(machine));
        param.orbit = orbit;
        cod_nan = sum(isnan(orbit(:))) > 0;
        if ~cod_nan
            theta_x = lnls_get_kickangle(machine, fam.CH.ATIndex, 'x')';
            theta_y = lnls_get_kickangle(machine, fam.CV.ATIndex, 'y')';
            rms_x = nanstd(orbit(1, :));   rms_y = nanstd(orbit(3, :));
            cod_data.kickx = theta_x;   cod_data.kicky = theta_y;
            cod_data.rms_x = rms_x;     cod_data.rms_y = rms_y;
            cod_data.orbit = orbit;
            first_cod = true;
        end
end
