function r = lnls1_injbump_optimization(varargin)
%Optimiza bump AC de injeção (drive)
%
%Para utilizar a interface gráfica, digite inj_bump_optimization_GUI no 
%MATLAB com a pasta do script aberta.
%
% O script executa uma rotina que analisa os parâmetros dos kickers e os varia 
%de forma a fechar o bump de injeção.
%
% Os dados de saída contém todos os pontos gerados, valores de rms, maximos 
%e mínimos para cada medida, as médias e erros para um ponto e as curvas
%obtidas com o Libera.
%
% O método de otimização pode ser escolhido pelo usuário.
% Métodos já implementados:
%- Simulated Annealing (simplificado - T = 0)
%- Single Parameter Scan
%
% Serão implementados possivelmente os métodos de Simulated Annealing
%completo e o método por SVD.
%
% Os dados da resposta do feixe ao kick são adquiridos pelo Libera, no modo 
%Turn-by-Turn.
% O valor RMS da curva gerada pelo Libera é o parâmetro que define o
%fechamento do bump. Isso foi baseado no fato de que quanto mais longe da
%situação de bump fechado, maior será a oscilação do feixe.
%
% O programa tem uma série de valores default. Se nenhum dado desejado pelo
%usuário for colocado em input_parms.PARAMETRO_A_SER_MODIFICADO o programa
%usa o default.
%
% O script pode ser facilmente modificado para o caso de diferente número
%de kickers ou utilização de outro tipo de função de aproximação.
%
%---=== Lista de parâmetros de entrada ===---
%
%*** Parâmetros de Otimização
%- input_parms.nr_pts     -> Número de pontos. Cada ponto é um conjunto de
%                            parâmetros de amplitude e atraso dos kickers.
%                            O método Single Parameter Scan gera o número
%                            de pontos necessários automaticamente. No S.A.
%                            esse número define o fim da procura. 
%- input_parms.nr_pts_avg -> Número de vezes que a medida é feita para
%                            aquele ponto. O RMS do ponto é a média dessas
%                            medidas.
%- input_parms.mode       -> 'online' ou 'simulation'.
%- input_parms.method     -> Método de otimização. Atualmente
%                            'sim_annealing' ou 'parms_scan'.
%- input_parms.plot       -> Plota um gráfico com os valores de RMS para 
%                            cada ponto. Há distinção entre os pontos
%                            aceitos como mínimo e os descartados.
%- input_parms.data_range_libera ->
%                            Janela, i.e, intervalo de importância dos
%                            dados do libera que serão avaliados no cálculo
%                            do RMS. A análise da curva toda atenua o valor
%                            do RMS.
%-input_parms.max_kicker_voltage ->
%                            Tensão máxima admitida para os kickers
%                            (default = 25 kV)
%-input_parms.general_pause_time ->
%                            Pausa entre o envio de comandos para o                              
%                            lnls1_link.
%
%*** Parâmetros de Simulação 
%- input_parms.sim_point_parms ->
%                            Parâmetros do ponto inicial para a simulação.
%                            [02V 03V 04V 02AG 03AG 04AG 02AF 03AF 04AF].
%                            A simulação deve procurar o ponto de mínimo
%                            RMS(definido em
%                            injbump_lnls1_libera_read_data)
%
%*** Parâmetros do Simulated Annealing
%- input_parms.parms_delta-> Janela de valores na qual variam os parâmetros
%                            dos kickers. É um vetor da forma
%                            [KVolts KVolts KVolts nanosec nanosec nanosec]
%                            sendo ordenados na mesma sequencia que os
%                            kickers.
%
%*** Parâmetros do método Single Parâmeter scan.
%- input_parms.scan_component -> 
%                            É o parâmetro no qual será executada a
%                            varredura. Ex: 'AKC02_AF_SP' ou 'AKC03_SP'.
%                            Ainda limitado â amplitude e atraso fino.
%input_parms.scan_interval-> Intervalo no qual será executada a varredura.
%                            Deve ser um vetor do tipo [ini_val end_value].
%input_parms.scan_step    -> Passo da varredura.
%
%*** Parametros do Libera
%-input_parms.nr_pts_libera  
%-input_parms.ip
%-input_parms.file_name
%-input_parms.local_dir
%(...) ver as funções libera "acquire" e "read" data.
%
%
%História: 
%
%2010-09-13: comentários iniciais no código.
%2010-02-09: Editado por Rodrigo B. Braga LNLS-FAC-BV2010, rodrigobraga.fuzz@gmail.com


