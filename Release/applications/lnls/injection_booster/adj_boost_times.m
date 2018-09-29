function param = adj_boost_times(bo_ring, n_mach, n_part, n_pulse, param0)

param0 = add_errors_injection(param0);

if n_mach == 1
    [param, ~, x_scrn3] = bo_injection_adjustment(bo_ring, n_part, n_pulse, 'no', param0);
    res_scrn = param.sigma_scrn;
    while abs(x_scrn3) > res_scrn
        fprintf('ADJUSTING ENERGY \n');
        [param, ~, x_scrn3] = bo_injection_adjustment(bo_ring, n_part, n_pulse, 'no', param);
    end
    return
else
    for j = 1:n_mach
    tic;
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    [param{j}, ~, x_scrn3] = bo_injection_adjustment(bo_ring{j}, n_part, n_pulse, 'no', param0);
    res_scrn = param{j}.sigma_scrn;
    while abs(x_scrn3) > res_scrn
        fprintf('ADJUSTING ENERGY \n');
        [param{j}, ~, x_scrn3] = bo_injection_adjustment(bo_ring{j}, n_part, n_pulse, 'no', param{j});
    end
    param{j}.orbit = param0.orbit{j};
    toc;
    end
end
end
