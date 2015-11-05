function [model, model_length] = sirius_bo_qf_segmented_model(fam_name, strength, passmethod)

types = {};
quad   = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);

% QF model 2015-11-05
% ====================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/bo/magnet_modelling/qf/fieldmaps/
% '2014-11-04 Quadrupolo_Booster_QF_Modelo 4_-32_32mm_-450_450mm.txt'
monomials = [1,5,9,13];
segmodel = [ ...
%len[m]              angle[deg]             PolynomB(n=1)           PolynomB(n=5)           PolynomB(n=9)          PolynomB(n=13)          
quad  0.11350  +0.0000000000000000e+00 +2.0678629110439761e+00 -2.2703958540960379e+04 +2.7720759751229974e+11 +6.9579670640156496e+16
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
half_model = quadrupole_sirius(type.fam_name, segmodel(i,2), PolyA, PolyB, passmethod);
mqf  = marker('mqf',     'IdentityPass');
model = [half_model, mqf, half_model];
