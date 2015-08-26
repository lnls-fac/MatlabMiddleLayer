function bba = lnls1_measbba(varargin)
%Faz medida BBA (Beam-based alignment)
%
%Historia: 
%
%2013-10-09: mudada a estrutura de dados com info sobre bba a ser realizado (p/ ficar mais fácil selecionar BPMs)
%2012-10-11: adicionado delta_shunt_global = 3 para tentar melhorar a sensibilidade da medida.(Ximenes e Jefferson) 
%2011-04-04: adicionada rotina que gera arquivo *.orb para uso no OPR1 (Fernando)
%2010-09-13: comentarios iniciais no codigo (X.R.R.) 

delta_shunt_global = 3;  % [A]

bba_x_data = {};
bba_x_data{end+1} = {'AMP01B', 'AQF01B', delta_shunt_global, 'ACH07B', [-0.0825,+0.1025,7]};
bba_x_data{end+1} = {'AMP02A', 'AQF02A', delta_shunt_global, 'ACH09B', [-0.2675,+0.0937,7]};
bba_x_data{end+1} = {'AMP02B', 'AQF02B', delta_shunt_global, 'ACH07A', [+0.0272,+0.4184,7]};
bba_x_data{end+1} = {'AMP03A', 'AQF03A', delta_shunt_global, 'ACH09A', [-0.0770,+0.0910,7]};
%%%bba_x_data{end+1} = {'AMP03C', 'AQF03B', delta_shunt_global, 'ACH09B', [-0.2190,+0.2190,7]};
bba_x_data{end+1} = {'AMP03B', 'AQF03B', delta_shunt_global, 'ACH09B', [-0.0870,+0.0830,7]};
bba_x_data{end+1} = {'AMP04A', 'AQF04A', delta_shunt_global, 'ACH11B', [-0.0480,+0.3390,7]};
bba_x_data{end+1} = {'AMP04B', 'AQF04B', delta_shunt_global, 'ACH09A', [-0.3100,+0.0470,7]};
bba_x_data{end+1} = {'AMP05A', 'AQF05A', delta_shunt_global, 'ACH11A', [-0.108,+0.098,7]};
bba_x_data{end+1} = {'AMP05B', 'AQF05B', delta_shunt_global, 'ACH11B', [-0.076,+0.111,7]};
bba_x_data{end+1} = {'AMP06A', 'AQF06A', delta_shunt_global, 'ACH01A', [-0.1930,+0.1830,7]};
bba_x_data{end+1} = {'AMP06B', 'AQF06B', delta_shunt_global, 'ACH11A', [-0.1350,+0.2580,7]};
bba_x_data{end+1} = {'AMP07A', 'AQF07A', delta_shunt_global, 'ACH01A', [-0.0690,+0.1050,7]};
bba_x_data{end+1} = {'AMP07B', 'AQF07B', delta_shunt_global, 'ACH01B', [-0.1200,+0.1200,7]};
bba_x_data{end+1} = {'AMP08A', 'AQF08A', delta_shunt_global, 'ACH03B', [-0.1700,+0.2210,7]};
bba_x_data{end+1} = {'AMP08B', 'AQF08B', delta_shunt_global, 'ACH01A', [-0.1490,+0.2170,7]};
bba_x_data{end+1} = {'AMP09A', 'AQF09A', delta_shunt_global, 'ACH03A', [-0.0850,+0.0910,7]};
bba_x_data{end+1} = {'AMP09B', 'AQF09B', delta_shunt_global, 'ACH03B', [-0.0730,+0.0990,7]};
bba_x_data{end+1} = {'AMP10A', 'AQF10A', delta_shunt_global, 'ACH05B', [-0.2250,+0.1870,7]};
bba_x_data{end+1} = {'AMP10B', 'AQF10B', delta_shunt_global, 'ACH03A', [-0.1340,+0.2410,7]};
bba_x_data{end+1} = {'AMU11A', 'AQF11A', delta_shunt_global, 'ACH05A', [-0.143,+0.066,7]};
bba_x_data{end+1} = {'AMU11B', 'AQF11B', delta_shunt_global, 'ACH05B', [-0.068,+0.143,7]};
bba_x_data{end+1} = {'AMP12A', 'AQF12A', delta_shunt_global, 'ACH07B', [-0.2030,+0.1820,7]};
bba_x_data{end+1} = {'AMP12B', 'AQF12B', delta_shunt_global, 'ACH05A', [-0.1780,+0.2380,7]};
bba_x_data{end+1} = {'AMP01A', 'AQF01A', delta_shunt_global, 'ACH07A', [-0.0730,+0.1090,7]}; 

