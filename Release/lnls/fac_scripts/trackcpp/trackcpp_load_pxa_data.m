function [spos, pxa, nLost, eLost] = trackcpp_load_pxa_data(pathname)

fname = fullfile(pathname,'dynap_pxa_out.txt');

a = importdata(fname, ' ', 13);

spos  = a.data(:,5)'; 
pxa   = a.data(:,9)';
nLost = a.data(:,2)';
eLost = a.data(:,3)';
