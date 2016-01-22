function [model, model_length] = sirius_si_b2_segmented_model(passmethod, m_accep_fam_name)

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
b2      = 1; types{end+1} = struct('fam_name', 'b2', 'passmethod', passmethod);
b2_edge = 2; types{end+1} = struct('fam_name', 'b2_edge', 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');

% dipole model 2016-01-05
% =======================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/si/magnet_modelling/si-b2/b2-model3 
% '2015-12-01_Dipolo_Anel_B2_Modelo3_-63_17mm_-1500_1500mm.txt'

monomials = [0,1,2,3,6];
segmodel = [ ...
% %type      len[m]      angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=6)   
% b2,         0.030  ,  +0.09805 ,  +0.00e+00 ,  -7.99e-01 ,  +2.84e-01 ,  +1.20e+01 ,  +2.24e+06 ; 
% b2,         0.095  ,  +0.31130 ,  +0.00e+00 ,  -8.00e-01 ,  +2.78e-01 ,  +1.17e+01 ,  +2.16e+06 ; 
% b2,         0.055  ,  +0.18129 ,  +0.00e+00 ,  -7.99e-01 ,  +2.75e-01 ,  +1.09e+01 ,  +1.92e+06 ; 
% b2,         0.010  ,  +0.03253 ,  +0.00e+00 ,  -7.55e-01 ,  -1.05e-01 ,  +1.30e+00 ,  +1.41e+06 ; 
% b2,         0.005  ,  +0.01580 ,  +0.00e+00 ,  -6.49e-01 ,  -2.02e+00 ,  -3.88e+00 ,  +2.65e+06 ; 
% b2,         0.005  ,  +0.01539 ,  +0.00e+00 ,  -5.52e-01 ,  -3.87e+00 ,  -1.14e+01 ,  +3.71e+06 ; 
% b2,         0.005  ,  +0.01520 ,  +0.00e+00 ,  -5.05e-01 ,  -4.69e+00 ,  -1.85e+01 ,  +4.77e+06 ; 
% m_accep,    0,0,0,0,0,0,0;
% b2,         0.005  ,  +0.01537 ,  +0.00e+00 ,  -5.46e-01 ,  -3.98e+00 ,  -1.14e+01 ,  +4.13e+06 ; 
% b2,         0.010  ,  +0.03193 ,  +0.00e+00 ,  -6.85e-01 ,  -1.33e+00 ,  -2.74e+00 ,  +2.24e+06 ; 
% b2,         0.010  ,  +0.03285 ,  +0.00e+00 ,  -7.84e-01 ,  +2.59e-01 ,  +5.69e+00 ,  +1.52e+06 ; 
% b2,         0.175  ,  +0.57500 ,  +0.00e+00 ,  -7.99e-01 ,  +2.85e-01 ,  +1.20e+01 ,  +2.19e+06 ; 
% b2_edge,    0,0,0,0,0,0,0;
% b2,         0.175  ,  +0.57547 ,  +0.00e+00 ,  -8.00e-01 ,  +2.79e-01 ,  +1.22e+01 ,  +2.23e+06 ; 
% b2,         0.020  ,  +0.06320 ,  +0.00e+00 ,  -7.53e-01 ,  -5.68e-01 ,  +1.05e+00 ,  +2.38e+06 ; 
% b2,         0.010  ,  +0.02489 ,  +0.00e+00 ,  -4.29e-01 ,  -3.77e+00 ,  -1.84e+01 ,  +2.64e+06 ; 
% b2,         0.015  ,  +0.02434 ,  +0.00e+00 ,  -1.63e-01 ,  -3.23e+00 ,  -2.19e+01 ,  -1.16e+06 ; 
% b2,         0.020  ,  +0.01685 ,  +0.00e+00 ,  -4.53e-02 ,  -1.77e+00 ,  -1.74e+00 ,  -1.02e+06 ; 
% b2,         0.030  ,  +0.01055 ,  +0.00e+00 ,  -9.48e-03 ,  -7.41e-01 ,  +1.48e+00 ,  -4.57e+04 ; 
% b2,         0.064  ,  +0.00588 ,  +0.00e+00 ,  -5.16e-04 ,  -1.50e-01 ,  +2.33e-01 ,  +3.50e+04 ; 
% b2,         0.0005 ,  +0.00231 ,  +7.31e-03*0, +5.75e-02 ,  -2.95e+00 ,  +7.46e-01 ,  +1.05e+06 ; 
% m_accep,    0,0,0,0,0,0,0;
%type        len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=6)   
b2,          0.125  ,  +0.40935 ,  +0.00e+00 ,  -8.00e-01 ,  +2.79e-01 ,  +1.18e+01 ,  +2.18e+06 ; 
b2,          0.055  ,  +0.18129 ,  +0.00e+00 ,  -7.99e-01 ,  +2.75e-01 ,  +1.09e+01 ,  +1.92e+06 ; 
b2,          0.010  ,  +0.03253 ,  +0.00e+00 ,  -7.55e-01 ,  -1.05e-01 ,  +1.30e+00 ,  +1.41e+06 ; 
b2,          0.005  ,  +0.01580 ,  +0.00e+00 ,  -6.49e-01 ,  -2.02e+00 ,  -3.88e+00 ,  +2.65e+06 ; 
b2,          0.005  ,  +0.01539 ,  +0.00e+00 ,  -5.52e-01 ,  -3.87e+00 ,  -1.14e+01 ,  +3.71e+06 ; 
b2,          0.005  ,  +0.01520 ,  +0.00e+00 ,  -5.05e-01 ,  -4.69e+00 ,  -1.85e+01 ,  +4.77e+06 ; 
m_accep,    0,0,0,0,0,0,0;
b2,          0.005  ,  +0.01537 ,  +0.00e+00 ,  -5.46e-01 ,  -3.98e+00 ,  -1.14e+01 ,  +4.13e+06 ; 
b2,          0.010  ,  +0.03193 ,  +0.00e+00 ,  -6.85e-01 ,  -1.33e+00 ,  -2.74e+00 ,  +2.24e+06 ; 
b2,          0.010  ,  +0.03285 ,  +0.00e+00 ,  -7.84e-01 ,  +2.59e-01 ,  +5.69e+00 ,  +1.52e+06 ; 
b2,          0.175  ,  +0.57500 ,  +0.00e+00 ,  -7.99e-01 ,  +2.85e-01 ,  +1.20e+01 ,  +2.19e+06 ; 
b2_edge,    0,0,0,0,0,0,0;
b2,          0.175  ,  +0.57547 ,  +0.00e+00 ,  -8.00e-01 ,  +2.79e-01 ,  +1.22e+01 ,  +2.23e+06 ; 
b2,          0.020  ,  +0.06320 ,  +0.00e+00 ,  -7.53e-01 ,  -5.68e-01 ,  +1.05e+00 ,  +2.38e+06 ; 
b2,          0.010  ,  +0.02489 ,  +0.00e+00 ,  -4.29e-01 ,  -3.77e+00 ,  -1.84e+01 ,  +2.64e+06 ; 
b2,          0.015  ,  +0.02434 ,  +0.00e+00 ,  -1.63e-01 ,  -3.23e+00 ,  -2.19e+01 ,  -1.16e+06 ; 
b2,          0.020  ,  +0.01685 ,  +0.00e+00 ,  -4.53e-02 ,  -1.77e+00 ,  -1.74e+00 ,  -1.02e+06 ; 
b2,          0.030  ,  +0.01055 ,  +0.00e+00 ,  -9.48e-03 ,  -7.41e-01 ,  +1.48e+00 ,  -4.57e+04 ; 
b2,          0.064  ,  +0.00588 ,  +0.00e+00 ,  -5.16e-04 ,  -1.50e-01 ,  +2.33e-01 ,  +3.50e+04 ; 
b2,          0.0005 ,  +0.00231 ,  +7.31e-03*0, +5.75e-02 ,  -2.95e+00 ,  +7.46e-01 ,  +1.05e+06 ;
m_accep,    0,0,0,0,0,0,0;
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
mb2 = marker('mb2', 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mb2, m_accep, b];
