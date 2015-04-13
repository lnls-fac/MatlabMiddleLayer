%   Wm = tau_quantico_inverso(tau_am,K,EA_x,EA_y,E_n,T_rev,cp,mcf,Nb,V,U0)
%   calcula Wm = 1/tau, onde tau é o tempo de vida quântico, em segundos.
%
%   As entradas são um vetor tau_am com os tempos de amortecimento x, z e E
%   [s], o fator de acoplamento K, as aceitâncias horizontal EA_x e
%   vertical EA_y [mm mrad], a emitância natural E_nat [m rad], o período
%   de revolução T_rev [s], a energia cp [GeV], o fator de compactação de
%   momento mcf, o número harmônico k, a tensão de RF V [V] e a perda de
%   energia por radiação por volta U0 (eV);

function Wm = tau_quantico_inverso(tau_am,K,EA_x,EA_y,E_n,T_rev,cp,mcf, ...
                                   k,V,U0)

tau_x = tau_am(1);
tau_y = tau_am(2);
tau_E = tau_am(3);

ksi_x = 1e-6*(1+K)*EA_x / (2*E_n);
tau_q_x = tau_x * exp(ksi_x) / (2*ksi_x);

ksi_y = 1e-6*(1+K)*EA_y / (2*K*E_n);
tau_q_y = tau_y * exp(ksi_y) / (2*ksi_y);

q = V / U0;
if(q >= 1)
    F_q = 2*(sqrt(q^2-1) - acos(1/q));
    E1 = 1.08e+8;
    J_E = 2e9*cp*T_rev/(tau_E*U0);
    ksi_E = J_E*1e9*cp/(mcf*k*E1) * F_q;
    tau_q_E = tau_E * exp(ksi_E) / (2*ksi_E);
else
    tau_q_E = 0;
end

Wm = 1/tau_q_x + 1/tau_q_y + 1/tau_q_E;