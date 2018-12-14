function [machine_correct, first_turn_mach, first_turn_mach_refined, count_turns, gr_mach, n_t] = check_first_turn(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns, n_pulse_turns, n0, n_sv, M_acc)
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
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end

% machine_correct = cell(n_mach, 1);
first_turn_mach = zeros(n_mach, 1);
first_turn_mach_refined = zeros(n_mach, 1);
count_turns = zeros(n_pulse_turns, n_mach);
gr_mach = cell(n_mach, 2);
machine_correct = cell(n_mach, 1);
param_errors.sigma_bpm = 2e-3;

fam = sirius_si_family_data(machine_cell{1});
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
m_corr_x = zeros(length(bpm), length(ch));
m_corr_y = zeros(length(bpm), length(cv));


M_bpms_x = M_acc(1:2, 1:2, bpm);
M_bpms_y = M_acc(3:4, 3:4, bpm);

for j = 1:length(ch)
    ind_bpms_ch = bpm > ch(j);
    first = find(ind_bpms_ch);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_ch = M_acc(1:2, 1:2, ch(j));
        for i=1:length(trecho)
            M_x = M_bpms_x(:, :, trecho(i)) / M_ch; 
            m_corr_x(trecho(i), j) = squeeze(M_x(1, 2, :));
        end
    end
end

for j = 1:length(cv)
    ind_bpms_cv = bpm > cv(j);
    first = find(ind_bpms_cv);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_cv = M_acc(3:4, 3:4, cv(j));
        for i=1:length(trecho)
            M_y = M_bpms_y(:, :, trecho(i)) / M_cv; 
            m_corr_y(trecho(i), j) = squeeze(M_y(1, 2, :));
        end
    end
end

m0xy = zeros(size(bpm, 1), size(cv, 1));
m0yx = zeros(size(bpm, 1), size(ch, 1));
n_t = zeros(n_mach, 1);
m_corr = [m_corr_x, m0xy; m0yx, m_corr_y];

for j = 1:n_mach    
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    
    machine = machine_cell{j};
    param = param_cell{j};
    
    machine = setcavity('off', machine);
    machine = setradiation('on', machine);
    
    n_min = min(n0(:, j));
    
    if n_min < n_turns
        % [machine_correct{j}, ~, gr_mach{j, 1}, gr_mach{j, 2}] = sirius_commis.first_turns.bo.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, n_pulse);
        [machine_correct{j}, ~, ~, ~, ~, n_t(j)] = sirius_commis.first_turns.si.first_turn_corrector(machine, 1, param, param_errors, m_corr, n_part, n_pulse, n_sv);
        machine_correct1 = machine_correct{j}{1};
        first_turn_mach(j) = 1;
        count_turns1 = sirius_commis.first_turns.si.multiple_pulse_turn(machine_correct1, 1, param, param_errors, n_part, n_pulse_turns, n_turns);
        
        if min(count_turns1) < n_turns
            [machine_correct{j}, ~, ~, ~, ~, n_t(j)] = sirius_commis.first_turns.si.first_turn_corrector(machine_correct1, 1, param, param_errors, m_corr, n_part, 5*n_pulse, n_t(j));
            % machine_correct{j} = sirius_commis.first_turns.si.first_turn_corrector(machine, 1, param, param_errors, M_acc, n_part, 10*n_pulse);
            machine_correct2 = machine_correct{j}{1};
            first_turn_mach_refined(j) = 1;
            count_turns2 = sirius_commis.first_turns.si.multiple_pulse_turn(machine_correct2, 1, param, param_errors, n_part, n_pulse_turns, n_turns);
            if min(count_turns1) > min(count_turns2)
                machine_correct{j} = machine_correct1;
                count_turns(:, j) = count_turns1;
            else
                machine_correct{j} = machine_correct2;
                count_turns(:, j) = count_turns2;
            end
        else
            machine_correct{j} = machine_correct1;
            count_turns(:, j) = count_turns1;
        end
    else
        machine_correct{j} = machine;        
    end
    
    save first_turns.mat machine_correct first_turn_mach first_turn_mach_refined count_turns gr_mach n_t
end

