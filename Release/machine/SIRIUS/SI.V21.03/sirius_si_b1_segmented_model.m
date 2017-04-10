function [model, model_length] = sirius_si_b1_segmented_model(passmethod, m_accep_fam_name)

b_famname = 'B1';
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

% B1 model 2017-02-01 (3GeV)
% ===========================
% dipole model-08
% filename: 2017-02-01_B1_Model08_Sim_X=-32_32mm_Z=-1000_1000mm_Imc=451.8A.txt
% trajectory centered in good-field region.
% init_rx is set to  4.86 mm at s=0

monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
b1,       0.0020 ,  +0.00646 ,  +0.00e+00 ,  -7.60e-01 ,  +1.94e-02 ,  +1.59e+00 ,  +4.18e+02 ,  -5.77e+03 ,  +3.91e+05 ;
b1,       0.0030 ,  +0.00970 ,  +0.00e+00 ,  -7.61e-01 ,  +5.64e-02 ,  +1.24e+00 ,  +4.30e+02 ,  -5.59e+03 ,  +2.95e+05 ;
b1,       0.0050 ,  +0.01619 ,  +0.00e+00 ,  -7.66e-01 ,  +1.47e-01 ,  +8.22e-01 ,  +4.16e+02 ,  -4.97e+03 ,  +2.83e+05 ;
b1,       0.0050 ,  +0.01623 ,  +0.00e+00 ,  -7.72e-01 ,  +2.14e-01 ,  +1.28e+00 ,  +3.85e+02 ,  -5.43e+03 ,  +3.77e+05 ;
b1,       0.0050 ,  +0.01625 ,  +0.00e+00 ,  -7.75e-01 ,  +2.19e-01 ,  +1.87e+00 ,  +3.76e+02 ,  -5.91e+03 ,  +4.08e+05 ;
b1,       0.0100 ,  +0.03252 ,  +0.00e+00 ,  -7.75e-01 ,  +2.04e-01 ,  +1.95e+00 ,  +3.79e+02 ,  -5.95e+03 ,  +4.17e+05 ;
b1,       0.0400 ,  +0.12981 ,  +0.00e+00 ,  -7.75e-01 ,  +2.07e-01 ,  +1.99e+00 ,  +3.78e+02 ,  -5.56e+03 ,  +4.12e+05 ;
b1,       0.1500 ,  +0.48333 ,  +0.00e+00 ,  -7.74e-01 ,  +2.26e-01 ,  +3.09e+00 ,  +3.75e+02 ,  -4.32e+03 ,  +3.81e+05 ;
b1,       0.1000 ,  +0.32210 ,  +0.00e+00 ,  -7.74e-01 ,  +2.37e-01 ,  +3.49e+00 ,  +3.81e+02 ,  -4.30e+03 ,  +3.79e+05 ;
b1,       0.0500 ,  +0.16184 ,  +0.00e+00 ,  -7.76e-01 ,  +1.63e-01 ,  +1.91e+00 ,  +3.84e+02 ,  -4.74e+03 ,  +4.05e+05 ;
b1,       0.0340 ,  +0.10488 ,  +0.00e+00 ,  -7.75e-01 ,  +4.45e-02 ,  +7.00e+00 ,  +3.51e+02 ,  -3.50e+02 ,  +2.17e+05 ;
b1_edge, 0,0,0,0,0,0,0,0,0;
b1,       0.0160 ,  +0.03288 ,  +0.00e+00 ,  -4.15e-01 ,  -1.96e+00 ,  +1.77e+01 ,  -9.80e+00 ,  +1.27e+04 ,  -2.71e+05 ;
b1,       0.0400 ,  +0.03230 ,  +0.00e+00 ,  -7.58e-02 ,  -1.74e+00 ,  +8.17e+00 ,  -5.62e+01 ,  +3.68e+03 ,  -5.11e+03 ;
b1,       0.0400 ,  +0.00813 ,  +0.00e+00 ,  -6.80e-03 ,  -4.05e-01 ,  +1.29e+00 ,  +1.35e+01 ,  -1.77e+01 ,  +5.25e+03 ;
b1,       0.0500 ,  +0.00503 ,  -7.69e-05 ,  -3.07e-04 ,  -1.04e-01 ,  +1.64e-01 ,  +4.20e+00 ,  -1.00e+01 ,  -4.61e+02 ;
m_accep, 0,0,0,0,0,0,0,0,0;
];

