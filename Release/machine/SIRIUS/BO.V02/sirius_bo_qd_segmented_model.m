function [model, model_length] = sirius_bo_qd_segmented_model(fam_name, strength, passmethod)

types = {};
quad   = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);

% QD model 2015-11-05
% ====================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/bo/magnet_modelling/qd/fieldmaps/
% '2015-08-24 Quadrupolo_Booster_QD_Modelo 1_-20_20mm_-300_300mm_115A_extracao.txt'
monomials = [1,5,9,13];
segmodel = [ ...
%len[m]              angle[deg]             PolynomB(n=1)           PolynomB(n=5)           PolynomB(n=9)          PolynomB(n=13)   
quad  0.05050  +0.0000000000000000e+00 -5.0037880016612302e-01 +2.4871556929337290e+04 -6.8747285617449402e+10 -7.5279297084782300e+14
];

% hardedge quadrupole strength of the fieldmap
seg_lens = segmodel(:,2);
model_length = 2*sum(seg_lens);
hedge_strength = sum(2*segmodel(:,4) .* seg_lens) / model_length;
rescale_current = strength / hedge_strength; % rescaling current because fieldmap is usually generated with maximum current, not nominal value.

% builds the magnet model 
% (lattice_error scripts cannot yet deal with segmented quadrupole models)
i = 1;
maxorder = 1+max(monomials);
PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
PolyB(monomials+1) = segmodel(i,4:end) * rescale_current; 
type = types{segmodel(i,1)};
model = quadrupole_sirius(type.fam_name, 2*segmodel(i,2), PolyA, PolyB, passmethod);
