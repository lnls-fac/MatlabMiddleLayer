%   LNLS_CARREGA_FUNCOES fornece um vetor r com posições, a pressão P e as
%   funções Bx, By, -B'/2, D e D', sem elementos repetidos.
%
%   [r,P,Bx,By,alpha,eta,eta_diff,err] = LNLS_CARREGA_FUNCOES(s_B,Bx0,By0,
%   alpha0,eta0,eta_diff0,pres,flag_refine) com pres do tipo string carrega
%   o perfil de pressao cujo arquivo (caminho e nome) é pres; com pres
%   igual a um número, considera a pressão constante e igual a pres; com
%   pres vazio, abre interface para seleção de arquivo; com pres==-1, os
%   valores de pressão não são fornecidos.
%
%   ENTRADA
%       s_B          posição [m]
%       Bx0          função betatron horizontal [m]
%       By0          função betatron vertical [m]
%       alpha0       derivada da função betatron horizontal
%       eta0         função dispersão [m]
%       eta_diff0    derivada da função dispersão
%       pres         nome do arquivo .txt com o perfil de pressão ou valor
%                    médio da pressão [mbar] (opcional)
%       flag_refine  se verdadeiro, não interpola as funções
%   SAÍDA
%       r            posição [m]
%       P            pressão [mbar]
%       Bx           função betatron horizontal [m]
%       By           função betatron vertical [m]
%       alpha        derivada da função betatron horizontal
%       eta          função dispersão [m]
%       eta_diff     derivada da função dispersão
%       err          verdadeiro se ocorreu erro

function [r,P,Bx,By,alpha,eta,eta_diff,err] = lnls_carrega_funcoes(s_B,Bx0,By0,alpha0,eta0,eta_diff0,pres,flag_refine)

% Parâmetro fixo
h = 0.01; % passo para interpolação

err = false;

% Remove valores repetidos (para interpolação)
[r0,indices3] = unique(s_B);
Bx = Bx0(indices3);
By = By0(indices3);
alpha = alpha0(indices3);
eta = eta0(indices3);
eta_diff = eta_diff0(indices3);

idx_fim = length(r0);

if(flag_refine)
    r = r0;
else
    % Intervalo para interpolação
    a = r0(1);
    b = r0(idx_fim);
    r = (a:h:b)';
    
    % Interpola
    Bx = interp1(r0,Bx,r,'cubic');
    By = interp1(r0,By,r,'cubic');
    alpha = interp1(r0,alpha,r,'cubic');
    eta = interp1(r0,eta,r,'cubic');
    eta_diff = interp1(r0,eta_diff,r,'cubic');
end

idx_fim = length(r);

% Seleciona o perfil de pressão
if(pres == -1)
    err = true;
    P = 0;
    return;
elseif(isempty(pres))
    flag_interp = 1;
    [arquivo,caminho] = uigetfile('*.txt','Select pressure profile');
    if(~arquivo)
        err = true;
        P = 0;
        return;
    end
    nome = fullfile(caminho,arquivo);
elseif(ischar(pres))
    flag_interp = 1;
    nome = pres;
elseif(isnumeric(pres))
    flag_interp = 0;
    P = zeros(idx_fim,1) + pres;
else
    error('No pressure profile.');
end

% Interpola a pressão
if(flag_interp)
    [s_P,P1] = lnls_importa_perfil_pressao(nome);
    [s_P,idx] = unique(s_P);
    P1 = P1(idx);
    % Normaliza a posição
    s_P = s_P - s_P(1);
    s_P = s_P / s_P(length(s_P)) * r(idx_fim);
    P = interp1(s_P,P1,r,'linear');
end
