function THERING = define_mba5

Energy = 3.000000;
 
li       = drift('DS', 3.000000, 'DriftPass');
l1       = drift('DS', 0.170000, 'DriftPass');
l2       = drift('DS', 0.170000, 'DriftPass');
l3       = drift('DS', 0.150000, 'DriftPass');
lc11     = drift('DS', 0.150000, 'DriftPass');
lc12     = drift('DS', 0.800000, 'DriftPass');
lc21     = drift('DS', 0.300000, 'DriftPass');
lc22     = drift('DS', 0.150000, 'DriftPass');
lc31     = drift('DS', 0.150000, 'DriftPass');
lc32     = drift('DS', 0.300000, 'DriftPass');
lc41     = drift('DS', 0.300000, 'DriftPass');
lc42     = drift('DS', 0.150000, 'DriftPass');
lq       = drift('DS', 0.170000, 'DriftPass');
lb       = drift('DS', 0.130000, 'DriftPass');
mb1      = marker('MB1', 'IdentityPass');
mb2      = marker('MB2', 'IdentityPass');
mc       = marker('MC', 'IdentityPass');
mi       = marker('MI', 'IdentityPass');
qif      = quadrupole('QUAD', 0.500000,  2.449476, 'StrMPoleSymplectic4Pass');
qid1     = quadrupole('QUAD', 0.250000, -2.550504, 'StrMPoleSymplectic4Pass');
qid2     = quadrupole('QUAD', 0.250000, -1.375598, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('QUAD', 0.250000,  2.699490, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('QUAD', 0.250000,  3.149319, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('QUAD', 0.250000,  3.149338, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('QUAD', 0.250000,  3.149989, 'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);

b1e      = rbend('BEND', 0.327479, deg2rad * 1.125000, deg2rad * 1.125000, deg2rad * 0.000000, -0.791344, 'BndMPoleSymplectic4Pass');
b1s      = rbend('BEND', 0.327479, deg2rad * 1.125000, deg2rad * 0.000000, deg2rad * 1.125000, -0.791344, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('BEND', 0.654957, deg2rad * 2.250000, deg2rad * 2.250000, deg2rad * 0.000000, -0.791344, 'BndMPoleSymplectic4Pass');
b2s      = rbend('BEND', 0.654957, deg2rad * 2.250000, deg2rad * 0.000000, deg2rad * 2.250000, -0.791344, 'BndMPoleSymplectic4Pass');
b3       = rbend('BEND', 0.451193, deg2rad * 1.550000, deg2rad * 0.775000, deg2rad * 0.775000, -0.791344, 'BndMPoleSymplectic4Pass');
bce      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.700000, deg2rad * 0.000000,  0,   'BndMPoleSymplectic4Pass');
bcs      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.000000, deg2rad * 0.700000,  0,   'BndMPoleSymplectic4Pass');

sd       = sextupole('SEXT', 0.150000, -132.003350, 'StrMPoleSymplectic4Pass');
sf       = sextupole('SEXT', 0.150000, 159.619278, 'StrMPoleSymplectic4Pass');
sd2      = sextupole('SEXT', 0.150000, -72.398287, 'StrMPoleSymplectic4Pass');
sd3      = sextupole('SEXT', 0.150000, -137.087701, 'StrMPoleSymplectic4Pass');
sf2      = sextupole('SEXT', 0.150000, 98.924628, 'StrMPoleSymplectic4Pass');
s1       = sextupole('SEXT', 0.150000, 88.816665, 'StrMPoleSymplectic4Pass');
s2       = sextupole('SEXT', 0.150000, -45.689136, 'StrMPoleSymplectic4Pass');
s3       = sextupole('SEXT', 0.150000, -42.966792, 'StrMPoleSymplectic4Pass');
s4       = sextupole('SEXT', 0.150000, 88.816665, 'StrMPoleSymplectic4Pass');
s5       = sextupole('SEXT', 0.150000, -45.689136, 'StrMPoleSymplectic4Pass');
s6       = sextupole('SEXT', 0.150000, -42.966792, 'StrMPoleSymplectic4Pass');
s7       = sextupole('SEXT', 0.150000, -42.966792, 'StrMPoleSymplectic4Pass');
s8       = sextupole('SEXT', 0.150000, -42.966792, 'StrMPoleSymplectic4Pass');

fim      = marker('END', 'IdentityPass');
 
disp_ins = [b1e, mb1, b1s, lc11,s3,lc12, qf1, lq, sf, lq, qf2, lc21,sd,lc22, b2e, mb2, ...
           b2s, lc31,s6,lc32, qf3, lq, s7, lq, qf4, lc41,s8,lc42, b3, lb, bce, mc];
disp_cen = [mc, bcs, lb, b3, lc42,s8,lc41, qf4, lq, s7, lq, qf3,lc32,s6, lc31, b2e, ...
           mb2, b2s, lc22,sd,lc21, qf2, lq, sf, lq, qf1, lc12,s3,lc11, b1e, mb1, b1s];
ins      = [mi, li, qid1, l1, s1, l1, qif, l2, s2, l2, qid2, l3];
hsup_ins = [ins, disp_ins];
hsup_cen = [disp_cen, fliplr(ins)];
sup      = [hsup_ins, hsup_cen];

nr_cells = 1;
anel     = [repmat(sup,1,nr_cells) fim];


THERING = buildlat(anel);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);
