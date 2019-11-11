function [model, model_length] = sirius_ts_b_segmented_model(energy, famname, passmethod)

types = {};
b      = 1; types{end+1} = struct('fam_name', famname, 'passmethod', passmethod);
b_edge = 2; types{end+1} = struct('fam_name', 'edgeB', 'passmethod', 'IdentityPass');
b_pb   = 3; types{end+1} = struct('fam_name', 'physB', 'passmethod', 'IdentityPass');

% % dipole model 2019-10-31
% Interpolated Dipole Model for TS at 3GeV (698.85A) for BD-006 (interpolation of 680A and 720A data)
% ===============================================
monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%  %--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m^(n-1)] for polynom_b ---
%  %type   len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
b,         0.19600, 0.809257, +0.0000e+00, -1.5054e-01, -1.3448e+00, -2.8514e+00, +4.9654e+01, -9.7962e+03, -1.4425e+06;
b,         0.19200, 0.797120, +0.0000e+00, -1.4328e-01, -1.3380e+00, -2.7288e+00, +2.1067e+02, +5.1905e+03, -1.6808e+06;
b,         0.18200, 0.760060, +0.0000e+00, -1.3084e-01, -1.3232e+00, +7.4249e-01, -9.9878e+01, -2.2005e+03, +1.5113e+05;
b,         0.01000, 0.034611, +0.0000e+00, -1.5176e-01, -1.2704e+00, +6.8939e+00, +4.2288e+01, +8.9753e+03, -1.5715e+06;
b,         0.01000, 0.025086, +0.0000e+00, -9.5750e-02, -1.0544e+00, +1.0254e+01, -1.5327e+02, +9.3432e+03, -1.8207e+06;
b_edge,    0,0,0,0,0,0,0,0,0;
b,         0.01300, 0.022508, +0.0000e+00, -3.2273e-02, -1.3281e+00, +1.0407e+01, -3.2405e+02, +9.0864e+03, -9.2305e+05;
b,         0.01700, 0.020260, +0.0000e+00, -1.0375e-03, -1.5937e+00, +5.8647e+00, -2.3126e+02, +5.5698e+03, -3.9056e+04;
b,         0.02000, 0.015855, +0.0000e+00, +9.8129e-03, -1.5127e+00, +1.1375e+00, -4.5477e+01, +2.0338e+03, +2.1443e+05;
b,         0.03000, 0.013028, +0.0000e+00, +9.4251e-03, -1.0114e+00, -7.6112e-01, +7.4214e+01, +9.2988e+02, -1.1137e+05;
b,         0.05000, 0.007986, -8.5102e-07, +3.1611e-03, -3.4872e-01, -9.4469e-01, +4.3492e+01, +1.9965e+03, -1.4370e+05;
b_pb,      0,0,0,0,0,0,0,0,0
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
mb = marker('mB', 'IdentityPass');
model = [fliplr(b), mb, b];
