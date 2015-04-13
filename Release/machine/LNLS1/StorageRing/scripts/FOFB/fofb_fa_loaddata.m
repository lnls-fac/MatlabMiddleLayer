function fa_data = fofb_fa_loaddata(filename)
%
% FOFB_FA_LOADDATA Loads acquisition data from file.
% fa_data = fofb_fa_loaddata(filename)

try
    file_id = fopen(filename);
    period = fread(file_id,1,'uint32','l');
    period = period*1e-3; % convert us to ms
    header_bpm = strread(fgetl(file_id), '%s', 'delimiter', '\t');
    length_bpm = length(header_bpm);
    header_ps = strread(fgetl(file_id), '%s', 'delimiter', '\t');
    length_ps = length(header_ps);
    
    data = [];
    while true
        nrows = fread(file_id,1, 'uint32=>double', 'l');
        ncols = fread(file_id,1, 'uint32=>double', 'l');
        if isempty(ncols*nrows)
            break;
        end
        subdata = fread(file_id, ncols*nrows, 'double', 'l');
        data = [data; reshape(subdata, ncols, nrows)'];
    end
    
    npts = size(data,1);
    time = ((0:npts-1)*period)';

catch err
    fclose(file_id);
    retrhow(err);
end

fclose(file_id);

fa_data = struct('time', time, ...
           'bpm_readings', data(:,1:length_bpm), ...
           'bpm_names', {header_bpm(1:end)}, ...
           'ps_readings', data(:,length_bpm+1:length_bpm+length_ps/2), ...
           'ps_names', {header_ps(1:length_ps/2)}, ...
           'ps_setpoints', data(:,1+length_bpm+length_ps/2:length_bpm+length_ps), ...
           'ps_setpoints_names', {header_ps(1+length_ps/2:length_ps)});
