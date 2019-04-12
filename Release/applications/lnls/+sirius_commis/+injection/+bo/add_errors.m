function [param_errors, param] = add_errors(param)
% Includes the systematic errors in position and angle of injection, kicker
% angle and energy deviation in injection parameters. Also includes the
% pulse dependent error for these quantities. The function includes the BPM
% and Screens resolutions.
%
% See also: sirius_commis.injection.bo.single_adj_loop, sirius_commis.injection.bo.multiple_adj_loop
%
% Version 1 - Murilo B. Alves, 2018
    cutoff = 1e8;
    f = 1;

    param_errors.x_error_sist = f * 3e-3 * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.offset_x_sist = param.offset_x0 + param_errors.x_error_sist;
    param_errors.x_error_pulse = 0.5e-3;
    
    param_errors.xl_error_sist = f * 5e-3 * lnls_generate_random_numbers(1, 1, 'norm', cutoff); 
    param.offset_xl_sist = param.offset_xl0 + param_errors.xl_error_sist;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    param_errors.xl_error_pulse = 0.028e-3; % Measurement (0.036 %) 03/10/2018
    
    param_errors.y_error_sist = f * 3e-3 * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.offset_y_sist = param.offset_y0 + param_errors.y_error_sist;
    param_errors.y_error_pulse = 0.5e-3;
    
    param_errors.yl_error_sist = f * 5e-3 * lnls_generate_random_numbers(1, 1, 'norm', cutoff); 
    param.offset_yl_sist = param.offset_yl0 + param_errors.yl_error_sist;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    param_errors.yl_error_pulse = 0.028e-3; % Measurement (0.036 %) 03/10/2018
    
    param_errors.kckr_error_sist = f * 5e-3 * lnls_generate_random_numbers(1, 1, 'norm', cutoff); 
    param.kckr_sist = param.kckr0 + param_errors.kckr_error_sist;
    % param.kckr_error_pulse = 0.074e-3;  % Especification (0.31%) Wiki
    param_errors.kckr_error_pulse = 0.048e-3; % Measurement (0.2%) 03/10/2018
    
    
    param_errors.delta_error_sist = f * 1e-2 * lnls_generate_random_numbers(1, 1, 'norm', cutoff); 
    param.delta_sist = param.delta0 + param_errors.delta_error_sist;
    param_errors.delta_error_pulse = 3e-3;
    
    param_errors.sigma_bpm = 2e-3;
    param_errors.sigma_scrn_pulse = 0.5e-3;
    param_errors.sigma_scrn = 2 * 0.5e-3;
    param_errors.cutoff = 1;
    param_errors.phase_offset = 0;
    
    param.kckr_init = param.kckr_sist;
    param.xl_sept_init = param.offset_xl_sist;
end

