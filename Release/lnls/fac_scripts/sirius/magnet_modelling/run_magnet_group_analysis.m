function r = run_magnet_group_analysis


% selects and loads configuration for analysis
parms = load_config('BOOSTER_B_MODELO2');

% calcs beam parameters (magnetic rigidity, gamma factor, beta, etc)
calc_beam_parameters(parms.beam.energy);

% loads fieldmap from file
load_fieldmap(parms.fmap_fname, 'suppress_plot');
maxwell_field_reconstruction(parms.fmap_maxwell_order);

% calcs real trajectory based on adaptative-step RK integration on fieldmap data
[~, zmax, xmin, xmax] = get_fmaps_boundingbox; s_length = max([zmax + (xmax - xmin), 1.01*parms.model.half_length]);
rk_traj = calc_trajectory(s_length, parms.init_position, parms.runge_kutta_flags);
if ~strcmpi(parms.magnet_type, 'dipole')
        rk_traj.x = 0 * rk_traj.x;
        rk_traj.y = 0 * rk_traj.y;
        rk_traj.beta_x = 0 * rk_traj.beta_x;
        rk_traj.beta_y = 0 * rk_traj.beta_y;
        rk_traj.beta_z = ones(size(rk_traj.beta_z));
        rk_traj.angle_x = 0 * rk_traj.angle_x;
        rk_traj.angle_y = 0 * rk_traj.angle_y;
end
    
% calcs parameters on real trajectory (polynomB)
rk_traj = calc_field_on_rk_trajectory(rk_traj, parms.perp_grid, 'verbose_off');
rk_traj_parms = calc_parameters_on_rk_trajectory(rk_traj, parms.beam, parms.magnet_type, parms.tracy.r0, parms.perp_grid.monomials);

% creates reference trajectory path based on ref_traj defined by AT model
%ref_traj  = gen_ref_traj_from_rk_traj(rk_traj, parms.model.half_length, parms.magnet_type, parms.nominal_ang);
ref_traj = rk_traj;

% tracks particle through fieldmap and generates kick curves
fieldmap_track = track_through_fieldmap(ref_traj, parms.track, parms.runge_kutta_flags);

xi  = fieldmap_track.in_pts(:,1)';
pxf = fieldmap_track.out_pts(:,2)';
r.kick_coeffs = lnls_polyfit(xi,pxf,parms.perp_grid.monomials);
r.by_polynom=rk_traj_parms.integ_by_polynom;


