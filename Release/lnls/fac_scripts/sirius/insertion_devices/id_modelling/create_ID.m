function ID = create_ID(id_def, nr_periods_init)

% cleanup
clc; fclose('all'); close('all');
addpath('epu');

% ID basic parameters
if ~exist('id_def','var')
    ids = ID_definitions();
    %id_def = ids.SCW3T;
    %id_def = ids.SCW4T;
    %id_def = ids.W2T;
    %id_def = ids.U18;
    %id_def = ids.U19;
    %id_def = ids.U25;
    %id_def = ids.EPU50_PH;
    %id_def = ids.EPU50_PC;
    %id_def = ids.EPU50_PV;
    %id_def = ids.EPU200_PH;
    %id_def = ids.EPU200_PC;
    %id_def = ids.EPU200_PV;
    id_def = ids.EPU80_PH;
    %id_def = ids.EPU80_PV;
    %id_def = ids.UTEST;  
end

% turns diary mode on
diary off;
diary_fname = [id_def.id_label ' - ID-SUMMARY.txt'];
if exist(diary_fname, 'file'), delete(diary_fname); end;
diary(diary_fname);

% check convergence of fields within central period
if exist('nr_periods_init','var')
    nr_periods = search_nr_periods_for_field_convergence(id_def, nr_periods_init);
else
    nr_periods = nr_periods_init;
end;

% created 3d model of the insertion device
model_id_def = id_def;
model_id_def.nr_periods = nr_periods;
id_model = epu_create(model_id_def);

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
% -bz-
pos(2,:) = fs.on_axis_bz_max_abs_z;
field = epu_field(id_model, pos);
fs.x_rolloff_bz = field(2,:);
% -by-
pos(2,:) = fs.on_axis_by_max_abs_z;
field = epu_field(id_model, pos);
fs.x_rolloff_by = field(3,:);

% calcs vertical rolloffs
y = linspace(-1,1,nr_pts_transversal_y) * (id_def.magnetic_gap/2 - 0.05);
fs.y_rolloff_y = y;
pos = zeros(3,length(x)); pos(3,:) = y;
% -bx-
pos(2,:) = fs.on_axis_bx_max_abs_z;
field = epu_field(id_model, pos);
fs.y_rolloff_bx = field(1,:);
% -bz-
pos(2,:) = fs.on_axis_bz_max_abs_z;
field = epu_field(id_model, pos);
fs.y_rolloff_bz = field(2,:);
% -by-
pos(2,:) = fs.on_axis_by_max_abs_z;
field = epu_field(id_model, pos);
fs.y_rolloff_by = field(3,:);

function print_summary(id_def, field_parms)

clc;
fmt_str = '%-30s: %s\n';
fprintf(fmt_str, 'ID Label', id_def.id_label);
fprintf('--- geometry ---\n');
fprintf(fmt_str, 'Period', [num2str(id_def.period) ' mm']);
fprintf(fmt_str, 'Length', [num2str(id_def.period * id_def.nr_periods) ' mm']);
fprintf(fmt_str, 'Magnetic gap', [num2str(id_def.magnetic_gap) ' mm']);
fprintf(fmt_str, 'ID width', [num2str(2*id_def.block_width + id_def.cassette_separation) ' mm']);
fprintf(fmt_str, 'URC phase', [num2str(id_def.phase_csd) ' mm']);
fprintf(fmt_str, 'LLC phase', [num2str(id_def.phase_cie) ' mm']);
fprintf('--- fields ---\n');
fprintf(fmt_str, 'KX (from Vert.Field)', num2str(field_parms.on_axis_kx, '%7.4f'));
fprintf(fmt_str, 'KY (from Hori.Field)', num2str(field_parms.on_axis_ky, '%7.4f'));
fprintf(fmt_str, 'Max.Vertical     By (on-axis)', [num2str(field_parms.on_axis_by_max_abs_field, '%6.4f') ' T']);
fprintf(fmt_str, 'Max.Horizontal   Bx (on-axis)', [num2str(field_parms.on_axis_bx_max_abs_field, '%6.4f') ' T']);
fprintf(fmt_str, 'Max.Longitudinal Bz (on-axis)', [num2str(field_parms.on_axis_bz_max_abs_field, '%6.4f') ' T']);

% longitudinal variation plot
figure; hold all;
set(gcf, 'Name', 'ID-ROLLOFF-Longitudinal');
plot(field_parms.on_axis_z, field_parms.on_axis_bz, 'g', 'LineWidth', 2);
plot(field_parms.on_axis_z, field_parms.on_axis_bx, 'b', 'LineWidth', 2);
plot(field_parms.on_axis_z, field_parms.on_axis_by, 'r', 'LineWidth', 2);
xlabel('Longitudinal Z Position [mm]');
ylabel('Field Amplitude [T]');
legend({'Bz','Bx','By'});

% horizontal variation plot
figure; hold all;
set(gcf, 'Name', 'ID-ROLLOFF-Horizontal');
plot(field_parms.x_rolloff_x, field_parms.x_rolloff_bz, 'g', 'LineWidth', 2);
plot(field_parms.x_rolloff_x, field_parms.x_rolloff_bx, 'b', 'LineWidth', 2);
plot(field_parms.x_rolloff_x, field_parms.x_rolloff_by, 'r', 'LineWidth', 2);
xlabel('Horizontal X Position [mm]');
ylabel('Field Amplitude [T]');
legend({'Bz','Bx','By'});

% vertical variation plot
figure; hold all;
set(gcf, 'Name', 'ID-ROLLOFF-Vertical');
plot(field_parms.y_rolloff_y, field_parms.y_rolloff_bz, 'g', 'LineWidth', 2);
plot(field_parms.y_rolloff_y, field_parms.y_rolloff_bx, 'b', 'LineWidth', 2);
plot(field_parms.y_rolloff_y, field_parms.y_rolloff_by, 'r', 'LineWidth', 2);
xlabel('Vertical Y Position [mm]');
ylabel('Field Amplitude [T]');
legend({'Bz','Bx','By'});

function save_plots(label)

% grava figuras
hds = get(0, 'Children');
for i=1:length(hds);
    name = get(hds(i), 'Name');
    if isempty(name), name = ['Fig ' num2str(hds(i))]; end;
    saveas(hds(i), [label ' - ' name '.fig']);
end

