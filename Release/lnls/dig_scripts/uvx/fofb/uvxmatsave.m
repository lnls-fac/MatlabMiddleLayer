function uvxmatsave(filename, matrix, beam_energy, row_names, column_names)

fileid = fopen(filename, 'w+');

fprintf(fileid, '%s\t%g\r\n', 'Beam Energy (MeV):', beam_energy);
fprintf(fileid, '\t%s', column_names{:});
fprintf(fileid, '\r\n');

for i=1:size(matrix, 1)
    fprintf(fileid, row_names{i});
    fprintf(fileid, '\t%0.10f', matrix(i,:));
    fprintf(fileid, '\r\n');
end

fclose(fileid);
