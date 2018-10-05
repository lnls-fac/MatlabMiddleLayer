function count_turns = multiple_pulses_turns(machine, n_mach, param, n_part, n_pulse, n_turns)
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

initializations();

if ~exist('n_turns','var');
    n_turns = 1e5;
end
count_turns = zeros(n_pulse, n_mach);

for i = 1:n_pulse
    fprintf('======================= \n');
    fprintf('Pulse number %i \n', i);
    fprintf('======================= \n');
    [~, count_turns(i, :)] = booster_turns(machine, n_mach, param, n_part, n_turns);
end
end
