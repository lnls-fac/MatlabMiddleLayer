function config = simulated_annealing_run(opt, complete)
    if ~exist('complete', 'var')
        complete = false;
    end
    ndig = ceil(log(opt.simulanneal_Niter)/log(10));
    st_tmp = sprintf('I%%0%dd',ndig);
    
    setappdata(0, 'stop_now', 0);
    config = opt.config0(:,1);
    vres = opt.objective_fun(config, opt.objective_data);
    res = rms(vres .* opt.simulanneal_weight);
    fprintf('%s : %7.4f\n', 'ini', res);
    
    st = sprintf(st_tmp,0);
    configs.(st).G = config;
    configs.(st).res = vres';
    for i=1:opt.simulanneal_Niter
        config_t = opt.small_change(config, opt.objective_data);
        vres_t = opt.objective_fun(config_t, opt.objective_data);
        res_t = rms(vres_t .* opt.simulanneal_weight);
        if res_t < res
            res = res_t;
            config = config_t;
            if complete
                st = sprintf(st_tmp,i);
                configs.(st).G = config;
                configs.(st).res = vres_t';
            end
            fprintf('%03d : %7.4f\n', i, res);
        end
        if getappdata(0, 'stop_now')
            fprintf('Interruped by user at iteration %03d\n', i);
            break;
        end
    end
    if complete
        config = configs;
    end
end
