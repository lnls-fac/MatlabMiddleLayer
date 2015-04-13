function lnls1_grff02_set_on
%Coloca o gerador de RF no modo de ajuste.
%
%History: 
%
%2010-09-13: comentários iniciais no código.


setpv('GRFF02_OP',2);
sleep(0.5);
op = getpv('GRFF02_OP');
if op ~= 2
    error('Não foi possível configurar gerador de RF no modo de ajuste!');
end