function get_orb_corr_streng()

ring = sirius_si_lattice();
fam_data = sirius_si_family_data(ring);

% making sure they are in order
bpm_idx = sort(fam_data.bpm.ATIndex);
hcm_idx = sort(fam_data.ch.ATIndex);
vcm_idx = sort(fam_data.cv.ATIndex);

cv_idx = findcells(ring,'FamName','cv')';
vcm_nocv_idx = setdiff(vcm_idx,cv_idx);

machine = load('CONFIG_machines_cod_corrected_tune_coup.mat');
machine = machine.machine;


fprintf('\n');
fprintf('    -------------------------------------------------------------------------------------------  \n');
fprintf('   |         kickx                 kicky               kicky w/o CV         kicky only CV      | \n');
fprintf('   |        [urad]                 [urad]                [urad]                 [urad]         | \n');
fprintf('   | (max)          (rms) | (max)          (rms) | (max)          (rms) | (max)          (rms) | \n');
fprintf('---|-------------------------------------------------------------------------------------------| \n');
for i=1:length(machine)
    hkck      = lnls_get_kickangle(machine{i},hcm_idx,'x');
    vkck      = lnls_get_kickangle(machine{i},vcm_idx,'y');
    vkck_nocv = lnls_get_kickangle(machine{i},vcm_nocv_idx,'y');
    vkck_cv   = lnls_get_kickangle(machine{i},cv_idx,'y');
    
%     orb = findorbit4(machine{i},0,1:length(machine{i}));
%     codx = orb(1,:);
%     cody = orb(3,:);
%     [x_max_all,x_rms_all] = get_max_rms(codx,1e6);
%     [x_max_bpm,x_rms_bpm] = get_max_rms(codx(bpm_idx),1e6);
%     [y_max_all,y_rms_all] = get_max_rms(cody,1e6);
%     [y_max_bpm,y_rms_bpm] = get_max_rms(cody(bpm_idx),1e6);
    [ind,kickx_max,kickx_rms] = get_max_rms(hkck,1e6);
    famx = ring{hcm_idx(ind)}.FamName;
    
    [ind,kicky_max,kicky_rms] = get_max_rms(vkck,1e6);
    famy = ring{vcm_idx(ind)}.FamName;
    
    [ind,kicky_nocv_max,kicky_nocv_rms] = get_max_rms(vkck_nocv,1e6);
    famy_novc = ring{vcm_nocv_idx(ind)}.FamName;
    
    [ind,kicky_cv_max,kicky_cv_rms] = get_max_rms(vkck_cv,1e6);
    famy_cv = ring{cv_idx(ind)}.FamName;
    fprintf('%03i|  %3.0f @ (%4s)   %3.0f  |  %3.0f @ (%4s)   %3.0f  |  %3.0f @ (%4s)   %3.0f  |  %3.0f @ (%4s)   %3.0f  | \n', i, ...
        kickx_max,famx,kickx_rms,kicky_max,famy,kicky_rms,kicky_nocv_max,famy_novc,...
        kicky_nocv_rms,kicky_cv_max,famy_cv,kicky_cv_rms);
    
end
fprintf('----------------------------------------------------------------------------------------------- \n');

function [maxi, maxv,rmsv] = get_max_rms(v,f)
    
[maxv,maxi] = max(abs(v));
maxv = f*maxv;
rmsv = f*sqrt(sum(v.^2)/length(v));
