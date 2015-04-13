deg2rad = (pi/180);

% definicao de um modelo particular:
bend_pass_method = 'BndMPoleSymplectic4Pass';
B_length = 1.1520;   % [m]
B_angle  = (360 / 50) * deg2rad; % [rad]
B_rho    = B_length / B_angle;
B_gap    =  0.025;   % [m]
B_fint1  =  0.0;
B_fint2  =  0.0;
B_quad   = -0.2037;  % [1/m^2]
B_sext   = -2.2685;  % [1/m^3]
b = rbend_sirius('B', B_length/2, B_angle/2, 0*(B_angle/2), 1*(B_angle/2), ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0 B_quad B_sext 0], bend_pass_method);
atmodel = buildlat(b);



spos = findspos(atmodel, 1:length(atmodel)+1);
%traj_len deve ser maior ou igual ao comprimento do modelo at a ser usado!!
config.traj_len = 1.036/2;
ind = spos < config.traj_len;
atmodel = atmodel(ind);
config.traj_len = findspos(atmodel, length(atmodel)+1);


config.dipole_length    = 1.152;
config.dipole_angle     = 2*sum(getcellstruct(atmodel,'BendingAngle',1:length(atmodel)));

config.energy = 3; % [GeV]

config.dipole_model = atmodel;

config.dipole_rho       = 1.152 / (7.2*pi/180);
config.dipole_sagitta   = config.dipole_rho * (1.0 - cos((7.2*pi/180)/2));
config.hard_edge_length = 2*config.dipole_rho*sin((7.2*pi/180)/2); 
% grid of points perp. to the ref. trajectory for AT-RK comparison
config.x    = [-6 -1  0 +1 +6] / 1000;
% config.coeffs   = [B0, G0, S0];     % [T T/m T/m^2]; By(x) = coeffs(1) + coeffs(2) * x + coeffs(3) * x^2
B0 = -1.054325;
G0 =  1.843324;
S0 = 19.594382;
config.coeffs   = [B0, G0, S0];

findmultipoles(config);
