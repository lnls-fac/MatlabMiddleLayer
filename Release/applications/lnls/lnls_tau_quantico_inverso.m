%   Wm = LNLS_TAU_QUANTICO_INVERSO(tau_am,K,EA_x,EA_y,E_n,cp,mcf,Nb,V,U0)
%   calcula o recíproco do tempo de vida quântico.
%
%   ENTRADA
%       tau_am  tempos de amortecimento x, z e E [s]
%       K       fator de acoplamento
%       EA_x    aceitância horizontal [mm mrad]
%       EA_y    aceitância horizontal [mm mrad]
%       E_n     emitância natural [m rad]
%       cp      energia [GeV]
%       mcf     fator de compactação de momento
%       k       número harmônico
%       q       sobrevoltagem
%       J_E     damping partition number da energia
%   SAÍDA
%       Wm      recíproco do tempo de vida quântico [1/s]

function Wm = lnls_tau_quantico_inverso(tau_am,K,EA_x,EA_y,E_n,cp,mcf,k,q,J_E)

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
    ksi_E = J_E*1e9*cp/(mcf*k*E1) * F_q;
    tau_q_E = tau_E * exp(ksi_E) / (2*ksi_E);
else
    tau_q_E = 0;
end

Wm = 1/tau_q_x + 1/tau_q_y + 1/tau_q_E;