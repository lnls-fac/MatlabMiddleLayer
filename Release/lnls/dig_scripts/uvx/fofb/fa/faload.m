function fadata = faload(filenames, selected_bpm, selected_corr, npts, nmarker)
%
% FALOAD Loads fast acquisition (FA) data from file.

if nargin < 2
    selected_bpm = [];
end

if nargin < 3
    selected_corr = [];
end

if nargin < 4
    npts = [];
end

if nargin < 5 || isempty(nmarker)
    nmarker = 1;
end


if ischar(filenames)
    try
        fileid = fopen(filenames);

        [period, header_bpm, header_corr] = readparams(fileid);
        
        nbpm_readings = length(header_bpm);
        ncorr = length(header_corr)/2;
        
        nbpm = nbpm_readings/2;
        
        if nargin < 2 || isempty(selected_bpm)
            selected_bpm = 1:nbpm;
        elseif selected_bpm == 0
            selected_bpm = [];
        end

        if nargin < 3 || isempty(selected_corr)
            selected_corr = 1:ncorr;
        elseif selected_corr == 0
            selected_corr = [];
        end
        
        selected_bpm_readings = [selected_bpm (selected_bpm+nbpm)];
               
        header_bpm = header_bpm(selected_bpm_readings);
        header_corr = {header_corr{selected_corr} header_corr{ncorr+selected_corr}}';
        
        nselected_bpm = length(header_bpm);
        nselected_corr = length(header_corr);
        
        fileinfo = dir(filenames);
        remaining_bytes = fileinfo.bytes - ftell(fileid);

        nrows = fread(fileid, 1, 'uint32=>uint32', 'l');
        ncols = fread(fileid, 1, 'uint32=>uint32', 'l');

        nblocks = remaining_bytes/4/(2+nrows*ncols);
        data = zeros(nblocks*nrows, length(selected_bpm_readings) + 2*length(selected_corr) + nmarker + 2, 'single');
        for i=0:nblocks-1
            subdata = fread(fileid, ncols*nrows, 'single=>single', 'l');
            subdata = reshape(subdata, ncols, nrows)';
            data_ = [subdata(:, [selected_bpm_readings (nbpm_readings+selected_corr) (nbpm_readings+ncorr+selected_corr)]) subdata(:, nbpm_readings+2*ncorr+1:end)];
            data((i*nrows+1):((i+1)*nrows), :) = data_;
            fread(fileid, 1, 'uint32=>uint32', 'l');
            fread(fileid, 1, 'uint32=>uint32', 'l');
        end
        time_hi = typecast(data(:,end), 'uint32');
        time_lo = typecast(data(:,end-1), 'uint32');
        time = bitor(bitshift(uint64(time_hi), 32), uint64(time_lo));

        marker = typecast(data(:,end-1-nmarker:end-2), 'uint32');
        
        data = data(:, 1:end-2-nmarker);
        
    catch err
        fclose(fileid);
        rethrow(err);
    end

    fclose(fileid);

    fadata = struct('time', time, ...
               'bpm_readings', data(:,1:nselected_bpm), ...
               'bpm_names', {header_bpm(1:end)}, ...
               'corr_readings', data(:,nselected_bpm+1:nselected_bpm+nselected_corr/2), ...
               'corr_names', {header_corr(1:nselected_corr/2)}, ...
               'corr_setpoints', data(:,1+nselected_bpm+nselected_corr/2:nselected_bpm+nselected_corr), ...
               'corr_setpoints_names', {header_corr(1+nselected_corr/2:nselected_corr)}, ...
               'marker', marker, ...
               'period', period);

elseif iscell(filenames)
    if isempty(npts)
        fadata = struct('time', [], ...
            'bpm_readings', [], ...
            'bpm_names', [], ...
            'corr_readings', [], ...
            'corr_names', [], ...
            'corr_setpoints', [], ...
            'corr_setpoints_names', [], ...
            'marker', [], ...
            'period', []);
    else
        fileid = fopen(filenames{1});
        [dummy, header_bpm, header_corr] = readparams(fileid);
        nbpm_readings = length(header_bpm);
        ncorr = length(header_corr)/2;
        fclose(fileid);
        
        nbpm = nbpm_readings/2;
        
        if isempty(selected_bpm)
            nselected_bpm_readings = nbpm_readings;
        elseif selected_bpm == 0
            nselected_bpm_readings = 0;
        else
            nselected_bpm_readings = 2*length(selected_bpm);
        end
        
        if isempty(selected_corr)
            nselected_corr = ncorr;
        elseif selected_corr == 0
            nselected_corr = 0;
        else
            nselected_corr = length(selected_corr);
        end
        
        fadata = struct('time', zeros(npts*length(filenames), 1, 'uint64'), ...
            'bpm_readings', zeros(npts*length(filenames), nselected_bpm_readings, 'single'), ...
            'bpm_names', [], ...
            'corr_readings', zeros(npts*length(filenames), nselected_corr, 'single'), ...
            'corr_names', [], ...
            'corr_setpoints', zeros(npts*length(filenames), nselected_corr, 'single'), ...
            'corr_setpoints_names', [], ...
            'marker', [], ...
            'period', []);
    end
   
       
    for i=1:length(filenames)
        subfadata = faload(filenames{i}, selected_bpm, selected_corr, npts, nmarker);
        if isempty(npts)
            fadata.time           = [fadata.time;           subfadata.time];
            fadata.bpm_readings   = [fadata.bpm_readings;   subfadata.bpm_readings];
            fadata.corr_readings  = [fadata.corr_readings;  subfadata.corr_readings];
            fadata.corr_setpoints = [fadata.corr_setpoints; subfadata.corr_setpoints];
            fadata.marker         = [fadata.marker; subfadata.marker];
        else
            fadata.time((i-1)*npts+1:i*npts) = subfadata.time;
            fadata.bpm_readings((i-1)*npts+1:i*npts, :) = subfadata.bpm_readings;
            fadata.corr_readings((i-1)*npts+1:i*npts, :) = subfadata.corr_readings;
            fadata.corr_setpoints((i-1)*npts+1:i*npts, :) = subfadata.corr_setpoints;
            fadata.marker((i-1)*npts+1:i*npts, :) = subfadata.marker;
        end
            
        fadata.bpm_names            = compare(fadata.bpm_names, subfadata.bpm_names);
        fadata.corr_names           = compare(fadata.corr_names, subfadata.corr_names);
        fadata.corr_setpoints_names = compare(fadata.corr_setpoints_names, subfadata.corr_setpoints_names);
        fadata.period               = compare(fadata.period, subfadata.period);        
    end

end


function new = compare(current, new)

if ~(isempty(current) || isequal(current, new))
    error('Corresponding headers and constants across different files shall be identical.');
end

function header = readheader(fileid)

header = fgetl(fileid);
if ~isempty(header)
    header = textscan(header, '%s', 'delimiter', '\t');
    header = header{1};
else
    header = {};
end


function [period, header_bpm, header_corr] = readparams(fileid)

period = fread(fileid, 1, 'uint32', 'l');
header_bpm = readheader(fileid);
header_corr = readheader(fileid);
