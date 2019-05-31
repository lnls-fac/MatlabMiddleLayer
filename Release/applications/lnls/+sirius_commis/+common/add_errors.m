function [param_errors, param] = add_errors(param, param_sigma, f)
% Includes the systematic errors in position and angle of injection, kicker
% angle and energy deviation in injection parameters. Also includes the
% pulse dependent error for these quantities. The function includes the BPM
% and Screens resolutions.
%
% See also: sirius_commis.injection.bo.single_adj_loop, sirius_commis.injection.bo.multiple_adj_loop
%
% Version 1 - Murilo B. Alves, 2018
    cutoff = 1;

    % Systematic and Jitter error for x position
    param_errors.x_error_syst = param_sigma.x_syst * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.offset_x_syst = param.offset_x0 + param_errors.x_error_syst;
    param_errors.x_error_pulse = param_sigma.x_jit;

    % Systematic and Jitter error for x angle
    param_errors.xl_error_syst = f * param_sigma.xl_syst * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.offset_xl_syst = param.offset_xl0 + param_errors.xl_error_syst;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    param_errors.xl_error_pulse = param_sigma.x_jit; % Measurement (0.036 %) 03/10/2018

    % Systematic and Jitter error for y position
    param_errors.y_error_syst = param_sigma.y_syst * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.offset_y_syst = param.offset_y0 + param_errors.y_error_syst;
    param_errors.y_error_pulse = param_sigma.x_jit;

    % Systematic and Jitter error for y angle
    param_errors.yl_error_syst = f * param_sigma.yl_syst * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.offset_yl_syst = param.offset_yl0 + param_errors.yl_error_syst;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    param_errors.yl_error_pulse = param_sigma.x_jit; % Measurement (0.036 %) 03/10/2018

    % Systematic and Jitter error for kicker angle deflection
    param_errors.kckr_error_syst = f * param_sigma.kckr_syst * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.kckr_syst = param.kckr0 + param_errors.kckr_error_syst;
    % param.kckr_error_pulse = 0.074e-3;  % Especification (0.31%) Wiki
    param_errors.kckr_error_pulse = param_sigma.x_jit; % Measurement (0.2%) 03/10/2018

    % Systematic and Jitter error for beam energy
    param_errors.delta_error_syst = param_sigma.energy_syst * lnls_generate_random_numbers(1, 1, 'norm', cutoff);
    param.delta_syst = param.delta0 + param_errors.delta_error_syst;
    param_errors.delta_error_pulse = param_sigma.energy_jit;

    % Diagnostics errors
    param_errors.sigma_bpm = param_sigma.bpm_jit; %Pulse by Pulse variation for BPM
    param_errors.sigma_scrn = param_sigma.scrn_offset; %Alignment error for Screen
    param_errors.sigma_scrn_pulse = param_sigma.scrn_jit; %Pulse by Pulse variation for Screen
    param_errors.cutoff = 1;
    param_errors.phase_offset = 0; %Longitudinal phase error

    % Initial values to calculate the error determination efficiency at the end of the injection adjustment
    param.kckr_init = param.kckr_syst;
    param.xl_sept_init = param.offset_xl_syst;
    param.yl_sept_init = param.offset_yl_syst;
    param.x_sept_init = param.offset_x_syst;
    param.y_sept_init = param.offset_y_syst;
end
