function [count_turns, r_bpm, int_bpm] = multiple_pulse_turn(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns)
% Simulation of booster injection and turns around the ring for multiple
% injection pulses
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of random machines
%  - n_part: number of particles
%  - param: cell of structs with adjusted injection parameters for each
%  machine
%  - n_pulse: number of pulses injected
%  - n_turns [optional] : limited number of turns before reach the
%  specified efficiency which considers the beam as lost. If n_turns is not
%  specified, it is set as 10000;
%
% OUTPUTS:
%  - count_turns: number of turns that the beam is considered lost (maximum
%  value is n_turns) for each pulse to the corresponding random machine
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

for i = 1:n_pulse
    fprintf('======================= \n');
    fprintf('Pulse number %i \n', i);
    fprintf('======================= \n');
    if i == 1
        [~, count_turns(i, :), r_bpm_turns(i, :, :), int_bpm_turns(i, :, :)] = sirius_commis.first_turns.bo.single_pulse_turn(machine, n_mach, param, param_errors, n_part, n_turns, n_turns);
    else
        [~, count_turns(i, :), r_bpm_turns(i, :, :), int_bpm_turns(i, :, :)] = sirius_commis.first_turns.bo.single_pulse_turn(machine, n_mach, param, param_errors, n_part, n_turns, count_turns(i-1, :));
    end
end

r_bpm = squeeze(mean(r_bpm_turns, 1));
int_bpm = squeeze(mean(int_bpm_turns, 1));
end
