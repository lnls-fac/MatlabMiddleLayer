function machine = lnls_latt_err_correct_coupling(name, machine, coup)
% function machine = lnls_latt_err_correct_optics(name, machine, coup)
%
% Correct coupling of several machines.
%
% INPUTS:
%   name     : name of the file to which the inputs will be saved;
%   machine  : cell array of lattice models to symmetrize the optics.
%   coup     : structure with fields:
%      bpm_idx   - bpm indexes in the model;
%      hcm_idx   - horizontal correctors indexes in the model;
%      vcm_idx   - vertical correctors indexes in the model;
%      scm_idx   - indexes of the skew quads which will be used to symmetrize;
%      svs       - may be a number denoting how many singular values will be
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
%      respm - structure with fields M, S, V, U which are the coupling response
%         matrix and its SVD decomposition. If NOT present, the function
%         WILL CALCULATE the coupling response matrix for each machine.
%
% OUTPUT:
%   machine : cell array of lattice models with the orbit corrected.

coup.bpm_idx = sort(coup.bpm_idx);
coup.hcm_idx = sort(coup.hcm_idx);
coup.vcm_idx = sort(coup.vcm_idx);

nr_machines = length(machine);

calc_respm = false;
if ~isfield(coup,'respm'), calc_respm = true; end

coup2 = rmfield(coup,'respm');
save([name,'_correct_coup_input.mat'], 'coup2');

%if isnumeric(coup.svs), svs = num2str(coup.svs);else svs = coup.svs;end
fprintf('   number of svs used in correction: %i\n', coup.svs);
fprintf('   maximum number of correction iterations: %i\n', coup.max_nr_iter);
fprintf('   tolerance: %8.2e\n', coup.tolerance);

fprintf('\n');
fprintf('     -------------------------------------------------------------------------- \n');
fprintf('    | Max Kl |  chi2  | Tilt  |           Coup[%%]           | NIters | NRedStr |\n');
fprintf('    | [1/km] |        | [deg] |  Ey/Ex  | Tracking | Dy[mm] |        |         |\n');
fprintf('-------------------------------------------------------------------------------|\n');
for i=1:nr_machines
        R=0; T=0; D=0;
        try
            [T, Eta, ~, ~, R, ~, ~, ~, ~] = calccoupling(machine{i});
            D = 1000*sqrt(sum(Eta(3,:).^2)/size(Eta,2));
        end
        
        if calc_respm
            [respm, ~] = calc_respm_coupling(machine{i}, coup);
            coup.respm = respm;
        end
        RTr = mean(lnls_calc_emittance_coupling(machine{i}));
        [machine{i}, skewstr, iniFM, bestFM, iter, n_times] = coup_sg(machine{i}, coup);
        RTr2 = mean(lnls_calc_emittance_coupling(machine{i}));
        R2=0; T2=0; D2=0;
        try
            [T2, Eta2, ~, ~, R2, ~, ~, ~, ~] = calccoupling(machine{i});
            D2 = 1000*sqrt(sum(Eta2(3,:).^2)/size(Eta2,2));
        end
        %fprintf('%03i| skewstr[1/m^2] %+6.4f(max) %6.4f(std) | coup %8.5f (std) | tilt[deg] %5.2f -> %5.2f (std), k[%%] %5.2f -> %5.2f (std)\n', i, max(abs(skewstr)), std(skewstr), best_fm, std(Tilt)*180/pi, std(Tilt2)*180/pi, 100*Ratio, 100*Ratio2);
        fprintf('%03d | %6s | %6.3f | %5.2f | %7.3f | %7.3f  | %6.3f |  %4s  |  %4s   |\n',...
            i, ' ', iniFM, std(T)*180/pi,  100*[R, RTr], D, ' ',' ');  
        fprintf('%3s | %6.2f | %6.3f | %5.2f | %7.4f | %7.4f  | %6.3f |  %4d  |  %4d   |\n',...
            ' ', 1000*max(abs(skewstr)), bestFM, std(T2)*180/pi,  100*[R2, RTr2], D2, iter, n_times);
        fprintf('-------------------------------------------------------------------------------|\n');
end
