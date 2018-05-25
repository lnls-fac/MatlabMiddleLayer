% lnls_calc_total_lifetime: calculates each contribution for the total
% lifetime (quantum, elastic, inelastic and Touschek). For the Touschek
% lifetime it takes the effect of IBS into account. For the elastic and
% inelastic lifetimes it was used a simulated pressure profile with
% accumulated charge of 10000Ah and considering the effect of delta
% undulator radiation. Data file is "Pressure_Profile.txt".
%
% Input - data_at: struct with ring parameters (atsummary)
%         ph: set the operational phase (0, 1 or 2)
%         I: Beam Current [mA] (Default: current per bunch, Nb = 1, but  
%    if Nb is different from 1, input must be total beam current and uniform 
%    fill will be considered)
%         Nb (Optional) = Number of bunches (harmonic number) Default: 1 
%         K  (Optional) = Coupling [decimal] (Default = 0.03); 
% 
% Output - lifetime: struct with each component of lifetime in hours
%          total: value of total lifetime [h]
%
% Notes:
% - lnls_refine_lattice was used setting 5cm as the maximum value for
% elements lenght and then calculations of twiss function for this refined
% lattice were made with atsummary
% - sirius_pressure_profile_2018: check if the pressure profile is the
% newest one
% ========================================================================
% 2012-09-28 Afonso Haruo Carnielli Mukai - Version 1
% 2018-05-25 Murilo Barbosa Alves - Version 2
%=========================================================================
function [lifetime,total] = lnls_lifetime_calc(data_at,ph,I,Nb,K)

%Default Coupling = 3%;
if(~exist('K','var'))
    K = 0.03;
end

%Default: current input as current per bunch
if(~exist('Nb','var'))
    Nb=1;
end

Z = 7;   % Atomic number of equivalent residual gas (N2)
T = 300; % Temperature [K]

%Vacuum chamber model in atsummary takes the IDs vacuum chamber into
%account. In the case of phase 0 operation, it must be modified as follows.
%Obs.: Simulated pressure profile takes into account undulator radiation,
%so using these values of pressure is not appropriate to phase 0 calculations,
%but there was no pressure profile without IDs effects.

if ph==0
lx = getcellstruct(data_at.the_ring,'VChamber',1:length(data_at.the_ring),1,1);
ly = getcellstruct(data_at.the_ring,'VChamber',1:length(data_at.the_ring),1,2);

for j=1:length(lx)
    if lx(j) == 0.004 
      lx(j) = 0.012;
    end
    if ly(j) ~=0.012
    ly(j) = 0.012;
    end
    data_at.the_ring{1,j}.VChamber(1,1) = lx(j);
    data_at.the_ring{1,j}.VChamber(1,2) = ly(j);
 end
    load('accep_refined_phase0.mat');
    ring_input = data_at.the_ring;
    ring_model_accep = ring_model;
if isequal(ring_input,ring_model_accep) == 0;
  error('Input ring model differs from the ring model used to calculate acceptance \n%s','Calculate the acceptances to this input ring model with the function lnls_calc_touschek_accep');
end
else
load('accep_refined.mat');
ring_input = data_at.the_ring;
ring_model_accep = ring_model;
if isequal(ring_input,ring_model_accep) == 0;
  error('Input ring model differs from the ring model used to calculate acceptance \n%s','Calculate the acceptances to this input ring model with the function lnls_calc_touschek_accep');
end
end

%Parameters
E0       = data_at.e0;
mcf      = data_at.compactionFactor;
J_E      = data_at.damping(3);
E_n      = data_at.naturalEmittance;
tau_am   = data_at.radiationDamping;
k        = data_at.harmon;
q        = data_at.overvoltage;

%Twiss
n        = length(data_at.twiss.SPos);
s_B      = data_at.twiss.SPos(1:n-1);
Bx       = data_at.twiss.beta(1:n-1,1);
By       = data_at.twiss.beta(1:n-1,2);

vacc = -1; %Takes the vacuum chamber profile from atsummary
    
% Calcula aceit�ncias
[EA_x,EA_y,theta_x,theta_y,~] = lnls_calcula_aceitancias(data_at.the_ring,s_B,Bx,By,vacc);

%Pressure Profile
%Once lnls_import_pressure_profile calculates the pressure profile, it
%generates a .mat file.
%Qacc = 10000; %Accumulated charge: 10000 - Seeks stationary values
%[s_P,P] = lnls_import_pressure_profile(data_at,'sirius_pressure_profile_2018.txt',Qacc);

load('sirius_pressure_profile_2018.mat');
s_B = unique(s_B);

%Interpolation on the positions where twiss functions were calculated with
%refine lattice (more accurate)
P = interp1(s,P,s_B,'linear');

% Quantum Lifetime
W_q = lnls_lifetime_quantum(tau_am,K,EA_x,EA_y,E_n,E0,mcf,k,q,J_E);
 lifetime.quantum   = (1/W_q) / 3600;

% Elastic Lifetime
[~,W_e] = lnls_lifetime_elastic(Z,T,E0,theta_x,theta_y,s_B,P);
lifetime.elastic   = (1/W_e) / 3600;
    
% Inelastic Lifetime    
[~,W_i] = lnls_lifetime_inelastic(Z,T,P,s_B,Accep);
lifetime.inelastic = (1/W_i)/3600;

% Touschek Lifetime
rate = lnls_lifetime_touschek(data_at,ph,I,Nb,K,Accep);
W_t = rate.AveRate;
lifetime.touschek = (1/W_t) / 3600;

% Total Lifetime
W = W_q + W_e + W_i + W_t;
lifetime.total = (1/W) / 3600;

total = lifetime.total;

