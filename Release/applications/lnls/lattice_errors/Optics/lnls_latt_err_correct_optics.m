function machine = lnls_latt_err_correct_optics(name, machine, optics, the_ring)
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

calc_respm = false;
if ~isfield(optics,'respm'), calc_respm = true; end

optics2 = optics;
if ~calc_respm, optics2 = rmfield(optics2,'respm'); end
save([name,'_correct_optics_input.mat'], 'optics2');

fprintf(['Correcting Optics [' datestr(now) ']:\n']);
if isnumeric(optics.svs), svs = num2str(optics.svs);else svs = optics.svs;end
fprintf('\nNumber Of Singular Values : %4s\n',svs);
fprintf('Max Number of Correction iterations : %4d\n',optics.max_nr_iter);
fprintf('Tolerância : %7.2e\n\n', optics.tolerance);

fprintf('mac | Max Kl |  chi2  | dtunes | Betbeat  | eta @ss | NIters | NRedStr\n');
fprintf('    | [1/km] |        |  x1000 | rms[%%]   | Max[mm] |        |\n');
fprintf('%s',repmat('-',1,69));

indcs = optics.bpm_idx';
indcs = indcs(logical(repmat([1,0,0,0,0,0,0,0,1],1,20)));
[bx0,by0,tune0] = calcbetas(the_ring);
for i=1:nr_machines
        [bxi,byi,tunei] = calcbetas(machine{i});
        etai = calc_dispersion(machine{i}, indcs)*1000;
        
        if calc_respm
            [respm, ~] = calc_respm_optics(machine{i}, optics);
            optics.respm = respm;
        end
        
        [machine{i}, quadstr, iniFM, bestFM, iter, n_times] = optics_sg(machine{i}, optics);
                            
        [bxf,byf,tunef]  = calcbetas(machine{i});
        etaf = calc_dispersion(machine{i}, indcs)*1000;

        dtune = sqrt(sum((tune0-tunei).^2))*1000;
        dbx = 100*sqrt(lnls_meansqr((bx0-bxi)./bx0));
        dby = 100*sqrt(lnls_meansqr((by0-byi)./by0));
        fprintf('\n%03d | %6s | %6.1f | %6.3f | %5.2f / %5.2f |  %5.3f  |  %4s  |  %4s \n',...
            i, ' ', iniFM, dtune, [dbx, dby],max(etai(1,:)),' ',' ');
        dtune = sqrt(sum((tune0-tunef).^2))*1000;
        dbx = 100*sqrt(lnls_meansqr((bx0-bxf)./bx0));
        dby = 100*sqrt(lnls_meansqr((by0-byf)./by0));
        fprintf('%3s | %6.2f | %6.3f | %6.3f | %5.2f / %5.2f |  %5.3f  |  %4d  |  %4d \n',...
            ' ', 1000*max(abs(quadstr)), bestFM, dtune, [dbx,dby], max(etaf(1,:)), iter, n_times);
        fprintf('%s',repmat('-',1,69));
end
fprintf('\n');


function [betax, betay, tune] = calcbetas(the_ring)

[TD, tune] = twissring(the_ring,0,1:length(the_ring));
beta = cat(1, TD.beta);
betax = beta(:,1);
betay = beta(:,2);