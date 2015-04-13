function fofb_fa_plot_spatial_spectogram_bpm(data, freq_range)
% fofb_fa_plot_spatial_spectogram_bpm(data, freq_range)

% Convert time from ms to seconds
time = data.time/1e3;

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
n_bpms = size(data.bpm_readings,2)/2;

if (nargin < 2) || isempty(freq_range)
    freq_range = [0 1/(time(2)-time(1))/2];
end

% ===================
% Preparation of data
% ===================

% Convert BPM data from mm to um
signals = 1e3*data.bpm_readings;

% Calculate FFT
[signals_fseries, freq] = fofb_fft(signals, time, [], [], 1, []);

selected_indexes = 1:size(signals_fseries,1);
selected_indexes = selected_indexes((freq >= freq_range(1)) & (freq <= freq_range(2)));

signals_fseries = signals_fseries(selected_indexes,:,:);
freq = freq(selected_indexes);

% ===========
% Plot graphs
% ===========
aux = regexp(data.bpm_names(1:n_bpms),'(AMP)|(AMU)','split');
bpm_names_stripped = cell(n_bpms, 1);
for i=1:n_bpms
    aux2 = regexp(aux{i}(end), 'H|V', 'split');
    bpm_names_stripped{i} = aux2{1}{1};
end

fig = figure;
surf(freq, 1:n_bpms, squeeze(signals_fseries(:,1,1:n_bpms))','EdgeColor','none');
axis([freq_range [1 n_bpms]]);
view(10, 50);
set(gca, 'XTick', 0:min(floor(freq_range(end)/3),60):freq_range(end));
set(gca, 'XMinorTick', 'on');
set(gca, 'YTick', 1:n_bpms);
set(gca, 'YTickLabel', bpm_names_stripped);
set(gca, 'FontSize', 12);
title('Horizontal plane', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('BPM', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('Position (\mum)', 'FontSize', 12, 'FontWeight', 'bold');
set(fig, 'Name', 'Horizontal plane spatial spectogram', 'NumberTitle', 'off');
set(fig,'WindowStyle','docked');

fig = figure;
surf(freq, 1:n_bpms, squeeze(signals_fseries(:,1,n_bpms+1:2*n_bpms))','EdgeColor','none');
axis([freq_range [1 n_bpms]]);
view(10, 50);
set(gca, 'XTick', 0:min(floor(freq_range(end)/3),60):freq_range(end));
set(gca, 'XMinorTick', 'on');
set(gca, 'YTick', 1:n_bpms);
set(gca, 'YTickLabel', bpm_names_stripped);
set(gca, 'FontSize', 12);
title('Vertical plane', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('BPM', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('Position (\mum)', 'FontSize', 12, 'FontWeight', 'bold');
set(fig, 'Name', 'Vertical plane spatial spectogram', 'NumberTitle', 'off');
set(fig,'WindowStyle','docked');