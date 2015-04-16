function data_cut = facutdata(data, pts, selected_bpm, selected_corr)

npts = length(data.time);
nbpm = size(data.bpm_readings,2);
ncorr = size(data.corr_readings,2);

if nargin < 2 || isempty(pts)
    pts = 1:npts;
end

if nargin < 3 || isempty(selected_bpm)
    selected_bpm = 1:nbpm;
elseif selected_bpm == 0
    selected_bpm = [];
end

if nargin < 4 || isempty(selected_corr)
    selected_corr = 1:ncorr;
elseif selected_corr == 0
    selected_corr = [];
end

data_cut = struct('time', data.time(pts), ...
               'bpm_readings', data.bpm_readings(pts, selected_bpm), ...
               'bpm_names', {data.bpm_names(selected_bpm)}, ...
               'corr_readings', data.corr_readings(pts, selected_corr), ...
               'corr_names', {data.corr_names(selected_corr)}, ...
               'corr_setpoints', data.corr_setpoints(pts, selected_corr), ...
               'corr_setpoints_names', {data.corr_setpoints_names(selected_corr)}, ...
               'marker', {data.marker(pts,:)}, ...
               'period', data.period);
