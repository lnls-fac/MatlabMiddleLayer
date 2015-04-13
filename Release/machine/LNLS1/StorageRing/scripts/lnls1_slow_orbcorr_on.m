function lnls1_slow_orbcorr_on
%Liga correção automática de órbita no OPR1
%
%History: 
%
%2010-09-13: comentários iniciais no código.

if strcmpi(getmode('BEND'), 'online')
    msg.AORBCOR_ON = 1;
    lnls1_comm_write(msg);
else
    fprintf('lnls1_slow_orbcorr_on: simulation mode!\n');
end
