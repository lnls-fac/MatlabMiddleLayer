
% first, we load the lattice
lattice_errors([pwd '/cod_matlab']);
machines = load([pwd '/cod_matlab/CONFIG_machines_cod_corrected.mat']);
storage_ring = machines.machine;

param1.energy_deviation  = 0;
param1.radius_resolution = 3e-4;
param1.nr_turns          = 1000;
param1.points_angle      = repmat([1/2+1e-3, 5/8, 6/8, 7/8, 1-1e-3]*pi, length(param1.energy_deviation), 1);
param1.points_radius     = repmat([2,          2,   3,   3,   5   ]*1e-3, length(param1.energy_deviation), 1);
param1.quiet_mode        = true;

param2.energy_deviation  = [-4, -3, -2, -1, 0, 1, 2, 3, 4]*1e-2;
param2.radius_resolution = 3e-4;
param2.nr_turns          = 1000;
param2.points_angle      = repmat((1-1e-3)*pi, length(param2.energy_deviation), 1);
param2.points_radius     = repmat(5*1e-3,     length(param2.energy_deviation), 1);
param2.quiet_mode        = true;

x = zeros(length(storage_ring),length(param1.points_angle(1,:)));
y = zeros(length(storage_ring),length(param1.points_angle(1,:)));
x_en = zeros(length(storage_ring),length(param2.energy_deviation));
en0 = sum(param2.energy_deviation <= 0);
for ii = 1:length(storage_ring)
    r = lnls_dynapt(storage_ring{ii},param1);
    x(ii,:) = r.points_x(1,:);
    y(ii,:) = r.points_y(1,:);
    r = lnls_dynapt(storage_ring{ii},param2);
    x_en(ii,:) = r.points_x(:,1)'; 
    fprintf('Ja foi: %d\n', ii);
end

%%

x_ave = mean(x,1);
x_rms = std(x);
x_plus = x_ave - x_rms;
x_min = x_ave + x_rms;

y_ave = mean(y,1);
y_rms = std(y);
y_plus = y_ave + y_rms;
y_min = y_ave - y_rms;

x_en_ave = mean(x_en,1);
x_en_rms = std(x_en);
x_en_plus = x_en_ave - x_en_rms;
x_en_min = x_en_ave + x_en_rms;
ener = param2.energy_deviation;


scrsz = get(0,'ScreenSize');
scrsz = [1, 1, 1/4, 1].*scrsz;
% Booster drawing:
figure1 = figure('OuterPosition', scrsz);
axes11 = subplot(2,1,1,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
ylabel(axes11,'y [mm]'); xlabel(axes11,'x [mm]');
hold(axes11,'on');
plot(x_ave*1e3,  y_ave*1e3, 'LineWidth',3,'LineStyle','-', 'Parent',axes11);
plot(x_plus*1e3, y_plus*1e3,'LineWidth',1,'LineStyle','--', 'Parent',axes11);
plot(x_min*1e3,  y_min*1e3, 'LineWidth',1,'LineStyle','--', 'Parent',axes11);

axes12 = subplot(2,1,2,'Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
ylabel(axes12,'x [mm]'); xlabel(axes12,'ener [%]');
hold(axes12,'on');
plot(ener*1e2,  x_en_ave*1e3, 'LineWidth',3,'LineStyle','-', 'Parent',axes12);
plot(ener*1e2, x_en_plus*1e3,'LineWidth',1,'LineStyle','--', 'Parent',axes12);
plot(ener*1e2,  x_en_min*1e3, 'LineWidth',1,'LineStyle','--', 'Parent',axes12);