function system_freqresp(config, controller_config, plane)

w = warning('off', 'Control:ltiobject:UseSSforInternalDelay');
UseSSforInternalDelay_state = w.state;
w = warning('off', 'Control:analysis:MarginUnstable');
MarginUnstable_state = w.state;

% Controller sample time
Ts = 1/config.ps_update_rate;

% Power supply (second-order model)
ps_damping = config.ps_response_damping_factor;
ps_natural_frequency = 4/ps_damping/config.ps_response_time; % rad/s

% Vacuum chamber bandwidth (first-order model)
if strcmpi(plane,'H')
    vac_cutoff = config.vac_cutoff_H; %Hz
    plane = 'Horizontal';
elseif strcmpi(plane,'V')
    vac_cutoff = config.vac_cutoff_V; %Hz
    plane = 'Vertical';
end

% Delays
total_latency = config.delay_measurement + config.delay_processing + config.delay_actuation; % s

% BPM electronics bandwidth (two-pole discrete Butterworth filter)
[num, den] = butter(2, 2*config.bpm_bandwidth/config.bpm_sampling_rate, 'low'); 

% Build each subsystem's transfer function
bpm_electronics = c2d(d2c(tf(num, den, 1/config.bpm_sampling_rate)), Ts, 'zoh');
power_supply = tf(ps_natural_frequency^2,[1 2*ps_damping*ps_natural_frequency ps_natural_frequency^2]);
vacuum_chamber = tf(1,[1/2/pi/vac_cutoff 1]);
actuator = c2d(tf(1,1,'ioDelay',total_latency)*power_supply*vacuum_chamber, Ts, 'zoh');
[ctrl_num, ctrl_den] = generate_contoller(controller_config, Ts);
controller = tf(ctrl_num, ctrl_den, Ts);

% Calculate open-loop, closed-loop and disturbance rejection transfer functions
open_loop = actuator*controller*bpm_electronics;
closed_loop = feedback(open_loop,1);
disturbance_rejection = feedback(1,open_loop);

% Define frequency range to be evaluated and frequency range for plotting
frequency = logspace(log10(min(0.01, 1/Ts/2/2/1000)), log10(1/Ts/2), 1000);
frequency_plot_range = [min(0.1, 1/Ts/2/2/100) 1/Ts/2];

% Calculate open-loop frequency response (magnitude and phase)
[mag_open_loop, phase_open_loop] = bode(open_loop, 2*pi*frequency);
mag_open_loop = squeeze(mag_open_loop);
phase_open_loop = squeeze(phase_open_loop);
[Gm,Pm,Wcg,Wcp] = margin(open_loop);

% Calculate closed-loop frequency response (magnitude)
mag_closed_loop = squeeze(bode(closed_loop, 2*pi*frequency));

% Calculate disturbance rejection transfer function (magnitude)
mag_disturbance_rejection = squeeze(bode(disturbance_rejection, 2*pi*frequency));

% Find maximum disturbance amplification
[max_disturbance_amplification, index_max_disturbance_amplification] = max(mag_disturbance_rejection);
index_disturbance_amplification = find(mag_disturbance_rejection > 1);

% Find disturbace attenuation-amplification boundaries (frequencis for each the disturbance rejection, in dB, changes its signal)
attenuation_crossing_points = index_disturbance_amplification((index_disturbance_amplification(2:end)-index_disturbance_amplification(1:end-1))~=1);
if ~isempty(index_disturbance_amplification)
    if index_disturbance_amplification(1) > 1
        attenuation_crossing_points = [index_disturbance_amplification(1); attenuation_crossing_points];
    end
    if index_disturbance_amplification(end) < length(mag_disturbance_rejection)
        attenuation_crossing_points = [attenuation_crossing_points; index_disturbance_amplification(end)];
    end
end
    attenuation_crossing_frequencies = frequency(attenuation_crossing_points);

% Check closed-loop stability
if isstable(closed_loop)
    closed_loop_stability = 'stable';
else
    closed_loop_stability = 'instable';
end

% Plot results
screensize = get(0, 'ScreenSize');
h = figure('Position', [0 0 screensize(3) screensize(4)]);
set(h, 'Name', 'Fast Orbit Feedback Simulator - System frequency response');