% se primeiro argumento é string, chama subfunção correspondente
if (~isempty(varargin)) && (ischar(varargin{1}))
    fcn_ptr = eval(['@' varargin{1}]);
    varargin(1) = [];
    r = fcn_ptr(varargin);
    return;
end;
    

%% Pré-inicialização

% Default
input_parms.nr_pts               = 10;
input_parms.nr_pts_avg           = 1;
input_parms.mode                 = 'online';
input_parms.method               = 'sim_annealing';
input_parms.plot                 = true;                      
input_parms.parms_delta          = [0 0.5 0.5 0 0 0];           
input_parms.scan_component       = 'AKC02_voltage';
input_parms.scan_interval        = [15 21];
input_parms.scan_step            = 0.2;                       
input_parms.nr_pts_libera        = 512;
input_parms.libera.nr_pts_libera = input_parms.nr_pts_libera;
input_parms.data_range_libera    = [107  295];                
input_parms.ip                   = '10.0.4.154';
input_parms.file_name            = 'libera_data';
input_parms.local_dir            = 'D:\libera\';
input_parms.idx                  = 1;
input_parms.sim_point_parms      = [18 18 18 0 0 0 0 0 0]';
input_parms.max_kicker_voltage   = 25;
input_parms.general_pause_time   = 0.2;



% modify/add default parameters with input data
if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i=1:length(fnames)
        input_parms.(fnames{i}) = varargin{1}.(fnames{i});
    end
end

% Select MODE
if strcmpi(input_parms.mode, 'sim')
    input_parms.getpv               = @injbump_getpv;
    input_parms.setpv               = @injbump_setpv;
    input_parms.libera_acquire_data = @injbump_lnls1_libera_acquire_data;
    input_parms.libera_read_data    = @injbump_lnls1_libera_read_data;
    input_parms.general_pause_time  = 0.0000000001; % Necessario para o funcionamento do botao ABORT da GUI.
    global point_parms;
    point_parms = input_parms.sim_point_parms;
else
    input_parms.mode = 'online';
    input_parms.getpv               = @getpv;
    input_parms.setpv               = @setpv;
    input_parms.libera_acquire_data = @lnls1_libera_acquire_data;
    input_parms.libera_read_data    = @lnls1_libera_read_data;
end

% Select METHOD

if strcmpi(input_parms.method, 'sim_annealing')
    input_parms.optimization_function = @injbump_sim_annealing;
end

if strcmpi(input_parms.method, 'svd_response_matrix')
    error('algoritmo nao implementado ainda, tche!');
end

if strcmpi(input_parms.method, 'parms_scan')
    input_parms.optimization_function = @injbump_parms_scan;
    try
        input_parms.scan_step  = (input_parms.scan_interval(2) - input_parms.scan_interval(1)) / (input_parms.nr_pts - 1);
    catch
        input_parms.scan_step  = (input_parms.scan_interval(2) - input_parms.scan_interval(1));
    end;
    scan_step = input_parms.scan_step;
    input_parms.setpv(input_parms.scan_component , input_parms.scan_interval(1));
    [G F] = lnls1_booster_delay2GF(input_parms.scan_interval(1));
    switch input_parms.scan_component
        case 'AKC02_voltage'
            input_parms.parms_delta = [scan_step 0 0 0 0 0];
            input_parms.setpv('AKC02_SP' , input_parms.scan_interval(1))
        case 'AKC03_voltage'
            input_parms.parms_delta = [0 scan_step 0 0 0 0];
            input_parms.setpv('AKC03_SP' , input_parms.scan_interval(1))
        case 'AKC04_voltage'
            input_parms.parms_delta = [0 0 scan_step 0 0 0];
            input_parms.setpv('AKC04_SP' , input_parms.scan_interval(1))
        case 'AKC02_delay'
            input_parms.parms_delta = [0 0 0 scan_step 0 0];
            input_parms.setpv('AKC02_AG_SP', G);
            input_parms.setpv('AKC02_AF_SP', F);
        case 'AKC03_delay'
            input_parms.parms_delta = [0 0 0 0 scan_step 0];
            input_parms.setpv('AKC03_AG_SP', G);
            input_parms.setpv('AKC03_AF_SP', F);
        case 'AKC04_delay'
            input_parms.parms_delta = [0 0 0 0 0 scan_step];
            input_parms.setpv('AKC04_AG_SP', G);
            input_parms.setpv('AKC04_AF_SP', F);
    end
