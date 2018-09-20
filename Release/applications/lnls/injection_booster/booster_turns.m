function booster_turns(machine, param, n_part, n_turns)
initializations()

for j = 1:length(machine)
    
    machine = machine{j};
    param = param{j};    
    
    lm = length(machine);

    if ~exist('n_turns', 'var')
        n_turns = 1e5;
    end

    kckr = 'on';
    [eff_1turn, ~, r_init, machine] = bo_pulses(machine, param, n_part, 1, lm, kckr, 'plot', 'diag');

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

    fprintf('=================================================\n');   
    fprintf('TURNS \n');
    fprintf('=================================================\n');

    fprintf('Turn number 1 , Efficiency %f %% \n', eff_1turn*100);
    for i = 1:n_turns-1
        [r_init, ~, eff] = single_turn(machine, n_part, r_init, i+1, 'bpm', param.sigma_bpm);
        if eff < 0.25
            break
        end
    end
end
end

function [r_init, r_out, eff, r_bpm] = single_turn(machine, n_part, r_init, turn_n, bpm, sigma_bpm0)
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
        bpm = findcells(machine, 'FamName', 'BPM');
        r_out_bpm = r_out_xy(:, :, bpm);
        plot_booster_turn(machine, r_out_bpm, bpm, n_part, sigma_bpm0);
        sigma_bpm = bpm_error_inten(r_out_bpm, n_part, sigma_bpm0);
        r_diag_bpm = squeeze(nanmean(r_out_bpm, 2)) + sigma_bpm;
        r_bpm = compares_vchamb(machine, r_diag_bpm, bpm, true);        
    end
end

function initializations()

    fprintf('\n<initializations> [%s]\n\n', datestr(now));

    % seed for random number generator
    seed = 131071;
    % fprintf('-  initializing random number generator with seed = %i ...\n', seed);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

end
