function r = ltx

global THERING;
global FAMLIST;

energy = 496.40e6;

GRAUS2RAD = pi/180;
quad_pass_method = 'QuadLinearPass';
bend_pass_method = 'BendLinearPass';

LA = drift('LA', 3.34697, 'DriftPass');
LB = drift('LB', 2.88124, 'DriftPass');
LC = drift('LC', 2.68009, 'DriftPass');
LD = drift('LD', 1.31426, 'DriftPass');
LS = drift('LS', 0.3, 'DriftPass');
LSG = drift('LSG', 0.024, 'DriftPass');
LA2 = drift('LA2', 0.395, 'DriftPass');
LA3 = drift('LA3', 0.372, 'DriftPass');
LA1 = drift('LA1', FAMLIST{LA}.ElemData.Length-FAMLIST{LA2}.ElemData.Length-FAMLIST{LA3}.ElemData.Length-0.4, 'DriftPass');
LB1 = drift('LB1', 1.5126, 'DriftPass');
LB2 = drift('LB2', FAMLIST{LB}.ElemData.Length-FAMLIST{LB1}.ElemData.Length-0.2, 'DriftPass');
LC1 = drift('LC1', 0.376, 'DriftPass');
LC2 = drift('LC2', 0.354, 'DriftPass');
LC3 = drift('LC3', FAMLIST{LC}.ElemData.Length-FAMLIST{LC1}.ElemData.Length-FAMLIST{LC2}.ElemData.Length-0.4, 'DriftPass');
LA11 = drift('LA11', 1.35199, 'DriftPass');
LA12 = drift('LA12', 0.65016, 'DriftPass');
LA13 = drift('LA13', FAMLIST{LA1}.ElemData.Length-FAMLIST{LA11}.ElemData.Length-FAMLIST{LA12}.ElemData.Length, 'DriftPass');
LB11 = drift('LB11', 0.29589, 'DriftPass');
LB12 = drift('LB12', 0.65411, 'DriftPass');
LB13 = drift('LB13', FAMLIST{LB1}.ElemData.Length-FAMLIST{LB11}.ElemData.Length-FAMLIST{LB12}.ElemData.Length, 'DriftPass');
LB21 = drift('LB21', 0.67106, 'DriftPass');
LB22 = drift('LB22', FAMLIST{LB2}.ElemData.Length-FAMLIST{LB21}.ElemData.Length, 'DriftPass');
LC31 = drift('LC31', 0.93204, 'DriftPass');
LC32 = drift('LC32', 0.37509, 'DriftPass');
LC33 = drift('LC33', FAMLIST{LC3}.ElemData.Length-FAMLIST{LC31}.ElemData.Length-FAMLIST{LC32}.ElemData.Length, 'DriftPass');
LD1 = drift('LD1', 0.55467, 'DriftPass');
LD2 = drift('LD2', FAMLIST{LD}.ElemData.Length-FAMLIST{LD1}.ElemData.Length, 'DriftPass');

LA12A = drift('LA12A', 0.4211, 'DriftPass');
LA12B = drift('LA12B', FAMLIST{LA12}.ElemData.Length - FAMLIST{LA12A}.ElemData.Length, 'DriftPass');

LB21A = drift('LB21A', 0.5319, 'DriftPass');
LB21B = drift('LB21B', FAMLIST{LB21}.ElemData.Length - FAMLIST{LB21A}.ElemData.Length, 'DriftPass');

LC31A = drift('LC31A', 0.7979, 'DriftPass');
LC31B = drift('LC31B', FAMLIST{LC31}.ElemData.Length - FAMLIST{LC31A}.ElemData.Length, 'DriftPass');

LD1A = drift('LD1A', 0.4211, 'DriftPass');
LD1B = drift('LD1B', FAMLIST{LD1}.ElemData.Length - FAMLIST{LD1A}.ElemData.Length, 'DriftPass');


%XSI01  = rbend('XSI01',  0.40033, -4*GRAUS2RAD, 0, -4*GRAUS2RAD, 0, bend_pass_method);

XSI01  = rbend('XSI01', 0.40033, -0.06981317008, 0.0, -0.06981317008, 0.0, bend_pass_method);
XSG02  = rbend('XSG02', 0.60027, -0.10471975512, -0.05235987756, -0.05235987756, 0.0, bend_pass_method);
XSI06  = rbend('XSI06', 0.40018, 0.05235987756, 0.05235987756, 0.0, 0.0, bend_pass_method);
XSG05A = rbend('XSG05A', 0.40041, 0.07853981634, 0.07853981634, 0.0, 0.0, bend_pass_method);
XSG05B = rbend('XSG05B', 0.40041, 0.07853981634, 0.0, 0.07853981634, 0.0, bend_pass_method);
X2DH   = rbend('X2DH', 0.45029, 0.375245789179, 0.187622894589, 0.187622894589, 0.0, bend_pass_method);

