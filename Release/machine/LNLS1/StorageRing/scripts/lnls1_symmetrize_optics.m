function r = lnls1_symmetrize_optics(varargin)
% function r = lnls1_symmetrize_optics(varargin)
%
% Faz simetrização da ótica do anel a partir da análise LOCO;
%
% Parâmetros de argumento:
%   'DataInFiles'              : medidas usadas pelo LOCO já estão em arquivos.
%   'NoSymmImplementation'     : não implementar na máquina real a simetrização.
%   'FamiliesShuntsSeparately' : implementa variações nas famílias e nos shunts separadamente.
%   'FamiliesOnly'             : implementa  variações apenas nas famílias
%   'BEDI'                     : faz simetrização do modo BEDI.
%   NR_STEPS (integer)         : número de steps na implementação da simetrização.
%
% Exemplo:
%
% 1) lnls1_symmetrize_optics
%    Faz medidas, faz análise LOCO e implementa uma iteração do processo de
%    simetrização na máquina real
%
% 2) lnls1_symmetrize_optics('DataInFiles')
%    Lê medidas de arquivos, faz análise LOCO e implementa uma iteração do processo de
%    simetrização na máquina real
%
% 3) lnls1_symmetrize_optics('DataInFiles', 'NoSymmImplementation')
%    Lê medidas de arquivos, faz análise LOCO , calcula dados de simetrização mas não implementa
%
% História
%
% 2011-05-16:   alterado trecho que renomeia diretório com medidas.
% 2011-04-27:   adicionada opção para simetrização do modo BEDI
% 2011-04-02:   criação do script (Ximenes)


global THERING;




% parâmetros default do script
r.DataInFiles = false;
r.DataDir = [];
r.SymmImplementation = true;
r.ImplementationType = 'FamiliesShunts';
r.ImplementationSteps = 10;
r.Mode = 'BBY6T';

% processa parâmetros de inpput
for i=length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i},{'DataInFiles', 'DataInFile'}))
            r.DataInFiles = true;
        elseif strcmpi(varargin{i},'NoSymmImplementation')
            r.SymmImplementation = false;
        elseif strcmpi(varargin{i},'FamiliesShuntsSeparately')
            r.ImplementationType = 'FamiliesShuntsSeparately';
        elseif strcmpi(varargin{i},'FamiliesOnly')
            r.ImplementationType = 'FamiliesOnly';
        elseif strcmpi(varargin{i},'BEDI')
            r.Mode = 'BEDI';
        else
            r.DataInFiles = true;
            r.DataDir = varargin{i};
        end
    elseif isinteger(varargin{i})
        r.ImplementationSteps = varargin{i};
    end
end




% MEDIDAS
if r.DataInFiles
    
    if isempty(r.DataDir)
        data_dir = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics', 'docs');
        r.DataDir = uigetdir(data_dir, 'Diretório onde estão arquivos com medidas');
        if ~ischar(r.DataDir), return; end;
    end
    
else
    
    date_str = get_date_str;
    
    DataDir = datestr(now, 'yyyy-mm-dd');
    r.DataDir = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics',['SYMM-' DataDir]);
    
    % medida de flutuações dos BPMs
    interval  = 180; % seconds
    period    = 1.0; % seconds
    file_name = fullfile(r.DataDir, ['BPMData_' date_str '.mat']);
    lnls1_monbpm(0:period:interval, 'Archive', file_name, 'NoDisplay');
    
    % medida de função dispersão
    file_name = fullfile(r.DataDir, ['Disp_' date_str '.mat']);
    lnls1_measdisp('NoDisplay', 'Archive', file_name);
    
    % medida de matriz resposta
    file_name = fullfile(r.DataDir, ['BPMRespMat_' date_str '.mat']);
    lnls1_measbpmresp('Archive', file_name);
    
end

% gera arquivo de input para o LOCO
try
    buildlocoinput(r.DataDir, 1);
catch
    fprintf('Problema ao construir o input do LOCO: arquivos com dados não encontrados no diretório especificado.\n');
    return;
end
OutputFileName = fullfile(r.DataDir, 'LOCODataFileSLM');
if exist('buildlocofitparameters', 'file')
    buildlocofitparameters(OutputFileName, 2, 0);
