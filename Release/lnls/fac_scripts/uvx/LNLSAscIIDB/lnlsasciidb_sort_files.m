function r = lnlsasciidb_sort_files(data)

r = data;
for i=1:length(r)
    if r(i).isdir, continue; end;
    [pathstr, file, ext] = fileparts(r(i).name);
    year    = str2double(file(1:4));
    month   = str2double(file(6:7));
    day     = str2double(file(9:10));
    hour    = str2double(file(12:13));  
    if (length(file) > 13)
        minute  = str2double(file(15:16));
        second  = str2double(file(18:19));
        msecond = str2double(file(21:23));
    else
        minute  = 59;
        second  = 59;
        msecond = 999;
    end;
    r(i).datevec = [year month day hour minute second msecond];
    r(i).datenum = lnlsasciidb_get_datenum(r(i).datevec);
    datenum_vec(i) = r(i).datenum;
end
if ~isempty(r)
    tmp_data = r;
    [datenum_vec idx] = sort(datenum_vec);
    for i=1:length(r)
        r(i) = tmp_data(idx(i));
    end
end