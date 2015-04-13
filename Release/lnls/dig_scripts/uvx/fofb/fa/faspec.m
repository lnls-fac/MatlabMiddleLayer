function haxis_out = faspec(data, graph_type, selected_bpm, window, color, log, dataset_name, haxis, spectra_range, freq_range)
% haxis_out = fofb_fa_plot_spectrum_bpm(data, graph_type, selected_bpm, window, color, log, dataset_name, haxis, spectra_range, freq_range)

time = double(data.time-data.time(1))/1e9; % seconds, relative time
Fs = 1/mean(double(diff(time)));

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
nbpm = size(data.bpm_readings,2)/2;

if (nargin < 3) || isempty(selected_bpm)
    selected_bpm = 1:nbpm;
end

selected_readings = zeros(1, 2*length(selected_bpm));
selected_readings(1:2:end) = selected_bpm;
selected_readings(2:2:end) = selected_bpm + nbpm;
n_selected_readings = length(selected_readings);

% Convert BPM data from mm to um
selected_signals = 1e3*data.bpm_readings(:, selected_readings);
selected_bpm_names = data.bpm_names(selected_readings);

if (nargin < 2)
    graph_type = 'dft';
end

if (nargin < 4)
    window = [];
end

if (nargin < 5)
    color = [];
end

if (nargin < 6)
    log = [];
end

if (nargin < 7) || isempty(dataset_name)
    dataset_name = [];
end

if (nargin < 8) || isempty(haxis)
    haxis = zeros(n_selected_readings, 1);
    for i = 1:n_selected_readings/2
        fig = figure;

        haxis(2*i-1) = subplot(211);
        haxis(2*i) = subplot(212);

        linkaxes(haxis([(2*i-1) (2*i)]), 'x');

        set(fig, 'Name', [selected_bpm_names{2*i-1} ' - ' selected_bpm_names{2*i}], 'NumberTitle', 'off');
        set(fig, 'WindowStyle', 'docked');
    end
end

if (nargin < 9)
    spectra_range = [];
end

if (nargin < 10)
    freq_range = [];
end

% ===========
% Plot graphs
% ===========
if (nargin < 1) || isempty(selected_signals)
    spectra = [];
    freq = [];
    spectrum_ylabel = [];
elseif strcmpi(graph_type, 'dft')
    [spectra, freq] = fourierseries(selected_signals, Fs, window);
    spectrum_ylabel = 'Amplitude (um)';
elseif strcmpi(graph_type, 'psd')
    [spectra, freq] = psdrms(selected_signals, Fs, 0, Inf, window, [], [], graph_type);
    spectrum_ylabel = 'PSD (um/sqrt(Hz))';
elseif strcmpi(graph_type, 'rms')
    [spectra, freq] = psdrms(selected_signals, Fs, 0, Inf, window, [], [], graph_type);
    spectrum_ylabel = 'Integrated RMS (um)';
else
    error('Invalid value for ''graph_type'' parameter.');
end

haxis_out = multiplot(freq, spectra, freq_range, spectra_range, color, log, 'Frequency (Hz)', spectrum_ylabel, selected_bpm_names, dataset_name, haxis);
