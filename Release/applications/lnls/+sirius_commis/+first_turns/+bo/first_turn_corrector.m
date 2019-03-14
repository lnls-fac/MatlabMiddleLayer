function ft_data = first_turn_corrector(machine, n_mach, param, param_errors, m_corr, n_part, n_pulse, n_sv, approach)
% Increases the intensity of BPMs and adjusts the first turn by changing the
% correctors based on BPMs measurements using two approaches: 'tl' for
% transport line and 'matrix' using matrix facilities of SOFB
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of machines to correct first turn
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: struct with injection parameters errors and
%  measurements errors
%  - m_corr: first turn trajectory corrector matrix with 2 * #BPMs rows
%  and #CH + #CV + 1 columns 
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_sv: number of singular values to use in correction
%  - approach: strings 'tl' or 'matrix'
%
% OUTPUTS:
%  - ft_data: first turn data struct with the following properties:
%  * first_cod: First COD solution obtained
%  * final_cod: Last COD solution when algorithm has converged
%  * machine: booster ring lattice with corrector kicks applied
%  * max_kick: vector with 0 and 1 where 1 means that the kick
%  reached the maximum value for the specific corrector
%  * n_svd: number of singular values when the algorithm converge
%  * ft_cod: data with kicks setting to obtain first COD solution, its
%  values and statistics

% Version 1 - Murilo B. Alves - October, 2018
% Version 2 - Murilo B. Alves - March, 2019

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
    fam = sirius_bo_family_data(machine);
elseif n_mach > 1
    machine_correct = machine;
    param_cell = param;
    fam = sirius_bo_family_data(machine{1});
end

bpm = fam.BPM.ATIndex;
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;

r_bpm_mach = zeros(n_mach, 2, length(bpm));
gr_mach_x = zeros(n_mach, length(ch));
gr_mach_y = zeros(n_mach, length(cv));
cod = ones(n_mach, 1);

for j = 1:n_mach
    %fprintf('=================================================\n');
    %fprintf('MACHINE NUMBER %i \n', j)
    %fprintf('=================================================\n');
    machine = machine_correct{j};
    param = param_cell{j};
    
    if flag_tl
        [machine_correct{j}, r_bpm_mach(j, :, :), gr_mach_x(j, :), gr_mach_y(j, :)] = sirius_commis.first_turns.bo.correct_orbit_bpm_tl(machine, param, param_errors, m_corr, n_part, n_pulse);
    else
        ft_data{j} = sirius_commis.first_turns.bo.correct_orbit_bpm_matrix(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv);
    end
    orbita = findorbit4(ft_data{j}.machine, 0, 1:length(ft_data{j}.machine));
    if any(isnan(orbita(1, :)))
        cod(j) = 0;
    end
    % save cod_nosext.mat cod
end