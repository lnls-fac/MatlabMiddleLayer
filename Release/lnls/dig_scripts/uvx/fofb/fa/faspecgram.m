function faspecgram(data, npts_interval, freq_range, selected_bpm)

time = double(data.time-data.time(1))/1e9; % seconds, relative time
Fs = 1/mean(double(diff(time)));

if (nargin < 2) || isempty(npts_interval)
    npts_interval = min(1000, ceil(length(time)/10));
end

if (nargin < 3) || isempty(freq_range)
    freq_range = [0 Fs];
end

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
nbpm = size(data.bpm_readings,2)/2;
if (nargin < 4) || isempty(selected_bpm)
    selected_bpm = 1:nbpm;
end

% ===================
% Preparation of data
% ===================
selected_readings = [selected_bpm selected_bpm+length(selected_bpm)];
nselected_readings = length(selected_readings);

% Convert BPM data from mm to um
signals = double(1e3*data.bpm_readings);

npts = size(signals,1);


% Calculate FFT
for i=1:nselected_readings
    signal = signals(:, selected_readings(i));
    ntime = floor(npts/npts_interval);
    signal = reshape(signal(1:ntime*npts_interval), npts_interval, ntime);

    [spectra, freq] = fourierseries(signal, Fs);
    signals_fseries(:,:,i) = spectra;
end

time_intervals_start = time(1:npts_interval:(npts_interval*size(signals_fseries,2)));
signals_fseries = 20*log10(signals_fseries);

% ===========
% Plot graphs
% ===========
for i = 1:nselected_readings/2
    fig = figure;
    subplot(211)
    surf(freq, time_intervals_start, signals_fseries(:,:,i)','EdgeColor','none','LineStyle','none','FaceLighting','phong');
    view(0,90);
    axis([freq_range time_intervals_start([1 end])'])
    set(gca, 'FontSize', 12);
    title(data.bpm_names{selected_readings(i)},'FontSize',12,'FontWeight','bold');
    ylabel('Time (s)','FontSize',12,'FontWeight','bold');
    zlabel('dB','FontSize',12,'FontWeight','bold');

    subplot(212)
    surf(freq, time_intervals_start, signals_fseries(:,:,i+nselected_readings/2)','EdgeColor','none','LineStyle','none','FaceLighting','phong');
    view(0,90);
    axis([freq_range time_intervals_start([1 end])'])
    set(gca, 'FontSize', 12);
    title(data.bpm_names{selected_readings(i)+nbpm},'FontSize',12,'FontWeight','bold');
    ylabel('Time (s)','FontSize',12,'FontWeight','bold');
    zlabel('dB','FontSize',12,'FontWeight','bold');

    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');

    set(fig,'WindowStyle','docked');
    set(fig, 'Name', [data.bpm_names{selected_readings(i)} ' - ' data.bpm_names{selected_readings(i)+nbpm}], 'NumberTitle', 'off');
end
