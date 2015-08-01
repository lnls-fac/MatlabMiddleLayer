function kickmap_save_kickmap_tables(id_def, kickmaps)

dpsi_dx = kickmaps.kickx;
dpsi_dy = kickmaps.kicky;
posx    = kickmaps.posx;
posy    = kickmaps.posy;

sep_char = ' ';
% gera arquivo com mapa de kicks
fp = fopen([id_def.id_label '_kicktable.txt'], 'w');
fprintf(fp, ['# ' id_def.id_label ' KICKMAP \r\n']);
fprintf(fp, ['# Author: Ximenes R. Resende @ LNLS, Date: ' datestr(now) '\r\n']);
fprintf(fp,  '# ID Length [m]\r\n');
fprintf(fp,  '%6.4f\r\n', id_def.period * id_def.nr_periods / 1000);
fprintf(fp,  '# Number of Horizontal Points\r\n');
fprintf(fp,  '%i \r\n', size(dpsi_dx,2));
fprintf(fp,  '# Number of Vertical Points\r\n');
fprintf(fp,  '%i \r\n', size(dpsi_dx,1));

fprintf(fp,  '# Horizontal KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+11.8f', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=length(posy):-1:1
    fprintf(fp, '%+11.8f', posy(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+6.3E', dpsi_dx(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fprintf(fp,  '# Vertical KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+11.8f', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=length(posy):-1:1
    fprintf(fp, '%+11.8f', posy(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+6.3E', dpsi_dy(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fclose(fp);