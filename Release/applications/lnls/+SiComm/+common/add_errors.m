function MD = add_errors(MD)
% Includes the systematic errors in position and angle of injection, kicker
% angle and energy deviation in injection parameters. Also includes the
% pulse dependent error for these quantities. The function includes the BPM
% and Screens resolutions.
%
% See also: SiComm.injection.bo.single_adj_loop, SiComm.injection.bo.multiple_adj_loop
%
% Version 1 - Murilo B. Alves, 2018

    % Systematic and Jitter error for x position
    MD.Err.x_error_syst = MD.Err.Sigma.x_syst * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff);
    MD.Inj.R.offset_x_syst = MD.Inj.R0.offset_x0 + MD.Err.x_error_syst;
    MD.Err.x_error_pulse = MD.Err.Sigma.x_jit;

    % Systematic and Jitter error for x angle
    MD.Err.xl_error_syst = MD.Err.Sigma.xl_syst * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff);
    MD.Inj.R.offset_xl_syst = MD.Inj.R0.offset_xl0 + MD.Err.xl_error_syst;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    MD.Err.xl_error_pulse = MD.Err.Sigma.x_jit; % Measurement (0.036 %) 03/10/2018

    % Systematic and Jitter error for y position
    MD.Err.y_error_syst = MD.Err.Sigma.y_syst * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff);
    MD.Inj.R.offset_y_syst = MD.Inj.R0.offset_y0 + MD.Err.y_error_syst;
    MD.Err.y_error_pulse = MD.Err.Sigma.x_jit;

    % Systematic and Jitter error for y angle
    MD.Err.yl_error_syst = MD.Err.Sigma.yl_syst * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff);
    MD.Inj.R.offset_yl_syst = MD.Inj.R0.offset_yl0 + MD.Err.yl_error_syst;
    % param.xl_error_pulse = 0.06e-3; % Especification (0.070%) Wiki
    MD.Err.yl_error_pulse = MD.Err.Sigma.x_jit; % Measurement (0.036 %) 03/10/2018

    % Systematic and Jitter error for kicker angle deflection
    MD.Err.kckr_error_syst = MD.Err.Sigma.kckr_syst * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff);
    MD.Inj.R.kckr_syst = MD.Inj.R0.kckr0 + MD.Err.kckr_error_syst;
    % param.kckr_error_pulse = 0.074e-3;  % Especification (0.31%) Wiki
    MD.Err.kckr_error_pulse = MD.Err.Sigma.x_jit; % Measurement (0.2%) 03/10/2018

    % Systematic and Jitter error for beam energy
    MD.Err.delta_error_syst = MD.Err.Sigma.energy_syst * lnls_generate_random_numbers(1, 1, 'norm', MD.Err.Sigma.Cutoff);
    MD.Inj.R.delta_syst = MD.Inj.R0.delta0 + MD.Err.delta_error_syst;
    MD.Err.delta_error_pulse = MD.Err.Sigma.energy_jit;

    % Diagnostics errors
    MD.Err.sigma_bpm = MD.Err.Sigma.bpm_jit; %Pulse by Pulse variation for BPM
    MD.Err.sigma_scrn = MD.Err.Sigma.scrn_offset; %Alignment error for Screen
    MD.Err.sigma_scrn_pulse = MD.Err.Sigma.scrn_jit; %Pulse by Pulse variation for Screen
    MD.Err.Cutoff = 1;
    MD.Err.phase_offset = 0; %Longitudinal phase error
end
