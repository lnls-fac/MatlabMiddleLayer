function ft_data = closes_orbit(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv, n_turns)
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

sirius_commis.common.initializations();

    fam = sirius_bo_family_data(machine);
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;

    machine = setcellstruct(machine, 'PolynomB', fam.SD.ATIndex, 0, 1, 3);
    machine = setcellstruct(machine, 'PolynomB', fam.SF.ATIndex, 0, 1, 3);

    theta_x = lnls_get_kickangle(machine, ch, 'x')';
    theta_y = lnls_get_kickangle(machine, cv, 'y')';
    n_bpm = length(bpm);
    n_bpm_turns = n_bpm * n_turns;

    r = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);

    count_turns_old = min(r.num_of_turns);
    r_bpm = r.r_bpm_pulse_mean;
    int_bpm = r.sum_bpm_pulse_mean;

    r_bpm(isnan(r_bpm)) = 0;
    int_bpm(isnan(int_bpm)) = 0;
    corr_lim = 20 * 300e-6;
    eff_lim = 0.25;
    n_cor = 1;
    inc_x = true; inc_y = true;
    ft_data.error = false;

    int_bpm = squeeze(int_bpm);
    int_bpm = reshape(int_bpm', n_bpm_turns, 1);

    rx = squeeze(r_bpm(:, 1, :));
    ry = squeeze(r_bpm(:, 2, :));

    rxx = reshape(rx', n_bpm_turns, 1);
    ryy = reshape(ry', n_bpm_turns, 1);

    ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
    ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
    ref_orbit = [ref_orbitx; ref_orbity];
    count_turns_new = count_turns_old;
    ref = true;

    x_mean = mean(rxx);
    delta_mean = x_mean / mean(param.etax_bpms);
    param.delta_ave = param.delta_ave * (1 + delta_mean) + delta_mean;

    while count_turns_old < n_turns

        int_bpm = squeeze(int_bpm);
        int_bpm = reshape(int_bpm', n_bpm_turns, 1);

        rx = squeeze(r_bpm(:, 1, :));
        ry = squeeze(r_bpm(:, 2, :));

        rxx = reshape(rx', n_bpm_turns, 1);
        ryy = reshape(ry', n_bpm_turns, 1);

        ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
        ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);

        rxx(int_bpm < eff_lim) = 0;
        ryy(int_bpm < eff_lim) = 0;
        ref_orbitx(int_bpm < eff_lim) = 0;
        ref_orbity(int_bpm < eff_lim) = 0;
        r_bpm_turn = [rxx; ryy];

        [U, S, V] = svd(m_corr, 'econ');
        S_inv = 1 ./ diag(S);
        S_inv(isinf(S_inv)) = 0;

        if n_sv > size(S_inv, 1)
            n_sv = size(S_inv, 1);
        end

        S_inv(n_sv+1:end) = 0;
        S_inv = diag(S_inv);
        m_corr_inv = V * S_inv * U';

        if count_turns_new > 1 && ref
            ref_orbit = [ref_orbitx; ref_orbity];
            ref = false;
        else
            ref_orbit = 0.*ref_orbit;
        end

        delta_kicks = m_corr_inv * (ref_orbit - r_bpm_turn);
        delta_kicks(isnan(delta_kicks)) = 0;
        theta_x = theta_x + delta_kicks(1:length(ch));
        theta_y = theta_y + delta_kicks(length(ch)+1:end-1);

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
            theta_x(over_kick_y) =  sign(theta_x(over_kick_y)) * corr_lim;
        end

        if inc_x
            machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
        end

        if inc_y
            machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
        end

        r = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);

        count_turns_old = min(r.num_of_turns);
        r_bpm = r.r_bpm_pulse_mean;
        int_bpm = r.sum_bpm_pulse_mean;

        r_bpm(isnan(r_bpm)) = 0;
        int_bpm(isnan(int_bpm)) = 0;

        if count_turns_new < count_turns_old
            theta_x = theta_x - delta_kicks(1:length(ch));
            theta_y = theta_y - delta_kicks(length(ch)+1:end-1);
            machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
            machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
        else
            count_turns_old = count_turns_new;
        end

        n_cor = n_cor + 1;
    end
end
