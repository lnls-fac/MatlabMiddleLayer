function tostop = lnlsasciidb_set_state(state)

tostop = false;

lnlsasciidb_create_mutex('SET_STATE');

def_parms = lnlsasciidb_load_default_parameters;
if ~exist(def_parms.srvcmd_path, 'dir'), mkdir(def_parms.srvcmd_path); end;
file_name = fullfile(def_parms.srvcmd_path, 'state.txt');

if any(strcmpi(state, {'stop', 'debug', 'query', 'update'}))
    setappdata(0,'lnlsasciidb_STATE',state);
    try
        dlmwrite(file_name, state);
    catch
    end
    if strcmpi(state, 'stop')
        tostop = true;
    elseif strcmpi(state, 'debug')
        lnlsasciidb_debug_mode;
    end;
end;


lnlsasciidb_delete_mutex('SET_STATE');