% lnls_calc_ibs_bane_cimp: calculates the horizontal and vertical emittance growth
% and relative energy spread due to intrabeam scattering. The code uses two
% approximated models: CIMP and high energy developed by Bane. Equilibrium
% emittances are calculated by the temporal evolution over a time which is
% a multiple of damping time, based on equations described in KIM - A Code 
% for Calculating the Time Evolution of Beam Parameters in High Intensity
% Circular Accelerators - PAC 97. The bunch length was calculated by the
% expression given in SANDS - The Physics of Electron Storage Rings, an
% Introduction.
% This function was based very much on lnls_calcula_ibs developed by Afonso H. C. Mukai 
% which calculates the effect of IBS with CIMP model only.
%   
%   INPUT
%       data_atsum      struct with ring parameters (atsummary):
%                       revTime              revolution time [s]
%                       gamma
%                       twiss
%                       compactionFactor
%                       damping
%                       naturalEnergySpread
%                       naturalEmittance     zero current emittance [m rad]
%                       radiationDamping     damping times [s]
%                       synctune
%       I           Beam Current [mA]
%       K           Coupling 
%       R(=1)       growth bunch length factor (optional)
%       'plot'      plot graphics of time evolution (optional)
%   OUTPUT
%       finalEmit   equilibrium values for Bane and CIMP models[Ex Ey sigmaE sigmaz]
%                   [m rad] [m rad] [] [m]
%       relEmit     variation of initial and final values (in %)
%
% April, 2018 
% =====================================================================================

function [finalEmitBANE,relEmitBANE,finalEmitCIMP,relEmitCIMP] = lnls_calc_ibs_bane_cimp(data_atsum,I,K,R,p)

% If there is no argument, set R=1
if(~exist('R','var'))
    R = 1;
end

% Verifies if the plot option was selected
if(exist('p','var'))
    if(strcmp(p,'plot'))
        flag_plot = true;
    else
        error('Invalid argument.');
    end
else
    flag_plot = false;
end

% Constants
qe = 1.6021773e-19; % electron charge [C]
r0 = 2.8179409e-15; % classic electron radius [m]
c  = 2.99792458e8;  % speed of light [m/s]

% Load interpolation tables
% Function g(alpha) of Bane's model (elliptic integral)
integraltable = getappdata(0, 'IBSGIntegralTableB');
if isempty(integraltable)
    load('g_bane_new.mat');
    integraltable.x_table = x_table;
    integraltable.g_table = g_table;
    setappdata(0, 'IBSGIntegralTableB', integraltable);
else
   x_table = integraltable.x_table;
   g_table = integraltable.g_table;
end
% Function g of CIMP model (Related to the associated Legendre functions)
ginttableC = getappdata(0, 'IBSGIntegralTableC');
if isempty(ginttableC)
    load('lnls_tabela_g_ibs.mat');
    ginttableC.w_tabela = w_tabela;
    ginttableC.g_tabela = g_tabela;
    setappdata(0, 'IBSGIntegralTableC', ginttableC);
else
    w_tabela = ginttableC.w_tabela;
    g_tabela = ginttableC.g_tabela;
end

% Take parameters of database
T_rev     = data_atsum.revTime;
gamma     = data_atsum.gamma;
alpha     = data_atsum.compactionFactor;
Je        = data_atsum.damping(3);
Se        = data_atsum.naturalEnergySpread;
Sb        = data_atsum.bunchlength;
En        = data_atsum.naturalEmittance;
tau_x     = data_atsum.radiationDamping(1);
tau_y     = data_atsum.radiationDamping(2);
tau_e     = data_atsum.radiationDamping(3);
%synctune  = data1.synctune;
%K         = data2.Coupling;  %If the function mode which calls getad as data2 is used
%I         = data_get.BeamCurrent; %If the function mode which calls getad as data2 is used
%Nb        = data_get.NrBunches; %If the function mode which calls getad as data2 is used
Nb        = 1; %It is useful to calculate the IBS effect with current per bunch

% Copy values making them unique
[s,idx]   = unique(data_atsum.twiss.SPos(2:end));
idx       = idx + 1;
betax     = data_atsum.twiss.beta(idx,1);
betay     = data_atsum.twiss.beta(idx,2);
alphax    = data_atsum.twiss.alpha(idx,1);
alphay    = data_atsum.twiss.alpha(idx,2);
etax      = data_atsum.twiss.Dispersion(idx,1);
etax_diff = data_atsum.twiss.Dispersion(idx,2);
etay      = data_atsum.twiss.Dispersion(idx,3);
etay_diff = data_atsum.twiss.Dispersion(idx,4);

delta_s = s(end) - s(1);
synctune = R*c*T_rev *alpha*Se/Sb/2/pi; %Synchrtron tune adjusted to match bunch length
omega = 2 * pi * synctune / T_rev; % angular synchrotron frequency [1/s]

