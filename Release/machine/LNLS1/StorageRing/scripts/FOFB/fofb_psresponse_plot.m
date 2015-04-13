function fofb_psresponse_plot(data, normalized)
% fofb_psresponse_plot(data, normalized)

if nargin < 2
    normalized = 0;
end

if normalized
    npts = length(data.time);
    
    amplitude_before = repmat(data.ps_setpoints(1,:), npts, 1);
    amplitude_after = repmat(data.ps_setpoints(end,:), npts, 1);
    delta_amplitude = amplitude_after - amplitude_before;

    data.ps_readings = (data.ps_readings - amplitude_before)./delta_amplitude;
    data.ps_setpoints = (data.ps_setpoints - amplitude_before)./delta_amplitude;
    
    unit = 'normalized';
else
    unit = 'A';
end

figure
hold on
plot(data.time, data.ps_readings)
plot(data.time, data.ps_setpoints, '--')
ax = axis;
axis([data.time(1) data.time(end) ax(3:4)]);
xlabel('Time (ms)', 'FontSize', 14)
ylabel(sprintf('Current (%s)', unit), 'FontSize', 14)
legend(data.ps_names, 'FontSize', 8)
grid on