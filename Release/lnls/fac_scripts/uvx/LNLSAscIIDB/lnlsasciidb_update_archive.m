function lnlsasciidb_update_archive


lnlsasciidb_set_state('update');

db_files = lnlsasciidb_get_db_file_list;
if ~isempty(db_files)
    db_name = db_files(1).name;
    lnlsasciidb_convert_ascii_to_mat_file(db_name);
    if (length(db_files)>1) && strcmpi(db_files(1).name, db_name)
        lnlsasciidb_backup_db_file(db_name);
    end
end