[~,Hym] = calc_H(betay,alphay,etay,etay_diff,s);
Ex  = En/(1 + K);
Ey  = K*Ex + Je*Hym*Se^2;
%Sb  = R * c * alpha / omega * Se; % bunch length if it was not taken as an input
Eln = Se * Sb; % zero current longitudinal emittance
EBANEl = Eln;
ECIMPl = Eln;
EBANEx = Ex;
EBANEy = Ey;
ECIMPx = Ex;
ECIMPy = Ey;
SeBANE = Se;
SeCIMP = Se;
initialEmit = [Ex Ey Se Sb];

N = I* T_rev / qe / Nb; % number of electrons per bunch
CBANE = r0^2 * c * N / 16 / gamma^3; 
CCIMP = r0^2 * c * N / 64 / pi^2 /  gamma^4;
f = 10; %ratio of IBS times over damping times

tf = f * max([tau_x tau_y tau_e]);
delta_t = min([tau_x tau_y tau_e]) /f;
niter = ceil(tf / delta_t);
t = linspace(0,tf,niter);

EBANE = zeros(niter,3);
EBANE(1,:) = [Ex Ey Se];
ECIMP = zeros(niter,3);
ECIMP(1,:) = [Ex Ey Se];

% Calculates IBS effect 
% Total time and time step are set based on assumptions that IBS tipical 
%times are greater (about 10 times) than damping times

for i=1:niter
    Hx = calc_H(betax,alphax,etax,etax_diff);
    Hy = calc_H(betay,alphay,etay,etay_diff);

    sigma_H2BANE = 1 ./ ( Hx./EBANEx + Hy./EBANEy + 1/SeBANE^2 );
    sigma_HBANE  = sqrt(sigma_H2BANE);
               
    %Argument of g(\alpha) functions (for Bane and CIMP)
    aBANE = sigma_HBANE .* sqrt(betax./EBANEx) / gamma;
    bBANE = sigma_HBANE .* sqrt(betay./EBANEy) / gamma;
    razao = aBANE./bBANE;
    
    %Part of calculation related to Bane model

    ABANE = CBANE ./ (EBANEx).^(3/4) / (EBANEy).^(3/4) / EBANEl / (SeBANE).^2;
    SyBANE = sqrt(EBANEy.*betay + (SeBANE^2*etay).^2);
    LogBANE = log( SyBANE .* sigma_H2BANE / 4 / r0 ./ aBANE.^2 );

    gBANE_ab = interp1(x_table,g_table,razao);

    WeBANE = ABANE*LogBANE.*(sigma_HBANE.*gBANE_ab.*(betax.*betay).^(-1/4));
    WemBANE = trapz(s,WeBANE) / delta_s;
    TeBANE = 1 / WemBANE; % longitudinal growth time BANE

    WxBANE = (SeBANE)^2.*Hx./ EBANEx ;
    WxmBANE = trapz(s,WxBANE) / delta_s;
    TxBANE = TeBANE / WxmBANE; % horizontal growth time BANE

    WyBANE = (SeBANE).^2.*Hy./ EBANEy;
    WymBANE = trapz(s,WyBANE) / delta_s;
    TyBANE = TeBANE / WymBANE; % vertical growth time BANE

    delta_EBANEl = delta_t * ( EBANEl/TeBANE - (EBANEl - Eln)/tau_e );
    delta_EBANEx = delta_t * ( EBANEx/TxBANE - (EBANEx - Ex)/tau_x );
    delta_EBANEy = delta_t * ( EBANEy/TyBANE - (EBANEy - K*EBANEx/(1+K))/tau_y );

    EBANEl = EBANEl + delta_EBANEl;
    EBANEx = EBANEx + delta_EBANEx;
    EBANEy = EBANEy + delta_EBANEy;

    SeBANE  = sqrt(omega * EBANEl / c / alpha / R);
    EBANE(i,1) = EBANEx;
    EBANE(i,2) = EBANEy;
    EBANE(i,3) = SeBANE;
    
    %%=============================================================
    
    %Part of calculation related to CIMP model   
    ACIMP = CCIMP ./ ECIMPx / ECIMPy / ECIMPl;
    SyCIMP = sqrt(ECIMPy.*betay + (SeCIMP^2*etay).^2);
    LogCIMP = log( gamma^2 * SyCIMP .* ECIMPx ./ betax / r0 );
    
    sigma_H2CIMP = 1 ./ ( Hx./ECIMPx + Hy./ECIMPy + 1/SeCIMP^2 );
    sigma_HCIMP  = sqrt(sigma_H2CIMP);
    
    aCIMP = sigma_HCIMP .* sqrt(betax./ECIMPx) / gamma;
    bCIMP = sigma_HCIMP .* sqrt(betay./ECIMPy) / gamma;
    
    gCIMP_ab = interp1(w_tabela,g_tabela,aCIMP./bCIMP);
    gCIMP_ba = interp1(w_tabela,g_tabela,bCIMP./aCIMP);
    
    fator = gCIMP_ba./aCIMP + gCIMP_ab./bCIMP;
    
    WeCIMP = 2*pi^1.5 * ACIMP * LogCIMP .* sigma_H2CIMP / SeCIMP.^2 .* fator;
    WemCIMP = trapz(s,WeCIMP) / delta_s;
    TeCIMP = 1 / WemCIMP; % tempo de crescimento longitudinal CIMP
    
    WxCIMP = 2*pi^1.5 * ACIMP * LogCIMP .* ( -aCIMP.*gCIMP_ba + Hx.*sigma_H2CIMP/ECIMPx.*fator );
    WxmCIMP = trapz(s,WxCIMP) / delta_s;
    TxCIMP = 1 / WxmCIMP; % tempo de crescimento horizontal CIMP
    
    WyCIMP = 2*pi^1.5 * ACIMP * LogCIMP .* ( -bCIMP.*gCIMP_ab + Hy.*sigma_H2CIMP/ECIMPy.*fator );
    WymCIMP = trapz(s,WyCIMP) / delta_s;
    TyCIMP = 1 / WymCIMP; % tempo de crescimento vertical CIMP
    
    delta_ECIMPl = delta_t * ( ECIMPl/TeCIMP - (ECIMPl - Eln)/tau_e );
    delta_ECIMPx = delta_t * ( ECIMPx/TxCIMP - (ECIMPx - Ex)/tau_x );
    delta_ECIMPy = delta_t * ( ECIMPy/TyCIMP - (ECIMPy - K*ECIMPx/(1+K))/tau_y );
    
    ECIMPl = ECIMPl + delta_ECIMPl;
    ECIMPx = ECIMPx + delta_ECIMPx;
    ECIMPy = ECIMPy + delta_ECIMPy;
    
    SeCIMP  = sqrt(omega * ECIMPl / c / alpha / R);
    ECIMP(i,1) = ECIMPx;
    ECIMP(i,2) = ECIMPy;
    ECIMP(i,3) = SeCIMP;

