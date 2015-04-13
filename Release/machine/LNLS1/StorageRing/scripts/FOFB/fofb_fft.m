function [signals_fseries, freq, time_intervals_labels] = fofb_fft(signals, time, time_intervals_start_indexes, npts_interval, remove_dc, window)
% [signals_fseries, freq, time_intervals_labels] = fofb_fft(signals, time, time_intervals_start_indexes, npts_interval, remove_dc, window)

if isempty(time_intervals_start_indexes)
    time_intervals_start_indexes = 1;
end

if isempty(npts_interval)
    npts_interval = length(time);
end

% Sampling frequency
Fs = 1/(time(2)-time(1));

freq = linspace(0, Fs, npts_interval+1);
freq = freq(1:end-1);

n_intervals = length(time_intervals_start_indexes);

signals_fseries = zeros(npts_interval, n_intervals, size(signals, 2));
time_intervals_labels = cell(n_intervals, 1);
for i=1:length(time_intervals_start_indexes)
    time_interval_index = time_intervals_start_indexes(i)+(0:npts_interval-1);
    npts = time_interval_index(end)-time_interval_index(1)+1;
    
    if remove_dc
        signals_dc = mean(signals(time_interval_index, :));
        signals_ = signals(time_interval_index, :) - repmat(signals_dc, length(time_interval_index), 1);
    else
        signals_ = signals(time_interval_index, :);
    end
    
    % Windowing
    if isempty(window)
        signals_windowed = signals_;
    else
        signals_windowed = signals_.*repmat(window, 1,  size(signals_,2));
    end
    
    % Compute FFT and convert to Fourier series
    fft_result = abs(fft(signals_windowed));
    signals_fseries(:,i,:) = 1/npts*[fft_result(1,:); 2*fft_result(2:end,:)];
     
    time_intervals_labels{i} = [num2str(round(time(time_interval_index(1)))) ' \leq t \leq ' num2str(round(time(time_interval_index(end))))];
end