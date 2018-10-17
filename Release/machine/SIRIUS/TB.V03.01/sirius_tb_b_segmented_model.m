function [model, model_length] = sirius_tb_b_segmented_model(energy, famname, passmethod, sign)

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


% dipole model (150MeV)
% =====================
% filename: 2018-08-04_TB_Dipole_Model03_Sim_X=-85_85mm_Z=-500_500mm_Imc=249.1A.txt
segmodel = [ ...
 %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
 %type   len[m]    angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6) 
 b,      0.0800 ,  +3.96552 ,  +0.00e+00 ,  -6.11e-04 ,  -7.42e-02 ,  -2.19e+00 ,  -2.43e+02 ,  -3.43e+04 ,  -2.11e+06 ; 
 b,      0.0200 ,  +0.98973 ,  +0.00e+00 ,  -2.15e-02 ,  -2.68e-01 ,  -2.01e+00 ,  -1.63e+02 ,  -8.81e+03 ,  -1.15e+06 ; 
 b,      0.0200 ,  +0.93979 ,  +0.00e+00 ,  -6.44e-01 ,  -4.76e+00 ,  -1.42e+01 ,  -7.80e+02 ,  -5.33e+03 ,  -1.42e+06 ; 
 b,      0.0200 ,  +0.64484 ,  +0.00e+00 ,  -1.63e+00 ,  -6.59e+00 ,  +2.42e+01 ,  -5.22e+03 ,  +1.82e+04 ,  -2.67e+06 ; 
 b_edge, 0,0,0,0,0,0,0,0,0
 b,      0.0200 ,  +0.38227 ,  +0.00e+00 ,  -7.75e-01 ,  -1.34e+01 ,  +9.09e+01 ,  -5.95e+03 ,  +3.50e+04 ,  -7.03e+05 ; 
 b,      0.0200 ,  +0.24438 ,  +0.00e+00 ,  -3.74e-01 ,  -1.41e+01 ,  +9.51e+01 ,  -2.80e+03 ,  +6.72e+03 ,  +2.36e+05 ; 
 b,      0.0300 ,  +0.20469 ,  +0.00e+00 ,  -2.13e-01 ,  -9.21e+00 ,  +5.84e+01 ,  -8.54e+02 ,  -6.30e+02 ,  +1.14e+05 ; 
 b,      0.0300 ,  +0.12878 ,  +1.04e-04 ,  -1.38e-01 ,  -6.08e+00 ,  +3.36e+01 ,  -2.08e+02 ,  -8.68e+02 ,  +4.60e+04 ; 
 b_pb,   0,0,0,0,0,0,0,0,0

];
 
% converts deflection angle from degress to radians and sets correct positive or negative sign
segmodel(:,3) = sign * segmodel(:,3) * (pi/180.0);

% inverts odd-order polynomB, if sign=-1 (for the negative dipole)
% if sign ~= 1
%     for i=1:length(monomials)
%         segmodel(:,3+i) = segmodel(:,3+i) * sign ^ monomials(i);
%     end
% end

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
