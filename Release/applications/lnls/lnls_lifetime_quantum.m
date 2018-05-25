% Wm = lnls_lifetime_quantum(tau_am,K,EA_x,EA_y,E_n,cp,mcf,Nb,V,U0):
% calculates the loss rate due to quantum effects, which its inverse is the
% quantum lifetime
% 
% Input: tau_am  damping times x, z e E [s]
%        K       coupling factor
%        EA_x    horizontal acceptance [mm mrad]
%        EA_y    vertical acceptance[mm mrad]
%        E_n     natural emittance [m rad]
%        E0      nominal energy [GeV]
%        mcf     momentum coupling factor
%        k       harmonic number
%        q       overvoltage
%        J_E     damping partition number of energy
% 
% Output: Wm     average loss rate due to quantum effects [1/s]
%==========================================================================
%Version 1 - Unknown source
%25 May, 2018 - Murilo Barbosa Alves - Version 2
%==========================================================================
function Wm = lnls_lifetime_quantum(tau_am,K,EA_x,EA_y,E_n,E0,mcf,k,q,J_E)

tau_x = tau_am(1);
tau_y = tau_am(2);
tau_E = tau_am(3);

ksi_x = 1e-6*(1+K)*EA_x / (2*E_n);
tau_q_x = tau_x * exp(ksi_x) / (2*ksi_x);

ksi_y = 1e-6*(1+K)*EA_y / (2*K*E_n);
tau_q_y = tau_y * exp(ksi_y) / (2*ksi_y);

if(q >= 1)
    F_q = 2*(sqrt(q^2-1) - acos(1/q));
    E1 = 1.08e+8;
    ksi_E = J_E*1e9*E0/(mcf*k*E1) * F_q;
    tau_q_E = tau_E * exp(ksi_E) / (2*ksi_E);
else
    tau_q_E = 0;
end

Wm = 1/tau_q_x + 1/tau_q_y + 1/tau_q_E;