function [model, model_length] = sirius_si_bc_segmented_model(passmethod, m_accep_fam_name)

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
bc   = 1; types{end+1} = struct('fam_name', 'BC', 'passmethod', passmethod);
bc_edge = 2; types{end+1} = struct('fam_name', 'BC_EDGE', 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');

% Average Dipole Model for BC
% =============================================
% date: 2019-06-27
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
bc,       0.00100, 0.01877, -1.4741e-05, -3.2459e-03, -2.5934e+01, +2.2655e+02, -4.2041e+05, -1.9362e+06, -8.8515e+08, +1.8066e+10, -4.1927e+13, +1.8535e+17;
bc,       0.00400, 0.07328, -3.5868e-06, -8.0872e-03, -2.3947e+01, +1.9896e+02, -3.8312e+05, -1.5555e+06, -8.7538e+08, +1.5588e+10, -3.4411e+13, +1.5036e+17;
bc,       0.00500, 0.08149, -1.5878e-06, -2.2156e-02, -1.6636e+01, +9.5225e+01, -2.4803e+05, -2.8667e+05, -6.2015e+08, +5.9788e+09, -1.1795e+13, +5.3967e+16;
bc,       0.00500, 0.06914, -2.2515e-06, -2.6794e-02, -9.9744e+00, +4.0910e+01, -1.2934e+05, -1.8459e+04, +6.5912e+06, +1.8432e+09, -3.7282e+12, +1.5831e+16;
bc,       0.00500, 0.05972, +2.4800e-07, -2.6704e-02, -7.1238e+00, +2.8365e+01, -7.1836e+04, -1.7947e+05, +2.5073e+08, +1.9029e+09, -3.3936e+12, +1.2829e+16;
bc,       0.01000, 0.09814, -7.2919e-07, -2.5788e-02, -5.4243e+00, +1.8297e+01, -3.6399e+04, -1.8928e+05, +2.7961e+08, +1.5270e+09, -3.1054e+12, +1.1735e+16;
bc,       0.01000, 0.07568, -1.8658e-06, -2.4549e-02, -3.7961e+00, +7.9939e+00, -1.8270e+04, -9.0518e+04, +2.3235e+08, +8.1040e+08, -2.4656e+12, +9.3410e+15;
bc,       0.01000, 0.05755, -6.9437e-07, -1.9501e-02, -2.2458e+00, +2.9742e+00, -1.0525e+04, -1.8749e+04, +1.6339e+08, +2.9806e+08, -1.6673e+12, +6.2159e+15;
bc,       0.01000, 0.04544, -1.2861e-07, -1.2764e-03, -8.7276e-01, -4.5371e-01, -5.5830e+03, +2.6585e+04, +9.6483e+07, +1.2858e+06, -1.0053e+12, +3.9069e+15;
m_accep,  0,0,0,0,0,0,0,0,0,0,0,0;
bc,       0.03200, 0.11887, -3.6974e-08, +1.2757e-02, +1.1825e+00, +1.8453e+00, -4.6262e+03, +2.4200e+04, +7.3751e+07, -6.3579e+07, -7.8054e+11, +3.0544e+15;
bc,       0.03200, 0.09720, -9.0591e-07, -1.2063e-01, +5.2835e-01, +1.0917e+01, -3.2323e+03, -1.8683e+03, +4.9009e+07, -4.9946e+07, -4.6379e+11, +1.7988e+15;
m_accep,  0,0,0,0,0,0,0,0,0,0,0,0;
bc,       0.16000, 0.62161, -1.1668e-06, -8.9725e-01, +4.4207e-01, +3.2247e+01, +1.9416e+03, -2.8567e+05, -5.0265e+07, +1.4028e+09, +6.1042e+11, -2.5574e+15;
bc,       0.16000, 0.62274, +2.8034e-07, -9.0717e-01, +2.0879e-01, -6.2815e-01, +1.9822e+03, +2.4218e+05, -4.1507e+07, -1.1837e+09, +4.3276e+11, -1.5769e+15;
bc,       0.01200, 0.04249, +5.4796e-07, -8.8611e-01, +4.9910e-01, +2.4958e+01, -9.4206e+03, -1.6025e+05, +1.8960e+08, +8.8432e+08, -1.6666e+12, +5.5453e+15;
bc_edge,  0,0,0,0,0,0,0,0,0,0,0,0;
bc,       0.01400, 0.03339, -4.4895e-07, -4.4684e-01, -1.8750e+00, +2.2077e+01, -5.5912e+03, -1.6748e+05, +1.0327e+08, +9.3221e+08, -8.6332e+11, +2.7550e+15;
bc,       0.01600, 0.01935, +7.1551e-07, -1.1215e-01, -1.9597e+00, +1.3313e+01, -3.5424e+03, -1.6337e+05, +6.3653e+07, +8.9179e+08, -5.4044e+11, +1.7393e+15;
bc,       0.03500, 0.01344, -1.7487e-07, -1.9828e-02, -1.2534e+00, +1.9342e+01, +2.8084e+03, -2.9546e+05, -5.0640e+07, +1.4694e+09, +4.0940e+11, -1.2172e+15;
];

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
