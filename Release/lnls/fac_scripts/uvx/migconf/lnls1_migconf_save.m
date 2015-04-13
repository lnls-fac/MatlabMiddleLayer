function lnls1_migconf_save(r, suffix_name)
% Salva arquivo de rampa e configurações correspondentes.
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)

[pathstr, name, ext] = fileparts(r.file_name);

new_file_name = fullfile(r.default_dir, fullfile(pathstr, [name suffix_name ext]));

fp = fopen(new_file_name, 'w');
fprintf('Arquivo de migração: %s\n', new_file_name);
fprintf(fp, '%i\r\n', length(r.configs));
for i=1:length(r.configs)
    [pathstr, name, ext] = fileparts(r.configs{i}.config_fname);
    fprintf('%i. %s\n', i, fullfile(pathstr, [name suffix_name ext]));
    fprintf(fp, '%s\r\n', fullfile(pathstr, [name suffix_name ext]));
end
fprintf(fp, '%i\r\n', r.rf_habilita);
fprintf(fp, '%i\r\n', r.wiggler_habilita);
for i=1:length(r.configs)
    fprintf(fp, '%.15E ', r.configs{i}.energy);
    fprintf(fp, '%.15E ', r.configs{i}.rep_rate);
    fprintf(fp, '%.15E ', r.configs{i}.finesse);
    fprintf(fp, '%.15E ', r.configs{i}.vg);
    fprintf(fp, '%.15E ', r.configs{i}.dt);
    fprintf(fp, '\r\n');
end
fprintf(fp, '%f\r\n', r.wiggler_gap);
fprintf(fp, '%i\r\n', r.nr_passos);
fprintf(fp, '%i\r\n', r.epu_habilita);
fprintf(fp, '%f\r\n', r.epu_velocidade);
fprintf(fp, '%f\r\n', r.epu_gap);
fprintf(fp, '%f\r\n', r.epu_fase);
for i=1:length(r.configs)
    fprintf(fp, '%s\r\n', r.configs{i}.optics_mode);
    fprintf(fp, '%s\r\n', r.configs{i}.response_matrix);
    fprintf(fp, '%s\r\n', r.configs{i}.response_matrix_dir);
    fprintf(fp, '%s\r\n', r.configs{i}.orbit);
    fprintf(fp, '%s\r\n', r.configs{i}.orbit_fname);
    fprintf(fp, '%s\r\n', r.configs{i}.orbit_dir);
    fprintf(fp, '%s\r\n', r.configs{i}.corrector_set);
    [pathstr, name, ext] = fileparts(r.configs{i}.config_fname);
    save_conf(r.configs{i}, fullfile(pathstr, [name suffix_name ext]));
end
fprintf(fp, '%i\r\n', r.correcao_orbita);
fprintf(fp, '%i\r\n', r.abrir_gama);
fprintf(fp, '%i\r\n', r.carregar_injecao);
fclose(fp);

function save_conf(config, file_name)

[exe_path fname] = fileparts(file_name);

% cria arquivo texto com configuração
txt_file_name = file_name;
txt_file_name = strrep(txt_file_name, '.db', '.txt');
txt_file_name = strrep(txt_file_name, '.DB', '.txt');
fp = fopen(txt_file_name, 'w');
fprintf(fp, '%s\tNOME\tFORCA\r\n', fname);
for i=1:length(config.power_supplies.fields)
    fprintf(fp, '%i\t%s\t%+16.13f\r\n', i, config.power_supplies.fields{i}, config.power_supplies.values(i));
end
fclose(fp);

% cria arquivo paradox a partir do arquivo texto
exe_path = fileparts(mfilename('fullpath'));
original_dir = pwd;
cd(exe_path);
cmd = ['dos(''' 'Paradox2AscII.exe' ' ' txt_file_name ''')'];
tmp = evalc(cmd);
cd(original_dir);

% apaga arquivo
delete(txt_file_name);
