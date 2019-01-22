function first_turns_analysis(ft_data, plt)

mm = 1e3; um = 1e6;

fprintf('============================================================ \n')
fprintf('Horizontal \n')
fprintf('============================================================ \n')
fprintf('Mach. n || MAX FT COD || RMS FT COD || MAX 1st COD || RMS 1st COD || MAX Last COD || RMS Last COD \n')

for j = 1:length(ft_data)
    ft_dataj = ft_data{j, 1};
    orbitx1 = ft_dataj.ftcod.orbit(1, :);
    orbitx2 = ft_dataj.firstcod.orbit(1, :);
    orbitx3 = ft_dataj.finalcod.orbit(1, :);
    max_x1(j) = max(orbitx1) * mm;
    max_x2(j) = max(orbitx2) * mm;
    max_x3(j) = max(orbitx3) * mm;
    rms_x1(j) = ft_dataj.ftcod.rms_x * mm;
    rms_x2(j) = ft_dataj.firstcod.rms_x * mm;
    rms_x3(j) = ft_dataj.finalcod.rms_x * mm;
    fprintf('-- %02d -- || %1.2f mm --|| %1.2f mm -- || -- %1.2f mm -- || -- %1.2f mm -- || -- %1.2f mm -- || -- %1.2f mm --\n', j, max_x1(j), rms_x1(j), max_x2(j), rms_x2(j), max_x3(j), rms_x3(j));   
end

fprintf('============================================================ \n')
fprintf('Vertical \n')
fprintf('============================================================ \n')
fprintf('Mach. n || MAX FT COD || RMS FT COD || MAX 1st COD || RMS 1st COD || MAX Last COD || RMS Last COD \n')

for j = 1:length(ft_data)
    ft_dataj = ft_data{j, 1};
    orbity1 = ft_dataj.ftcod.orbit(3, :);
    orbity2 = ft_dataj.firstcod.orbit(3, :);
    orbity3 = ft_dataj.finalcod.orbit(3, :);
    max_y1(j) = max(orbity1) * mm;
    max_y2(j) = max(orbity2) * mm;
    max_y3(j) = max(orbity3) * mm;
    rms_y1(j) = ft_dataj.ftcod.rms_y * mm;
    rms_y2(j) = ft_dataj.firstcod.rms_y * mm;
    rms_y3(j) = ft_dataj.finalcod.rms_y * mm;
    fprintf('-- %02d -- || %1.2f mm --|| %1.2f mm -- || -- %1.2f mm -- || -- %1.2f mm -- || -- %1.2f mm -- || -- %1.2f mm --\n', j, max_y1(j), rms_y1(j), max_y2(j), rms_y2(j), max_y3(j), rms_y3(j));   
end

fprintf('============================================================ \n')
fprintf('Horizontal BPM \n')
fprintf('============================================================ \n')
fprintf('Mach. n || RMS 1st COD || RMS Last COD \n')

for j = 1:length(ft_data)
    ft_dataj = ft_data{j, 1};
    rms_x_bpm1(j) = std(ft_dataj.firstcod.bpm_pos(1, :)) * mm;
    rms_x_bpm2(j) = std(ft_dataj.finalcod.bpm_pos(1, :)) * mm;
    fprintf('-- %02d --|| %1.2f mm -- || -- %1.2f mm -- \n', j, rms_x_bpm1(j), rms_x_bpm2(j));
end

fprintf('============================================================ \n')
fprintf('Vertical BPM \n')
fprintf('============================================================ \n')
fprintf('Mach. n || RMS 1st COD || RMS Last COD \n')

for j = 1:length(ft_data)
    ft_dataj = ft_data{j, 1};
    rms_y_bpm1(j) = std(ft_dataj.firstcod.bpm_pos(2, :)) * mm;
    rms_y_bpm2(j) = std(ft_dataj.finalcod.bpm_pos(2, :)) * mm;
    fprintf('-- %02d --|| %1.2f mm -- || -- %1.2f mm -- \n', j, rms_y_bpm1(j), rms_y_bpm2(j));
end

% rms_x2m = mean(rms_x2); rms_y2m = mean(rms_y2);
% rms_x3m = mean(rms_x3); rms_y3m = mean(rms_y3);

% rms_x2r = std(rms_x2); rms_y2r = std(rms_y2);
% rms_x3r = std(rms_x3); rms_y3r = std(rms_y3);

