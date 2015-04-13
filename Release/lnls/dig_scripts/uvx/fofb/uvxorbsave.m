function uvxorbsave(filename, orbit, bpm_names)

fileid = fopen(filename, 'w+');

for i=1:length(orbit)
    fprintf(fileid, bpm_names{i});
    fprintf(fileid, '\t%0.10f', orbit(i));
    fprintf(fileid, '\r\n');
end

fclose(fileid);
