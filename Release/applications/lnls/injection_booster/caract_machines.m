function caract_machines(machine0, machine_corr, n_mach, n_turns0, n_turns_corr, rms_orbit_bpm, max_orbit_bpm)

bpm = findcells(machine0{1}, 'FamName', 'BPM');
mu_x0 = zeros(n_mach, 1);
mu_x_corr = zeros(n_mach, 1);
mu_y0 = zeros(n_mach, 1);
mu_y_corr = zeros(n_mach, 1);
sigma_x0 = zeros(n_mach, 1);
sigma_x = zeros(n_mach, 1);
sigma_y0 = zeros(n_mach, 1);
sigma_y = zeros(n_mach, 1);
max_x0 = zeros(n_mach, 1);
max_x = zeros(n_mach, 1);
max_y = zeros(n_mach, 1);
max_y0 = zeros(n_mach, 1);
orbit_0 = cell(n_mach, 1);
orbit_corr = cell(n_mach, 1);

if n_mach == 1
    machine_cell0 = {machine0};
    machine_cell_corr = {machine_corr};
elseif n_mach > 1
    machine_cell0 = machine0;
    machine_cell_corr = machine_corr;    
end

for j = 1:n_mach
    machine0 = machine_cell0{j};
    machine_corr = machine_cell_corr{j};   
    
    twiss0 = calctwiss(machine0, 1:length(machine0));
    twiss_corr = calctwiss(machine_corr, 1:length(machine_corr));

    mu_x0(j) = twiss0.mux(end)/2/pi;
    mu_y0(j) = twiss0.muy(end)/2/pi;

    mu_x_corr(j) = twiss_corr.mux(end)/2/pi;
    mu_y_corr(j) = twiss_corr.muy(end)/2/pi;

    orbit_0{j} = findorbit4(machine0, 0, bpm);
    orbit_corr{j} = findorbit4(machine_corr, 0, bpm);
    
    orbit0 = orbit_0{j};
    orbit_x0 = orbit0(1, :);
    orbit_y0 = orbit0(3, :);
    
    orbitcorr = orbit_corr{j};
    orbit_xcorr = orbitcorr(1, :);
    orbit_ycorr = orbitcorr(3, :);
    
    sigma_x(j) = nanstd(orbit_xcorr);
    sigma_x0(j) = nanstd(orbit_x0);
    sigma_y(j) = nanstd(orbit_ycorr);
    sigma_y0(j) = nanstd(orbit_y0);
    
    [max_x(j), i_max_x] = nanmax(abs(orbit_xcorr));
    max_x(j) = sign(orbit_xcorr(i_max_x))*max_x(j);
    [max_x0(j), i_max_x0] = nanmax(abs(orbit_x0));
    max_x0(j) = sign(orbit_x0(i_max_x0))*max_x0(j);
    
    [max_y(j), i_max_y] = nanmax(abs(orbit_ycorr));
    max_y(j) = sign(orbit_ycorr(i_max_y))*max_y(j);
    [max_y0(j), i_max_y0] = nanmax(abs(orbit_y0));
    max_y0(j) = sign(orbit_y0(i_max_y0))*max_y0(j);
end

mm = 1e3;
ind_mach = (1:n_mach)';

mean_n_turns0 = squeeze(mean(n_turns0, 1));
sigma_n_turns0 = squeeze(std(n_turns0, 1, 1));
mean_n_turns_corr = squeeze(mean(n_turns_corr, 1));
sigma_n_turns_corr = squeeze(std(n_turns_corr, 1, 1));

