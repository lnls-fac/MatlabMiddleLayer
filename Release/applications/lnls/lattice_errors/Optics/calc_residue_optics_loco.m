function v = calc_residue_optics_loco(ring, optics, goal)

BETAW = 1e2; % order of centimeters
DISPW = 1e4; % order of tenth of milimeters
TUNEW = 1e4; % order of 10^-2

twi0 = goal.twi_goal;
tune0 = goal.tune_goal;

hcm_idx = sort(optics.hcm_idx);
vcm_idx = sort(optics.vcm_idx);
bpm_idx = sort(optics.bpm_idx);

[twi1,tune1] = my_calctwiss(ring, 0, 1:length(ring)+1);

vbx = [twi1.betax(bpm_idx) - twi0.betax(bpm_idx); twi1.betax(hcm_idx) - twi0.betax(hcm_idx)];
vby = [twi1.betay(bpm_idx) - twi0.betay(bpm_idx); twi1.betay(vcm_idx) - twi0.betay(vcm_idx)];
vdx = (twi1.etax(bpm_idx)  - twi0.etax(bpm_idx));
vtune = (tune1 - tune0)';

v = [BETAW*vbx/length(vbx); BETAW*vby/length(vby); ...
     DISPW*vdx/length(vdx); TUNEW*vtune/length(vtune)];

function [twi, tune] = my_calctwiss(ring, delta, ind)
[TD, tune] = twissring(ring,delta,ind);

twi.pos = cat(1,TD.SPos);

beta = cat(1, TD.beta);
twi.betax = beta(:,1);
twi.betay = beta(:,2);

% alpha = cat(1, TD.alpha);
% twi.alphax = alpha(:,1);
% twi.alphay = alpha(:,2);

% mu = cat(1, TD.mu);
% twi.mux = mu(:,1);
% twi.muy = mu(:,2);

co = cat(1,TD.ClosedOrbit);
twi.cox  = co(1:4:end);
% twi.coxp = co(2:4:end);
% twi.coy  = co(3:4:end);
% twi.coyp = co(4:4:end);

eps = 1e-6;
Rou = findorbit4(ring, delta + eps, ind);
twi.etax = (Rou(1,:)' - twi.cox)/eps;
