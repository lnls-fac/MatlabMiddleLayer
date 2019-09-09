function conf_machines(param, param_errors)
% Prints a table with comparison between values of systematic errors found
% by the algorithm of injection adjustment with screens and the systematic
% errors introduced in the random machines. It also calculates the rms of
% horizontal and vertical closed orbits (if it exists) for each machine.
% Finally it plots a figure with these data.
%
% Version 1 - Murilo B. Alves - October 4th, 2018

zero = zeros(length(param), 1);
erro_en = zero;
gen_en = zero;
gen_x = zero;
gen_y = zero;
gen_xl = zero;
gen_yl = zero;
agree = zero;
gen_kckr = zero;
xl_inicial = zero;
kckr_inicial = zero;
erro_xl = zero;
erro_kckr = zero;
diffx = zero;
diffy = zero;

% gen_en = repmat(gen_en, 1, length(param));
% gen_x = repmat(gen_x, 1, length(param));
% gen_y = repmat(gen_y, 1, length(param));
% gen_xl = repmat(gen_xl, 1, length(param));
% gen_yl = repmat(gen_yl, 1, length(param));
% gen_kckr = repmat(gen_kckr, 1, length(param));

fprintf('============================================================ \n')
fprintf('Energy \n')
fprintf('============================================================ \n')
fprintf('Mach. n ||GEN. ERROR || SCRIPT FOUND ||  AGREEMENT \n')

for j = 1:length(param)
    erro_en(j) = param{j}.delta_ave*100;
    gen_en(j) = param_errors{j}.delta_error_sist*100;
    gen_x(j) = param_errors{j}.x_error_sist;
    gen_y(j) = param_errors{j}.y_error_sist;
    gen_xl(j) = param_errors{j}.xl_error_sist;
    gen_yl(j) = param_errors{j}.yl_error_sist;
    gen_kckr(j) = param_errors{j}.kckr_error_sist;
    agree(j) = sirius_commis.common.prox_percent(erro_en(j), gen_en(j));
    fprintf('-- %02d --|| %1.2f %% -- || -- %1.2f %% -- || -- %1.2f %% --\n', j, gen_en(j), erro_en(j), agree(j));
end

conc_en = sirius_commis.common.prox_percent(erro_en, gen_en);
conc_en_mean = nanmean(conc_en);
conc_en_std = nanstd(conc_en);
[~, i_max] = min(abs(conc_en - 100));
[~, i_min] = max(abs(conc_en - 100));
fprintf('-------------------------------------------------------------\n')
fprintf('Average || %1.2f %% ||    -- -- %1.4f %% -- --      || -- %1.2f %% --\n', mean(gen_en), mean(erro_en(erro_en ~= 0)), conc_en_mean);
fprintf('RMS     || %1.2f %% ||    -- -- %1.4f %% -- --      || -- %1.2f %% --\n', std(gen_en), std(erro_en(erro_en ~= 0)), conc_en_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_en(i_max));
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_en(i_min));


fprintf('============================================================ \n')
fprintf('Injection position X \n')
fprintf('=========================================================== \n')
fprintf('Mach. n ||  GEN. ERROR  ||   SCRIPT FOUND  ||  AGREEMENT \n')

for j = 1:length(param)
    x_inicial(j) = param{j}.x_sept_init;
    erro_x(j) = abs(x_inicial(j) - param{j}.offset_x_sist); 
    fprintf('-- %02d --|| %1.2f mm -- || -- %1.2f mm -- || -- %1.2f %% --\n', j, gen_x(j)*1e3, erro_x(j)*1e3, sirius_commis.common.prox_percent(erro_x(j), gen_x(j)));
end

conc_x = sirius_commis.common.prox_percent(erro_x', gen_x);
conc_x_mean = mean(conc_x);
conc_x_std = std(conc_x);
[~, i_max] = min(abs(conc_x - 100));
[~, i_min] = max(abs(conc_x - 100));
fprintf('-------------------------------------------------------------\n')
fprintf('Average ||%1.2f mrad||    -- -- %1.4f mrad -- --    || -- %1.2f %% --\n', mean(gen_x)*1e3, mean(erro_x)*1e3, conc_x_mean);
fprintf('RMS     || %1.2fmrad||   -- -- %1.4fmrad-- --      || -- %1.2f %% --\n', std(gen_x)*1e3, std(erro_x)*1e3, conc_x_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_x(i_max));
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_x(i_min));

