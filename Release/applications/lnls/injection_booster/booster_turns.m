function booster_turns(machine, r_init, n_part, turns, eff_1turn)
injkckr = findcells(machine, 'FamName', 'InjKckr');
machine = lnls_set_kickangle(machine, 0, injkckr, 'x');

fprintf('=================================================\n');   
fprintf('TURNS \n');
fprintf('=================================================\n');

fprintf('Turn number 1 , Efficiency %f %% \n', eff_1turn*100);

[r_init, ~, ~] = single_turn(machine, n_part, r_init, 2);

for i = 1:turns
    [r_init, ~, eff] = single_turn(machine, n_part, r_init, i+2);
    if eff < 0.25
        [~, r_out, ~] = single_turn(machine, n_part, r_init, i+2);
        plot_booster_turn(machine, r_out([1,3], :, :), 1:length(machine));
        break
    end
end
end

function [r_init, r_out, eff] = single_turn(machine, n_part, r_init, turn_n)
    if turn_n ~= 2
        r_out = linepass(machine, r_init, 1:length(machine), 'reuse');
    else
        r_out = linepass(machine, r_init, 1:length(machine));
    end
   
    r_out = reshape(r_out, 6, length(r_init(1,:)), length(machine));        
    r_out_xy = compares_vchamb(machine, r_out([1,3], :, :), 1:length(machine));
    r_out([1,3], :, :) = r_out_xy;
    r_init = squeeze(r_out(:, :, end));
    
    loss_ind = ~isnan(r_out(1, :, length(machine)));
    r_init = r_init(:, loss_ind);
    
    n_perdida = n_part - length(r_init(1,:));
    eff = (1 - n_perdida / n_part);
    fprintf('Turn number %i , Efficiency %f %% \n', turn_n, eff*100);
end

