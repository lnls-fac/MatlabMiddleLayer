function r = lnls1_migconf_load
% Carrega configuração de rampa do anel
%
% Histórico
% 
% 2010-09-16: comentários iniciais no código

r.default_dir       = 'C:\Arq\Controle\BDADOS\CONFIGS\Normal\RUpDOwn';
[r.file_name, r.default_dir] = uigetfile({'*.rmw'},'Seleção de arquivo com rota de migração', r.default_dir);


fp = fopen(fullfile(r.default_dir, r.file_name), 'r');

nr_configs = str2double(fgetl(fp));
for i=1:nr_configs
    r.configs{i}.config_fname = fgetl(fp);
end
r.rf_habilita             = str2double(fgetl(fp));
r.wiggler_habilita        = str2double(fgetl(fp));
for i=1:nr_configs
    parms = sscanf(fgetl(fp), '%f %f %f %f %f');
    r.configs{i}.energy   = parms(1);
    r.configs{i}.rep_rate = parms(2);
    r.configs{i}.finesse  = parms(3);
    r.configs{i}.vg       = parms(4);
    r.configs{i}.dt       = parms(5);
end
r.wiggler_gap             = str2double(fgetl(fp));
r.nr_passos               = str2double(fgetl(fp));
r.epu_habilita            = str2double(fgetl(fp));
r.epu_velocidade          = str2double(fgetl(fp));
r.epu_gap                 = str2double(fgetl(fp));
r.epu_fase                = str2double(fgetl(fp));
for i=1:nr_configs
    r.configs{i}.optics_mode = fgetl(fp);
    r.configs{i}.response_matrix     = fgetl(fp);
    r.configs{i}.response_matrix_dir = fgetl(fp);
    r.configs{i}.orbit = fgetl(fp);
    r.configs{i}.orbit_fname = fgetl(fp);
    r.configs{i}.orbit_dir = fgetl(fp);
    r.configs{i}.corrector_set = fgetl(fp);
    r.configs{i}.power_supplies = read_conf(r.configs{i}.config_fname);
end
r.correcao_orbita  = str2double(fgetl(fp));
r.abrir_gama       = str2double(fgetl(fp));
r.carregar_injecao = str2double(fgetl(fp));
fclose(fp);

function r = read_conf(file_name)

% cria arquivo texto a partir do arquivo paradox
exe_path = fileparts(mfilename('fullpath'));
original_dir = pwd;
cd(exe_path);
cmd = ['dos(''' 'Paradox2AscII.exe' ' ' file_name ''')'];
tmp = evalc(cmd);
cd(original_dir);

% lê dados de rampa do arquivo texto gerado
file_name = strrep(file_name, '.DB', '.txt');
file_name = strrep(file_name, '.db', '.txt');
data = importdata(file_name);
r.fields = data.textdata(2:end,2);
r.values = data.data;

% apaga arquivo
delete(file_name);

 


