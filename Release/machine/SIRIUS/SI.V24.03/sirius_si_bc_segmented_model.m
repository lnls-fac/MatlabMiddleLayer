function [model, model_length] = sirius_si_bc_segmented_model(passmethod, m_accep_fam_name)

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
bc   = 1; types{end+1} = struct('fam_name', 'BC', 'passmethod', passmethod);
bc_edge = 2; types{end+1} = struct('fam_name', 'BC_EDGE', 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


% Average Dipole Model for BC 
% =============================================
% date: 2019-06-19
% Based on multipole expansion around average segmented model trajectory calculated
% from fieldmap analysis of measurement data
% folder = si-dipoles-bc/model-13/analysis/hallprobe/production/x0-0p079mm-reftraj
% init_rx =  79 um
% ref_rx  = 7.7030 mm (average model trajectory)
% goal_tunes = [49.096188917357331, 14.151971558423915];
% goal_chrom = [2.549478494984214, 2.527086095938103];

monomials = [0,1,2,3,4,5,6,7,8,10];
segmodel = [ ...
%         len[m]  angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)
 bc,      0.00100, 0.01877, -1.4741e-05, -3.2459e-03, -2.5934e+01, +2.2655e+02, -4.2041e+05, -1.9362e+06, -8.8515e+08, +1.8066e+10, -4.1927e+13, +1.8535e+17; 
 bc,      0.00400, 0.07328, -3.5868e-06, -8.0872e-03, -2.3947e+01, +1.9896e+02, -3.8312e+05, -1.5555e+06, -8.7538e+08, +1.5588e+10, -3.4411e+13, +1.5036e+17; 
 bc,      0.00500, 0.08149, -1.5878e-06, -2.2156e-02, -1.6636e+01, +9.5225e+01, -2.4803e+05, -2.8667e+05, -6.2015e+08, +5.9788e+09, -1.1795e+13, +5.3967e+16; 
 bc,      0.00500, 0.06914, -2.2515e-06, -2.6794e-02, -9.9744e+00, +4.0910e+01, -1.2934e+05, -1.8459e+04, +6.5912e+06, +1.8432e+09, -3.7282e+12, +1.5831e+16; 
 bc,      0.00500, 0.05972, +2.4800e-07, -2.6704e-02, -7.1238e+00, +2.8365e+01, -7.1836e+04, -1.7947e+05, +2.5073e+08, +1.9029e+09, -3.3936e+12, +1.2829e+16; 
 bc,      0.01000, 0.09814, -7.2919e-07, -2.5788e-02, -5.4243e+00, +1.8297e+01, -3.6399e+04, -1.8928e+05, +2.7961e+08, +1.5270e+09, -3.1054e+12, +1.1735e+16; 
 bc,      0.01000, 0.07568, -1.8658e-06, -2.4549e-02, -3.7961e+00, +7.9939e+00, -1.8270e+04, -9.0518e+04, +2.3235e+08, +8.1040e+08, -2.4656e+12, +9.3410e+15; 
 bc,      0.01000, 0.05755, -6.9437e-07, -1.9501e-02, -2.2458e+00, +2.9742e+00, -1.0525e+04, -1.8749e+04, +1.6339e+08, +2.9806e+08, -1.6673e+12, +6.2159e+15; 
 bc,      0.01000, 0.04544, -1.2861e-07, -1.2764e-03, -8.7276e-01, -4.5371e-01, -5.5830e+03, +2.6585e+04, +9.6483e+07, +1.2858e+06, -1.0053e+12, +3.9069e+15;
 m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
 bc,      0.03200, 0.11887, -3.6974e-08, +1.2757e-02, +1.1825e+00, +1.8453e+00, -4.6262e+03, +2.4200e+04, +7.3751e+07, -6.3579e+07, -7.8054e+11, +3.0544e+15; 
 bc,      0.03200, 0.09720, -9.0591e-07, -1.2063e-01, +5.2835e-01, +1.0917e+01, -3.2323e+03, -1.8683e+03, +4.9009e+07, -4.9946e+07, -4.6379e+11, +1.7988e+15;
 m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
 bc,      0.16000, 0.62161, -1.1668e-06, -8.9725e-01, +4.4207e-01, +3.2247e+01, +1.9416e+03, -2.8567e+05, -5.0265e+07, +1.4028e+09, +6.1042e+11, -2.5574e+15; 
 bc,      0.16000, 0.62274, +2.8034e-07, -9.0717e-01, +2.0879e-01, -6.2815e-01, +1.9822e+03, +2.4218e+05, -4.1507e+07, -1.1837e+09, +4.3276e+11, -1.5769e+15; 
 bc,      0.01200, 0.04249, +5.4796e-07, -8.8611e-01, +4.9910e-01, +2.4958e+01, -9.4206e+03, -1.6025e+05, +1.8960e+08, +8.8432e+08, -1.6666e+12, +5.5453e+15;
 bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;
 bc,      0.01400, 0.03339, -4.4895e-07, -4.4684e-01, -1.8750e+00, +2.2077e+01, -5.5912e+03, -1.6748e+05, +1.0327e+08, +9.3221e+08, -8.6332e+11, +2.7550e+15; 
 bc,      0.01600, 0.01935, +7.1551e-07, -1.1215e-01, -1.9597e+00, +1.3313e+01, -3.5424e+03, -1.6337e+05, +6.3653e+07, +8.9179e+08, -5.4044e+11, +1.7393e+15; 
 bc,      0.03500, 0.01344, +8.5843e-04, -1.9922e-02, -1.2879e+00, +7.6367e+00, +4.5874e+03, -8.3229e+04, -8.5862e+07, +4.1734e+08, +6.8108e+11, -1.9335e+15;
];