end

injbump_check_abort(input_parms);


%% inicialização

if strcmpi(input_parms.mode, 'online')
    switch2online;
else
    switch2sim;
end;

%% Adquire os dados iniciais dos kickers

%Tensão
%point(1).parms(1:3) = input_parms.getpv('KICKER');
point(1).parms(1) = input_parms.getpv('AKC02_SP');
point(1).parms(2) = input_parms.getpv('AKC03_SP');
point(1).parms(3) = input_parms.getpv('AKC04_SP');

%Atrasos
point(1).parms(4) = lnls1_booster_GF2delay(input_parms.getpv('AKC02_AG_SP'),input_parms.getpv('AKC02_AF_SP'));
point(1).parms(5) = lnls1_booster_GF2delay(input_parms.getpv('AKC03_AG_SP'),input_parms.getpv('AKC03_AF_SP'));
point(1).parms(6) = lnls1_booster_GF2delay(input_parms.getpv('AKC04_AG_SP'),input_parms.getpv('AKC04_AF_SP'));

injbump_check_abort(input_parms);

%% Faz aquisicao inicial

current_data      = injbump_get_measurement(point(1), input_parms);
point(1).acq_data = current_data;
point(1).info     = injbump_process_data(current_data,input_parms.data_range_libera) ;
point(1).delta    = [0 0 0 0 0 0];

point_min.parms   = point(1).parms;
point_min.mdn     = point(1).info.x.media.mdn;
point_min.idx     = 1;

% Inicia a plotagem dos pontos
if input_parms.plot == 1, input_parms = injbump_plot(input_parms, 1,point(1).info.x.media.mdn, 0, input_parms.nr_pts); end 

injbump_check_abort(input_parms);

%% Otimizacao do bump por simulated annealing

for n = 2:input_parms.nr_pts
    
    %Calcula um novo ponto
    point(n)          = input_parms.optimization_function(point(n-1), point_min, input_parms.parms_delta);      % Calcula o novo ponto pela função de otimização escolhida.
    
    %Testa se a tensão dos Kickers não ultrapassou o valor máximo
    if (max(point(n).parms(1:3)) > input_parms.max_kicker_voltage)
        fprintf('ponto descartado: tensão máxima excedida');
        continue;
    end   
    
    current_data      = injbump_get_measurement(point(n),input_parms);                                          % Gera o bump e adquire dados para aquele ponto.
    point(n).acq_data = current_data;                                                                           % Salva a curva do Libera.
    point(n).info     = injbump_process_data(current_data, input_parms.data_range_libera) ;                     % Armazena os dados dos valores de rms e erros.
        
    if point(n).info.x.media.mdn < point_min.mdn              % Testa se o ponto é um novo minimo.
        point_min.parms = point(n).parms;
        point_min.mdn   = point(n).info.x.media.mdn;
        point_min.idx   = n;
        injbump_print_new_min(point_min);                     % Escreve os dados do mínimo no prompt do MATLAB

        if input_parms.plot == 1, input_parms = injbump_plot(input_parms, n,point(n).info.x.media.mdn, 1); end  % Plota o ponto como minimo                              
    else
        if input_parms.plot == 1, input_parms = injbump_plot(input_parms, n,point(n).info.x.media.mdn, 2); end  % Plota o ponto como descartado
        pause(0.0000001);                                                            % Necessário para a plotagem correta do gráfico.
    end
    
    injbump_check_abort(input_parms);
          
end

%% Finalização do Gráfico

%hold off;


%% Saída de dados
    
r.setup     = input_parms;
r.point     = point;
r.point_min = point_min;

%% Seta nos kickers os parâmetros para o rms minimo encontrado

[delay.AG delay.AF] = lnls1_booster_delay2GF(point_min.parms(4:6));

% Tensão
input_parms.setpv('AKC02_SP',point_min.parms(1));
input_parms.setpv('AKC03_SP',point_min.parms(2));
input_parms.setpv('AKC04_SP',point_min.parms(3));

% Temporização - Ajuste Grosso
input_parms.setpv('AKC02_AG_SP',delay.AG(1));
input_parms.setpv('AKC03_AG_SP',delay.AG(2));
input_parms.setpv('AKC04_AG_SP',delay.AG(3));

