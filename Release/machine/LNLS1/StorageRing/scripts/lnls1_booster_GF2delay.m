function delay = lnls1_booster_GF2delay(G,F)
%Retorna ajuste total de atraso do sistema de injeção.
%
%Retorna ajuste de atraso total (nanosegundos) calculados do ajuste grosso
%
%History: 
%
%2010-09-13: comentários iniciais no código.


delay = G + F;