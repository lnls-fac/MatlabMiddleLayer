function r = lnlsasciidb_get_fields_from_mat_file(db_file_name)

def_parms = lnlsasciidb_load_default_parameters;

file_name = fullfile(def_parms.mat_db_path, [db_file_name '.mat']);

% loads fields from file (critical section!)
lnlsasciidb_create_mutex(db_file_name);
if exist(file_name, 'file')
    %try
        data = whos('-file', file_name);
        r = {data(:).name};
        r = r(:);
    %catch
    %    fprintf([datestr(now) ': could not open mat file ' db_file_name '!\n']);
    %    r = [];
    %end
else
    r = [];
end
lnlsasciidb_delete_mutex(db_file_name);



