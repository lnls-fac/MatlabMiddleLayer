function [time, data] = build_disturbance_vib(frequencies, rms_values, simulation_time)

% Minimum number of points per period
min_points_per_period = 20;

% Prevent from meanless sinusoids (negative frequency or very small frequency)
very_slow_sinusoids = find(frequencies <= 1/min_points_per_period/simulation_time);
frequencies(very_slow_sinusoids) = 1/min_points_per_period/simulation_time;
rms_values(very_slow_sinusoids) = 0;

% Use time interval for getting at least 15 points of the fastest sinusoid
time = (0:1/min_points_per_period/max(frequencies):simulation_time)';

frequencies_rad_s = repmat(2*pi*frequencies, length(time), 1);

data_aux = sqrt(2)*repmat(rms_values, length(time), 1).*sin(frequencies_rad_s.*repmat(time,1,length(frequencies)));
data = sum(data_aux, 2);