function [model, model_length] = sirius_si_b2_segmented_model(passmethod, m_accep_fam_name)

b_famname = 'B2';
mb_famname = ['m',b_famname];
edge_famname = [b_famname, '_edge'];

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
b2      = 1; types{end+1} = struct('fam_name', b_famname, 'passmethod', passmethod);
b2_edge = 2; types{end+1} = struct('fam_name', edge_famname, 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


% FIELDMAP
% *** interpolation of fields is now cubic ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---

% B2 model 08 (3 GeV)
% ===================
% filename: 2017-05-17_B2_Model08_Sim_X=-63_27mm_Z=-1000_1000mm_Imc=394.1A.txt
% trajectory centered in good-field region.
% init_rx is set to  7.92 mm at s=0

% monomials = [0,1,2,3,4,5,6];
% segmodel = [ ...
% %type     len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   
% b2,        0.1250 ,  +0.40481 ,  +0.00e+00 ,  -7.74e-01 ,  +4.46e-02 ,  +1.66e+00 ,  +3.21e+01 ,  +3.14e+03 ,  +1.33e+05 ; 
% b2,        0.0550 ,  +0.17931 ,  +0.00e+00 ,  -7.74e-01 ,  +2.77e-02 ,  +1.44e+00 ,  +2.26e+01 ,  +2.92e+03 ,  +1.21e+05 ; 
% b2,        0.0100 ,  +0.03263 ,  +0.00e+00 ,  -7.74e-01 ,  +1.78e-02 ,  +1.27e+00 ,  -1.80e+01 ,  +4.06e+03 ,  +9.54e+04 ; 
% b2,        0.0050 ,  +0.01626 ,  +0.00e+00 ,  -7.67e-01 ,  -1.88e-02 ,  +3.45e-01 ,  -3.28e+01 ,  +5.41e+03 ,  +7.86e+03 ; 
% b2,        0.0050 ,  +0.01620 ,  +0.00e+00 ,  -7.59e-01 ,  -1.50e-01 ,  +3.96e-01 ,  -4.87e+01 ,  +6.49e+03 ,  +4.25e+04 ; 
% b2,        0.0050 ,  +0.01617 ,  +0.00e+00 ,  -7.53e-01 ,  -2.68e-01 ,  +1.14e+00 ,  -3.73e+01 ,  +7.62e+03 ,  -7.89e+04 ; 
% m_accep,  0,0,0,0,0,0,0,0,0;
% b2,        0.0050 ,  +0.01619 ,  +0.00e+00 ,  -7.56e-01 ,  -1.95e-01 ,  +6.57e-01 ,  -4.55e+01 ,  +7.04e+03 ,  +2.61e+03 ; 
% b2,        0.0100 ,  +0.03253 ,  +0.00e+00 ,  -7.68e-01 ,  -1.11e-02 ,  +6.49e-01 ,  -3.45e+01 ,  +5.44e+03 ,  +3.61e+04 ; 
% b2,        0.0100 ,  +0.03265 ,  +0.00e+00 ,  -7.74e-01 ,  +2.23e-02 ,  +1.71e+00 ,  -1.24e+00 ,  +3.61e+03 ,  +1.07e+05 ; 
% b2,        0.1750 ,  +0.56774 ,  +0.00e+00 ,  -7.73e-01 ,  +8.13e-02 ,  +2.99e+00 ,  +5.39e+01 ,  +2.92e+03 ,  +1.23e+05 ; 
% b2,        0.1750 ,  +0.56735 ,  +0.00e+00 ,  -7.73e-01 ,  +1.07e-01 ,  +4.38e+00 ,  +8.27e+01 ,  +3.27e+03 ,  +1.22e+05 ; 
% b2,        0.0200 ,  +0.06336 ,  +0.00e+00 ,  -7.91e-01 ,  -3.03e-02 ,  +8.98e+00 ,  +8.71e+01 ,  +7.12e+03 ,  +3.61e+04 ; 
% b2,        0.0100 ,  +0.02751 ,  +0.00e+00 ,  -6.82e-01 ,  -2.04e-01 ,  +1.38e+01 ,  -1.03e+02 ,  +1.27e+04 ,  -2.77e+05 ; 
% b2_edge, 0,0,0,0,0,0,0,0,0;
% b2,        0.0150 ,  +0.02960 ,  +0.00e+00 ,  -3.61e-01 ,  -2.44e+00 ,  +1.92e+01 ,  -2.39e+02 ,  +1.75e+04 ,  -2.13e+05 ; 
% b2,        0.0200 ,  +0.02204 ,  +0.00e+00 ,  -1.08e-01 ,  -2.48e+00 ,  +1.07e+01 ,  -1.61e+02 ,  +7.25e+03 ,  +2.19e+03 ; 
% b2,        0.0300 ,  +0.01445 ,  +0.00e+00 ,  -2.59e-02 ,  -1.22e+00 ,  +4.05e+00 ,  -8.35e+00 ,  +6.42e+02 ,  +2.43e+04 ; 
% b2,        0.0320 ,  +0.00530 ,  +0.00e+00 ,  -5.22e-03 ,  -3.59e-01 ,  +1.00e+00 ,  +1.67e+01 ,  -4.09e+01 ,  +3.58e+03 ; 
% b2,        0.0325 ,  +0.00410 ,  +6.74e-06 ,  -1.02e-03 ,  -1.49e-01 ,  +2.51e-01 ,  +6.75e+00 ,  -1.79e+01 ,  +3.81e+01 ;
% m_accep,  0,0,0,0,0,0,0,0,0;
% ];


% Average Dipole Model for B2 at current 401p8A
% =============================================
% date: 2019-01-30
% Based on multipole expansion around average segmented model trajectory calculated
% from fieldmap analysis of measured data
% init_rx =  8.153 mm
% ref_rx  = 19.428 mm (average model trajectory)
% goal_tunes = [49.096188917357331, 14.151971558423915];
% goal_chrom = [2.549478494984214, 2.527086095938103];

monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   
b2,       0.12500, 0.40623207, +2.8141e-07, -7.7535e-01, +3.8504e-02, +1.7048e+00, -2.6809e+02, +8.8090e+03, +1.8541e+06; 
b2,       0.05500, 0.17963415, +2.4869e-07, -7.7400e-01, +1.8903e-02, +1.3538e+00, -2.7871e+02, +8.4667e+03, +1.7913e+06; 
b2,       0.01000, 0.03260439, -1.4532e-07, -7.6990e-01, -7.3993e-03, +1.4325e+00, -3.7053e+02, +9.0098e+03, +1.8818e+06; 
b2,       0.00500, 0.01623988, -9.6976e-07, -7.6272e-01, -4.4905e-02, +3.7505e-01, -4.0759e+02, +1.0527e+04, +1.8729e+06; 
b2,       0.00500, 0.01618634, -8.5112e-08, -7.5413e-01, -1.7000e-01, +1.3254e-01, -4.2095e+02, +1.2650e+04, +1.8762e+06; 
b2,       0.00500, 0.01615890, +5.0825e-07, -7.4866e-01, -2.8166e-01, +7.1392e-01, -3.5386e+02, +1.3287e+04, +1.5160e+06; 
m_accep,  0,0,0,0,0,0,0,0,0;
b2,       0.00500, 0.01618220, +1.7001e-06, -7.5218e-01, -2.1312e-01, +3.8486e-01, -3.9031e+02, +1.2889e+04, +1.7072e+06; 
b2,       0.01000, 0.03253671, +1.3585e-06, -7.6428e-01, -4.1565e-02, +6.7680e-01, -4.0577e+02, +1.0602e+04, +1.8735e+06; 
b2,       0.01000, 0.03269244, +2.9027e-07, -7.7165e-01, -8.0002e-03, +1.7812e+00, -3.2568e+02, +8.2067e+03, +1.7365e+06; 
b2,       0.17500, 0.57072732, -1.1637e-07, -7.7428e-01, +6.8988e-02, +4.1024e+00, -5.1871e+01, +7.5752e+02, +5.9943e+05; 
b2,       0.17500, 0.57033927, -3.3225e-07, -7.7352e-01, +7.8447e-02, +5.4514e+00, +1.9975e+02, +3.3621e+03, -3.1314e+05; 
b2,       0.02000, 0.06315500, +2.2577e-08, -7.8534e-01, -1.4538e-01, +9.2976e+00, -1.5715e+02, +1.2311e+04, +1.1408e+06; 
b2,       0.01000, 0.02719024, +8.7645e-08, -6.7626e-01, -3.1354e-01, +1.6050e+01, -3.9938e+02, +1.6288e+04, +8.1085e+05; 
b2_edge, 0,0,0,0,0,0,0,0,0;
b2,       0.01500, 0.02866488, +6.3204e-08, -3.6034e-01, -2.3415e+00, +2.0402e+01, -3.9166e+02, +1.9055e+04, +3.1586e+05; 
b2,       0.02000, 0.01993524, +5.4460e-07, -1.0711e-01, -2.1654e+00, +1.1296e+01, -1.7816e+02, +7.2357e+03, +1.6786e+05; 
b2,       0.03000, 0.01188171, +1.3393e-07, -2.3886e-02, -8.9207e-01, +3.8284e+00, -1.5146e+01, +5.3693e+02, +7.8230e+04; 
b2,       0.03200, 0.00444341, -2.8999e-07, -4.5556e-03, -2.6166e-01, +7.8754e-01, +1.5573e+00, +8.3579e+01, +3.8831e+04; 
b2,       0.03250, 0.00339585, -1.3468e-07, -1.2481e-03, -1.3069e-01, +3.6679e-01, +1.3671e+01, -7.7370e+02, -2.9544e+04; 
m_accep,  0,0,0,0,0,0,0,0,0;
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
mb2 = marker(mb_famname, 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mb2, m_accep, b];
