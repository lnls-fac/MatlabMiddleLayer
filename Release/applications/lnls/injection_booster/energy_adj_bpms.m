function delta_bpm = energy_adj_bpms(machine, n_mach, param, n_part, n_pulse, n_turns, etax_bpms)
    
if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end        

for i = 1:n_mach
    machine = machine_cell{i};
    param = param_cell{i};

    booster_turns(machine, 1, param, n_part, n_turns)
    kckr = 'on';
    [~, ~, ~, ~, r_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');
    delta_bpm = nanmean(r_bpm(1, :)) / etax_bpms;

    param.delta_ave = param.delta_ave * (1 + delta_bpm) + delta_bpm;
    fprintf('=================================================\n');
    fprintf('ADJUSTING ENERGY WITH BPMS \n')
    fprintf('=================================================\n');
    booster_turns(machine, 1, param, n_part, n_turns)
end
end

