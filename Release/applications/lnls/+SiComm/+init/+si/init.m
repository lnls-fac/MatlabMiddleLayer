the_ring = sirius_si_lattice();
inj_sept = findcells(the_ring, 'FamName', 'InjSeptF');
the_ring = circshift(the_ring, [0, - (inj_sept - 1)]);
clear inj_sept
fam_data = sirius_si_family_data(the_ring);
[~, M_acc] = findm44(the_ring, 0, 1:length(the_ring));
respm = calc_respm_cod(the_ring, fam_data.BPM.ATIndex, fam_data.CH.ATIndex, fam_data.CV.ATIndex);
load('/home/fac_files/lnls-fac/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+init/+si/random_machines.mat');
load('/home/fac_files/lnls-fac/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+init/+si/injection_param.mat');
% load('/home/fac_files/lnls_fac/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+init/+si/injection_errors.mat');
