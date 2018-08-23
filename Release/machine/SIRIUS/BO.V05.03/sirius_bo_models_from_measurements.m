function the_ring = sirius_bo_models_from_measurements(the_ring0)

the_ring = models_from_measurements_dipoles(the_ring0);
the_ring = correct_optics(the_ring);


function the_ring = correct_optics(the_ring0)

% see 'set_magnets_strength_booster.m' file with strength values.
goal_tunes = [19.20433, 7.31417];
goal_chrom = [0.5, 0.5];
the_ring = the_ring0;
idx_qf = findcells(the_ring, 'FamName', 'QF');
idx_qd = findcells(the_ring, 'FamName', 'QD');
idx_sf = findcells(the_ring, 'FamName', 'SF');
idx_sd = findcells(the_ring, 'FamName', 'SD');
the_ring = setcellstruct(the_ring, 'PolynomB', idx_qf, +1.653749039924653, 1, 2);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_qd, -0.102503665792927, 1, 2);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_sf, +11.253921969396233, 1, 3);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_sd, +11.095043319723608, 1, 3);
ats = atsummary(the_ring);
if any(abs(ats.tunes - goal_tunes) > 0.00001) || any(abs(ats.chromaticity - goal_chrom) > 0.01)
    for i=1:8
        the_ring = fitchrom2(the_ring, goal_chrom, 'SD', 'SF');
        [the_ring, conv, t2, t1] = lnls_correct_tunes(the_ring, goal_tunes, {'QF','QD'}, 'svd', 'add', 10, 1e-9);
    end
    fprintf('   Tunes and Chromaticities corrected!\n');
    fprintf('   qf_strength = %f;\n', the_ring{idx_qf(1)}.PolynomB(2));
    fprintf('   qd_strength = %f;\n', the_ring{idx_qd(1)}.PolynomB(2));
    fprintf('   sf_strength = %f;\n', the_ring{idx_sf(1)}.PolynomB(3));
    fprintf('   sd_strength = %f;\n', the_ring{idx_sd(1)}.PolynomB(3));
end


function the_ring = models_from_measurements_dipoles(the_ring0)
the_ring = the_ring0;

data = sirius_bo_family_data(the_ring);
idx = data.B.ATIndex;

[tpath, ~, ~] = fileparts(mfilename('fullpath'));
sorting = sirius_bo_importfile_sorting(fullfile(tpath, 'models-dipoles', 'sorting.txt'));

d2r = pi / 180.0;
ang_nominal = 7.2;

% get dipole nominal model
model_sim = [ getcellstruct(the_ring, 'Length', idx(1,:)), getcellstruct(the_ring, 'BendingAngle', idx(1,:)) / d2r];
    
for i=1:length(sorting)
    % load instance of dipole model
    maglabel = fullfile(tpath, 'models-dipoles', [sorting{i}, '-3gev']);
    [harms, model] = sirius_bo_load_fmap_model(maglabel);
    if length(the_ring{idx(i, 1)}.PolynomB) ~= length(harms)
        error('Incompatible PolynomB and dipole model!')
    end
    % redistribute deflection angle, as compared in model segments
    ang_error = model(1, 3) * model(1, 1) + model(end, 3) * model(end, 1); % angle missing from segmodel
    ang_total = ang_nominal + ang_error / d2r; % total angle of dipole instance
    ang_segs = model(:,2) * (ang_total / ang_nominal); % renormalize sigment angles according to tot angle
    dang = ang_segs - model_sim(:,2); % difference between dipole instance and nominal dipole segment angles
    dpolB = (dang * d2r) ./ model(:,1); % converted to polynomB
    for j=1:size(idx,2)
        the_ring{idx(i, j)}.PolynomB = model(j,3:end); % higher-order multipoles from instance dipole (quad, sext, ...)
        the_ring{idx(i, j)}.PolynomB(1) = dpolB(j); % dipolar errors applied to segments
    end
end