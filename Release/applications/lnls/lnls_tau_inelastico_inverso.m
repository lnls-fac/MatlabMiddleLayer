%   [W,Wm] = LNLS_TAU_INELASTICO_INVERSO(Z,T,cp,R,EA_x,EA_y,r,P,Bx,By)
%   calcula 1/tau, onde tau é o tempo de vida inelástico, em segundos. W é
%   um vetor contendo os valores de tempo de vida ao longo do vetor posição
%   r, enquanto Wm é o valor médio de W nesse trecho.
%
%   Cálculo de tempo de vida por espalhamento elástico baseado em Beam
%   losses and lifetime - A. Piwinski, em CERN 85-19.
%
%   As entradas são a aceitância em energia d_acc (fração), um vetor
%   posição (r), em m, com os valores de pressão (P) ao longo desse vetor
%   (r e P devem ter as mesmas dimensões. Para aceitância nula, negativa ou
%   complexa, o tempo de vida calculado é nulo.

function [W,Wm] = lnls_tau_inelastico_inverso(Z,T,d_acc,r,P)

if(isreal(d_acc) && d_acc>0)
    W = 1346 * log(183/Z^(1/3)) * ( log(1/d_acc) - 0.625 + d_acc ) * Z^2/T * P;
    Wm = trapz(r,W) / ( r(length(r)) - r(1) );
else
    W = Inf(length(r),1);
    Wm = Inf;
end