function [param_errors, param] = add_errors(param)
% Includes the systematic errors in position and angle of injection, kicker
% angle and energy deviation in injection parameters. Also includes the
% pulse dependent error for these quantities. The function includes the BPM resolutions.
%
% See also: sirius_commis.injection.si.single_adj_loop, sirius_commis.injection.si.multiple_adj_loop
%
% Version 1 - Murilo B. Alves, 2018

    param_errors.x_error_sist = 0; %3e-3;
    param.offset_x_sist = param.offset_x0 + param_errors.x_error_sist;
    param_errors.x_error_pulse = 60e-6; %Especification (3.7 * dtheta_sept) Wiki 28/11/2018
    
    param_errors.xl_error_sist = 1e-3; 
    param.offset_xl_sist = param.offset_xl0 + param_errors.xl_error_sist;
    param_errors.xl_error_pulse = 16.2e-6; % Especification (0.019%) Wiki 28/11/2018
    
    param_errors.y_error_sist = 0; 
    param.offset_y_sist = param.offset_y0 + param_errors.y_error_sist;
    param_errors.y_error_pulse = 0; 
    
    param_errors.yl_error_sist = 0; 
    param.offset_yl_sist = param.offset_yl0 + param_errors.yl_error_sist;
    param_errors.yl_error_pulse = 0; 
    
    param_errors.kckr_error_sist = 1e-3; 
    param.kckr_sist = param.kckr0 + param_errors.kckr_error_sist;
    param_errors.kckr_error_pulse = 20e-6;  % Especification (0.33%) Wiki 28/11/2018
    
    param_errors.delta_error_sist = 5e-2; 
    param.delta_sist = param.delta0 + param_errors.delta_error_sist;
    param_errors.delta_error_pulse = 1e-3;
    
    param_errors.sigma_bpm = 2e-3; % Single pass = 2mm, Turn-by-turn = 3mm
    param_errors.cutoff = 1;
    param_errors.phase_offset = 0;
    
    param.kckr_init = param.kckr_sist;
    param.xl_sept_init = param.offset_xl_sist;
end

