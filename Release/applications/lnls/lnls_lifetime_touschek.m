%lnls_lifetime_touschek(data_at,phase,I,Nb,K): Calculates the Touschek
%lifetime taking into account the variation of emittance due to ID's, i.e.,
%for a given operation phase and also takes into consideration the IBS
%effect in the growth of emittance.
%
%The main reference is: J. Le Duff - "Single and Multiple Touschek effects"
%
%Output:
%    - Result = struct with:
%           Rate     = electron loss rate over the ring  [1/s]
%           AveRate  = average electron loss rate    [1/s]
%           Lifetime = Touschek Life [h]
%           Pos      = Ring positions where the rates were calculated [m]
%           Volume   = Beam volume over the ring [m^3]
%
%Input: 
%    - data_at = struct with ring parameters (atsummary)
%    - phase   = set the operational phase (0, 1 or 2)
%    - I       = Beam Current [mA] (Default: current per bunch, Nb = 1, but  
%    if Nb is different from 1, input must be total beam current and uniform 
%    fill will be considered) ;
%    - Nb (Optional) = Number of bunches (harmonic number) Default: 1 
%    - K  (Optional) = Coupling [decimal] (Default = 0.03); 
%
% WARNING = calculations limits are defined by acceptance initial and final
% points not by twiss function.
%==========================================================================
% May 25, 2018 - Murilo Barbosa Alves
%==========================================================================
function Result = lnls_lifetime_touschek(data_at,phase,I,Nb,K,Accep)

%Default Coupling = 3%;
if(~exist('K','var'))
    K = 0.03;
end

%Default: current input as current per bunch
if(~exist('Nb','var'))
    Nb=1;
end

qe = 1.60217662e-19; % electron charge [C]
r0 = 2.8179403227e-15; % classic electron radius [m]
c  = 2.99792458e8;  % speed of light [m/s]

gamma = data_at.gamma;
T_rev = data_at.revTime;
N = I * T_rev / qe / Nb;
Ib = I/Nb;

%Takes into account the ID's
data_at_ids = lnls_effect_emittance(data_at,phase);

%Takes into account IBS effect
[emit_ibs,~,~,~] = lnls_calc_ibs_bane_cimp(data_at_ids,Ib,K);

emit_x = emit_ibs(1);
emit_y = emit_ibs(2);
sig_E  = emit_ibs(3);
sig_S  = emit_ibs(4);

if length(Accep.pos) == 1
    Accep.pos = Accep.pos(1) * ones(size(Accep.s));
    Accep.neg = Accep.neg(1) * ones(size(Accep.s));
end

s        = data_at.twiss.SPos;
betax    = data_at.twiss.beta(:,1);
betay    = data_at.twiss.beta(:,2);
alphax   = data_at.twiss.alpha(:,1);
alphay   = data_at.twiss.alpha(:,2);
etax     = data_at.twiss.Dispersion(:,1);
etaxl    = data_at.twiss.Dispersion(:,2);

[s,r]    = unique(s);
betax    = betax(r);
betay    = betay(r);
alphax   = alphax(r);
alphay   = alphay(r);
etax     = etax(r);
etaxl    = etaxl(r);

%Guarantees that acceptance and twiss are calculate at same positions
d_accp   = interp1(Accep.s, Accep.pos, s);
d_accn   = interp1(Accep.s,-Accep.neg, s);

%Bunch Volume
Sigxbeta2 = betax.*emit_x;
V = sig_S * sqrt(Sigxbeta2 + etax.^2*sig_E^2).*sqrt(betay*emit_y);

%Inputs of function D of Touschek lifetime
Hx = betax.*etaxl + alphax.*etax;
A1 = 1/(4*sig_E^2) + (etax.^2 + Hx.^2)./(4*Sigxbeta2);
B1 = betax.*Hx./(2*Sigxbeta2);
C1 = betax.^2./(4*Sigxbeta2) - B1.^2./(4*A1);
ksip = (2.*sqrt(C1)./gamma .* d_accp).^2;
ksin = (2.*sqrt(C1)./gamma .* d_accn).^2;

%Interpolation of function D
load('func_d_touschek.mat');
Dp = interp1(range(1,:),dtouschek(1,:),ksip,'linear','extrap');
Dn = interp1(range(1,:),dtouschek(1,:),ksin,'linear','extrap');

%Inverse of Touschek Lifetime
Ratep = (r0^2*c/8/pi)*N/gamma^2 ./ d_accp.^3 .* Dp ./ V;
Raten = (r0^2*c/8/pi)*N/gamma^2 ./ d_accn.^3 .* Dn ./ V;
Result.Rate = (Ratep + Raten) / 2;

%Average over the ring
Result.AveRate = trapz(s, Result.Rate) / ( s(end) - s(1) );
Result.Lifetime = 1/Result.AveRate/3600; %Lifetime in hours
Result.Volume = V;
Result.Pos = s;
