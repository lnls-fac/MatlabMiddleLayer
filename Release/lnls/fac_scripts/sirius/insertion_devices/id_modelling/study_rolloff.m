function ID = create_ID(id_def)

% cleanup
clc; fclose('all'); close('all');
addpath('epu');

% ID basic parameters
% units
mm = 1; Tesla = 1;
id_def.id_label             = 'TEST_EPU80_PV';
id_def.period               = 80 * mm;
id_def.nr_periods           = 38;
id_def.magnetic_gap         = 16.0 * mm;
id_def.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
id_def.block_separation     = 0  * mm;
id_def.block_width          = 40 * mm;
id_def.block_height         = 60 * mm;
id_def.phase_csd            = 40 * mm;
id_def.phase_cie            = 40 * mm;
id_def.chamfer              =  0 * mm;
id_def.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
id_def.vchamber_thkness     = 1.00 * mm;
id_def.mech_tol             = 0.50 * mm;
id_def.physical_gap         = id_def.magnetic_gap - 2 * (id_def.vchamber_thkness + id_def.mech_tol);

% turns diary mode on
diary off;
diary_fname = [id_def.id_label ' - ID-SUMMARY.txt'];
if exist(diary_fname, 'file'), delete(diary_fname); end;
diary(diary_fname);


% created 3d model of the insertion device
id_model = epu_create(id_def);

% calcs basic field parameters
field_parms = get_field_summary(id_def, id_model);

% prints summary of parameters and plots fields
print_summary(id_def, field_parms);

% saves plots to file
save_plots(id_def.id_label);

% saves result to mat file
ID.def = id_def;
ID.model = id_model;
ID.field = field_parms;
save([id_def.id_label ' - ID.mat'], 'ID');

% finalizations
diary off;





function fs = get_field_summary(id_def, id_model)

nr_pts_longitudinal_z = 65;
nr_pts_transversal_x  = 65;
nr_pts_transversal_y  = 65;

% calcs field on axis
z  = linspace(-id_def.period/2,id_def.period/2,nr_pts_longitudinal_z);
pos = zeros(3,length(z)); pos(2,:) = z;
field = epu_field(id_model, pos); 
fs.on_axis_z  = z;
fs.on_axis_bx = field(1,:);
fs.on_axis_bz = field(2,:);
fs.on_axis_by = field(3,:);

% stores z-position and values of maximum fields for all three components
[max_field idx] = max(abs(fs.on_axis_bx));
fs.on_axis_bx_max_abs_field = max_field;
fs.on_axis_bx_max_abs_z     = z(idx);
[max_field idx] = max(abs(fs.on_axis_bz));
fs.on_axis_bz_max_abs_field = max_field;
fs.on_axis_bz_max_abs_z     = z(idx);
[max_field idx] = max(abs(fs.on_axis_by));
fs.on_axis_by_max_abs_field = max_field;
fs.on_axis_by_max_abs_z     = z(idx);

% calcs id K values
fs.on_axis_kx = 93.44 * fs.on_axis_by_max_abs_field * (id_def.period/1000);
fs.on_axis_ky = 93.44 * fs.on_axis_bx_max_abs_field * (id_def.period/1000);

% calcs horizontal rolloffs
x = linspace(-1,1,nr_pts_transversal_x) * (id_def.block_width + id_def.block_separation/2);
fs.x_rolloff_x = x;
pos = zeros(3,length(x)); pos(1,:) = x;
% -bx-
pos(2,:) = fs.on_axis_bx_max_abs_z;
field = epu_field(id_model, pos);
fs.x_rolloff_bx = field(1,:);
% % -bz-
% pos(2,:) = fs.on_axis_bz_max_abs_z;
% field = epu_field(id_model, pos);
% fs.x_rolloff_bz = field(2,:);
% % -by-
% pos(2,:) = fs.on_axis_by_max_abs_z;
% field = epu_field(id_model, pos);
% fs.x_rolloff_by = field(3,:);
% 
% % calcs vertical rolloffs
% y = linspace(-1,1,nr_pts_transversal_y) * (id_def.magnetic_gap/2 - 0.05);
% fs.y_rolloff_y = y;
% pos = zeros(3,length(x)); pos(3,:) = y;
% % -bx-
% pos(2,:) = fs.on_axis_bx_max_abs_z;
% field = epu_field(id_model, pos);
% fs.y_rolloff_bx = field(1,:);
% % -bz-
% pos(2,:) = fs.on_axis_bz_max_abs_z;
% field = epu_field(id_model, pos);
% fs.y_rolloff_bz = field(2,:);
% % -by-
% pos(2,:) = fs.on_axis_by_max_abs_z;
% field = epu_field(id_model, pos);
% fs.y_rolloff_by = field(3,:);


