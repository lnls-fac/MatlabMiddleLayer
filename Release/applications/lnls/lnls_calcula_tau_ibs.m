% LNLS_CALCULA_TAU_IBS calcula as contribui��es para o tempo de vida e o
% tempo de vida total, considerando o aumento das emit�ncias devido a
% Intrabeam Scattering,  conforme calculado pela fun��o lnls_calcula_ibs, a
% partir de uma  modifica��o da fun��o lnls_calcula_tau.
%
%   [lifetime,pressure,relEmit] = LNLS_CALCULA_TAU_IBS(data1,data2,r,pres,
%   vacc) com pres=-1 usa o arquivo de perfil de press�o especificado em
%   AD; com vacc=-1, usa o perfil de c�mara de v�cuo no modelo.
%
%   ENTRADA
%       data1       struct com os par�metros do anel (atsummary):
%                       e0                   energia [GeV]
%                       revTime              per�odo de revolu��o [s]
%                       gamma
%                       twiss
%                       compactionFactor
%                       damping
%                       naturalEnergySpread
%                       naturalEmittance     emit�ncia natural [m rad]
%                       radiationDamping     tempos de amortecimento [s]
%                       harmon
%                       overvoltage
%                       energyacceptance
%                       bunchlength          comprimento do pacote [m]
%       data2       struct com os par�metros do anel (getad):
%                       Machine
%                       Submachine
%                       Coupling             coeficiente de acoplamento
%                       BeamCurrent          corrente [A]
%                       NrBunches            n�mero de pacotes
%                      (OpsData.PrsProfFile) arquivo do perfil de press�o
%                      (OpsData.VccProfFile) arquivo da c�mara de v�cuo
%       r           fator multiplicativo para o comprimento do pacote
%       pres        nome do arquivo do perfil de press�o ou valor m�dio de
%                   press�o [mbar]
%       vacc        nome do arquivo do perfil de c�mara de v�cuo ou valores
%                   de meia abertura horizontal e vertical [Vx Vy] [m]
%	SA�DA
%       lifetime    struct com os valores de tempo de vida [h]
%       pressure    struct com os valores de press�o [mbar]
%       relEmit     aumento da emit�ncia fornecido por lnls_calcula_ibs
%
% NOTAS -------------------------------------------------------------------
%   1. O aumento da emit�ncia natural � calculado usando o aumento relativo
%      da emit�ncia horizontal fornecido por lnls_calcula_ibs
% -------------------------------------------------------------------------
%
% 2012-09-28 Afonso Haruo Carnielli Mukai


function [lifetime,pressure,relEmit] = lnls_calcula_tau_ibs(data1,data2,r,pres,vacc)

% Par�metros fixos
Z = 7;   % N�mero at�mico do �tomo do g�s residual diat�mico equivalente
T = 300; % Temperatura [K]

% Carga do el�tron [C]
qe = 1.60217653e-19;

[~,relEmit] = lnls_calcula_ibs(data1,data2,r);

if(pres == -1)
    %pres_temp = fullfile(getmmlroot,'machine',data2.Machine,data2.SubMachine,data2.OpsData.PrsProfFile);
    
    pres = 'sirius_si_pressure_profile.txt';
    pres = pres_temp;
    %if(exist(pres_temp,'file'))
       % pres = pres_temp;
    %end
end

% Copia par�metros
cp       = data1.e0;
T_rev    = data1.revTime;
gamma    = data1.gamma;
mcf      = data1.compactionFactor;
J_E      = data1.damping(3);
sigma_E  = data1.naturalEnergySpread * relEmit(3);
E_n      = data1.naturalEmittance * relEmit(1);
tau_am   = data1.radiationDamping;
k        = data1.harmon;
q        = data1.overvoltage;
d_acc    = data1.energyacceptance;
sigma_s  = data1.bunchlength * r * relEmit(4);
if(isfield(data2,'Coupling') && isfield(data2,'BeamCurrent'))
    %K             = data2.Coupling;
    %I             = data2.BeamCurrent;
    I = 0.1; %pode mudar valores de coupling e corrente
    K = 0.03;
    data2.Couping = K;
    data2.BeamCurrent = I;
    flag_quantum  = true;
    flag_touschek = true;
elseif(isfield(data2,'Coupling'))
    K             = data2.Coupling;
    flag_quantum  = true;
    flag_touschek = false;
else
    flag_quantum  = false;
    flag_touschek = false;
end
if(isfield(data2,'NrBunches'))
    Nb = data2.NrBunches;
else
    Nb = k;
