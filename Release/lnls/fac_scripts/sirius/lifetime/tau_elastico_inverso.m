%   [W,Wm] = tau_elastico_inverso(Z,T,cp,R,EA_x,EA_y,r,P,Bx,By) calcula
%   1/tau, onde tau é o tempo de vida elástico, em segundos. W é um vetor
%   contendo os valores de tempo de vida ao longo do vetor posição r,
%   enquanto Wm é o valor médio de W nesse trecho.
%
%   As entradas são o número atômico do gás residual (Z), a temperatura (T)
%   em K, a energia (cp) em GeV, a razão entre as dimensões vertical e
%   horizontal da abertura (R = theta_y / theta_x), as aceitâncias
%   horizontal (EA_x) e vertical (EA_y) em (mm mrad), um vetor posição (r),
%   em m, com os valores de pressão (P) em mbar, betax (Bx) e betay (By) em
%   m ao longo desse vetor (r, P, Bx e By devem ter as mesmas dimensões).

function [W,Wm] = tau_elastico_inverso(Z,T,cp,R,EA_x,EA_y,r,P,Bx,By)

F1 = 2*atan(R) + sin(2*atan(R));
F2 = pi - 2*atan(R) + sin(2*atan(R));

W = 18009*Z^2/(T*cp^2) * (F1*P.*Bx/EA_x + F2*P.*By/EA_y);

Wm = trapz(r,W) / ( r(length(r)) - r(1) );