function r_out = multiple_pulse_turn(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns)
% Simulation of booster injection and turns around the ring for multiple
% injection pulses
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of random machines
%  - param: cell of structs with adjusted injection parameters for each
%  machine
%  - param_errors: errors in the injection parameters
%  - n_part: number of particles
%  - n_pulse: number of pulses injected
%  - n_turns [optional] : limited number of turns before reach the
%  specified efficiency which considers the beam as lost. If n_turns is not
%  specified, it is set as 10000;
%
% OUTPUTS:
%  - count_turns: number of turns that the beam is considered lost (maximum
%  value is n_turns) for each pulse to the corresponding random machine
%  - r_bpm: average position of each BPM in turns
%  - int_bpm: average intensity of each BPM in turns
%  - eff_mean: average effiency of turns for each injection pulse
%
% Version 1 - Murilo B. Alves - October 4th, 2018

% sirius_commis.common.initializations();

    if ~exist('n_turns','var')
        n_turns = 1e5;
    end

    if n_mach > 1
        bpm = findcells(machine{1}, 'FamName', 'BPM');
    else
        bpm = findcells(machine, 'FamName', 'BPM');
    end

    count_turns = zeros(n_pulse, n_mach);
    r_bpm_turns = zeros(n_pulse, 2, length(bpm));
    int_bpm_turns = zeros(n_pulse, length(bpm));
    eff_turns = zeros(n_pulse, n_mach, n_turns);
    RBPM = zeros(n_pulse, n_turns, 2, length(bpm));
    INTBPM = zeros(n_pulse, n_turns, 1, length(bpm));

    for i = 1:n_pulse
        fprintf('======================= \n');
        fprintf('Pulse number %i \n', i);
        fprintf('======================= \n');

        if i == 1
            r = sirius_commis.first_turns.bo.single_pulse_turn(machine, n_mach, param, param_errors, n_part, n_turns, n_turns);
            count_turns(i, :) = r.num_of_turns;
            r_bpm_turns(i, :, :) = r.r_bpm_mean;
            int_bpm_turns(i, :, :) = r.sum_bpm_mean;
            RBPM(1, :, :, :) = r.r_bpm_tbt;
            INTBPM(1, :, :, :) = r.sum_bpm_tbt;
            eff_turns(i, :, :) = r.eff_turns;
        else
            r = sirius_commis.first_turns.bo.single_pulse_turn(machine, n_mach, param, param_errors, n_part, n_turns, count_turns(i-1, :));
            count_turns(i, :) = r.num_of_turns;
            r_bpm_mean_turns(i, :, :) = r.r_bpm_mean;
            int_bpm_mean_turns(i, :, :) = r.sum_bpm_mean;
            r_bpm_tbt_pbp(i, :, :, :) = r.r_bpm_tbt;
            int_bpm_tbt_pbp(i, :, :, :) = r.sum_bpm_tbt;
            eff_turns(i, :, :) = r.eff_turns;
        end

        % a = sum(eff_turns, 3) ./ count_turns(i, :);
    end

    r_bpm = squeeze(mean(r_bpm_mean_turns, 1));
    int_bpm = squeeze(mean(int_bpm_mean_turns, 1));
    r_bpm_mean_pulse = squeeze(mean(r_bpm_tbt_pbp, 1));
    int_bpm_mean_pulse = squeeze(mean(int_bpm_tbt_pbp, 1));

    r_out.num_of_turns = count_turns;
    r_out.r_bpm_tbt_pbp_mean = r_bpm;
    r_out.sum_bpm_tbt_pbp_mean = int_bpm;
    r_out.efficiency_1st_turn = eff_ft;
    r_out.r_bpm_pulse_mean = r_bpm_mean_pulse;
    r_out.sum_bpm_pulse_mean = int_bpm_mean_pulse;
    r_out.r_bpm_tbt_pbp = r_bpm_tbt_pbp;
    r_out.sum_bpm_tbt_pbp = int_bpm_tbt_pbp;
end
