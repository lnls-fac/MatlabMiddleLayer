%lnls_inelastic_lifetime: calculates the rate due to inelastic scattering
%of electrons with nuclei of residual gas in vacuum chamber
%
%Reference: H. Wiedemann - "Particle Accelerator Physics" - Third Edition
%Section 8.8.1 - Beam Lifetime and Vacuum (Inelastic Scattering)
%
%Input:   r: position where the twiss parameters were calculated [m]
%         Accep: struct with ring position and values of positive and negative
%         energy acceptance 
%         Obs: gas atomic number Z and temperature T are needed depending 
%         on the model used, but requires changes in some code lines

%Output:  W:  vector with inelastic loss rate for each position of ring
%         Wm: average loss rate due to inelastic scattering over the ring
%==========================================================================
%May 24, 2018 - Murilo Barbosa Alves
%==========================================================================
function [W,Wm] = lnls_lifetime_inelastic(Z,T,P,r,Accep)

[Accep.s, perm] = unique(Accep.s,'first');
Accep.pos = Accep.pos(perm);
Accep.neg = Accep.neg(perm);
r = unique(r);
d_accp  = interp1(Accep.s, Accep.pos, r,'linear','extrap');
d_accn  = interp1(Accep.s,-Accep.neg, r,'linear','extrap');

%Constants
%r0 = 2.8179403227e-15; % classic electron radius [m]
%c  = 2.99792458e8;  % speed of light [m/s]
%Kb = 1.3806505e-23; %Boltzmann Constant [J/K]
%alpha_fine = 0.0072973525664;

%Approximated result Eq. (8.129) from Particle Accelerator
%Physics- Third Edition)

Conv = 7.500616828e8; %[nTorr -> mbar]

Wp = Conv*0.00653.*log(1./d_accp).*P;
Wn = Conv*0.00653.*log(1./d_accn).*P;

W = (Wp+Wn)/2;

Wm =trapz(r,W)/(r(end)-r(1))/3600;

%Intermediate approximation, Eq. (8.125) from Particle Accelerator
%Physics- Third Edition
%{
phi = r0^2*Z^2*alpha_fine;

L = 1/(phi*(4*log(183/(Z^(1/3)) + 2/9)));


Wp = -400/3*c/L/T/Kb.*P.*log(d_accp);
Wn = -400/3*c/L/T/Kb.*P.*log(d_accn); 

W = (Wp+Wn)/2;

Wm = trapz(r,W)/(r(end)-r(1));
%}

%No approximations made, result derived from Eq. (8.122) from Particle Accelerator
%Physics- Third Edition
%{
Fp = (4/3.*(log(1./d_accp)+ d_accp - 5/8)+1/2.*(d_accp).^2).*log(183/Z^(1/3)) + 1/9.*(log(1./d_accp) + d_accp -1);
Fn = (4/3.*(log(1./d_accn)+ d_accn - 5/8)+1/2.*(d_accn).^2).*log(183/Z^(1/3)) + 1/9.*(log(1./d_accn) + d_accn -1);

%Fp = 4/3.*(log(1./d_accp)).*log(183/Z^(1/3));
%Fn = 4/3.*(log(1./d_accn)).*log(183/Z^(1/3));

Const = 2*4*r0^2*c*alpha_fine/Kb;
Const = Const*100; %Pascal -> mbar

Wp = (Const*Z^2/T).*P.*Fp;
Wn = (Const*Z^2/T).*P.*Fn;
W = (Wp+Wn)/2;

Wm = trapz(r,W)/(r(end)-r(1));
%}

%Results derived from A. Piwinski "Beam-losses and lifetime" without
%approximations

%{
Wp = 16*r0^2*Z^2*c/(3*137*Kb*T)*100* log(183/Z^(1/3)) .* ( log(1./d_accp) ) .* P;
Wn = 16*r0^2*Z^2*c/(3*137*Kb*T)*100* log(183/Z^(1/3)) .* ( log(1./d_accn) ) .* P;

W = (Wp+Wn)/2; 
Wm = trapz(r,W) / ( r(end) - r(1) );
%}
end