% Plot disturbance rejection
ax = subplot(311);
semilogx(frequency, 20*log10(mag_disturbance_rejection), 'r');
grid('on');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title({'----------------------------------------  SIMULATION  PARAMETERS  ----------------------------------------',['Total latency: ' num2str(total_latency) ' s'], ['BPM: Bandwidth: ' num2str(config.bpm_bandwidth) ' Hz; Sampling rate: ' num2str(config.bpm_sampling_rate) ' S/s'], ['POWER SUPPLY: Damping factor: ' num2str(ps_damping) '; Natural frequency: ' num2str(2*pi*ps_natural_frequency) ' Hz'], [plane ' vacuum chamber cutoff: ' num2str(vac_cutoff) ' Hz'], ['CONTROLLER: Update rate: ' num2str(config.ps_update_rate) ' Hz; Transfer function (z taps): ' mat2str(ctrl_num) '/' mat2str(ctrl_den)]}, 'FontSize', 8);
legend('Disturbance suppression');
set(ax, 'FontSize', 8, 'XLim', frequency_plot_range);
hold on;
text(frequency(index_max_disturbance_amplification), 20*log10(max_disturbance_amplification), ['Maximum amplification: ' num2str(max_disturbance_amplification) ' (' num2str(20*log10(max_disturbance_amplification)) ' dB)  '], 'VerticalAlignment', 'bottom', 'HorizontalAlignment','right', 'Color', 'r', 'FontSize', 8, 'Clipping', 'on');
text(frequency(index_max_disturbance_amplification), 0, [num2str(frequency(index_max_disturbance_amplification)) ' Hz  '], 'VerticalAlignment', 'top', 'HorizontalAlignment','left', 'Color', 'r', 'FontSize', 8, 'Clipping', 'on');
stem(frequency(index_max_disturbance_amplification), 20*log10(max_disturbance_amplification), 'ro', 'filled');
for i=1:length(attenuation_crossing_frequencies)
    freq = attenuation_crossing_frequencies(i);
    text(freq, 20*log10(mag_disturbance_rejection(attenuation_crossing_points(i))), [num2str(attenuation_crossing_frequencies(i)) ' Hz  '], 'VerticalAlignment', 'top', 'HorizontalAlignment','left', 'Color', 'r', 'FontSize', 8, 'Clipping', 'on');
end
plot(attenuation_crossing_frequencies, 20*log10(mag_disturbance_rejection(attenuation_crossing_points)), 'r*');    

% Plot open- and closed-loop magnitude
ax = subplot(312);
semilogx(frequency, 20*log10([mag_open_loop mag_closed_loop]));
grid('on');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
h_legend = legend('Open loop', ['Closed loop (' closed_loop_stability ')']);
if ~isstable(closed_loop)
    set(h_legend, 'Color', [1 0.9 0.9]);
    set(h_legend, 'EdgeColor', [1 0 0]);
end
set(ax, 'FontSize', 8, 'XLim', frequency_plot_range);
hold on;
text(Wcg/2/pi, -20*log10(Gm), ['Gain margin: ' num2str(Gm) ' (' num2str(20*log10(Gm)) ' dB)  '], 'VerticalAlignment', 'top', 'HorizontalAlignment','right', 'Color', 'b', 'FontSize', 8, 'Clipping', 'on');
stem(Wcg/2/pi, 20*log10(interp1(frequency,mag_open_loop,Wcg/2/pi)), 'bo', 'filled');

% Plot open-loop phase
ax = subplot(313);
semilogx(frequency, phase_open_loop);
grid('on');
xlabel('Frequency (Hz)');
ylabel('Phase (deg)');
legend('Open loop');
set(ax, 'FontSize', 8, 'XLim', frequency_plot_range);
hold on;
text(Wcp/2/pi, interp1(frequency,phase_open_loop,Wcp/2/pi), ['  Phase margin: ' num2str(Pm) '°'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment','left', 'Color', [0 0 1], 'FontSize', 8, 'Clipping', 'on');
plot(Wcp/2/pi, interp1(frequency,phase_open_loop,Wcp/2/pi), 'o', 'MarkerFaceColor', 'b');

warning(UseSSforInternalDelay_state, 'Control:ltiobject:UseSSforInternalDelay');
warning(MarginUnstable_state, 'Control:analysis:MarginUnstable');