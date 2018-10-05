function [machine_cell, theta_x, theta_y, rms_orbit_bpm, max_orbit_bpm] = first_turn_corrector(machine, n_mach, param, M_acc, n_part, n_pulse, method)


if(exist('method','var'))
    if(strcmp(method,'tl'))
        flag_tl = true;
    elseif(strcmp(method,'matrix'))
        flag_tl = false;
    end            
else
    flag_tl = false;
end

initializations()
if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end        

rms_orbit_bpm = zeros(n_mach, 2);
max_orbit_bpm = zeros(n_mach, 2);
theta_x = cell(n_mach, 1);
theta_y = cell(n_mach, 1);

for j = 1:n_mach
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    machine = machine_cell{j};
    param = param_cell{j};
    
    if flag_tl
        [machine_cell{j}, theta_x{j}, theta_y{j}, rms_orbit_bpm(j, :), max_orbit_bpm(j, :)] = correct_orbit_bpm_tl(machine, param, M_acc, n_part, n_pulse);
    else
        [machine_cell{j}, theta_x{j}, theta_y{j}, rms_orbit_bpm(j, :), max_orbit_bpm(j, :)] = correct_orbit_bpm_matrix(machine, param, M_acc, n_part, n_pulse);
        % [machine_cell{j}, theta_x{j}, theta_y{j}, rms_orbit_bpm(j, :), max_orbit_bpm(j, :)] = correct_orbit_bpm_respm(machine, param, M_acc, n_part, n_pulse);
    end
end
end