end

SBANEb  = R * c * alpha / omega * SeBANE;
SCIMPb  = R * c * alpha / omega * SeCIMP;


finalEmitBANE = [EBANEx EBANEy SeBANE SBANEb]; %final values
finalEmitCIMP = [ECIMPx ECIMPy SeCIMP SCIMPb];
relEmitBANE   = abs(1-finalEmitBANE ./ initialEmit).*100; %parameters variation in %
relEmitCIMP   = abs(1-finalEmitCIMP ./ initialEmit).*100;


%Setting plots
if(flag_plot)
    EBANE(:,1) = EBANE(:,1) * 1e12;
    EBANE(:,2) = EBANE(:,2) * 1e12;
    EBANE(:,3) = EBANE(:,3) * 10000;
    ECIMP(:,1) = ECIMP(:,1) * 1e12;
    ECIMP(:,2) = ECIMP(:,2) * 1e12;
    ECIMP(:,3) = ECIMP(:,3) * 10000;
    
    t_min = t(1);
    t_max = t(end);
    f_min = 0.96;
    f_max = 1.04;
    
    figure;
    plot(t,EBANE(:,1),'color',[1.0 0.0 0.0]);
    title('Horizontal Emittance');
    xlabel('t [s]');
    ylabel('\epsilon_x [pm rad]');
    axis([t_min t_max f_min*min(EBANE(:,1)) f_max*max(EBANE(:,1))]);
    
    hold on 
    
    plot(t,ECIMP(:,1),'color',[0.0 0.0 1.0]);
    
    legend('BANE','CIMP','location','east');
    hold off
    
    figure;
    plot(t,EBANE(:,2),'color',[1.0 0.0 0.0]);
    title('Vertical Emittance');
    xlabel('t [s]');
    ylabel('\epsilon_y [pm rad]');
    axis([t_min t_max f_min*min(EBANE(:,2)) f_max*max(EBANE(:,2))]);
    
    hold on
    
    plot(t,ECIMP(:,2),'color',[0.0 0.0 1.0]);
    legend('BANE','CIMP','location','east');

    hold off
    
    figure;
    plot(t,EBANE(:,3),'color',[1.0 0.0 0.0]);
    title('Energy Spread');
    xlabel('t [s]');
    ylabel('\sigma_E / E_0 [10^{-4}]');
    axis([t_min t_max f_min*min(EBANE(:,3)) f_max*max(EBANE(:,3))]);    
    
    hold on
    
    plot(t,ECIMP(:,3),'color',[0.0 0.0 1.0]);
    legend('BANE','CIMP','location','east');
    
    hold off  
    
    
end


function [H,Hm] = calc_H(beta,alpha,eta,eta_diff,s)

H = (eta.^2 + (beta.*eta_diff + alpha.*eta).^2)./beta;

if(nargin == 5)
    Hm = trapz(s,H) / (s(end) - s(1));
end
