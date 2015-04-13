function faspspecgram(data)

time = double(data.time-data.time(1))/1e9; % seconds, relative time

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
nbpm = size(data.bpm_readings,2)/2;

% Convert BPM data from mm to um
signals = double(1e3*data.bpm_readings);

% Calculate FFT
[spectra, freq] = psdrms(signals, 1/mean(diff(time)), 10, 500, [], [], [], 'psd');

spectra = 20*log10(spectra);

% ===========
% Plot graphs
% ===========
aux = regexp(data.bpm_names(1:nbpm),'(AMP)|(AMU)','split');
bpm_names_stripped = cell(nbpm, 1);
for i=1:nbpm
    aux2 = regexp(aux{i}(end), 'H|V', 'split');
    bpm_names_stripped{i} = aux2{1}{1};
end

fig = figure;
surf(freq, 1:nbpm, squeeze(spectra(:,1:nbpm))','EdgeColor','none');
view(10, 50);
set(gca, 'XTick', 0:min(floor(freq(end)/3),60):freq(end));
set(gca, 'XMinorTick', 'on');
set(gca, 'YTick', 1:nbpm);
set(gca, 'YTickLabel', bpm_names_stripped);
set(gca, 'FontSize', 12);
title('Horizontal plane', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('BPM', 'FontSize', 12, 'FontWeight', 'bold');
set(fig,'Name', 'Horizontal plane spatial spectogram', 'NumberTitle', 'off');
set(fig,'WindowStyle','docked');

fig = figure;
surf(freq, 1:nbpm, squeeze(spectra(:,nbpm+1:2*nbpm))','EdgeColor','none');
view(10, 50);
set(gca, 'XTick', 0:min(floor(freq(end)/3),60):freq(end));
set(gca, 'XMinorTick', 'on');
set(gca, 'YTick', 1:nbpm);
set(gca, 'YTickLabel', bpm_names_stripped);
set(gca, 'FontSize', 12);
title('Vertical plane', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('BPM', 'FontSize', 12, 'FontWeight', 'bold');
set(fig,'Name', 'Vertical plane spatial spectogram', 'NumberTitle', 'off');
set(fig,'WindowStyle','docked');
