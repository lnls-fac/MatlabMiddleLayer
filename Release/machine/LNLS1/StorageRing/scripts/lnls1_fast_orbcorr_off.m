function lnls1_fast_orbcorr_off
%Desliga correção automática rápida de órbita no OPR1
%
%History: 
% 
%2015-03-11: comentários iniciais no código.

if strcmpi(getmode('BEND'), 'online')
    msg.AFOFB_MODO_SP = 1;
    lnls1_comm_write(msg);
else
    fprintf('lnls1_fast_orbcorr_off: simulation mode!\n');
end
