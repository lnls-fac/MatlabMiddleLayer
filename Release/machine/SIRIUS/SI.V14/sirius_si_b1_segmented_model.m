function [model, model_length] = sirius_si_b1_segmented_model(passmethod, m_accep_fam_name)

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
b1      = 1; types{end+1} = struct('fam_name', 'b1', 'passmethod', passmethod);
b1_edge = 2; types{end+1} = struct('fam_name', 'b1_edge', 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');

% dipole model 2016-01-04
% =======================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/si/magnet_modelling/si-b1/b1-model2 
% '2015-11-19_Dipolo_Anel_B1_Modelo2_-32_15mm_-1000_1000mm.txt'

monomials = [0,1,2,3,6];
segmodel = [ ...
%type     len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=6)   
b1,       0.002  ,  +0.00621 ,  +0.00e+00 ,  -5.36e-01 ,  -6.82e+00 ,  +1.55e+01 ,  +1.39e+07 ; 
b1,       0.003  ,  +0.00935 ,  +0.00e+00 ,  -5.57e-01 ,  -6.27e+00 ,  +1.89e+01 ,  +1.22e+07 ; 
b1,       0.005  ,  +0.01580 ,  +0.00e+00 ,  -6.23e-01 ,  -4.47e+00 ,  +2.17e+01 ,  +7.91e+06 ; 
b1,       0.005  ,  +0.01609 ,  +0.00e+00 ,  -7.09e-01 ,  -1.96e+00 ,  +1.35e+01 ,  +4.05e+06 ; 
b1,       0.005  ,  +0.01629 ,  +0.00e+00 ,  -7.64e-01 ,  -4.46e-01 ,  +6.80e+00 ,  +2.71e+06 ; 
b1,       0.010  ,  +0.03280 ,  +0.00e+00 ,  -7.92e-01 ,  +1.69e-01 ,  +8.17e+00 ,  +2.06e+06 ; 
b1,       0.040  ,  +0.13116 ,  +0.00e+00 ,  -8.00e-01 ,  +2.64e-01 ,  +1.11e+01 ,  +2.08e+06 ; 
b1,       0.150  ,  +0.48795 ,  +0.00e+00 ,  -7.99e-01 ,  +2.91e-01 ,  +1.22e+01 ,  +2.34e+06 ; 
b1,       0.100  ,  +0.32489 ,  +0.00e+00 ,  -7.99e-01 ,  +3.01e-01 ,  +1.26e+01 ,  +2.37e+06 ; 
b1,       0.050  ,  +0.16324 ,  +0.00e+00 ,  -8.00e-01 ,  +2.52e-01 ,  +1.13e+01 ,  +2.21e+06 ; 
b1,       0.034  ,  +0.10495 ,  +0.00e+00 ,  -7.27e-01 ,  -1.67e+00 ,  +1.05e+01 ,  +4.45e+06 ; 
b1_edge, 0,0,0,0,0,0,0
b1,       0.016  ,  +0.02994 ,  +0.00e+00 ,  -2.28e-01 ,  -5.20e+00 ,  -1.95e+01 ,  +6.31e+06 ; 
b1,       0.040  ,  +0.02774 ,  +0.00e+00 ,  -3.65e-02 ,  -1.70e+00 ,  -1.12e+00 ,  +2.09e+04 ; 
b1,       0.040  ,  +0.00689 ,  +0.00e+00 ,  -2.47e-03 ,  -3.48e-01 ,  +6.84e-01 ,  +8.05e+04 ; 
b1,       0.050  ,  +0.00435 ,  -9.57e-06*0, +7.77e-04 ,  -8.91e-02 ,  +8.48e-02 ,  +3.92e+04 ; 
m_accep, 0,0,0,0,0,0,0
];


% builds half of the magnet model
d2r = pi/180.0;
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end); 
        PolyB(1) = 0.0; PolyA(1) = 0.0; % convenience of a nominal lattice with zero 4D closed-orbit.
        b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end
end

% builds entire magnet model, inserting additional markers
model_length = 2*sum(segmodel(:,2));
mb1 = marker('mb1', 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mb1, m_accep, b];