% % dipole model 2018-10-15
% % =======================
% % this (half) model is based on model-13, fieldmap
% % /home/fac_files/lnls-ima/si-dipoles-bc/model-13/analysis/fieldmap/3gev
% % '2018-10-10_bc_model13_X=-90_12mm_Z=-1000_1000mm.txt'
% monomials = [0,1,2,3,4,5,6,7,8,10];
% segmodel = [ ...
% %         len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)  
%  bc,      0.0010 ,  +0.01850 ,  +0.00e+00 ,  -6.87e-04 ,  -2.78e+01 ,  -8.86e+00 ,  -4.02e+05 ,  +2.25e+05 ,  -1.72e+09 ,  -1.40e+09 ,  -2.83e+13 ,  +1.23e+17; 
%  bc,      0.0040 ,  +0.07222 ,  +0.00e+00 ,  -4.91e-03 ,  -2.48e+01 ,  -5.58e+01 ,  -4.29e+05 ,  +1.61e+06 ,  -1.10e+08 ,  -9.82e+09 ,  -3.81e+13 ,  +1.52e+17; 
%  bc,      0.0050 ,  +0.08030 ,  +0.00e+00 ,  -2.10e-02 ,  -1.78e+01 ,  -3.63e+01 ,  -2.75e+05 ,  +1.25e+06 ,  -1.96e+08 ,  -5.44e+09 ,  -1.53e+13 ,  +6.46e+16; 
%  bc,      0.0050 ,  +0.06788 ,  +0.00e+00 ,  -2.72e-02 ,  -1.10e+01 ,  +1.03e+00 ,  -1.13e+05 ,  +4.19e+05 ,  -5.63e+08 ,  -1.43e+09 ,  +2.85e+12 ,  -1.02e+16; 
%  bc,      0.0050 ,  +0.05839 ,  +0.00e+00 ,  -2.71e-02 ,  -7.65e+00 ,  +7.25e+00 ,  -5.47e+04 ,  +1.73e+05 ,  -2.11e+08 ,  -6.16e+08 ,  +1.69e+12 ,  -6.75e+15; 
%  bc,      0.0100 ,  +0.09571 ,  +0.00e+00 ,  -2.62e-02 ,  -5.62e+00 ,  +7.17e+00 ,  -2.26e+04 ,  +6.17e+04 ,  -6.48e+07 ,  -2.23e+08 ,  +6.35e+11 ,  -2.65e+15; 
%  bc,      0.0100 ,  +0.07378 ,  +0.00e+00 ,  -2.60e-02 ,  -3.92e+00 ,  +5.24e+00 ,  -8.05e+03 ,  +1.95e+04 ,  -1.02e+07 ,  -6.91e+07 ,  +1.13e+11 ,  -5.12e+14; 
%  bc,      0.0100 ,  +0.05610 ,  +0.00e+00 ,  -2.53e-02 ,  -2.38e+00 ,  +3.00e+00 ,  -3.79e+03 ,  +1.60e+04 ,  +1.69e+07 ,  -5.98e+07 ,  -1.88e+11 ,  +7.11e+14; 
%  bc,      0.0100 ,  +0.04419 ,  +0.00e+00 ,  -2.07e-02 ,  -1.03e+00 ,  +2.37e+00 ,  -2.62e+02 ,  -5.86e+03 ,  -2.36e+07 ,  +3.43e+07 ,  +2.77e+11 ,  -1.13e+15; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,      0.0320 ,  +0.11553 ,  +0.00e+00 ,  -2.33e-02 ,  +9.03e-01 ,  +1.02e+00 ,  -4.30e+02 ,  +8.02e+03 ,  -7.50e+06 ,  -4.62e+06 ,  +7.01e+10 ,  -2.85e+14; 
%  bc,      0.0320 ,  +0.09676 ,  +0.00e+00 ,  -1.48e-01 ,  +2.86e-01 ,  +1.13e+01 ,  +1.69e+02 ,  -1.15e+04 ,  -1.57e+07 ,  +7.95e+07 ,  +1.88e+11 ,  -7.75e+14; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,      0.1600 ,  +0.62503 ,  +0.00e+00 ,  -8.88e-01 ,  +3.41e-01 ,  +1.35e+01 ,  +1.34e+02 ,  +1.06e+04 ,  +3.96e+06 ,  -2.74e+06 ,  -4.74e+10 ,  +1.89e+14; 
%  bc,      0.1600 ,  +0.62839 ,  +0.00e+00 ,  -9.03e-01 ,  +1.77e-01 ,  +1.07e+01 ,  +3.16e+02 ,  +8.88e+03 ,  -5.24e+05 ,  +1.26e+07 ,  +4.72e+09 ,  -1.99e+13; 
%  bc,      0.0120 ,  +0.04272 ,  +0.00e+00 ,  -8.74e-01 ,  +6.80e-02 ,  +1.84e+01 ,  +1.71e+03 ,  +1.20e+04 ,  -4.44e+07 ,  -1.36e+07 ,  +4.96e+11 ,  -1.91e+15; 
%  bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,      0.0140 ,  +0.03347 ,  +0.00e+00 ,  -4.34e-01 ,  -2.10e+00 ,  +1.31e+01 ,  -2.57e+03 ,  +3.74e+04 ,  +5.76e+07 ,  -1.39e+08 ,  -5.98e+11 ,  +2.24e+15; 
%  bc,      0.0160 ,  +0.01943 ,  +0.00e+00 ,  -1.07e-01 ,  -2.05e+00 ,  +4.19e+00 ,  +1.91e+02 ,  +2.05e+04 ,  -1.07e+07 ,  -5.52e+07 ,  +1.08e+11 ,  -3.73e+14; 
%  bc,      0.0350 ,  +0.01990 ,  -2.63e-05 ,  -1.89e-02 ,  -1.18e+00 ,  +2.73e+00 ,  +8.69e+01 ,  +3.46e+03 ,  -3.66e+06 ,  -1.75e+07 ,  +4.01e+10 ,  -1.49e+14; 
% ];


