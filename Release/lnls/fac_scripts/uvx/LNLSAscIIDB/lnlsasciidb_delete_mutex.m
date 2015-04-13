function lnlsasciidb_delete_mutex(db_file_name)

if ~isempty(db_file_name)
    mutex_name = ['lnlsasciidb_mutex_' db_file_name];
    rmappdata(0, mutex_name);
else
    data_list = fieldnames(getappdata(0));
    mutex_idx_list = strncmpi('lnlsasciidb_mutex_', data_list,18);
    mutex_names_list = data_list(mutex_idx_list);
    for i=1:length(mutex_names_list)
        rmappdata(0, mutex_names_list{i});
    end
end
    
    