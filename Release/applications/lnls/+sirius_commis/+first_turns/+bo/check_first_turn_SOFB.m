function ft_data = check_first_turn_SOFB(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns, n_pulse_turns, n0, n_sv)
% Increases the intensity of BPMs and adjusts the first turn by changing the
% correctors based on BPMs measurements
%
% INPUTS:
%  - machine: storage ring model with errors
%  - n_mach: number of machines
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: errors of injection parameters
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_turns: number of turns to check after first turn correction
%  - n0: number of turns for each injection pulse without first turn correction
%  - M_acc: transfer matrix from the origin (InjSept) to all the elements
%  of machine ([~, MS] = findm44())
%
% OUTPUTS:
%  - machine_correct: storage ring model with corrector setup adjusted for 1st turn
%  - first_turns_mach: 1 if it was possible to correct first turn with
%  given number of pulses 
%  - first_turns_mach_refined: 1 if it was needed to increase the pulses
% 10 times to calculate the correction 
%  - gr_mach: 1 indicates that the corresponding machine demanded a kick in
%  correctors greater than the limit
%
% Version 1 - Murilo B. Alves - December, 2018

sirius_commis.common.initializations();

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
    param_errors_cell = {param_errors};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
    param_errors_cell = param_errors;
end

% machine_correct = cell(n_mach, 1);
ft_mach = zeros(n_mach, 1);
ft_mach_refined = zeros(n_mach, 1);
count_turns = zeros(n_pulse_turns, n_mach);
% gr_mach = cell(n_mach, 2);
machine_correct = cell(n_mach, 1);
% param_errors.sigma_bpm = 2e-3;

fam = sirius_bo_family_data(machine_cell{1});
ft_data = cell(n_mach, 1);

% [~, ~, m_corr] = sirius_commis.common.trajectory_matrix(fam, M_acc);

for j = 1:n_mach
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    
    machine = machine_cell{j};
    param = param_cell{j};
    param_errors = param_errors_cell{j};
    
    machine = setcavity('off', machine);
    machine = setradiation('on', machine);
    
    n_min = min(n0(:, j));
    
    if n_min < n_turns
        % [machine_correct{j}, ~, gr_mach{j, 1}, gr_mach{j, 2}] = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, n_pulse);
        ft_data1 = sirius_commis.first_turns.bo.first_turn_corrector_SOFB(machine, 1, param, param_errors, n_part, n_pulse, n_sv);
        ft_data1 = ft_data1{1, 1};
        machine_correct1 = ft_data1.machine;
        ft_mach(j) = 1;
        count_turns1 = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct1, 1, param, param_errors, n_part, n_pulse_turns, n_turns);
        
        if min(count_turns1) < n_turns
            % ft_data2 = sirius_commis.first_turns.bo.first_turn_corrector_SOFB(machine_correct1, 1, param, param_errors, n_part, 3*n_pulse, ft_data1.n_svd);
            % machine_correct{j} = sirius_commis.first_turns.si.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, 10*n_pulse);
            ft_data2 = ft_data1;
            machine_correct2 = ft_data2.machine;
            ft_mach_refined(j) = 1;
            % count_turns2 = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct2, 1, param, param_errors, n_part, n_pulse_turns, n_turns);
            count_turns2 = count_turns1;
            if min(count_turns1) > min(count_turns2)
                ft_data{j} = ft_data1;
                machine_correct{j} = machine_correct1;
                count_turns(:, j) = count_turns1;
            else
                ft_data{j} = ft_data2;
                machine_correct{j} = machine_correct2;
                count_turns(:, j) = count_turns2;
            end
        else
            ft_data{j} = ft_data1;
            machine_correct{j} = machine_correct1;
            count_turns(:, j) = count_turns1;
        end
    else
        machine_correct{j} = machine;        
    end
   
    ft_data{j}.ft_ok = ft_mach;
    ft_data{j}.ft_ok_ref = ft_mach_refined;
    ft_data{j}.n_turns = count_turns(:, j);
    kickx_final = lnls_get_kickangle(ft_data{j}.machine, fam.CH.ATIndex, 'x'); 
    kicky_final = lnls_get_kickangle(ft_data{j}.machine, fam.CV.ATIndex, 'y');
    ft_data{j}.finalcod.kickx = kickx_final;
    ft_data{j}.finalcod.kicky = kicky_final;
    orbit_final = findorbit4(ft_data{j}.machine, 0, 1:length(ft_data{j}.machine));
    ft_data{j}.finalcod.orbit = orbit_final;
    rms_x = std(orbit_final(1, :));     rms_y = std(orbit_final(3, :));
    ft_data{j}.finalcod.rms_x = rms_x;  ft_data{j}.finalcod.rms_y = rms_y;
    
    save first_turns_SOFB.mat ft_data
end
