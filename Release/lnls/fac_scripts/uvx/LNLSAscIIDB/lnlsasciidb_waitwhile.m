function lnlsasciidb_waitwhile(state)

state_now = getappdata(0, 'lnlsasciidb_STATE');
while strcmpi(state_now, state)
    pause(0.1);
    state_now = getappdata(0, 'lnlsasciidb_STATE');
end;