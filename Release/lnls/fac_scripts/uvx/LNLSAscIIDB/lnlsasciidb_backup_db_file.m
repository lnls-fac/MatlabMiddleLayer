
function lnlsasciidb_backup_db_file(db_name)

def_parms = lnlsasciidb_load_default_parameters;

if ~exist(def_parms.ascii_db_backup_path, 'dir'), mkdir(def_parms.ascii_db_backup_path); end

db_file_name = [db_name def_parms.db_ascii_file_ext];
old_path = fullfile(def_parms.ascii_db_path, db_file_name);
new_path = fullfile(def_parms.ascii_db_backup_path, db_file_name);
if exist(new_path, 'file')
    fprintf([datestr(now) ': backup file ' db_file_name ' already exists!\n']);
    return;
end
if exist(old_path, 'file')
    fprintf([datestr(now) ': moving data file ' db_file_name ' to backup directory...\n']);
    try
        movefile(old_path, new_path);
    catch
        fprintf([datestr(now) ': unable to move file ' db_file_name ' to backup directory!\n']);
    end
end
