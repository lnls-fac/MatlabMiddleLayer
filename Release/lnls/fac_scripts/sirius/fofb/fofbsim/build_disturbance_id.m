function [time, data] = build_disturbance_id(stoptime, amplitude, simulation_time)

% Prevent from meanless stoptime (negative or greater than simulation time)
if (stoptime <= 0) || (stoptime >= simulation_time)
    time = [0; simulation_time];
    data = [0; amplitude];
else
    time = [0; stoptime; simulation_time];
    data = [0; amplitude; amplitude];
end