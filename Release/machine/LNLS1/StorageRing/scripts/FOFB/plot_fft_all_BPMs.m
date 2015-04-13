%close all;

%load('\\centaurus\Repositorio\Grupos\DIG\Projetos\Ativos\DT_FOFB\LNLS\Experimentos\Aquisição rápida\fadata_20110528_20h50.mat', 'data');

% Selected time intervals
%time_intervals = [0 4650; 4670 6215];
time_intervals = [];

if ~exist('time_intervals','var') || isempty(time_intervals) || all(all(time_intervals == 0))
    time_intervals = [data.time(1) data.time(end)];
end

time_intervals_indexes = zeros(size(time_intervals));
for i=1:size(time_intervals,1)
   aux1 = find(data.time >= time_intervals(i,1));
   aux2 = find(data.time <= time_intervals(i,2));
   
   time_intervals_indexes(i,1:2) = [aux1(1) aux2(end)];
end

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
n_bpms = size(data.orb,2)/2;

% Selected BPM indexes
selected_bpms = 1:n_bpms;

% Frequency range (Hz) (for visualization)
freq_range = [0 1000];

% Frequency range (um) (for visualization)
%amplitude_range = [0 20];
amplitude_range = [1e-4 1e1];

% Selector for log plot (only Y axis)
log = 1;

% Threshold of relevant position disturbance (um)
disturbance_threshold = 0;

% Sample time
Ts = data.time(2)-data.time(1);

% Sampling frequency (Hz)
Fs = 1000/Ts;

% Convert BPM data from mm to um
bpm_position = 1e3*data.orb;

bpm_position_fft = cell(size(time_intervals_indexes,1),1);
time_intervals_labels = cell(size(time_intervals_indexes,1),1);
for i=1:size(time_intervals_indexes,1)
    time_interval_index = time_intervals_indexes(i,1):time_intervals_indexes(i,2);
    
    % Remove DC component
    bpm_position_dc = mean(bpm_position(time_interval_index,:));
    bpm_position_ac = bpm_position(time_interval_index,:) - repmat(bpm_position_dc, length(time_interval_index), 1);    
    
    % Apply windowing on data for FFT
    bpm_position_ac_windowed = bpm_position_ac.*repmat(hann(size(bpm_position_ac,1)), 1,  size(bpm_position_ac,2));
    
    % Compute FFT
    bpm_position_fft{i} = 2/size(bpm_position_ac_windowed,1)*abs(fft(bpm_position_ac_windowed));
     
    time_intervals_labels{i} = [num2str(round(data.time(time_interval_index(1)))) ' \leq t \leq ' num2str(round(data.time(time_interval_index(end))))];
end

if size(time_intervals_indexes,1) == 1
    colors = 'b';
else
    colors = copper(size(time_intervals_indexes,1));
end

for i=selected_bpms
    fig = figure;
    set(fig,'Name',[data.bpm_names{i} ' - ' data.bpm_names{i+25}],'NumberTitle','off');
    
    subplot(211);
    for j=1:size(time_intervals_indexes,1)
        bpm_position_fft_ = bpm_position_fft{j};
        f = linspace(0,Fs,size(bpm_position_fft_,1));
        if log
            semilogy(f, bpm_position_fft_(:,i), 'Color', colors(j,:));
        else
            plot(f, bpm_position_fft_(:,i), 'Color', colors(j,:));
        end
        hold on;
    end
    if size(time_intervals_indexes,1) > 1
         legend(time_intervals_labels,  'FontSize', 8);
    end
    axis([freq_range amplitude_range])
    if disturbance_threshold > 0
        hold on;
        plot([0 Fs], disturbance_threshold*[1 1], 'r--')
    end
    grid on;
    title(data.bpm_names{i},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position (um)','FontSize',12,'FontWeight','bold');

    subplot(212)
    for j=1:size(time_intervals_indexes,1)
        bpm_position_fft_ = bpm_position_fft{j};
        f = linspace(0,Fs,size(bpm_position_fft_,1));
        if log
            semilogy(f, bpm_position_fft_(:,i+n_bpms), 'Color', colors(j,:));
        else
            plot(f, bpm_position_fft_(:,i+n_bpms), 'Color', colors(j,:));
        end
        hold on;
    end
    axis([freq_range amplitude_range])
    if disturbance_threshold > 0
        hold on;
        plot([0 Fs], disturbance_threshold*[1 1], 'r--')
    end
    grid on;
    title(data.bpm_names{i+25},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position (um)','FontSize',12,'FontWeight','bold');    
end