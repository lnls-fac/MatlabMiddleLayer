function the_ring = lnls_insert_kicktable(the_ring0, idx_pos, id, strength, length_scale)
% the_ring = lnls_insert_kicktable(the_ring0, idx_pos, id)
% INPUTS:
%  the_ring - AT model of the lattice;
%  idx_pos  - index of the element where to insert the kicktable;
%  strength - fraction of the kick defined in the kicktable file
%             which will be applied to the AT element to be inserted;
%  id       - structure with information regarding the id. Fields:
%    kicktable_file - path to the kicktable file;
%    nr_segs        - number of segmets of the kicktable;
%    label          - family name of the element which will be inserted;

file_name = id.kicktable_file;
nsegs     = id.nr_segs;
famname   = id.label;

if ~exist('strength','var'), strength = 1; end
if ~exist('length_scale','var'), length_scale = 1; end

% reads kicktable
[posx, posy, kickx, kicky, id_length] = lnls_read_kickmap_file(file_name);

% id_length normalization
id_length = id_length * length_scale;

% calculates indices of elements in the location of insertion
idx_dws = idx_pos+1;
while any(strcmpi(the_ring0{idx_dws}.PassMethod, 'DriftPass'))
    idx_dws = idx_dws + 1;
end
idx_dws = idx_dws - 1;

idx_ups = idx_pos-1;
while any(strcmpi(the_ring0{idx_ups}.PassMethod, 'DriftPass'))
    idx_ups = idx_ups - 1;
end
idx_ups = idx_ups + 1;

lens_ups = getcellstruct(the_ring0, 'Length', idx_ups:idx_pos);
lens_dws = getcellstruct(the_ring0, 'Length', idx_pos:idx_dws);

% builds the id flanking drifts in the line
ups_drift = the_ring0{idx_ups};
dws_drift = the_ring0{idx_dws};
ups_drift.PassMethod = 'DriftPass';
dws_drift.PassMethod = 'DriftPass';
ups_drift.Length = sum(lens_ups) - (id_length/2);
dws_drift.Length = sum(lens_dws) - (id_length/2);
if (ups_drift.Length < 0) || (dws_drift.Length < 0)
    error(['there is no space to insert id ' file_name ' within the defined location!']);
end

if (mod(nsegs, 2) ~= 0)
    error('nsegs should be even...');
end

half_id = idthickkickmap([famname '_kicktable'], id_length/2, (nsegs/2), posx, posy, (strength/2) * kickx, (strength/2) * kicky, 'LNLSThickEPUPass');
half_id = buildlat(half_id);
half_id{1}.VChamber = [max(abs(posx(:))) max(abs(posy(:))) 1];
half_id = half_id(1);
half_id{1}.Energy = the_ring0{idx_pos}.Energy;

% finally builds lattice with id
the_ring = [the_ring0(1:(idx_ups-1)) ups_drift half_id the_ring0{idx_pos} half_id dws_drift the_ring0((idx_dws+1):end)];
