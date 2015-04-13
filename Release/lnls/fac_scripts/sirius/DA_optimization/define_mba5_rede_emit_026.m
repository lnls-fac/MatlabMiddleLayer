function THERING = define_mba5_rede_emit_026

Energy = 3.000000;
 
li       = drift('DS', 3.000000, 'DriftPass');
l1       = drift('DS', 0.199998, 'DriftPass');
l2       = drift('DS', 0.255467, 'DriftPass');
l31      = drift('DS', 0.176030, 'DriftPass');
l32      = drift('DS', 0.176030, 'DriftPass');
lc11     = drift('DS', 0.400000, 'DriftPass');
lc12     = drift('DS', 0.241659, 'DriftPass');
lc21     = drift('DS', 0.194874, 'DriftPass');
lc22     = drift('DS', 0.200000, 'DriftPass');
lc31     = drift('DS', 0.177338, 'DriftPass');
lc32     = drift('DS', 0.177338, 'DriftPass');
lc41     = drift('DS', 0.170000, 'DriftPass');
lc42     = drift('DS', 0.241799, 'DriftPass');
ls       = drift('DS', 0.150000, 'DriftPass');
lq       = drift('DS', 0.170000, 'DriftPass');
lb       = drift('DS', 0.130000, 'DriftPass');
mb1      = marker('MB1', 'IdentityPass');
mb2      = marker('MB2', 'IdentityPass');
mc       = marker('MC', 'IdentityPass');
mi       = marker('MI', 'IdentityPass');
qif      = quadrupole('QUAD', 0.500000,  1.709079, 'StrMPoleSymplectic4Pass');
qid1     = quadrupole('QUAD', 0.250000, -1.182100, 'StrMPoleSymplectic4Pass');
qid2     = quadrupole('QUAD', 0.250000, 0.241799, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('QUAD', 0.30000,  2.719254, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('QUAD', 0.30000,  2.479897, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('QUAD', 0.30000,  2.967060, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('QUAD', 0.30000,  2.804060, 'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);

b1e      = rbend('BEND', 0.436638, deg2rad * 1.5000, deg2rad * 1.5000, deg2rad * 0.000000, -0.959977, 'BndMPoleSymplectic4Pass');
b1s      = rbend('BEND', 0.436638, deg2rad * 1.5000, deg2rad * 0.000000, deg2rad * 1.5000, -0.959977, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('BEND', 0.582184, deg2rad * 2.00000, deg2rad * 2.00000, deg2rad * 0.000000, -0.959977, 'BndMPoleSymplectic4Pass');
b2s      = rbend('BEND', 0.582184, deg2rad * 2.00000, deg2rad * 0.000000, deg2rad * 2.00000, -0.959977, 'BndMPoleSymplectic4Pass');
b3       = rbend('BEND', 0.378420, deg2rad * 1.30000, deg2rad * 0.65000, deg2rad * 0.65000, -0.959977, 'BndMPoleSymplectic4Pass');
bce      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.700000, deg2rad * 0.000000,  0,   'BndMPoleSymplectic4Pass');
bcs      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.000000, deg2rad * 0.700000,  0,   'BndMPoleSymplectic4Pass');


sd       = sextupole('SEXT', 0.150000, -134.608241, 'StrMPoleSymplectic4Pass');
sf       = sextupole('SEXT', 0.150000, 135.395821, 'StrMPoleSymplectic4Pass');
s1       = sextupole('SEXT', 0.150000, 34.118231, 'StrMPoleSymplectic4Pass');
s2       = sextupole('SEXT', 0.150000, -66.815120, 'StrMPoleSymplectic4Pass');
s3       = sextupole('SEXT', 0.150000, -57.098224, 'StrMPoleSymplectic4Pass');
s6       = sextupole('SEXT', 0.150000, -156.519551, 'StrMPoleSymplectic4Pass');
s7       = sextupole('SEXT', 0.150000, 302.844401, 'StrMPoleSymplectic4Pass');
s8       = sextupole('SEXT', 0.150000, -195.455684, 'StrMPoleSymplectic4Pass');


fim      = marker('END', 'IdentityPass');
 
disp_ins = [b1e, mb1, b1s, lc11, sd, lc12, qf1, lq, sf, lq, qf2, ...
           lc21, s3, lc22, b2e, mb2, b2s, lc31, s6, lc32, qf3, lq, s7, lq, qf4,...
           lc41, s8, lc42, b3, lb, bce, mc];
disp_cen = [mc, bcs, lb, b3, lc42, s8, lc41, qf4, lq, s7, lq, qf3, ...
           lc32, s6, lc31, b2e, mb2, b2s, lc22, s3, lc21, qf2, lq, sf, lq,...
           qf1, lc12, sd, lc11, b1e, mb1, b1s];
ins      = [mi, li, qid1, l1, s1, l1, qif, l2, qid2, l31, s2, l32];
hsup_ins = [ins, disp_ins];
hsup_cen = [disp_cen, fliplr(ins)];
sup      = [hsup_ins, hsup_cen];

nr_cells = 1;
anel     = [repmat(sup,1,nr_cells) fim];


THERING = buildlat(anel);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);
