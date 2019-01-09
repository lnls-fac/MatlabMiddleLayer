function [machine_correct, cod, r_bpm_mach, gr_mach_x, gr_mach_y, n_t] = first_turn_corrector(machine, n_mach, param, param_errors, m_corr, n_part, n_pulse, n_sv, approach)
% Increases the intensity of BPMs and adjusts the first turn by changing the
% correctors based on BPMs measurements using two approaches: 'tl' for
% transport line and 'matrix' using matrix facilities of SOFB
%
% INPUTS:
%  - machine: storage ring model with errors
%  - n_mach: number of machines
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: errors of injection parameters
%  - m_corr: first turn trajectory corrector matrix calculate from transfer
%  matrix as a response matrix
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_sv: initial number of singular values
%  - approach: 'tl' or 'matrix'
%
% OUTPUTS:
%  - machine_correct: booster ring model with corrector setup adjusted for 1st turn
%  - cod: 1 if code obtains closed orbit and 0 if does not
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
n_t = zeros(n_mach, 1);
cod = ones(n_mach, 1);

for j = 1:n_mach
    %fprintf('=================================================\n');
    %fprintf('MACHINE NUMBER %i \n', j)
    %fprintf('=================================================\n');
    machine = machine_correct{j};
    param = param_cell{j};
    
    if flag_tl
        [machine_correct{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.si.correct_orbit_bpm_tl(machine, param, param_errors, m_corr, n_part, n_pulse);
    else
        [machine_correct{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :), n_t(j)] = sirius_commis.first_turns.si.correct_orbit_bpm_matrix(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv);
    end
    orbita = findorbit4(machine_correct{j}, 0, 1:length(machine_correct{j}));
    if any(isnan(orbita(1, :)))
        cod(j) = 0;
    end
    % save cod_nosext.mat cod
end