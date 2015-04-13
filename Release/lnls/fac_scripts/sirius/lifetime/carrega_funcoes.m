%   [r,P,Bx,By,alpha,eta,eta_diff,s_P_dipolo] = carrega_funcoes(arquivo)
%   fornece um vetor r com posições igualmente espaçadas em m, a pressão P
%   em arquivo(.txt) interpolada nos pontos de r e as funções Bx, By,
%   -B'/2, D e D' interpoladas ao longo desses pontos, usando o at.
%
%   A função importa o perfil de pressão do arquivo .txt, para um trecho do
%   anel até o marker definido em nomeft, com o vetor de posições
%   correspondente. Bx, By, alpha=-Bx'/2, eta e eta' são obtidas do at, com
%   calctwiss. Se a posição do dipolo no perfil de pressão é conhecida, o
%   vetor posição do perfil de pressão é transladado para coincidir com as
%   posições das funções obtidas do at, com o nome do dipolo definido em
%   nomedp; caso não seja, o perfil de pressão é transladado para o centro
%   do trecho. Os valores finais fornecidos pela função são obtidos por
%   interpolação dentro do intervalo determinado pela intersecção do perfil
%   de pressão com o intervalo do trecho.

function [r,P,Bx,By,alpha,eta,eta_diff,s_P_dipolo]...
    = carrega_funcoes(arquivo)

% Importa perfil de pressão
[s_P,P1,s_P_dipolo,nome_pos_dipolo,nome_fim_trecho] = importa_perfil_pressao(arquivo);

% Obtém dados do at
global THERING
A = calctwiss;

% Encontra índice do final do 1º trecho.
indices1 = findcells(THERING,'FamName',nome_fim_trecho);
i_B_fim = indices1(1);
% Obtém valores de beta para o trecho.
s_B = A.pos(1:i_B_fim);        % Posição
Bx1 = A.betax(1:i_B_fim);      % Função betatron horizontal no trecho
By1 = A.betay(1:i_B_fim);      % Função betatron vertical no trecho
alpha1 = A.alphax;
eta1 = A.etax;

n_P = length(s_P);
n_B = length(s_B);


% Ajusta a origem da posição da pressão.
if(~isnan(s_P_dipolo))
    % Encontra índice do início do 1º dipolo em s_B.
    indices2 = findcells(THERING,'FamName',nome_pos_dipolo);
    i_B_dipolo = indices2(1);
    s_P = s_P + s_B(i_B_dipolo) - s_P_dipolo;
else
    % Desloca o perfil de pressão para o centro do trecho.
    s_P = s_P + (s_B(n_B) - s_B(1) - (s_P(n_P) - s_P(1))) / 2;
end


% Determina o intervalo da interpolação.
a = max(s_P(1),s_B(1));
b = min(s_P(n_P),s_B(n_B));

% Remove valores repetidos (para interpolação).
[s_B,indices3] = unique(s_B);
Bx1 = Bx1(indices3);
By1 = By1(indices3);
alpha1 = alpha1(indices3);
eta1 = eta1(indices3);

% Calcula a derivada de eta1
eta_diff = diff(eta1) ./ diff(s_B);
s_Be = s_B(1:(length(s_B)-1));

N = 1000;   % Número de pontos para interpolação
h = (b - a)/N;

% Interpola valores para integração.
r = a:h:b;                             % Pontos para interpolação
P = interp1(s_P,P1,r);                 % Valores interpolados de pressão
Bx = interp1(s_B,Bx1,r);               % Valores interpolados de betax
By = interp1(s_B,By1,r);               % Valores interpolados de betay
alpha = interp1(s_B,alpha1,r);         % Valores interpolados de alpha
eta = interp1(s_B,eta1,r);             % Valores interpolados de eta
% Valores interpolados e extrapolados de eta_diff
eta_diff = interp1(s_Be,eta_diff,r,'linear','extrap');