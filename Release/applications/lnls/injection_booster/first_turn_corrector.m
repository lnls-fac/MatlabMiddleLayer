function machine_cell = first_turn_corrector(machine, n_mach, param, M_acc, n_part, n_pulse)
initializations()
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
    
    machine_cell{j} = correct_orbit_bpm(M_acc, machine, param, n_part, n_pulse);

end
end
function initializations()

    fprintf('\n<initializations> [%s]\n\n', datestr(now));

    % seed for random number generator
    seed = 131071;
    % fprintf('-  initializing random number generator with seed = %i ...\n', seed);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

end