function lnlsasciidb_save_query_data_to_file(query_data_, dbdata)

query_data = query_data_;

if ~isfield(query_data, 'data_file_name'), query_data.data_file_name = 'DATA.m'; end;
if ~isfield(query_data, 'variable_name'), query_data.variable_name = 'DATA'; end;

%fprintf([datestr(now) ': saving query data for db file ' query_data.data_file_name '...\n']);

def_parms = lnlsasciidb_load_default_parameters;
if ~exist(def_parms.queries_path, 'dir'), mkdir(def_parms.queries_path); end;
file_name = fullfile(def_parms.queries_path, query_data.data_file_name);



%eval([query_data.variable_name '=dbdata.data;']);
eval([query_data.variable_name '=cell2mat(struct2cell(dbdata.data)'');']);

if exist(file_name, 'file')
    save(file_name, query_data.variable_name, '-mat', '-append');
else
    fields = char(fieldnames(dbdata.data));
    save(file_name, 'fields', query_data.variable_name, '-mat');
end



function lnlsasciidb_save_query_data_to_file2(query_data_, dbdata)

query_data = query_data_;

if ~isfield(query_data, 'data_file_name'), query_data.data_file_name = 'DATA.txt'; end;

fprintf([datestr(now) ': saving query data for db file ' query_data.data_file_name '...\n']);

def_parms = lnlsasciidb_load_default_parameters;
if ~exist(def_parms.queries_path, 'dir'), mkdir(def_parms.queries_path); end;
file_name = fullfile(def_parms.queries_path, query_data.data_file_name);

fields = fieldnames(dbdata.data);

if ~exist(file_name, 'file')
    line_ = '';
    for j=1:length(fields)
        line_ = [line_ sprintf('%s\t', fields{j})];
    end;
    fid = fopen(file_name, 'w');
    fprintf(fid, '%s\r\n', line_);
    fclose(fid);
end

tmp = struct2cell(dbdata.data);
data = cell2mat(tmp);
data = reshape(data, length(dbdata.data.DATAHORA),length(fields));
dlmwrite(file_name, data, '-append', 'delimiter', '\t', 'newline', 'pc', 'precision', 16);