for i = 1:length(ft_data{1,1}.firstcod.orbit(1, :))
    for j = 1:length(ft_data)
        orbitx2_stat(j) = ft_data{j}.firstcod.orbit(1, i);
        orbitx3_stat(j) = ft_data{j}.finalcod.orbit(1, i);
        orbity2_stat(j) = ft_data{j}.firstcod.orbit(3, i);
        orbity3_stat(j) = ft_data{j}.finalcod.orbit(3, i);
    end
    orbitx2_rms(i) = nanstd(orbitx2_stat) * mm;
    orbitx3_rms(i) = nanstd(orbitx3_stat) * mm;
    orbity2_rms(i) = nanstd(orbity2_stat) * mm;
    orbity3_rms(i) = nanstd(orbity3_stat) * mm;
end

fprintf('-------------------------------------------------------------\n')
fprintf('MAX + RMS 1st CODx || %1.2f mm || %1.2f mm \n', nanmean(orbitx2_rms), nanstd(orbitx2_rms));
fprintf('MAX + RMS Last CODx || %1.2f mm || %1.2f mm \n', nanmean(orbitx3_rms), nanstd(orbitx3_rms));
fprintf('MAX + RMS 1st CODy || %1.2f mm || %1.2f mm \n', nanmean(orbity2_rms), nanstd(orbity2_rms));
fprintf('MAX + RMS Last CODy || %1.2f mm || %1.2f mm \n', nanmean(orbity3_rms), nanstd(orbity3_rms));

% fprintf('Average CODx || %1.2f mm || %1.2f mm \n', rms_y2m, rms_y3m);
% fprintf('rms CODy || %1.2f mm || %1.2f mm \n', rms_y2r, rms_y3r);

rms_bpm_x1m = mean(rms_x_bpm1); rms_bpm_y1m = mean(rms_y_bpm1);
rms_bpm_x2m = mean(rms_x_bpm2); rms_bpm_y2m = mean(rms_y_bpm2);

rms_bpm_x1r = std(rms_x_bpm1); rms_bpm_y1r = std(rms_y_bpm1);
rms_bpm_x2r = std(rms_x_bpm2); rms_bpm_y2r = std(rms_y_bpm2);


fprintf('-------------------------------------------------------------\n')
fprintf('Average BPMx || %1.2f mm || %1.2f mm \n', rms_bpm_x1m, rms_bpm_x2m);
fprintf('rms BPMx || %1.2f mm || %1.2f mm \n', rms_bpm_x1r, rms_bpm_x2r);

fprintf('Average BPMy || %1.2f mm || %1.2f mm \n', rms_bpm_y1m, rms_bpm_y2m);
fprintf('rms BPMy || %1.2f mm || %1.2f mm \n', rms_bpm_y1r, rms_bpm_y2r);

%{
conc_en = sirius_commis.common.prox_percent(erro_en, gen_en);
conc_en_mean = mean(conc_en);
conc_en_std = std(conc_en);
[conc_en_max, i_max] = max(conc_en);
[conc_en_min, i_min] = min(conc_en);
fprintf('-------------------------------------------------------------\n')
fprintf('Average || %1.2f %% ||    -- -- %1.4f %% -- --      || -- %1.2f %% --\n', mean(gen_en), mean(erro_en), conc_en_mean);
fprintf('RMS     || %1.2f %% ||    -- -- %1.4f %% -- --      || -- %1.2f %% --\n', std(gen_en), std(erro_en), conc_en_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_en_max);
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_en_min);
%}
if strcmp(plt, 'noplot')
return
elseif strcmp(plt, 'plot')
ini=1;
thering0 = ft_data{1,1}.machine;
    idx = findcells(thering0,'FamName','mib');
    if isempty(idx)
        idx = findcells(thering0, 'FamName', 'mqf');
        if isempty(idx)
            idx = findcells(thering0, 'FamName', 'MQF');
        end
        if isempty(idx)
            idx = findcells(thering0, 'FamName', 'mQF');
        end
        fim = idx(2);
    else
        fim = idx(1);
    end
    
    posz= findspos(thering0, ini:fim); 
    % nper = posz(end)/posz(fim);

