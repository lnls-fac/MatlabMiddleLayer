function [spos, accep, nLost, sLost] = tracy3_load_ma_data(pathname)

fname = fullfile(pathname,'momAccept.out');

a = importdata(fname, ' ', 3);

spos  = str2num(char(a.textdata{:,2}))'; 
spos = spos(1:end/2);

accep = str2num(char(a.textdata{:,3}));
len = length(accep)/2;
accep = reshape(accep, len, 2)';

nLost = a.data(:,2);
nLost = reshape(nLost, len, 2)';

sLost = str2num(char(a.textdata{:,4}));
sLost = reshape(sLost, len, 2)';