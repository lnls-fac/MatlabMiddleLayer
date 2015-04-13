function [signals_psd, freq] = fofb_psd(signals, time, remove_dc, window)
% [signals_psd, freq] = fofb_psd(signals, time, remove_dc, window)

% Sampling frequency
Fs = 1/(time(2)-time(1));

npts = length(time);

if remove_dc
    signals_dc = mean(signals);
    signals_ = signals - repmat(signals_dc, npts, 1);
else
    signals_ = signals(time_interval_index, :);
end

% Compute PSD
for j=1:size(signals, 2)
    %[signals_psd(:,1,j), freq] = pwelch(signals_(:,j), window, floor(0.5*npts), min(floor(10*Fs), floor(Fs*floor(npts/Fs))), Fs);
    [signals_psd(:,1,j), freq] = pwelch(signals_(:,j), window, [], [], Fs);
    signals_psd(:,1,j) = sqrt(signals_psd(:,1,j));
end