% % dipole model 2017-08-21
% % =======================
% % this (half) model is based on fieldmap
% % /home/fac_files/lnls-ima/si-dipoles-bc/model-12/analysis/fieldmap/3gev
% % '2017-08-21_bc_model12_X=-90_12mm_Z=-1000_1000mm.txt'
% monomials = [0,1,2,3,4,5,6,7,8,10];
% segmodel = [ ...
% %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
% %type    len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)  
%  bc,     0.0010 ,  +0.01811 ,  +0.00e+00 ,  -7.24e-04 ,  -3.47e+01 ,  +1.43e+01 ,  -4.22e+05 ,  -2.54e+05 ,  -1.85e+09 ,  +1.30e+09 ,  -2.14e+13 ,  +1.12e+17; 
%  bc,     0.0040 ,  +0.07079 ,  +0.00e+00 ,  -4.37e-03 ,  -3.17e+01 ,  -6.82e+01 ,  -4.36e+05 ,  +1.73e+06 ,  -5.58e+08 ,  -1.01e+10 ,  -2.76e+13 ,  +1.22e+17; 
%  bc,     0.0050 ,  +0.07926 ,  +0.00e+00 ,  -1.89e-02 ,  -2.33e+01 ,  -3.04e+01 ,  -2.85e+05 ,  +1.13e+06 ,  -2.61e+08 ,  -5.05e+09 ,  -1.24e+13 ,  +5.76e+16; 
%  bc,     0.0050 ,  +0.06748 ,  +0.00e+00 ,  -2.55e-02 ,  -1.46e+01 ,  +6.07e+00 ,  -1.19e+05 ,  +3.42e+05 ,  -5.11e+08 ,  -1.07e+09 ,  +2.60e+12 ,  -8.18e+15; 
%  bc,     0.0050 ,  +0.05823 ,  +0.00e+00 ,  -2.57e-02 ,  -9.80e+00 ,  +8.44e+00 ,  -5.66e+04 ,  +1.68e+05 ,  -1.97e+08 ,  -5.98e+08 ,  +1.66e+12 ,  -6.58e+15; 
%  bc,     0.0100 ,  +0.09572 ,  +0.00e+00 ,  -2.51e-02 ,  -6.65e+00 ,  +7.74e+00 ,  -2.29e+04 ,  +6.06e+04 ,  -6.27e+07 ,  -2.20e+08 ,  +6.40e+11 ,  -2.67e+15; 
%  bc,     0.0100 ,  +0.07398 ,  +0.00e+00 ,  -2.47e-02 ,  -4.32e+00 ,  +5.52e+00 ,  -8.13e+03 ,  +1.98e+04 ,  -9.65e+06 ,  -7.09e+07 ,  +1.11e+11 ,  -5.05e+14; 
%  bc,     0.0100 ,  +0.05634 ,  +0.00e+00 ,  -2.27e-02 ,  -2.55e+00 ,  +3.46e+00 ,  -3.93e+03 ,  +1.24e+04 ,  +2.05e+07 ,  -3.75e+07 ,  -2.37e+11 ,  +9.31e+14; 
%  bc,     0.0100 ,  +0.04442 ,  +0.00e+00 ,  -1.32e-02 ,  -1.09e+00 ,  +2.67e+00 ,  -2.80e+02 ,  -4.69e+03 ,  -2.38e+07 ,  +3.19e+07 ,  +2.80e+11 ,  -1.14e+15; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.0320 ,  +0.11599 ,  +0.00e+00 ,  -9.09e-03 ,  +9.07e-01 ,  +1.48e+00 ,  -4.07e+02 ,  +6.66e+03 ,  -7.84e+06 ,  -6.52e+06 ,  +7.39e+10 ,  -3.00e+14; 
%  bc,     0.0320 ,  +0.09680 ,  +0.00e+00 ,  -1.38e-01 ,  +3.20e-01 ,  +1.07e+01 ,  +1.76e+02 ,  -9.07e+03 ,  -1.64e+07 ,  +6.54e+07 ,  +1.97e+11 ,  -8.16e+14; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.1600 ,  +0.62773 ,  +0.00e+00 ,  -8.90e-01 ,  +3.19e-01 ,  +1.26e+01 ,  +1.06e+02 ,  +1.00e+04 ,  +3.95e+06 ,  -3.64e+06 ,  -4.71e+10 ,  +1.88e+14; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.1600 ,  +0.63145 ,  +0.00e+00 ,  -9.06e-01 ,  +1.55e-01 ,  +9.63e+00 ,  +2.87e+02 ,  +8.14e+03 ,  -6.01e+05 ,  +1.20e+07 ,  +5.81e+09 ,  -2.47e+13; 
%  bc,     0.0120 ,  +0.04291 ,  +0.00e+00 ,  -8.77e-01 ,  +4.85e-02 ,  +1.80e+01 ,  +8.37e+02 ,  -2.17e+04 ,  -1.87e+07 ,  +2.00e+08 ,  +2.16e+11 ,  -8.81e+14; 
%  bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;...
%  bc,     0.0140 ,  +0.03356 ,  +0.00e+00 ,  -4.36e-01 ,  -2.13e+00 ,  +9.42e+00 ,  -1.20e+03 ,  +6.79e+04 ,  +2.39e+07 ,  -2.85e+08 ,  -2.50e+11 ,  +9.60e+14; 
%  bc,     0.0160 ,  +0.01936 ,  +0.00e+00 ,  -1.08e-01 ,  -2.06e+00 ,  +3.12e+00 ,  +1.91e+02 ,  +2.03e+04 ,  -1.06e+07 ,  -5.57e+07 ,  +1.06e+11 ,  -3.64e+14; 
%  bc,     0.0350 ,  +0.01617 ,  -1.59e-04 ,  -1.89e-02 ,  -1.18e+00 ,  +2.57e+00 ,  +8.67e+01 ,  +3.56e+03 ,  -3.67e+06 ,  -1.78e+07 ,  +4.03e+10 ,  -1.49e+14; 
% ];


