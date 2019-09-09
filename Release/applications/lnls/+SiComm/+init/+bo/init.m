sirius('BO');
the_ring = sirius_bo_lattice();
inj_sept = findcells(the_ring, 'FamName', 'InjSept');
the_ring = circshift(the_ring, [0, - (inj_sept - 1)]);
clear inj_sept
fam_data = sirius_bo_family_data(the_ring);
respm = calc_respm_cod(the_ring, fam_data.BPM.ATIndex, fam_data.CH.ATIndex, fam_data.CV.ATIndex);
load('/home/fac_files/lnls-fac/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+init/+bo/random_machines.mat');
load('/home/fac_files/lnls-fac/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+init/+bo/injection_param.mat');
% load('/home/fac_files/lnls_fac/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+init/+si/injection_errors.mat');
