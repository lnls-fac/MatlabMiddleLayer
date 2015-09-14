function sirius_injection

% global parameters

nr_particles = 1000;
bo_coupling  = 0.10;
sirius_path = fullfile(lnls_get_root_folder(), 'code', 'MatlabMiddleLayer', 'Release', 'machine', 'SIRIUS');

% loads BO model
addpath(fullfile(sirius_path, 'BO.V02'));
bo = sirius_bo_lattice(3.0);

% loads TS model
addpath(fullfile(sirius_path, 'TS.V01'));
ts = sirius_bo_lattice();

% loads SI model
addpath(fullfile(sirius_path, 'SI.V10'));
si = sirius_bo_lattice();

% shift BO model so that ot starts at extraction kicker
bo_kickex_idx = findcells(bo, 'FamName', 'kick_ex');
bo = [bo(bo_kickex_idx(1):end) bo(1:bo_kickex_idx(1)-1)];

% calculates optics and equilibrium parametes of BO
bo_twiss = calctwiss(bo);
bo_eqparms = atsummary(bo);

% generates bunch at entrance of BO extraction kicker
emitx =  1 * bo_eqparms.naturalEmittance / (1.0 + bo_coupling);
emity =  bo_coupling * bo_eqparms.naturalEmittance / (1.0 + bo_coupling);
bunch = [zeros(6,1) lnls_generate_bunch(emitx, emity, bo_eqparms.naturalEnergySpread, bo_eqparms.bunchlength, bo_twiss(1), nr_particles-1, 30)];
figure; plot(1e3*bunch(1,:), 1e3*bunch(2,:), '.'); xlabel('rx/mm'); ylabel('px/mrad');
