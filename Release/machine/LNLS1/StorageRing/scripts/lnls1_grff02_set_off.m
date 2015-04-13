function lnls1_grff02_set_off
%Coloca o gerador de RF no modo de leitura.
%
%History: 
%
%2010-09-13: comentários iniciais no código.

setpv('GRFF02_OP',1);
sleep(0.5);
op = getpv('GRFF02_OP');
if op ~= 1
    error('Não foi possível configurar gerador de RF no modo de leitura!');
end