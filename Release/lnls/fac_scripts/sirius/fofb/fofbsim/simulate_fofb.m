function simulation_results = simulate_fofb(config, disturbance_config, controller_config, ss_matrices)

config = build_default_simulation_parameters(config);
config.beam_disturbance = generate_disturbance(disturbance_config, config.sim_time, size(config.beam_response_matrix,1));
assignin('base', 'config_fofbsim', config);

ss_matrices = build_ss_matrices(ss_matrices, config, controller_config);
assignin('base', 'ss_matrices_fofbsim', ss_matrices);

% Disable non-relevant warnings, run simulation and re-enable warnings
warning('off', 'Simulink:SL_TDelayDirectThroughAutoSet');
warning('off', 'Simulink:SL_UsingDefaultMaxStepSize');
[simulation_time, simulation_states, simulation_outputs] = sim('fofbsim_model');
warning('on', 'Simulink:SL_UsingDefaultMaxStepSize');
warning('on', 'Simulink:SL_TDelayDirectThroughAutoSet');

% Build results structure
simulation_results = build_results(config, simulation_time, simulation_outputs);