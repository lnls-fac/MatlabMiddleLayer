function [model, model_length] = sirius_bo_b_segmented_model(famname, passmethod, strength)

types = {};
b      = 1; types{end+1} = struct('fam_name', famname, 'passmethod', passmethod);
b_edge = 2; types{end+1} = struct('fam_name', 'b_edge', 'passmethod', 'IdentityPass');
b_pb   = 3; types{end+1} = struct('fam_name', 'pb', 'passmethod', 'IdentityPass');

% dipole model 2016-11-22
% =======================
% dipole model09
% fieldmap: 2016-11-11_BD_Model09_Sim_X=-80_35mm_Z=-1000_1000mm_I=981.778A.txt2016-11-11_BD_Model09_Sim_X=-80_35mm_Z=-1000_1000mm_I=981.778A.txt
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% *** interpolation of fields is now cubic ***
% *** dipole angles were normalized to better close 360 degrees ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
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
 b,      0.050  ,  +0.01240 ,  +1.13e-06 , +2.39e-03 ,  -3.61e-01 ,  +8.09e-01 ,  -3.65e-01 ,  -1.16e+02 ,  +2.07e+03 ;
 b_pb,   0,0,0,0,0,0,0,0,0
];

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
mb = marker('mb', 'IdentityPass');
model = [fliplr(b), mb, b];
