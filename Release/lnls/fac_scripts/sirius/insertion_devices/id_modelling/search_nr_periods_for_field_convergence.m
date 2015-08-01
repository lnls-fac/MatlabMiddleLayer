function nr_periods = search_nr_periods_for_field_convergence(id_def, nr_periods_init)

nr_periods = nr_periods_init;
id_model = create_id_model(id_def, nr_periods);
fs = calc_field(id_def, id_model);
while (true)
    nr_periods = nr_periods + 4;
    id_model = create_id_model(id_def, nr_periods);
    new_fs = calc_field(id_def, id_model);
    maxdiff = calc_max_diff(fs, new_fs);
    fprintf('nr_periods:%03i, maxdiff:%.4E\n', nr_periods, maxdiff);
    if (maxdiff < 1e-6) || (nr_periods >= id_def.nr_periods), break; end
    fs = new_fs;
end
nr_periods = min([nr_periods, id_def.nr_periods]);


function maxdiff = calc_max_diff(fs1, fs2)
    
b1 = fs1.on_axis_bx_max_abs_field; b2 = fs2.on_axis_bx_max_abs_field;
if abs(b1) > 1e-4
    dbx = abs((b2-b1)/b1);
else
    dbx = 0;
end
b1 = fs1.on_axis_by_max_abs_field; b2 = fs2.on_axis_by_max_abs_field;
if abs(b1) > 1e-4
    dby = abs((b2-b1)/b1);
else
    dby = 0;
end
b1 = fs1.on_axis_bz_max_abs_field; b2 = fs2.on_axis_bz_max_abs_field;
if abs(b1) > 1e-4
    dbz = abs((b2-b1)/b1);
else
    dbz = 0;
end
maxdiff = max([dbx, dby, dbz]);


function id_model = create_id_model(id_def, nr_periods) 

id_def.nr_periods = nr_periods; 
id_model = epu_create(id_def);


function fs = calc_field(id_def, id_model)

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

