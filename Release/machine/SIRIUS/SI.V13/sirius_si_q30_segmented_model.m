function [model, model_length] = sirius_si_q30_segmented_model(fam_name, strength, passmethod)

types = {};
quad   = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);

% Q30 model 2015-10-29
% ====================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/si/magnet_modelling/si-q30/model5/
% '11-05-2015 Quadrupolo_Anel_Q30_Modelo 5_-14_14mm_-500_500mm.txt'
monomials = [1,5,9,13,17];
segmodel = [ ...
%len[m]              angle[deg]             PolynomB(n=1)           PolynomB(n=5)           PolynomB(n=9)          PolynomB(n=13)          PolynomB(n=17) 
quad, 0.15000  +0.0000000000000000e+00 -4.8094118405370176e+00 +1.0563800793035635e+05 -2.0525547903119117e+13 +4.1376047948347376e+20 -1.2260123399423674e+27 
];

% hardedge quadrupole strength of the fieldmap
seg_lens = segmodel(:,2);
model_length = 2*sum(seg_lens);
hedge_strength = sum(2*segmodel(:,4) .* seg_lens) / model_length;
rescale_current = strength / hedge_strength; % rescaling current because fieldmap is usually generated with maximum current, not nominal value.

% builds the magnet model (supposing 1 segment model - current
% lattice_error scripts cannot deal with segmented quadrupole models)
i = 1;
maxorder = 1+max(monomials);
PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
PolyB(monomials+1) = segmodel(i,4:end) * rescale_current; 
type = types{segmodel(i,1)};
model = quadrupole_sirius(type.fam_name, 2*segmodel(i,2), PolyA, PolyB, passmethod);

