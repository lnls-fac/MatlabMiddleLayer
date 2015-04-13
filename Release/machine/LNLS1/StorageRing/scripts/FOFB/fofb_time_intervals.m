function [time_intervals_start_indexes, time_intervals_start] = fofb_time_intervals(time, npts_interval)
% [time_intervals_start_indexes, time_intervals_start] = fofb_time_intervals(time, npts_interval)

npts = length(time);

dt = time(2) - time(1);
npts_fraction = npts_interval/npts;
time_intervals_start = ((1:(npts/200):npts*(1/npts_fraction-1)*npts_fraction)-1)*dt;

time_intervals_start_indexes = zeros(size(time_intervals_start));
for i=1:length(time_intervals_start)
   aux = find(time >= time_intervals_start(i));
   time_intervals_start_indexes(i) = aux(1);
end
