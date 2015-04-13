function r = lnlsasciidb_get_datenum(datevec)

r = datenum(datevec(:,1:6)) + datevec(:,7)/(24*60*60*1000);