bba_y_data = {};
bba_y_data{end+1} = {'AMP01B', 'AQF01B', delta_shunt_global, 'ACV11A', [-0.0910,+0.0670,7]};
bba_y_data{end+1} = {'AMP02A', 'AQF02A', delta_shunt_global, 'ACV07B', [-0.1160,+0.1160,7]};
bba_y_data{end+1} = {'AMP02B', 'AQF02B', delta_shunt_global, 'ACV09B', [-0.1350,+0.1190,7]};
bba_y_data{end+1} = {'AMP03A', 'AQF03A', delta_shunt_global, 'ACV09A', [-0.0830,+0.0950,7]};
%%%bba_y_data{end+1} = {'AMP03C', 'AQF03B', delta_shunt_global, 'ACV01A', [-0.1500,+0.0500,7]};
bba_y_data{end+1} = {'AMP03B', 'AQF03B', delta_shunt_global, 'ACV09B', [-0.0980,+0.1090,7]};
bba_y_data{end+1} = {'AMP04A', 'AQF04A', delta_shunt_global, 'ACV03B', [-0.2300,+0.1340,7]};
bba_y_data{end+1} = {'AMP04B', 'AQF04B', delta_shunt_global, 'ACV11A', [-0.1270,+0.1110,7]};
bba_y_data{end+1} = {'AMP05A', 'AQF05A', delta_shunt_global, 'ACV11A', [-0.0870,+0.0730,7]};
bba_y_data{end+1} = {'AMP05B', 'AQF05B', delta_shunt_global, 'ACV11B', [-0.0770,+0.0910,7]};
bba_y_data{end+1} = {'AMP06A', 'AQF06A', delta_shunt_global, 'ACV11A', [-0.1440,+0.0840,7]};
bba_y_data{end+1} = {'AMP06B', 'AQF06B', delta_shunt_global, 'ACV07A', [-0.1000,+0.1000,7]};
bba_y_data{end+1} = {'AMP07A', 'AQF07A', delta_shunt_global, 'ACV09B', [-0.0790,+0.0810,7]};
bba_y_data{end+1} = {'AMP07B', 'AQF07B', delta_shunt_global, 'ACV01B', [-0.1500,+0.1500,7]};
bba_y_data{end+1} = {'AMP08A', 'AQF08A', delta_shunt_global, 'ACV07B', [-0.2331,+0.0531,7]};
bba_y_data{end+1} = {'AMP08B', 'AQF08B', delta_shunt_global, 'ACV03B', [-0.2100,+0.1660,7]};
bba_y_data{end+1} = {'AMP09A', 'AQF09A', delta_shunt_global, 'ACV11B', [-0.0390,+0.1410,7]};
bba_y_data{end+1} = {'AMP09B', 'AQF09B', delta_shunt_global, 'ACV07A', [-0.1000,+0.1000,7]};
bba_y_data{end+1} = {'AMP10A', 'AQF10A', delta_shunt_global, 'ACV09B', [-0.1340,+0.1110,7]};
bba_y_data{end+1} = {'AMP10B', 'AQF10B', delta_shunt_global, 'ACV11A', [-0.1410,+0.0880,7]};
bba_y_data{end+1} = {'AMU11A', 'AQF11A', delta_shunt_global, 'ACV11A', [-0.1220,+0.0840,7]};
bba_y_data{end+1} = {'AMU11B', 'AQF11B', delta_shunt_global, 'ACV11B', [-0.0840,+0.1460,7]};
bba_y_data{end+1} = {'AMP12A', 'AQF12A', delta_shunt_global, 'ACV11B', [-0.1080,+0.1310,7]};
bba_y_data{end+1} = {'AMP12B', 'AQF12B', delta_shunt_global, 'ACV07B', [-0.1030,+0.1180,7]};
bba_y_data{end+1} = {'AMP01A', 'AQF01A', delta_shunt_global, 'ACV07A', [-0.0600,+0.1030,7]};


