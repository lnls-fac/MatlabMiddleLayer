function data = lnlsasciidb_query(query_data_)

query_data = query_data_;

def_parms = lnlsasciidb_load_default_parameters;

second_in_datenum = datenum([2010 10 13 0 0 1]) - datenum([2010 10 13 0 0 0]);

% default query parameters and processes query input arguments
if ~isfield(query_data, 'initi_datetime'), query_data.initi_datetime = [1997 1 1 0 0 0 0]; end;
if ~isfield(query_data, 'final_datetime'), query_data.final_datetime = [2020 1 1 0 0 0 0]; end;
if ~isfield(query_data, 'match_fields'), query_data.match_fields = {'.+'}; end;
if ~isfield(query_data, 'time_interval'), query_data.time_interval = def_parms.record_period * second_in_datenum; end;
if ~isfield(query_data, 'func_to_call'), query_data.func_to_call = []; end;
query_data.time_interval = query_data.time_interval * second_in_datenum;

% gets initi and final datetime in datenum format
initi_datenum = datenum(query_data.initi_datetime(1:6) .* [1 1 1 1 0 0]);
final_datenum = datenum(query_data.final_datetime(1:6) .* [1 1 1 1 0 0]);
if initi_datenum > final_datenum
    fprintf([datestr(now) ': initial date_time is posterior to final date_time!\n']);
    data = {};
    return;
end

% gets list of db files
db_list = get_db_file_names_list(initi_datenum, final_datenum, query_data.time_interval);

% gets all fields compatible with query
all_fields = {};
for i=1:length(db_list.db_file_name)
    db_file_name = db_list.db_file_name{i};
    field_names = lnlsasciidb_get_fields_from_mat_file(db_file_name);
    field_names = filter_fields(field_names(:), query_data.match_fields);
    all_fields = unique([all_fields(:); field_names(:)]);
end

% loops through all files and processes data
nr_db_files = 0;
for i=1:length(db_list.db_file_name)
    db_file_name = db_list.db_file_name{i};
    %fprintf([datestr(now) ': retriving query data for db file ' db_file_name '...\n']);
    nr_records_to_load = db_list.nr_records_to_load(i);
    field_names = lnlsasciidb_get_fields_from_mat_file(db_file_name);
    field_names = filter_fields(field_names(:), query_data.match_fields);
    if length(field_names) <= def_parms.small_nr_fields
        dbdata.db_name = db_file_name;
        dbdata.data = lnlsasciidb_get_data_from_mat_file(db_file_name, field_names, nr_records_to_load, '');
    else
        % if number of fields is <=28 loading all fields is actually
        % quicker (for around 1000 total fields) !!!
        dbdata.db_name = db_file_name;
        dbdata.data = lnlsasciidb_get_data_from_mat_file(db_file_name, [], nr_records_to_load, '');
        dbdata.data = removes_unasked_fields(dbdata.data, field_names);
    end
    dbdata = complete_fields_and_crops_records(dbdata, all_fields, initi_datenum, final_datenum);
    
    % sorts fields. DATAHORA remains the first field.
    if isempty(dbdata.data), continue; end;
    fields = fieldnames(dbdata.data);
    [fields idx] =  sort(fields(2:end));
    dbdata.data = orderfields(dbdata.data, [1; idx+1]);
    
    % passes data to function to proccess it.
    if ~isempty(query_data.func_to_call)
        nr_db_files = nr_db_files + 1;
        query_data.variable_name = ['data' int2str(nr_db_files)];
        query_data.func_to_call(query_data, dbdata);
    end
end


data = dbdata;


function data1 = complete_fields_and_crops_records(data0, fields, initi_datenum, final_datenum)

data1 = data0;
data_hora = data1.data.DATAHORA;
selection_ok = find((data_hora >= initi_datenum) & (data_hora <= final_datenum));
for j=1:length(fields)
    field_name = fields{j};
    if ~isfield(data1.data, field_name)
        data1.data.(field_name) = NaN * data1.data.DATAHORA;
    end
    %if length(selection_ok) ~= length(data1.data.(field_name))
        data = data1.data.(field_name);
        data1.data.(field_name) = cast(data(selection_ok),'double');
    %end
end
if isempty(data1.data.DATAHORA), data1.data = []; end;



function r =  removes_unasked_fields(r0, asked_field_names)

rm_field_idx = [];
field_names = fieldnames(r0);
for j=1:length(field_names)
    if isempty(find(strcmpi(field_names{j}, asked_field_names(:))))
        rm_field_idx = [rm_field_idx j];
    end
end
if ~isempty(rm_field_idx)
    r = rmfield(r0, field_names(rm_field_idx));
else
    r = r0;
end


function r = filter_fields(fields, strings)

r = {'DATAHORA'};
for i=1:length(fields)
    field = fields{i};
    found = false;
    for j=1:length(strings)
        found = found || ~isempty(regexpi(field, strings{j}));
    end
    if found, r{end+1} = field; end
end


function r = get_db_file_names_list(initi_datenum, final_datenum, query_time_interval_in_datenum)

hour_in_datenum = datenum([2010 10 13 1 0 0]) - datenum([2010 10 13 0 0 0]);

datenum_list = initi_datenum : max([hour_in_datenum query_time_interval_in_datenum]) : final_datenum;

def_parms = lnlsasciidb_load_default_parameters;
db_files  = dir(def_parms.mat_db_path);
db_files  = lnlsasciidb_sort_files(db_files);

r.db_file_name = {};
r.nr_records_to_load = [];
for i=1:length(db_files)
    if (db_files(i).isdir), continue; end;
    initi = lnlsasciidb_get_datenum(db_files(i).datevec .* [1 1 1 1 0 0 0]);
    final = lnlsasciidb_get_datenum(db_files(i).datevec .* [1 1 1 1 1 1 1]);
    if ((final >= initi_datenum) && (initi <= final_datenum))
        r.db_file_name = [r.db_file_name; strrep(db_files(i).name, '.mat', '')];
        r.nr_records_to_load = [r.nr_records_to_load; max([1 ceil(hour_in_datenum / query_time_interval_in_datenum)])];
    end
end
        
    
% 
% for i=1:length(datenum_list)
%     r.db_file_name{i} = datestr(datenum_list(i), 'yyyy_mm_dd_HH');
%     r.nr_records_to_load(i) = max([1 ceil(hour_in_datenum / query_time_interval_in_datenum)]);
% end





