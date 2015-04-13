function fofb_fa_plot_bpm_ps(data, selected_bpms, selected_ps, bpm_visualization_offset, ps_visualization_offset)
% fofb_fa_plot_bpm_ps(data, selected_bpms, selected_ps, bpm_visualization_offset, ps_visualization_offset)

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
n_bpms = size(data.bpm_readings,2)/2;
if nargin < 2 || isempty(selected_bpms)
    selected_bpms = 1:n_bpms;
end
selected_bpm_readings = [selected_bpms selected_bpms+n_bpms];
n_selected_bpms = length(selected_bpms);

n_ps = size(data.ps_readings,2);
if nargin < 2 || isempty(selected_ps)
    selected_ps = 1:n_ps;
end
n_selected_ps = length(selected_ps);

% ===================
% Preparation of data
% ===================

if nargin < 4
    bpm_visualization_offset = 50;
end

if nargin < 5
    ps_visualization_offset = 50;
end

if(~isempty(data.bpm_readings)) 
    % Convert BPM data from mm to um
    bpm_readings = 1e3*data.bpm_readings;
    
    offset_bpm_readings = ((0:n_selected_bpms-1) - floor(n_selected_bpms/2))*bpm_visualization_offset;
    offset_bpm_readings = [offset_bpm_readings offset_bpm_readings];
    
    % Remove DC component
    bpm_dc = mean(bpm_readings(:, selected_bpm_readings));
    bpm_ac = bpm_readings - repmat(bpm_dc + offset_bpm_readings, size(bpm_readings, 1), 1);
end

if(~isempty(data.ps_readings))
    % Convert PS data from A to mA
    ps_readings = 1e3*data.ps_readings;
    ps_setpoints = 1e3*data.ps_setpoints;

    offset_ps = ((0:n_selected_ps-1) - floor(n_selected_ps/2))*ps_visualization_offset;
    
    % Remove DC component
    ps_dc = mean(ps_readings(:, selected_ps));
    ps_ac = ps_readings - repmat(ps_dc + offset_ps, size(ps_readings, 1), 1);
    ps_setpoints_ac = ps_setpoints - repmat(ps_dc + offset_ps, size(ps_setpoints, 1), 1);
end

% ===========
% Plot graphs
% ===========

if(~isempty(data.bpm_readings)) 
    fig = figure;
    set(fig, 'Name', 'Horizontal plane BPM readings');
    plot(data.time, bpm_ac(:, selected_bpms));
    xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
    ylabel('Position (\mum)','FontSize',12,'FontWeight','bold');
    title('Horizontal plane BPM readings','FontSize',12,'FontWeight','bold');
    legend(data.bpm_names(selected_bpms),'FontSize',8);
    ax = axis;
    axis([data.time(1) data.time(end) ax(3:4)]);
    set(gca, 'FontSize', 12);
    
    fig = figure;
    set(fig, 'Name', 'Vertical plane BPM readings');
    plot(data.time, bpm_ac(:, selected_bpms + n_selected_bpms));
    xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
    ylabel('Position (\mum)','FontSize',12,'FontWeight','bold');
    title('Vertical plane BPM readings','FontSize',12,'FontWeight','bold');
    legend(data.bpm_names(selected_bpms + n_bpms),'FontSize',8);
    ax = axis;
    axis([data.time(1) data.time(end) ax(3:4)]);
    set(gca, 'FontSize', 12);
end

if(~isempty(data.ps_readings))
    fig = figure;
    set(fig, 'Name', 'Power supplies readings');
    plot(data.time, ps_ac(:, selected_ps));
    hold on;
    plot(data.time, ps_setpoints_ac(:, selected_ps), '--');
    xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
    ylabel('Current (mA)','FontSize',12,'FontWeight','bold');
    title('Orbit corrector power supplies','FontSize',12,'FontWeight','bold');
    legend(data.ps_names(selected_ps),'FontSize',8);
    ax = axis;
    axis([data.time(1) data.time(end) ax(3:4)]);
    set(gca, 'FontSize', 12);
end