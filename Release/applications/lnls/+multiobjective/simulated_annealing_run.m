function config = simulated_annealing_run(opt)
    setappdata(0, 'stop_now', 0);
    config = opt.config0(:,1);
    res = opt.objective_fun(config, opt.objective_data) .* opt.simulanneal_weight;
    res = rms(res);
    fprintf('%s : %7.4f\n', 'ini', res);
    
    for i=1:opt.simulanneal_Niter
        config_t = opt.small_change(config, opt.objective_data);
        res_t = opt.objective_fun(config_t, opt.objective_data) .* opt.simulanneal_weight;
        res_t = rms(res_t);
        if res_t < res
            res = res_t;
            config = config_t;
            fprintf('%03d : %7.4f\n', i, res);
        end
        if getappdata(0, 'stop_now')
            fprintf('Interruped by user at iteration %03d\n', i);
            break;
        end
    end
end
