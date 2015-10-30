function [spos, pya, nLost, eLost] = trackcpp_load_pya_data(pathname)

fname = fullfile(pathname,'dynap_pya_out.txt');

a = importdata(fname, ' ', 13);

spos  = a.data(:,5)'; 
pya   = a.data(:,10)';
nLost = a.data(:,2)';
eLost = a.data(:,3)';
