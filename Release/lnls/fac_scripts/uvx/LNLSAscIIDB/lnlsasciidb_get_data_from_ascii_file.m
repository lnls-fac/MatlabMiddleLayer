function r = lnlsasciidb_get_data_from_ascii_file(db_file_name)

def_parms = lnlsasciidb_load_default_parameters;

file_name = fullfile(def_parms.ascii_db_path, [db_file_name def_parms.db_ascii_file_ext]);
data = importdata(file_name);

r.DATAHORA = datenum(data.data(:,1:6)) + data.data(:,7)/(24*60*60*1000);
for i=8:length(data.textdata)
    values = data.data(:,i);
    % downcasts data value type if possible to optimize disc space
    value_type = lnlsasciidb_get_cast_type(values);
    values = cast(values, value_type);
    r.(data.textdata{i}) = values;
end
