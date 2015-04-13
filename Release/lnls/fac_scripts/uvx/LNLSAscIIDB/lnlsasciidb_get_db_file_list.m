function r = lnlsasciidb_get_db_file_list

persistent prev_db_file_list;


% prevents reentrant in this function creating mutex
lnlsasciidb_create_mutex('GET_DB_FILE_LIST');

def_parms = lnlsasciidb_load_default_parameters;
min_interval = def_parms.cfile_time_interval / (60 * 60 * 24);

% gets new db file list
this_time_stamp = now;
db_file_list    = dir(def_parms.ascii_db_path);

if isempty(prev_db_file_list)
    prev_db_names = [];
else
    prev_db_names = {prev_db_file_list(:).name};
end

r = struct('name',{},'isdir',{},'bytes',{},'datenum',{},'checktimestamp',{},'ischanging',{});
% compares with existing db file list
for i=1:length(db_file_list)
    if ~db_file_list(i).isdir
        data.name = strrep(db_file_list(i).name, def_parms.db_ascii_file_ext, '');
        data.isdir          = false;
        data.bytes          = db_file_list(i).bytes;
        data.datenum        = db_file_list(i).datenum;
        if isempty(prev_db_names)
            data.checktimestamp = this_time_stamp;
            data.ischanging = true;
        else
            pos = find(strcmpi(data.name, prev_db_names));
            if ~isempty(pos)
                data.checktimestamp = prev_db_file_list(pos(1)).checktimestamp;
                data.ischanging = false;
                data.ischanging = data.ischanging || ~(db_file_list(i).bytes == prev_db_file_list(pos(1)).bytes);
                data.ischanging = data.ischanging || ((this_time_stamp - prev_db_file_list(pos(1)).checktimestamp) < min_interval);
            else
                data.checktimestamp = this_time_stamp;
                data.ischanging = true;
            end
        end;
        r(end+1) = data;
    end
end
r = lnlsasciidb_sort_files(r);
prev_db_file_list = r;
time_stamp = this_time_stamp;

% releases mutex
lnlsasciidb_delete_mutex('GET_DB_FILE_LIST');





