% Build simulation results structure
function simulation_results = build_results(config, simulation_time, simulation_outputs)

n_pts = length(simulation_time);
[n_bpm, n_corr] = size(config.beam_response_matrix);

actual_pos = simulation_outputs(:,1:n_bpm);
pos_deviation =  actual_pos - repmat(config.beam_reference_orbit, n_pts,1);

kick_angle = simulation_outputs(:,2*n_bpm+2*n_corr+1:2*n_bpm+3*n_corr);

% Calculate average errors of position in relation to the reference orbit
pos_error = mean(pos_deviation);

% Find maximum position deviations
[pos_max_deviation index] = max(abs(pos_deviation));
pos_max_deviation = pos_deviation(index, :);

% Calculate position RMS values
pos_rms = std(actual_pos);

% Calculate kick angle RMS values
kick_rms = std(kick_angle);

% Find maximum kick angle amplitude
[kick_max_amplitude index] = max(abs(kick_angle));
kick_max_amplitude = kick_angle(index, :);

simulation_results = struct('time', simulation_time, ...
    'actual_pos', actual_pos, ...
    'bpm_pos', simulation_outputs(:,n_bpm+1:2*n_bpm), ...
    'current_setpoint', simulation_outputs(:,2*n_bpm+1:2*n_bpm+n_corr), ...
    'actual_current', simulation_outputs(:,2*n_bpm+n_corr+1:2*n_bpm+2*n_corr), ...
    'kick_angle', kick_angle, ...
    'pos_error', pos_error, ...
    'pos_rms', pos_rms, ...
    'pos_max_deviation', pos_max_deviation, ...
    'mfield_max_derivative', max(abs(simulation_outputs(:,2*n_bpm+3*n_corr+1:2*n_bpm+4*n_corr))), ...
    'kick_rms', kick_rms, ...
    'kick_max_amplitude', kick_max_amplitude);