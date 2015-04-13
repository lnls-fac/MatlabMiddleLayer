function r = lnls1_measeputable_counterphase(varargin)
%Mede tabela feedforward de correção de órbita do ondulador.
%
%História: 
%
%2011-04-29: implementação de medida em contra-fase e medida de matriz de correção de órbita só no início do experimento
%2010-09-27: adicionada rotina que processa argumentos da função (Ximenes)
%2010-09-27: adicionada rotina que grava dados no formato que o programa do ondulador lê. (Ximenes)
%2010-09-13: comentários iniciais no código. (Ximenes)


% Valores default para parâmetros da medida
r.tolerance = 500e-3;     % tolerancia em mm (movimentações do EPU)
r.reference_gap = 300;     % gap de referencia do EPU para tabelar corretoras
r.reference_fase = 0;
r.orbit_correction_pause = 1*30;
r.pause_after_corrector_setpoint = 1*1;
r.pause_after_epu_setpoint = 2;
r.delta_respm = 1.0; % amp
%r.gaps  = unique([22:2.5:97 100:50:300]);
r.gaps  = unique([linspace(23.5, 100, 32) 150:50:300]);
r.fases = unique([-25:5:25]);

% processa argumentos
for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'tolerance')
        r.tolerance = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'reference_gap')
        r.reference_gap = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'reference_fase')
        r.reference_fase = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'orbit_correction_pause')
        r.orbit_correction_pause = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'pause_after_corrector_setpoint')
        r.pause_after_corrector_setpoint = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'pause_after_epu_setpoint')
        r.pause_after_epu_setpoint = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'delta_respm')
        r.delta_respm = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'gaps')
        r.gaps = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'fases')
        r.fases = varargin{i+1};
    elseif ischar(varargin{i}) && strcmpi(varargin{i},'CounterPhase')
        r.counter_phase = -1;
    elseif ischar(varargin{i})
    elseif isstruct(varargin{i})
        fields = fieldnames(varargin{i});
        for j=1:length(fields)
            r.(fields{j}) = varargin{i}.(fields{j});
        end
    end
end


[FileName,PathName,~] = uiputfile('*.mat','Salvar medida',['tabela_epu_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat']);
if isempty(FileName)
    return;
end

fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': início das medidas do ondulador\n']);

% liga fontes corretoras do ondulador
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': ligando fontes corretoras do ondulador...\n']);
setpv('AOH11A_ON',1);
setpv('AOH11B_ON',1);
setpv('AOV11A_ON',1);
setpv('AOV11B_ON',1);


% envia ondulador para configuração inicial
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': enviando ondulador para configuração inicial...\n']);
setpv('AON11VGAP_SP', 500);
setpv('AON11VFASE_SP', 500);
setpv('AOH11A_SP',0);
setpv('AOH11B_SP',0);
setpv('AOV11A_SP',0);
setpv('AOV11B_SP',0);
IDS_REF(1).channel_name = 'AON11CFASE';
IDS_REF(1).value        = r.reference_fase;
IDS_REF(1).tolerance    = 0.5;
IDS_REF(2).channel_name = 'AON11GAP';
IDS_REF(2).value        = r.reference_gap;
IDS_REF(2).tolerance    = 0.5;
IDS = IDS_REF;
lnls1_set_id_configurations(IDS_REF);


% corrige órbita
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrigindo órbita por %i segundos...\n'], r.orbit_correction_pause);
lnls1_fast_orbcorr_on;
pause(r.orbit_correction_pause);
lnls1_slow_orbcorr_off;
lnls1_fast_orbcorr_off;



% loops
setbpmaverages(0.6,5);
%setbpmaverages(0,1);

% mede matriz de correção de órbita
% vai para config original
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': medida de matriz de correção de órbita...\n']);
setpv('AOH11A_SP',0);
setpv('AOH11B_SP',0);
setpv('AOV11A_SP',0);
setpv('AOV11B_SP',0);
%epu_go(r.reference_gap, r.reference_fase, r.tolerance);
lnls1_set_id_configurations(IDS_REF);
pause(r.pause_after_epu_setpoint);
r.correction_matrix = meas_correction_matrix(r);


