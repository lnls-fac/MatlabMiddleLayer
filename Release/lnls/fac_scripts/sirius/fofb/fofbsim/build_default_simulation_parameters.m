% Complete missing simulation parameters fields with default values
function config = build_default_simulation_parameters(config)

[n_bpm, n_corr] = size(config.beam_response_matrix);

% Default response matrix: 1x1 matrix, with unitay gain. 1 horizontal BPM reading and 1 horizontal corrector
if isempty(config.beam_response_matrix)    
    config.beam_response_matrix = 1;
    config.n_horizontal_bpm = 1;
    config.n_horizontal_corr = 1;
    n_bpm = 1;
    n_corr = 1;
end

% Default correction matrix: SVD-calculated pseudoinverse with all singular values
if isempty(config.ctrl_correction_matrix) || (size(config.ctrl_correction_matrix,2) ~= n_bpm) ...
        || (size(config.ctrl_correction_matrix,1) ~= n_corr)
    [U,V,W] = svd(config.beam_response_matrix, 'econ');
    config.ctrl_correction_matrix = W/V*U';
end

% Default reference orbit: zero for all BPM readings
if isempty(config.beam_reference_orbit) || (size(config.beam_reference_orbit,2) ~= n_bpm)
    config.beam_reference_orbit = zeros(1, size(config.beam_response_matrix, 1));   
end

% Default disturbance: no distrubance in all BPMs
if isempty(config.beam_disturbance)
    config.beam_disturbance = [[0; config.sim_time] zeros(2, n_bpm)];   
end

% Default simulation integration time: half the inverse of the maximum sampling/update rate of the BPMs/controller
if config.sim_max_step_auto
    config.sim_max_step = 1/max(config.bpm_sampling_rate, config.ps_update_rate)/2;
end