% Temporização - Ajuste Fino
input_parms.setpv('AKC02_AF_SP',delay.AF(1));
input_parms.setpv('AKC03_AF_SP',delay.AF(2));
input_parms.setpv('AKC04_AF_SP',delay.AF(3));

function injbump_check_abort(input_parms)


if evalin('base', 'exist(''injbump_abort_flag'')')
   evalin('base', 'clear injbump_abort_flag');
   error('medida injbump abortada!');
end
function r = injbump_get_data(varargin)
%function r = injbump_get_data
%function r = injbump_get_data(input_parms)
%
% Injection Bump Get Data
% Adquire dados de Injeção
%
% Caso queira modificar os settings do libera, deve-se entrar com os dados.
% Ver 'lnls1_libera_aquire_data' e 'lnls1_libera_read_data'.
%
% Recebe como entrada os parâmetros do Libera. A saída é o conjunto de pontos
%da curva gerada pelo Libera.
%
% Caso esteja no modo de simulação o script usa as funções alternativas para gerar
%uma curva senoidal amortecida.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Verifica os settings do libera

input_parms = struct;

% modify/add default parameters with input data
if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i=1:length(fnames)
        input_parms.(fnames{i}) = varargin{1}.(fnames{i});
    end
end

%% Incrementa em 1 o numero do arquivo gerado pelo libera

input_parms.idx = input_parms.idx + 1;

%% Prepara Libera

input_parms.libera_acquisition_mode = '-0 -t';
input_parms = input_parms.libera_acquire_data(input_parms);
injbump_check_abort(input_parms); 

%% Liga o Relógio Geral

input_parms.setpv('RELOGIOG_ON', 1);
pause(input_parms.general_pause_time);

%% Habilita Ejeção

input_parms.setpv('RELOGIOG_HE', 1);
pause(input_parms.general_pause_time);

injbump_check_abort(input_parms);

% No próximo 0 do relógio, o comando que pulsa os kickers é dado.

%% Le arquivo do Libera

r = input_parms.libera_read_data(input_parms);
r = r.libera_data;

% O programa deve continuar somente após a certeza de que os dados do
%Libera foram adquiridos.

%% Desabilita Ejeção

input_parms.setpv('RELOGIOG_HE', 0);
pause(input_parms.general_pause_time);

%% Desabilita Relógio

input_parms.setpv('RELOGIOG_ON', 0);
pause(input_parms.general_pause_time);

injbump_check_abort(input_parms);
function r = injbump_get_measurement(point, varargin)
%injbump_get_measurement(point)
%injbump_get_measurement(point, input_parms)
%
% Injection Bump Get Measurement
%
% Recebe como dados o ponto e envia à saída os resultados do Libera para
%cada medida naquele ponto.
%
% Caso queira modificar os settings do libera, deve-se entrar com os dados.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Verifica os settings do libera

input_parms = struct;

% modify/add default parameters with input data
if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i=1:length(fnames)
        input_parms.(fnames{i}) = varargin{1}.(fnames{i});
    end
end



%% Separa os atrasos em partes grossa e fina
[delay.AG delay.AF] = lnls1_booster_delay2GF(point.parms(4:6));


%% Desliga relogio

input_parms.setpv('RELOGIOG_ON', 0);
input_parms.setpv('RELOGIOG_HE', 0);

%% Envia os dados do ponto para os kickers

% Tensão
input_parms.setpv('AKC02_SP',point.parms(1));
input_parms.setpv('AKC03_SP',point.parms(2));
input_parms.setpv('AKC04_SP',point.parms(3));

% Temporização - Ajuste Grosso
input_parms.setpv('AKC02_AG_SP',delay.AG(1));
input_parms.setpv('AKC03_AG_SP',delay.AG(2));
input_parms.setpv('AKC04_AG_SP',delay.AG(3));

% Temporização - Ajuste Fino
input_parms.setpv('AKC02_AF_SP',delay.AF(1));
input_parms.setpv('AKC03_AF_SP',delay.AF(2));
input_parms.setpv('AKC04_AF_SP',delay.AF(3));


%% Adquire os dados com o libera

for k = 1:input_parms.nr_pts_avg
    data{k} = injbump_get_data(input_parms);
end

