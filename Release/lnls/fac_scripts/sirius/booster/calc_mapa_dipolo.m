function the_ring = calc_mapa_dipolo

%% multipolos
% n = repmat([1 2 3 4 5 6],100,1);
% %x = repmat(linspace(-10,10,100)'*1e-3,1,6);
% x = repmat(linspace(-17.5,17.5,100)'*1e-3,1,6);
% pol = pot*((x/17.5e-3).^n)';
% plot(x(:,1),pol*7.5/180*pi);
% 
% name = 'modelo4_fewsegments.mat';
name = 'fieldmap_analysis_modelo6_6segmentos.mat';
% name = 'modelo4.mat';
% name = 'modelo5_1segmento.mat';
% name = 'modelo5_6segmentos.mat';
at_model = load(['/home/fac_files/data/sirius_mml/magnet_modelling/CONFIGS/BOOSTER_B_MODELO6/' name]);
at_model = at_model.r.at_model;
comp_atmod = findspos(at_model, length(at_model)+1);

the_ring = sirius_bo_lattice();
atsummary(the_ring);
idx_dip = findcells(the_ring,'FamName','B');
n_dip = length(idx_dip);
comp_dip = the_ring{idx_dip(1)}.Length/2;

diff = comp_atmod - comp_dip;
for ii=1:n_dip
    comp_dr = getcellstruct(the_ring,'Length',idx_dip(1)+[-2 2]);
    comp_dr_new = comp_dr-diff;
    if any(comp_dr_new) < 0, error('comprimento negativo'); end;
    dr_menos = drift('dr_menos', comp_dr_new(1), 'DriftPass');
    dr_mais  = drift('dr_mais', comp_dr_new(2), 'DriftPass');
    drifts = buildlat([dr_menos dr_mais]);
    the_ring = [the_ring(1:idx_dip(1)-3) drifts(1) fliplr(at_model) ...
                at_model drifts(2) the_ring(idx_dip(1)+3:end)];
    idx_dip = findcells(the_ring,'FamName','B');
end
atsummary(the_ring);

return
%% geração do modelo2D;

bend_idx = findcells(the_ring,'FamName','BEND');
quad = getcellstruct(the_ring,'PolynomB',bend_idx,2);
the_ring = setcellstruct(the_ring,'PolynomB',bend_idx,quad*1.05,2);
sext = getcellstruct(the_ring,'PolynomB',bend_idx,3);
the_ring = setcellstruct(the_ring,'PolynomB',bend_idx,sext*0.88,3);
the_ring = setcellstruct(the_ring,'MaxOrder', bend_idx, 2);

% atsummary(the_ring);



ind = length(bend_idx)/50/2;
atmodel_idx = bend_idx(1:ind);
atmodel = fliplr(the_ring(atmodel_idx));

spos = findspos(at_model, 1:length(at_model));
quad = getcellstruct(at_model,'PolynomB',1:length(at_model),2);
figure; plot(spos, quad)
quad = getcellstruct(atmodel,'PolynomB',1:length(atmodel),2);
hold on; plot(spos, quad, 'r')

sext = getcellstruct(at_model, 'PolynomB', 1:length(at_model), 3);
figure;plot(spos, sext)
sext = getcellstruct(atmodel, 'PolynomB', 1:length(atmodel), 3);
hold on; plot(spos, sext,'r')


spos = findspos(atmodel, 1:length(atmodel)+1);
%traj_len deve ser maior ou igual ao comprimento do modelo at a ser usado!!
config.traj_len = 1.036/2;
ind = spos < config.traj_len;
atmodel = atmodel(ind);
config.traj_len = findspos(atmodel, length(atmodel)+1);


config.dipole_length    = 1.152;
config.dipole_angle     = 2*sum(getcellstruct(atmodel,'BendingAngle',1:length(atmodel)));

config.energy = 3; % [GeV]

config.dipole_model = atmodel;

config.dipole_rho       = 1.152 / (7.2*pi/180);
config.dipole_sagitta   = config.dipole_rho * (1.0 - cos((7.2*pi/180)/2));
config.hard_edge_length = 2*config.dipole_rho*sin((7.2*pi/180)/2); 
% grid of points perp. to the ref. trajectory for AT-RK comparison
config.x    = [-6 -1  0 +1 +6] / 1000;
% config.coeffs   = [B0, G0, S0];     % [T T/m T/m^2]; By(x) = coeffs(1) + coeffs(2) * x + coeffs(3) * x^2
B0 = -1.054325;
G0 =  1.843324;
S0 = 19.594382;
config.coeffs   = [B0, G0, S0];

addpath('/home/fac_files/code/MatlabMiddleLayer/Release/lnls/fac_scripts/sirius/calc_2dfield_from_at_model');
findmultipoles(config);