figure;
hold on;
%{    
 for i = 1:length(ft_data{1, 1}.finalcod.orbit(1, :))
     for j = 1:length(ft_data)
       codx2(j) = ft_data{j}.firstcod.orbit(1, i) * mm;
       codx3(j) = ft_data{j}.finalcod.orbit(1, i) * mm;
       cody2(j) = ft_data{j}.firstcod.orbit(3, i) * mm;
       cody3(j) = ft_data{j}.finalcod.orbit(3, i) * mm;
    end
    codx2m(i) = std(codx2);
    codx3m(i) = std(codx3);
    cody2m(i) = std(cody2);
    cody3m(i) = std(cody3);
end
%}
for ii = 1:length(ft_data{1,1}.firstcod.bpm_pos(1, :))
        for j = 1:length(ft_data)
           bpmx2(j) = ft_data{j}.firstcod.bpm_pos(1, ii) * mm;
           bpmx3(j) = ft_data{j}.finalcod.bpm_pos(1, ii) * mm;
           bpmy2(j) = ft_data{j}.firstcod.bpm_pos(2, ii) * mm;
           bpmy3(j) = ft_data{j}.finalcod.bpm_pos(2, ii) * mm;
        end
        bpmx2m(ii) = std(bpmx2);
        bpmx3m(ii) = std(bpmx3);
        bpmy2m(ii) = std(bpmy2);
        bpmy3m(ii) = std(bpmy3);
end
    
for j = 1:length(ft_data)
    plot(posz, abs(ft_data{j}.firstcod.orbit(1, ini:fim)*mm),'Color', [0.4 0.69 1]);
    % plot(posz, abs(ft_data{j}.finalcod.orbit(1, ini:fim)*mm), '--', 'Color', [0.4 0.69 1]);
    plot(posz, -abs(ft_data{j}.firstcod.orbit(3, ini:fim)*mm), 'Color', [1 0.6 0.6]);
    % plot(posz, -abs(ft_data{j}.finalcod.orbit(3, ini:fim)*mm),'--', 'Color', [1 0.6 0.6]);
end

plot(posz, orbitx2_rms(ini:fim),'LineWidth',3,'Color',[0 0 0.8]);
plot(posz, orbitx3_rms(ini:fim), '--', 'LineWidth',3,'Color',[0 0 0.8]);
plot(posz, -orbity2_rms(ini:fim),'LineWidth',3,'Color',[1 0 0]);
plot(posz, -orbity3_rms(ini:fim),'--', 'LineWidth',3,'Color',[1 0 0]);
legend('1st CODx', 'Last CODx', '1st CODy', 'Last CODy');
grid on

figure;
hold on;

for j = 1:length(ft_data)
    plot(abs(ft_data{j}.firstcod.bpm_pos(1, :)) * mm,'Color', [0.4 0.69 1]);
    plot(abs(ft_data{j}.finalcod.bpm_pos(1, :)) * mm,'Color', [0.4 0.69 0.9]);
    plot(-abs(ft_data{j}.firstcod.bpm_pos(2, :)) * mm, 'Color', [1 0.6 0.6]);
    plot(-abs(ft_data{j}.finalcod.bpm_pos(2, :)) * mm, 'Color', [1 0.6 0.5]);
end


plot(abs(bpmx2m), 'LineWidth', 3,'Color',[0 0 0.8]);
plot(abs(bpmx3m), '--', 'LineWidth', 3,'Color',[0 0 0.8]);
plot(-abs(bpmy2m), 'LineWidth', 3,'Color',[1 0 0]);
plot(-abs(bpmy3m),'--', 'LineWidth', 3,'Color',[1 0 0]);
legend ('1st BPMx', 'Last BPMx', '1st BPMy', 'Last BPMy');
grid on;
end

        %{
        kickx1{j} = ft_dataj.finalcod.kickx;
        kicky1{j} = ft_dataj.finalcod.kicky;    
        kickx2{j} = ft_dataj.firstcod.kickx;
        kicky2{j} = ft_dataj.firstcod.kicky;
        kickx3{j} = ft_dataj.finalcod.kickx;
        kicky3{j} = ft_dataj.finalcod.kicky;
        kickxj = kickx1{j};
        kickx1std(i) = std(kickxj(i));
        plot(kickxj,'Color', [0.4 0.69 1]);
    end
end

plot(std(kickx(i),'LineWidth',3,'Color',[0 0 0.8]);
%}
