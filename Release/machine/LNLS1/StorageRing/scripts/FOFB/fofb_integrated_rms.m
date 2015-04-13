function [signals_integrated_rms, freq] = fofb_integrated_rms(signals, time, remove_dc, window)
% [signals_integrated_rms, freq] = fofb_integrated_rms(signals, time, remove_dc, window)

[psd_result, freq] = fofb_psd(signals, time, remove_dc, window);

signals_integrated_rms = zeros(size(psd_result));
for i=1:size(psd_result,3)
    signals_integrated_rms(:,:,i) = sqrt(cumtrapz(freq, psd_result(:,:,i).^2));
end