else
    fprintf('   buildlocofitparameters.m was not found so the FitParameters variable still needs to be created.\n');
end


% copia medidas de diretório temporário para permanente
if strfind(r.DataDir, 'SYMM-')
    DataDir1 = r.DataDir;
    DataDir2 = strrep(r.DataDir, 'SYMM-', '');
    movefile(fullfile(DataDir1,'*'), fullfile(DataDir2), 'f');
    rmdir(DataDir1);
    r.DataDir = strrep(r.DataDir, 'SYMM-','');
    OutputFileName = strrep(OutputFileName, 'SYMM-', '');
end

% testa consistencia dos dados no arquivo e carrega parametros
[BPMData, CMData, LocoMeasData, LocoModel, FitParameters, LocoFlags, RINGData] = locofilecheck(OutputFileName);


% ajusta campo dos IDs no modelo de acordo com info do usuário.
switch2sim;
ids = inputdlg({'Campo do AWG01 [T]', 'Campo do AWG09 [T]', 'Campo do AON11 [T]'}, 'Dispositivos de Inserção', [1 1 1], {'0','0.2','0'});
lnls1_set_id_field('AWG01', str2double(ids{1}));
lnls1_set_id_field('AWG09', str2double(ids{2}));
lnls1_set_id_field('AON11', str2double(ids{3}));
RINGData.Lattice = THERING;

% executa analise LOCO de calibracao do modelo baseado na medida de eta e
% matriz resposta
disp([get_date_str ': análise LOCO...']);
converged = false;
while ~converged
    drawnow;
    [LocoModel(end+1), BPMData(end+1), CMData(end+1), FitParameters(end+1), LocoFlags(end+1), RINGData] = loco(LocoMeasData(end), BPMData(end), CMData(end), FitParameters(end), LocoFlags(end), RINGData(end));
    if abs(100*(LocoModel(end).ChiSquare - LocoModel(end-1).ChiSquare)/LocoModel(end).ChiSquare) < 0.01, converged = true; end
end
r.LOCO.BPMData = BPMData(end);
r.LOCO.CMData = CMData(end);
r.LOCO.LocoMeasData = LocoMeasData(end);
r.LOCO.LocoModel = LocoModel(end);
r.LOCO.FitParameters = FitParameters(end);
r.LOCO.LocoFlags = LocoFlags(end);
r.LOCO.RINGData = RINGData(end);


% exporta resultado do LOCO para modelo AT
THERING = RINGData(end).Lattice;


% faz simetrização da ótica registrando as forças quadrupolares antes e depois
% da simetrização.

disp([get_date_str ': simetrização da ótica...']);
kQF1 = getsp('QF', 'Hardware');
kQD1 = getsp('QD', 'Hardware');
kQFC1 = getsp('QFC', 'Hardware');
converged = false;
residue = 1e100;
bb = lnls1_calc_beta_beating;
r.InitialBetaBeating = bb;
fprintf('Tunes: [%6.4f (H) %6.4f (V)], Beta beating: [%5.2f%% (H) %5.2f%% (V)]\n', bb.tunex, bb.tuney, bb.betax_beating, bb.betay_beating);
while ~converged
    SymData = lnls1_symmetrize_simulation_optics('QuadElements', 'AllSymmetries', r.Mode);
    bb = lnls1_calc_beta_beating;
    fprintf('Tunes: [%6.4f (H) %6.4f (V)], Beta beating: [%5.2f%% (H) %5.2f%% (V)]\n', bb.tunex, bb.tuney, bb.betax_beating, bb.betay_beating);
    if (100*(abs(sum(SymData.Residue.^2) - residue)/residue) < 0.1) || ((bb.betax_beating < 0.1) && (bb.betay_beating < 0.1)), converged = true; end
    residue = sum(SymData.Residue.^2);
    drawnow;
end
r.SymData = SymData;
r.FinalBetaBeating = lnls1_calc_beta_beating;
kQF2 = getsp('QF', 'Hardware');
kQD2 = getsp('QD', 'Hardware');
kQFC2 = getsp('QFC', 'Hardware');

% separa ajustes de famílias e shunts
[r.QF_delta r.QD_delta r.QFC_delta r.SHUNTS_delta] = get_family_shunt_k_variations(kQF2-kQF1, kQD2-kQD1, kQFC2-kQFC1);


