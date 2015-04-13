% LNLS_CALCULA_IBS calcula o aumento das emit�ncias horizontal e vertical e
% o aumento da dispers�o relativa de energia devido a Intrabeam Scattering,
% com base na aproxima��o CIMP descrita em KUBO, MTINGWA, AND WOLSKI -
% Intrabeam scattering formulas for high energy beams - Phys. Rev. ST
% Accel. Beams 8, 081001 (2005). As emit�ncias  de equil�brio s�o
% calculadas pela evolu��o temporal em um tempo m�ltiplo do tempo de
% amortecimento, com base nas equa��es descritas em KIM - A Code for
% Calculating the Time Evolution of Beam Parameters in High Intensity
% Circular Accelerators - PAC 97. O comprimento do pacote � calculado pela
% express�o em SANDS - The Physics of Electron Storage Rings, an
% Introduction.
%
%   [finalEmit,relEmit] = LNLS_CALCULA_IBS(data1,data2)
%   [finalEmit,relEmit] = LNLS_CALCULA_IBS(data1,data2,R)
%   [finalEmit,relEmit] = LNLS_CALCULA_IBS(data1,data2,R,'plot')
%
%   ENTRADA
%       data1       struct com os par�metros do anel (atsummary):
%                       revTime              per�odo de revolu��o [s]
%                       gamma
%                       twiss
%                       compactionFactor
%                       damping
%                       naturalEnergySpread
%                       naturalEmittance     emit�ncia natural [m rad]
%                       radiationDamping     tempos de amortecimento [s]
%                       synctune
%       data2       struct com os par�metros do anel (getad):
%                       Coupling             coeficiente de acoplamento
%                       BeamCurrent          corrente [A]
%                       NrBunches            n�mero de pacotes
%       R(=1)       fator de aumento do comprimento do pacote (opcional)
%       'plot'      gera gr�ficos da evolu��o temporal (opcional)
%   SA�DA
%       finalEmit   valores de equil�brio [Ex Ey sigmaE sigmaz] 
%                   [m rad] [m rad] [] [m]
%       relEmit     raz�o entre os valores finais e iniciais
%
% NOTAS -------------------------------------------------------------------
%   1. Desvio de energia relativo n�o bate com o Tracy
%   2. Gr�ficos n�o batem com o Elegant
%   3. Pend�ncias:
%       - melhorar integra��o
%       - adicionar op��es para c�lculo dos tempos de crescimento atrav�s
%         de outros m�todos (aproxima��o de Bane, Bjorken-Mtingwa)?
% -------------------------------------------------------------------------
%
% 2012-09-06 Afonso Haruo Carnielli Mukai

function [finalEmit,relEmit] = lnls_calcula_ibs(data1,data2,R,p)

% Se o argumento R n�o existe, R = 1
if(~exist('R','var'))
    R = 1;
end

% Verifica se a op��o de gr�ficos foi selecionada
if(exist('p','var'))
    if(strcmp(p,'plot'))
        flag_plot = true;
    else
        error('Invalid argument.');
    end
else
    flag_plot = false;
end

% Constantes
qe = 1.6021773e-19; % carga do el�tron [C]
r0 = 2.8179409e-15; % raio cl�ssico do el�tron [m]
c  = 2.99792458e8;  % velocidade da luz [m/s]

% Carrega tabela para interpola��o
ginttable = getappdata(0, 'IBSGIntegralTable');
if isempty(ginttable)
    load('lnls_tabela_g_ibs.mat');
    ginttable.w_tabela = w_tabela;
    ginttable.g_tabela = g_tabela;
    setappdata(0, 'IBSGIntegralTable', ginttable);
else
    w_tabela = ginttable.w_tabela;
    g_tabela = ginttable.g_tabela;
end

% Copia par�metros
T_rev     = data1.revTime;
gamma     = data1.gamma;
alpha     = data1.compactionFactor;
Je        = data1.damping(3);
Se        = data1.naturalEnergySpread;
En        = data1.naturalEmittance;
tau_x     = data1.radiationDamping(1);
tau_y     = data1.radiationDamping(2);
tau_e     = data1.radiationDamping(3);
synctune  = data1.synctune;
K         = data2.Coupling;
I         = data2.BeamCurrent;
Nb        = data2.NrBunches;
% Copia removendo valores repetidos
[s,idx]   = unique(data1.twiss.SPos(2:end));
idx       = idx + 1;
betax     = data1.twiss.beta(idx,1);
betay     = data1.twiss.beta(idx,2);
alphax    = data1.twiss.alpha(idx,1);
alphay    = data1.twiss.alpha(idx,2);
etax      = data1.twiss.Dispersion(idx,1);
etax_diff = data1.twiss.Dispersion(idx,2);
etay      = data1.twiss.Dispersion(idx,3);
etay_diff = data1.twiss.Dispersion(idx,4);

N = I * T_rev / qe / Nb % n�mero de el�trons por bunch
C = r0^2 * c * N / 64 / pi^2 /  gamma^4;
delta_s = s(end) - s(1);

