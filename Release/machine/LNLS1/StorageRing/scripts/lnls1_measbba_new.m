function r = lnls1_measbba(varargin)

% processa argumentos
for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'Archive')
        r.default_filename = varargin{i+1};
    end
end

% registra nome do computador onde script está sendo rodado
jtmp = java.net.Socket;
r.local_host_string = char(jtmp.getLocalAddress.getLocalHost);
r.mml_mode = getmode('BEND');

% monta configurações
r = build_bba_configuration(r);
if strcmpi(r.mml_mode, 'Online') %|| true
    r.bba_parameters.shunts_pause          = 1;
    r.bba_parameters.shunts_nr_cycles      = 3;
    r.bba_parameters.shunts_delta_current  = 1;
    r.bba_parameters.correctors_pause      = 1;
    r.bba_parameters.bpms_pause            = 0.5;
    r.bba_parameters.bpms_nr_measurements  = 5;
else
    r.bba_parameters.shunts_pause          = 0;
    r.bba_parameters.shunts_nr_cycles      = 1;
    r.bba_parameters.shunts_delta_current  = 1;
    r.bba_parameters.correctors_pause      = 0;
    r.bba_parameters.bpms_pause            = 0.01;
    r.bba_parameters.bpms_nr_measurements  = 2;
end
r = modify_bba_configuration(r);

% Ajusta configuração inicial da máquina
r = initial_machine_setup(r);

% Medida BBA
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': INÍCIO DE MEDIDAS BBA\n']);
r.init_machineconfig = getmachineconfig;
for i=1:length(r.bpms)
    fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': ' r.bpms(i).bpm.name '\n']);
    r = measbba_bpm(r, i);
end
r.final_machineconfig = getmachineconfig;

% Ajusta configuração final da máquina
r = final_machine_setup(r);

function r = measbba_bpm(r0, bpm_idx)

r = r0;

bpm = r.bpms(bpm_idx);
params = r.bba_parameters;

if bpm.bba_flag(1)
    % BBA HORIZONTAL
    bba.init_hcorrectors_setpoint = getsp('HCM', 'Hardware');
    ref_h_orb = bpm.previous_offset(1);
    del_h_orb = bpm.delta_orbit(1);
    nr_h_pts  = bpm.nr_points(1);
    bba.h_pos_nominal = linspace(ref_h_orb - del_h_orb, ref_h_orb + del_h_orb, nr_h_pts);
    
    
    for i=1:length(bba.h_pos_nominal)
        
        % ajusta posição da órbita no BPM e registra
        correct_orbit(r.bba_parameters, bpm, 'BPMx', [bba.h_pos_nominal(i) bpm.previous_offset(2)]);
        bba.h_orb1(:,i) = getx;
        bba.h_pos_real(i) = bba.h_orb1(bpm.bpm.element,i);
        
        % step up do shunt
        init_shunt = getpv('QUADSHUNT', 'Monitor', 'Hardware', bpm.quadrupole.device);
        steppv('QUADSHUNT','Setpoint', 'Hardware', params.shunts_delta_current, bpm.quadrupole.device);
        pause(params.shunts_pause);
        final_shunt = getpv('QUADSHUNT', 'Monitor', 'Hardware', bpm.quadrupole.device);
        r = check_error_in_shunt_cycling(r,init_shunt,final_shunt,bpm.quadrupole.device);
        
        % registra órbita
        bba.h_orb2(:,i) = getx;
        
        % step down do shunt
        init_shunt = getpv('QUADSHUNT', 'Monitor' , 'Hardware' , bpm.quadrupole.device);
        steppv('QUADSHUNT','Setpoint', 'Hardware', -params.shunts_delta_current, bpm.quadrupole.device);
        pause(params.shunts_pause);
        final_shunt = getpv('QUADSHUNT', 'Monitor' , 'Hardware', bpm.quadrupole.device);
        r = check_error_in_shunt_cycling(r,final_shunt,init_shunt,bpm.quadrupole.device);
        
        bba.h_rms(i) = sqrt(sum((bba.h_orb2(:,i) - bba.h_orb1(:,i)).^2)/length(bba.h_orb2(:,i)));
        
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': %i %f[mm] %f[mm] %f[um]\n'], i, bba.h_pos_nominal(i),  bba.h_pos_real(i), 1000*bba.h_rms(i));
        
    end
    setsp('HCM', 'Hardware', bba.init_hcorrectors_setpoint);
