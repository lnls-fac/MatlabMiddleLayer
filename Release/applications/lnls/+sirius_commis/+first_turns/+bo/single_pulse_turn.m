function [eff_1turn, count_turns, r_bpm_turns, int_bpm_turns, r_init, RBPM, INTBPM, eff_turns] = single_pulse_turn(machine, n_mach, param, param_errors, n_part, n_turns, c_prev)
% Simulation of booster injection and turns around the ring for a single
% pulse (for multiple pulses, see the function multiple_pulses_turns())
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of random machines
%  - n_part: number of particles
%  - param: cell of structs with adjusted injection parameters for each
%  machine
%  - n_turns [optional] : limited number of turns before reach the
%  specified efficiency which considers the beam as lost. If n_turns is not
%  specified, it is set as 10000;
%
% OUTPUTS:
%  - eff_1turn: efficiency of first turn
%  - count_turns: number of turns that the beam is considered lost (maximum
%  value is n_turns)
%
% Version 1 - Murilo B. Alves - October 4th, 2018

% sirius_commis.common.initializations()
if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
    param_err_cell = {param_errors};
    bpm = findcells(machine, 'FamName', 'BPM');
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
    param_err_cell = param_errors;
    bpm = findcells(machine{1}, 'FamName', 'BPM');
end

RBPM = zeros(n_turns, 2, length(bpm));
INTBPM = zeros(n_turns, 1, length(bpm));

eff_1turn = zeros(1, n_mach);
count_turns = zeros(n_mach, 1);
eff_turns = zeros(n_mach, n_turns);
r_init = zeros(n_mach, n_turns, 6, n_part);
eff_lim = 0.10;
for j = 1:n_mach
    %fprintf('=================================================\n');
    %fprintf('MACHINE NUMBER %i \n', j)
    %fprintf('=================================================\n');

    param_cell{j}.orbit = findorbit4(machine_cell{j}, 0, 1:length(machine_cell{j}));
    
    machine = machine_cell{j};
    param = param_cell{j};
    param_errors = param_err_cell{j};
    lm = length(machine);


    if ~exist('n_turns', 'var')
        n_turns = 1e5;
    end

    kckr = 'on';
    [eff_1turn(j), ~, r_init, ~, RBPM(1, :, :), INTBPM(1, :, :)] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, 1, lm, kckr, 'diag');

    %if eff_1turn > 0.95
    %   continue
    %end

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

    fprintf('=================================================\n');
    fprintf('TURNS \n');
    fprintf('=================================================\n');

    fprintf('Turn number 1 , Efficiency %f %% \n', eff_1turn(j)*100);
    eff_turns(j, 1) = eff_1turn(j);

    if eff_1turn(j) < eff_lim
       r_bpm_turns = squeeze(RBPM(1, :, :));
       int_bpm_turns = squeeze(INTBPM(1, :, :));
       continue
    end
    count_turns(j) = count_turns(j) + 1;
    for i = 1:n_turns-1
        [r_init, ~, eff_turns(j, i+1), RBPM(i+1, :, :), INTBPM(i+1, :, :)] = single_turn(machine, n_part, r_init, i+1, 'bpm', param, param_errors);
        if eff_turns(j, i+1) < eff_lim
            % RBPM(i+1, :, :) = zeros(2, 50);
            % INTBPM(i+1, :, :) = zeros(1, 50);
            % eff_turns(j, i+1) = 0;
            break
        end
        count_turns(j) = count_turns(j) + 1;
        if count_turns(j) > c_prev
            break
        end
    end
    r_bpm_turns = squeeze(sum(RBPM, 1) / count_turns(j));
    int_bpm_turns = squeeze(sum(INTBPM, 1) / count_turns(j));
end
end

function [r_init, r_out, eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init, turn_n, bpm, param, param_errors)
    r_init = squeeze(r_init);
    if(exist('bpm','var'))
        if(strcmp(bpm,'bpm'))
            flag_bpm = true;
        end
    elseif(~exist('bpm','var'))
            flag_bpm = false;
    end
    
    p = 0;
    
    % !! IMPORTANT !!
    % +1 added because linepass does the tracking until the beginning of
    % element and it is needed until the end to perform one turn
    
    if turn_n ~= 2
        r_out = linepass(machine, r_init, 1:length(machine)+1, 'reuse');
    else
        r_out = linepass(machine, r_init, 1:length(machine)+1);
    end

    r_out = reshape(r_out, 6, size(r_init, 2), size(machine, 2)+1);
    r_out_xy = sirius_commis.common.compares_vchamb(machine, r_out([1,3], :, :), 1:length(machine));
    r_out([1,3], :, :) = r_out_xy;
    r_init = squeeze(r_out(:, :, end));
    loss_ind = ~isnan(r_out(1, :, size(machine, 2)));
    r_init = r_init(:, loss_ind);
    eff = sirius_commis.common.calc_eff(n_part, r_init);
    fprintf('Turn number %i , Efficiency %f %% \n', turn_n, eff*100);

    if flag_bpm
        sigma_bpm0 = param_errors.sigma_bpm;
        bpm = findcells(machine, 'FamName', 'BPM');
        r_out_bpm = r_out_xy(:, :, bpm);
        [sigma_bpm, int_bpm] = sirius_commis.common.bpm_error_inten(r_out_bpm, n_part, sigma_bpm0);
        r_diag_bpm = squeeze(nanmean(r_out_bpm, 2)) + p * sigma_bpm;
        r_bpm = sirius_commis.common.compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);
    end
end
