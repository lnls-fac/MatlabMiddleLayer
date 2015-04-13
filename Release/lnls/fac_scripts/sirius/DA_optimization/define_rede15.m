function THERING = define_rede15

Energy = 3.000000;
 
lai      = drift('DS', 3.500000, 'DriftPass');
la1      = drift('DS', 0.175000, 'DriftPass');
la2      = drift('DS', 0.200000, 'DriftPass');
la3      = drift('DS', 0.175000, 'DriftPass');
lbi      = drift('DS', 2.500000, 'DriftPass');
lb1      = drift('DS', 0.175000, 'DriftPass');
lb2      = drift('DS', 0.200000, 'DriftPass');
lb3      = drift('DS', 0.175000, 'DriftPass');
lc11     = drift('DS', 0.150000, 'DriftPass');
lc12     = drift('DS', 0.340000, 'DriftPass');
lc13     = drift('DS', 0.170000, 'DriftPass');
lc21     = drift('DS', 0.170000, 'DriftPass');
lc22     = drift('DS', 0.190000, 'DriftPass');
lc31     = drift('DS', 0.150000, 'DriftPass');
lc32     = drift('DS', 0.210000, 'DriftPass');
lc41     = drift('DS', 0.170000, 'DriftPass');
ls       = drift('DS', 0.150000, 'DriftPass');
lc42     = drift('DS', 0.280000, 'DriftPass');
lq       = drift('DS', 0.170000, 'DriftPass');
lb       = drift('DS', 0.130000, 'DriftPass');

mb1      = marker('MB1', 'IdentityPass');
mb2      = marker('MB2', 'IdentityPass');
mc       = marker('MC', 'IdentityPass');
mia      = marker('MI', 'IdentityPass');
mib      = marker('MI', 'IdentityPass');

