function [time, data] = build_disturbance_therm(tconstant, amplitude, simulation_time)

% Number of points per time constant
points_per_tconstant = 5;

% Maximum number of points
max_number_of_points = 10000;

% Prevent from meanless time constants (non-positive or very small time constants or very large time constants)
if (simulation_time*points_per_tconstant/tconstant > max_number_of_points) || (tconstant/points_per_tconstant >= simulation_time)
    time = [0; tconstant; simulation_time];
    data = [0; amplitude; amplitude];
else
    time = (0:tconstant/points_per_tconstant:simulation_time)';
    data = lsim(tf(1,[tconstant 1]), repmat(amplitude, length(time), 1), time);
end


