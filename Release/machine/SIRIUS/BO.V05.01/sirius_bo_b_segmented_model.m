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


% dipole model 2018-08-16 (3GeV)
% ==============================
% dipole model09
% filename: 2016-11-11_BD_Model09_Sim_X=-80_35mm_Z=-1000_1000mm_I=981.778A.txt
% analysis with x0(@z=0)=9.1013mm so that x_ref = 28.255 mm, the same value
% used in alignning the magnets.
segmodel_3GeV = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
 b,      0.1960 ,  +1.15776 ,  +0.00e+00 ,  -2.28e-01 ,  -1.99e+00 ,  -6.51e+00 ,  -3.22e+02 ,  -2.09e+04 ,  -7.45e+05 ; 
 b,      0.1920 ,  +1.14327 ,  +0.00e+00 ,  -2.12e-01 ,  -1.93e+00 ,  -3.59e+00 ,  -1.28e+02 ,  -7.26e+03 ,  -4.66e+05 ; 
 b,      0.1820 ,  +1.09640 ,  +0.00e+00 ,  -1.86e-01 ,  -1.92e+00 ,  +9.09e-01 ,  -1.98e+02 ,  +3.93e+03 ,  -1.32e+05 ; 
 b,      0.0100 ,  +0.05091 ,  +0.00e+00 ,  -2.49e-01 ,  -2.03e+00 ,  +2.75e+01 ,  -9.51e+02 ,  +2.29e+04 ,  -7.11e+05 ; 
 b,      0.0100 ,  +0.03671 ,  +0.00e+00 ,  -1.70e-01 ,  -1.47e+00 ,  +3.28e+01 ,  -1.21e+03 ,  +2.39e+04 ,  -6.81e+05 ; 
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.0130 ,  +0.03275 ,  +0.00e+00 ,  -6.21e-02 ,  -1.82e+00 ,  +3.12e+01 ,  -1.04e+03 ,  +1.16e+04 ,  -2.16e+05 ; 
 b,      0.0170 ,  +0.02909 ,  +0.00e+00 ,  -1.07e-02 ,  -1.97e+00 ,  +2.20e+01 ,  -5.66e+02 ,  +1.18e+03 ,  +2.06e+04 ; 
 b,      0.0200 ,  +0.02234 ,  +0.00e+00 ,  +5.00e-03 ,  -1.60e+00 ,  +1.07e+01 ,  -1.93e+02 ,  -1.25e+03 ,  +3.91e+04 ; 
 b,      0.0300 ,  +0.01836 ,  +0.00e+00 ,  +4.67e-03 ,  -9.30e-01 ,  +3.95e+00 ,  -4.31e+01 ,  -5.36e+02 ,  +1.10e+04 ; 
 b,      0.0500 ,  +0.01241 ,  -1.33e-04 ,  +2.35e-03 ,  -3.61e-01 ,  +8.09e-01 ,  -4.01e-01 ,  -1.16e+02 ,  +2.07e+03 ; 
 b_pb,   0,0,0,0,0,0,0,0,0
];


% dipole model 2018-08-16 (150MeV)
% ================================
% dipole model09
% filename: 2016-12-05_BD_Model09_Sim_X=-80_35mm_Z=-1000_1000mm_I=48.92A.txt
% analysis with x0(@z=0)=9.1013mm so that x_ref = 28.255 mm, the same value
% used in alignning the magnets.
segmodel_150MeV = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
 b,      0.1960 ,  +1.15695 ,  +0.00e+00 ,  -2.27e-01 ,  -1.98e+00 ,  -6.46e+00 ,  -3.18e+02 ,  -2.07e+04 ,  -7.38e+05 ; 
 b,      0.1920 ,  +1.14266 ,  +0.00e+00 ,  -2.12e-01 ,  -1.93e+00 ,  -3.58e+00 ,  -1.25e+02 ,  -7.24e+03 ,  -4.62e+05 ; 
 b,      0.1820 ,  +1.09643 ,  +0.00e+00 ,  -1.86e-01 ,  -1.90e+00 ,  +1.97e-01 ,  -1.76e+02 ,  +3.42e+03 ,  -1.05e+05 ; 
 b,      0.0100 ,  +0.05151 ,  +0.00e+00 ,  -2.61e-01 ,  -1.71e+00 ,  +1.15e+01 ,  -6.72e+02 ,  +2.00e+04 ,  +3.34e+05 ; 
 b,      0.0100 ,  +0.03716 ,  +0.00e+00 ,  -1.84e-01 ,  -1.12e+00 ,  +2.05e+01 ,  -9.15e+02 ,  +1.94e+04 ,  -3.13e+05 ; 
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.0130 ,  +0.03296 ,  +0.00e+00 ,  -6.81e-02 ,  -1.64e+00 ,  +2.68e+01 ,  -9.37e+02 ,  +1.14e+04 ,  -2.40e+05 ; 
 b,      0.0170 ,  +0.02916 ,  +0.00e+00 ,  -1.26e-02 ,  -1.91e+00 ,  +2.13e+01 ,  -5.64e+02 ,  +1.60e+03 ,  +1.02e+04 ; 
 b,      0.0200 ,  +0.02235 ,  +0.00e+00 ,  +4.51e-03 ,  -1.59e+00 ,  +1.07e+01 ,  -1.95e+02 ,  -1.19e+03 ,  +3.80e+04 ; 
 b,      0.0300 ,  +0.01836 ,  +0.00e+00 ,  +4.57e-03 ,  -9.29e-01 ,  +3.96e+00 ,  -4.34e+01 ,  -5.33e+02 ,  +1.08e+04 ; 
 b,      0.0500 ,  +0.01246 ,  -1.17e-04 ,  +2.34e-03 ,  -3.61e-01 ,  +8.08e-01 ,  -3.79e-01 ,  -1.15e+02 ,  +1.97e+03 ; 
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
