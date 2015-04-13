function faplot(data, mode, selected_bpm, selected_corr)

start_time = fatimelvrt2m(data.time(1));
time = double(data.time-data.time(1))/1e9; % relative time [s]

if nargin < 2 || isempty(mode)
    mode = '';
end

nbpm = size(data.bpm_readings,2)/2;
if nargin < 3 || isempty(selected_bpm)
    selected_bpm = 1:nbpm;
elseif selected_bpm == 0
    selected_bpm = [];
end
selected_bpm_readings = [selected_bpm (selected_bpm+nbpm)];
nselected_bpm = length(selected_bpm);

ncorr = size(data.corr_readings,2);
if nargin < 4 || isempty(selected_corr)
    selected_corr = 1:ncorr;
elseif selected_corr == 0
    selected_corr = [];
end
nselected_corr = length(selected_corr);

% Prepare data
bpm_visualization_offset = 50;
corr_visualization_offset = 50;

% Convert BPM data from mm to um
bpm_readings = double(1e3*data.bpm_readings(:, selected_bpm_readings));

% Convert corrector power supply data from A to mA
corr_readings = double(1e3*data.corr_readings(:, selected_corr));
corr_setpoints = double(1e3*data.corr_setpoints(:, selected_corr));

if strcmpi(mode, 'relative')
    if ~isempty(data.bpm_readings)
        offset_bpm_readings = ((0:nselected_bpm-1) - floor(nselected_bpm/2))*bpm_visualization_offset;
        offset_bpm_readings = [offset_bpm_readings offset_bpm_readings];
        bpm_dc = mean(bpm_readings);
        bpm_readings = bpm_readings - repmat(bpm_dc + offset_bpm_readings, size(bpm_readings, 1), 1);
    end
    
    if ~isempty(data.corr_readings)
        offset_corr = ((0:nselected_corr-1) - floor(nselected_corr/2))*corr_visualization_offset;
        corr_dc = mean(corr_readings);
        corr_setpoints_dc = mean(corr_setpoints);
        corr_readings = corr_readings - repmat(corr_dc + offset_corr, size(corr_readings, 1), 1);
        corr_setpoints = corr_setpoints - repmat(corr_setpoints_dc + offset_corr, size(corr_setpoints, 1), 1);
    end
    
    force_legend = true;
else
    force_legend = false;
end

bpmh_names = data.bpm_names(selected_bpm);
bpmv_names = data.bpm_names(selected_bpm+nbpm);
corr_names = data.corr_names(selected_corr);

% ===========
% Plot graphs
% ===========
hax1 = [];
hax2 = [];
hax3 = [];
if ~isempty(bpm_readings)
    hax1 = plotvar(bpm_readings(:, 1:end/2), [], time, 'Beam position (horizontal plane)', bpmh_names, 'um', start_time, force_legend);
    hax2 = plotvar(bpm_readings(:, end/2+1:end), [], time, 'Beam position (vertical plane)', bpmv_names, 'um', start_time, force_legend);
end

if ~isempty(corr_readings)
    hax3 = plotvar(corr_readings, corr_setpoints, time, 'Orbit correctors'' power supplies', corr_names, 'mA', start_time, force_legend);
end

linkaxes([hax1 hax2 hax3],'x');

function hax = plotvar(var_values, setpoint_values, time, plot_name, var_names, unit, start_time, force_legend)

hfig = figure;
set(hfig, 'Name', plot_name);
hplots = plot(time, var_values);
hold on
if ~isempty(setpoint_values)
    hplot_setpoint = plot(time, setpoint_values, '--');
end
xlabel({'Time (s)',sprintf('Start time = %s', fatimestr(start_time))},'FontSize',12,'FontWeight','bold');
ylabel(unit,'FontSize',12,'FontWeight','bold');
title(plot_name,'FontSize',12,'FontWeight','bold');
ax = axis;
axis([time(1) time(end) ax(3:4)]);
set(gca, 'FontSize', 12);
grid on

if length(var_names) < 8 || (nargin > 7 && force_legend)
    legend(var_names,'FontSize',8);
end

for i=1:length(hplots)
    userdata.name = var_names{i};
    userdata.unit = unit;
    set(hplots(i), 'UserData', userdata);
    
    if ~isempty(setpoint_values)
        userdata_setpoint = userdata;
        userdata_setpoint.name = [userdata_setpoint.name ' (setpoint)'];
        set(hplot_setpoint(i), 'UserData', userdata_setpoint);
    end
end
dcm_obj = datacursormode(hfig);
set(dcm_obj,'enable','on')
set(dcm_obj,'UpdateFcn', @update_datatip)

hax = get(hplots(1), 'Parent');

function outtxt = update_datatip(obj, event_obj)

userdata = get(get(event_obj,'Target'), 'UserData');
pos = get(event_obj,'Position');
outtxt = {sprintf([userdata.name ': %0.3f %s'], pos(2), userdata.unit), sprintf('Time: %0.3f ms', pos(1)*1e3)};
