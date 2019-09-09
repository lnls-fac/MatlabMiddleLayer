function [r_aft_kckr, theta_x, theta_y] = check_injection(machine, n_mach, param, param_errors, n_part, n_pulse, nturns)

sirius_commis.common.initializations();

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
    param_err_cell = {param_errors};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
    param_err_cell = param_errors;
end

kckr = findcells(machine_cell{1}, 'FamName', 'InjKckr');
fam = sirius_bo_family_data(machine_cell{1});

for j = 1:n_mach
    machine = machine_cell{j};
    param = param_cell{j};
    param_errors = param_err_cell{j};
    theta_x(j, :) = lnls_get_kickangle(machine, fam.CH.ATIndex, 'x');
    theta_y(j, :) = lnls_get_kickangle(machine, fam.CV.ATIndex, 'y');
    [~, ~, ~, r_aft_kckr(j, :)] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, kckr+1, 'on');
    orbit(j, :, :) = findorbit4(machine, 0, fam.BPM.ATIndex);
    dif_inj_orb(j, :) = r_aft_kckr(j, 1:4) - orbit(j, :, kckr+1);
end

rmscod = rms(orbit, 3);
r_aft_kckr = abs(r_aft_kckr);
figure;
subplot(2,2,1);
plot(r_aft_kckr(:, 1).*1e3, 'b.', 'MarkerSize', 20);
xlabel('Random Machine')
ylabel('X position [mm]')
xlim([0; n_mach+1])
hold on
xmean = mean(r_aft_kckr(:, 1).*1e3);
xrms = rms(r_aft_kckr(:, 1).*1e3);
plot(repmat(xmean + xrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(xmean - xrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(xmean, 1, n_mach), 'k-', 'LineWidth', 3);
grid on

subplot(2,2,2);
plot(r_aft_kckr(:, 2).*1e3, 'b.', 'MarkerSize', 20);
xlabel('Random Machine')
ylabel('X angle [mrad]')
xlim([0; n_mach+1])
hold on
xlmean = mean(r_aft_kckr(:, 2).*1e3);
xlrms = rms(r_aft_kckr(:, 2).*1e3);
plot(repmat(xlmean + xlrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(xlmean - xlrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(xlmean, 1, n_mach), 'k-', 'LineWidth', 3);
grid on

subplot(2,2,3);
plot(r_aft_kckr(:, 3).*1e3, 'b.', 'MarkerSize', 20);
xlabel('Random Machine')
ylabel('Y position [mm]')
xlim([0; n_mach+1])
hold on
ymean = mean(r_aft_kckr(:, 3).*1e3);
yrms = rms(r_aft_kckr(:, 3).*1e3);
plot(repmat(ymean + yrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(ymean - yrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(ymean, 1, n_mach), 'k-', 'LineWidth', 3);
grid on

subplot(2,2,4);
plot(r_aft_kckr(:, 4).*1e3, 'b.', 'MarkerSize', 20);
xlabel('Random Machine')
ylabel('Y angle [mrad]')
xlim([0; n_mach+1])
hold on
ylmean = mean(r_aft_kckr(:, 4).*1e3);
ylrms = rms(r_aft_kckr(:, 4).*1e3);
plot(repmat(ylmean + ylrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(ylmean - ylrms, 1, n_mach), 'r--', 'LineWidth', 3);
plot(repmat(ylmean, 1, n_mach), 'k-', 'LineWidth', 3);
grid on
%title('4D position after kicker')

%================================================================

figure;
subplot(2,1,1);
plot(rmscod(:, 1).*1e3, 'b.', 'MarkerSize', 20);
xlabel('Random Machine')
ylabel('X RMS [mm]')
xlim([0; n_mach+1])
hold on
cod_meanx = repmat(nanmean(rmscod(:, 1).*1e3), 1, n_mach);
cod_rmsx = repmat(nanstd(rmscod(:, 1).*1e3), 1, n_mach);
plot(cod_meanx + cod_rmsx, 'r--', 'LineWidth', 3);
plot(cod_meanx - cod_rmsx, 'r--', 'LineWidth', 3);
plot(cod_meanx, 'k-', 'LineWidth', 3);
grid on

subplot(2,1,2);
plot(rmscod(:, 3).*1e3, 'b.', 'MarkerSize', 20);
xlabel('Random Machine')
ylabel('Y RMS [mm]')
xlim([0; n_mach+1])
hold on
cod_meany = repmat(nanmean(rmscod(:, 3).*1e3), 1, n_mach);
cod_rmsy = repmat(nanstd(rmscod(:, 3).*1e3), 1, n_mach);
plot(cod_meany + cod_rmsy, 'r--', 'LineWidth', 3);
plot(cod_meany - cod_rmsy, 'r--', 'LineWidth', 3);
plot(cod_meany, 'k-', 'LineWidth', 3);
grid on
%title('Closed Orbit RMS')

% ======================================================================

figure;
subplot(2,1,1);
plot(rmscod(:, 1).*1e3, nturns, 'b.', 'MarkerSize', 20);
xlabel('X RMS [mm]')
ylabel('Number of Turns')
grid on

subplot(2,1,2);
plot(rmscod(:, 3).*1e3, nturns, 'b.', 'MarkerSize', 20);
xlabel('Y RMS [mm]')
ylabel('Number of Turns')
grid on

%title('Closed orbit rms versus number of turns')

% ======================================================================

figure;
subplot(2,2,1);
plot(r_aft_kckr(:, 1).*1e3, nturns, 'b.', 'MarkerSize', 20);
xlabel('X position [mm]')
ylabel('Number of turns')
grid on

subplot(2,2,2);
plot(r_aft_kckr(:, 2).*1e3, nturns, 'b.', 'MarkerSize', 20);
xlabel('Angle X [mrad]')
ylabel('Number of turns')
grid on

subplot(2,2,3);
plot(r_aft_kckr(:, 3).*1e3, nturns, 'b.', 'MarkerSize', 20);
xlabel('Y position [mm]')
ylabel('Number of turns')
grid on

subplot(2,2,4);
plot(r_aft_kckr(:, 4).*1e3, nturns, 'b.', 'MarkerSize', 20);
xlabel('Angle Y [mrad]')
ylabel('Number of turns')
grid on
%title('4D position after kicker versus number of turns')

% ======================================================================

figure;
subplot(2,2,1);
plot(dif_inj_orb(:, 1) * 1e3, rms(theta_x, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('X dif injected beam and cod [mm]')
ylabel('RMS Kick CH [urad]')
grid on

subplot(2,2,2);
plot(dif_inj_orb(:, 2) * 1e3, rms(theta_x, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('X angle dif injected beam and cod [mm]')
ylabel('RMS Kick CH [urad]')
grid on

subplot(2,2,3);
plot(dif_inj_orb(:, 3) * 1e3, rms(theta_y, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('Y dif injected beam and cod [mm]')
ylabel('RMS Kick CV [urad]')
grid on

subplot(2,2,4);
plot(dif_inj_orb(:, 4) * 1e3, rms(theta_y, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('Y angle dif injected beam and cod [mm]')
ylabel('RMS Kick CV [urad]')
grid on

%title('Diff between inj beam and closed orbit versus rms kicks')

% ======================================================================

figure;
subplot(2,2,1);
plot(r_aft_kckr(:, 1) * 1e3, rms(theta_x, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('X injected beam [mm]')
ylabel('RMS Kick CH [urad]')
grid on

subplot(2,2,2);
plot(r_aft_kckr(:, 2) * 1e3, rms(theta_x, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('X injected beam [mm]')
ylabel('RMS Kick CH [urad]')
grid on

subplot(2,2,3);
plot(r_aft_kckr(:, 3) * 1e3, rms(theta_y, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('Y injected beam [mm]')
ylabel('RMS Kick CV [urad]')
grid on

subplot(2,2,4);
plot(r_aft_kckr(:, 4) * 1e3, rms(theta_y, 2) * 1e6, 'b.', 'MarkerSize', 20);
xlabel('Y angle injected beam [mm]')
ylabel('RMS Kick CV [urad]')
grid on
%}
end