r.epu_table = [];
r.distorcoes = {};
r.distorcoes_corrigidas = {};
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': loop principal de medida...\n'], r.orbit_correction_pause); 
for j=1:length(r.gaps)
    
    for i=1:length(r.fases)
        
        fprintf('\n[GAP: %f  FASE: %f]\n', r.gaps(j), r.fases(i));
        
        % vai para config original
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': configuração inicial do ondulador...\n']);
        setpv('AOH11A_SP',0);
        setpv('AOH11B_SP',0);
        setpv('AOV11A_SP',0);
        setpv('AOV11B_SP',0);
        %epu_go(r.reference_gap, r.reference_fase, r.tolerance);
        lnls1_set_id_configurations(IDS_REF);
        pause(r.pause_after_epu_setpoint);
        
        % registra orbita original
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': registra órbita não perturbada...\n']);
        [orbit0_x orbit0_y] = getbpm; 
        
        % vai para config a ser medida
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': configuração do ondulador a ser medida...\n']);
        IDS(1).value = r.fases(i);
        IDS(2).value = r.gaps(j);
                 
        lnls1_set_id_configurations(IDS);
        pause(r.pause_after_epu_setpoint);
        
        % registra orbita distorcida
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': registra órbita distorcida...\n']);
        [orbit1_x orbit1_y] = getbpm; 
        
        % corrige distorções
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': corrigindo distorção...\n']);
        rp = local_epu_correction([orbit0_x orbit0_y], r);
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': valores das fontes [A]: %+5.3f %+5.3f %+5.3f %+5.3f \n'], rp(1), rp(2), rp(3), rp(4));
        
        % registra orbita corrigida
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': registra órbita corrigida...\n']);
        [orbit2_x orbit2_y] = getbpm; 
        
        % salva dados parciais
        fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': salvando dados parciais...\n']);
        %fases = -25:5:25; % TEMPORARIO!!! ESTA LINHA DEVE SER: fases = r.fases(i)
        fases = r.fases(i);
        for k=1:length(fases)
            r.distorcoes{length(r.distorcoes)+1} = [orbit1_x - orbit0_x orbit1_y - orbit0_y];
            r.distorcoes_corrigidas{length(r.distorcoes_corrigidas)+1} = [orbit2_x - orbit0_x orbit2_y - orbit0_y];
            r.epu_table = [r.epu_table; [r.gaps(j) fases(k) max(abs(orbit1_x-orbit0_x)) max(abs(orbit1_y-orbit0_y)) max(abs(orbit2_x-orbit0_x)) max(abs(orbit2_y-orbit0_y)) rp(1) rp(2) rp(3) rp(4)]];
        end
        save(fullfile(PathName,FileName),'r');
        save_opr1(PathName, r.epu_table);
    end
end
lnls1_fast_orbcorr_on;
setpv('AOH11A_SP',0);
setpv('AOH11B_SP',0);
setpv('AOV11A_SP',0);
setpv('AOV11B_SP',0);
lnls1_set_id_configurations(IDS_REF);
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': fim de medidas.\n']);


function save_opr1(PathName, epu_table)

nrpts_fase = length(unique(epu_table(:,2)));
if (mod(length(epu_table(:,2)),nrpts_fase) ~= 0)
    fprintf('Número de pontos no grid de fase deve ser o mesmo em todos os gaps.\n');
    return;
end
    
GapLimite = 100;

file_name1 = fullfile(PathName, 'TabelaCorrecaoAcopladoContraFase_Gap1.dat');
file_name2 = fullfile(PathName, 'TabelaCorrecaoAcopladoContraFase_Gap2.dat');
file_name3 = fullfile(PathName, 'CabDadosOndulador.dat');

% Gera as tabelas em arquivo correspondentes aos dois grids de gap
fd1 = fopen(file_name1, 'w');
fd2 = fopen(file_name2, 'w');
nrpts1 = 0;
nrpts2 = 0;
for i=1:size(epu_table,1)
    if (epu_table(i,1) >= GapLimite)
        fprintf(fd1, '%g\t%g\t%g\t%g\t%g\t%g\r\n', epu_table(i,1), epu_table(i,2), epu_table(i,7), epu_table(i,8), epu_table(i,9), epu_table(i,10));   
        nrpts1 = nrpts1 + 1;
    end
    if (epu_table(i,1) <= GapLimite)
        fprintf(fd2, '%g\t%g\t%g\t%g\t%g\t%g\r\n', epu_table(i,1), epu_table(i,2), epu_table(i,7), epu_table(i,8), epu_table(i,9), epu_table(i,10));   
        nrpts2 = nrpts2 + 1;
    end
