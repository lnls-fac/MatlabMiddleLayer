function machine = lnls_latt_err_correct_optics_loco(name, machine, optics, the_ring)
% function machine = lnls_latt_err_correct_optics(name, machine, optics, the_ring)
%
% Symmetrize optics of several machines.
%
% INPUTS:
%   name     : name of the file to which the inputs will be saved;
%   machine  : cell array of lattice models to symmetrize the optics.
%   the_ring : nominal model of the lattice, without errors. It will not be
%              used in the symmetrization process, it is only necessary to
%              estimate betabeatings;
%   optics   : structure with fields:
%      bpm_idx   - bpm indexes in the model;
%      hcm_idx   - horizontal correctors indexes in the model;
%      vcm_idx   - vertical correctors indexes in the model;
%      kbs_idx   - indexes of the knobs which will be used to symmetrize;
%      svs      - may be a number denoting how many singular values will be
%         used in the correction or the string 'all' to use all singular
%         values. Default: 'all';
%      max_nr_iter - maximum number of iteractions the correction
%         algortithm will perform at each call for each machine;
%      tolerance - if in two subsequent iteractions the relative difference
%         between the error function values is less than this value the
%         correction is considered to have converged and will terminate.
%      simul_bpm_corr_err - if true, the Gains field defined in the bpms  and 
%         the Gain field defined in the correctors in thelattice will be used
%         to simulate gain errors in these elements, changing the response
%         matrix calculated. Notice that the supra cited fields must exist
%         in the lattice models of the machine array for each bpm and corrector
%         in order for this this simulation to work. Otherwise an error will occur.
%      respm - structure with fields M, S, V, U which are the optics response
%         matrix and its SVD decomposition. If NOT present, the function
%         WILL CALCULATE the optics response matrix for each machine.
%      tune_goal - desired tune for the symmetrized machine.
%
% OUTPUT:
%   machine : cell array of lattice models with the orbit corrected.

optics.bpm_idx = sort(optics.bpm_idx);
optics.hcm_idx = sort(optics.hcm_idx);
optics.vcm_idx = sort(optics.vcm_idx);
optics.kbs_idx = sort(optics.kbs_idx);

nr_machines = length(machine);

save([name,'_correct_optics_input.mat'], 'optics');

fprintf(['Correcting Optics [' datestr(now) ']:\n']);
if isnumeric(optics.svs), svs = num2str(optics.svs);else svs = optics.svs;end
fprintf('\nNumber Of Singular Values : %4s\n',svs);
fprintf('Max Number of Correction iterations : %4d\n',optics.max_nr_iter);
fprintf('Tolerância : %7.2e\n\n', optics.tolerance);

fprintf('mac | Max Kl |  chi2  | dtunes | Betbeat (x/y) | eta @ss | NIters | NRedStr\n');
fprintf('    | [1/km] |        |  x1000 | rms[%%]        | Max[mm] |        |\n');
fprintf('%s',repmat('-',1,75));

mia = findcells(the_ring,'FamName','mia');
mib = findcells(the_ring,'FamName','mib');
mip = findcells(the_ring,'FamName','mip');
mi_all = [mia, mib, mip];

[twi0,tune0] = my_calctwiss(the_ring);
goal.twi_goal = twi0;
goal.tune_goal = tune0;
optics.respm = calc_respm_optics_loco(the_ring, optics, goal);

for k=1:nr_machines
        [twik,tunek] = my_calctwiss(machine{k});                
        [machine{k}, quadstr, iniFM, bestFM, iter, n_times] = optics_sg_loco(machine{k}, optics, goal);

        [twif,tunef]  = my_calctwiss(machine{k});

        dtune = sqrt(sum((tune0-tunek).^2))*1000;
        dbx = 100*sqrt(lnls_meansqr(( twi0.betax-twik.betax )./twi0.betax));
        dby = 100*sqrt(lnls_meansqr(( twi0.betay-twik.betay )./twi0.betay));
        fprintf('\n%03d | %6s | %6.3f | %6.3f | %5.2f / %5.2f |  %6.3f |  %4s  |  %4s \n',...
            k, ' ', iniFM, dtune, [dbx, dby],1000*max(twik.etax(mi_all)),' ',' ');
        dtune = sqrt(sum((tune0-tunef).^2))*1000;
        dbx = 100*sqrt(lnls_meansqr((twi0.betax-twif.betax)./twi0.betax));
        dby = 100*sqrt(lnls_meansqr((twi0.betay-twif.betay)./twi0.betay));
        fprintf('%3s | %6.2f | %6.3f | %6.3f | %5.2f / %5.2f |  %6.3f |  %4d  |  %4d \n',...
            ' ', 1000*max(abs(quadstr)), bestFM, dtune, [dbx,dby], 1000*max(twif.etax(mi_all)), iter, n_times);
        fprintf('%s',repmat('-',1,75));
end
fprintf('\n');


function [twi, tune] = my_calctwiss(ring, delta, idx)

if ~exist('delta','var'), delta = 0; end
if ~exist('idx','var'), idx = 1:(length(ring)+1); end

[TD, tune] = twissring(ring,delta,idx);

twi.pos = cat(1,TD.SPos);

beta = cat(1, TD.beta);
twi.betax = beta(:,1);
twi.betay = beta(:,2);

% alpha = cat(1, TD.alpha);
% twi.alphax = alpha(:,1);
%twi.alphay = alpha(:,2);

% mu = cat(1, TD.mu);
% twi.mux = mu(:,1);
% twi.muy = mu(:,2);

co = cat(1,TD.ClosedOrbit);
twi.cox  = co(1:4:end);
% twi.coxp = co(2:4:end);
% twi.coy  = co(3:4:end);
% twi.coyp = co(4:4:end);

eps = 1e-7;
Rou = findorbit4(ring, delta + eps, idx);
twi.etax = (Rou(1,:)' - twi.cox)/eps;

% function [betax, betay, tune] = calcbetas(the_ring)
% 
% [TD, tune] = twissring(the_ring,0,1:length(the_ring));
% beta = cat(1, TD.beta);
% betax = beta(:,1);
% betay = beta(:,2);