%% inicializacoes basicas 
if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'Archive')
        default_filename = varargin{i+1};
    end
end

%% Pede ao usuario, se for o caso, que defina onde os dados da medidas serao gravados
if ~exist('default_filename', 'var')
    default_dir      = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics', datestr(now, 'yyyy-mm-dd'));
    if ~exist(default_dir, 'dir')
        mkdir(default_dir); 
        dir_created = true;
    end
    default_filename = ['bba_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat'];
    [FileName,PathName] = uiputfile('*.mat','Arquivo a ser salvo com medidas', fullfile(default_dir, default_filename));
    if FileName==0
        if exist('dir_created', 'var') && dir_created, rmdir(default_dir); end
        return; 
    end
    default_filename = fullfile(PathName, FileName);
end

%% configuracoes iniciais
if exist(default_filename, 'file')
    load(default_filename); 
else   
    bba = load_default_bba_config(bba_x_data, bba_y_data);
%   bba = load_corrector_range_from_last_measdata(bba);
    bba.configs.shunts.pause         = 1*1;
    bba.configs.shunts.nr_cycles     = 3;
    bba.configs.correctors.pause     = 1*1; 
    bba.configs.bpms.pause           = 1*0.5;
    bba.configs.bpms.nr_measurements = 5;
end

