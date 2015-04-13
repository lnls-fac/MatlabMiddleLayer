function the_ring = booster_insert_segmented_models


the_ring = sirius_bo_lattice;


% calcs original tunes
fprintf('--- calc_ing original tunes ---\n');
[~, tunes0]  = twissring(the_ring,0,1:length(the_ring)+1);

%r = lnls_calc_optics(the_ring, '6d');

% inserts QD quadrupoles (renormalizes strengths)
fprintf('--- inserting segmented QD model ---\n');
idx     = findcells(the_ring, 'FamName', 'QD');
K0      = getcellstruct(the_ring, 'K', idx);
len0    = getcellstruct(the_ring, 'Length', idx);
intK0   = sum(K0 .* len0);
the_ring = insert_segmented_model(the_ring, fullfile('CONFIGS','BOOSTER_QD_MODELO2','ATMODEL.mat'), 'QD', 'MQD'); 
idx     = findcells(the_ring, 'FamName', 'QD');
K1      = getcellstruct(the_ring, 'K', idx);
len1    = getcellstruct(the_ring, 'Length', idx);
intK1   = sum(K1 .* len1);
the_ring = setcellstruct(the_ring, 'K', idx, K1 * (intK0/intK1));
the_ring = setcellstruct(the_ring, 'PolynomB', idx, K1 * (intK0/intK1), 1, 2);
fprintf('--- correcting tunes ---\n');
iter=1; 
while true
    [the_ring tunes dK] = local_correct_tunes(the_ring, tunes0, 'QF','QD');
    fprintf('%02i: %9.6f %9.6f <-> %9.6f %9.6f\n', iter, tunes0, tunes);
    if all(abs(tunes - tunes0) < 1e-6), break; end;
    iter = iter + 1;
end


% inserts QF quadrupoles (renormalizes strengths)
fprintf('--- inserting segmented QF model ---\n');
% shift model (so that qf can be substituted with its segmented model)
idx = findcells(the_ring, 'FamName', 'mlt');
the_ring = [the_ring(idx(1):end) the_ring(1:idx(1)-1)];
% inserts QF quadrupoles (renormalizes strengths)
idx     = findcells(the_ring, 'FamName', 'QF');
K0      = getcellstruct(the_ring, 'K', idx);
len0    = getcellstruct(the_ring, 'Length', idx);
intK0   = sum(K0 .* len0);
the_ring = insert_segmented_model(the_ring, fullfile('CONFIGS','BOOSTER_QF_MODELO4','ATMODEL.mat'), 'QF', 'MQF'); 
idx     = findcells(the_ring, 'FamName', 'QF');
K1      = getcellstruct(the_ring, 'K', idx);
len1    = getcellstruct(the_ring, 'Length', idx);
intK1   = sum(K1 .* len1);
%the_ring = lnls_set_quadrupole_factor(the_ring, idx, (intK0/intK1));
the_ring = setcellstruct(the_ring, 'K', idx, K1 * (intK0/intK1));
the_ring = setcellstruct(the_ring, 'PolynomB', idx, K1 * (intK0/intK1), 1, 2);
% shift model back to original
idx = findcells(the_ring, 'FamName', 'MQF');
the_ring = [the_ring(idx(1):end) the_ring(1:idx(1)-1)];
fprintf('--- correcting tunes ---\n');
iter=1; 
while true
    [the_ring tunes dK] = local_correct_tunes(the_ring, tunes0, 'QF','QD');
    fprintf('%02i: %9.6f %9.6f <-> %9.6f %9.6f\n', iter, tunes0, tunes);
    if all(abs(tunes - tunes0) < 1e-6), break; end;
    iter = iter + 1;
end

fprintf('--- inserting segmented B model ---\n');
the_ring = insert_segmented_model(the_ring, fullfile('CONFIGS','BOOSTER_B_MODELO1','ATMODEL.mat'), 'B', 'MB'); 
% % turing off kicks errors from dipole segmented model
idx = findcells(the_ring, 'FamName', 'B');
kick = getcellstruct(the_ring, 'PolynomB', idx, 1, 1);
ramp = linspace(0,1,20);

for i=1:length(ramp)
    fprintf('--- %f ---\n', ramp(i));
    the_ring = setcellstruct(the_ring, 'PolynomB', idx, ramp(i)*kick, 1, 1);
    fprintf('--- correcting tunes ---\n');
    iter=1;
    while true
        [the_ring tunes dK] = local_correct_tunes(the_ring, tunes0, 'QF','QD');
        fprintf('%02i: %9.6f %9.6f <-> %9.6f %9.6f\n', iter, tunes0, tunes);
        if all(abs(tunes - tunes0) < 1e-6), break; end;
        iter = iter + 1;
    end
end


function [the_ring tunes dK] = local_correct_tunes(the_ring0, tunes0, qf_famname, qd_famname)

the_ring = the_ring0;

% calcs initial parameters
idx_qf = findcells(the_ring, 'FamName', qf_famname);
idx_qd = findcells(the_ring, 'FamName', qd_famname);
len_qf = getcellstruct(the_ring, 'Length', idx_qf);
len_qd = getcellstruct(the_ring, 'Length', idx_qd);
K0_qf   = getcellstruct(the_ring, 'K', idx_qf);
K0_qd   = getcellstruct(the_ring, 'K', idx_qd);

% corrects tunes
[the_ring, ~, dK] = lnls_fittune(the_ring, tunes0, 'QF','QD');

% restores original K profile in quadrupoles
K1_qf   = getcellstruct(the_ring, 'K', idx_qf);
K1_qd   = getcellstruct(the_ring, 'K', idx_qd);
K2_qf   = K0_qf * (sum(len_qf.*K1_qf)/sum(len_qf.*K0_qf));
K2_qd   = K0_qd * (sum(len_qd.*K1_qd)/sum(len_qd.*K0_qd));
the_ring = setcellstruct(the_ring, 'K', idx_qf, K2_qf);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_qf, K2_qf, 1, 2);
the_ring = setcellstruct(the_ring, 'K', idx_qd, K2_qd);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_qd, K2_qd, 1, 2);

% calcs final tunes
[~, tunes]  = twissring(the_ring,0,1:length(the_ring)+1);







