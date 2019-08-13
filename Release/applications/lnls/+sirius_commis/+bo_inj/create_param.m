function [param_init, param_err] = create_param()

    % Twiss parameters 
    % Before Linac triplet, following set_parameters_tb
    param_init.twiss.betax0 = 2.71462;
    param_init.twiss.betay0 = 4.69925;
    param_init.twiss.alphax0 = -2.34174;
    param_init.twiss.alphay0 = 1.04009;
    param_init.twiss.etax0 = 0;
    param_init.twiss.etay0 = 0;
    param_init.twiss.etaxl0 = 0;
    param_init.twiss.etayl0 = 0;
    
    % Beam parameters
    % Based on measurements 16/07/2019
    param_init.beam.emitx = 148e-9; 
    param_init.beam.emity = 111e-9; 
    param_init.beam.sigmae = 0.45e-2;
    param_init.beam.sigmaz = 0;
    
    % Initial coordinates
    param_init.offset_x0 = 0;
    param_init.offset_xl0 = 0;
    param_init.offset_y0 = 0;
    param_init.offset_yl0 = 0;
    param_init.delta0 = 0;
    param_init.delta_ave = 0;
    
    % Conditions at booster injection
    param_init.injx0 = -30e-3;
    param_init.injxl0 = 14.3e-3;
    param_init.injy0 = 0;
    param_init.injyl0 = 0;
    param_init.inje0 = 0;
    param_init.injz0 = 0;
    
    param_init.injx = 1e-3;
    param_init.injxl = -500e-6;
    param_init.injy = -1e-3;
    param_init.injyl = 500e-6;
    param_init.inje = 0;
    param_init.injz = 0;  
    
    param_init.kckr0 = -19.34e-3;
    
    % One sigma to generate systematic and jitter errors in injection parameters and also in the diagnostics
    param_sigma.x_syst = 0; param_sigma.x_jit = 0;
    param_sigma.xl_syst = 0; param_sigma.xl_jit = 0;
    param_sigma.y_syst = 0; param_sigma.y_jit = 0;
    param_sigma.yl_syst = 0; param_sigma.yl_jit = 0;
    param_sigma.kckr_syst = 0; param_sigma.kckr_jit = 0;
    param_sigma.energy_syst = 0; param_sigma.energy_jit = 0;
    param_sigma.bpm_offset = 500e-6; param_sigma.bpm_jit = 0;
    param_sigma.scrn_offset = 0; param_sigma.scrn_jit = 0;
    
    % Adding random errors based on limits set above
    [param_err, param_init] = sirius_commis.common.add_errors(param_init, param_sigma, 1);
end