%% medida BBA
if ~isfield(bba, 'final_machineconfig')
    
    % ajustes iniciais
    setbpmaverages(bba.configs.bpms.pause, bba.configs.bpms.nr_measurements);
    fprintf('%s: desligando correcao de orbita automatica\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    lnls1_slow_orbcorr_off;
    lnls1_fast_orbcorr_off;
    fprintf('%s: ligando shunts\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    
    quads = [];
    for i=1:length(bba_x_data)
        quads = [quads; bba_x_data{i}{2}];
    end
    for i=1:length(bba_y_data)
        quads = [quads; bba_y_data{i}{2}];
    end
    lnls1_quad_shunts_on(quads);
    
    % XRR 2012-01-05: codigo de ajuste dos IDs comentado temporariamente.
    
    % fprintf('%s: abrindo dispositivos de inser��o\n', datestr(now,'yyyy-mm-dd_HH-MM-SS')); 
    % init_IDS = lnls1_set_id_configurations({'AON11GAP', 'AWG01GAP','AWG09FIELD'}); 
    % setpv('AON11VGAP_SP', 500);
    % setpv('AON11VFASE_SP', 500);
    % IDS(1) = struct('channel_name', 'AON11FASE',  'value',  0, 'tolerance', 0.1);
    % IDS(2) = struct('channel_name', 'AON11GAP',   'value',  300, 'tolerance', 0.5);
    % IDS(3) = struct('channel_name', 'AWG01GAP',   'value',  180, 'tolerance', 1.5);
    % lnls1_set_id_configurations(IDS);
    
    % mede bba
    bba.initial_time_stamp    = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    fprintf('%s: INICIO DE MEDIDAS BBA\n', bba.initial_time_stamp);
    bba.initial_machineconfig = getmachineconfig;
    if isfield(bba, 'bpm_x'), bba.bpm_x = do_bba('HCM', bba.bpm_x, bba.configs); end
    if isfield(bba, 'bpm_y'), bba.bpm_y = do_bba('VCM', bba.bpm_y, bba.configs); end
    bba.final_time_stamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    bba.final_machineconfig = getmachineconfig;
    
    % XRR 2012-01-05: codigo de ajuste dos IDs comentado temporariamente.
    
    % volta IDs a config original
    % fprintf('%s: voltando dispositivos de inser��o � configura��o original\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    % lnls1_set_id_configurations(init_IDS);
    
    fprintf('%s: FIM DE MEDIDAS BBA\n', bba.initial_time_stamp);

end

%% salva dados (Fiz alteracoes aqui e na funcao analysis_bba) - redundancia, caso aconteca algum erro no script de analise.
fprintf('\n%s: salvando dados\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
[pathstr namef] = fileparts(default_filename);
if ~exist(pathstr, 'dir')
    mkdir(pathstr); 
end
save(default_filename, 'bba');


%% measurement data has to be loaded manually at Matlab workspace at this point
% bba.bpm_x(5) = [];
% bba.bpm_y(5) = [];
% default_filename = 'C:\Arq\fac_files\code\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\2015-08-14\bba_2015-08-14_12-01-32.mat';
% [pathstr, namef] = fileparts(default_filename);
% if ~exist(pathstr, 'dir')
%     mkdir(pathstr); 
% end

%% faz analise das medidas
fprintf('\n%s: [ANALISE BBA HORIZONTAL]\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
if isfield(bba, 'bpm_x'), bba.bpm_x = analysis_bba('BPMx', bba.bpm_x); end
fprintf('\n%s: [ANALISE BBA VERTICAL]\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
if isfield(bba, 'bpm_y'), bba.bpm_y = analysis_bba('BPMy', bba.bpm_y); end

%% salva dados (Fiz alteracoes aqui e na funcao analysis_bba)
fprintf('\n%s: salvando dados\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
[pathstr namef] = fileparts(default_filename);
if ~exist(pathstr, 'dir')
    mkdir(pathstr); 
end
save(default_filename, 'bba');

% salva arquivo com ultimas medida na pasta principal, se em OPR2.
import java.net.Socket;
jtmp = java.net.Socket;
if strcmpi(jtmp.getLocalAddress.getLocalHost, 'OPR2')
    save('C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\last_bba.mat', 'bba');
end
clear jtmp;

%% Cria arquivo .orb:
orbfile = fullfile(pathstr,['BBA_' datestr(now,'yyyy-mm-dd') '.orb']);
BPMs = family2common('BPMx');
idf = fopen(orbfile,'a');
for i=1:size(BPMs,1),
    flaX = 'nOK';
    flaY = 'nOK';
    offsetX = NaN;
    offsetY = NaN;
    for j=1:length(bba.bpm_x)
        if strcmpi(bba.bpm_x{j}.bpm, BPMs(i,:))
            offsetX = bba.bpm_x{j}.offset; 
            flaX = bba.bpm_x{j}.fla;
        end
    end
    for j=1:length(bba.bpm_y)
        if strcmpi(bba.bpm_y{j}.bpm, BPMs(i,:))
            offsetY = bba.bpm_y{j}.offset; 
            flaY = bba.bpm_y{j}.fla;
        end
    end
    a = sprintf('%8.7f\t%8.7f\t',offsetX,offsetY);
    fprintf(idf,[a BPMs(i,:) '\t' flaX '\t' flaY '\r\n']);
end
fprintf(idf,'OFFSETH\t\tOFFSETV\t\tBPM\tSTATUSH\tSTATUSV\r\n\r\n');
fprintf(idf,['Medida de BBA realizada em ' datestr(now,'yyyy-mm-dd')...
    '\r\n Nome do arquivo .mat: ' namef] );
fclose(idf);
clear namef idf a orbfile;

%% registra experimento no historico
registra_historico(bba);

%% remove diretorio se vazio
files = dir(pathstr);
if (length(files)<3) 
    rmdir(PathName); 
end

function bba = load_default_bba_config(bba_x_data, bba_y_data)

    
bba.bpm_x = {};
for i=1:length(bba_x_data)
    bpm_data = bba_x_data{i};
    n = length(bba.bpm_x);
    bba.bpm_x{n+1}.bpm                 = bpm_data{1};
    bba.bpm_x{n+1}.shunt               = bpm_data{2};
    bba.bpm_x{n+1}.shunt_delta_amp     = bpm_data{3};
    bba.bpm_x{n+1}.corrector           = bpm_data{4};
    bba.bpm_x{n+1}.corrector_grid_mrad = linspace(bpm_data{5}(1), bpm_data{5}(2), bpm_data{5}(3));
    bba.bpm_x{n+1}.power_supply_off    = {};
end

bba.bpm_y = {};
for i=1:length(bba_y_data)
    bpm_data = bba_y_data{i};
    n = length(bba.bpm_y);
    bba.bpm_y{n+1}.bpm                 = bpm_data{1};
    bba.bpm_y{n+1}.shunt               = bpm_data{2};
    bba.bpm_y{n+1}.shunt_delta_amp     = bpm_data{3};
    bba.bpm_y{n+1}.corrector           = bpm_data{4};
    bba.bpm_y{n+1}.corrector_grid_mrad = linspace(bpm_data{5}(1), bpm_data{5}(2), bpm_data{5}(3));
    bba.bpm_y{n+1}.power_supply_off    = {};
end

function bba_data = do_bba(corrector_family, original_bba_data, configs)

bba_data = original_bba_data;

for i=1:length(bba_data)
   
    % prepara dados
    bba = bba_data{i};
    shunt_device = common2dev(bba.shunt, 'QUADSHUNT');
    corrector_device = common2dev(bba.corrector, corrector_family);
    initial_values_power_supply_off = zeros(1,length(bba.power_supply_off));
    for j=1:length(bba.power_supply_off)
        initial_values_power_supply_off(j) = getpv(bba.power_supply_off{j}, 'Setpoint');
    end
    initial_value_corrector = getpv(corrector_family, 'Setpoint', corrector_device, 'Physics');    
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
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': zerando possiveis fontes entre bpm e quadrupolo\n']);
    for j=1:length(bba.power_supply_off)
        setpv(bba.power_supply_off{j}, 0);
    end
    bba.dcct = [bba.dcct getdcct];
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrente = %f mA\n'], bba.dcct(end));
    
    % varre posi��o do feixe no bpm
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': varrendo corretora (orbita) [mrad]: ']);
    for j=1:length(bba.corrector_grid_mrad)
        
        fprintf('%+6.3f ', bba.corrector_grid_mrad(j));
        
        % ajusta corretora
        setpv(corrector_family, initial_value_corrector + bba.corrector_grid_mrad(j)/1000, corrector_device, 'Physics');
        pause(configs.correctors.pause);
        
        % registra �rbita original
        bba.orbit0{j} = [getx gety];
        
        % varia shunt
        steppv('QUADSHUNT','Setpoint', bba.shunt_delta_amp, shunt_device);
        pause(configs.shunts.pause);
        
        % registra �rbita final
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
    
    % A fun��o retorna um flag sobre a credibilidade do ponto de offset
    %('OK', ou 'nOK'). Foi necess�rio para a constru��o do arquivo .orb:
    bpm.fla = 'OK';
    if ((bpm.coeff_determination < 0.92) || bpm.extrapolation),
        plot_bba(bpm, direction, pos_bpm, rms);
        bpm.fla = 'nOK';
    end;
    
    bpm.pos_bpm = pos_bpm;
    bpm.rms = rms;
    
    % recalcula janela de kick centrada no offset e que gere desvios de
    % �rbita de +/- 1 mm
    delta = sort(interp1(pos_bpm, bpm.corrector_grid_mrad, bpm.offset + [-1 +1], 'spline', 'extrap'));
    bpm.new_corrector_grid_mrad = linspace(delta(1), delta(2), length(bpm.corrector_grid_mrad));
    
    % mostra resultado na an�lise:
    fprintf('[%s_%s] offset:%+5.0f um (%4.2f), novo_intervalo: [%+6.3f,%+6.3f] mrad, extrapolacaoo:%i\n', family_name, bpm.bpm, 1000*bpm.offset, bpm.coeff_determination, delta(1), delta(2), bpm.extrapolation);
    % insere dados de an�lise na estrutura
    bba{i} = bpm;
end

function plot_bba(bpm, direction, pos_bpm, rms)

if direction==1, bpm_label = [bpm.bpm '-H']; else bpm_label = [bpm.bpm '-V']; end;
figure('Name', bpm_label);
scatter(1e3*pos_bpm, 1e6*rms, 'filled');
xlabel('Posi��o [\mum]'); 
ylabel('RMS da distorsao de orbita [\mum^2]');
hold all;
pc = polyfit(pos_bpm,rms,2);
x = linspace(pos_bpm(1), pos_bpm(end), 30);
y = pc(1) * x.^2 + pc(2) * x + pc(3);
plot(1e3*x,1e6*y);
title(['BBA do ' bpm_label ' (' num2str(bpm.coeff_determination) ')']);

function registra_historico(bba)

def_bpm_names = [ ...
    'AMP01B'; ...
    'AMP02A'; 'AMP02B'; 'AMP03A'; 'AMP03B'; 'AMP03C'; 'AMP04A'; 'AMP04B'; ...
    'AMP05A'; 'AMP05B'; 'AMP06A'; 'AMP06B'; 'AMP07A'; 'AMP07B'; ...
    'AMP08A'; 'AMP08B'; 'AMP09A'; 'AMP09B'; 'AMP10A'; 'AMP10B'; ...
    'AMU11A'; 'AMU11B'; 'AMP12A'; 'AMP12B'; 'AMP01A' ];

bba_data_file = 'C:\Arq\fac_files\code\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\bba_data.mat';

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

function bba_final = load_corrector_range_from_last_measdata(bba0)

bba_final = bba0;

[FileName,PathName,tmp] = uigetfile;
 
filename = fullfile(PathName, FileName);
r = load(filename);

for i=1:length(bba_final.bpm_x)
    bpm = bba_final.bpm_x{i}.bpm;
    for idx=1:length(r.bba.bpm_x)
        if strcmpi(r.bba.bpm_x{idx}.bpm, bpm), break; end;
    end
    if (idx <= length(r.bba.bpm_x))
        bba_final.bpm_x{i}.corrector_grid_mrad = r.bba.bpm_x{idx}.new_corrector_grid_mrad;
        fprintf('H %s: %f %f \n', bpm, min(r.bba.bpm_x{i}.corrector_grid_mrad), max(r.bba.bpm_x{i}.corrector_grid_mrad));
    end
end

for i=1:length(bba_final.bpm_y)
    bpm = bba_final.bpm_y{i}.bpm;
    for idx=1:length(r.bba.bpm_y)
        if strcmpi(r.bba.bpm_y{idx}.bpm, bpm), break; end;
    end
    if (idx <= length(r.bba.bpm_y))
        bba_final.bpm_y{i}.corrector_grid_mrad = r.bba.bpm_y{idx}.new_corrector_grid_mrad;
        fprintf('V %s: %f %f \n', bpm, min(r.bba.bpm_y{i}.corrector_grid_mrad), max(r.bba.bpm_y{i}.corrector_grid_mrad));
    end
end
