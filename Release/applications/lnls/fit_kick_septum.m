function [kickx_fit, kicky_fit] = fit_kick_septum(ring, plane)

len = length(ring);
ring = shift_ring(ring, 'InjSept');
fam = sirius_bo_family_data(ring);
% ring = lnls_correct_tunes(ring, [19.204, 7.314], {'QF','QD'}, 'svd', 'add', 10, 1e-9);
cod = findorbit(ring, 0, 1:len+1);
um = 1e-6;
kick = 100e-6;

ring_kick_sept = ring;
local = len;
ring_kick_sept{local} = ring{fam.CH.ATIndex(1)};
ring_kick_sept{local}.Length = ring{local}.Length;

if strcmp(plane, 'xy')
    ring_kick_sept = lnls_set_kickangle(ring_kick_sept, kick, local, 'x');
    ring_kick_sept = lnls_set_kickangle(ring_kick_sept, kick, local, 'y');
else
    ring_kick_sept = lnls_set_kickangle(ring_kick_sept, kick, local, plane);
end
    
cod_kick = findorbit(ring_kick_sept, 0, 1:len+1);

dif_cod = (cod - cod_kick)./ um ;

[file, path] = uigetfile('*.txt', '*.dat', '/home/murilo/Desktop/screens-iocs/');
fileid = fopen(strcat(path, file));
data = textscan(fileid, '%f %f', 'delimiter', '', 'HeaderLines', 2);
dif_orbx = data{1}; dif_orby = data{2};

scalex = rms(dif_cod(1, fam.BPM.ATIndex)) / rms(dif_orbx);
scaley = rms(dif_cod(3, fam.BPM.ATIndex)) / rms(dif_orby);

% scalex = max(dif_cod(1, fam.BPM.ATIndex)) / max(dif_orbx);
% scaley = max(dif_cod(3, fam.BPM.ATIndex)) / max(dif_orby);

kickx_fit = kick/scalex;
kicky_fit = kick/scaley;

figure; 
plot(dif_orbx, '--o', 'LineWidth', 2);
hold on;
plot(dif_cod(1, fam.BPM.ATIndex) ./ scalex, '-o', 'LineWidth', 2);
legend('Measurement', 'Model');
strx = {strcat('Horizontal - Fitted Kick =', num2str(kickx_fit * 1e6), 'urad')};
title(strx{1})
xlabel('BPM Index')
ylabel('COD Diff [um]')

figure; 
plot(dif_orby, '--o', 'LineWidth', 2);
hold on;
plot(dif_cod(3, fam.BPM.ATIndex) ./ scaley, '-o', 'LineWidth', 2);
legend('Measurement', 'Model');
stry = {strcat('Vertical - Fitted Kick = ', num2str(kicky_fit * 1e6), 'urad')};
title(stry{1})
xlabel('BPM Index')
ylabel('COD Diff [um]')

end