% % dipole model 2017-08-23 (quadrupole trim with tilt pole -3.0 degrees)
% % =====================================================================
% % this (half) model is based on fieldmap
% % /home/fac_files/lnls-ima/si-dipoles-bc/model-12/analysis/fieldmap/3gev-3ndeg
% % '2017-08-23_bc_model12_rot=-3deg_X=-90_12mm_Z=-1000_1000mm.txt'
% quadrupole_nom = segmodel(:,5); 
% monomials = [0,1,2,3,4,5,6,7,8,10];
% segmodel = [ ...
% %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
% %type    len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)  
%  bc,     0.0010 ,  +0.01812 ,  +0.00e+00 ,  +1.33e-03 ,  -3.47e+01 ,  +1.34e+01 ,  -4.22e+05 ,  -2.55e+05 ,  -1.85e+09 ,  +1.33e+09 ,  -2.14e+13 ,  +1.12e+17 ; 
%  bc,     0.0040 ,  +0.07083 ,  +0.00e+00 ,  -2.29e-03 ,  -3.17e+01 ,  -6.90e+01 ,  -4.36e+05 ,  +1.73e+06 ,  -5.54e+08 ,  -1.00e+10 ,  -2.76e+13 ,  +1.22e+17 ; 
%  bc,     0.0050 ,  +0.07930 ,  +0.00e+00 ,  -1.67e-02 ,  -2.33e+01 ,  -3.11e+01 ,  -2.85e+05 ,  +1.14e+06 ,  -2.60e+08 ,  -5.05e+09 ,  -1.24e+13 ,  +5.77e+16 ; 
%  bc,     0.0050 ,  +0.06751 ,  +0.00e+00 ,  -2.29e-02 ,  -1.46e+01 ,  +6.65e+00 ,  -1.19e+05 ,  +3.21e+05 ,  -5.00e+08 ,  -9.39e+08 ,  +2.44e+12 ,  -7.41e+15 ; 
%  bc,     0.0050 ,  +0.05826 ,  +0.00e+00 ,  -2.25e-02 ,  -9.80e+00 ,  +8.37e+00 ,  -5.67e+04 ,  +1.69e+05 ,  -1.96e+08 ,  -6.04e+08 ,  +1.65e+12 ,  -6.54e+15 ; 
%  bc,     0.0100 ,  +0.09577 ,  +0.00e+00 ,  -2.03e-02 ,  -6.65e+00 ,  +8.27e+00 ,  -2.29e+04 ,  +6.06e+04 ,  -6.28e+07 ,  -2.20e+08 ,  +6.41e+11 ,  -2.68e+15 ; 
%  bc,     0.0100 ,  +0.07402 ,  +0.00e+00 ,  -1.55e-02 ,  -4.30e+00 ,  +7.88e+00 ,  -8.14e+03 ,  +1.91e+04 ,  -9.25e+06 ,  -6.85e+07 ,  +1.07e+11 ,  -4.89e+14 ; 
%  bc,     0.0100 ,  +0.05639 ,  +0.00e+00 ,  +3.35e-03 ,  -2.42e+00 ,  +1.01e+01 ,  -4.05e+03 ,  +1.33e+04 ,  +2.47e+07 ,  -4.19e+07 ,  -2.84e+11 ,  +1.11e+15 ; 
%  bc,     0.0100 ,  +0.04447 ,  +0.00e+00 ,  +7.28e-02 ,  -5.60e-01 ,  +1.60e+01 ,  -8.23e+01 ,  -3.44e+03 ,  -2.65e+07 ,  +4.62e+07 ,  +3.05e+11 ,  -1.22e+15 ; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.0320 ,  +0.11574 ,  +0.00e+00 ,  +1.68e-01 ,  +1.70e+00 ,  +1.51e+01 ,  -4.46e+02 ,  -1.91e+04 ,  -1.02e+07 ,  -1.20e+07 ,  +1.01e+11 ,  -4.14e+14 ; 
%  bc,     0.0320 ,  +0.09655 ,  +0.00e+00 ,  -2.98e-03 ,  +1.43e+00 ,  +1.30e+01 ,  +1.23e+02 ,  -1.63e+04 ,  -1.88e+07 ,  +9.08e+07 ,  +2.26e+11 ,  -9.34e+14 ; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.1600 ,  +0.62779 ,  +0.00e+00 ,  -8.88e-01 ,  +3.76e-01 ,  +1.31e+01 ,  +5.79e+01 ,  +9.98e+03 ,  +4.88e+06 ,  -6.25e+06 ,  -5.80e+10 ,  +2.32e+14 ; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.1600 ,  +0.63154 ,  +0.00e+00 ,  -9.06e-01 ,  +1.57e-01 ,  +9.41e+00 ,  +2.31e+02 ,  +1.18e+04 ,  +4.99e+05 ,  -6.99e+06 ,  -4.29e+09 ,  +1.03e+13 ; 
%  bc,     0.0120 ,  +0.04292 ,  +0.00e+00 ,  -8.77e-01 ,  +5.41e-02 ,  +1.57e+01 ,  +1.19e+03 ,  +2.81e+04 ,  -3.26e+07 ,  -8.81e+07 ,  +3.69e+11 ,  -1.42e+15 ; 
%  bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;...
%  bc,     0.0140 ,  +0.03357 ,  +0.00e+00 ,  -4.36e-01 ,  -2.13e+00 ,  +9.57e+00 ,  -1.47e+03 ,  +6.63e+04 ,  +2.91e+07 ,  -2.85e+08 ,  -2.93e+11 ,  +1.08e+15 ; 
%  bc,     0.0160 ,  +0.01936 ,  +0.00e+00 ,  -1.08e-01 ,  -2.06e+00 ,  +3.11e+00 ,  +1.90e+02 ,  +2.02e+04 ,  -1.05e+07 ,  -5.50e+07 ,  +1.05e+11 ,  -3.64e+14 ; 
%  bc,     0.0350 ,  +0.01616 ,  -8.23e-04 ,  -1.89e-02 ,  -1.18e+00 ,  +2.57e+00 ,  +8.52e+01 ,  +3.55e+03 ,  -3.61e+06 ,  -1.76e+07 ,  +3.96e+10 ,  -1.47e+14 ;
% ];
% quadrupole_new = segmodel(:,5);
% 
% % normalizes integrated quadrupole to nominal value
% intquad_nom = sum(quadrupole_nom .* segmodel(:,2));
% intquad_new = sum(quadrupole_new .* segmodel(:,2));
% segmodel(:,5) = segmodel(:,5) * (intquad_nom/intquad_new);


