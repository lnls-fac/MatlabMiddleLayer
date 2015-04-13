function the_ring = add_kick_elements_at_id_locations(the_ring_original, nr_kicks)
% the_ring = add_kick_elements_at_id_locations(the_ring_original)
%
% Substitutes driftspaces at the ID locations for drift_kick_drift elements
% in order to simulate the ID dipolar field errors.
%
% the_ring_original: original THERING model
% nr_kicks: number of kicks modelling dipolar field error for each ID
%
% obs.: this scripts is particular to the current (2013-04-17) SIRIUS
% model: it finds the ID straight sections by looking at 'mia' and 'mib'
% familyname elements. It also assumes that there are driftspaces upstream and
% downstream markers 'mia' and 'mib' that will host the ID.


% gets indices for the ID straight markers
mia = findcells(the_ring_original, 'FamName', 'mia');
mib = findcells(the_ring_original, 'FamName', 'mib');
ids = sort([mia mib]);

% finds US and DS indices for the ID straight sections
nr_kicks = ceil(nr_kicks); if ((nr_kicks/2) ~= floor(nr_kicks/2)), nr_kicks = nr_kicks + 1; end; % nr_kicks -> even int
for i=1:length(ids)
    us(i) = ids(i); while (~strcmpi(the_ring_original{us(i)}.PassMethod, 'DriftPass')), us(i) = us(i) - 1; if (us(i) < 1), us(i) = length(the_ring_original); end; end;
    ds(i) = ids(i); while (~strcmpi(the_ring_original{ds(i)}.PassMethod, 'DriftPass')), ds(i) = ds(i) + 1; if (ds(i) > length(the_ring_original)), ds(i) = 1; end; end;
    IDKicksUS{i} = gen_kicks(the_ring_original, us(i), nr_kicks/2);
    IDKicksDS{i} = gen_kicks(the_ring_original, ds(i), nr_kicks/2);
end

% inserts distributed dipolar errors in the lattice model
the_ring = {};
for i=1:length(the_ring_original)
    idxus = find(i == us); idxds = find(i == ds);
    if ~isempty(idxus)
        the_ring = [the_ring IDKicksUS{idxus}];
    elseif ~isempty(idxds)
        the_ring = [the_ring IDKicksUS{idxds}];
    else
        the_ring = [the_ring the_ring_original{i}];
    end  
end


function IDKicks = gen_kicks(the_ring, i, nr_kicks)

drift_element = the_ring{i};

L = drift_element.Length;
d = drift('IDKICKS', L/nr_kicks/2, 'DriftPass');
k = corrector('IDKICKS',0, [0 0], 'CorrectorPass');
ring = [];
for i=1:nr_kicks
    ring = [ring d k d];
end
IDKicks = buildlat(ring);
