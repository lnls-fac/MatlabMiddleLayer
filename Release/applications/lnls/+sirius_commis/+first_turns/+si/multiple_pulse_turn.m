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
%  specified efficiency which considers the beam as lost.
%
% OUTPUTS: r_out - struct with the fields:
%               - eff_1st_turn: first turn efficiency
%               - num_of_turns: number of turns
%               - r_bpm_mean: mean BPM meas. in turns
%               - sum_bpm_mean: mean BPM sum in turns
%               - r_bpm_tbt: turn-by-turn BPM position.
%               - sum_bpm_tbt: turn-by-turn BPM sum.
%               - eff_turns: efficiency for each turn

% sirius_commis.common.initializations();

    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
        param_err_cell = {param_errors};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
        param_err_cell = param_errors;
    end

    bpm = findcells(machine_cell{1}, 'FamName', 'BPM');
    nbpm = length(bpm);
    count_turns = zeros(n_pulse, n_mach);
    r_bpm_turns = zeros(n_pulse, 2, nbpm);
    int_bpm_turns = zeros(n_pulse, nbpm);
    eff_turns = zeros(n_pulse, n_mach, n_turns);
    r_bpm_tbt_pbp = zeros(n_pulse, n_turns, 2, nbpm);
    sum_bpm_tbt_pbp = zeros(n_pulse, n_turns, 1, nbpm);
    r_bpm_mean_turns = zeros(n_pulse, 2, nbpm);
    sum_bpm_mean_turns = zeros(n_pulse, 1, nbpm);
    r_out = cell(n_mach, 1); r = cell(n_mach, 1);

    for j = 1:n_mach
        
        fprintf('======================= \n');
        fprintf('MACHINE NUMBER %i \n', j);
        fprintf('======================= \n');
        
        machine = machine_cell{j};
        param = param_cell{j};
        param_errors = param_err_cell{j};

        for i = 1:n_pulse
            fprintf('======================= \n');
            fprintf('Pulse number %i \n', i);
            fprintf('======================= \n');

            if i == 1
                r{j} = sirius_commis.first_turns.si.single_pulse_turn(machine, param, param_errors, n_part, n_turns, n_turns);
                count_turns(i, j) = r{j}.num_of_turns;
                r_bpm_turns(i, :, :) = r{j}.r_bpm_mean;
                int_bpm_turns(i, :, :) = r{j}.sum_bpm_mean;
                r_bpm_tbt_pbp(1, :, :, :) = r{j}.r_bpm_tbt;
                sum_bpm_tbt_pbp(1, :, :, :) = r{j}.sum_bpm_tbt;
                eff_turns(i, j, :) = r{j}.eff_turns;
            else
                r{j} = sirius_commis.first_turns.si.single_pulse_turn(machine, param, param_errors, n_part, n_turns, count_turns(i-1, :));
                count_turns(i, j) = r{j}.num_of_turns;
                r_bpm_mean_turns(i, :, :) = r{j}.r_bpm_mean;
                sum_bpm_mean_turns(i, :, :) = r{j}.sum_bpm_mean;
                r_bpm_tbt_pbp(i, :, :, :) = r{j}.r_bpm_tbt;
                sum_bpm_tbt_pbp(i, :, :, :) = r{j}.sum_bpm_tbt;
                eff_turns(i, j, :) = r{j}.eff_turns;
            end
        end

        r_bpm = squeeze(mean(r_bpm_mean_turns, 1));
        int_bpm = squeeze(mean(sum_bpm_mean_turns, 1));
        r_bpm_mean_pulse = squeeze(mean(r_bpm_tbt_pbp, 1));
        int_bpm_mean_pulse = squeeze(mean(sum_bpm_tbt_pbp, 1));

        r_out{j}.num_of_turns = count_turns;
        r_out{j}.r_bpm_tbt_pbp_mean = r_bpm;
        r_out{j}.sum_bpm_tbt_pbp_mean = int_bpm;
        r_out{j}.r_bpm_pulse_mean = r_bpm_mean_pulse;
        r_out{j}.sum_bpm_pulse_mean = int_bpm_mean_pulse;
        r_out{j}.r_bpm_tbt_pbp = r_bpm_tbt_pbp;
        r_out{j}.sum_bpm_tbt_pbp = sum_bpm_tbt_pbp;
    end
end
