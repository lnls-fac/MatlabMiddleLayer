function lnlsasciidb_server
% LNLSASCIIDB_SERVER
% ------------------
% LNLS, Campinas 2010-10-07
% Ximenes R. Resende
%
% Script principal que atualiza banco de dados com registro no formato
% matlab e também atua como servidor de dados recebendo pedidos através
% de arquivos escritos em disco rígido.
%
% Importante:
%
% Este programa, uma vez iniciado, não deve ser interrompido
% através do prompt do matlab (CTRL+C), sob o risco de arquivos do banco
% de dados serem parcialmente escritos e consequentemente corrompidos.
% A maneira de se parar este script é inserindo um arquivo de nome
% 'cmd_stop' no diretório definido pela variável 'srvcmd_path' que é
% inicializada pelo script 'lnlsasciidb_load_default_parameters'.
%
% De maneira analoga para interromper e debugar uma instância deste
% em vôo deve-se inserir o arquivo 'cmd_debug' no mesmo diretório.


% initializations
dbstop in lnlsasciidb_debug_mode;
def_parms = lnlsasciidb_load_default_parameters;
if ~exist(def_parms.queries_path, 'dir'), mkdir(queries_dir); end;
request_file_mask = fullfile(def_parms.queries_path, 'req_*.txt');

% MAIN LOOP: loops indefinitely till server command is issued
% ==========
last_update_archive = [];
while true
    
    % checks whether there are server commands to proccess
    stop_cmd = check_srvcmds;
    if stop_cmd, return; end;
    
    % gets query requests to serve from 'queries_path' folder
    request = get_requests_to_proccess(request_file_mask);
    
    % if no request, proceeds with updating the archive database
    if isempty(request) && (isempty(last_update_archive) || ((now - last_update_archive)*24*3600 >= def_parms.update_archive_interval))
        lnlsasciidb_update_archive;
        last_update_archive = now;
        continue;
    end
    
    % if there are requests, serves them
    for i=1:length(request)
        process_request(request(i));
        move_request_file(request(i));
    end
    
end

function tostop = check_srvcmds

def_parms = lnlsasciidb_load_default_parameters;

tostop = false;

if ~exist(def_parms.srvcmd_path, 'dir')
    mkdir(def_parms.srvcmd_path);
    return;
end

files = dir(fullfile(def_parms.srvcmd_path, 'cmd_*'));
for i=1:length(files)
    if strcmpi(files(i).name, 'cmd_stop')
        try
            delete(fullfile(def_parms.srvcmd_path, files(i).name));
        catch
        end;
        tostop = lnlsasciidb_set_state('stop');
    elseif strcmpi(files(i).name, 'cmd_debug')
        try
            delete(fullfile(def_parms.srvcmd_path, files(i).name));
        catch
        end;
        lnlsasciidb_set_state('debug');
    end;
  
end;


function process_request(request)

lnlsasciidb_set_state('query');

fprintf([datestr(now) ': processing query ' request.file_name '...\n']);

% reads query file and loads query parameters
def_parms = lnlsasciidb_load_default_parameters;
file_name = fullfile(def_parms.queries_path, request.file_name);
fid = fopen(file_name, 'r');
if (fid == -1)
    return;
end;
tmpstr = fscanf(fid, '%s', 1); initi_datevec = fscanf(fid, '%i %i %i %i %i %i %i',[1 7]);
tmpstr = fscanf(fid, '%s', 1); final_datevec = fscanf(fid, '%i %i %i %i %i %i %i',[1 7]);
tmpstr = fscanf(fid, '%s', 1); time_interval = fscanf(fid, '%f', 1);
tmpstr = fscanf(fid, '%s', 1); nr_match_string = fscanf(fid, '%i',1);
if isempty(nr_match_string) || (nr_match_string < 1)
    fclose(fid);
    return;
end
match_string = cell(nr_match_string,1);
for i=1:nr_match_string
    match_string{i} = fscanf(fid, '%s',1);
end
end_of_file_string = fscanf(fid, '%s',1);
fclose(fid);

if strcmpi(end_of_file_string, 'end_request')
    
    % builds query data structure
    query_data.initi_datetime = initi_datevec;
    query_data.final_datetime = final_datevec;
    query_data.time_interval  = time_interval;
    query_data.match_fields   = match_string;
    query_data.func_to_call   = @lnlsasciidb_save_query_data_to_file;
    query_data.data_file_name = strrep(strrep(request.file_name, 'req_', 'dat_'), '.txt', '.mat');
    
    % runs query function
    lnlsasciidb_query(query_data);
else
    
end;




function move_request_file(request)

def_parms = lnlsasciidb_load_default_parameters;
old_file_name = fullfile(def_parms.queries_path, request.file_name);
new_path = fullfile(def_parms.queries_path, 'server_request');
new_file_name = fullfile(new_path, request.file_name);
if ~exist(new_path, 'dir'), mkdir(new_path); end;
try
    movefile(old_file_name, new_file_name);
catch
end


function r = get_requests_to_proccess(request_file_mask)

request = dir(request_file_mask);
if isempty(request)
    r = [];
else
    [tmp idx] = sort([request(:).datenum]);
    % serves only older request
    r(1).file_name = request(idx(1)).name;
    r(1).datenum   = request(idx(1)).datenum;
end