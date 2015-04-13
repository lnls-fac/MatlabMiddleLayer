function lnls_delete_waitbar
try
    mywaitbar = getappdata(0, 'MYWAITBAR');
    stop(mywaitbar.TH);
    close(mywaitbar.WH);
    delete(mywaitbar.TH);
    rmappdata(0, 'MYWAITBAR');
catch
end

