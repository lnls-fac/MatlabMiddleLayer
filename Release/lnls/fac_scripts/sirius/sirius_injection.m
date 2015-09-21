function sirius_injection

% initializations
close all; drawnow;
lnls_setpath_mml_at;

% global parameters
nr_particles = 1000;
bo_coupling  = 0.10;
sirius_path = fullfile(lnls_get_root_folder(), 'code', 'MatlabMiddleLayer', 'Release', 'machine', 'SIRIUS');

% loads BO model
addpath(fullfile(sirius_path, 'BO.V02'));
bo = sirius_bo_lattice(3.0);

% loads TS model
addpath(fullfile(sirius_path, 'TS.V01'));
ts = sirius_ts_lattice('M1');

% loads SI model
addpath(fullfile(sirius_path, 'SI.V10'));
si = sirius_si_lattice();

% shift BO model so that BO starts at extraction kicker
bo_kickex_idx = findcells(bo, 'FamName', 'kick_ex');
bo = [bo(bo_kickex_idx(1):end) bo(1:bo_kickex_idx(1)-1)];
bo_kickex_idx = findcells(bo, 'FamName', 'kick_ex');

% calculates optics and equilibrium parametes of BO
bo_twiss = calctwiss(bo);
bo_eqparms = atsummary(bo);

% generates bunch at entrance of BO extraction kicker
e0 = bo_eqparms.naturalEmittance; k = bo_coupling;
emitx =  1 * e0 / (1.0 + k); emity =  k * e0 / (1.0 + k);
bunch = [zeros(6,1) lnls_generate_bunch(emitx, emity, bo_eqparms.naturalEnergySpread, bo_eqparms.bunchlength, bo_twiss(1), nr_particles-1, 30)];
create_new_x_phase_space_plot(bunch, 'bunch at entrance of BO extraction kicker');

% sets extraction kicker and kicks beam
kickex_kick = 2.516e-3; % [rad]
bo = lnls_set_kickangle(bo, kickex_kick, bo_kickex_idx, 'x');
tbunch = linepass(bo, bunch, bo_kickex_idx(2)+1);
create_new_x_phase_space_plot(tbunch, 'bunch after extraction kicker');

% transport bunch from entrance of extraction kicker to entrance of extraction thin septum
bo_septex_idx = findcells(bo, 'FamName', 'sept_ex');
tbunch = linepass(bo, bunch, 1:bo_septex_idx);
bunch = tbunch(:,end-nr_particles+1:end);
create_new_x_phase_space_plot(bunch, 'bunch at entrance of thin extraction septum (BO coordinates)');

% translation of bunch coordinates from BO to TS
ts_chamber_rx_at_bo = 22e-3;  % [m]   (rx of center of TS vacuum chamber w.r.t. TS coord. system)
ts_chamber_px_at_bo = 5.0e-3; % [rad] (px of center of TS vacuum chamber w.r.t. TS coord. system)
ts_chamber_at_bo = [ts_chamber_rx_at_bo;ts_chamber_px_at_bo;0;0;0;0];
bunch = bunch - repmat(ts_chamber_at_bo, 1, size(bunch,2));
create_new_x_phase_space_plot(bunch, 'bunch at beginning of TS');

% adds error in thin and thick BO extraction septa
% adds error in thick and thin SI injection septa

% propagates bunch through TS
tbunch = linepass(ts, bunch, 1:length(ts)+1);
bunch = tbunch(:,end-nr_particles+1:end);
create_new_x_phase_space_plot(bunch, 'bunch at end of TS');

% translation of bunch coordinates from TS to SI
si_chamber_rx_at_ts =  0.0165; % [m]   (as measured at TS coordinates)
si_chamber_px_at_ts = -2.2e-3; % [rad] (as measured at SI coordinates)
si_chamber_at_ts = [si_chamber_rx_at_ts;si_chamber_px_at_ts;0;0;0;0];
bunch = bunch - repmat(si_chamber_at_ts, 1, size(bunch,2));
create_new_x_phase_space_plot(bunch, 'bunch at injection point of SI');

% turns PMM kick on 
pmm_strength = 0.5;
si_pmm_idx = findcells(si, 'FamName', 'pmm');
[~, ~, ~, LPolyB] = sirius_si_pmm_kick(pmm_strength);
si = sets_pmm(si, si_pmm_idx, 1.0, LPolyB);

% transports bunch one turn into SI, plots effect of PMM
tbunch = linepass(si, bunch, 1:length(si)+1);
bunch_before_pmm = tbunch(:,get_bunch(si_pmm_idx(1), nr_particles));
create_new_x_phase_space_plot(bunch_before_pmm, 'bunch right before PMM kick');
bunch_after_pmm = tbunch(:,get_bunch(si_pmm_idx(end)+1, nr_particles));
create_new_x_phase_space_plot(bunch_after_pmm, 'bunch after PMM kick');
bunch = tbunch(:,get_bunch(length(si)+1, nr_particles));

% turns PMM kick off
si = sets_pmm(si, si_pmm_idx, 0.0, LPolyB);


% plots turn after turn
f = create_new_x_phase_space_plot(bunch, 'bunch after 1 turn');
bunch = linepass(si, bunch, length(si)+1);
f = create_new_x_phase_space_plot(bunch, 'bunch after 1 turn', f);




function si = sets_pmm(old_si, pmm_idx, strength, LPolyB)
si = old_si;
si_pmm_len = sum(getcellstruct(si, 'Length', pmm_idx));
PolynomB = LPolyB/si_pmm_len;
for i=pmm_idx
    si{i}.PolynomB = PolynomB; 
    si{i}.PolynomA = zeros(1,length(PolynomB));
    si{i}.MaxOrder = length(PolynomB)-1;
end


function indcs = get_bunch(element_idx, nr_particles)
indcs = (nr_particles*(element_idx-1)+1):(nr_particles*(element_idx));

function indcs = get_orbit(particle_idx, nr_particles, nr_elements)
indcs = particle_idx:nr_particles:nr_particles*nr_elements;


function handle = create_new_x_phase_space_plot(bunch, ptitle, fig_handle)

if ~exist('fig_handle','var')
    handle = figure; hold all;
else
    handle = fig_handle;
end
plot(1e3*bunch(1,:), 1e3*bunch(2,:), '.'); 
plot(1e3*bunch(1,1), 1e3*bunch(2,1), 'o', 'MarkerEdgeColor','r','MarkerFaceColor','r');
xlabel('rx/mm'); ylabel('px/mrad'); title(ptitle);