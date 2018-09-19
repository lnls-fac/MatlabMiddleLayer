function param = adj_boost_times(bo_ring, n_part, n_pulse)

[param, machine, x_scrn3] = bo_injection_adjustment(bo_ring, n_part, n_pulse, 'yes');
res_scrn = param.sigma_scrn;
while abs(x_scrn3) > res_scrn
    fprintf('ADJUSTING ENERGY \n');
    [param, machine, x_scrn3] = bo_injection_adjustment(machine, n_part, n_pulse, 'no', param);
end

lm = length(machine);
kckr = 'on';
[eff3, ~, r_end, machine] = bo_pulses(machine, param, n_part, 1, lm, kckr, 'plot', 'diag');

fprintf('=================================================\n');
fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff3)*100, std(eff3)*100);
fprintf('=================================================\n');

turns = 10000;
booster_turns(machine, r_end, n_part, turns, mean(eff3));