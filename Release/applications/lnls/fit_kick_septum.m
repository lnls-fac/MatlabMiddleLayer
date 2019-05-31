function [kickx_fit, kicky_fit] = fit_kick_septum(ring, plane, plt, cmp)

len = length(ring);
ring = shift_ring(ring, 'InjSept');
fam = sirius_bo_family_data(ring);
% ring = lnls_correct_tunes(ring, [19.204, 7.314], {'QF','QD'}, 'svd', 'add', 10, 1e-9);
cod = findorbit(ring, 0, 1:len+1);
mm = 1e-3;
kick = 100e-6;

if ~exist('plt', 'var')
    flag_plot = false;
elseif strcmp(plt, 'plot')
    flag_plot = true;
elseif strcmp(plt, 'noplot')
    flag_plot = false;
else
    error('Set flag plot or noplot');
end

if ~exist('cmp', 'var')
    flag_cmp = false;
elseif strcmp(cmp, 'compare')
    flag_cmp = true;
end

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

dif_cod = (cod - cod_kick)./ mm ;

[file1, path1] = uigetfile('*.txt', '*.dat', '/home/murilo/Desktop/screens-iocs/');
fileid1 = fopen(strcat(path1, file1));
data1 = textscan(fileid1, '%f %f', 'delimiter', '', 'HeaderLines', 2);
dif_orbx1 = data1{1} * mm; dif_orby1 = data1{2} * mm;

if flag_cmp
    [file2, path2] = uigetfile('*.txt', '*.dat', '/home/murilo/Desktop/screens-iocs/');
    fileid2 = fopen(strcat(path2, file2));
    data2 = textscan(fileid2, '%f %f', 'delimiter', '', 'HeaderLines', 2);
    dif_orbx2 = data2{1} * mm; dif_orby2 = data2{2} * mm;

    dif_orbx12 = dif_orbx2 - dif_orbx1;
    dif_orby12 = dif_orby2 - dif_orby1;
    
    Ax = dot(dif_cod(1, fam.BPM.ATIndex)', dif_orbx12);
    Bx = dot(dif_cod(1, fam.BPM.ATIndex)', dif_cod(1, fam.BPM.ATIndex)');
    scalex = Ax/Bx;
    
    Ay = dot(dif_cod(3, fam.BPM.ATIndex)', dif_orby12);
    By = dot(dif_cod(3, fam.BPM.ATIndex)', dif_cod(3, fam.BPM.ATIndex)');
    scaley = Ay/By;
    
    kickx_fit = kick * scalex;
    kicky_fit = kick * scaley;

    
    if flag_plot
        figure; 
        plot(dif_orbx1, '--o', 'LineWidth', 2);
        hold on;
        plot(dif_orbx2, '--o', 'LineWidth', 2);
        legend('Ontem', 'Hoje');
        strx = {strcat('Horizontal - Change in Kick =', num2str(kickx_fit * 1e6), 'urad')};
        title(strx{1})
        xlabel('BPM Index')
        ylabel('Dif Orbit [mm]');

        figure;
        plot(dif_orby1, '--o', 'LineWidth', 2);
        hold on;
        plot(dif_orby2, '--o', 'LineWidth', 2);
        legend('Ontem', 'Hoje');
        stry = {strcat('Vertical - Change in Kick =', num2str(kicky_fit * 1e6), 'urad')};
        title(stry{1})
        xlabel('BPM Index')
        ylabel('Dif Orbit [mm]');
    end
else
    Ax = dot(dif_cod(1, fam.BPM.ATIndex)', dif_orbx1);
    Bx = dot(dif_cod(1, fam.BPM.ATIndex), dif_cod(1, fam.BPM.ATIndex));
    scalex = Ax/Bx;
    
    Ay = dot(dif_cod(3, fam.BPM.ATIndex)', dif_orby1);
    By = dot(dif_cod(3, fam.BPM.ATIndex), dif_cod(3, fam.BPM.ATIndex));
    scaley = Ay/By;
    
    kickx_fit = kick * scalex;
    kicky_fit = kick * scaley;

    if flag_plot
        figure; 
        plot(dif_orbx1, '--o', 'LineWidth', 2);
        hold on;
        plot(dif_cod(1, fam.BPM.ATIndex) .* scalex, '-o', 'LineWidth', 2);
        legend('Measurement', 'Model');
        strx = {strcat('Horizontal - Fitted Kick =', num2str(kickx_fit * 1e6), 'urad')};
        title(strx{1})
        xlabel('BPM Index')
        ylabel('COD Diff [mm]')

        figure; 
        plot(dif_orby1, '--o', 'LineWidth', 2);
        hold on;
        plot(dif_cod(3, fam.BPM.ATIndex) .* scaley, '-o', 'LineWidth', 2);
        legend('Measurement', 'Model');
        stry = {strcat('Vertical - Fitted Kick = ', num2str(kicky_fit * 1e6), 'urad')};
        title(stry{1})
        xlabel('BPM Index')
        ylabel('COD Diff [mm]')
    end
end