XSI01  = rbend('XSI01',  0.40033, -4*GRAUS2RAD, 0, -4*GRAUS2RAD, 0, bend_pass_method);
XSG02  = rbend('XSG02',  0.60027, -6*GRAUS2RAD, -3*GRAUS2RAD, -3*GRAUS2RAD, 0, bend_pass_method);
XSI06  = rbend('XSI06',  0.40018,  3*GRAUS2RAD, 3*GRAUS2RAD, 0, 0, bend_pass_method);
XSG05A = rbend('XSG05A', 0.40041,  4.5*GRAUS2RAD, 2.25*GRAUS2RAD, 0, 0, bend_pass_method);
XSG05B = rbend('XSG05B', 0.40041,  4.5*GRAUS2RAD, 0,  2.25*GRAUS2RAD, 0, bend_pass_method);
X2DH   = rbend('X2DH',   0.45029,  21.5*GRAUS2RAD, 10.75*GRAUS2RAD,  10.75*GRAUS2RAD, 0, bend_pass_method);


%{
XDH03 = rbend('XDH03',   0.45029,  (21.5)*GRAUS2RAD, (21.5/2)*GRAUS2RAD,  (21.5/2)*GRAUS2RAD, 0, bend_pass_method);
XDH04 = rbend('XDH03',   0.45029,  (21.5)*GRAUS2RAD, (21.5/2)*GRAUS2RAD,  (21.5/2)*GRAUS2RAD, 0, bend_pass_method);
XQF03: QUADRUPOLE, L=0.2, K1=5.365247634728, TILT=0.0;
XQD03: QUADRUPOLE, L=0.2, K1=-3.512925184293, TILT=0.0;
XQF04: QUADRUPOLE, L=0.2, K1=5.761194179359, TILT=0.0;
XQD05: QUADRUPOLE, L=0.2, K1=-4.045866043246, TILT=0.0;
XQF05: QUADRUPOLE, L=0.2, K1=5.487562391533, TILT=0.0;
%}

XCH03  = corrector('XCH03', 0, [0 0], 'CorrectorPass');
XCH04  = corrector('XCH04', 0, [0 0], 'CorrectorPass');

XQD03 = quadrupole('XQD03', 0.2, -3.512925184293, quad_pass_method);
XQF04 = quadrupole('XQF04', 0.2,  5.761194179359, quad_pass_method);
XQF05 = quadrupole('XQF05', 0.2,  5.487562391533, quad_pass_method);
XQF03E = quadrupole('XQF03', 0.1,  5.365247634728, quad_pass_method);
XQF03S = quadrupole('XQF03', 0.1,  5.365247634728, quad_pass_method);
XQF03  = [XQF03E XCH03 XQF03S];
XQD05E = quadrupole('XQD05', 0.1, -4.045866043246, quad_pass_method);
XQD05S = quadrupole('XQD05', 0.1, -4.045866043246, quad_pass_method);
XQD05  = [XQD05E XCH04 XQD05S];


XMF03  = marker('XMF03', 'IdentityPass');
XMF04A = marker('XMF04A', 'IdentityPass');
XMF04B = marker('XMF04B', 'IdentityPass');
XMF05  = marker('XMF05', 'IdentityPass');
XMF06  = marker('XMF06', 'IdentityPass');

XMP03 = marker('XMP03', 'IdentityPass');
XMP04 = marker('XMP04', 'IdentityPass');
XMP05 = marker('XMP05', 'IdentityPass');
XMP06 = marker('XMP06', 'IdentityPass');


END = marker('END', 'IdentityPass');

XCV03  = corrector('XCV03', 0, [0 0], 'CorrectorPass');
XCV04  = corrector('XCV04', 0, [0 0], 'CorrectorPass');
XCV05  = corrector('XCV05', 0, [0 0], 'CorrectorPass');

LTBA = [ ...
    XSI01 LS XSG02 LA11 XCV03 LA12A XMP03 LA12B XMF03 LA13 XQF03 LA2 XQD03 LA3 ...
    X2DH ...
    LB11 XMF04A LB12 XCV04 LB13 XQF04 LB21A XMP04 LB21B XMF04B LB22 ...
    X2DH ...
    LC1 XQD05 LC2 XQF05 LC31A XMP05 LC31B XMF05 LC32 XCV05 LC33 ...
    XSG05A LSG XSG05B LD1A XMP06 LD1B XMF06 LD2 XSI06 END];

%%% TAIL SECTION %%%

elist = LTBA;
THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);


r = THERING;