function bba = lnls1_measbba2(varargin)
%Faz medida BBA (Beam-based alignment)
%
%História: 
%
%2010-09-13: comentários iniciais no código.


%% inicializações básicas
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'Archive')
        default_filename = varargin{i+1};
    end
end

%% Pede ao usuário, se for o caso, que defina onde os dados da medidas serão gravados
if ~exist('default_filename', 'var')
    default_dir      = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics', datestr(now, 'yyyy-mm-dd'));
    if ~exist(default_dir, 'dir')
        mkdir(default_dir); 
        dir_created = true;
    end
    default_filename = ['bba_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat'];
    [FileName,PathName] = uiputfile('*.mat','Arquivo a ser salvo com medidas', fullfile(default_dir, default_filename));
    if FileName==0
        if dir_created, rmdir(default_dir); end
        return; 
    end
    default_filename = fullfile(PathName, FileName);
end

%% configurações iniciais
if exist(default_filename, 'file')
    load(default_filename); 
else   
    bba = load_default_bba_config;
    bba.configs.shunts.pause         = 1;
    bba.configs.shunts.nr_cycles     = 3;
    bba.configs.correctors.pause     = 3; 
    bba.configs.bpms.pause           = 0.5;
    bba.configs.bpms.nr_measurements = 5;
end

%% medida BBA
if ~isfield(bba, 'final_machineconfig')
    
    % ajustes iniciais
    setbpmaverages(bba.configs.bpms.pause, bba.configs.bpms.nr_measurements);
    fprintf('%s: desligando correção de órbita automática\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    lnls1_slow_orbcorr_off;
    lnls1_fast_orbcorr_off;
    fprintf('%s: ligando shunts\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    lnls1_quad_shunts_on;
    fprintf('%s: abrindo dispositivos de inserção\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    init_IDS = lnls1_set_id_configurations({'AON11GAP', 'AWG01GAP'});
    IDS(1) = struct('channel_name', 'AON11GAP', 'value', 300, 'tolerance', 0.5);
    IDS(2) = struct('channel_name', 'AWG01GAP', 'value', 180, 'tolerance', 0.5);
    lnls1_set_id_configurations(IDS);
    
    % mede bba
    bba.initial_time_stamp    = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    fprintf('%s: INÍCIO DE MEDIDAS BBA\n', bba.initial_time_stamp);
    bba.initial_machineconfig = getmachineconfig;
    if isfield(bba, 'bpm_x'), bba.bpm_x = do_bba('HCM', bba.bpm_x, bba.configs); end
    if isfield(bba, 'bpm_y'), bba.bpm_y = do_bba('VCM', bba.bpm_y, bba.configs); end
    bba.final_time_stamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    bba.final_machineconfig = getmachineconfig;
    fprintf('%s: FIM DE MEDIDAS BBA\n', bba.initial_time_stamp);
    
    % volta IDs aa config original
    fprintf('%s: voltando dispositivos de inserção à configuração original\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    lnls1_set_id_configurations(init_IDS);

end


%% faz análise das medidas
fprintf('\n%s: [ANÁLISE BBA HORIZONTAL]\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
if isfield(bba, 'bpm_x'), bba.bpm_x = analysis_bba('BPMx', bba.bpm_x); end
fprintf('\n%s: [ANÁLISE BBA VERTICAL]\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
if isfield(bba, 'bpm_y'), bba.bpm_y = analysis_bba('BPMy', bba.bpm_y); end

%% salva dados
fprintf('\n%s: salvando dados\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
pathstr = fileparts(default_filename);
if ~exist(pathstr, 'dir')
    mkdir(pathstr); 
end
save(default_filename, 'bba');

%% registra experimento no histórico
registra_historico(bba);

%% remove diretório se vazio
files = dir(pathstr);
if (length(files)<3) 
    rmdir(PathName); 
end

function bba = load_default_bba_config

% --- monitores horizontais ---
n=0;

%% AMP09A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP09A';
bba.bpm_x{n}.shunt                = 'AQF09A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH03A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.102, +0.098, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.085,+0.091,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP09B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP09B';
bba.bpm_x{n}.shunt                = 'AQF09B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH03B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.111, +0.089, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.073,+0.099,7);
bba.bpm_x{n}.power_supply_off     = {};


%% --- monitores verticais ---
n=0;


%% AMP09A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP09A';
bba.bpm_y{n}.shunt                = 'AQF09A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.082, +0.118, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.039,+0.141,7); 
bba.bpm_y{n}.power_supply_off     = {};
%% AMP09B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP09B';
bba.bpm_y{n}.shunt                = 'AQF09B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV07A';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.162, +0.038, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.044,+0.114,7); 
bba.bpm_y{n}.power_supply_off     = {};


function bba_data = do_bba(corrector_family, original_bba_data, configs)

bba_data = original_bba_data;

for i=1:length(bba_data)
   
    % prepara dados
    bba = bba_data{i};
    shunt_device = common2dev(bba.shunt, 'QUADSHUNT');
    corrector_device = common2dev(bba.corrector, corrector_family);
    initial_values_power_supply_off = zeros(1,length(bba.power_supply_off));
    for j=1:length(bba.power_supply_off)
        initial_values_power_supply_off(j) = getpv(bba.power_supply_off{j});
    end
    initial_value_corrector = getpv(corrector_family, corrector_device, 'Physics');    
    bba.dcct = getdcct;
    
    fprintf('\n');
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': [%s]\n'], bba.bpm);
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': shunt %s\n'], bba.shunt);
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corretora %s\n'], bba.corrector);
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    % cicla shunt
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': ciclando shunt\n']);
    for j=1:configs.shunts.nr_cycles
        init_shunt = getpv('QUADSHUNT', 'Monitor', shunt_device);
        steppv('QUADSHUNT','Setpoint', bba.shunt_delta_amp, shunt_device);
        pause(configs.shunts.pause);
        final_shunt = getpv('QUADSHUNT', 'Monitor', shunt_device);
        if (abs(final_shunt - init_shunt - bba.shunt_delta_amp) > 0.1)
            bba.obs = 'problema durante ciclagem de shunt'; 
            fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': %s\n'], bba.obs); 
        end;
        steppv('QUADSHUNT','Setpoint', -bba.shunt_delta_amp, shunt_device);
        pause(configs.shunts.pause);
    end
    bba.dcct = [bba.dcct getdcct];
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    % zera fontes entre quadrupolo e bpm
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': zerando possíveis fontes entre bpm e quadrupolo\n']);
    for j=1:length(bba.power_supply_off)
        setpv(bba.power_supply_off{j}, 0);
    end
    bba.dcct = [bba.dcct getdcct];
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    % varre posição do feixe no bpm
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': varrendo corretora (órbita) [mrad]: ']);
    for j=1:length(bba.corrector_grid_mrad)
        
        fprintf('%+6.3f ', bba.corrector_grid_mrad(j));
        
        % ajusta corretora
        setpv(corrector_family, initial_value_corrector + bba.corrector_grid_mrad(j)/1000, corrector_device, 'Physics');
        pause(configs.correctors.pause);
        
        % registra órbita original
        bba.orbit0{j} = [getx gety];
        
        % varia shunt
        steppv('QUADSHUNT','Setpoint', bba.shunt_delta_amp, shunt_device);
        pause(configs.shunts.pause);
        
        % registra órbita final
        bba.orbit1{j} = [getx gety];
        
        % restaura shunt
        steppv('QUADSHUNT','Setpoint', -bba.shunt_delta_amp, shunt_device);
        pause(configs.shunts.pause);
        
    end
    fprintf('\n');
    bba.dcct = [bba.dcct getdcct];
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    % restaura valor original da corretora
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': restaurando valor original da corretora\n']);
    setpv(corrector_family, initial_value_corrector, corrector_device, 'Physics');
    pause(configs.correctors.pause);
    bba.dcct = [bba.dcct getdcct];
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    % restaura fontes entre quadrupolo e bpm
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': restaurando fontes entre bpm e quadrupolo\n']);
    for j=1:length(bba.power_supply_off)
        setpv(bba.power_supply_off{j}, initial_values_power_supply_off{j});
    end
    bba.dcct = [bba.dcct getdcct];
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    bba_data{i} = bba;
    
