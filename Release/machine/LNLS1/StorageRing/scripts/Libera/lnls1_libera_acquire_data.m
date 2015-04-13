function r = lnls1_libera_acquire_data(varargin)
%Envia comando ao libera brilliance para aquisição de dados.
%
%História: 
%
%2010-09-13: comentários iniciais no código.


% default parameters

input_parms.libera_data_index       = 0;
input_parms.libera_ip               = '10.0.4.154';
input_parms.libera_username         = 'test';
input_parms.libera_password         = 'libera1';
input_parms.libera_nr_pts           = 1024;
input_parms.libera_local_dir        = 'D:\libera\';
input_parms.libera_file_name        = 'libera_data';
input_parms.libera_t4erexec         = 'C:\_t4ecltbundle\T4eRexec';
input_parms.libera_acquisition_mode = '-O';

% modify/add default parameters with input data
if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i=1:length(fnames)
        input_parms.(fnames{i}) = varargin{1}.(fnames{i});
    end
end

% builds libera command
fname = [input_parms.libera_file_name int2str(input_parms.libera_data_index) '.txt'];
libera_cmd = [input_parms.libera_t4erexec ' -l ' input_parms.libera_username ' -p ' input_parms.libera_password ' ' input_parms.libera_ip ' "cd /opt/bin; ./libera ' input_parms.libera_acquisition_mode ' ' int2str(input_parms.libera_nr_pts), ' > /mnt/nfs/' fname '"'];

r = input_parms;
r.libera_dos_cmd = ['dos(''' libera_cmd ' && exit ' ' & ' ''')'];
            
% executes libera command
r.libera_dos_return = evalc(r.libera_dos_cmd);




