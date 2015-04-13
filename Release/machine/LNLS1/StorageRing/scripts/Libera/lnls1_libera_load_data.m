function r = lnls1_libera_load_data(varargin)
%Lê dados gerado pelo libera brilliance.
%
%História: 
%
%2010-09-13: comentários iniciais no código.

% default parameters
input_parms.libera_data_index  = 0;
input_parms.libera_nr_pts      = 512;
input_parms.libera_file_name   = 'libera_data';
input_parms.libera_local_dir   = 'D:\libera\';
input_parms.libera_pause_time  = 0.1; % seconds
input_parms.libera_time_out    = 15; % seconds

% modify/add default parameters with input data
if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i=1:length(fnames)
        input_parms.(fnames{i}) = varargin{1}.(fnames{i});
    end
end

% loops until measurement data file is ready
file_size = 16 * input_parms.libera_nr_pts;
local_file_name = [input_parms.libera_local_dir input_parms.libera_file_name int2str(input_parms.libera_data_index) '.txt'];
file_info = dir(local_file_name);
file_not_ready = ~(exist(local_file_name, 'file') && (file_info.bytes > file_size));

t0 = clock;
t1 = t0;
while file_not_ready && (etime(t1, t0) < input_parms.libera_time_out)
    try
        injbump_check_abort(input_parms);
    catch
    end
    pause(input_parms.libera_pause_time);
    file_info = dir(local_file_name);
    file_not_ready = ~(exist(local_file_name, 'file') && (file_info.bytes > file_size));
    t1 = clock;
end

if ~(etime(t1, t0) < input_parms.libera_time_out)
    error('time out na espera do arquivo do libera');
end

r = input_parms;

% reads measurement data in file
r.libera_data = importdata(local_file_name);