end

if bpm.bba_flag(2)
    % BBA VERTICAL
    bba.init_vcorrectors_setpoint = getsp('VCM', 'Hardware');
    setsp('VCM', 'Hardware', bba.init_vcorrectors_setpoint);
end

r.bpms(bpm_idx).bba = bba;

function correct_orbit(params, bpm, BPMFam, target_pos)

MX = bpm.h_corrector.corrector_matrix;
MY = bpm.v_corrector.corrector_matrix;

if strcmpi(BPMFam, 'BPMx')
    
    pos = getam('BPMx', bpm.bpm.device);
    delta_orbit = target_pos(1) - pos;
    delta_kicks = MX * delta_orbit; % mm and mrad
    stepsp('HCM', 'Physics', delta_kicks/1000);
    
    pos = getam('BPMy', bpm.bpm.device);
    delta_orbit = target_pos(2) - pos;
    delta_kicks = MY * delta_orbit; % mm and mrad
    stepsp('VCM', 'Physics', delta_kicks/1000);
    
else
    
    pos = getam('BPMy', bpm.bpm.device);
    delta_orbit = target_pos(2) - pos;
    delta_kicks = MY * delta_orbit; % mm and mrad
    stepsp('VCM', 'Physics', delta_kicks/1000);
    
    pos = getam('BPMx', bpm.bpm.device);
    delta_orbit = target_pos(1) - pos;
    delta_kicks = MX * delta_orbit; % mm and mrad
    stepsp('HCM', 'Physics', delta_kicks/1000);
    
end

pause(params.correctors_pause);


function r = initial_machine_setup(r0)

r = r0;
r.init_time_stamp = clock;