end
fclose(fd1);
fclose(fd2);

% Gera arquivo cabecalho.
nr_gaps1 = nrpts1 / nrpts_fase;
nr_gaps2 = nrpts2 / nrpts_fase;
fd3 = fopen(file_name3, 'w');
fprintf(fd3, '%g\t\tGapLimite em mm\r\n', GapLimite);
fprintf(fd3, '%g\t\tNúmero de pontos de gap na região de gap 1\r\n', nr_gaps1);
fprintf(fd3, '%g\t\tNúmero de pontos de gap na região de gap 2\r\n', nr_gaps2);
fprintf(fd3, '%g\t\tNúmero de pontos de fase (idêntico em ambas as regiões de gap).\r\n', nrpts_fase);
fclose(fd3);






function m = meas_correction_matrix(r)

fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': medindo matriz resposta das corretoras do ondulador...\n']);
corrector = 'AOH11A';
index = 1;
current0 = getpv([corrector '_AM']);
[orbit0_x orbit0_y] = getbpm;
setpv([corrector '_SP'], current0 + r.delta_respm);
pause(r.pause_after_corrector_setpoint);
[orbit1_x orbit1_y] = getbpm;
current1 = getpv([corrector '_AM']);
setpv([corrector '_SP'], current0);
pause(r.pause_after_corrector_setpoint);
m(:,index) = [orbit1_x - orbit0_x; orbit1_y - orbit0_y] / (current1 - current0);

corrector = 'AOH11B';
index = 2;
current0 = getpv([corrector '_AM']);
[orbit0_x orbit0_y] = getbpm;
setpv([corrector '_SP'], current0 + r.delta_respm);
pause(r.pause_after_corrector_setpoint);
[orbit1_x orbit1_y] = getbpm;
current1 = getpv([corrector '_AM']);
setpv([corrector '_SP'], current0);
pause(r.pause_after_corrector_setpoint);
m(:,index) = [orbit1_x - orbit0_x; orbit1_y - orbit0_y] / (current1 - current0);

corrector = 'AOV11A';
index = 3;
current0 = getpv([corrector '_AM']);
[orbit0_x orbit0_y] = getbpm;
setpv([corrector '_SP'], current0 + r.delta_respm);
pause(r.pause_after_corrector_setpoint);
[orbit1_x orbit1_y] = getbpm;
current1 = getpv([corrector '_AM']);
setpv([corrector '_SP'], current0);
pause(r.pause_after_corrector_setpoint);
m(:,index) = [orbit1_x - orbit0_x; orbit1_y - orbit0_y] / (current1 - current0);

corrector = 'AOV11B';
index = 4;
current0 = getpv([corrector '_AM']);
[orbit0_x orbit0_y] = getbpm;
setpv([corrector '_SP'], current0 + r.delta_respm);
pause(r.pause_after_corrector_setpoint);
[orbit1_x orbit1_y] = getbpm;
current1 = getpv([corrector '_AM']);
setpv([corrector '_SP'], current0);
pause(r.pause_after_corrector_setpoint);
m(:,index) = [orbit1_x - orbit0_x; orbit1_y - orbit0_y] / (current1 - current0);

function rp = local_epu_correction(orbit0, r)

%m = meas_correction_matrix(r);
m = r.correction_matrix;
fprintf([datestr(now, 'yyyy-mm-dd_HH-MM-SS') ': max. distorção [um]: ']);
for i=1:5 %% será que é necessário aumentar # iterações para contra-fase?
    [orbit1_x orbit1_y] = getbpm;
    dorbit = [orbit1_x - orbit0(:,1); orbit1_y - orbit0(:,2)];
    fprintf('%f ', 1000*max(abs(dorbit)));
    rp = pinv(m) * (-dorbit);
    %rp = [1*i 2*i 3*i 4*i];
    steppv('AOH11A_SP', rp(1));
    steppv('AOH11B_SP', rp(2));
    steppv('AOV11A_SP', rp(3));
    steppv('AOV11B_SP', rp(4));
    pause(r.pause_after_corrector_setpoint);
end
fprintf('\n');
rp(1) = getpv('AOH11A_SP');
rp(2) = getpv('AOH11B_SP');
rp(3) = getpv('AOV11A_SP');
rp(4) = getpv('AOV11B_SP');
