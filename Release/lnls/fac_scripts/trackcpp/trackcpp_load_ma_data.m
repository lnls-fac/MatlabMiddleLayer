function [spos, accep, nLost, eLost] = trackcpp_load_ma_data(pathname)

fname = fullfile(pathname,'dynap_ma_out.txt');

a = importdata(fname, ' ', 13);

spos  = a.data(1:2:end,5)'; 

accep(1,:) = a.data(2:2:end,8)';
accep(2,:) = a.data(1:2:end,8)';

nLost(1,:) = a.data(2:2:end,2)';
nLost(2,:) = a.data(1:2:end,2)';

eLost(1,:) = a.data(2:2:end,3)';
eLost(2,:) = a.data(1:2:end,3)';
