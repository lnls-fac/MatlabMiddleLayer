function [model, model_length] = sirius_si_b2_segmented_model(passmethod, m_accep_fam_name)

b_famname = 'B2';
mb_famname = ['m',b_famname];
edge_famname = [b_famname, '_edge'];

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
b1      = 1; types{end+1} = struct('fam_name', b_famname, 'passmethod', passmethod);
b1_edge = 2; types{end+1} = struct('fam_name', edge_famname, 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


% FIELDMAP
% *** interpolation of fields is now cubic ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---

% B2 model 2017-02-01 (3GeV)
% ===========================
% dipole model-07
% filename: 2017-02-01_B2_Model07_Sim_X=-63_27mm_Z=-1000_1000mm_Imc=451.8A.txt
% trajectory centered in good-field region.
% init_rx is set to  5.444 mm at s=0

monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
b1,       0.1250 ,  +0.40617 ,  +0.00e+00 ,  -7.76e-01 ,  +1.52e-01 ,  -1.02e-01 ,  +3.47e+02 ,  -5.76e+03 ,  +4.30e+05 ;
b1,       0.0550 ,  +0.17994 ,  +0.00e+00 ,  -7.76e-01 ,  +1.48e-01 ,  -7.59e-01 ,  +3.59e+02 ,  -7.09e+03 ,  +4.59e+05 ;
b1,       0.0100 ,  +0.03277 ,  +0.00e+00 ,  -7.76e-01 ,  +1.67e-01 ,  -8.58e-01 ,  +3.50e+02 ,  -7.32e+03 ,  +4.82e+05 ;
b1,       0.0050 ,  +0.01634 ,  +0.00e+00 ,  -7.71e-01 ,  +1.56e-01 ,  -1.80e+00 ,  +3.44e+02 ,  -6.44e+03 ,  +4.83e+05 ;
b1,       0.0050 ,  +0.01631 ,  +0.00e+00 ,  -7.65e-01 ,  +6.84e-02 ,  -2.08e+00 ,  +3.65e+02 ,  -5.66e+03 ,  +3.89e+05 ;
b1,       0.0050 ,  +0.01628 ,  +0.00e+00 ,  -7.61e-01 ,  -7.30e-03 ,  -1.62e+00 ,  +3.76e+02 ,  -6.32e+03 ,  +3.92e+05 ;
m_accep,  0,0,0,0,0,0,0,0,0;
b1,       0.0050 ,  +0.01630 ,  +0.00e+00 ,  -7.64e-01 ,  +5.10e-02 ,  -2.01e+00 ,  +3.73e+02 ,  -5.84e+03 ,  +3.90e+05 ;
b1,       0.0100 ,  +0.03270 ,  +0.00e+00 ,  -7.72e-01 ,  +1.63e-01 ,  -1.44e+00 ,  +3.52e+02 ,  -6.74e+03 ,  +4.55e+05 ;
b1,       0.0100 ,  +0.03277 ,  +0.00e+00 ,  -7.76e-01 ,  +1.61e-01 ,  -5.35e-01 ,  +3.60e+02 ,  -7.41e+03 ,  +4.73e+05 ;
b1,       0.1750 ,  +0.56934 ,  +0.00e+00 ,  -7.75e-01 ,  +1.80e-01 ,  +7.06e-01 ,  +3.65e+02 ,  -6.08e+03 ,  +4.35e+05 ;
b1,       0.1750 ,  +0.56881 ,  +0.00e+00 ,  -7.75e-01 ,  +1.84e-01 ,  +1.58e+00 ,  +3.84e+02 ,  -5.75e+03 ,  +4.27e+05 ;
b1,       0.0200 ,  +0.06327 ,  +0.00e+00 ,  -7.96e-01 ,  +2.40e-02 ,  +6.47e+00 ,  +3.92e+02 ,  -3.96e+03 ,  +3.36e+05 ;
b1,       0.0100 ,  +0.02704 ,  +0.00e+00 ,  -6.73e-01 ,  -2.43e-01 ,  +1.29e+01 ,  +7.85e+01 ,  +6.80e+03 ,  +1.98e+05 ;
b1_edge, 0,0,0,0,0,0,0,0,0;
b1,       0.0150 ,  +0.02831 ,  +0.00e+00 ,  -3.48e-01 ,  -2.36e+00 ,  +1.83e+01 ,  -1.03e+02 ,  +1.34e+04 ,  -6.97e+04 ;
b1,       0.0200 ,  +0.01996 ,  +0.00e+00 ,  -1.02e-01 ,  -2.16e+00 ,  +1.07e+01 ,  -1.02e+02 ,  +5.84e+03 ,  -3.09e+04 ;
b1,       0.0300 ,  +0.01244 ,  +0.00e+00 ,  -2.21e-02 ,  -9.29e-01 ,  +3.84e+00 ,  +4.06e+00 ,  +3.46e+02 ,  +4.58e+03 ;
b1,       0.0320 ,  +0.00487 ,  +0.00e+00 ,  -3.89e-03 ,  -2.80e-01 ,  +8.00e-01 ,  +1.18e+01 ,  -2.70e+01 ,  +8.66e+01 ;
b1,       0.0325 ,  +0.00458 ,  -1.14e-04 ,  -7.17e-05 ,  -1.39e-01 ,  +1.99e-01 ,  +5.42e+00 ,  -1.25e+01 ,  -2.30e+02 ;
m_accep,  0,0,0,0,0,0,0,0,0;
];

