function [respm, info] = calc_respm_optics(the_ring, optics, nper, info)

optics.bpm_idx = sort(optics.bpm_idx);
optics.hcm_idx = sort(optics.hcm_idx);
optics.vcm_idx = sort(optics.vcm_idx);
optics.kbs_idx = sort(optics.kbs_idx);

if ~exist('nper','var'), nper = 1; end

if ~exist('info','var'), info = collect_info_optics(the_ring, optics, nper);end

Tsym = findcells(the_ring,'FamName','mia');
Msym = sort([Tsym, findcells(the_ring,'FamName','mib')]);
Msym = Msym(1:length(Msym)/2);

lnls_create_waitbar('Calculating Optics Response Matrix',0.5,length(info));

[Mxx, ~, ~, Myy, Dispx, ~] = prepare_data_for_symm(the_ring, optics, info{1}.M, info{1}.Disp);
v = calc_residue_optics(Mxx, Myy, Dispx, info{1}.Tune, [0,0], optics.bpm_idx, ...
                        optics.hcm_idx, optics.vcm_idx, Tsym, Msym);
M = zeros(length(v),length(info));
M(:,1) = v;
lnls_update_waitbar(1)
for i = 2:length(info)
    [Mxx, ~, ~, Myy, Dispx, ~] = prepare_data_for_symm(the_ring, optics, info{i}.M, info{i}.Disp);
    M(:,i) = calc_residue_optics(Mxx, Myy, Dispx, info{i}.Tune, [0,0], optics.bpm_idx, ...
                                optics.hcm_idx, optics.vcm_idx, Tsym, Msym);
    lnls_update_waitbar(i)
end
lnls_delete_waitbar;


respm.M = M;
[U,S,V] = svd(M,'econ');
respm.U = U;
respm.V = V;
respm.S = S;

