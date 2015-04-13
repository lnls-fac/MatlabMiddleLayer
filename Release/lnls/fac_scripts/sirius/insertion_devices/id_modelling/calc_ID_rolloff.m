function calc_ID_rolloff(id_def)

% cleanup
%clc; fclose('all'); close('all');
addpath('epu');

% ID basic parameters
if ~exist('id_def','var')
    ids = ID_definitions();
    %id_def = ids.SCW3T;
    %id_def = ids.W2T;
    %id_def = ids.U18;
    %id_def = ids.EPU50_PH;
    %id_def = ids.EPU50_PC;
    %id_def = ids.EPU50_PV;
    %id_def = ids.EPU200_PH;
    %id_def = ids.EPU200_PC;
    %id_def = ids.EPU200_PV;
    id_def = ids.UTEST;
end

% turns diary mode on
diary off;
diary_fname = [id_def.id_label ' - ID-SUMMARY.txt'];
if exist(diary_fname, 'file'), delete(diary_fname); end;
diary(diary_fname);


% created 3d model of the insertion device
id_model = epu_create(id_def);

% calcs basic field parameters
field_parms = get_field_summary(id_def, id_model);

x = linspace(0,1,10);
for i=1:length(x)
    rolloff(i) = (interp1(field_parms.x, field_parms.by, x(i) + 0.2) - interp1(field_parms.x, field_parms.by, x(i))) / interp1(field_parms.x, field_parms.by, x(i));
end
figure; plot(x, 1e6*rolloff); xlabel('Horizontal eBeam Offset [mm]'); ylabel('200 um Rolloff [ppm]');
title('Horizontal Rolloff of B_y for the SSRL Undulator [block height = 30 mm]');



function fs = get_field_summary(id_def, id_model)

nr_pts_longitudinal_z = 65;

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
x = 2 * linspace(0,1,50);
fs.x = x;
pos = zeros(3,length(x)); pos(1,:) = x;

% -by-
pos(2,:) = fs.on_axis_by_max_abs_z;
field = epu_field(id_model, pos);
fs.by = field(3,:);
