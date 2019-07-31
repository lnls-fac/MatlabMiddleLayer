function [model, model_length] = sirius_bo_b_segmented_model(energy, famname, passmethod, strength)

types = {};
b      = 1; types{end+1} = struct('fam_name', famname, 'passmethod', passmethod);
b_edge = 2; types{end+1} = struct('fam_name', 'edgeB', 'passmethod', 'IdentityPass');
b_pb   = 3; types{end+1} = struct('fam_name', 'physB', 'passmethod', 'IdentityPass');

% FIELDMAP
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% *** interpolation of fields is now cubic ***
% *** dipole angles were normalized to better close 360 degrees ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
monomials = [0,1,2,3,4,5,6];

% Average Dipole Model for BD at 3GeV (991.63A)
% =============================================
% date: 2019-07-26
% Based on multipole expansion around reference trajectory from fieldmap analysis of measurement data
% folder = bo-dipoles/model-09/analysis/hallprobe/production/x-ref-28p255mm-reftraj
% ref_rx  = 28.255 mm (used in the alignment)
% init_rx = 9.1476 mm (value that matches ref_rx for the average model)
% goal_tunes = [19.20433, 7.31417];
% goal_chrom = [0.5, 0.5];

segmodel_3GeV = [ ...
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
%type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
b,      0.19600, 1.16095, -4.5855e-05, -2.2616e-01, -1.9931e+00, -5.2809e+00, -7.2055e+01, -2.8342e+04, -2.0405e+06;
b,      0.19200, 1.14607, -4.6296e-05, -2.1071e-01, -1.9221e+00, -4.9789e+00, -1.5270e+02, +2.4240e+03, -7.1606e+05;
b,      0.18200, 1.09390, -4.5705e-05, -1.8355e-01, -1.9326e+00, +1.7971e+00, -2.7381e+02, +3.4881e+03, +2.5253e+05;
b,      0.01000, 0.04988, -3.7956e-05, -2.3442e-01, -2.1923e+00, +2.3988e+01, -9.6648e+02, +4.2551e+04, -2.6469e+05;
b,      0.01000, 0.03607, -3.2233e-05, -1.5777e-01, -1.7058e+00, +3.5159e+01, -8.1160e+02, +5.4334e+03, -2.2594e+06;
b_edge, 0,0,0,0,0,0,0,0,0
b,      0.01300, 0.03238, -2.5586e-05, -5.1427e-02, -2.0566e+00, +2.7487e+01, -1.4495e+03, +1.5325e+04, +2.2138e+06;
b,      0.01700, 0.02914, -1.5916e-05, +3.1680e-03, -2.3815e+00, +1.5507e+01, -4.7649e+02, +1.1270e+03, +2.4813e+05;
b,      0.02000, 0.02274, -1.1903e-05, +2.1920e-02, -2.1754e+00, +3.5485e+00, +4.8788e+01, -3.0931e+03, -6.3494e+05;
b,      0.03000, 0.01848, -7.3813e-06, +1.8886e-02, -1.4361e+00, -1.4453e+00, +9.1969e+01, +3.0972e+03, -3.0985e+05;
b,      0.05000, 0.01039, +3.2630e-04, +8.5522e-03, -5.0122e-01, -6.4221e-01, -4.7512e+01, -6.7946e+02, +3.8237e+05;
b_pb,   0,0,0,0,0,0,0,0,0
];

% % Dipole Model for BD-006 at 149.3018 MeV (60.46A)
% % =============================================
% % date: 2019-07-29
% % Based on multipole expansion around reference trajectory from fieldmap analysis of measurement data
% % folder = bo-dipoles/model-09/analysis/hallprobe/excitation_curve/x-ref-28p255mm-reftraj/bd-006/0060p46A
% % ref_rx  = 28.255 mm (used in the alignment)
% % init_rx = 9.1563 mm (average, different for each dipole to match ref_rx)
% % goal_tunes = [19.20433, 7.31417];
% % goal_chrom = [0.5, 0.5];

