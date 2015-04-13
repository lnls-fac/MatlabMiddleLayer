function [G F] = lnls1_booster_delay2GF(delay)
%Retorna ajustes de atraso fino e grosso de atraso geral do sistema de injeção.
%
%Retorna ajuste de atraso grosso G e fino F, em nanosegundos, que correspondem a
%ajuste de atraso total 'delay' (nanosegundos).
%
%History: 
%
%2010-09-13: comentários iniciais no código.

G_bin_size = 50; % nanoseconds

G = G_bin_size .* floor(delay ./ G_bin_size);
F = rem(delay, G_bin_size);

