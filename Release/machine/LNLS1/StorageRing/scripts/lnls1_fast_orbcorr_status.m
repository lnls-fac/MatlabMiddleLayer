function lnls1_fast_orbcorr_status
%History: 
%
%2015-09-17

status_fofb = getpvonline('AFOFB_MODO_AM');
if status_fofb == 2
    fprintf('The fast orbit correction is on!\n');
elseif status_fofb == 1
    fprintf('The fast orbit correction is off!\n');
else
    fprintf('PV AFOFB_MODO_AM not found!\n');
end

end