segmodel_150MeV = [ ...
b,      0.19600, 1.16095, -2.9521e-05, -2.2953e-01, -1.9835e+00, -3.1164e+00, -5.5670e+02, -1.7476e+04, -5.0956e+05;
b,      0.19200, 1.14607, +4.6028e-05, -2.1389e-01, -1.9732e+00, +1.0720e+00, -3.3952e+02, -2.9134e+04, +1.6710e+06; 
b,      0.18200, 1.09390, +4.6495e-04, -1.8724e-01, -1.9278e+00, -3.4280e-01, -2.5900e+02, -3.8416e+03, +4.5036e+05; 
b,      0.01000, 0.04988, +1.3811e-03, -2.5658e-01, -1.8540e+00, +1.4360e+01, +1.5288e+03, -8.5204e+03, -8.8288e+06; 
b,      0.01000, 0.03607, +1.0497e-03, -1.7873e-01, -1.3828e+00, +1.7956e+01, +1.1377e+03, +2.1959e+04, -9.8321e+06; 
b_edge, 0,0,0,0,0,0,0,0,0
b,      0.01300, 0.03238, +3.7135e-04, -6.0692e-02, -1.9748e+00, +1.9712e+01, +4.7660e+02, +2.6825e+04, -6.4633e+06; 
b,      0.01700, 0.02914, +3.8800e-05, +1.0925e-03, -2.4287e+00, +9.8002e+00, +1.9017e+02, +2.7471e+04, -2.9952e+06; 
b,      0.02000, 0.02274, -1.4480e-04, +2.2144e-02, -2.2824e+00, -3.1138e-01, +7.3542e+02, +2.3161e+04, -3.8130e+06; 
b,      0.03000, 0.01848, -2.0692e-04, +2.0159e-02, -1.4701e+00, -6.1800e+00, -1.6290e+01, +3.2373e+04, +2.7180e+05; 
b,      0.05000, 0.01039, -8.3314e-04, +6.7566e-03, -4.7985e-01, +1.4036e+00, -2.2084e+02, -8.8720e+03, +1.0762e+06; 
b_pb,   0,0,0,0,0,0,0,0,0
];


% % Average Dipole Model for BD at 3GeV (991.63A)
% % =============================================
% % date: 2019-07-26
% % Based on multipole expansion around Runge-Kutta trajectory from fieldmap analysis of measurement data
% % folder = bo-dipoles/model-09/analysis/hallprobe/production/x-ref-28p255mm
% % ref_rx  = 28.255 mm (used in the alignment)
% % init_rx = 9.1563 mm (average, different for each dipole to match ref_rx)
% % goal_tunes = [19.20433, 7.31417];
% % goal_chrom = [0.5, 0.5];

% segmodel_3GeV = [ ...
% %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
% %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
% b,      0.19600, 1.16095, +0.0000e+00, -2.2622e-01, -1.9932e+00, -5.2709e+00, -6.8136e+01, -2.8555e+04, -2.0713e+06;
% b,      0.19200, 1.14607, +0.0000e+00, -2.1074e-01, -1.9223e+00, -5.0262e+00, -1.5015e+02, +2.6576e+03, -7.2840e+05;
% b,      0.18200, 1.09390, +0.0000e+00, -1.8368e-01, -1.9324e+00, +1.7863e+00, -2.7103e+02, +3.4562e+03, +2.3668e+05;
% b,      0.01000, 0.04988, +0.0000e+00, -2.3446e-01, -2.1906e+00, +2.3908e+01, -9.7166e+02, +4.2522e+04, -2.1112e+05;
% b,      0.01000, 0.03607, +0.0000e+00, -1.5782e-01, -1.7030e+00, +3.5090e+01, -8.2703e+02, +5.3668e+03, -2.1745e+06;
% b_edge, 0,0,0,0,0,0,0,0,0
% b,      0.01300, 0.03238, +0.0000e+00, -5.1496e-02, -2.0550e+00, +2.7363e+01, -1.4521e+03, +1.5704e+04, +2.2365e+06;
% b,      0.01700, 0.02914, +0.0000e+00, +3.0831e-03, -2.3811e+00, +1.5489e+01, -4.7125e+02, +1.0624e+03, +2.1724e+05;
% b,      0.02000, 0.02274, +0.0000e+00, +2.1839e-02, -2.1749e+00, +3.5905e+00, +4.9090e+01, -3.3930e+03, -6.3600e+05;
% b,      0.03000, 0.01848, +0.0000e+00, +1.8832e-02, -1.4357e+00, -1.4438e+00, +9.1314e+01, +3.1014e+03, -3.0267e+05;
% b,      0.05000, 0.01040, -5.8820e-04, +7.1654e-03, -4.7666e-01, -6.3332e-01, -1.3312e+01, +1.5719e+01, +2.3187e+05;
% b_pb,   0,0,0,0,0,0,0,0,0
% ];

