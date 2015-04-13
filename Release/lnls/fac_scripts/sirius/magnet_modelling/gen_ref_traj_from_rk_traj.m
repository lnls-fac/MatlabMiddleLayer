function ref_traj  = gen_ref_traj_from_rk_traj(rk_traj, s_max, magnet_type, nominal_ang)

if strcmpi(magnet_type, 'dipole')
    sel = (rk_traj.s <= s_max);
    ref_traj.s = rk_traj.s(sel);
    ref_traj.x = rk_traj.x(sel);
    ref_traj.y = rk_traj.y(sel);
    ref_traj.z = rk_traj.z(sel);
    ref_traj.beta_x = rk_traj.beta_x(sel);
    ref_traj.beta_y = rk_traj.beta_y(sel);
    ref_traj.beta_z = rk_traj.beta_z(sel);
        
    final_beta_z  = cos(nominal_ang);
    final_beta_x  = sign(rk_traj.beta_x(end)) * sqrt(1.0 - final_beta_z^2);
%     final_beta_x = rk_traj.beta_x(end) * abs(nominal_ang / rk_traj.beta_x(end));
%     final_beta_z = sqrt(1 - final_beta_x^2);
    
    s_grid = linspace(s_max+0.00015, rk_traj.s(end), length(find(~sel)));
    x_grid = ref_traj.x(end) + (s_grid - s_max) * final_beta_x;
    z_grid = ref_traj.z(end) + (s_grid - s_max) * final_beta_z;
    y_grid = zeros(size(x_grid));
    beta_x_grid = final_beta_x * ones(size(x_grid));
    beta_z_grid = final_beta_z * ones(size(z_grid));
    beta_y_grid = zeros(size(y_grid));
    ref_traj.s = [ref_traj.s; s_grid'];
    ref_traj.x = [ref_traj.x; x_grid'];
    ref_traj.y = [ref_traj.y; y_grid'];
    ref_traj.z = [ref_traj.z; z_grid'];
    ref_traj.beta_x = [ref_traj.beta_x; beta_x_grid'];
    ref_traj.beta_y = [ref_traj.beta_y; beta_y_grid'];
    ref_traj.beta_z = [ref_traj.beta_z; beta_z_grid'];
    ref_traj.angle_x = atan(ref_traj.beta_x./ref_traj.beta_z);
    ref_traj.angle_y = atan(ref_traj.beta_y./ref_traj.beta_z);
    
elseif any(strcmpi(magnet_type, {'quadrupole','sextupole','corrector'}))
    ref_traj = rk_traj;
    ref_traj.z = ref_traj.s;
    ref_traj.x = 0 * ref_traj.x;
    ref_traj.y = 0 * ref_traj.y;
    ref_traj.angle_x = 0 * ref_traj.angle_x;
    ref_traj.angle_y = 0 * ref_traj.angle_y;
    ref_traj.beta_x = 0 * ref_traj.beta_x;
    ref_traj.beta_y = 0 * ref_traj.beta_y;
    ref_traj.beta_z = ones(size(ref_traj.beta_z));
end
