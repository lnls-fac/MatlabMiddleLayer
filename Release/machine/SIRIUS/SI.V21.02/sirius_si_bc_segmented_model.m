function [model, model_length] = sirius_si_bc_segmented_model(passmethod, m_accep_fam_name)

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
bc   = 1; types{end+1} = struct('fam_name', 'BC', 'passmethod', passmethod);
bc_edge = 3; types{end+1} = struct('fam_name', 'BC_EDGE', 'passmethod', 'IdentityPass');
m_accep = 4; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


% dipole model 2016-01-13
% =======================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/si/magnet_modelling/si-bc/bc-model8
% '2016-01-12_Dipolo_Anel_BC_Modelo8_gap_lateral_2.9mm_peca_3.7mm_-90_12mm_-2000_2000mm.txt'
monomials = [0,1,2,3,4,5,6,7,8,10];
segmodel = [ ...
 %type    len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)  
 bc,   0.005  ,  +0.09110 ,  +0.00e+00 ,  +3.82e-03 ,  -3.54e+01 ,  -3.99e+02 ,  -1.34e+05 ,  +5.52e+06 ,  -9.09e+09 ,  -2.68e+10 ,  +6.08e+13 ,  -2.20e+17 ;
 bc,   0.005  ,  +0.08089 ,  +0.00e+00 ,  -2.31e-02 ,  -2.21e+01 ,  +8.72e+01 ,  -2.76e+05 ,  -1.30e+06 ,  -1.92e+09 ,  +9.20e+09 ,  +1.70e+13 ,  -1.05e+17 ; 
 bc,   0.005  ,  +0.06850 ,  +0.00e+00 ,  -2.20e-02 ,  -1.75e+01 ,  -3.23e+02 ,  +9.27e+04 ,  +6.39e+06 ,  -6.36e+09 ,  -3.56e+10 ,  +7.06e+13 ,  -2.92e+17 ; 
 bc,   0.005  ,  +0.05892 ,  +0.00e+00 ,  -2.66e-02 ,  -1.08e+01 ,  -5.20e+01 ,  +3.55e+04 ,  +1.33e+06 ,  -2.88e+09 ,  -7.47e+09 ,  +3.38e+13 ,  -1.43e+17 ; 
 bc,   0.010  ,  +0.09662 ,  +0.00e+00 ,  -2.65e-02 ,  -6.72e+00 ,  -3.36e-01 ,  -8.34e+03 ,  +3.02e+05 ,  -5.12e+08 ,  -2.04e+09 ,  +5.98e+12 ,  -2.47e+16 ; 
 bc,   0.010  ,  +0.07443 ,  +0.00e+00 ,  -2.58e-02 ,  -4.19e+00 ,  -3.35e+01 ,  -9.69e+03 ,  +7.03e+05 ,  -8.59e+06 ,  -3.71e+09 ,  +3.18e+11 ,  -1.93e+15 ; 
 bc,   0.010  ,  +0.05612 ,  +0.00e+00 ,  -2.56e-02 ,  -2.46e+00 ,  +2.77e+01 ,  -9.37e+02 ,  -3.93e+05 ,  -2.75e+06 ,  +2.18e+09 ,  -4.79e+11 ,  +3.31e+15 ; 
 bc,   0.010  ,  +0.04318 ,  +0.00e+00 ,  -1.73e-02 ,  -2.57e-01 ,  +5.38e+01 ,  -3.12e+04 ,  -8.40e+05 ,  +7.89e+08 ,  +4.23e+09 ,  -8.42e+12 ,  +3.14e+16 ; 
 m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
 bc,   0.064  ,  +0.21752 ,  +0.00e+00 ,  -7.09e-02 ,  +6.39e-02 ,  +3.43e+00 ,  +3.65e+02 ,  +2.55e+04 ,  -5.12e+06 ,  -3.70e+07 ,  -7.58e+10 ,  +6.63e+14 ; 
 m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;...
 bc,   0.160  ,  +0.62805 ,  +0.00e+00 ,  -9.25e-01 ,  +3.00e-01 ,  +1.79e+01 ,  +1.94e+03 ,  +3.37e+04 ,  -3.75e+07 ,  -1.15e+08 ,  +3.71e+11 ,  -1.29e+15 ; 
 m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;...
 bc,   0.160  ,  +0.62913 ,  +0.00e+00 ,  -9.36e-01 ,  +2.18e-02 ,  +1.57e+01 ,  -6.03e+02 ,  +1.76e+04 ,  +3.02e+07 ,  -4.16e+07 ,  -3.71e+11 ,  +1.57e+15 ; 
 bc,   0.012  ,  +0.03774 ,  +0.00e+00 ,  -4.86e-01 ,  -6.29e+00 ,  -1.72e+01 ,  +2.01e+04 ,  +1.96e+05 ,  -5.15e+08 ,  -1.10e+09 ,  +5.40e+12 ,  -1.96e+16 ; 
 bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;...
 bc,   0.014  ,  +0.02843 ,  +0.00e+00 ,  -1.41e-01 ,  -4.21e+00 ,  -4.95e+01 ,  -7.83e+02 ,  +2.41e+04 ,  -9.98e+06 ,  +8.96e+07 ,  +2.20e+11 ,  -1.08e+15 ; 
 bc,   0.016  ,  +0.01811 ,  +0.00e+00 ,  -4.29e-02 ,  -2.02e+00 ,  -1.23e+01 ,  +1.33e+03 ,  +2.72e+03 ,  -4.91e+07 ,  -6.36e+07 ,  +5.63e+11 ,  -2.25e+15 ; 
 bc,   0.035  ,  +0.01956 ,  -3.56e-04*0, -8.49e-03 ,  -1.21e+00 ,  +2.30e+00 ,  +8.79e+02 ,  -2.03e+04 ,  -1.57e+07 ,  +4.30e+07 ,  +1.30e+11 ,  -4.24e+14 ; 
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
mc = marker('mc', 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mc, m_accep, b];