figure('OuterPosition', [100, 100, 600, 600]);
% plot(ind_mach, n_turns0, 'ro',  'MarkerFaceColor', 'red')
errorbar(ind_mach, mean_n_turns0, sigma_n_turns0, 'ro',  'MarkerFaceColor', 'red')
hold all
errorbar(ind_mach, mean_n_turns_corr, sigma_n_turns_corr, 'bo',  'MarkerFaceColor', 'blue')
% plot(ind_mach, n_turns_corr, 'bo',  'MarkerFaceColor', 'blue')
title('Number of Turns - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('Number of Turns')
xlim([1,20]);
ylim([-10, 70]);
legend({'No correctors','Correction 1st turn'},'Location','best')
set(gca,'XTick',1:1:20);
grid on;
fname = '/home/murilo/Documents/Injection_Booster/Correction_M/100_pulses';
saveas(gcf, fullfile(fname, 'turns.eps'), 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
hold off
plot(ind_mach, rms_orbit_bpm(:, 1)*mm, 'o',  'MarkerFaceColor', 'green')
hold all
plot(ind_mach, sigma_x*mm, 'b--o',  'MarkerFaceColor', 'blue')
plot(ind_mach, sigma_x0*mm, 'r--o',  'MarkerFaceColor', 'red');
title('Standard Deviation Horizontal Orbit - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('RMS Horizontal [mm]')
xlim([1,20]);
set(gca,'XTick',1:1:20);
legend({'1st turn BPM','Closed orbit with correction', 'Closed orbit no corrector'},'Location','best')
grid on;
saveas(gcf, fullfile(fname, 'rms_orbit_x.eps'), 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
hold off
plot(ind_mach, max_orbit_bpm(:, 1)*mm, 'o',  'MarkerFaceColor', 'green')
hold all
plot(ind_mach, max_x*mm, 'o',  'MarkerFaceColor', 'blue')
plot(ind_mach, max_x0*mm, 'o',  'MarkerFaceColor', 'red');
title('Maximum Value Horizontal Orbit - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('Max Horizontal [mm]')
xlim([1,20]);
set(gca,'XTick',1:1:20);
legend({'1st turn BPM','Closed orbit with correction', 'Closed orbit no corrector'},'Location','best')
grid on;
saveas(gcf, fullfile(fname, 'max_orbit_x.eps'), 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
hold off
plot(ind_mach, rms_orbit_bpm(:, 2)*mm, 'o',  'MarkerFaceColor', 'green');
hold all
plot(ind_mach, sigma_y*mm, 'b--o',  'MarkerFaceColor', 'blue');
plot(ind_mach, sigma_y0*mm, 'r--o',  'MarkerFaceColor', 'red');
title('Standard Deviation Vertical Orbit - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('RMS Vertical [mm]')
xlim([1,20]);
set(gca,'XTick',1:1:20);
legend({'1st turn BPM','Closed orbit with correction', 'Closed orbit no corrector'},'Location','best')
grid on;
saveas(gcf, fullfile(fname, 'rms_orbit_y.eps'), 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
hold off
plot(ind_mach, max_orbit_bpm(:, 2)*mm, 'o',  'MarkerFaceColor', 'green');
hold all
plot(ind_mach, max_y*mm, 'o',  'MarkerFaceColor', 'blue');
plot(ind_mach, max_y0*mm, 'o',  'MarkerFaceColor', 'red'); 
title('Maximum Value Vertical Orbit - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('Max Vertical [mm]')
xlim([1,20]);
set(gca,'XTick',1:1:20);
legend({'1st turn BPM','Closed orbit with correction', 'Closed orbit no corrector'},'Location','best')
grid on;
saveas(gcf, fullfile(fname, 'max_orbit_y.eps'), 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
hold off
plot(ind_mach, mu_x0, 'o',  'MarkerFaceColor', 'red')
hold all
plot(ind_mach, mu_x_corr, 'o',  'MarkerFaceColor', 'blue')
title('Horizontal Tune - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('Tune x')
xlim([1,20]);
set(gca,'XTick',1:1:20);
legend({'No correctors','Correction 1st turn'},'Location','best')
grid on;
saveas(gcf, fullfile(fname, 'tune_x.eps'), 'epsc');

figure('OuterPosition', [100, 100, 600, 600]);
hold off
plot(ind_mach, mu_y0, 'o',  'MarkerFaceColor', 'red');
hold all
plot(ind_mach, mu_y_corr, 'o',  'MarkerFaceColor', 'blue')
title('Vertical Tune - Matrix Method - 100 pulses');
xlabel('Machine')
ylabel('Tune y')
xlim([1,20]);
set(gca,'XTick',1:1:20);
legend({'No correctors','Correction 1st turn'},'Location','best')
grid on;
saveas(gcf, fullfile(fname,'tune_y.eps'), 'epsc');
drawnow();
end
