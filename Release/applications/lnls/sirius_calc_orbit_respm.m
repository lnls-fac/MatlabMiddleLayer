function respm = sirius_calc_orbit_respm(the_ring, feedback_type)

% prepares nominal machine
if ~exist('the_ring','var')
    global THERING;
    the_ring = THERING;
end
the_ring = setradiation('off',the_ring); the_ring = setcavity('off',the_ring);

if ~exist('feedback_type','var')
    feedback_type = 'sofb';
end

% finds indices of FB elements
data = sirius_si_family_data(the_ring);
sofb_hcm_idx = data.chs.ATIndex;
sofb_vcm_idx = data.cvs.ATIndex;
sofb_bpm_idx = data.bpm.ATIndex;
fofb_hcm_idx = data.chf.ATIndex;
fofb_vcm_idx = data.cvf.ATIndex;
fofb_bpm_idx = data.rbpm.ATIndex;
if strcmpi(feedback_type, 'sofb')
    hcm = sofb_hcm_idx;
    vcm = sofb_vcm_idx;
    bpm = sofb_bpm_idx;
else
    hcm = fofb_hcm_idx;
    vcm = fofb_vcm_idx;
    bpm = fofb_bpm_idx;
end
    
kicksize = 10e-6;
M = zeros(2*size(bpm,1), size(hcm,1)+size(vcm,1));

for i=1:size(hcm,1)
    new_ring = lnls_set_kickangle(the_ring, +kicksize/2.0, hcm(i,:), 'x');
    co_pos = findorbit4(new_ring, 0, bpm);
    new_ring = lnls_set_kickangle(the_ring, -kicksize/2.0, hcm(i,:), 'x');
    co_neg = findorbit4(new_ring, 0, bpm);
    M(:,i) = [co_pos(1,:) - co_neg(1,:), co_pos(3,:) - co_neg(3,:)]/kicksize; 
end

for i=1:size(vcm,1)
    new_ring = lnls_set_kickangle(the_ring, +kicksize/2.0, vcm(i,:), 'y');
    co_pos = findorbit4(new_ring, 0, bpm);
    new_ring = lnls_set_kickangle(the_ring, -kicksize/2.0, vcm(i,:), 'y');
    co_neg = findorbit4(new_ring, 0, bpm);
    M(:,size(hcm,1)+i) = [co_pos(1,:) - co_neg(1,:), co_pos(3,:) - co_neg(3,:)]/kicksize; 
end

respm.M = M;
[U,S,V] = svd(M,'econ');
respm.U = U;
respm.V = V;
respm.S = S;



