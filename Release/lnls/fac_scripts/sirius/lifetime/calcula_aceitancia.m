% d_acc = CALCULA_ACEITANCIA(U0,mcf,k,cp,V_rf) calcula a aceitância em
% energia.
%
%   ENTRADA
%       U0      perda de energia por volta por elétron [eV]
%       mcf     fator de compactação de momento
%       k       número harmônico
%       cp      energia [GeV]
%       V_rf    tensão de RF [V]
%   SAÍDA
%       d_acc   acetância em energia relativa


function d_acc = calcula_aceitancia(U0,mcf,k,cp,V_rf)

cp = cp * 1e9; % energia em eV

q = V_rf/U0; % sobrevoltagem

if(q > 1)
    F = 2*(sqrt(q^2-1) - acos(1/q));
    d_acc = sqrt(U0*F/pi/mcf/k/cp);
else
    d_acc = 0;
end