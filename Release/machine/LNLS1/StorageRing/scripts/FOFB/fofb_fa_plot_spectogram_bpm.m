function fofb_fa_plot_spectogram_bpm(data, npts_interval, freq_range, selected_bpms)
% fofb_fa_plot_spectogram_bpm(data, npts_interval, freq_range, selected_bpms)

% Convert time from ms to seconds
time = data.time/1e3;

if (nargin < 2) || isempty(npts_interval)
    npts_interval = min(1000, ceil(length(time)/10));
end

[time_intervals_start_indexes, time_intervals_start] = fofb_time_intervals(time, npts_interval);

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
n_bpms = size(data.bpm_readings,2)/2;

if (nargin < 3) || isempty(freq_range)
    freq_range = [0 1/(time(2)-time(1))/2];
end

if (nargin < 4) || isempty(selected_bpms)
    selected_bpms = 1:n_bpms;
end

% ===================
% Preparation of data
% ===================
selected_readings = [selected_bpms selected_bpms+length(selected_bpms)];
n_selected_readings = length(selected_readings);

% Convert BPM data from mm to um
signals = 1e3*data.bpm_readings;

% Calculate FFT
[signals_fseries, freq] = fofb_fft(signals(:, selected_readings), time, time_intervals_start_indexes, npts_interval, 1, []);

% ===========
% Plot graphs
% ===========
for i = 1:n_selected_readings/2
    fig = figure;
    subplot(211)
    surf(freq, time_intervals_start, signals_fseries(:,:,i)','EdgeColor','none','LineStyle','none','FaceLighting','phong');
    view(0,90);
    axis([freq_range time_intervals_start([1 end])])
    set(gca, 'FontSize', 12);
    title(data.bpm_names{selected_readings(i)},'FontSize',12,'FontWeight','bold');
    ylabel('Time (s)','FontSize',12,'FontWeight','bold');  
    zlabel('Position (\mum)','FontSize',12,'FontWeight','bold');

    subplot(212)
    surf(freq, time_intervals_start, signals_fseries(:,:,i+n_selected_readings/2)','EdgeColor','none','LineStyle','none','FaceLighting','phong');
    view(0,90);
    axis([freq_range time_intervals_start([1 end])])
    set(gca, 'FontSize', 12);
    title(data.bpm_names{selected_readings(i)+n_bpms},'FontSize',12,'FontWeight','bold');
    ylabel('Time (s)','FontSize',12,'FontWeight','bold');  
    zlabel('Position (\mum)','FontSize',12,'FontWeight','bold');
    
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');    

    set(fig,'WindowStyle','docked');
    set(fig, 'Name', [data.bpm_names{selected_readings(i)} ' - ' data.bpm_names{selected_readings(i)+n_bpms}], 'NumberTitle', 'off');
end