fprintf('============================================================ \n')
fprintf('Injection angle X \n')
fprintf('=========================================================== \n')
fprintf('Mach. n ||  GEN. ERROR  ||   SCRIPT FOUND  ||  AGREEMENT \n')

for j = 1:length(param)
    xl_inicial(j) = param{j}.xl_sept_init;
    erro_xl(j) = abs(xl_inicial(j) - param{j}.offset_xl_sist); 
    fprintf('-- %02d --|| %1.2f mrad -- || -- %1.2f mrad -- || -- %1.2f %% --\n', j, gen_xl(j)*1e3, erro_xl(j)*1e3, sirius_commis.common.prox_percent(erro_xl(j), gen_xl(j)));
end

conc_xl = sirius_commis.common.prox_percent(erro_xl, gen_xl);
conc_xl_mean = mean(conc_xl);
conc_xl_std = std(conc_xl);
[~, i_max] = min(abs(conc_xl - 100));
[~, i_min] = max(abs(conc_xl - 100));
fprintf('-------------------------------------------------------------\n')
fprintf('Average ||%1.2f mrad||    -- -- %1.4f mrad -- --    || -- %1.2f %% --\n', mean(gen_xl)*1e3, mean(erro_xl)*1e3, conc_xl_mean);
fprintf('RMS     || %1.2fmrad||   -- -- %1.4fmrad-- --      || -- %1.2f %% --\n', std(gen_xl)*1e3, std(erro_xl)*1e3, conc_xl_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_xl(i_max));
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_xl(i_min));

fprintf('============================================================ \n')
fprintf('Injection position Y \n')
fprintf('=========================================================== \n')
fprintf('Mach. n ||  GEN. ERROR  ||   SCRIPT FOUND  ||  AGREEMENT \n')

for j = 1:length(param)
    y_inicial(j) = param{j}.y_sept_init;
    erro_y(j) = abs(y_inicial(j) -param{j}.offset_y_sist); 
    fprintf('-- %02d --|| %1.2f mm -- || -- %1.2f mm -- || -- %1.2f %% --\n', j, gen_y(j)*1e3, erro_y(j)*1e3, sirius_commis.common.prox_percent(erro_y(j), gen_y(j)));
end

conc_y = sirius_commis.common.prox_percent(erro_y', gen_y);
conc_y_mean = mean(conc_y);
conc_y_std = std(conc_y);
[~, i_max] = min(abs(conc_y - 100));
[~, i_min] = min(abs(conc_y - 100));
fprintf('-------------------------------------------------------------\n')
fprintf('Average ||%1.2f mrad||    -- -- %1.4f mrad -- --    || -- %1.2f %% --\n', mean(gen_y)*1e3, mean(erro_y)*1e3, conc_y_mean);
fprintf('RMS     || %1.2fmrad||   -- -- %1.4fmrad-- --      || -- %1.2f %% --\n', std(gen_y)*1e3, std(erro_y)*1e3, conc_y_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_y(i_max));
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_y(i_min));

fprintf('============================================================ \n')
fprintf('Injection angle Y \n')
fprintf('=========================================================== \n')
fprintf('Mach. n ||  GEN. ERROR  ||   SCRIPT FOUND  ||  AGREEMENT \n')

for j = 1:length(param)
    yl_inicial(j) = param{j}.yl_sept_init;
    erro_yl(j) = abs(yl_inicial(j) - param{j}.offset_yl_sist); 
    fprintf('-- %02d --|| %1.2f mrad -- || -- %1.2f mrad -- || -- %1.2f %% --\n', j, gen_yl(j)*1e3, erro_yl(j)*1e3, sirius_commis.common.prox_percent(erro_yl(j), gen_yl(j)));
end

conc_yl = sirius_commis.common.prox_percent(erro_yl', gen_yl);
conc_yl_mean = mean(conc_yl);
conc_yl_std = std(conc_yl);
[~, i_max] = min(abs(conc_yl - 100));
[~, i_min] = max(abs(conc_yl - 100));
fprintf('-------------------------------------------------------------\n')
fprintf('Average ||%1.2f mrad||    -- -- %1.4f mrad -- --    || -- %1.2f %% --\n', mean(gen_yl)*1e3, mean(erro_yl)*1e3, conc_yl_mean);
fprintf('RMS     || %1.2fmrad||   -- -- %1.4fmrad-- --      || -- %1.2f %% --\n', std(gen_yl)*1e3, std(erro_yl)*1e3, conc_yl_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_yl(i_max));
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_yl(i_min));