r = data;
function r = injbump_getpv(pv_name)
%r = injbump_getpv(pv_name)
%
% Função de simulação para a função do MML "getpv".
%
% A entrada é o nome do parâmetro desejado.
%
% A saída é o parâmetro simulado na variável point_parms
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Retorna os parâmetros dos kickers (simulação)

global point_parms;

% Tensao
if strcmpi(pv_name, 'AKC02_SP')
    r = point_parms(1);
    return;
end

if strcmpi(pv_name, 'AKC03_SP')
    r = point_parms(2);
    return;
end

if strcmpi(pv_name, 'AKC04_SP')
    r = point_parms(3);
    return;
end

if strcmpi(pv_name, 'KICKER')
    r = point_parms(1:3);
    return;
end

% Atraso Ajuste Grosso
if strcmpi(pv_name, 'AKC02_AG_SP')
    r = point_parms(4);
    return;
end

if strcmpi(pv_name, 'AKC03_AG_SP')
    r = point_parms(5);
    return;
end

if strcmpi(pv_name, 'AKC04_AG_SP')
    r = point_parms(6);
    return;
end

% Atraso Ajuste Fino
if strcmpi(pv_name, 'AKC02_AF_SP')
    r = point_parms(7);
    return;
end

if strcmpi(pv_name, 'AKC03_AF_SP')
    r = point_parms(8);
    return;
end

if strcmpi(pv_name, 'AKC04_AF_SP')
    r = point_parms(9);
    return;
end
function r = injbump_lnls1_libera_acquire_data(input_parms)
%injbump_lnls1_libera_acquire_data(input_parms)
%
% Função usada pela simulação para enviar os dados pelo Libera.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Não faz nada.

r = input_parms;
function r = injbump_lnls1_libera_read_data(input_parms)
%r = injbump_lnls1_libera_read_data(input_parms)
%
% Função que simula a leitura dos dados Libera.
% Gera uma curva que tenta simular a oscilação gerada pelo bump e captada pelo Libera.
% A Função é feita de forma a oscilação tender à amplitude zero quando os valores 
%se aproximam dos corretos
%
% A onda é aproximada por uma senoide amortecida.
%
% Os valores considerados corretos podem ser modificados na Função de
%Simulação
%
% Atualmente: Tensões - AKC02 = 18 kV; AKC04 = 19 kV; AKC04 = 20 kV
%             Atrasos : 0
%

%% Função de Simulação

global point_parms;

Amplitude = (18 - point_parms(1))^2 + (19 - point_parms(2))^2 + (20 - point_parms(3))^2 ...
    + 0.1*(0 - point_parms(4) - point_parms(7))^2 ...
    + 0.1*(0 - point_parms(5) - point_parms(8))^2 ...
    + 0.1*(0 - point_parms(6) - point_parms(9))^2 ;

Amplitude = 1e6 * sqrt(Amplitude / 3) / 10;

x = 1:input_parms.nr_pts_libera;

curve = Amplitude * sin(0.5 * x) .* exp(-x/100);


injbump_check_abort(input_parms);


%% Envia a curva para a saída.

r = input_parms;
r.libera_data(:,5) = curve;
r.libera_data(:,6) = curve;
function r = injbump_parms_scan(point, point_min, window, varargin)
%r = injbump_parms_scan(point, point_min, window, varargin)
%
% Injection Bump Single Parameter Scan
%
% Faz a varredura de um único parâmetro por vez. 
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Gera novo ponto.

r = point;

delta = window ;

newpoint_parms = point.parms + delta;

r.parms = newpoint_parms;
r.delta = delta;
function output_data = injbump_plot(input_data, n,valor,flag, varargin)
% injbump_plot(n,valor,flag)
% injbump_plot(n,valor,flag,nr_pts)
%
% Injection Bump Plot function
%
% Plota o gráfico RMS x ponto
%
% A função distingue os pontos mínimos por meio do flag.
%
% Em preto: ponto descartado. Em roxo: Ponto mínimo encontrado.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com


output_data = input_data;

%% Set do grafico