end

function bba = analysis_bba(family_name, original_bba)

bba = original_bba;

if strcmpi(family_name, 'BPMx'), direction = 1; else direction = 2; end;

for i=1:length(bba)
    bpm = bba{i};
    bpm_element = dev2elem(family_name, common2dev(bpm.bpm, family_name));
    rms = zeros(1,length(bpm.orbit1));
    pos_bpm = zeros(1,length(bpm.orbit1));
    
    for j=1:length(bpm.orbit1)
        cod    = bpm.orbit1{j} - bpm.orbit0{j};
        rms(j) = sum(cod(:,direction).^2)/length(cod(:,direction));
        pos_bpm(j)  = bpm.orbit0{j}(bpm_element, direction);
    end
    
    pc =  polyfit(pos_bpm, rms, 2);
    b  =  pc(1);
    x0 = -pc(2)/(2*b);
    a  =  pc(3) - b*x0^2;
    
    bpm.offset  = x0;
    if (bpm.offset > max(pos_bpm)) || (bpm.offset < min(pos_bpm)), bpm.extrapolation = true; else bpm.extrapolation = false; end;
    
    rms1    = a;
    rms2    = b*(pos_bpm - x0).^2;
    rms_fit = rms1 + rms2;
    
    s1 = sum((rms_fit - rms).^2);
    s2 = sum((rms - mean(rms)).^2);
    bpm.coeff_determination = 1 - s1/s2;
    if (rms1 > 50*10^-6), bpm.coeff_determination = -1; end
    if (max(abs(rms2)) < 1*10^-6), bpm.coeff_determination = -2; end
        
    if (bpm.coeff_determination < 0.99), plot_bba(bpm, direction, pos_bpm, rms); end;
    
    bpm.pos_bpm = pos_bpm;
    bpm.rms = rms;
    
    % recalcula janela de kick centrada no offset e que gere desvios de
    % órbita de +/- 1 mm
    delta = sort(interp1(pos_bpm, bpm.corrector_grid_mrad, bpm.offset + [-1 +1], 'spline', 'extrap'));
    bpm.new_corrector_grid_mrad = linspace(delta(1), delta(2), length(bpm.corrector_grid_mrad));
    
    % mostra resultado na análise:
    fprintf('[%s_%s] offset:%+5.0f um (%4.2f), novo_intervalo: [%+6.3f,%+6.3f] mrad, extrapolação:%i\n', family_name, bpm.bpm, 1000*bpm.offset, bpm.coeff_determination, delta(1), delta(2), bpm.extrapolation);
    % insere dados de análise na estrutura
    bba{i} = bpm;
