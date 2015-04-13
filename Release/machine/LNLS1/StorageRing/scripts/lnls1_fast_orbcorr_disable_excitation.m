function lnls1_fast_orbcorr_disable_excitation
%Deshabilita excitacao das corretoras pelo OPER1
%
%History: 
%
%2015-03-11: comentários iniciais no código.

if strcmpi(getmode('BEND'), 'online')
    msg.AFOFB_CR_ON = 0;
    lnls1_comm_write(msg);
else
    fprintf('lnls1_fast_orbcorr_disable_excitation: simulation mode!\n');
end