if flag == 0
    
    plot_end_x = cell2mat(varargin)*1.2; %valor maximo para x
    max_valor = 1.5*valor;               %valor maximo para y
    
    figure1 = figure; % cria o grafico
    output_data.plot_figure_handle = figure1;
    
    axes1 = axes('Parent',figure1); % cria os eixos
    
    xlim(axes1,[0 plot_end_x]);
    if max_valor == 0
        ylim(axes1, [0 1]);
    else
        ylim(axes1,[0 max_valor]);
    end
    hold(axes1,'all');
    
    % titulos
    xlabel('Point');
    ylabel('RMS value of horizontal oscilation');
    title({'RMS value for each set of kicker parameters'});
          
    %plota o ponto inicial.
    plot(n,valor,'MarkerEdgeColor',[1 0 1],'MarkerSize',5,'Marker','o','Color',[1 0 1]);
         
    %hold on;
    
else
    figure(output_data.plot_figure_handle);
end;

%% Plota um mínimo

if flag == 1
    figure(output_data.plot_figure_handle);
    plot(n,valor,'MarkerEdgeColor',[1 0 1],'MarkerSize',5,'Marker','o','Color',[1 0 1]);
end

%% Plota um ponto descartado

if flag == 2
    figure(output_data.plot_figure_handle);
    plot(n,valor,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
    'Marker','x',...
    'LineStyle','none',...
    'Color',[0 0 0]);
end
function injbump_print_new_min(point_min)
%injbump_print_new_min(point_min)
%
% Injection Bump Print New Min
%
% Escreve no prompt do MATLAB os dados do último ponto mínimo encontrado.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Armazena os dados do ponto

[G F] = lnls1_booster_delay2GF(point_min.parms(4));
AKC02 = [point_min.parms(1) G F];
[G F] = lnls1_booster_delay2GF(point_min.parms(5));
AKC03 = [point_min.parms(2) G F];
[G F] = lnls1_booster_delay2GF(point_min.parms(6));
AKC04 = [point_min.parms(3) G F]; 

%% Escreve os dados no prompt

fprintf('Last min found: idx = %f MDN = %f \n', point_min.idx, point_min.mdn);
fprintf('[AKC02 %f %f %f] [AKC03 %f %f %f] [AKC04 %f %f %f]\n', AKC02(1), AKC02(2), AKC02(3), AKC03(1), AKC03(2), AKC03(3), AKC04(1), AKC04(2), AKC04(3));
function r = injbump_process_data(varargin)
%function r = injbump_process_data(varargin)
%function r = injbump_process_data(data_in,idx1,idx2)
%
% InjectionBump  Data Processing
%
%Lê os dados para um mesmo experimento e gera uma tabela com
%os valores RMS de cada medida, a média deles e os erros e desvios.
%
%A saída se divide nos valores tabelados para cada medida(data) e valores
%medios(media) para cada componente transversal (x ou y).
%
%---Intervalo de importância
%Se os valores idx 1 e 2 forem indicados a analise sera feita entre esses
%pontos. Se nao, sera feita para toda a curva
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com
   


%% Se nao for setado, pede um diretório
  
%data_in = cell2mat(varargin(1));
data_in = varargin{1};
 
if length(varargin)<2  %índices do intervalo de importância
    idx1 = [];
    idx2 = [];
else
    idx = cell2mat(varargin(2));
    idx1 = idx(1);
    idx2 = idx(2);
end


%% constantes

nm_2_um = 1000; % converte os dados do libera em micrometros (raw = nm)


%% Calcula os valores a partir de um diretorio

n_arq = length(data_in); %numero de arquivos

%envia os dados dos arquivos para a funcao bump_rms e armazena seus dados
%de saida em vetores do struct

for n = 1:n_arq
    
        data = data_in{n}/nm_2_um;
        if length(varargin)<2
            temp = injbump_rms(data);
        else
            temp = injbump_rms(data, idx1,idx2);
        end
        x.data.rms(n) = temp.x.rms;
        x.data.max(n) = temp.x.max;
        x.data.min(n) = temp.x.min;
        y.data.rms(n) = temp.y.rms;
        y.data.max(n) = temp.y.max;
        y.data.min(n) = temp.y.min;           
end

m = n_arq; % auxiliar

%% Joga os dados na resposta

r.x = x;
r.y = y;

%% Calcula os valores de rms para x
dim = 'x';

r.(dim).media.rms = mean(r.(dim).data.rms);
r.(dim).media.mdn = median(r.(dim).data.rms);

%Metodo sem graça (desvio padrao)
r.(dim).media.std = std(r.(dim).data.rms);

%% Calcula os valores maximo e minimo (medios) para x