qaf      = quadrupole('QUAD', 0.500000, 2.127747, 'StrMPoleSymplectic4Pass');
qad1     = quadrupole('QUAD', 0.250000, -1.625443, 'StrMPoleSymplectic4Pass');
qad2     = quadrupole('QUAD', 0.250000, -0.684339, 'StrMPoleSymplectic4Pass');
qbf      = quadrupole('QUAD', 0.500000, 2.716884, 'StrMPoleSymplectic4Pass');
qbd1     = quadrupole('QUAD', 0.250000, -3.088846, 'StrMPoleSymplectic4Pass');
qbd2     = quadrupole('QUAD', 0.250000, -0.719756, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('QUAD', 0.300000, 2.385008, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('QUAD', 0.300000, 2.596605, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('QUAD', 0.300000, 3.143155, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('QUAD', 0.300000, 2.359727, 'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);

b1e      = rbend('BEND', 0.392974, deg2rad * 1.35000, deg2rad * 1.35000, deg2rad * 0.000000, -0.900000, 'BndMPoleSymplectic4Pass');
b1s      = rbend('BEND', 0.392974, deg2rad * 1.35000, deg2rad * 0.000000, deg2rad * 1.35000, -0.900000, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('BEND', 0.611293, deg2rad * 2.100000, deg2rad * 2.100000, deg2rad * 0.000000, -0.900000, 'BndMPoleSymplectic4Pass');
b2s      = rbend('BEND', 0.611293, deg2rad * 2.100000, deg2rad * 0.000000, deg2rad * 2.100000, -0.900000, 'BndMPoleSymplectic4Pass');
b3       = rbend('BEND', 0.407529, deg2rad * 1.40000, deg2rad * 0.7000, deg2rad * 0.7000, -0.900000, 'BndMPoleSymplectic4Pass');
bce      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.700000, deg2rad * 0.000000,  0,   'BndMPoleSymplectic4Pass');
bcs      = rbend('BC',   0.062697, deg2rad * 0.700000, deg2rad * 0.000000, deg2rad * 0.700000,  0,   'BndMPoleSymplectic4Pass');


sda      = sextupole('SEXT', 0.150000, -176.533759, 'StrMPoleSymplectic4Pass');
sfa      = sextupole('SEXT', 0.150000, 174.652505, 'StrMPoleSymplectic4Pass');
sdb      = sextupole('SEXT', 0.150000, -172.803311, 'StrMPoleSymplectic4Pass');
sfb      = sextupole('SEXT', 0.150000, 191.656667, 'StrMPoleSymplectic4Pass');
sa1      = sextupole('SEXT', 0.150000, 45.943815, 'StrMPoleSymplectic4Pass');
sa2      = sextupole('SEXT', 0.150000, -80.814044, 'StrMPoleSymplectic4Pass');
sb1      = sextupole('SEXT', 0.150000, 84.388447, 'StrMPoleSymplectic4Pass');
sb2      = sextupole('SEXT', 0.150000, -128.279672, 'StrMPoleSymplectic4Pass');
s3       = sextupole('SEXT', 0.150000, -48.941782, 'StrMPoleSymplectic4Pass');
s6       = sextupole('SEXT', 0.150000, -165.795388, 'StrMPoleSymplectic4Pass');
s4       = sextupole('SEXT', 0.150000, 241.067011, 'StrMPoleSymplectic4Pass');
s5       = sextupole('SEXT', 0.150000, -193.394902, 'StrMPoleSymplectic4Pass');
s7       = sextupole('SEXT', 0.150000, 202.883780, 'StrMPoleSymplectic4Pass');
s8       = sextupole('SEXT', 0.150000, -75.684962, 'StrMPoleSymplectic4Pass');

fim      = marker('END', 'IdentityPass');
 
idispa   = [b1e, mb1, b1s, lc11, ls, lc12, sda, lc13, qf1, lq, sfa, lq, ...
           qf2, lc21, s3, lc22, b2e, mb2, b2s, lc31, s6, lc32, qf3, lq, s7, lq, ...
           qf4, lc41, ls, lc42, b3, lb, bce, mc];
cdispa   = [mc, bcs, lb, b3, lc42, ls, lc41, qf4, lq, s7, lq, qf3, lc32, ...
           s6, lc31, b2e, mb2, b2s, lc22, s3, lc21, qf2, lq, sfa, lq, qf1, lc13, ...
           sda, lc12, ls, lc11, b1e, mb1, b1s];
idispb   = [b1e, mb1, b1s, lc11, ls, lc12, sdb, lc13, qf1, lq, sfb, lq, ...
           qf2, lc21, s8, lc22, b2e, mb2, b2s, lc31, s5, lc32, qf3, lq, s4, lq, ...
           qf4, lc41, ls, lc42, b3, lb, bce, mc];
cdispb   = [mc, bcs, lb, b3, lc42, ls, lc41, qf4, lq, s4, lq, qf3, lc32, ...
           s5, lc31, b2e, mb2, b2s, lc22, s8, lc21, qf2, lq, sfb, lq, qf1, lc13, ...
           sdb, lc12, ls, lc11, b1e, mb1, b1s];
insa     = [mia, lai, qad1, la1, sa1, la1, qaf, la2, qad2, la3, sa2, la3];
insb     = [mib, lbi, qbd1, lb1, sb1, lb1, qbf, lb2, qbd2, lb3, sb2, lb3];
hisupa   = [insa, idispa];
hcsupa   = [cdispa, fliplr(insa)];
hisupb   = [insb, idispb];
hcsupb   = [cdispb, fliplr(insb)];
sup      = [hisupa, hcsupb, hisupb, hcsupa];

nr_cells = 1;
% nr_cells = 10;
anel     = [repmat(sup,1,nr_cells) fim];


THERING = buildlat(anel);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);

%Sextupolo no BC
bc = findcells(THERING,'FamName','BC');
THERING = setcellstruct(THERING,'PolynomB',bc,-18.93,3);
