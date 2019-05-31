function r_out = single_pulse_turn(machine, param, param_errors, n_part, n_turns, c_prev)
% Simulation of storage ring injection and turns around the ring for a single
% pulse (for multiple pulses, see the function multiple_pulses_turns())
%
% INPUTS:
%  - machine: storage ring ring model with errors
%  - n_mach: number of random machines
%  - n_part: number of particles
%  - param: cell of structs with adjusted injection parameters for each
%  machine
%  - n_turns: limited number of turns before reach the
%  specified efficiency which considers the beam as lost
%
% OUTPUTS: r_out - struct with the fields:
%               - eff_1st_turn: first turn efficiency
%               - num_of_turns: number of turns
%               - r_bpm_mean: mean BPM meas. in turns
%               - sum_bpm_mean: mean BPM sum in turns
%               - r_bpm_tbt: turn-by-turn BPM position.
%               - sum_bpm_tbt: turn-by-turn BPM sum.
%               - eff_turns: efficiency for each turn

% sirius_commis.common.initializations()

    bpm = findcells(machine, 'FamName', 'BPM');
    r_bpm_tbt = zeros(n_turns, 2, length(bpm));
    sum_bpm_tbt = zeros(n_turns, 1, length(bpm));

    eff_turns = zeros(n_turns, 1);
    eff_lim = 0.50;
    lm = length(machine);
    param.orbit = findorbit4(machine, 0, 1:lm);
    count_turns = 0;

    kckr = 'on';
    r =  sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, lm, kckr, 'diag');

    eff_1turn = r.efficiency;
    r_init = r.r_end;
    r_bpm_tbt(1, :, :) = r.r_bpm;
    sum_bpm_tbt(1, :, :) = r.sum_bpm;

    injkckr = findcells(machine, 'FamName', 'InjDpKckr');
    machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

    fprintf('=================================================\n');
    fprintf('TURNS \n');
    fprintf('=================================================\n');

    fprintf('Turn number 1 , Efficiency %f %% \n', eff_1turn*100);
    eff_turns(1) = eff_1turn;

    if eff_1turn < eff_lim
        r_bpm_turns = squeeze(r_bpm_tbt(1, :, :));
        int_bpm_turns = squeeze(sum_bpm_tbt(1, :, :));
        r_out.num_of_turns = count_turns;
        r_out.r_bpm_mean = r_bpm_turns;
        r_out.sum_bpm_mean = int_bpm_turns;
        r_out.eff_turns = eff_turns;
        r_out.r_bpm_tbt = r_bpm_tbt;
        r_out.sum_bpm_tbt = sum_bpm_tbt;
        return
    end

    count_turns = count_turns + 1;

    for i = 1:n_turns-1
        r = single_turn(machine, n_part, r_init, i+1, 'bpm', param, param_errors);

        eff_turns(i+1) = r.efficiency;
        r_init = r.r_end;
        r_bpm_tbt(i+1, :, :) = r.r_bpm;
        sum_bpm_tbt(i+1, :, :) = r.sum_bpm;

        if eff_turns(i+1) < eff_lim
            break
        end

        count_turns = count_turns + 1;

        if count_turns > c_prev
            break
        end
    end

    r_bpm_turns = squeeze(sum(r_bpm_tbt, 1) / count_turns);
    int_bpm_turns = squeeze(sum(sum_bpm_tbt, 1) / count_turns);

    r_out.eff_1st_turn = eff_1turn;
    r_out.num_of_turns = count_turns;
    r_out.r_bpm_mean = r_bpm_turns;
    r_out.sum_bpm_mean = int_bpm_turns;
    r_out.r_bpm_tbt = r_bpm_tbt;
    r_out.sum_bpm_tbt = sum_bpm_tbt;
    r_out.eff_turns = eff_turns;
end

function r = single_turn(machine, n_part, r_init, turn_n, bpm, param, param_errors)
    r_init = squeeze(r_init);
    if(exist('bpm','var'))
        if(strcmp(bpm,'bpm'))
            flag_bpm = true;
        end
    elseif(~exist('bpm','var'))
            flag_bpm = false;
    end

    p = 0;

    % !! IMPORTANT !!
    % +1 added because linepass does the tracking until the beginning of
    % element and it is needed until the end to perform one turn

    if turn_n ~= 2
        r_out = linepass(machine, r_init, 1:length(machine)+1, 'reuse');
    else
        r_out = linepass(machine, r_init, 1:length(machine)+1);
    end

    r_out = reshape(r_out, 6, size(r_init, 2), size(machine, 2)+1);
    r_out_xy = sirius_commis.common.compares_vchamb(machine, r_out([1,3], :, :), 1:length(machine));
    r_out([1,3], :, :) = r_out_xy;
    r_init = squeeze(r_out(:, :, end));
    loss_ind = ~isnan(r_out(1, :, size(machine, 2)));
    r_init = r_init(:, loss_ind);
    eff = sirius_commis.common.calc_eff(n_part, r_init);
    fprintf('Turn number %i , Efficiency %f %% \n', turn_n, eff*100);

    if flag_bpm
        sigma_bpm0 = param_errors.sigma_bpm;
        bpm = findcells(machine, 'FamName', 'BPM');
        r_out_bpm = r_out_xy(:, :, bpm);
        [sigma_bpm, int_bpm] = sirius_commis.common.bpm_error_inten(r_out_bpm, n_part, sigma_bpm0);
        r_diag_bpm = squeeze(nanmean(r_out_bpm, 2)) + p * sigma_bpm;
        r_bpm = sirius_commis.common.compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);
    end

    r.r_end = r_init;
    r.r_track = r_out;
    r.efficiency = eff;
    r.r_bpm = r_bpm;
    r.sum_bpm = int_bpm;
end
