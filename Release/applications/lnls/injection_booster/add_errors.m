function param = add_errors(param)
    param.offset_x = -30e-3;
    param.kckr = -19.34e-3;

    param.x_error_sist = -3e-3; % lnls_generate_random_numbers(1, 1, 'norm') * 3e-3;
    param.offset_x_erro = param.offset_x0 + param.x_error_sist;
    
    param.xl_error_sist = 2e-3; % lnls_generate_random_numbers(1, 1, 'norm') * 2e-3;
    param.offset_xl_erro = param.offset_xl0 + param.xl_error_sist;
    param.xl_error_pulse = 0.27e-3;
    
    param.kckr_error_sist = 2e-3; % lnls_generate_random_numbers(1, 1, 'norm') * 2e-3;
    param.kckr_erro = param.kckr0 + param.kckr_error_sist;
    param.kckr_error_pulse = 0.074e-3;
    
    param.energy_error_sist = 1e-2; % lnls_generate_random_numbers(1, 1, 'norm') * 3e-2;
    param.energy_error_pulse = 5e-3; % lnls_generate_random_numbers(1, 1, 'norm') * 5e-3;

    param.sigma_bpm = 2e-3;
    param.sigma_scrn = 0.5e-3;
    param.cutoff = 3;
    
    param.kckr_inicial = param.kckr0 + param.kckr_error_sist;
    param.xl_sept_inicial = param.offset_xl0 + param.xl_error_sist;
end

