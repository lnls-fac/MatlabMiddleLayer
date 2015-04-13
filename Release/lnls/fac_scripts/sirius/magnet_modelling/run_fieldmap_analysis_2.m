function r = run_fieldmap_analysis_2

% initial cleanup
clc; close('all');
fclose('all'); drawnow;

% selects and loads configuration for analysis
parms = load_config('CONFIG2');
%parms = load_config('BOOSTER_B_MODELO1');
%parms = load_config('BOOSTER_B_MODELO1_TRAJ_CENTERED');
%parms = load_config('BOOSTER_QD_MODELO2');
%parms = load_config('BOOSTER_SX_MODELO3');
%parms = load_config('BOOSTER_QF_MODELO4');
%parms = load_config('BOOSTER_QF_ERRORS');
%parms = load_config('BOOSTER_QF_ERRORS_SKEW');

% parms = load_config('SIRIUS_B2_MODELO7');
%parms = load_config('SIRIUS_CM_H');
%parms = load_config('SIRIUS_CM_V');
%parms = load_config('SIRIUS_QF_ERRORS');

% calcs beam parameters (magnetic rigidity, gamma factor, beta, etc)
calc_beam_parameters(parms.beam.energy);

% loads fieldmap from file
%load_fieldmap(parms.fmap_fname);
%load_fieldmap(parms.fmap_fname, 'HCM');
load_fieldmap(parms.fmap_fname);
maxwell_field_reconstruction(parms.fmap_maxwell_order);

% calcs real trajectory based on adaptative-step RK integration on fieldmap data
if ~isempty(parms.rk_traj)
    data = load(parms.rk_traj);
    rk_traj = data.r.rk_traj;
    clear('data');
else
    [~, zmax, xmin, xmax] = get_fmaps_boundingbox; s_length = max([zmax + (xmax - xmin), 1.01*parms.model.half_length]);
    rk_traj = calc_trajectory(s_length, parms.init_position, parms.runge_kutta_flags);
    if ~strcmpi(parms.magnet_type, 'dipole')
%    if true
        % if not dipole RK_TRAJ (REF_TRAJ) should be straight line
        rk_traj.x = 0 * rk_traj.x;
        rk_traj.y = 0 * rk_traj.y;
        rk_traj.beta_x = 0 * rk_traj.beta_x;
        rk_traj.beta_y = 0 * rk_traj.beta_y;
        rk_traj.beta_z = ones(size(rk_traj.beta_z));
        rk_traj.angle_x = 0 * rk_traj.angle_x;
        rk_traj.angle_y = 0 * rk_traj.angle_y;
    end
end
    
% calcs parameters on real trajectory (polynomB)
rk_traj = calc_field_on_rk_trajectory(rk_traj, parms.perp_grid);
rk_traj_parms = calc_parameters_on_rk_trajectory(rk_traj, parms.beam, parms.magnet_type, parms.tracy.r0, parms.perp_grid.monomials);

% creates segmentated model based on PolynomB profil
seg_model = generate_model_segmentation(rk_traj, parms.model.half_length, parms.perp_grid.monomials, 'load_return', parms.config_path);

% creates segmented AT model (with thin element bumping all multipoles outside model half-length)
at_model  = create_at_model(rk_traj, seg_model, parms.magnet_type, parms.perp_grid.monomials, parms.nominal_ang);

% creates reference trajectory path based on ref_traj defined by AT model
ref_traj  = gen_ref_traj_from_rk_traj(rk_traj, seg_model.s(end), parms.magnet_type, parms.nominal_ang);

% tracks particle through fieldmap and generates kick curves
fieldmap_track = track_through_fieldmap(ref_traj, parms.track, parms.runge_kutta_flags);

% calibrates at_model to yield kick curve close to the one from the fieldmap
[at_model_calibrated M_fieldmap M_atmodel K_fieldmap K_atmodel] = calibrate_at_model(ref_traj, at_model, fieldmap_track, parms.track, parms.perp_grid.monomials, parms.runge_kutta_flags, parms.calibration);
atmodel_track = track_through_atmodel(at_model_calibrated, parms.track, ref_traj.s(end));

% prints summary data
print_summary(parms, rk_traj, rk_traj_parms, ref_traj, at_model_calibrated, fieldmap_track, atmodel_track, M_fieldmap, M_atmodel);

% saves AT model
saves_at_model(parms.config_path, at_model);

% saves results
r.parms = parms;
r.fieldmaps = getappdata(0, 'FIELD_MAPS');
r.rk_traj = rk_traj;
r.ref_traj = ref_traj;
r.rk_traj_parms = rk_traj_parms;
r.seg_model = seg_model;
r.at_model = at_model_calibrated;
r.fieldmap_track = fieldmap_track;
r.atmodel_track = atmodel_track;
save(fullfile(parms.config_path, 'fieldmap_analysis.mat'), 'r');
tpath=pwd; cd(parms.config_path); lnls_save_plots; cd(tpath);
