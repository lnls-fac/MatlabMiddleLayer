function THERING = define_5ba_e0p26

Energy = 3.000000;

%     betax   = 12.7069343; alphax  = 0.0000000;
%     etax    = -0.0007726; etaxp   = 0.0000000;
%     betay   = 1.1116917; alphay  = 0.0000000;
%     etay    = 0.0000000; etayp   = 0.0000000;
%     orbitx  = 0.0000000000; orbitxp = 0.0000000000;
%     orbity  = 0.0000000000; orbityp = 0.0000000000;
%     orbitdpp= 0.0000000000;
 
li       = drift('li',  3.000000000000, 'DriftPass');
l1       = drift('l1',  0.511077627925, 'DriftPass');
l2       = drift('l2',  0.524088001277, 'DriftPass');
l3       = drift('l3',  0.182220642067, 'DriftPass');
lc1      = drift('lc1', 1.001050646059, 'DriftPass');
lc2      = drift('lc2', 0.524706998978, 'DriftPass');
lc3      = drift('lc3', 0.475855151078, 'DriftPass');
lc4      = drift('lc4', 0.535028411822, 'DriftPass');
lq       = drift('DS',  0.245000000000, 'DriftPass');
lb       = drift('DS',  0.130000000000, 'DriftPass');

qb_str = -0.934985000588;
qif      = quadrupole('qif',  0.50000,  2.080195935321, 'StrMPoleSymplectic4Pass');
qid1     = quadrupole('qid1', 0.25000, -1.992913507517, 'StrMPoleSymplectic4Pass');
qid2     = quadrupole('qid2', 0.25000, -0.167625794581, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('qf1',  0.30000,  2.505595685532, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('qf2',  0.30000,  2.434589713965, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('qf3',  0.30000,  2.994848369566, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('qf4',  0.30000,  2.842499957554, 'StrMPoleSymplectic4Pass');
%qb       = quadrupole('qb',   0.10000,  qb_str,         'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);

b1e      = rbend('b1', 0.3929740, 0.023561944902, 0.023561944902, 0.000000000000, qb_str, 'BndMPoleSymplectic4Pass');
b1s      = rbend('b1', 0.3929740, 0.023561944902, 0.000000000000, 0.023561944902, qb_str, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('b2', 0.6112930, 0.036651914292, 0.036651914292, 0.000000000000, qb_str, 'BndMPoleSymplectic4Pass');
b2s      = rbend('b2', 0.6112930, 0.036651914292, 0.000000000000, 0.036651914292, qb_str, 'BndMPoleSymplectic4Pass');
b3       = rbend('b3', 0.4075290, 0.024434609528, 0.012217304764, 0.012217304764, qb_str, 'BndMPoleSymplectic4Pass');
bce      = rbend('bc', 0.0626965, 0.012217304764, 0.012217304764, 0.000000000000, 0,      'BndMPoleSymplectic4Pass');
bcs      = rbend('bc', 0.0626965, 0.012217304764, 0.000000000000, 0.012217304764, 0,      'BndMPoleSymplectic4Pass');

s1       = sextupole('s1', 0.200000, 0, 'StrMPoleSymplectic4Pass');
s2       = sextupole('s2', 0.200000, 0, 'StrMPoleSymplectic4Pass');
sd       = sextupole('sd', 0.200000, 0, 'StrMPoleSymplectic4Pass');
sf       = sextupole('sf', 0.200000, 0, 'StrMPoleSymplectic4Pass');

mb1      = marker('mb1', 'IdentityPass');
mb2      = marker('mb2', 'IdentityPass');
mc       = marker('mc', 'IdentityPass');
mq1      = marker('mq1', 'IdentityPass');
mq2      = marker('mq2', 'IdentityPass');
mi       = marker('mi', 'IdentityPass');
mt       = marker('mt', 'IdentityPass');

disp_ins = [b1e,mb1,b1s,lc1,qf1,lq,mq1,lq,qf2,lc2,b2e,mb2,b2s,lc3,qf3,lq,mq2,lq,qf4,lc4,b3,lb,bce,mc];
disp_cen = [mc,bcs,lb,b3,lc4,qf4,lq,mq2,lq,qf3,lc3,b2e,mb2,b2s,lc2,qf2,lq,mq1,lq,qf1,lc1,b1e,mb1,b1s];
ins      = [mi,li,qid1,l1,qif,l2,qid2,l3];
hsup_ins = [ins,disp_ins];
hsup_cen = [disp_cen,mt,fliplr(ins)];
sup      = [hsup_ins,hsup_cen];

nr_cells = 1;
anel     = repmat(sup,1,nr_cells);
 

THERING = buildlat(anel);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);
