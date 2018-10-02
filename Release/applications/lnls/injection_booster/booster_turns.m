function eff_1turn = booster_turns(machine, n_mach, param, n_part, n_turns)
% initializations()
if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
end        

for j = 1:n_mach    
%     fprintf('=================================================\n');
%     fprintf('MACHINE NUMBER %i \n', j)
%     fprintf('=================================================\n');
%     
    machine = machine_cell{j};
    param = param_cell{j};
    lm = length(machine);

    if ~exist('n_turns', 'var')
        n_turns = 1e5;
    end

    kckr = 'on';
    [eff_1turn, ~, r_init, machine] = bo_pulses(machine, param, n_part, 1, lm, kckr, 'diag');
    
    if eff_1turn > 0.70
        return
    end

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

    fprintf('=================================================\n');   
    fprintf('TURNS \n');
    fprintf('=================================================\n');

    fprintf('Turn number 1 , Efficiency %f %% \n', eff_1turn*100);
    
    if eff_1turn < 0.30
        break
    end
    
    for i = 1:n_turns-1
        [r_init, ~, eff] = single_turn(machine, n_part, r_init, i+1, 'bpm', param);
        if eff < 0.30
            break
        end
    end
end
end

function [r_init, r_out, eff, r_bpm] = single_turn(machine, n_part, r_init, turn_n, bpm, param)
    if(exist('bpm','var'))
        if(strcmp(bpm,'bpm'))
            flag_bpm = true;
        end
    elseif(~exist('bpm','var'))
            flag_bpm = false;
    end

    if turn_n ~= 2
        r_out = linepass(machine, r_init, 1:length(machine), 'reuse');
    else
        r_out = linepass(machine, r_init, 1:length(machine));
    end
   
    r_out = reshape(r_out, 6, length(r_init(1,:)), length(machine));        
    r_out_xy = compares_vchamb(machine, r_out([1,3], :, :), 1:length(machine), false);
    r_out([1,3], :, :) = r_out_xy;
    r_init = squeeze(r_out(:, :, end));
    loss_ind = ~isnan(r_out(1, :, length(machine)));
    r_init = r_init(:, loss_ind);
    eff = calc_eff(n_part, r_init);
    fprintf('Turn number %i , Efficiency %f %% \n', turn_n, eff*100);
    
    if flag_bpm
        sigma_bpm0 = param.sigma_bpm;
        bpm = findcells(machine, 'FamName', 'BPM');
        r_out_bpm = r_out_xy(:, :, bpm);
        [sigma_bpm, int_bpm] = bpm_error_inten(r_out_bpm, n_part, sigma_bpm0);
        r_diag_bpm = squeeze(nanmean(r_out_bpm, 2)) + sigma_bpm;
        r_bpm = compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        % param.orbit = findorbit4(machine, 0, bpm);
        plot_bpms(machine, param.orbit, r_bpm, int_bpm);
    end
end
% 
% function initializations()
% 
%     fprintf('\n<initializations> [%s]\n\n', datestr(now));
% 
%     % seed for random number generator
%     seed = 131071;
%     % fprintf('-  initializing random number generator with seed = %i ...\n', seed);
%     RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));
% 
% end