% % B1 model 2017-01-19 (3GeV)
% % ===========================
% % dipole model-07
% % filename: 2017-01-19_B1_Model07_Sim_X=-32_32mm_Z=-1000_1000mm_Imc=452.4A.txt
% % trajectory centered in good-field region.
% % init_rx is set to  4.86 mm at s=0

% monomials = [0,1,2,3,4,5,6];
% segmodel = [ ...
% %type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
% b1,       0.0020 ,  +0.00647 ,  +0.00e+00 ,  -7.64e-01 ,  +3.43e-01 ,  +2.06e+01 ,  +4.80e+02 ,  +8.81e+02 ,  -4.76e+05;
% b1,       0.0030 ,  +0.00970 ,  +0.00e+00 ,  -7.65e-01 ,  +3.84e-01 ,  +2.02e+01 ,  +4.78e+02 ,  +1.67e+03 ,  -5.29e+05;
% b1,       0.0050 ,  +0.01620 ,  +0.00e+00 ,  -7.71e-01 ,  +4.85e-01 ,  +1.96e+01 ,  +4.24e+02 ,  +2.99e+03 ,  -4.06e+05;
% b1,       0.0050 ,  +0.01624 ,  +0.00e+00 ,  -7.76e-01 ,  +5.63e-01 ,  +2.00e+01 ,  +3.57e+02 ,  +3.20e+03 ,  -2.41e+05;
% b1,       0.0050 ,  +0.01626 ,  +0.00e+00 ,  -7.79e-01 ,  +5.73e-01 ,  +2.07e+01 ,  +3.36e+02 ,  +2.76e+03 ,  -1.89e+05;
% b1,       0.0100 ,  +0.03254 ,  +0.00e+00 ,  -7.80e-01 ,  +5.61e-01 ,  +2.09e+01 ,  +3.34e+02 ,  +2.44e+03 ,  -1.51e+05;
% b1,       0.0400 ,  +0.12987 ,  +0.00e+00 ,  -7.79e-01 ,  +5.76e-01 ,  +2.09e+01 ,  +3.39e+02 ,  +2.08e+03 ,  -1.41e+05;
% b1,       0.1500 ,  +0.48351 ,  +0.00e+00 ,  -7.78e-01 ,  +6.25e-01 ,  +2.19e+01 ,  +3.49e+02 ,  +1.54e+03 ,  -1.41e+05;
% b1,       0.1000 ,  +0.32223 ,  +0.00e+00 ,  -7.78e-01 ,  +6.35e-01 ,  +2.23e+01 ,  +3.56e+02 ,  +1.56e+03 ,  -1.48e+05;
% b1,       0.0500 ,  +0.16192 ,  +0.00e+00 ,  -7.80e-01 ,  +5.38e-01 ,  +2.07e+01 ,  +3.51e+02 ,  +2.38e+03 ,  -1.37e+05;
% b1,       0.0340 ,  +0.10467 ,  +0.00e+00 ,  -7.64e-01 ,  -5.08e-01 ,  +4.78e+01 ,  +3.39e+02 ,  -1.26e+04 ,  -3.87e+03;
% b1_edge, 0,0,0,0,0,0,0,0,0;
% b1,       0.0160 ,  +0.03259 ,  +0.00e+00 ,  -3.74e-01 ,  -3.93e+00 ,  +7.91e+01 ,  +2.28e+02 ,  -3.59e+04 ,  +3.05e+05;
% b1,       0.0400 ,  +0.03217 ,  +0.00e+00 ,  -6.65e-02 ,  -1.89e+00 ,  +1.05e+01 ,  +3.74e+01 ,  +7.56e+02 ,  -2.56e+04;
% b1,       0.0400 ,  +0.00817 ,  +0.00e+00 ,  -5.77e-03 ,  -4.01e-01 ,  +1.17e+00 ,  +1.35e+01 ,  -1.75e+01 ,  +6.05e+03;
% b1,       0.0500 ,  +0.00511 ,  -1.86e-05 ,  -3.84e-06 ,  -1.04e-01 ,  +1.43e-01 ,  +4.09e+00 ,  -9.02e+00 ,  -3.67e+02;
% m_accep, 0,0,0,0,0,0,0,0,0;
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
