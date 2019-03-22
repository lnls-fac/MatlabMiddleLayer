function check_emit_meas_tb(tb_lattice, mode, n_points)

[~, gamma] = lnls_beta_gamma(0.150);

% ANTES TRIPLETO
% betax0 = 5.385; betay0 = 5.549;
% alphax0 = 0.814; alphay0 = 2.360;
% mux0 = 0; muy0 = 0;

% DEPOIS TRIPLETO

betax0 = 3.00; betay0 = 3.50;
alphax0 = 2.48; alphay0 = 1.58;
mux0 = 0; muy0 = 0;
emitx_n = 55 * 1e-6; emity_n = emitx_n;
emitx = emitx_n / gamma; emity = emity_n / gamma;
kmax = 15.9890;

fam = sirius_tb_family_data(tb_lattice);
tb_lattice = tb_lattice(fam.QF3L.ATIndex+1:end);
fam = sirius_tb_family_data(tb_lattice);

twiss_data_in.ElemIndex = 1;
twiss_data_in.SPos = 0;
twiss_data_in.ClosedOrbit = [0; 0; 0; 0];
twiss_data_in.Dispersion = [0; 0; 0; 0];
twiss_data_in.M44 = findm44(tb_lattice, 0, 1);
twiss_data_in.beta = [betax0, betay0];
twiss_data_in.alpha = [alphax0, alphay0];
twiss_data_in.mu = [mux0, muy0];

QD_ind = fam.QF2A.ATIndex;
Scrn1_ind = fam.Scrn.ATIndex(3);
Scrn2_ind = fam.Scrn.ATIndex(4);
init = QD_ind - 1;
final = Scrn2_ind + 1;
% trecho_meas = tb_lattice(init:final);

if strcmp(mode, 'pm')
    grad = linspace(-kmax, kmax, n_points);
elseif strcmp(mode, 'm')
    grad = linspace(-kmax, 0, n_points);
elseif strcmp(mode, 'p')
    grad = linspace(0, kmax, n_points);
end

% tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QD2A.ATIndex, 0, 1, 2);
tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QF2A.ATIndex, 0, 1, 2);
tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QD2B.ATIndex, 0, 1, 2);
tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QF2B.ATIndex, 0, 1, 2);


for i = 1:n_points
    tb_lattice_meas = setcellstruct(tb_lattice, 'PolynomB', QD_ind, grad(i), 1, 2);
    twiss_tb = twissline(tb_lattice_meas, 0, twiss_data_in, 1:length(tb_lattice));
    beta = cat(1, twiss_tb.beta);
    spos = cat(1, twiss_tb.SPos);
    shape1x(i) = sqrt(emitx * beta(Scrn1_ind, 1)) * 1e3;
    shape2x(i) = sqrt(emitx * beta(Scrn2_ind, 1)) * 1e3;
    shape1y(i) = sqrt(emity * beta(Scrn1_ind, 2)) * 1e3;
    shape2y(i) = sqrt(emity * beta(Scrn2_ind, 2)) * 1e3;
    % gcf();
    % plot(spos(init: final), beta(init:final, 1), 'blue');
    % hold all
end

if strcmp(mode, 'pm')
    figure; plot(grad ./ 1.5989, shape1x , 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2A(+-): Tamanho horizontal @ Screen 1');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpmx1.jpg');
    figure; plot(grad, shape2x, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+-): Tamanho horizontal @ Screen 2');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpmx2.jpg');
    figure; plot(grad, shape1y, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+-): Tamanho vertical @ Screen 1');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpmy1.jpg');
    figure; plot(grad, shape2y, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+-): Tamanho vertical @ Screen 2');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpmy2.jpg');
    close all
elseif strcmp(mode, 'm')
    figure; plot(grad ./ 1.5989, shape1x, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(-): Tamanho horizontal @ Screen 1');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bmx1.jpg');
    figure; plot(grad, shape2x, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(-): Tamanho horizontal @ Screen 2');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bmx2.jpg');
    figure; plot(grad, shape1y, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(-): Tamanho vertical @ Screen 1');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bmy1.jpg');
    figure; plot(grad, shape2y, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(-): Tamanho vertical @ Screen 2');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bmy2.jpg');
    close all
elseif strcmp(mode, 'p')
    figure; plot(grad ./ 1.5989, shape1x, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+): Tamanho horizontal @ Screen 1');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpx1.jpg');
    figure; plot(grad, shape2x, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+): Tamanho horizontal @ Screen 2');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpx2.jpg');
    figure; plot(grad, shape1y, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+): Tamanho vertical @ Screen 1');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpy1.jpg');
    figure; plot(grad, shape2y, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
    title('QD2B(+): Tamanho vertical @ Screen 2');
    xlabel('Corrente Quadrupolo [A]')
    ylabel('Tamanho feixe [mm]');
    saveas(gcf, 'QD2Bpy2.jpg');
    close all
end






% lnls_drawlattice(tb_lattice, 1, -1);
% xlim([spos(init), spos(final)]);
% y = get(gca, 'ylim');
% plot([spos(Scrn1_ind) spos(Scrn1_ind)], y, 'black', 'LineWidth', 3);
% plot([spos(Scrn2_ind) spos(Scrn2_ind)], y, 'black', 'LineWidth', 3);





end

