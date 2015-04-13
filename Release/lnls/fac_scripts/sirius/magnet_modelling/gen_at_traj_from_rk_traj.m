function at_traj  = gen_at_traj_from_rk_traj(rk_traj, s_max, magnet_type, nominal_ang)

if strcmpi(magnet_type, 'dipole')
    sel = (rk_traj.s <= s_max);
    at_traj.s = rk_traj.s(sel);
    at_traj.x = rk_traj.x(sel);
    at_traj.y = rk_traj.y(sel);
    at_traj.z = rk_traj.z(sel);
    at_traj.beta_x = rk_traj.beta_x(sel);
    at_traj.beta_y = rk_traj.beta_y(sel);
    at_traj.beta_z = rk_traj.beta_z(sel);
    
%     final_beta_x = rk_traj.beta_x(end);
%     final_beta_z = sqrt(1 - final_beta_x^2);
    
    final_beta_x = rk_traj.beta_x(end) * abs(nominal_ang / rk_traj.beta_x(end));
    final_beta_z = sqrt(1 - final_beta_x^2);
    
    s_grid = linspace(s_max+0.00015, rk_traj.s(end), length(find(~sel)));
    x_grid = at_traj.x(end) + (s_grid - s_max) * final_beta_x;
    z_grid = at_traj.z(end) + (s_grid - s_max) * final_beta_z;
    y_grid = zeros(size(x_grid));
    beta_x_grid = final_beta_x * ones(size(x_grid));
    beta_z_grid = final_beta_z * ones(size(z_grid));
    beta_y_grid = zeros(size(y_grid));
    at_traj.s = [at_traj.s; s_grid'];
    at_traj.x = [at_traj.x; x_grid'];
    at_traj.y = [at_traj.y; y_grid'];
    at_traj.z = [at_traj.z; z_grid'];
    at_traj.beta_x = [at_traj.beta_x; beta_x_grid'];
    at_traj.beta_y = [at_traj.beta_y; beta_y_grid'];
    at_traj.beta_z = [at_traj.beta_z; beta_z_grid'];
elseif any(strcmpi(magnet_type, {'quadrupole','sextupole'}))
    at_traj = rk_traj;
    at_traj.z = at_traj.s;
    at_traj.x = 0 * at_traj.x;
    at_traj.y = 0 * at_traj.y;
    at_traj.angle_x = 0 * at_traj.angle_x;
    at_traj.angle_y = 0 * at_traj.angle_y;
    at_traj.beta_x = 0 * at_traj.beta_x;
    at_traj.beta_y = 0 * at_traj.beta_y;
    at_traj.beta_z = ones(size(at_traj.beta_z));
end
