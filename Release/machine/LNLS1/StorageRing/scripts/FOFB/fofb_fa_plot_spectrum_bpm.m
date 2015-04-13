function haxis_out = fofb_fa_plot_spectrum_bpm(data, graph_type, amplitude_range, freq_range, selected_bpms, window_fcn, color, log, dataset_name, haxis)
% haxis_out = fofb_fa_plot_spectrum_bpm(data, graph_type, amplitude_range, freq_range, selected_bpms, window_fcn, color, log, dataset_name, haxis)

% Convert time from ms to seconds
time = data.time/1e3;

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
n_bpms = size(data.bpm_readings,2)/2;

if (nargin < 5) || isempty(selected_bpms)
    selected_bpms = 1:n_bpms;
end

selected_readings = zeros(1, 2*length(selected_bpms));
selected_readings(1:2:end) = selected_bpms;
selected_readings(2:2:end) = selected_bpms + n_bpms;
n_selected_readings = length(selected_readings);

% Convert BPM data from mm to um
selected_signals = 1e3*data.bpm_readings(:, selected_readings);
selected_bpm_names = data.bpm_names(selected_readings);

if nargin < 2
    graph_type = 'fft';
end

if (nargin < 3)
    amplitude_range = [];
end

if (nargin < 4) || isempty(freq_range)
    freq_range = [0 1/(time(2)-time(1))/2];
end

if (nargin < 6)
    window_fcn = [];
end

if (nargin < 7)
    color = [];
end

if (nargin < 8)
    log = [];
end

if (nargin < 9) || isempty(dataset_name)
    dataset_name = [];
end

% ===========
% Plot graphs
% ===========

if (nargin < 10) || isempty(haxis)
    haxis = zeros(n_selected_readings, 1);
    for i = 1:n_selected_readings/2
        fig = figure;

        haxis(2*i-1) = subplot(211);
        haxis(2*i) = subplot(212);

        set(fig, 'Name', [selected_bpm_names{2*i-1} ' - ' selected_bpm_names{2*i}], 'NumberTitle', 'off');
        set(fig, 'WindowStyle', 'docked');
    end
end

haxis_out = fofb_plot_spectrum(selected_signals, time, graph_type, amplitude_range, freq_range, window_fcn, color, log, selected_bpm_names, '\mum', dataset_name, haxis);