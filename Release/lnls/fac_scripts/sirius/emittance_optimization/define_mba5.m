function THERING = define_mba5

Energy = 3.000000;
 
li       = drift('DS', 3.000000, 'DriftPass');
l1       = drift('DS', 0.101927, 'DriftPass');
l2       = drift('DS', 0.050012, 'DriftPass');
l3       = drift('DS', 0.050378, 'DriftPass');
lc1      = drift('DS', 0.850000, 'DriftPass');
lc2      = drift('DS', 0.361334, 'DriftPass');
lc3      = drift('DS', 0.399215, 'DriftPass');
lq       = drift('DS', 0.075000, 'DriftPass');
lb       = drift('DS', 0.130000, 'DriftPass');
l10      = drift('DS', 0.100000, 'DriftPass');
mb1      = marker('MB1', 'IdentityPass');
mb2      = marker('MB2', 'IdentityPass');
mq       = marker('MQ', 'IdentityPass');
mc       = marker('MC', 'IdentityPass');
mi       = marker('MI', 'IdentityPass');
qif      = quadrupole('QUAD', 0.500000,  2.998160, 'StrMPoleSymplectic4Pass');
qid1     = quadrupole('QUAD', 0.250000, -2.570624, 'StrMPoleSymplectic4Pass');
qid2     = quadrupole('QUAD', 0.250000, -2.192447, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('QUAD', 0.250000,  2.640793, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('QUAD', 0.250000,  2.999939, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('QUAD', 0.250000,  3.277056, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('QUAD', 0.250000,  3.052342, 'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);

b1e      = rbend('BEND', 0.327479, deg2rad * 1.125000, deg2rad * 1.125000, deg2rad * 0.000000, -0.8, 'BndMPoleSymplectic4Pass');
b1s      = rbend('BEND', 0.327479, deg2rad * 1.125000, deg2rad * 0.000000, deg2rad * 1.125000, -0.8, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('BEND', 0.654957, deg2rad * 2.250000, deg2rad * 2.250000, deg2rad * 0.000000, -0.8, 'BndMPoleSymplectic4Pass');
b2s      = rbend('BEND', 0.654957, deg2rad * 2.250000, deg2rad * 0.000000, deg2rad * 2.250000, -0.8, 'BndMPoleSymplectic4Pass');
b3       = rbend('BEND', 0.451193, deg2rad * 1.550000, deg2rad * 0.775000, deg2rad * 0.775000, -0.8, 'BndMPoleSymplectic4Pass');
bce      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.700000, deg2rad * 0.000000,  0,   'BndMPoleSymplectic4Pass');
bcs      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.000000, deg2rad * 0.700000,  0,   'BndMPoleSymplectic4Pass');

sd       = sextupole('SD', 0.150000, -114.403530, 'StrMPoleSymplectic4Pass');
sf       = sextupole('SF', 0.150000,  164.611654, 'StrMPoleSymplectic4Pass');
s1       = sextupole('S1', 0.100000,  235.028241, 'StrMPoleSymplectic4Pass');
s2       = sextupole('S2', 0.100000, -167.670732, 'StrMPoleSymplectic4Pass');
s3       = sextupole('S3', 0.100000,   -4.567385, 'StrMPoleSymplectic4Pass');
s4       = sextupole('S4', 0.150000,    0.000000, 'StrMPoleSymplectic4Pass');
s5       = sextupole('S5', 0.150000,    0.000000, 'StrMPoleSymplectic4Pass');
s6       = sextupole('S6', 0.150000,   87.759235, 'StrMPoleSymplectic4Pass');
           
           
fim      = marker('END', 'IdentityPass');
 
disp_ins = [ b1e, mb1, b1s, l10, l10, sd, lc1, qf1, lq, sf, lq, qf2, ...
             lc2, sd, l10, b2e, mb2, b2s, l10, sd, lc2, qf3, lq, s6, lq, qf4, ...
             lc3, sd, l10, b3, lb, bce, mc];
disp_cen = [ mc, bcs, lb, b3, l10, sd, lc3, qf4, lq, s6, lq, qf3, lc2, ...
             sd, l10, b2e, mb2, b2s, l10, sd, lc2, qf2, lq, sf, lq, qf1, lc1, ...
             sd, l10, l10, b1e, mb1, b1s];
ins      = [ mi, li, qid1, l1, s1, l1, qif, l2, s2, l2, qid2, l3, s3, ...
             l3 ];
   
hsup_ins = [ins, disp_ins];
hsup_cen = [disp_cen, fliplr(ins)];
sup      = [hsup_ins, hsup_cen];

nr_cells = 1;
anel     = [repmat(sup,1,nr_cells) fim];
 

THERING = buildlat(anel);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);
