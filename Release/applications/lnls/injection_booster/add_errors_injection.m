function param = add_errors_injection(param)
% Includes the systematic errors in position and angle of injection, kicker
% angle and energy deviation in injection parameters. Also includes the
% pulse dependent error for these quantities. The function includes the BPM
% and Screens resolutions.
%
% See also: bo_injection_adjustment, adj_booster_times
%
% Version 1 - Murilo B. Alves

    param.x_error_sist = 3e-3;
    param.offset_x_sist = param.offset_x0 + param.x_error_sist;
    param.x_error_pulse = 0.5e-3;
    
    param.xl_error_sist = 5e-3; 
    param.offset_xl_sist = param.offset_xl0 + param.xl_error_sist;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    param.xl_error_pulse = 0.028e-3; % Measurement (0.036 %) 03/10/2018
    
    param.kckr_error_sist = 5e-3; 
    param.kckr_sist = param.kckr0 + param.kckr_error_sist;
    % param.kckr_error_pulse = 0.074e-3;  % Especification (0.31%) Wiki
    param.kckr_error_pulse = 0.048e-3; % Measurement (0.2%) 03/10/2018
    
    
    param.delta_error_sist = 5e-2; 
    param.delta_sist = param.delta0 + param.delta_error_sist;
    param.delta_error_pulse = 5e-3;
     
    param.sigma_bpm = 2e-3;
    param.sigma_scrn = 0.5e-3;
    param.cutoff = 3;
    
    param.kckr_init = param.kckr_sist;
    param.xl_sept_init = param.offset_xl_sist;
end

