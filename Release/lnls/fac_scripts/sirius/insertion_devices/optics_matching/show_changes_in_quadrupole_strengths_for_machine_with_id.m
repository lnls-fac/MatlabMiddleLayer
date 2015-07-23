function show_changes_in_quadrupole_strengths_for_machine_with_id(the_ring1,the_ring2)

if ~exist('the_ring1','var'), load('the_ring0.mat'); the_ring1 = the_ring0;end
if ~exist('the_ring2','var'), load('the_ring_withids.mat'); the_ring2 = the_ring_glob; end
if ~exist('knobs','var'), knobs = {'qda','qfa','qdb1','qdb2','qfb'};end

idx1 = findcells(the_ring1,'FamName','mc'); idx1 = idx1(end);
the_ring1 = circshift(the_ring1',[0,-idx1]);
idx2 = findcells(the_ring2,'FamName','mc'); idx2 = idx2(end);
the_ring2 = circshift(the_ring2',[0,-idx2]);

mc1 = sort([1,findcells(the_ring1,'FamName','mc'),length(the_ring1)]);
mc2 = sort([1,findcells(the_ring2,'FamName','mc'),length(the_ring2)]);

for i=1:20
    the_line1 = the_ring1(mc1(i):mc1(i+1));
    the_line2 = the_ring2(mc2(i):mc2(i+1));
    
    idx = findcells(the_line2,'XGrid');
    if ~isempty(idx), id_name = ['<',the_line2{idx(1)}.FamName, '>'];
    else id_name = 'No ID'; end
    if mod(i,2), fprintf('[ %02d-MIB ] --> %s\n', i, id_name);
    else fprintf('[ %02d-MIA ] --> %s\n', i, id_name); end
    
    idx1 = setdiff(findcells(the_line1, 'K'), findcells(the_line1, 'BendingAngle'));
    idx2 = setdiff(findcells(the_line2, 'K'), findcells(the_line2, 'BendingAngle'));
    K1 = getcellstruct(the_line1, 'PolynomB', idx1, 1, 2);
    K2 = getcellstruct(the_line2, 'PolynomB', idx2, 1, 2);
    fam_name = getcellstruct(the_line2, 'FamName', idx2);
    
    for ii=1:length(K1)
        if any(strcmp(fam_name{ii},knobs))
            fprintf('%10s : K1 %+09.6f, K2 %+09.6f, dK %+09.6f, dK %+6.2f %%\n',...
                fam_name{ii}, K1(ii), K2(ii), K2(ii)-K1(ii), (K2(ii)-K1(ii))/K1(ii)*100);
        end
    end
    fprintf('---\n');
end

%Max quadrupole strengths
maxK14 = -3.74;
maxK20 = 4.54;
maxK30 = 4.54;

fprintf('SUMMARY OF QUAD VARIATIONS WITH ID SET\n')
fprintf('======================================\n')
fprintf('Max q14 quadrupole Strength: %6.2f\n',maxK14);
fprintf('Max q20 quadrupole Strength: %6.2f\n',maxK20);
fprintf('Max q30 quadrupole Strength: %6.2f\n',maxK30);

get_max_deltas_from_quadrupole_model('q14', the_ring1, the_ring2, maxK14)
get_max_deltas_from_quadrupole_model('q20', the_ring1, the_ring2, maxK20)
get_max_deltas_from_quadrupole_model('q30', the_ring1, the_ring2, maxK30)

function get_max_deltas_from_quadrupole_model(quad_model, the_ring1, the_ring2, maxK)

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
    fprintf('%s: max pos. delta at %5s, from %+6.4f to %+6.4f, (%+4.1f %%). \n',...
        quad_model, max_pos_family, max_pos_K1, max_pos_K2, 100*(max_pos_K2-max_pos_K1)/maxK);
end
if strcmp(max_neg_family,'')
    fprintf('%s: has no negative delta K\n', quad_model);
else
    fprintf('%s: max neg. delta at %5s, from %+6.4f to %+6.4f, (%+4.1f %%). \n',...
        quad_model, max_neg_family, max_neg_K1, max_neg_K2, 100*(max_neg_K2-max_neg_K1)/maxK);
end