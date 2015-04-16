function disporbit = fadisporbit(fadata, npts_level)

Hd = c2d(tf([0.5e-3 1],[0.05e-3 1]), double(fadata.period)*1e-6);
Hd = dfilt.df1(Hd.num{1}, Hd.den{1});

steps = filter(Hd,fadata.bpm_readings);
steps = sum(abs(steps),2);
steps(1:20) = 0;
[~, idxo] = max(steps);

orb1 = mean(fadata.bpm_readings(idxo+(-npts_level+1:0),:));
orb2 = mean(fadata.bpm_readings(idxo+50+(0:npts_level-1),:));

disporbit = orb2-orb1;
