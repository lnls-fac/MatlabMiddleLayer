function [machine_cell, r_bpm_mach, gr_mach_x, gr_mach_y] = first_turn_corrector(machine, n_mach, param, param_errors, M_acc, n_part, n_pulse, r_bpm, int_bpm, method)

% sirius_commis.common.initializations()

if(exist('method','var'))
    if(strcmp(method,'tl'))
        flag_tl = true;
    elseif(strcmp(method,'matrix'))
        flag_tl = false;
    end            
else
    flag_tl = false;
end

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
    fam = sirius_bo_family_data(machine);
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
    fam = sirius_bo_family_data(machine{1});
end

bpm = fam.BPM.ATIndex;
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;

if ~exist('r_bpm', 'var') && ~exist('int_bpm', 'var')
    no_bpm = true;
else
    no_bpm = false;
end
% rms_orbit_bpm = zeros(n_mach, 2);
% max_orbit_bpm = zeros(n_mach, 2);
r_bpm_mach = zeros(n_mach, 2, length(bpm));
gr_mach_x = zeros(n_mach, length(ch));
gr_mach_y = zeros(n_mach, length(cv));

for j = 1:n_mach
    % fprintf('=================================================\n');
    % fprintf('MACHINE NUMBER %i \n', j)
    % fprintf('=================================================\n');
    machine = machine_cell{j};
    param = param_cell{j};
    
    if flag_tl
        [machine_cell{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.bo.correct_orbit_bpm_tl(machine, param, param_errors, M_acc, n_part, n_pulse);
    else
        if no_bpm
            [machine_cell{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.bo.correct_orbit_bpm_matrix(machine, param, param_errors, M_acc, n_part, n_pulse);
        else
            [machine_cell{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.bo.correct_orbit_bpm_matrix(machine, param, param_errors, M_acc, n_part, n_pulse, r_bpm, int_bpm);
        end
    end
end
end