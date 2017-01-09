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


% dipole model 2016-11-22 (3GeV)
% ==============================
% dipole model09
% filename: 2016-11-11_BD_Model09_Sim_X=-80_35mm_Z=-1000_1000mm_I=981.778A.txt
segmodel_3GeV = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
 b,      0.196  ,  +1.15780 ,  +0.00e+00 ,  -2.27e-01 ,  -1.99e+00 ,  -6.44e+00 ,  -3.17e+02 ,  -2.06e+04 ,  -7.40e+05 ;
 b,      0.192  ,  +1.14328 ,  +0.00e+00 ,  -2.12e-01 ,  -1.93e+00 ,  -3.56e+00 ,  -1.26e+02 ,  -7.10e+03 ,  -4.62e+05 ;
 b,      0.182  ,  +1.09639 ,  +0.00e+00 ,  -1.86e-01 ,  -1.92e+00 ,  +9.55e-01 ,  -1.99e+02 ,  +3.99e+03 ,  -1.32e+05 ;
 b,      0.010  ,  +0.05091 ,  +0.00e+00 ,  -2.49e-01 ,  -2.04e+00 ,  +2.78e+01 ,  -9.57e+02 ,  +2.32e+04 ,  -7.17e+05 ;
 b,      0.010  ,  +0.03671 ,  +0.00e+00 ,  -1.70e-01 ,  -1.48e+00 ,  +3.31e+01 ,  -1.22e+03 ,  +2.41e+04 ,  -6.87e+05 ;
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.013  ,  +0.03275 ,  +0.00e+00 ,  -6.19e-02 ,  -1.83e+00 ,  +3.15e+01 ,  -1.04e+03 ,  +1.16e+04 ,  -2.15e+05 ;
 b,      0.017  ,  +0.02908 ,  +0.00e+00 ,  -1.05e-02 ,  -1.97e+00 ,  +2.21e+01 ,  -5.66e+02 ,  +1.18e+03 ,  +2.15e+04 ;
 b,      0.020  ,  +0.02233 ,  +0.00e+00 ,  +5.19e-03 ,  -1.60e+00 ,  +1.08e+01 ,  -1.92e+02 ,  -1.26e+03 ,  +3.92e+04 ;
 b,      0.030  ,  +0.01835 ,  +0.00e+00 ,  +4.78e-03 ,  -9.31e-01 ,  +3.96e+00 ,  -4.29e+01 ,  -5.40e+02 ,  +1.10e+04 ;
 b,      0.050  ,  +0.01240 ,  +1.13e-06 ,  +2.39e-03 ,  -3.61e-01 ,  +8.09e-01 ,  -3.65e-01 ,  -1.16e+02 ,  +2.07e+03 ;
 b_pb,   0,0,0,0,0,0,0,0,0
];

% dipole model 2016-12-05 (150MeV)
% ================================
% dipole model09
% filename: 2016-12-05_BD_Model09_Sim_X=-80_35mm_Z=-1000_1000mm_I=48.92A.txt
segmodel_150MeV = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
 b,      0.196  ,  +1.15700 ,  +0.00e+00 ,  -2.27e-01 ,  -1.98e+00 ,  -6.39e+00 ,  -3.13e+02 ,  -2.05e+04 ,  -7.33e+05 ;
 b,      0.192  ,  +1.14267 ,  +0.00e+00 ,  -2.12e-01 ,  -1.93e+00 ,  -3.55e+00 ,  -1.24e+02 ,  -7.08e+03 ,  -4.58e+05 ;
 b,      0.182  ,  +1.09642 ,  +0.00e+00 ,  -1.86e-01 ,  -1.90e+00 ,  +2.37e-01 ,  -1.77e+02 ,  +3.47e+03 ,  -1.05e+05 ;
 b,      0.010  ,  +0.05151 ,  +0.00e+00 ,  -2.61e-01 ,  -1.72e+00 ,  +1.17e+01 ,  -6.81e+02 ,  +2.00e+04 ,  +3.53e+05 ;
 b,      0.010  ,  +0.03715 ,  +0.00e+00 ,  -1.84e-01 ,  -1.12e+00 ,  +2.07e+01 ,  -9.21e+02 ,  +1.95e+04 ,  -3.16e+05 ;
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.013  ,  +0.03295 ,  +0.00e+00 ,  -6.79e-02 ,  -1.65e+00 ,  +2.70e+01 ,  -9.40e+02 ,  +1.15e+04 ,  -2.39e+05 ;
 b,      0.017  ,  +0.02915 ,  +0.00e+00 ,  -1.24e-02 ,  -1.92e+00 ,  +2.15e+01 ,  -5.65e+02 ,  +1.60e+03 ,  +1.10e+04 ;
 b,      0.020  ,  +0.02235 ,  +0.00e+00 ,  +4.70e-03 ,  -1.59e+00 ,  +1.08e+01 ,  -1.95e+02 ,  -1.21e+03 ,  +3.81e+04 ;
 b,      0.030  ,  +0.01835 ,  +0.00e+00 ,  +4.67e-03 ,  -9.29e-01 ,  +3.97e+00 ,  -4.33e+01 ,  -5.37e+02 ,  +1.08e+04 ;
 b,      0.050  ,  +0.01245 ,  +1.74e-05 ,  +2.38e-03 ,  -3.61e-01 ,  +8.08e-01 ,  -3.43e-01 ,  -1.16e+02 ,  +1.97e+03 ;
 b_pb,   0,0,0,0,0,0,0,0,0
];


% interpolates multipoles linearly in energy
segmodel = segmodel_3GeV;
segmodel(:,4:end) = segmodel_150MeV(:,4:end) + (energy - 150e6)/(3e9-150e6) * (segmodel_3GeV(:,4:end) - segmodel_150MeV(:,4:end));

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
