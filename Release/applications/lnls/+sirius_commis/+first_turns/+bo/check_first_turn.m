function [machine_correct, first_turn_mach, first_turn_mach_refined, count_turns, gr_mach] = check_first_turn(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns, n0, M_acc)

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

for j = 1:n_mach    
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    
    machine = machine_cell{j};
    param = param_cell{j};
    
    n_min = min(n0(:, j));
    
    if n_min < n_turns
        [machine_correct{j}, ~, gr_mach{j, 1}, gr_mach{j, 2}] = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, n_pulse);
        machine_correct{j} = machine_correct{j}{1};
        first_turn_mach(j) = 1;
        [count_turns(:, j), r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct{j}, 1, param, param_errors, n_part, n_pulse, n_turns);
        
        if min(count_turns(:, j)) < n_turns
            [machine_correct{j}, ~, gr_mach{j, 1}, gr_mach{j, 2}] = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, 10*n_pulse, r_bpm, int_bpm);
            machine_correct{j} = machine_correct{j}{1};
            first_turn_mach_refined(j) = 1;
            count_turns(:, j) = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct{j}, 1, param, param_errors, n_part, n_pulse, n_turns);
        end
    end
end
end

