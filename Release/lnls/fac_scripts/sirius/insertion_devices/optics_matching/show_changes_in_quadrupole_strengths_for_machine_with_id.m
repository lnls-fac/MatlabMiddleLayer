function show_changes_in_quadrupole_strengths_for_machine_with_id(the_ring2, the_ring1)

clc;

% loads the_ring
if ~exist('the_ring','var')
    load('the_ring.mat'); the_ring1 = the_ring;
    load('the_ring_withids.mat'); the_ring2 = the_ring;
end

idx1 = setdiff(findcells(the_ring1, 'K'), findcells(the_ring1, 'BendingAngle'));
idx2 = setdiff(findcells(the_ring2, 'K'), findcells(the_ring2, 'BendingAngle'));
K1 = getcellstruct(the_ring1, 'K', idx1);
K2 = getcellstruct(the_ring2, 'K', idx2);

idx = 1; mia_nr = 1; mib_nr = 1; max_abs_var = 0; current_id = '';
for i=1:length(the_ring2)
    if strcmpi(the_ring2{i}.FamName, 'mia')
        fprintf('[ MIA-%02i ]\n', mia_nr);
        mia_nr = mia_nr + 1;
    end
    if strcmpi(the_ring2{i}.FamName, 'mib')
        fprintf('[ MIB-%02i ]\n', mib_nr);
        mib_nr = mib_nr + 1;
    end
    if isfield(the_ring{i},'K') && ~isfield(the_ring{i}, 'BendingAngle')
        k1 = the_ring1{idx1(idx)}.K; idx = idx + 1;
        k2 = the_ring2{i}.K;
        dk = 100*(k2-k1)/abs(k1);
        if (abs(dk) > max_abs_var), max_abs_var = abs(dk); end
        fprintf('%10s : K1 %+09.6f, K2 %+09.6f, dK %+09.6f, dK %+6.2f %%\n', the_ring{i}.FamName, k1, k2, k2-k1, dk);
    end
    if isfield(the_ring{i}, 'XGrid') && ~strcmpi(the_ring{i}.FamName, current_id)
        fprintf('<%s>\n', the_ring{i}.FamName);
        current_id = the_ring{i}.FamName;
    end
    if strcmpi(the_ring{i}.FamName, 'mb1')
        fprintf('---\n');
    end
end
fprintf('\n\n');

fprintf('SUMMARY OF QUAD VARIATIONS WITH ID SET\n')
fprintf('======================================\n')
fprintf('Max. variation dK: %+6.2f\n', max_abs_var);

get_max_deltas_from_quadrupole_model('q14', the_ring1, the_ring2)
get_max_deltas_from_quadrupole_model('q20', the_ring1, the_ring2)
get_max_deltas_from_quadrupole_model('q30', the_ring1, the_ring2)

function get_max_deltas_from_quadrupole_model(quad_model, the_ring1, the_ring2)

ao = getao();
fams = findmemberof(quad_model);
max_pos_K1     = 0;
max_pos_K2     = 0;
max_pos_delta  = 0;
max_pos_family = ''; 
max_neg_K1     = 0;
max_neg_K2     = 0;
max_neg_delta  = 0;
max_neg_family = ''; 
for i=1:length(fams)
    idx1 = findcells(the_ring1, 'FamName', fams{i});
    idx2 = findcells(the_ring2, 'FamName', fams{i});
    K1 = getcellstruct(the_ring1, 'PolynomB', idx1, 1, 2);
    K2 = getcellstruct(the_ring2, 'PolynomB', idx2, 1, 2);
    deltaK = K2 - K1;
    pos = deltaK > 0;
    [maxposdelta, idx] = max(deltaK(pos));
    if (maxposdelta > max_pos_delta)
        tmp = K1(pos); max_pos_K1 = tmp(idx);
        tmp = K2(pos); max_pos_K2 = tmp(idx);
        tmp = deltaK(pos); max_pos_delta = tmp(idx);
        max_pos_family = fams{i}; 
    end
    neg = deltaK < 0;
    [maxnegdelta, idx] = min(deltaK(neg));
    if (maxnegdelta < max_neg_delta)
        tmp = K1(neg); max_neg_K1 = tmp(idx);
        tmp = K2(neg); max_neg_K2 = tmp(idx);
        tmp = deltaK(neg); max_neg_delta = tmp(idx);
        max_neg_family = fams{i}; 
    end
end
if strcmp(max_pos_family,'')
    fprintf('%s: has not positive delta K\n', quad_model);
else
    fprintf('%s: max pos. delta at %5s, from %+6.4f to %+6.4f, (%+4.1f %%). \n', quad_model, max_pos_family, max_pos_K1, max_pos_K2, 100*(max_pos_K2-max_pos_K1)/max_pos_K1);
end
if strcmp(max_neg_family,'')
    fprintf('%s: has no negative delta K\n', quad_model);
else
    fprintf('%s: max neg. delta at %5s, from %+6.4f to %+6.4f, (%+4.1f %%). \n', quad_model, max_neg_family, max_neg_K1, max_neg_K2, 100*(max_neg_K2-max_neg_K1)/max_neg_K1);
end