r.(dim).media.max = mean(r.(dim).data.max);
r.(dim).media.min = mean(r.(dim).data.min);


%% Calcula os valores de rms para y

dim = 'y';

r.(dim).media.rms = mean(r.(dim).data.rms);

%Metodo sem graça (desvio padrao)
r.(dim).media.std = std(r.(dim).data.rms);

%% Calcula os valores maximo e minimo (medios) para y

r.(dim).media.max = mean(r.(dim).data.max);
r.(dim).media.min = mean(r.(dim).data.min);
function r = injbump_rms(data_in,varargin)
%function r = injbump_rms(data_in,idx1,idx2) 
%function r = injbump_rms(data_in,idx1,idx2)
%
%Injection Bump RMS
%
% Faz a análise RMS e de valores de pico das curvas de posição horizontal e
%vertical geradas pelo Libera.
%
%data_in são os dados do Libera
%
% Se for indicado o intervalo de importancia(idx1,1dx2), o rms será calculado 
%dentro dele. Senão, será calculado para toda a extensão dos dados.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Intervalo de importância

if isempty(varargin)
    idx1 = 1;
    idx2 = length(data_in);
else
    idx1 = cell2mat(varargin(1));
    idx2 = cell2mat(varargin(2));
end

%% Cálculo do RMS

% O valor rms da curva original menos o offset vertical é o mesmo calculado
%pela função std(2) do matlab.

r.data_in = data_in;

% std das oscilações horizontais
col = 5;     %coluna dos dados da osc. hor. do feixe no arquivo do Libera
dim = 'x';
r.(dim).idx1 = idx1;
r.(dim).idx2 = idx2; 
data = data_in(r.(dim).idx1:r.(dim).idx2,col);
r.(dim).rms = std(data,1);
r.(dim).max = max(data);
r.(dim).min = min(data);


% std das oscilacoes verticais
col = 6;     %coluna dos dados da osc. vert. do feixe no arquivo do Libera
dim = 'y';
r.(dim).idx1 = idx1;
r.(dim).idx2 = idx2;
data = data_in(r.(dim).idx1:r.(dim).idx2,col);
r.(dim).rms = std(data,1);
r.(dim).max = max(data);
r.(dim).min = min(data);
function r = injbump_setpv(varargin)
%injbump_setpv(pv_name,value)
%
% Função de simulação para a função do MML "setpv".
%
% A entrada é composta pelo parâmetro a ser modificado e o valor dele. 
% Esses dados são salvos na variável de simulação point_parms.
% 
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Retorna os parâmetros dos kickers (simulação)

global point_parms

varargin = varargin{1};
pv_name = varargin{1};
value = varargin{2};

r = [];

% Tensão
if strcmpi(pv_name, 'AKC02_SP')
    point_parms(1) = value;
    return;
end

if strcmpi(pv_name, 'AKC03_SP')
    point_parms(2) = value;
    return;
end

if strcmpi(pv_name, 'AKC04_SP')
    point_parms(3) = value;
    return;
end


% Atraso Ajuste Grosso
if strcmpi(pv_name, 'AKC02_AG_SP')
    point_parms(4) = value;
    return;
end

if strcmpi(pv_name, 'AKC03_AG_SP')
    point_parms(5) = value;
    return;
end

if strcmpi(pv_name, 'AKC04_AG_SP')
    point_parms(6) = value;
    return;
end

% Atraso Ajuste Fino

if strcmpi(pv_name, 'AKC02_AF_SP')
    point_parms(7) = value;
    return;
end

if strcmpi(pv_name, 'AKC03_AF_SP')
    point_parms(8) = value;
    return;
end

if strcmpi(pv_name, 'AKC04_AF_SP')
    point_parms(9) = value;
    return;
end
function r = injbump_sim_annealing(point, point_min, window,varargin)
%r = injbump_sim_annealing(point, point_min, window)
%
%Injection Bump Simulated Annealing
%
% Gera um novo ponto pelo método de simulated annealing.
%
% O método foi simplificado para o caso específico em que T = 0.
%
%Rodrigo B. Braga LNLS-FAC-BV2010
%rodrigobraga.fuzz@gmail.com

%% Calcula novo ponto.
r = point;

delta = (rand(1,6) - 0.5).*window ;

newpoint_parms = point_min.parms + delta;

r.parms = newpoint_parms;
r.delta = delta;
