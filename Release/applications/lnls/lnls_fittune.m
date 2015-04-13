function [the_ring tunes1 dK] = lnls_fittune(the_ring0, goal_tunes, q1, q2, step_K)

if ~exist('step_K','var'), step_K=0.001; end;


% builds indices of knob quadupoles
q1_idx = {};
if iscell(q1)
    for i=1:length(q1)
        q1_idx{end+1} = findcells(the_ring0, 'FamName', q1{i});
    end
else
    q1_idx{1} = findcells(the_ring0, 'FamName', q1);
end
q2_idx = {};
if iscell(q2)
    for i=1:length(q2)
        q2_idx{end+1} = findcells(the_ring0, 'FamName', q2{i});
    end
else
    q2_idx{1} = findcells(the_ring0, 'FamName', q2);
end

% initial tunes
[~, tunes0]  = twissring(the_ring0,0,1:length(the_ring0)+1);

% varying Q1
the_ring = the_ring0;
q = q1_idx;
for i=1:length(q)
    K = getcellstruct(the_ring, 'K', q{i});
    newK = K + step_K/2;
    the_ring = setcellstruct(the_ring, 'K', q{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', q{i}, newK, 1, 2);
end
[~, tunes_p]  = twissring(the_ring,0,1:length(the_ring)+1);
the_ring = the_ring0;
for i=1:length(q)
    K = getcellstruct(the_ring, 'K', q{i});
    newK = K - step_K/2;
    the_ring = setcellstruct(the_ring, 'K', q{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', q{i}, newK, 1, 2);
end
[~, tunes_n]  = twissring(the_ring,0,1:length(the_ring)+1);
M(:,1) = (tunes_p - tunes_n)/step_K;

% varying Q2
the_ring = the_ring0;
q = q2_idx;
for i=1:length(q)
    K = getcellstruct(the_ring, 'K', q{i});
    newK = K + step_K/2;
    the_ring = setcellstruct(the_ring, 'K', q{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', q{i}, newK, 1, 2);
end
[~, tunes_p]  = twissring(the_ring,0,1:length(the_ring)+1);
the_ring = the_ring0;
for i=1:length(q)
    K = getcellstruct(the_ring, 'K', q{i});
    newK = K - step_K/2;
    the_ring = setcellstruct(the_ring, 'K', q{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', q{i}, newK, 1, 2);
end
[~, tunes_n]  = twissring(the_ring,0,1:length(the_ring)+1);
M(:,2) = (tunes_p - tunes_n)/step_K;

% calcs factor
v(:,1) = goal_tunes(:) - tunes0(:);
dK = (M \ v);

% applies factor
the_ring = the_ring0;
for i=1:length(q1_idx)
    K = getcellstruct(the_ring, 'K', q1_idx{i});
    newK = K + dK(1);
    the_ring = setcellstruct(the_ring, 'K', q1_idx{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', q1_idx{i}, newK, 1, 2);
end
for i=1:length(q2_idx)
    K = getcellstruct(the_ring, 'K', q2_idx{i});
    newK = K + dK(2);
    the_ring = setcellstruct(the_ring, 'K', q2_idx{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', q2_idx{i}, newK, 1, 2);
end
[~, tunes1]  = twissring(the_ring,0,1:length(the_ring)+1);

%fprintf('%f %f -> %f %f\n', dK, tunes1);














