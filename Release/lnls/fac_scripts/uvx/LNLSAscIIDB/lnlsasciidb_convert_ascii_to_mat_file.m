function lnlsasciidb_convert_ascii_to_mat_file(db_file_name_orig)

% loads new data from AscII file
fprintf([datestr(now) ': reading ascii file ' db_file_name_orig '...\n']);
def_parms = lnlsasciidb_load_default_parameters;
new_data = lnlsasciidb_get_data_from_ascii_file(db_file_name_orig);

% builds MAT file name from original file name
db_file_name = db_file_name_orig(1:13);
archive_path = def_parms.mat_db_path;
if ~exist(archive_path, 'dir'), mkdir(archive_path); end;
mat_file_name = fullfile(archive_path, [db_file_name '.mat']);

% loads old data if MAT file exists
if exist(mat_file_name, 'file')
    old_data = load(mat_file_name, '-mat');
else
    old_data = [];
end

% merges old and new data
if isempty(old_data)
    fprintf([datestr(now) ': saving data into new mat file...\n']);
    merged_data = new_data;
else
    fprintf([datestr(now) ': merging and saving data into existing mat file...\n']);
    data_hora = [old_data.DATAHORA; new_data.DATAHORA];
    [data_hora sorting_idx_vec n] = unique(data_hora);
    % merge fields
    new_fields = unique([fieldnames(old_data); fieldnames(new_data)]);
    for i=1:length(new_fields)
        if isfield(old_data, new_fields{i}), old_values = old_data.(new_fields{i}); else old_values = NaN * old_data.DATAHORA; end
        if isfield(new_data, new_fields{i}), new_values = new_data.(new_fields{i}); else new_values = NaN * new_data.DATAHORA; end     
                
        data = lnlsasciidb_concat_data(old_values(:), new_values(:));
        
        % sorts data using DATAHORA field
        data = data(sorting_idx_vec);
        merged_data.(new_fields{i}) = data; 
    end
end
    
    
% saves merged data to temporary MAT file
tmp_mat_file_name = fullfile(def_parms.mat_db_path, [db_file_name '_tmp.mat']);
save(tmp_mat_file_name, '-struct', 'merged_data');

% rename temporary MAT file to final name 
% (critical section: mutex used to avoid access collisions)
lnlsasciidb_create_mutex(db_file_name);
movefile(tmp_mat_file_name, mat_file_name, 'f');
lnlsasciidb_delete_mutex(db_file_name);