% parâmetros de registro de órbita
setbpmaverages(r.bba_parameters.bpms_pause, r.bba_parameters.bpms_nr_measurements);
fprintf('%s: desligando correção de órbita automática\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
lnls1_slow_orbcorr_off;
lnls1_fast_orbcorr_off;

% ligando shunts
fprintf('%s: ligando shunts\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
lnls1_quad_shunts_on;

% Abertura de IDs
fprintf('%s: abrindo dispositivos de inserção\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
% primeiramente seta velocidades do AON11
r.ids.init_speed = lnls1_set_id_configurations({'AON11VGAP', 'AON11VFASE'});
IDS(1) = struct('channel_name', 'AON11VGAP', 'value', 500, 'tolerance', 0.5);
IDS(2) = struct('channel_name', 'AON11VFASE', 'value', 500, 'tolerance', 0.5);
lnls1_set_id_configurations(IDS);
% ajusta campos dos IDs
r.ids.init_fields = lnls1_set_id_configurations({'AON11GAP', 'AON11FASE', 'AWG01GAP','AWG09FIELD'});
IDS(1) = struct('channel_name', 'AON11FASECSD', 'value', 0, 'tolerance', 0.1);
IDS(3) = struct('channel_name', 'AON11FASECIE', 'value', 0, 'tolerance', 0.1);
IDS(3) = struct('channel_name', 'AON11GAP', 'value', 300, 'tolerance', 0.5);
IDS(4) = struct('channel_name', 'AWG01GAP', 'value', 180, 'tolerance', 0.5);
%IDS(4) = struct('channel_name', 'AWG09FIELD', 'value', 0.2, 'tolerance', 0.05);
lnls1_set_id_configurations(IDS);

% cicla shunt
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': ciclando shunts\n']);
shunts_device_list = [];
for i=1:length(r.bpms)
    if any(r.bpms(i).bba_flag), shunts_device_list = [shunts_device_list; r.bpms(i).quadrupole.device]; end
end
for i=1:r.bba_parameters.shunts_nr_cycles
    % step up
    init_shunts = getpv('QUADSHUNT', 'Monitor', 'Hardware', shunts_device_list);
    steppv('QUADSHUNT','Setpoint', 'Hardware', r.bba_parameters.shunts_delta_current, shunts_device_list);
    pause(r.bba_parameters.shunts_pause);
    final_shunts = getpv('QUADSHUNT', 'Monitor', 'Hardware', shunts_device_list);
    r = check_error_in_shunt_cycling(r,init_shunts,final_shunts,shunts_device_list);
    % step down
    init_shunts = getpv('QUADSHUNT', 'Monitor' , 'Hardware' , shunts_device_list);
    steppv('QUADSHUNT','Setpoint', 'Hardware', -r.bba_parameters.shunts_delta_current, shunts_device_list);
    pause(r.bba_parameters.shunts_pause);
    final_shunts = getpv('QUADSHUNT', 'Monitor' , 'Hardware', shunts_device_list);
    r = check_error_in_shunt_cycling(r,final_shunts,init_shunts,shunts_device_list);
end

function r = final_machine_setup(r0)

r = r0;
r.final_time_stamp = clock;

% desligando shunts
fprintf('%s: desligando shunts\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
lnls1_quad_shunts_off;
% Abertura de IDs
fprintf('%s: restaurando configuração dos dispositivos de inserção\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
lnls1_set_id_configurations(r.ids.init_fields);
% primeiramente seta velocidades do AON11
lnls1_set_id_configurations(r.ids.init_speed);




function r = check_error_in_shunt_cycling(r0,v1,v2,shunt_device_list)

r = r0;
shunts_in_error = find(abs(v2 - v1 - r.bba_parameters.shunts_delta_current) > 0.1);
if ~isempty(shunts_in_error)
    fprintf([datestr ': durante ciclagem problemas com o(s) shunt(s) ']);
    for j=1:length(shunts_in_error)
        shunt_name = dev2common('QUADSHUNT', shunt_device_list(shunts_in_error(j),:));
        fprintf([shunt_name ' ']);
    end
    fprintf('\n');
end

function r = modify_bba_configuration(r0)

r = r0;
%r = exclude_all(r);
%r = include(r, ['AMP01A';'AMP03B']);

function r = build_bba_configuration(r0)

r = r0;

bpms = getfamilydata('BPMx','CommonNames');

for bpm_idx=1:size(bpms,1)
    % parâmetros MML do BPM
    d.bpm.name = bpms(bpm_idx,:);
    d.bpm.element = bpm_idx;
    d.bpm.device = elem2dev('BPMx', bpm_idx);
    d.bpm.pos = getfamilydata('BPMx', 'Position', d.bpm.device);
    % quadrupolo mais próximo do BPM
    d.quadrupole = find_closest_quadrupole(d.bpm);
    % corretoras mais eficientes a serem utilizadas
    [d.h_corrector d.v_corrector] = find_best_correctors(d.bpm);
    % flag indicando se BPM é para ser medido ([X Y])
    d.bba_flag = [true true];
    d.previous_offset = [0 0];
    d.delta_orbit = [1 1]; % mm para cada lado
    d.nr_points = [7 7];
    % inclui dados no vetor com todos os BPMs
    r.bpms(bpm_idx) = d;
end

function quadrupole = find_closest_quadrupole(bpm)

quad_pos = getfamilydata('QUADSHUNT', 'Position');
[quad_distance quad_idx] = min(abs(quad_pos - bpm.pos));
quadrupole.device = elem2dev('QUADSHUNT', quad_idx);
quadrupole.name = family2common('QUADSHUNT', quadrupole.device);
quadrupole.pos = getfamilydata('QUADSHUNT', 'Position', quadrupole.device);
quadrupole.distance_from_bpm = quad_distance;
function [h_corrector v_corrector] = find_best_correctors(bpm)

respm = getbpmresp('Struct','Physics');

% procura na matriz resposta horizontal a linha que corresponde ao BPM
dl = respm(1,1).Monitor.DeviceList;
bpmx = (dl(:,1) == bpm.device(1)) & (dl(:,2) == bpm.device(2));
% procura corretor horizontal mais eficiente e registra dados
[~, h_corrector.element_in_respm] = max(abs(respm(1,1).Data(bpmx,:)));
h_corrector.device = respm(1,1).Actuator.DeviceList(h_corrector.element_in_respm,:);
h_corrector.element = dev2elem('HCM', h_corrector.device);
h_corrector.name = dev2common('HCM', h_corrector.device);
h_corrector.response_matrix = respm(1,1).Data(bpmx,:);
[U,S,V] = svd(h_corrector.response_matrix, 'econ');
h_corrector.corrector_matrix = V*inv(S)*U';

% procura na matriz resposta vertical a linha que corresponde ao BPM
dl = respm(2,2).Monitor.DeviceList;
bpmy = (dl(:,1) == bpm.device(1)) & (dl(:,2) == bpm.device(2));
% procura corretor vertical mais eficiente e registra dados
[~, v_corrector.element_in_respm] = max(abs(respm(2,2).Data(bpmy,:)));
v_corrector.device = respm(2,2).Actuator.DeviceList(v_corrector.element_in_respm,:);
v_corrector.element = dev2elem('VCM', v_corrector.device);
v_corrector.name = dev2common('VCM', v_corrector.device);
v_corrector.response_matrix = respm(2,2).Data(bpmy,:);
[U,S,V] = svd(v_corrector.response_matrix, 'econ');
v_corrector.corrector_matrix = V*inv(S)*U';



function r = exclude_all(r0)
r =  r0;
for i=1:length(r.bpms)
    r.bpms(i).bba_flag = [false false];
end
function r = exclude_all_horizontal(r0)
r =  r0;
for i=1:length(r.bpms)
    r.bpms(i).bba_flag(1) = false;
end
function r = exclude_all_vertical(r0)
r =  r0;
for i=1:length(r.bpms)
    r.bpms(i).bba_flag(2) = false;
end
function r = include_all(r0)
r = r0;
for i=1:length(r.bpms)
    r.bpms(i).bba_flag = [true true];
end
function r = include_all_horizontal(r0)
r = r0;
for i=1:length(r.bpms)
    r.bpms(i).bba_flag(1) = true;
end
function r = include_all_vertical(r0)
r = r0;
for i=1:length(r.bpms)
    r.bpms(i).bba_flag(2) = true;
end
function r = include(r0, bpm)
r = r0;
for i=1:size(bpm,1)
    for j=1:length(r.bpms)
        if strcmpi(r.bpms(j).bpm.name, bpm(i,:))
            r.bpms(j).bba_flag = [true true];
        end
    end
end
function r = include_horizontal(r0, bpm)
r = r0;
for i=1:size(bpm,1)
    for j=1:length(r.bpms)
        if strcmpi(r.bpms(j).bpm.name, bpm(i,:))
            r.bpms(j).bba_flag(1) = true;
        end
    end
end
function r = include_vertical(r0, bpm)
r = r0;
for i=1:size(bpm,1)
    for j=1:length(r.bpms)
        if strcmpi(r.bpms(j).bpm.name, bpm(i,:))
            r.bpms(j).bba_flag(2) = true;
        end
    end
end
function r = exclude(r0, bpm)
r = r0;
for i=1:size(bpm,1)
    for j=1:length(r.bpms)
        if strcmpi(r.bpms(j).bpm.name, bpm(i,:))
            r.bpms(j).bba_flag = [false false];
        end
    end
end
function r = exclude_horizontal(r0, bpm)
r = r0;
for i=1:size(bpm,1)
    for j=1:length(r.bpms)
        if strcmpi(r.bpms(j).bpm.name, bpm(i,:))
            r.bpms(j).bba_flag(1) = false;
        end
    end
end
function r = exclude_vertical(r0, bpm)
r = r0;
for i=1:size(bpm,1)
    for j=1:length(r.bpms)
        if strcmpi(r.bpms(j).bpm.name, bpm(i,:))
            r.bpms(j).bba_flag(2) = false;
        end
    end
end







function bba = lnls1_measbba2(varargin)
%Faz medida BBA (Beam-based alignment)
%
%História:
%
%2011-04-04: adicionada rotina que gera arquivo *.orb para uso no OPR1 (Fernando)
%2010-09-13: comentários iniciais no código (X.R.R.)


%% inicializações básicas
%if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

% registra nome do computador onde script é rodado
import java.net.Socket;
jtmp = java.net.Socket;
bba.local_host = jtmp.getLocalAddress.getLocalHost;
bba.mode = getmode('BEND');

for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'Archive')
        default_filename = varargin{i+1};
    end
end

%% Pede ao usuário, se for o caso, que defina onde os dados da medidas serão gravados
if ~exist('default_filename', 'var')
    if strcmpi(bpm.local_host, 'OPR2') && strcmpi(bpm.mode, 'Online')
        default_dir      = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics', datestr(now, 'yyyy-mm-dd'));
    else
        default_dir      = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics', 'SIMULATIONS');
    end
    gotodirectory(default_dir)
    
    default_filename = ['bba_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat'];
    [FileName,PathName] = uiputfile('*.mat','Arquivo a ser salvo com medidas', fullfile(default_dir, default_filename));
    if FileName==0
        try
            rmdir(default_dir);
        catch
        end
        return;
    end
    
    default_filename = fullfile(PathName, FileName);
end

%% configurações iniciais
if exist(default_filename, 'file')
    load(default_filename);
else
    bba = load_default_bba_config;
    bba = load_corrector_range_from_last_measdata(bba);
    bba.configs.shunts.pause         = 1;
    bba.configs.shunts.nr_cycles     = 3;
    bba.configs.correctors.pause     = 1;
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
    init_IDS = lnls1_set_id_configurations({'AON11GAP', 'AWG01GAP','AWG09FIELD'});
    
    IDS(1) = struct('channel_name', 'AON11VGAP', 'value', 500, 'tolerance', 0.5);
    IDS(2) = struct('channel_name', 'AON11VFASE', 'value', 500, 'tolerance', 0.5);
    lnls1_set_id_configurations(IDS);
    
    IDS(1) = struct('channel_name', 'AON11FASE', 'value', 0, 'tolerance', 0.1);
    lnls1_set_id_configurations(IDS);
    
    IDS(1) = struct('channel_name', 'AON11GAP', 'value', 300, 'tolerance', 0.5);
    IDS(2) = struct('channel_name', 'AWG01GAP', 'value', 180, 'tolerance', 0.5);
    %IDS(3) = struct('channel_name', 'AWG09FIELD', 'value', 0.2, 'tolerance', 0.05);
    lnls1_set_id_configurations(IDS);
    
    % mede bba
    bba.initial_time_stamp    = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    fprintf('%s: INÍCIO DE MEDIDAS BBA\n', bba.initial_time_stamp);
    bba.initial_machineconfig = getmachineconfig;
    if isfield(bba, 'bpm_x'), bba.bpm_x = do_bba('HCM', bba.bpm_x, bba.configs); end
    if isfield(bba, 'bpm_y'), bba.bpm_y = do_bba('VCM', bba.bpm_y, bba.configs); end
    bba.final_time_stamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
    bba.final_machineconfig = getmachineconfig;
    
    % volta IDs aa config original
    fprintf('%s: voltando dispositivos de inserção à configuração original\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
    lnls1_set_id_configurations(init_IDS);
    
    fprintf('%s: FIM DE MEDIDAS BBA\n', bba.initial_time_stamp);
    
end


%% faz análise das medidas
fprintf('\n%s: [ANÁLISE BBA HORIZONTAL]\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
if isfield(bba, 'bpm_x'), bba.bpm_x = analysis_bba('BPMx', bba.bpm_x); end
fprintf('\n%s: [ANÁLISE BBA VERTICAL]\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
if isfield(bba, 'bpm_y'), bba.bpm_y = analysis_bba('BPMy', bba.bpm_y); end

%% salva dados (Fiz alterações aqui e na função analysis_bba)
fprintf('\n%s: salvando dados\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
[pathstr namef] = fileparts(default_filename);
gotodirectory(pathstr);
save(default_filename, 'bba');

% salva arquivo com ultimas medida na pasta principal, se em OPR2.
import java.net.Socket;
jtmp = java.net.Socket;
if strcmpi(jtmp.getLocalAddress.getLocalHost, 'OPR2')
    save(fullfile(pathstr,'last_BBA.mat'), 'bba');
end
clear jtmp;

%% Cria arquivo .orb


bpm_names = get_bpm_names;
for i=1:size(bpm_names)
    
end

orbfile = fullfile(pathstr,['BBA_' datestr(now,'yyyy-mm-dd') '.orb']);
idf = fopen(orbfile,'a');
for i=1:25,
    a = sprintf('%+08.7f\t%+08.7f\t',bba.bpm_x{i}.offset,bba.bpm_y{i}.offset);
    
    fprintf(idf,[a bba.bpm_x{i}.bpm '\t' bba.bpm_x{i}.fla '\t' bba.bpm_y{i}.fla '\r\n']);
    
end
fprintf(idf,'OFFSETH\t\tOFFSETV\t\tBPM\tSTATUSH\tSTATUSV\r\n\r\n');
fprintf(idf,['Medida de BBA realizada em ' datestr(now,'yyyy-mm-dd')...
    '\r\n Nome do arquivo .mat: ' namef] );
fclose(idf);
clear namef idf a orbfile;

%% registra experimento no histórico
registra_historico(bba);

%% remove diretório se vazio
files = dir(pathstr);
if (length(files)<3)
    rmdir(PathName);
end

function bba = load_default_bba_config



%% --- monitores horizontais ---
n=0;



%% AMP01B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP01B';
bba.bpm_x{n}.shunt                = 'AQF01B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH07B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.078, +0.122, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.0825,0.1025,7);
bba.bpm_x{n}.power_supply_off     = {};


%% AMP02A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP02A';
bba.bpm_x{n}.shunt                = 'AQF02A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH09B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(+0.015, +0.215, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.2675,0.0937,7) ;
bba.bpm_x{n}.power_supply_off     = {};


%% AMP02B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP02B';
bba.bpm_x{n}.shunt                = 'AQF02B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH07A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.265, -0.065, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(0.0272,0.4184,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP03A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP03A';
bba.bpm_x{n}.shunt                = 'AQF03A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH09A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.117, +0.083, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.077,+0.091,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP03B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP03B';
bba.bpm_x{n}.shunt                = 'AQF03B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH09B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.109, +0.091, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.087,+0.083,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP03C
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP03C';
bba.bpm_x{n}.shunt                = 'AQF03B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH09B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.044, +0.156, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.219,+0.219,7);
bba.bpm_x{n}.power_supply_off     = {};



%% AMP04A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP04A';
bba.bpm_x{n}.shunt                = 'AQF04A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH11B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.292, -0.092, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.048,+0.339,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP04B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP04B';
bba.bpm_x{n}.shunt                = 'AQF04B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH09A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(+0.108, +0.308, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.310,+0.047,7);
bba.bpm_x{n}.power_supply_off     = {};



%% AMP05A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP05A';
bba.bpm_x{n}.shunt                = 'AQF05A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH11A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.075, +0.125, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.109,+0.079,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP05B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP05B';
bba.bpm_x{n}.shunt                = 'AQF05B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH11B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.104, +0.096, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.085,+0.099,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP06A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP06A';
bba.bpm_x{n}.shunt                = 'AQF06A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH01A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.057, +0.143, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.193,+0.183,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP06B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP06B';
bba.bpm_x{n}.shunt                = 'AQF06B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH11A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.138, +0.062, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.135,+0.258,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP07A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP07A';
bba.bpm_x{n}.shunt                = 'AQF07A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH01A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.101, +0.099, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.069,+0.105,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP07B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP07B';
bba.bpm_x{n}.shunt                = 'AQF07B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH01B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.068, +0.132, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.095,+0.080,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP08A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP08A';
bba.bpm_x{n}.shunt                = 'AQF08A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH03B';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.107, +0.093, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.156,+0.201,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP08B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP08B';
bba.bpm_x{n}.shunt                = 'AQF08B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH01A';
%bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.109, +0.091, 5);
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.149,+0.217,7);
bba.bpm_x{n}.power_supply_off     = {};
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
%% AMP10A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP10A';
bba.bpm_x{n}.shunt                = 'AQF10A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH05B';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.225,+0.187,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP10B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP10B';
bba.bpm_x{n}.shunt                = 'AQF10B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH03A';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.134,+0.241,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMU11A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMU11A';
bba.bpm_x{n}.shunt                = 'AQF11A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH05A';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.116,+0.078,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMU11B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMU11B';
bba.bpm_x{n}.shunt                = 'AQF11B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH05B';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.125,+0.064,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP12A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP12A';
bba.bpm_x{n}.shunt                = 'AQF12A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH07B';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.203,+0.182,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP12B
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP12B';
bba.bpm_x{n}.shunt                = 'AQF12B';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH05A';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.178,+0.238,7);
bba.bpm_x{n}.power_supply_off     = {};
%% AMP01A
n=n+1;
bba.bpm_x{n}.bpm                  = 'AMP01A';
bba.bpm_x{n}.shunt                = 'AQF01A';
bba.bpm_x{n}.shunt_delta_amp      = 1.0;
bba.bpm_x{n}.corrector            = 'ACH07A';
bba.bpm_x{n}.corrector_grid_mrad  = linspace(-0.073,+0.109,7);
bba.bpm_x{n}.power_supply_off     = {};





%% --- monitores verticais ---
n=0;


%% AMP01B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP01B';
bba.bpm_y{n}.shunt                = 'AQF01B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11A';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.095, +0.105, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.091,+0.067,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMP02A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP02A';
bba.bpm_y{n}.shunt                = 'AQF02A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV07B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.109, +0.091, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.116,+0.116,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMP02B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP02B';
bba.bpm_y{n}.shunt                = 'AQF02B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV09B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.119, +0.081, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.135,+0.119,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP03A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP03A';
bba.bpm_y{n}.shunt                = 'AQF03A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV09A';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.097, +0.103, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.083,+0.095,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMP03B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP03B';
bba.bpm_y{n}.shunt                = 'AQF03B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV09B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.106, +0.094, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.098,+0.109,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP03C
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP03C';
bba.bpm_y{n}.shunt                = 'AQF03B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV01A';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.15,+0.05,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP04A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP04A';
bba.bpm_y{n}.shunt                = 'AQF04A';
bba.bpm_y{n}.shunt_delta_amp      = 3.0;
bba.bpm_y{n}.corrector            = 'ACV03B';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.230,+0.134,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP04B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP04B';
bba.bpm_y{n}.shunt                = 'AQF04B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11A';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.127,+0.111,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP05A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP05A';
bba.bpm_y{n}.shunt                = 'AQF05A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11A';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.087,+0.073,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMP05B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP05B';
bba.bpm_y{n}.shunt                = 'AQF05B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11B';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.077,+0.091,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP06A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP06A';
bba.bpm_y{n}.shunt                = 'AQF06A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11A';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.144,+0.084,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP06B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP06B';
bba.bpm_y{n}.shunt                = 'AQF06B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV07A';
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.1,+0.1,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP07A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP07A';
bba.bpm_y{n}.shunt                = 'AQF07A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV09B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.102, +0.098, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.079,+0.081,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP07B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP07B';
bba.bpm_y{n}.shunt                = 'AQF07B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV01B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.100, +0.100, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.1,+0.1,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP08A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP08A';
bba.bpm_y{n}.shunt                = 'AQF08A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV07B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.166, +0.034, 5);
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.126,+0.086,7);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.0570,0.1511,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP08B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP08B';
bba.bpm_y{n}.shunt                = 'AQF08B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV03B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.091, +0.109, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.210,+0.166,7);
bba.bpm_y{n}.power_supply_off     = {};


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
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.044,+0.114,7);
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.252,-0.061,7);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.1,0.1,7);
bba.bpm_y{n}.power_supply_off     = {};



