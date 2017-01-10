function respm = calc_respm_optics_loco(the_ring, optics, goal)

hcm_idx = sort(optics.hcm_idx);
vcm_idx = sort(optics.vcm_idx);
bpm_idx = sort(optics.bpm_idx);
kbs_idx = sort(optics.kbs_idx);

sym = optics.symmetry;

nb = [1, length(bpm_idx), length(hcm_idx), length(bpm_idx), ...
    length(vcm_idx), length(bpm_idx)];

kbs_idx = kbs_idx( 1:length(kbs_idx)/sym );
v0 = calc_residue_optics_loco(the_ring, optics, goal);

eps = 1e-4;
K0 = knobs_get_values(the_ring, optics.kbs_idx);
M = zeros(sum(nb(2:end))+2,sym*length(kbs_idx));
for ii = 1:length(kbs_idx)
    K1 = K0;
    K1(ii) = K1(ii) + eps;
    ring1 = knobs_set_values(the_ring,kbs_idx,K1);
    v = calc_residue_optics_loco(ring1, optics, goal);
    dv = v - v0;
    
    for k = 1:length(nb)-1
        Mdv{k} = dv(sum(nb(1:k)):sum(nb(2:k+1)))/eps;
    end
    dTune = dv([end-1,end])/eps;
    
    for k = 0:(sym-1)
        M_aux = [];
        for l = 1:length(Mdv);
            M_aux = [M_aux; circshift(Mdv{l},k*length(Mdv{l})/sym)];
        end
        M_aux = [M_aux; dTune];
        M(:,ii+k*length(kbs_idx)) = M_aux;
    end
end

respm.M = M;
[U,S,V] = svd(M,'econ');
respm.U = U;
respm.V = V;
respm.S = S;

function values = knobs_get_values(ring, idx)
for ii=1:length(idx)
    values(ii) = ring{idx(ii)}.PolynomB(2);
end

function ring = knobs_set_values(ring,idx,values)
for ii=1:length(idx)
    ring = setcellstruct(ring,'PolynomB',idx(ii),values(ii),1,2);
end
