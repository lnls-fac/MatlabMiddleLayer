%   LNLS_CARREGA_FUNCOES fornece um vetor r com posi��es, a press�o P e as
%   fun��es Bx, By, -B'/2, D e D', sem elementos repetidos.
%
%   [r,P,Bx,By,alpha,eta,eta_diff,err] = LNLS_CARREGA_FUNCOES(s_B,Bx0,By0,
%   alpha0,eta0,eta_diff0,pres,flag_refine) com pres do tipo string carrega
%   o perfil de pressao cujo arquivo (caminho e nome) � pres; com pres
%   igual a um n�mero, considera a press�o constante e igual a pres; com
%   pres vazio, abre interface para sele��o de arquivo; com pres==-1, os
%   valores de press�o n�o s�o fornecidos.
%
%   ENTRADA
%       s_B          posi��o [m]
%       Bx0          fun��o betatron horizontal [m]
%       By0          fun��o betatron vertical [m]
%       alpha0       derivada da fun��o betatron horizontal
%       eta0         fun��o dispers�o [m]
%       eta_diff0    derivada da fun��o dispers�o
%       pres         nome do arquivo .txt com o perfil de press�o ou valor
%                    m�dio da press�o [mbar] (opcional)
%       flag_refine  se verdadeiro, n�o interpola as fun��es
%   SA�DA
%       r            posi��o [m]
%       P            press�o [mbar]
%       Bx           fun��o betatron horizontal [m]
%       By           fun��o betatron vertical [m]
%       alpha        derivada da fun��o betatron horizontal
%       eta          fun��o dispers�o [m]
%       eta_diff     derivada da fun��o dispers�o
%       err          verdadeiro se ocorreu erro

function [r,P,Bx,By,alphax,alphay,etax,etaxl,etay,etayl,err] = lnls_carrega_funcoes(s_B,Bx0,By0,alphax0,alphay0,etax0,etay0,etaxl0,etayl0,pres,flag_refine)

% Par�metro fixo
h = 0.01; % passo para interpola��o

err = false;

% Remove valores repetidos (para interpola��o)
[r0,indices3] = unique(s_B);
Bx = Bx0(indices3);
By = By0(indices3);
alphax = alphax0(indices3);
alphay = alphay0(indices3);
etax = etax0(indices3);
etay = etay0(indices3);
etaxl = etaxl0(indices3);
etayl = etayl0(indices3);

idx_fim = length(r0);

if(flag_refine)
    r = r0;
else
    % Intervalo para interpola��o
    a = r0(1);
    b = r0(idx_fim);
    r = (a:h:b)';
    
    % Interpola
    Bx = interp1(r0,Bx,r,'pchip');
    By = interp1(r0,By,r,'pchip');
    alphax = interp1(r0,alphax,r,'pchip');
    alphay = interp1(r0,alphay,r,'pchip');
    etax = interp1(r0,etax,r,'pchip');
    etaxl = interp1(r0,etaxl,r,'pchip');
    etay = interp1(r0,etay,r,'pchip');
    etayl = interp1(r0,etayl,r,'pchip');
end

idx_fim = length(r);

% Seleciona o perfil de press�o
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

% Interpola a press�o
if(flag_interp)
    [s_P,P1] = lnls_importa_perfil_pressao(nome);
    [s_P,idx] = unique(s_P);
    P1 = P1(idx);
    % Normaliza a posi��o
    s_P = s_P - s_P(1);
    s_P = s_P / s_P(length(s_P)) * r(idx_fim);
    P = interp1(s_P,P1,r,'linear');
end
