function optimize_sirius_plot_solution(opt)


clear global THERING;

if ~exist('opt','var')
    opt = getappdata(0, 'opt');
    if isempty(opt)
        if exist('OPT.mat','file')
            load('OPT.mat');
        else
            fprintf('no solution found.\n');
            return;
        end
    end
end
global THERING;
THERING = opt.the_ring;

scell = opt.the_ring;
len   = getcellstruct(scell, 'Length', 1:length(scell));
bends = findcells(scell, 'BendingAngle');
quads = findcells(scell, 'K');
quads = setdiff(quads, bends);

quad_K = zeros(size(len));
quad_K(quads) = getcellstruct(scell, 'K', quads);
bend_K = zeros(size(len));
bend_K(bends) = getcellstruct(scell, 'K', bends);
bend_A = zeros(size(len));
bend_A(bends) = getcellstruct(scell, 'BendingAngle', bends);
bend_F = opt.b_rho * (bend_A ./ len);
bend_F(isnan(bend_F)) = 0;

quadK = [];
bendF = [];
bendK = [];
pos   = [];
for i=1:length(len)
    if i==1
        pos = [pos 0 len(i)];
    else
        pos = [pos pos(end) pos(end)+len(i)];
    end
    quadK = [quadK quad_K(i) quad_K(i)];
    bendF = [bendF bend_F(i) bend_F(i)];
    bendK = [bendK bend_K(i) bend_K(i)];
end
figure; hold all;
plot(pos, 10*bendF, 'LineWidth', 2.3);
plot(pos, bendK, 'LineWidth', 2.3);
plot(pos, quadK, 'LineWidth', 2.3);
maxy = max([quadK, bendK, 10*bendF]);
miny = min([quadK, bendK, 10*bendF]);
dely = maxy-miny;
plot([min(pos) max(pos)], [miny miny], 'k--');
drawlattice(miny - dely/8, dely/8);
axis([min(pos), max(pos), miny-dely/4, maxy]);
xlabel('Pos [m]');
ylabel('10 \times B_{bend} [T], K_{bend} [m^{-2}], K_{quad} [m^{-2}]');
legend({'10 \times B_{bend}', 'K_{bend}', 'K_{quad}'});



% TWISS
figure; hold all;
twiss   = calctwiss(opt.the_ring);
nux = opt.nr_cells*twiss.mux(end)/2/pi;
nuy = opt.nr_cells*twiss.muy(end)/2/pi;
plot(twiss.pos, twiss.betax, 'LineWidth', 2.3);
plot(twiss.pos, twiss.betay, 'LineWidth', 2.3);
plot(twiss.pos, 100*twiss.etax, 'LineWidth', 2.3);
maxy = max([twiss.betax; twiss.betay; 100*twiss.etax]);
miny = min([twiss.betax; twiss.betay; 100*twiss.etax]);
dely = maxy-miny;
legend({'\beta_x', '\beta_y', '\eta_x'});
xlabel('Pos [m]');
ylabel('\beta_x [m], \beta_y [m], \eta_x [cm]');
drawlattice(miny - dely/8, dely/8);
axis([min(pos), max(pos), miny-dely/4, maxy]);
title(['Twiss Parameters [\nu_x = ', num2str(nux, '%7.4f'), ', \nu_y = ', num2str(nuy, '%7.4f'), ']']);