fprintf('============================================================ \n')
fprintf('Kicker angle \n')
fprintf('=========================================================== \n')
fprintf('Mach. n ||  GEN. ERROR  ||  SCRIPT FOUND   ||  AGREEMENT \n')

for j = 1:length(param)
    kckr_inicial(j) = param{j}.kckr_init;
    erro_kckr(j) = abs(kckr_inicial(j) - param{j}.kckr_sist); 
    fprintf('-- %02d --|| %1.2f mrad -- || -- %1.2f mrad -- || -- %1.2f %% --\n', j, gen_kckr(j)*1e3, erro_kckr(j)*1e3, sirius_commis.common.prox_percent(erro_kckr(j), gen_kckr(j)));
end

conc_kckr = sirius_commis.common.prox_percent(erro_kckr, gen_kckr);
[~, i_max] = max(abs(conc_kckr - 100));
[~, i_min] = min(abs(conc_kckr - 100));
conc_kckr_mean = mean(conc_kckr);
conc_kckr_std = std(conc_kckr);
fprintf('-------------------------------------------------------------\n')
fprintf('Average ||%1.2f mrad||    -- -- %1.4f mrad -- --    || -- %1.2f %% --\n', mean(gen_kckr)*1e3, mean(erro_kckr)*1e3, conc_kckr_mean);
fprintf('RMS     || %1.2fmrad||    -- -- %1.4f mrad -- --    || -- %1.2f %% --\n', std(gen_kckr), std(erro_kckr)*1e3, conc_kckr_std);
fprintf('Maximum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_max, conc_kckr(i_max));
fprintf('Minimum || -- -- -- ||  -- Machine Number %02d --   || -- %1.2f %% --\n', i_min, conc_kckr(i_min));

fprintf('Orbit Standard Deviation \n')
fprintf('============================================================ \n')
fprintf('Machine ||  Horizontal || Vertical \n');
fprintf('============================================================ \n')
for i = 1:length(param)
    orbit_mach = param{i}.orbit;
    orbit_mach_x = orbit_mach(1, :);
    orbit_mach_y = orbit_mach(3, :);
    diffx(i) = nanstd(orbit_mach_x);
    diffy(i) = nanstd(orbit_mach_y);
    fprintf(' %0.2i     || %f mm || %f mm\n', i, diffx(i)*1e3, diffy(i)*1e3);
end

diffx_mean = nanmean(diffx);
[diffx_max, ix_max] = max(diffx);
[diffx_min, ix_min] = min(diffx);
diffy_mean = nanmean(diffy);
[diffy_max, iy_max] = max(diffy);
[diffy_min, iy_min] = min(diffy);
fprintf('-----------------------HORIZONTAL----------------------------------\n')
fprintf('Average || %f mm \n', diffx_mean*1e3);
fprintf('Maximum || -- Machine Number %02d -- || -- %f mm --\n', ix_max, diffx_max*1e3);
fprintf('Minimum || -- Machine Number %02d -- || -- %f mm --\n', ix_min, diffx_min*1e3);
fprintf('-----------------------VERTICAL----------------------------------\n')
fprintf('Average || %f mm \n', diffy_mean*1e3);
fprintf('Maximum || -- Machine Number %02d -- || -- %f mm --\n', iy_max, diffy_max*1e3);
fprintf('Minimum || -- Machine Number %02d -- || -- %f mm --\n', iy_min, diffy_min*1e3);

ind_mach = (1:length(param))';
figure('OuterPosition', [100, 100, 600, 600]);
plot(ind_mach, erro_en, 'o',  'MarkerFaceColor', 'red')
hold all
plot(ind_mach, gen_en, 'o',  'MarkerFaceColor', 'blue')
title('Energy Error');
xlabel('Machine')
ylabel('Energy error [%]')
xlim([0,length(param) + 1]);
legend({'Script','Generated'},'Location','best')
set(gca,'XTick',1:1:length(param));
grid on;
saveas(gcf, 'energy_error.eps', 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
plot(ind_mach, diffx*1e3, 'r--o',  'MarkerFaceColor', 'red')
hold all
plot(ind_mach, diffy*1e3, 'b--o',  'MarkerFaceColor', 'blue')
title('Orbit Standard Deviation');
xlabel('Machine')
ylabel('RMS [mm]')
xlim([0,length(param) + 1]);
% ylim([0, 5]);
legend({'Horizontal','Vertical'},'Location','best')
set(gca,'XTick',1:1:length(param));
grid on;
saveas(gcf, 'orbit_rms_nocorr.eps', 'epsc');
end



