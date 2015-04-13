function lnls_update_waitbar(P)

mywaitbar = getappdata(0, 'MYWAITBAR');
mywaitbar.P = P;
setappdata(0, 'MYWAITBAR', mywaitbar);
if P == mywaitbar.nr_points;
    lnls_delete_waitbar
end
drawnow;




