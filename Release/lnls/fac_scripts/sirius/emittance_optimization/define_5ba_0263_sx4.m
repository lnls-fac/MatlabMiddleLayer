function THERING = define_5ba_0263_sx4

Energy = 3.000000;

%     betax   = 12.7069343; alphax  = 0.0000000;
%     etax    = -0.0007726; etaxp   = 0.0000000;
%     betay   = 1.1116917; alphay  = 0.0000000;
%     etay    = 0.0000000; etayp   = 0.0000000;
%     orbitx  = 0.0000000000; orbitxp = 0.0000000000;
%     orbity  = 0.0000000000; orbityp = 0.0000000000;
%     orbitdpp= 0.0000000000;
 
li       = drift('li',   3.000000000000, 'DriftPass');
l1       = drift('l1',   0.171265, 'DriftPass');
l2       = drift('l2',   0.203952, 'DriftPass');
l31      = drift('l31',  0.170000, 'DriftPass');
l32      = drift('l32',  0.154741, 'DriftPass');
lc11     = drift('lc11', 0.400000, 'DriftPass');
lc12     = drift('lc12', 0.106200, 'DriftPass');
lc13     = drift('lc13', 0.170000, 'DriftPass');
lc21     = drift('lc21', 0.171709, 'DriftPass');
lc22     = drift('lc22', 0.200000, 'DriftPass');
lc31     = drift('lc31', 0.150000, 'DriftPass');
lc32     = drift('lc32', 0.170669, 'DriftPass');
lc41     = drift('lc41', 0.170000, 'DriftPass');
ls       = drift('ls',   0.150000, 'DriftPass');
lc42     = drift('lc42', 0.229917, 'DriftPass');
lq       = drift('DS',   0.170000, 'DriftPass');
lb       = drift('DS',   0.130000, 'DriftPass');

qif      = quadrupole('qif',  0.50000,  1.965590, 'StrMPoleSymplectic4Pass');
qid1     = quadrupole('qid1', 0.25000, -1.192041, 'StrMPoleSymplectic4Pass');
qid2     = quadrupole('qid2', 0.25000, -0.592217, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('qf1',  0.30000,  2.483034, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('qf2',  0.30000,  2.475179, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('qf3',  0.30000,  3.149987, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('qf4',  0.30000,  2.585392, 'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);
qb_str = -0.935110;

b1e      = rbend('b1', 0.3929740, 1.35 * deg2rad, 1.35 * deg2rad, 0.00 * deg2rad, qb_str, 'BndMPoleSymplectic4Pass');
b1s      = rbend('b1', 0.3929740, 1.35 * deg2rad, 0.00 * deg2rad, 1.35 * deg2rad, qb_str, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('b2', 0.6112930, 2.10 * deg2rad, 2.10 * deg2rad, 0.00 * deg2rad, qb_str, 'BndMPoleSymplectic4Pass');
b2s      = rbend('b2', 0.6112930, 2.10 * deg2rad, 0.00 * deg2rad, 2.10 * deg2rad, qb_str, 'BndMPoleSymplectic4Pass');
b3       = rbend('b3', 0.4075290, 1.40 * deg2rad, 0.70 * deg2rad, 0.70 * deg2rad, qb_str, 'BndMPoleSymplectic4Pass');
bce      = rbend('bc', 0.0626965, 0.70 * deg2rad, 0.70 * deg2rad, 0.00 * deg2rad, 0,      'BndMPoleSymplectic4Pass');
bcs      = rbend('bc', 0.0626965, 0.70 * deg2rad, 0.00 * deg2rad, 0.70 * deg2rad, 0,      'BndMPoleSymplectic4Pass');

           
sd       = sextupole('sd', 0.150000, -53.792340, 'StrMPoleSymplectic4Pass');
sf       = sextupole('sf', 0.150000, 133.623901, 'StrMPoleSymplectic4Pass');           
s11      = sextupole('s11', 0.150000,  38.369922, 'StrMPoleSymplectic4Pass');
s21      = sextupole('s21', 0.150000, -63.917160, 'StrMPoleSymplectic4Pass');
%s12      = sextupole('s12', 0.150000,  49.817814, 'StrMPoleSymplectic4Pass');
%s22      = sextupole('s22', 0.150000, -89.675042, 'StrMPoleSymplectic4Pass');
s3       = sextupole('s3', 0.150000, -120.603316, 'StrMPoleSymplectic4Pass');
s6       = sextupole('s6', 0.150000, -150.052741, 'StrMPoleSymplectic4Pass');
s7       = sextupole('s7', 0.150000,  343.518839, 'StrMPoleSymplectic4Pass');
s8       = sextupole('s8', 0.150000, -378.879759, 'StrMPoleSymplectic4Pass');


mb1      = marker('mb1', 'IdentityPass');
mb2      = marker('mb2', 'IdentityPass');
mc       = marker('mc', 'IdentityPass');
mq1      = marker('mq1', 'IdentityPass');
mq2      = marker('mq2', 'IdentityPass');
mi       = marker('mi', 'IdentityPass');
mt       = marker('mt', 'IdentityPass');


disp_ins = [b1e, mb1, b1s, lc11, sd, lc12, ls, lc13, qf1, lq, sf, lq, ...
           qf2, lc21, s3, lc22, b2e, mb2, b2s, lc31, s6, lc32, qf3, lq, s7, ...
           lq, qf4, lc41, s8, lc42, b3, lb, bce, mc];
disp_cen = [mc, bcs, lb, b3, lc42, s8, lc41, qf4, lq, s7, lq, qf3, ...
           lc32, s6, lc31, b2e, mb2, b2s, lc22, s3, lc21, qf2, lq, sf, lq, ...
           qf1, lc13, ls, lc12, sd, lc11, b1e, mb1, b1s];
ins      = [mi, li, qid1, l1, s11, l1, qif, l2, qid2, l31, s21, l32];
hsup_ins = [ins, disp_ins];
hsup_cen = [disp_cen, mt, fliplr(ins)];
sup      = [hsup_ins, hsup_cen];

nr_cells = 1;
anel     = repmat(sup,1,nr_cells);
 

THERING = buildlat(anel);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);