end
if(exist('refine','var'))
    if(vacc == -1)
        error('refine cannot be used with vacc=-1.');
    elseif(isnumeric(refine))
        global THERING;
        RING2       = lnls_refine_lattice(THERING,refine);
        twiss       = calctwiss(RING2);
        s_B         = twiss.pos;
        Bx          = twiss.betax;
        By          = twiss.betay;
        alpha       = twiss.alphax;
        etax        = twiss.etax;
        etaxl       = twiss.etaxl;
        etay        = twiss.etay;
        etayl       = twiss.etayl;
        flag_refine = true;
    else
        error('refine must be a number.');
    end
else
    n        = length(data1.twiss.SPos);
    s_B      = data1.twiss.SPos(1:n-1);
    Bx       = data1.twiss.beta(1:n-1,1);
    By       = data1.twiss.beta(1:n-1,2);
    alphax   = data1.twiss.alpha(1:n-1,1);
    alphay   = data1.twiss.alpha(1:n-1,2);
    etax     = data1.twiss.Dispersion(1:n-1,1);
    etaxl    = data1.twiss.Dispersion(1:n-1,2);
    etay     = data1.twiss.Dispersion(1:n-1,3);
    etayl    = data1.twiss.Dispersion(1:n-1,4);
    flag_refine = false;
end

% Calcula aceit�ncias
[EA_x,EA_y,R,err] = lnls_calcula_aceitancias(data1.the_ring,s_B,Bx,By,vacc);
if(err)
    flag_elastic = false;
else
    flag_elastic = true;
end

load('accep.mat');

% Carrega fun��es
[r,P,Bx,By,alphax,alphay,etax,etaxl,etay,etayl,err] = lnls_carrega_funcoes(s_B,Bx,By,alphax,alphay,etax,etay,etaxl,etayl,pres,flag_refine);
if(err)
    flag_pressure = false;
else
    flag_pressure = true;
end
 n        = length(r);
data1.twiss.SPos(1:n)           = r;
data1.twiss.beta(1:n,1)         = Bx;
data1.twiss.beta(1:n,2)         = By;
data1.twiss.alpha(1:n,1)        = alphax;
data1.twiss.alpha(1:n,2)        = alphay;
data1.twiss.Dispersion(1:n,1)   = etax;
data1.twiss.Dispersion(1:n,2)   = etaxl;
data1.twiss.Dispersion(1:n,3)   = etay;
data1.twiss.Dispersion(1:n,4)   = etayl;

% Calcula as contribui��es para o tempo de vida
% Tempo de vida qu�ntico
if(flag_quantum)
    W_q = lnls_tau_quantico_inverso(tau_am,K,EA_x,EA_y,E_n,cp,mcf,k,q,J_E);
    lifetime.quantum   = (1/W_q) / 3600;
else
    W_q = 0;
    lifetime.quantum = 'Not available';
end
% Tempo de vida el�stico e inel�stico
if(flag_pressure)
    if(flag_elastic)
        [~,W_e] = lnls_tau_elastico_inverso(Z,T,cp,R,EA_x,EA_y,r,P,Bx,By);
        lifetime.elastic   = (1/W_e) / 3600;
    else
        W_e = 0;
        lifetime.elastic   = 'Not available';
    end
    [~,W_i] = lnls_tau_inelastico_inverso(Z,T,d_acc,r,P);
    lifetime.inelastic = (1/W_i) / 3600;
else
    W_e = 0;
    W_i = 0;
    lifetime.elastic   = 'Not available';
    lifetime.inelastic = 'Not available';
end
% Tempo de vida Touschek
if(flag_touschek)
    N = I * T_rev / (qe * Nb);
    %[~,W_t,~] = lnls_tau_touschek_inverso(E_n,gamma,N,sigma_E,sigma_s,d_acc,r,Bx,By,alpha,eta,eta_diff,K);
    Resp = touschek_lifetime(data1,data2,Accep);
    W_t = Resp.AveRate;
    lifetime.touschek = (1/W_t) / 3600;
else
    W_t = 0;
    lifetime.touschek = 'Not available';
end

% Tempo de vida
if(flag_quantum && flag_pressure && flag_elastic && flag_touschek)
    W = W_q + W_e + W_i + W_t;
    lifetime.total = (1/W) / 3600;
else
    lifetime.total = 'Not available';
end

% Press�o
if(flag_pressure)
    pressure.average = trapz(r,P) / (r(length(r) - r(1)));
    pressure.min     = min(P);
    pressure.max     = max(P);
else
    pressure.average = 'Not available';
    pressure.min     = 'Not available';
    pressure.max     = 'Not available';
end