% % dipole model 2017-08-23 (quadrupole trim with tilt pole +3.0 degrees)
% % =====================================================================
% % this (half) model is based on fieldmap
% % /home/fac_files/lnls-ima/si-dipoles-bc/model-12/analysis/fieldmap/3gev-3pdeg
% % '2017-08-23_bc_model12_rot=3deg_X=-90_12mm_Z=-1000_1000mm.txt'
% quadrupole_nom = segmodel(:,5); 
% monomials = [0,1,2,3,4,5,6,7,8,10];
% segmodel = [ ...
% %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
% %type    len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)  
%  bc,     0.0010 ,  +0.01811 ,  +0.00e+00 ,  -2.84e-03 ,  -3.47e+01 ,  +1.52e+01 ,  -4.22e+05 ,  -2.53e+05 ,  -1.85e+09 ,  +1.28e+09 ,  -2.14e+13 ,  +1.12e+17 ; 
%  bc,     0.0040 ,  +0.07079 ,  +0.00e+00 ,  -6.52e-03 ,  -3.17e+01 ,  -6.72e+01 ,  -4.36e+05 ,  +1.73e+06 ,  -5.57e+08 ,  -1.01e+10 ,  -2.76e+13 ,  +1.22e+17 ; 
%  bc,     0.0050 ,  +0.07925 ,  +0.00e+00 ,  -2.13e-02 ,  -2.33e+01 ,  -2.98e+01 ,  -2.85e+05 ,  +1.13e+06 ,  -2.60e+08 ,  -5.05e+09 ,  -1.24e+13 ,  +5.77e+16 ; 
%  bc,     0.0050 ,  +0.06747 ,  +0.00e+00 ,  -2.82e-02 ,  -1.46e+01 ,  +7.27e+00 ,  -1.19e+05 ,  +3.19e+05 ,  -5.01e+08 ,  -9.44e+08 ,  +2.45e+12 ,  -7.47e+15 ; 
%  bc,     0.0050 ,  +0.05823 ,  +0.00e+00 ,  -2.90e-02 ,  -9.80e+00 ,  +8.53e+00 ,  -5.67e+04 ,  +1.68e+05 ,  -1.96e+08 ,  -6.03e+08 ,  +1.65e+12 ,  -6.55e+15 ; 
%  bc,     0.0100 ,  +0.09571 ,  +0.00e+00 ,  -3.00e-02 ,  -6.65e+00 ,  +7.24e+00 ,  -2.29e+04 ,  +6.11e+04 ,  -6.27e+07 ,  -2.25e+08 ,  +6.40e+11 ,  -2.67e+15 ; 
%  bc,     0.0100 ,  +0.07397 ,  +0.00e+00 ,  -3.43e-02 ,  -4.31e+00 ,  +3.35e+00 ,  -8.09e+03 ,  +2.00e+04 ,  -1.09e+07 ,  -7.15e+07 ,  +1.25e+11 ,  -5.55e+14 ; 
%  bc,     0.0100 ,  +0.05636 ,  +0.00e+00 ,  -4.94e-02 ,  -2.47e+00 ,  -2.73e+00 ,  -3.71e+03 ,  +1.30e+04 ,  +1.46e+07 ,  -4.08e+07 ,  -1.70e+11 ,  +6.71e+14 ; 
%  bc,     0.0100 ,  +0.04447 ,  +0.00e+00 ,  -1.01e-01 ,  -6.81e-01 ,  -1.03e+01 ,  -1.19e+02 ,  -2.46e+03 ,  -2.69e+07 ,  +1.72e+07 ,  +3.19e+11 ,  -1.30e+15 ; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.0320 ,  +0.11601 ,  +0.00e+00 ,  -1.89e-01 ,  +1.74e+00 ,  -1.11e+01 ,  -7.62e+02 ,  +3.42e+04 ,  -4.82e+06 ,  -5.24e+06 ,  +3.61e+10 ,  -1.45e+14 ; 
%  bc,     0.0320 ,  +0.09676 ,  +0.00e+00 ,  -2.76e-01 ,  +4.13e-01 ,  +1.02e+01 ,  +1.50e+02 ,  -5.13e+03 ,  -1.36e+07 ,  +4.78e+07 ,  +1.63e+11 ,  -6.72e+14 ; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.1600 ,  +0.62770 ,  +0.00e+00 ,  -8.92e-01 ,  +2.72e-01 ,  +1.22e+01 ,  +1.41e+02 ,  +9.85e+03 ,  +3.34e+06 ,  -1.94e+06 ,  -4.02e+10 ,  +1.60e+14 ; 
%  m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;
%  bc,     0.1600 ,  +0.63146 ,  +0.00e+00 ,  -9.06e-01 ,  +1.57e-01 ,  +9.41e+00 ,  +2.30e+02 ,  +1.18e+04 ,  +5.04e+05 ,  -7.21e+06 ,  -4.17e+09 ,  +9.28e+12 ; 
%  bc,     0.0120 ,  +0.04291 ,  +0.00e+00 ,  -8.77e-01 ,  +5.63e-02 ,  +1.53e+01 ,  +1.00e+03 ,  +3.45e+04 ,  -2.98e+07 ,  -1.16e+08 ,  +3.63e+11 ,  -1.48e+15 ; 
%  bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;...
%  bc,     0.0140 ,  +0.03357 ,  +0.00e+00 ,  -4.36e-01 ,  -2.13e+00 ,  +1.30e+01 ,  -1.70e+03 ,  +9.69e+03 ,  +3.99e+07 ,  +5.10e+06 ,  -4.33e+11 ,  +1.67e+15 ; 
%  bc,     0.0160 ,  +0.01936 ,  +0.00e+00 ,  -1.08e-01 ,  -2.04e+00 ,  +3.66e+00 ,  -1.06e+03 ,  +2.34e+03 ,  +2.05e+07 ,  +5.47e+07 ,  -2.13e+11 ,  +7.96e+14 ; 
%  bc,     0.0350 ,  +0.01617 ,  -1.70e-04 ,  -1.89e-02 ,  -1.18e+00 ,  +2.60e+00 ,  -7.05e+01 ,  +1.70e+03 ,  +9.86e+05 ,  -2.53e+06 ,  -1.21e+10 ,  +5.27e+13 ;
% ];
% quadrupole_new = segmodel(:,5);
% 
% % normalizes integrated quadrupole to nominal value
% intquad_nom = sum(quadrupole_nom .* segmodel(:,2));
% intquad_new = sum(quadrupole_new .* segmodel(:,2));
% segmodel(:,5) = segmodel(:,5) * (intquad_nom/intquad_new);

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
mc = marker('mc', 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mc, m_accep, b];