end

function plot_bba(bpm, direction, pos_bpm, rms)

if direction==1, bpm_label = [bpm.bpm '-H']; else bpm_label = [bpm.bpm '-V']; end;
figure('Name', bpm_label);
scatter(1e3*pos_bpm, 1e6*rms, 'filled');
xlabel('Posição [\mum]'); 
ylabel('RMS da distorção de órbita [\mum^2]');
hold all;
pc = polyfit(pos_bpm,rms,2);
x = linspace(pos_bpm(1), pos_bpm(end), 30);
y = pc(1) * x.^2 + pc(2) * x + pc(3);
plot(1e3*x,1e6*y);
title(['BBA do ' bpm_label ' (' num2str(bpm.badness_of_fit) ')']);

function registra_historico(bba)

def_bpm_names = [ ...
    'AMP01B'; ...
    'AMP02A'; 'AMP02B'; 'AMP03A'; 'AMP03B'; 'AMP03C'; 'AMP04A'; 'AMP04B'; ...
    'AMP05A'; 'AMP05B'; 'AMP06A'; 'AMP06B'; 'AMP07A'; 'AMP07B'; ...
    'AMP08A'; 'AMP08B'; 'AMP09A'; 'AMP09B'; 'AMP10A'; 'AMP10B'; ...
    'AMU11A'; 'AMU11B'; 'AMP12A'; 'AMP12B'; 'AMP01A' ];

bba_data_file = 'C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\bba_data.mat';
bba_data = [];
if exist(bba_data_file, 'file'), load(bba_data_file); end;
data.time_stamp = bba.initial_time_stamp;
data.offsets = NaN * ones(size(def_bpm_names,1),2);

if isfield(bba, 'bpm_x')
for i=1:length(bba.bpm_x)
    for j=1:size(def_bpm_names)
        if strcmpi(def_bpm_names(j,:),bba.bpm_x{i}.bpm)
            data.offsets(j,1) = bba.bpm_x{i}.offset;
        end
    end
end
end

if isfield(bba, 'bpm_y')
for i=1:length(bba.bpm_y)
    for j=1:size(def_bpm_names)
        if strcmpi(def_bpm_names(j,:),bba.bpm_y{i}.bpm)
            data.offsets(j,2) = bba.bpm_y{i}.offset;
        end
    end
end
end

if ~isempty(bba_data)
    is_match = false;
    for i=1:length(bba_data)
        is_match = is_match || strcmpi(data.time_stamp, bba_data(i).time_stamp);
        if is_match, break; end
    end
    if is_match,
        bba_data(i) = data;
    else
        bba_data(end+1) = data;
    end
else
    bba_data = data; 
end

save(bba_data_file, 'bba_data');
assignin('base', 'bba_data', bba_data);

bba_data_file = strrep(bba_data_file, '.mat', '.txt');

fp = fopen(bba_data_file, 'w');
fprintf(fp, 'DATA\tHORA\t');
pvs = family2common('BPMx');
for i=1:size(pvs,1);
    fprintf(fp, '%sH\t', pvs(i,:));
end
for i=1:size(pvs,1);
    fprintf(fp, '%sV\t', pvs(i,:));
end
fprintf(fp, '\r\n');


for j=1:length(bba_data)
    data = bba_data(j);
    dn = datenum(data.time_stamp, 'yyyy-mm-dd_HH-MM-SS');
    ts = datestr(dn, 'dd/mm/yyyy HH:MM:SS');
    fprintf(fp, '%s\t', ts);
    for i=1:size(data.offsets,1)
        fprintf(fp, '%f\t', data.offsets(i,1));
    end
    for i=1:size(data.offsets,1)
        fprintf(fp, '%f\t', data.offsets(i,2));
    end
    fprintf(fp, '\r\n');
end
fclose(fp);
