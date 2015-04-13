% Build state-space matrices of dynamics subsystems
function ss_matrices = build_ss_matrices(ss_matrices, config, controller_config, dynamics_neglection_factor)

% In order to optimize the simulation, the power supply dynamics and vacuum chamber dynamics can be
% disabled (passed through) whether the response times of such subsystems are much smaller than the
% maximum integration. The 'dynamics_neglection_factor' parameter specifies how many times the reponse
% time must be smaller than the integration time for neglecting it. The default value is 5.
if nargin < 4
    dynamics_neglection_factor = 5;
end

[n_bpm, n_corr] = size(config.beam_response_matrix);

n_horizontal_corr = config.n_horizontal_corr;
n_vertical_corr = n_corr - n_horizontal_corr;

% Generate state-space representation of band limitation filter of BPMs
% Must guarantee that config.bpm_bandwidth < config.bpm_sampling_rate/2
[A,B,C,D] = butter(2, 2*config.bpm_bandwidth/config.bpm_sampling_rate, 'low');
[A,B,C,D] = replicate_ss(A,B,C,D,n_bpm);
ss_matrices.bpm_filter = struct('A',A,'B',B,'C',C,'D',D);

% Generate state-space representation of power supplies dynamics
if (config.ps_response_time > config.sim_max_step*dynamics_neglection_factor)
    wn = 4/config.ps_response_damping_factor/config.ps_response_time;
    [A,B,C,D] = tf2ss(wn*wn, [1 2*config.ps_response_damping_factor*wn wn*wn]);
else
    A=0; B=0; C=0; D=1;
end
[A,B,C,D] = replicate_ss(A,B,C,D,n_horizontal_corr + n_vertical_corr);
ss_matrices.ps_dynamics = struct('A',A,'B',B,'C',C,'D',D);

% Generate state-space representation of vacuum chamber dynamics
if (1/2/pi/config.vac_cutoff_H > config.sim_max_step*dynamics_neglection_factor)
    [A,B,C,D] = tf2ss(1, [1/2/pi/config.vac_cutoff_H 1]);
else
    A=0; B=0; C=0; D=1;
end
[A_H,B_H,C_H,D_H] = replicate_ss(A,B,C,D,n_horizontal_corr);

if (1/2/pi/config.vac_cutoff_V > config.sim_max_step*dynamics_neglection_factor)
    [A,B,C,D] = tf2ss(1, [1/2/pi/config.vac_cutoff_V 1]);
else
    A=0; B=0; C=0; D=1;
end
[A_V,B_V,C_V,D_V] = replicate_ss(A,B,C,D,n_vertical_corr);

% Concatenate matrices of horizontal and vertical vacuum chambers
A = zeros(size(A_H)+size(A_V));
B = zeros(size(B_H)+size(B_V));
C = zeros(size(C_H)+size(C_V));
D = zeros(size(D_H)+size(D_V));

A(1:size(A_H,1),1:size(A_H,2)) = A_H;
B(1:size(B_H,1),1:size(B_H,2)) = B_H;
C(1:size(C_H,1),1:size(C_H,2)) = C_H;
D(1:size(D_H,1),1:size(D_H,2)) = D_H;
A(size(A_H,1)+1:end,size(A_H,2)+1:end) = A_V;
B(size(B_H,1)+1:end,size(B_H,2)+1:end) = B_V;
C(size(C_H,1)+1:end,size(C_H,2)+1:end) = C_V;
D(size(D_H,1)+1:end,size(D_H,2)+1:end) = D_V;

ss_matrices.vac_dynamics = struct('A',A,'B',B,'C',C,'D',D);

% Generate state-space representation of control algorithm
[ctrl_num, ctrl_den] = generate_contoller(controller_config, 1/config.ps_update_rate);
[ctrl_num, ctrl_den] = equalize_tf(ctrl_num, ctrl_den);
[A,B,C,D] = tf2ss(ctrl_num,ctrl_den);
[A,B,C,D] = replicate_ss(A,B,C,D,n_horizontal_corr + n_vertical_corr);
ss_matrices.ctrl_algorithm = struct('A',A,'B',B,'C',C,'D',D);