%% AMP10A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP10A';
bba.bpm_y{n}.shunt                = 'AQF10A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV09B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.127, +0.073, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.134,+0.111,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP10B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP10B';
bba.bpm_y{n}.shunt                = 'AQF10B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11A';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.087, +0.113, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.141,+0.088,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMU11A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMU11A';
bba.bpm_y{n}.shunt                = 'AQF11A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11A';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.100, +0.100, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.122,+0.084,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMU11B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMU11B';
bba.bpm_y{n}.shunt                = 'AQF11B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.109, +0.091, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.084,+0.146,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMP12A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP12A';
bba.bpm_y{n}.shunt                = 'AQF12A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV11B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.095, +0.105, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.108,+0.131,7);
bba.bpm_y{n}.power_supply_off     = {};
%% AMP12B
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP12B';
bba.bpm_y{n}.shunt                = 'AQF12B';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV07B';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.077, +0.123, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.103,+0.118,7);
bba.bpm_y{n}.power_supply_off     = {};


%% AMP01A
n=n+1;
bba.bpm_y{n}.bpm                  = 'AMP01A';
bba.bpm_y{n}.shunt                = 'AQF01A';
bba.bpm_y{n}.shunt_delta_amp      = 1.0;
bba.bpm_y{n}.corrector            = 'ACV07A';
%bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.078, +0.122, 5);
bba.bpm_y{n}.corrector_grid_mrad  = linspace(-0.060,+0.103,7);
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
    
    % A função retorna um flag sobre a credibilidade do ponto de offset
    %('OK', ou 'nOK'). Foi necessário para a construção do arquivo .orb:
    bpm.fla = 'OK';
    if ((bpm.coeff_determination < 0.95) || bpm.extrapolation),
        plot_bba(bpm, direction, pos_bpm, rms);
        bpm.fla = 'nOK';
    end;
    
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
title(['BBA do ' bpm_label ' (' num2str(bpm.coeff_determination) ')']);

function r = get_bpm_names

r = [ ...
    'AMP01B'; ...
    'AMP02A'; 'AMP02B'; 'AMP03A'; 'AMP03B'; 'AMP03C'; 'AMP04A'; 'AMP04B'; ...
    'AMP05A'; 'AMP05B'; 'AMP06A'; 'AMP06B'; 'AMP07A'; 'AMP07B'; ...
    'AMP08A'; 'AMP08B'; 'AMP09A'; 'AMP09B'; 'AMP10A'; 'AMP10B'; ...
    'AMU11A'; 'AMU11B'; 'AMP12A'; 'AMP12B'; 'AMP01A' ];


function registra_historico(bba)


def_bpm_names = get_bpm_names;

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

function bba_final = load_corrector_range_from_last_measdata(bba0)

bba_final = bba0;

error('continuar');

load('C:\Arq\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Optics\last_bba.mat');
for i=1:length(bba.bpm_x)
end
