function r = lnlsasciidb_get_data_from_mat_file(db_file_name, fields, nr_records_to_load, conditional)

def_parms = lnlsasciidb_load_default_parameters;
file_name = fullfile(def_parms.mat_db_path, [db_file_name '.mat']);

% loads data from file (critical section!)
warning('off','MATLAB:load:variableNotFound');
lnlsasciidb_create_mutex(db_file_name);
if exist(file_name, 'file')
    try
        if isempty(fields)
            r = load(file_name, '-mat');
        else
            r = load(file_name, '-mat', fields{:});
        end;
    catch exception
        fprintf([datestr(now) ': could not open mat file ' db_file_name '!\n']);
        r = []; % could not open file!
    end
else
    r = []; % file does not exist
end
lnlsasciidb_delete_mutex(db_file_name);
warning('on','MATLAB:load:variableNotFound');

% filters selection using nr_of_records_to_load
if ~isempty(r)
    step = max([1 round(length(r.DATAHORA) / nr_records_to_load)]);
    pos = 1:step:length(r.DATAHORA);
    %pos = unique(round(linspace(1,length(r.DATAHORA),nr_records_to_load)));
    data_fields = fieldnames(r);
    for i=1:length(data_fields)
        data = r.(data_fields{i});
        r.(data_fields{i}) = data(pos);
    end
end


