function [machine_correct, first_turn_mach, first_turn_mach_refined, count_turns, gr_mach] = check_first_turn(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns, n0, M_acc)
% Increases the intensity of BPMs and adjusts the first turn by changing the
% correctors based on BPMs measurements
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of machines
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: errors of injection parameters
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_turns: number of turns to check after first turn correction
%  - n0: number of turns for each injection pulse without first turn correction
%  - MS_acc: transfer matrix from the origin (InjSept) to all the elements
%  of machine ([~, MS] = findm44())
%
% OUTPUTS:
%  - machine_correct: booster ring model with corrector setup adjusted for 1st turn
%  - first_turns_mach: 1 if it was possible to correct first turn with
%  given number of pulses 
%  - first_turns_mach_refined: 1 if it was needed to increase the pulses
% 10 times to calculate the correction 
%  - gr_mach: 1 indicates that the corresponding machine demanded a kick in
%  correctors greater than the limit
%
% Version 1 - Murilo B. Alves - October, 2018

sirius_commis.common.initializations();

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end

% machine_correct = cell(n_mach, 1);
first_turn_mach = zeros(n_mach, 1);
first_turn_mach_refined = zeros(n_mach, 1);
count_turns = ones(n_pulse, n_mach) * n_turns;
gr_mach = cell(n_mach, 2);
machine_correct = cell(n_mach, 1);
param_errors.sigma_bpm = 2e-3;

for j = 1:n_mach    
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    
    machine = machine_cell{j};
    param = param_cell{j};
    
    n_min = min(n0(:, j));
    
    if n_min < n_turns
        % [machine_correct{j}, ~, gr_mach{j, 1}, gr_mach{j, 2}] = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, n_pulse);
        machine_correct{j} = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, n_pulse);
        machine_correct{j} = machine_correct{j}{1};
        first_turn_mach(j) = 1;
        [count_turns(:, j), r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct{j}, 1, param, param_errors, n_part, n_pulse, n_turns);
        
        if min(count_turns(:, j)) < n_turns
            % [machine_correct{j}, ~, gr_mach{j, 1}, gr_mach{j, 2}] = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, 10*n_pulse, r_bpm, int_bpm);
            machine_correct{j} = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, 10*n_pulse, r_bpm, int_bpm);
            machine_correct{j} = machine_correct{j}{1};
            first_turn_mach_refined(j) = 1;
            count_turns(:, j) = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct{j}, 1, param, param_errors, n_part, n_pulse, n_turns);
        end
    end
end
end

