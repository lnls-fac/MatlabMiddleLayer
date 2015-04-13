function r = fafind(path, date_start, date_stop)

if nargin < 1 || isempty(path)
    path = pwd;
end

if nargin < 2 || isempty(date_start)
    tstart = -Inf;
else
    tstart = datenum(date_start);
end

if nargin < 3 || isempty(date_stop)
    if isinf(tstart)
        tstop = Inf;
    else
        tstop = tstart + 1/24/60;
    end
else
    tstop = datenum(date_stop);
end

filenames = dir(fullfile(path,'*.dat'));
filenames = {filenames.name};

% Convert Matlab serial date number to Labivew/Excel/Igor PRO serial date number
tinterval = fatimem2lvrt([tstart tstop]);

tstart = tinterval(1);
tstop = tinterval(end);

r = {};
j=1;
for i=1:length(filenames)
    [pathstr, filename, ext] = fileparts(filenames{i});

    filename_num = str2double(filename);

    if strcmpi(ext, '.dat') && ~strcmpi(filename, 'temp') && ~isempty(filename_num) && (filename_num >= tstart) && (filename_num <= tstop)
        r{j} = fullfile(path, filenames{i});
        j = j+1;
    end
end
