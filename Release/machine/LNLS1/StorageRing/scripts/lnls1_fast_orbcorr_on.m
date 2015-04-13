function lnls1_fast_orbcorr_on
%Liga correção automática de órbita no OPR1
%
%History: 
%
%2010-09-13: comentários iniciais no código.

if strcmpi(getmode('BEND'), 'online')
    msg.AFOFB_MODO_SP = 2;
    lnls1_comm_write(msg);
else
    fprintf('lnls1_fast_orbcorr_on: simulation mode!\n');
end
