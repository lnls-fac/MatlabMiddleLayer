close all;

%load('\\centaurus\Repositorio\Grupos\DIG\Projetos\Ativos\DT_FOFB\LNLS\Experimentos\Aquisição rápida\fadata_20110528_20h50.mat', 'data');
%load('\\centaurus\Repositorio\Grupos\DIG\Projetos\Ativos\DT_FOFB\LNLS\Experimentos\Aquisição rápida\fadata_20110527_12h56.mat', 'data');

% Selected time intervals
%time_intervals = [0 4650];% 4670 6215];
%time_intervals = [];

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
%amplitude_range = [0 400];
amplitude_range = [1e-4 30];

% Selector for log plot (only Y axis)
log = 1;

psd_window = hann(2496);

% Sample time
Ts = data.time(2)-data.time(1);

% Sampling frequency (Hz)
Fs = 1000/Ts;

% Convert BPM data from mm to um
bpm_position = 1e3*data.orb;

bpm_position_psd = cell(size(time_intervals_indexes,1),1);
bpm_position_integrated_rms = cell(size(time_intervals_indexes,1),1);
time_intervals_labels = cell(size(time_intervals_indexes,1),1);
for i=1:size(time_intervals_indexes,1)
    time_interval_index = time_intervals_indexes(i,1):time_intervals_indexes(i,2);
    
    % Remove DC component
    bpm_position_dc = mean(bpm_position(time_interval_index,:));
    bpm_position_ac = bpm_position(time_interval_index,:) - repmat(bpm_position_dc, length(time_interval_index), 1);    
    
    % Compute PSD
    aux = zeros(size(bpm_position_ac));
    for j=1:size(bpm_position_ac,2)
        aux(:,j) = pwelch(bpm_position_ac(:,j),psd_window,[],size(bpm_position_ac,1),Fs,'twosided');
    end       
    bpm_position_psd{i}= aux;
    bpm_position_integrated_rms{i}= sqrt(cumtrapz(aux)*Ts);

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
    
    subplot(221);
    for j=1:size(time_intervals_indexes,1)
        bpm_position_psd_ = bpm_position_psd{j};
        f = linspace(0,Fs,size(bpm_position_psd_,1));
        if log
            semilogy(f, bpm_position_psd_(:,i), 'Color', colors(j,:));
        else
            plot(f, bpm_position_psd_(:,i), 'Color', colors(j,:));
        end
        hold on;
    end
    if size(time_intervals_indexes,1) > 1
         legend(time_intervals_labels,  'FontSize', 8);
    end
    axis([freq_range amplitude_range.^2]);
    grid on;
    title(data.bpm_names{i},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position PSD (um^2/Hz)','FontSize',12,'FontWeight','bold');

    
    subplot(222);
    for j=1:size(time_intervals_indexes,1)
        bpm_position_integrated_rms_ = bpm_position_integrated_rms{j};
        f = linspace(0,Fs,size(bpm_position_integrated_rms_,1));
        plot(f, bpm_position_integrated_rms_(:,i), 'Color', colors(j,:));
        hold on;
    end
    axis([freq_range amplitude_range]);
    grid on;
    title(data.bpm_names{i},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position RMS (um)','FontSize',12,'FontWeight','bold');

    
    subplot(223)
    for j=1:size(time_intervals_indexes,1)
        bpm_position_psd_ = bpm_position_psd{j};
        f = linspace(0,Fs,size(bpm_position_psd_,1));
        if log
            semilogy(f, bpm_position_psd_(:,i+n_bpms), 'Color', colors(j,:));
        else
            plot(f, bpm_position_psd_(:,i+n_bpms), 'Color', colors(j,:));
        end
        hold on;
    end
    axis([freq_range amplitude_range.^2]);
    grid on;
    title(data.bpm_names{i+n_bpms},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position PSD (um^2/Hz)','FontSize',12,'FontWeight','bold');

    
    subplot(224);
    for j=1:size(time_intervals_indexes,1)
        bpm_position_integrated_rms_ = bpm_position_integrated_rms{j};
        f = linspace(0,Fs,size(bpm_position_integrated_rms_,1));
        plot(f, bpm_position_integrated_rms_(:,i+n_bpms), 'Color', colors(j,:));
        hold on;
    end
    axis([freq_range amplitude_range]);
    grid on;
    title(data.bpm_names{i+n_bpms},'FontSize',12,'FontWeight','bold');
    xlabel('Frequency (Hz)','FontSize',12,'FontWeight','bold');
    ylabel('Position RMS (um)','FontSize',12,'FontWeight','bold');

end