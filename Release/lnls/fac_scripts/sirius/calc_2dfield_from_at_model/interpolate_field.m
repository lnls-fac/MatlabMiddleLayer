function field = interpolate_field(r)

config = getappdata(0, 'P_CONFIG');

coeffs = config.coeffs;
x = r(1);
z = r(3);

field = [0;0;0];

%field(2) = coeffs(1)
%return;

% config.dipole_length    = 2*dipole{1}.Length;
% config.dipole_angle     = 2*dipole{1}.BendingAngle;
% config.dipole_rho       = config.dipole_length / config.dipole_angle;
% config.dipole_sagitta   = config.dipole_rho * (1.0 - cos(config.dipole_angle/2));
% config.hard_edge_length = 2*config.dipole_rho*sin(config.dipole_angle/2); 

% zc  = config.hard_edge_length/2;
% xc  = -config.dipole_sagitta;
% an  = tan(pi/2 - config.dipole_angle/2);
% x_z = xc + an * (z - zc);
% 
% if (x > x_z)
%     field(2) = coeffs(1) + coeffs(2) * x + coeffs(3) * x^2; 
% end


% calcs basic dipole parameters
he_length = config.hard_edge_length;
if (z > -he_length/2) && (z < he_length/2)
%     field(2) = 0;
%     for i=1:length(coeffs)
%         field(2) = field(2) + coeffs(i) * x^(i-1);
%     end
    field(2) = coeffs(1) + coeffs(2) * x + coeffs(3) * x^2; 
end

