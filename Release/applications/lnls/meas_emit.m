function [size_x, size_y] = meas_emit(tb_lattice)
sirius_commis.common.initializations();
[~, gamma, ~] = lnls_beta_gamma(0.150);
fam = sirius_tb_family_data(tb_lattice);
k_max = 15.9890;
I_max = 10;
n_points = 20;
curr2k = k_max / I_max;

emit_x = 55e-6 / gamma;
emit_y = 55e-6 / gamma;
sigmae = 0.5e-2;
sigmas = 2e-9 * 3e8; % sigmat [ns] x speed_of_light

twiss_bunch.betax = 5.385;
twiss_bunch.betay = 5.549;
twiss_bunch.alphax = 0.814;
twiss_bunch.alphay = 2.360;
twiss_bunch.etax = 0;
twiss_bunch.etay = 0;
twiss_bunch.etaxl = 0;
twiss_bunch.etayl = 0;
n_part = 1e4;
cutoff = 3;

twiss_data_in.ElemIndex = 1;
twiss_data_in.SPos = 0;
twiss_data_in.ClosedOrbit = [0; 0; 0; 0];
twiss_data_in.Dispersion = [0; 0; 0; 0];
twiss_data_in.M44 = findm44(tb_lattice, 0, 1);
twiss_data_in.beta = [twiss_bunch.betax, twiss_bunch.betay];
twiss_data_in.alpha = [twiss_bunch.alphax, twiss_bunch.alphay];
twiss_data_in.mu = [0, 0];
twiss_tb = twissline(tb_lattice, 0, twiss_data_in, 1:length(tb_lattice));
beta0 = cat(1, twiss_tb.beta);
alpha0 = cat(1, twiss_tb.alpha);
KQ = getcellstruct(tb_lattice, 'PolynomB', fam.QF2A.ATIndex, 1, 2);
cur_nomQ = KQ / curr2k;
curr = linspace(6.5, 7.25, n_points);
grad = curr.* curr2k;
% tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QD2A.ATIndex, 0, 1, 2);
tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QF2A.ATIndex, 0, 1, 2);
tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QD2B.ATIndex, 0, 1, 2);
tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QF2B.ATIndex, 0, 1, 2);
% tb_lattice = setcellstruct(tb_lattice, 'PolynomB', fam.QD2A.ATIndex, 0, 1, 2);
for i = 1:n_points
    tb_lattice_meas = setcellstruct(tb_lattice, 'PolynomB', fam.QF2A.ATIndex, grad(i), 1, 2);
    R_in = lnls_generate_bunch(emit_x, emit_y, sigmae, sigmas, twiss_bunch, n_part, cutoff);
    R_out = linepass(tb_lattice_meas(1:fam.Scrn.ATIndex(4)), R_in, fam.Scrn.ATIndex(4));
    size_x(i) = sqrt(mean(squeeze(R_out(1, :) .* R_out(1, :))));
    size_y(i) = sqrt(mean(squeeze(R_out(3, :) .* R_out(3, :))));
end

figure; plot(curr, size_x * 1e3, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
hold on;
title('Tamanho horizontal @ Screen 2 - Setor 2');
xlabel('Corrente Quadrupolo [A]')
ylabel('Tamanho feixe [mm]');

p2x = polyfit(curr, size_x, 2);
size_x_fit = polyval(p2x, curr);
plot(curr, size_x_fit * 1e3, 'blue', 'LineWidth', 2);
s = findspos(tb_lattice, 1:length(tb_lattice));
L = tb_lattice{fam.QF2A.ATIndex}.Length;
d = s(fam.Scrn.ATIndex(4)) - s(fam.QF2A.ATIndex) - L;

sigma0_11x = p2x(1) / d^2 / L^2;
sigma0_12x = - (p2x(2) + 2 * d * L * sigma0_11x) / (2 * d^2 * L);
sigma0_22x = (p2x(3) - sigma0_11x - 2 * d * sigma0_12x) / d^2;

emitx = sqrt(sigma0_11x * sigma0_22x - sigma0_12x * sigma0_12x);
betax = sigma0_11x / emitx;
alphax = -sigma0_12x / emitx;

figure; plot(curr, size_y * 1e3, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); grid on;
hold on;
title('Tamanho vertical @ Screen 2 - Setor 2');
xlabel('Corrente Quadrupolo [A]')
ylabel('Tamanho feixe [mm]');

p2y = polyfit(curr, size_y, 2);
size_y_fit = polyval(p2y, curr);
plot(curr, size_y_fit * 1e3, 'blue', 'LineWidth', 2);

sigma0_11y = p2y(1) / d^2 / L^2;
sigma0_12y = - (p2y(2) + 2 * d * L * sigma0_11y) / (2 * d^2 * L);
sigma0_22y = (p2y(3) - sigma0_11y - 2 * d * sigma0_12y) / d^2;

emity = sqrt(sigma0_11y * sigma0_22y - sigma0_12y * sigma0_12y);
betay = sigma0_11y / emity;
alphay = - sigma0_12y / emity;

betax0 = beta0(fam.QF2A.ATIndex + 1, 1);
betay0 = beta0(fam.QF2A.ATIndex + 1, 2);
alphax0 = alpha0(fam.QF2A.ATIndex + 1, 1);
alphay0 = alpha0(fam.QF2A.ATIndex + 1, 2);




end

