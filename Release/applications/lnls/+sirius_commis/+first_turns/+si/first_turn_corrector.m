function [machine_correct, r_bpm_mach, gr_mach_x, gr_mach_y] = first_turn_corrector(machine, n_mach, param, param_errors, M_acc, n_part, n_pulse, approach)
% Increases the intensity of BPMs and adjusts the first turn by changing the
% correctors based on BPMs measurements using two approaches: 'tl' for
% transport line and 'matrix' using matrix facilities of SOFB
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of machines
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: errors of injection parameters
%  - M_acc: transfer matrix from the origin (InjSept) to all the elements
%  of machine ([~, MS] = findm44())
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - approach: 'tl' or 'matrix'
%
% OUTPUTS:
%  - machine_correct: booster ring model with corrector setup adjusted for 1st turn
%  - r_bpm_mach: BPM position for the first turn for each random machine
%  - gr_mach_x and gr_mach_y: 1 indicates that the corresponding machine demanded a kick in
%  correctors greater than the limit in horizontal and vertical plane
%
% Version 1 - Murilo B. Alves - October, 2018

% sirius_commis.common.initializations()

if(exist('method','var'))
    if(strcmp(approach,'tl'))
        flag_tl = true;
    elseif(strcmp(approach,'matrix'))
        flag_tl = false;
    end            
else
    flag_tl = false;
end

if n_mach == 1
    machine_correct = {machine};
    param_cell = {param};
    fam = sirius_si_family_data(machine);
elseif n_mach > 1
    machine_correct = machine;
    param_cell = param;
    fam = sirius_si_family_data(machine{1});
end

bpm = fam.BPM.ATIndex;
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;

r_bpm_mach = zeros(n_mach, 2, length(bpm));
gr_mach_x = zeros(n_mach, length(ch));
gr_mach_y = zeros(n_mach, length(cv));

for j = 1:n_mach
    % fprintf('=================================================\n');
    % fprintf('MACHINE NUMBER %i \n', j)
    % fprintf('=================================================\n');
    machine = machine_correct{j};
    param = param_cell{j};
    
    if flag_tl
        [machine_correct{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.si.correct_orbit_bpm_tl(machine, param, param_errors, M_acc, n_part, n_pulse);
    else
        [machine_correct{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.si.correct_orbit_bpm_matrix(machine, param, param_errors, M_acc, n_part, n_pulse, r_bpm, int_bpm);
    end
end
end