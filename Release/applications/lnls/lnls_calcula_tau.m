% LNLS_CALCULA_TAU calcula as contribuições para o tempo de vida e o tempo
% de vida total.
%
%   [lifetime,pressure] = LNLS_CALCULA_TAU(data1,data2,pres,vacc) com
%   pres=-1 usa o arquivo de perfil de pressão especificado em AD; com
%   vacc=-1, sem refine, usa o perfil de câmara de vácuo no modelo (nesse
%   caso, refine não pode ser usado).
%
%   [lifetime,pressure] = LNLS_CALCULA_TAU(data1,data2,pres,vacc,refine)
%   usa a função lnls_refine_lattice, passando refine como argumento.
%
%   ENTRADA
%       data1       struct com os parâmetros do anel (atsummary):
%                       e0                   energia [GeV]
%                       revTime              período de revolução [s]
%                       gamma
%                       twiss
%                       compactionFactor
%                       damping
%                       naturalEnergySpread
%                       naturalEmittance     emitância natural [m rad]
%                       radiationDamping     tempos de amortecimento [s]
%                       harmon
%                       overvoltage
%                       energyacceptance
%                       bunchlength          comprimento do pacote [m]
%       data2       struct com os parâmetros do anel (getad):
%                       Machine
%                       Submachine
%                       Coupling             coeficiente de acoplamento
%                       BeamCurrent          corrente [A]
%                       NrBunches            número de pacotes
%                      (OpsData.PrsProfFile) arquivo do perfil de pressão
%                      (OpsData.VccProfFile) arquivo da câmara de vácuo
%       pres        nome do arquivo do perfil de pressão ou valor médio de
%                   pressão [mbar]
%       vacc        nome do arquivo do perfil de câmara de vácuo ou valores
%                   de meia abertura horizontal e vertical [Vx Vy] [m]
%      (refine)     argumento para lnls_refine_lattice (opcional)
%	SAÍDA
%       lifetime    struct com os valores de tempo de vida [h]
%       pressure    struct com os valores de pressão [mbar]

function [lifetime,pressure] = lnls_calcula_tau(data1,data2,pres,vacc,refine)

% Parâmetros fixos
Z = 7;   % Número atômico do átomo do gás residual diatômico equivalente
T = 300; % Temperatura [K]

% Carga do elétron [C]
qe = 1.60217653e-19;

if(pres == -1)
    pres_temp = fullfile(getmmlroot,'machine',data2.Machine,data2.SubMachine,data2.OpsData.PrsProfFile);
    if(exist(pres_temp,'file'))
        pres = pres_temp;
    end
end

% Copia parâmetros
cp       = data1.e0;
T_rev    = data1.revTime;
gamma    = data1.gamma;
mcf      = data1.compactionFactor;
J_E      = data1.damping(3);
sigma_E  = data1.naturalEnergySpread;
E_n      = data1.naturalEmittance;
tau_am   = data1.radiationDamping;
k        = data1.harmon;
q        = data1.overvoltage;
d_acc    = data1.energyacceptance;
sigma_s  = data1.bunchlength;
if(isfield(data2,'Coupling') && isfield(data2,'BeamCurrent'))
    K             = data2.Coupling;
    I             = data2.BeamCurrent;
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
        eta         = twiss.etax;
        eta_diff    = twiss.etaxl;
        flag_refine = true;
    else
        error('refine must be a number.');
    end
else
    n        = length(data1.twiss.SPos);
    s_B      = data1.twiss.SPos(1:n-1);
    Bx       = data1.twiss.beta(1:n-1,1);
    By       = data1.twiss.beta(1:n-1,2);
    alpha    = data1.twiss.alpha(1:n-1,1);
    eta      = data1.twiss.Dispersion(1:n-1,1);
    eta_diff = data1.twiss.Dispersion(1:n-1,2);
    flag_refine = false;
end

% Calcula aceitâncias
[EA_x,EA_y,R,err] = lnls_calcula_aceitancias(data1.the_ring, s_B,Bx,By,vacc);
if(err)
    flag_elastic = false;
else
    flag_elastic = true;
end

% Carrega funções
[r,P,Bx,By,alpha,eta,eta_diff,err] = lnls_carrega_funcoes(s_B,Bx,By,alpha,eta,eta_diff,pres,flag_refine);
if(err)
    flag_pressure = false;
else
    flag_pressure = true;
end

% Calcula as contribuições para o tempo de vida
% Tempo de vida quântico
if(flag_quantum)
    W_q = lnls_tau_quantico_inverso(tau_am,K,EA_x,EA_y,E_n,cp,mcf,k,q,J_E);
    lifetime.quantum   = (1/W_q) / 3600;
else
    W_q = 0;
    lifetime.quantum = 'Not available';
end
% Tempo de vida elástico e inelástico
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
    [~,W_t,~] = lnls_tau_touschek_inverso(E_n,gamma,N,sigma_E,sigma_s,d_acc,r,Bx,By,alpha,eta,eta_diff,K);
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

% Pressão
if(flag_pressure)
    pressure.average = trapz(r,P) / (r(length(r) - r(1)));
    pressure.min     = min(P);
    pressure.max     = max(P);
else
    pressure.average = 'Not available';
    pressure.min     = 'Not available';
    pressure.max     = 'Not available';
end
