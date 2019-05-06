function kick_fit = fit_kick_corrector(ring, corr_num, plane)

len = length(ring);
ring = shift_ring(ring, 'InjSept');
fam = sirius_bo_family_data(ring);
% ring = lnls_correct_tunes(ring, [19.204, 7.314 + 0.3], {'QF','QD'}, 'svd', 'add', 10, 1e-9);
cod = findorbit(ring, 0, 1:len+1);
um = 1e-6;
kick = 100e-6;

if strcmp(plane, 'x')
    ring_kick = lnls_set_kickangle(ring, kick, fam.CH.ATIndex(corr_num), plane);
elseif strcmp(plane, 'y')
    ring_kick = lnls_set_kickangle(ring, kick, fam.CV.ATIndex(corr_num), plane);
end

% ring_kick = lnls_set_kickangle(ring_kick, kick, fam.CH.ATIndex(1), 'y');
    
cod_kick = findorbit(ring_kick, 0, 1:len+1);

dif_cod = (cod - cod_kick)./ um ;

[file, path] = uigetfile('*.txt', '*.dat', '/home/murilo/Desktop/screens-iocs/');
fileid = fopen(strcat(path, file));
data = textscan(fileid, '%f %f', 'delimiter', '', 'HeaderLines', 2);
dif_orbx = data{1}; dif_orby = data{2};

% scalex = max(dif_cod(1, fam.BPM.ATIndex)) / max(dif_orbx);
% scaley = max(dif_cod(3, fam.BPM.ATIndex)) / max(dif_orby);

if strcmp(plane, 'x')
    ratio_x = squeeze(dif_cod(1, fam.BPM.ATIndex))' ./ dif_orbx;
    signal = sign(mean(ratio_x));
    scalex = signal * rms(dif_cod(1, fam.BPM.ATIndex)) / rms(dif_orbx);
    kickx_fit = kick/scalex;

    figure; 
    plot(dif_orbx, '--o', 'LineWidth', 2);
    hold on;
    plot(dif_cod(1, fam.BPM.ATIndex) ./ scalex, '-o', 'LineWidth', 2);
    legend('Measurement', 'Model');
    strx = {strcat('Horizontal - Fitted Kick =', num2str(kickx_fit * 1e6), 'urad')};
    title(strx{1})
    xlabel('BPM Index')
    ylabel('COD Diff [um]')

    kick_fit = kickx_fit;
end

if strcmp(plane, 'y')
    ratio_y = squeeze(dif_cod(3, fam.BPM.ATIndex))' ./ dif_orby;
    signal = sign(mean(ratio_y));
    scaley = signal * rms(dif_cod(3, fam.BPM.ATIndex)) / rms(dif_orby);
    
    kicky_fit = kick / scaley;

    figure; 
    plot(dif_orby, '--o', 'LineWidth', 2);
    hold on;
    plot(dif_cod(3, fam.BPM.ATIndex) ./ scaley, '-o', 'LineWidth', 2);
    legend('Measurement', 'Model');
    stry = {strcat('Vertical - Fitted Kick = ', num2str(kicky_fit * 1e6), 'urad')};
    title(stry{1})
    xlabel('BPM Index')
    ylabel('COD Diff [um]')
    
    kick_fit = kicky_fit;
end
end