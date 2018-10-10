function check_first_turn(machine, n_mach, param, n_part, n_pulse, n_turns)

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end

for j = 1:n_mach    
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    
    machine = machine_cell{j};
    param = param_cell{j};
    
end
end

