function param = adj_boost_times(bo_ring, n_part, n_pulse, param0)
param0 = add_errors_machine(param0);
tic
for j = 1:length(bo_ring)
    tic;
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');
    
    [param{j}, machine{j}, x_scrn3] = bo_injection_adjustment(bo_ring{j}, n_part, n_pulse, 'no', param0);
    res_scrn = param{j}.sigma_scrn;
    while abs(x_scrn3) > res_scrn
        fprintf('ADJUSTING ENERGY \n');
        [param{j}, ~, x_scrn3] = bo_injection_adjustment(machine{j}, n_part, n_pulse, 'no', param{j});
    end
    toc;
end
toc
end
