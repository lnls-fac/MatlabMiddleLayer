function [respm, info] = calc_respm_coupling(the_ring, coup, lattice_symmetry, info)

coup.bpm_idx = sort(coup.bpm_idx);
coup.hcm_idx = sort(coup.hcm_idx);
coup.vcm_idx = sort(coup.vcm_idx);

if ~exist('lattice_symmetry','var'), lattice_symmetry = 1; end

if ~exist('info','var'), info = collect_info_coup(the_ring, coup, lattice_symmetry);end

[~, Mxy, Myx, ~, ~, Dispy] = prepare_data_for_symm(the_ring, coup, info{1}.M, info{1}.Disp);
v = calc_residue_coupling(Mxy, Myx, Dispy, coup.bpm_idx, coup.hcm_idx, coup.vcm_idx);
M = zeros(length(v),length(info));
M(:,1) = v;
for i = 2:length(info)
    [~, Mxy, Myx, ~, ~, Dispy] = prepare_data_for_symm(the_ring, coup, info{i}.M, info{i}.Disp);
    M(:,i) = calc_residue_coupling(Mxy, Myx, Dispy, coup.bpm_idx, coup.hcm_idx, coup.vcm_idx);
end


respm.M = M;
[U,S,V] = svd(M,'econ');
respm.U = U;
respm.V = V;
respm.S = S;

sv = diag(S);
fprintf('   number of singular values: %03i\n', length(sv));
fprintf('   singular values: %f,%f,%f ... %f,%f,%f\n', sv(1),sv(2),sv(3),sv(end-2),sv(end-1),sv(end));
