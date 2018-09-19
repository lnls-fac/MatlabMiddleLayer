function param = add_errors_machine(param)
    param.offset_x = -30e-3;
    param.offset_xl = 14.3e-3;
    param.kckr = -19.34e-3;
    param.delta = 0;

    param.x_error_sist = -3e-3;
    param.offset_x_sist = param.offset_x0 + param.x_error_sist;
    param.x_error_pulse = 0.5e-3;
    
    param.xl_error_sist = 2e-3; 
    param.offset_xl_sist = param.offset_xl0 + param.xl_error_sist;
    param.xl_error_pulse = 0.06e-3;
    
    param.kckr_error_sist = 2e-3; 
    param.kckr_sist = param.kckr0 + param.kckr_error_sist;
    param.kckr_error_pulse = 0.074e-3;
    
    param.delta_error_sist = 5e-2; 
    param.delta_sist = param.delta0 + param.delta_error_sist;
    param.delta_error_pulse = 5e-3;
     
    param.sigma_bpm = 2e-3;
    param.sigma_scrn = 0.5e-3;
    param.cutoff = 3;
    
    param.kckr_init = param.kckr_sist;
    param.xl_sept_init = param.offset_xl_sist;
end