omega = 2 * pi * synctune / T_rev; % frequ�ncia s�ncrotron angular

[~,Hym] = calcula_H(betay,alphay,etay,etay_diff,s);

% Valores iniciais de emit�ncia
Ex  = En/(1 + K);
Ey  = K*En/(1 + K) + Je*Hym*Se^2;
Sb  = R * c * alpha / omega * Se; % comprimento do pacote
Eln = Se * Sb; % emit�ncia longitudinal natural
El  = Eln;

initialEmit = [Ex Ey Se Sb];

% Calcula IBS
tf = 10 * max([tau_x tau_y tau_e]);
delta_t = min([tau_x tau_y tau_e]) / 10;
niter = ceil(tf / delta_t);
t = zeros(niter,1);
E = zeros(niter,3);
E(1,:) = [Ex Ey Se];
Se0 = Se;
El0 = El;
Ex0 = Ex;
Ey0 = Ey;
for i=2:niter    
    Hx = calcula_H(betax,alphax,etax,etax_diff);
    Hy = calcula_H(betay,alphay,etay,etay_diff);
    
    sigma_H2 = 1 ./ ( Hx./Ex0 + Hy./Ey0 + 1/Se0^2 );
    sigma_H  = sqrt(sigma_H2);
    
    a = sigma_H .* sqrt(betax./Ex0) / gamma;
    b = sigma_H .* sqrt(betay./Ey0) / gamma;
    
    A = C ./ Ex0 / Ey0 / El0;
    Sy = sqrt(Ey0.*betay + (Se0^2*etay).^2);
    Log = log( gamma^2 * Sy .* Ex0 ./ betax / r0 );
    
    g_ab = interp1(w_tabela,g_tabela,a./b);
    g_ba = interp1(w_tabela,g_tabela,b./a);
    
    fator = g_ba./a + g_ab./b;
    
    We = 2*pi^1.5 * A * Log .* sigma_H2 / Se0^2 .* fator;
    Wem = trapz(s,We) / delta_s;
    Te = 1 / Wem; % tempo de crescimento longitudinal
    
    Wx = 2*pi^1.5 * A * Log .* ( -a.*g_ba + Hx.*sigma_H2/Ex0.*fator );
    Wxm = trapz(s,Wx) / delta_s;
    Tx = 1 / Wxm; % tempo de crescimento horizontal
    
    Wy = 2*pi^1.5 * A * Log .* ( -b.*g_ab + Hy.*sigma_H2/Ey0.*fator );
    Wym = trapz(s,Wy) / delta_s;
    Ty = 1 / Wym; % tempo de crescimento vertical
    
    delta_El = delta_t * ( El0/Te - (El0 - Eln)/tau_e );
    delta_Ex = delta_t * ( Ex0/Tx - (Ex0 - En/(1+K))/tau_x );
    delta_Ey = delta_t * ( Ey0/Ty - (Ey0 - K*Ex0/(1+K))/tau_y );
    
    El = El + delta_El;
    Ex = Ex + delta_Ex;
    Ey = Ey + delta_Ey;
    
    El0 = El;
    Ex0 = Ex;
    Ey0 = Ey;
    
    Se  = sqrt(omega * El / c / alpha / R);
    Se0 = Se;
    
    t(i)   = (i - 1) * delta_t;
    E(i,1) = Ex;
    E(i,2) = Ey;
    E(i,3) = Se;
end

Sb  = R * c * alpha / omega * Se;

finalEmit = [Ex Ey Se Sb];
relEmit   = finalEmit ./ initialEmit;

if(flag_plot)
    E(:,1) = E(:,1) * 1e12;
    E(:,2) = E(:,2) * 1e12;
    E(:,3) = E(:,3) * 100;
    
    t_min = t(1);
    t_max = t(end);
    f_min = 0.96;
    f_max = 1.04;
    
    figure;
    plot(t,E(:,1),'color',[0.0 0.0 1.0]);
    title('Horizontal Emittance');
    xlabel('t [s]');
    ylabel('\epsilon_x [pm rad]');
    axis([t_min t_max f_min*min(E(:,1)) f_max*max(E(:,1))]);
    
    figure;
    plot(t,E(:,2),'color',[0.0 0.5 0.0]);
    title('Vertical Emittance');
    xlabel('t [s]');
    ylabel('\epsilon_y [pm rad]');
    axis([t_min t_max f_min*min(E(:,2)) f_max*max(E(:,2))]);
    
    figure;
    plot(t,E(:,3),'color',[1.0 0.0 0.0]);
    title('Energy Spread');
    xlabel('t [s]');
    ylabel('\sigma_E / E_0 [%]');
    axis([t_min t_max f_min*min(E(:,3)) f_max*max(E(:,3))]);
end


function [H,Hm] = calcula_H(beta,alpha,eta,eta_diff,s)

H = (eta.^2 + (beta.*eta_diff + alpha.*eta).^2)./beta;

if(nargin == 5)
    Hm = trapz(s,H) / (s(end) - s(1));
end
