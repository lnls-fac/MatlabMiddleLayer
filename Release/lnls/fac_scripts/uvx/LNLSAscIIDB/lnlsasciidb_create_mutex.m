function lnlsasciidb_create_mutex(db_file_name)

mutex_name = ['lnlsasciidb_mutex_' db_file_name];
has_waited = false;

if ~isempty(getappdata(0, mutex_name))
    fprintf([datestr(now) ': waiting for mutex ' mutex_name '...\n']);
    has_waited = true;
end
while ~isempty(getappdata(0,mutex_name))
    pause(0.1);
end
if has_waited, fprintf([datestr(now) ': mutex ' mutex_name ' released.\n']); end
setappdata(0, mutex_name, 1);