% % B2 model 2017-01-19 (3GeV)
% % ===========================
% % dipole model-06
% % filename: 2017-01-19_B2_Model06_Sim_X=-63_27mm_Z=-1000_1000mm_Imc=452.4A.txt
% % trajectory centered in good-field region.
% % init_rx is set to  5.444 mm at s=0
% 
% monomials = [0,1,2,3,4,5,6];
% segmodel = [ ...
% %type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
% b1,       0.1250 ,  +0.40641 ,  +0.00e+00 ,  -7.81e-01 ,  +5.25e-01 ,  +1.91e+01 ,  +3.09e+02 ,  +2.07e+03 ,  -1.29e+05 ;
% b1,       0.0550 ,  +0.18003 ,  +0.00e+00 ,  -7.81e-01 ,  +4.73e-01 ,  +1.83e+01 ,  +3.07e+02 ,  +2.54e+03 ,  -1.32e+05 ;
% b1,       0.0100 ,  +0.03273 ,  +0.00e+00 ,  -7.71e-01 ,  -2.68e-02 ,  +2.62e+01 ,  +4.24e+02 ,  -3.04e+03 ,  -2.08e+05 ;
% b1,       0.0050 ,  +0.01629 ,  +0.00e+00 ,  -7.49e-01 ,  -1.10e+00 ,  +5.44e+01 ,  +4.73e+02 ,  -2.07e+04 ,  -2.98e+05 ;
% b1,       0.0050 ,  +0.01623 ,  +0.00e+00 ,  -7.27e-01 ,  -2.25e+00 ,  +8.90e+01 ,  +4.10e+02 ,  -4.39e+04 ,  -3.11e+05 ;
% b1,       0.0050 ,  +0.01619 ,  +0.00e+00 ,  -7.15e-01 ,  -2.91e+00 ,  +1.10e+02 ,  +3.40e+02 ,  -6.12e+04 ,  -5.94e+04 ;
% m_accep,  0,0,0,0,0,0,0,0,0;
% b1,       0.0050 ,  +0.01621 ,  +0.00e+00 ,  -7.24e-01 ,  -2.41e+00 ,  +9.44e+01 ,  +3.77e+02 ,  -4.89e+04 ,  -1.44e+05 ;
% b1,       0.0100 ,  +0.03261 ,  +0.00e+00 ,  -7.54e-01 ,  -8.11e-01 ,  +4.69e+01 ,  +4.70e+02 ,  -1.68e+04 ,  -2.89e+05 ;
% b1,       0.0100 ,  +0.03276 ,  +0.00e+00 ,  -7.76e-01 ,  +2.51e-01 ,  +2.07e+01 ,  +3.79e+02 ,  +8.97e+02 ,  -2.07e+05 ;
% b1,       0.1750 ,  +0.56967 ,  +0.00e+00 ,  -7.80e-01 ,  +5.40e-01 ,  +1.97e+01 ,  +3.22e+02 ,  +2.16e+03 ,  -1.32e+05 ;
% b1,       0.1750 ,  +0.56914 ,  +0.00e+00 ,  -7.80e-01 ,  +5.44e-01 ,  +2.05e+01 ,  +3.42e+02 ,  +2.35e+03 ,  -1.36e+05 ;
% b1,       0.0200 ,  +0.06318 ,  +0.00e+00 ,  -7.88e-01 ,  -3.06e-01 ,  +3.82e+01 ,  +4.79e+02 ,  -7.84e+03 ,  -1.62e+05 ;
% b1,       0.0100 ,  +0.02685 ,  +0.00e+00 ,  -6.30e-01 ,  -2.81e+00 ,  +1.08e+02 ,  +1.29e+02 ,  -5.80e+04 ,  +5.56e+05 ;
% b1_edge, 0,0,0,0,0,0,0,0,0;
% b1,       0.0150 ,  +0.02805 ,  +0.00e+00 ,  -3.10e-01 ,  -4.08e+00 ,  +6.51e+01 ,  +3.98e+02 ,  -2.71e+04 ,  -6.68e+04 ;
% b1,       0.0200 ,  +0.01985 ,  +0.00e+00 ,  -8.89e-02 ,  -2.39e+00 ,  +1.37e+01 ,  +4.48e+01 ,  +1.83e+03 ,  -6.34e+04 ;
% b1,       0.0300 ,  +0.01245 ,  +0.00e+00 ,  -1.92e-02 ,  -9.29e-01 ,  +3.56e+00 ,  +1.29e+01 ,  +1.85e+02 ,  -1.43e+03 ;
% b1,       0.0320 ,  +0.00490 ,  +0.00e+00 ,  -3.20e-03 ,  -2.77e-01 ,  +7.22e-01 ,  +1.16e+01 ,  -2.70e+01 ,  -2.25e+02 ;
% b1,       0.0325 ,  +0.00465 ,  -7.71e-05 ,  +3.45e-04 ,  -1.39e-01 ,  +1.73e-01 ,  +5.30e+00 ,  -1.21e+01 ,  -2.16e+02 ;
% m_accep,  0,0,0,0,0,0,0,0,0;
% ];




% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
segmodel(:,4) = 0;

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
mb1 = marker(mb_famname, 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mb1, m_accep, b];
