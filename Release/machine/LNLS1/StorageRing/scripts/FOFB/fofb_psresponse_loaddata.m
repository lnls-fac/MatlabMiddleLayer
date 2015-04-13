function r = fofb_psresponse_loaddata(path)
% r = fofb_psresponse_loaddata(path)

dir_info = dir([path '\*.dat']);
filenames={dir_info.name};

nps = length(filenames);
ps_readings = [];
ps_setpoints = [];
ps_names = cell(nps, 1);

% Load FA files
for i=1:nps
    r = fofb_fa_loaddata([path '\' filenames{i}]);
    ps_names(i) = r.ps_names(1);
    ps_readings = [ps_readings r.ps_readings];
    ps_setpoints = [ps_setpoints r.ps_setpoints];
end
Ts = r.time(2)-r.time(1);
npts = length(r.time);
time = (0:npts-1)*Ts;

r = struct('time', time, ...
           'ps_readings', ps_readings, ...
           'ps_setpoints', ps_setpoints, ...
           'ps_names', {ps_names});