% % Dipole Model for BD-006 at 149.3018 MeV (60.46A)
% % =============================================
% % date: 2019-07-29
% % Based on multipole expansion around Runge-Kutta trajectory from fieldmap analysis of measurement data
% % folder = bo-dipoles/model-09/analysis/hallprobe/excitation_curve/x0-9p1013mm/bd-006/0060p46A
% % ref_rx  = 28.255 mm (used in the alignment)
% % init_rx = 9.1013 mm (value used in bd-004 to match required ref_rx)
% % goal_tunes = [19.20433, 7.31417];
% % goal_chrom = [0.5, 0.5];
% 
% segmodel_150MeV = [ ...
% b,      0.19600, 1.16080, +0.0000e+00, -2.2900e-01, -1.9850e+00, -2.8750e+00, -5.8000e+02, -1.8380e+04, -3.5200e+05; 
% b,      0.19200, 1.14674, +0.0000e+00, -2.1350e-01, -1.9700e+00, +1.0605e+00, -3.2650e+02, -2.9050e+04, +1.6300e+06; 
% b,      0.18200, 1.09889, +0.0000e+00, -1.8700e-01, -1.9300e+00, -2.9000e-01, -2.5000e+02, -4.0300e+03, +4.0800e+05; 
% b,      0.01000, 0.05067, +0.0000e+00, -2.5650e-01, -1.8550e+00, +1.4100e+01, +1.5670e+03, -5.8450e+03, -9.0400e+06; 
% b,      0.01000, 0.03667, +0.0000e+00, -1.7900e-01, -1.3850e+00, +1.7800e+01, +1.1415e+03, +2.4300e+04, -9.9150e+06;
% b_edge, 0,0,0,0,0,0,0,0,0
% b,      0.01300, 0.03265, +0.0000e+00, -6.0650e-02, -1.9750e+00, +1.9650e+01, +4.5650e+02, +2.8550e+04, -6.3900e+06; 
% b,      0.01700, 0.02917, +0.0000e+00, +1.2650e-03, -2.4250e+00, +9.7850e+00, +1.6800e+02, +2.8300e+04, -2.9090e+06; 
% b,      0.02000, 0.02257, +0.0000e+00, +2.2350e-02, -2.2800e+00, -3.3350e-01, +6.9800e+02, +2.3400e+04, -3.6350e+06; 
% b,      0.03000, 0.01811, +0.0000e+00, +2.0300e-02, -1.4700e+00, -6.1750e+00, -6.5000e+01, +3.2300e+04, +5.0000e+05; 
% b,      0.05000, 0.00375, -4.5000e-05, +6.6600e-03, -4.9550e-01, +1.7900e+00, -1.6400e+02, -1.5005e+04, +9.4750e+05;
% b_pb,   0,0,0,0,0,0,0,0,0
% ];

% interpolates multipoles linearly in energy
segmodel = segmodel_3GeV;
segmodel(:,4:end) = segmodel_150MeV(:,4:end) + (energy - 149.3018e6)/(3e9-149.3018e6) * (segmodel_3GeV(:,4:end) - segmodel_150MeV(:,4:end));

% converts deflection angle from degress to radians
segmodel(:,3) = segmodel(:,3) * (pi/180.0);

% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
segmodel(:,4) = 0;

% builds half of the magnet model
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end);
        b(i) = rbend_sirius(type.fam_name, segmodel(i,2), segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end
end

% builds entire magnet model, inserting additional markers
model_length = 2*sum(segmodel(:,2));
mb = marker('mB', 'IdentityPass');
model = [fliplr(b), mb, b];