% se não é para implementar simetrização retorna.
if ~r.SymmImplementation, return; end

%% ---- A PARTIR DESTE PONTO AJUSTES SÃO ENVIADOS NO MODO ONLINE ----

% implementa ajuste de simetrização na máquina real em steps suaves
switch2online;
nr_steps = r.ImplementationSteps;
disp([get_date_str ': implementação no anel...']);
r.InitMachineConfig = getmachineconfig;

if strcmpi(r.ImplementationType, 'FamiliesShuntsSeparately')
    % FamiliesShuntsSeparately
    for j=1:nr_steps
        fprintf('stepping quad families #%i\n', j);
        stepsp('QF', r.QF_delta/nr_steps, 'Hardware');
        stepsp('QD', r.QD_delta/nr_steps, 'Hardware');
        stepsp('QFC', r.QFC_delta/nr_steps, 'Hardware');
        pause(1);
        drawnow;
    end
    lnls1_quad_shunts_on;
    for j=1:nr_steps
        fprintf('stepping quad shunts #%i\n', j);
        stepsp('QUADSHUNT', r.SHUNTS_delta/nr_steps, 'Hardware');
        pause(1);
        drawnow;
    end
elseif strcmpi(r.ImplementationType, 'FamiliesShunts')
    % FamiliesShunts
    lnls1_quad_shunts_on;
    for j=1:nr_steps
        fprintf('stepping #%i\n', j);
        stepsp('QF', (kQF2 - kQF1)/nr_steps, 'Hardware');
        stepsp('QD', (kQD2 - kQD1)/nr_steps, 'Hardware');
        stepsp('QFC', (kQFC2 - kQFC1)/nr_steps, 'Hardware');
        pause(1);
        drawnow;
    end
else
    for j=1:nr_steps
        fprintf('stepping quad families #%i\n', j);
        stepsp('QF', r.QF_delta/nr_steps, 'Hardware');
        stepsp('QD', r.QD_delta/nr_steps, 'Hardware');
        stepsp('QFC', r.QFC_delta/nr_steps, 'Hardware');
        pause(1);
        drawnow;
    end
end

r.FinalMachineConfig = getmachineconfig;
disp([get_date_str ': fim de simetrização...']);

function [QF_delta QD_delta QFC_delta SHUNTS_delta] = get_family_shunt_k_variations(QF_dK, QD_dK, QFC_dK)

QN = 'QF';
dK = QF_dK;
names  = family2channel(QN,'Setpoint');
names  = strrep(mat2cell(names, ones(size(names,1),1),size(names,2)), '_SP','');
unames = unique(names);
for i=1:size(unames)
    idx = find(strcmpi(names, unames{i}));
    QF_delta(idx,1) =  mean(dK(idx));
    shunt_dQF(idx,1) = dK(idx) - QF_delta(idx,1);
end
QN = 'QD';
dK = QD_dK;
names  = family2channel(QN,'Setpoint');
names  = strrep(mat2cell(names, ones(size(names,1),1),size(names,2)), '_SP','');
unames = unique(names);
for i=1:size(unames)
    idx = find(strcmpi(names, unames{i}));
    QD_delta(idx,1) =  mean(dK(idx));
    shunt_dQD(idx,1) = dK(idx) - QD_delta(idx,1);
end
QN = 'QFC';
dK = QFC_dK;
names  = family2channel(QN,'Setpoint');
names  = strrep(mat2cell(names, ones(size(names,1),1),size(names,2)), '_SP','');
unames = unique(names);
for i=1:size(unames)
    idx = find(strcmpi(names, unames{i}));
    QFC_delta(idx,1) =  mean(dK(idx));
    shunt_dQFC(idx,1) = dK(idx) - QFC_delta(idx,1);
end


ind = [getfamilydata('QF', 'AT', 'ATIndex'); getfamilydata('QD', 'AT', 'ATIndex'); getfamilydata('QFC', 'AT', 'ATIndex')];
[~, idx] = sort(ind(:,1));
SHUNTS_delta = [shunt_dQF; shunt_dQD; shunt_dQFC];
SHUNTS_delta = SHUNTS_delta(idx,1);

function r = get_date_str
r = datestr(now, 'yyyy-mm-dd_HH-MM-SS');


