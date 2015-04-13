function [the_ring, hkicks, vkicks, codx, cody, iter, n_times] = cod_sg(orbit, the_ring, goal_codx, goal_cody)

if ~exist('goal_codx','var'), goal_codx = zeros(1,size(orbit.bpm_idx,1)); end
if ~exist('goal_cody','var'), goal_cody = zeros(1,size(orbit.bpm_idx,1)); end
if ~isfield(orbit,'tolerance'), orbit.tolerance = 1e-5; end
tol = abs(orbit.tolerance);

scale_x = 200e-6;
scale_y = 200e-6;

S = orbit.respm.S;
U = orbit.respm.U;
V = orbit.respm.V;

corr_list = [orbit.hcm_idx(:); orbit.vcm_idx(:)];

if ischar(orbit.svs) && strcmpi(orbit.svs, 'all')
    sing_vals = min(size(S));
else
    sing_vals = orbit.svs;
end

% selection of singular values
iS = diag(1./diag(S));
diS = diag(iS);
diS(sing_vals+1:end) = 0;
iS = diag(diS);
CM = -(V*iS*U');

dim = get_dim(the_ring);

[codx, cody] = calc_cod(the_ring, dim);
best_fm = sqrt(lnls_meansqr([(codx(orbit.bpm_idx)-goal_codx)/scale_x, ...
               (cody(orbit.bpm_idx)-goal_cody)/scale_y]));
best_corr = the_ring(corr_list);
factor = 1;
n_times = 0;
for iter = 1:orbit.max_nr_iter
    % calcs kicks
    [codx, cody] = calc_cod(the_ring, dim);
    delta_kick = factor*CM * [codx(orbit.bpm_idx)' - goal_codx(:);...
                              cody(orbit.bpm_idx)' - goal_cody(:)];
    % sets kicks
    delt_hkicks = delta_kick(1:size(orbit.hcm_idx,1))';
    delt_vkicks = delta_kick((1+size(orbit.hcm_idx,1)):end)';
    init_hkicks = lnls_get_kickangle(the_ring, orbit.hcm_idx, 'x');
    init_vkicks = lnls_get_kickangle(the_ring, orbit.vcm_idx, 'y');
    tota_hkicks = init_hkicks + delt_hkicks;
    tota_vkicks = init_vkicks + delt_vkicks;
    the_ring = lnls_set_kickangle(the_ring, tota_hkicks, orbit.hcm_idx, 'x');
    the_ring = lnls_set_kickangle(the_ring, tota_vkicks, orbit.vcm_idx, 'y');
    [codx, cody] = calc_cod(the_ring, dim);
    fm = sqrt(lnls_meansqr([(codx(orbit.bpm_idx)-goal_codx)/scale_x, ...
              (cody(orbit.bpm_idx)-goal_cody)/scale_y]));
    residue = abs(best_fm-fm)/best_fm;
    if (fm < best_fm)
        best_fm      = fm;
        best_corr    = the_ring(corr_list);
        factor = 1; % reset the correction strength to 1
    else
        the_ring(corr_list) = best_corr;
        factor = factor * 0.75; % reduces the strength of the correction
        n_times = n_times + 1; % to check how many times it passed here
    end
    % breaks the loop in case convergence is reached
    if residue < tol
        break;
    end
end
hkicks = lnls_get_kickangle(the_ring, orbit.hcm_idx, 'x');
vkicks = lnls_get_kickangle(the_ring, orbit.vcm_idx, 'y');
[codx, cody] = calc_cod(the_ring, dim);