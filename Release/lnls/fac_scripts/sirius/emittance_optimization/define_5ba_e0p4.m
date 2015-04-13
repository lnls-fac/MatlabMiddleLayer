function THERING = define_5ba_e0p4

Energy = 3.000000;

%     betax   = 12.7069343; alphax  = 0.0000000;
%     etax    = -0.0007726; etaxp   = 0.0000000;
%     betay   = 1.1116917; alphay  = 0.0000000;
%     etay    = 0.0000000; etayp   = 0.0000000;
%     orbitx  = 0.0000000000; orbitxp = 0.0000000000;
%     orbity  = 0.0000000000; orbityp = 0.0000000000;
%     orbitdpp= 0.0000000000;
 
li       = drift('li',  3.000000000000, 'DriftPass');
l1       = drift('l1',  0.502661834548, 'DriftPass');
l2       = drift('l2',  0.523557043115, 'DriftPass');
l3       = drift('l3',  0.150031697126, 'DriftPass');
lc1      = drift('lc1', 0.998982694401, 'DriftPass');
lc2      = drift('lc2', 0.477673613008, 'DriftPass');
lc3      = drift('lc3', 0.475827473719, 'DriftPass');
lc4      = drift('lc4', 0.546117378693, 'DriftPass');
lq       = drift('DS',  0.245000000000, 'DriftPass');
lb       = drift('DS',  0.130000000000, 'DriftPass');

qb_str = -0.885308389757;
qif      = quadrupole('qif',  0.50000,  2.240148763713, 'StrMPoleSymplectic4Pass');
qid1     = quadrupole('qid1', 0.25000, -1.857545451919, 'StrMPoleSymplectic4Pass');
qid2     = quadrupole('qid2', 0.25000, -1.178336774733, 'StrMPoleSymplectic4Pass');
qf1      = quadrupole('qf1',  0.30000,  2.104466684689, 'StrMPoleSymplectic4Pass');
qf2      = quadrupole('qf2',  0.30000,  3.065308429594, 'StrMPoleSymplectic4Pass');
qf3      = quadrupole('qf3',  0.30000,  3.149026150919, 'StrMPoleSymplectic4Pass');
qf4      = quadrupole('qf4',  0.30000,  2.508480599047, 'StrMPoleSymplectic4Pass');
%qb       = quadrupole('qb',   0.10000,  qb_str,         'StrMPoleSymplectic4Pass');

deg2rad = (pi/180);

b1e      = rbend('b1', 0.3274785, deg2rad * 1.125000, deg2rad * 1.125000, deg2rad * 0.000000, qb_str, 'BndMPoleSymplectic4Pass');
b1s      = rbend('b1', 0.3274785, deg2rad * 1.125000, deg2rad * 0.000000, deg2rad * 1.125000, qb_str, 'BndMPoleSymplectic4Pass');          
b2e      = rbend('b2', 0.6549570, deg2rad * 2.250000, deg2rad * 2.250000, deg2rad * 0.000000, qb_str, 'BndMPoleSymplectic4Pass');
b2s      = rbend('b2', 0.6549570, deg2rad * 2.250000, deg2rad * 0.000000, deg2rad * 2.250000, qb_str, 'BndMPoleSymplectic4Pass');
b3       = rbend('b3', 0.4511930, deg2rad * 1.550000, deg2rad * 0.775000, deg2rad * 0.775000, qb_str, 'BndMPoleSymplectic4Pass');
bce      = rbend('bc', 0.0626965, deg2rad * 0.700000, deg2rad * 0.700000, deg2rad * 0.000000, 0,      'BndMPoleSymplectic4Pass');
bcs      = rbend('bc', 0.0626965, deg2rad * 0.700000, deg2rad * 0.000000, deg2rad * 0.700000, 0,      'BndMPoleSymplectic4Pass');

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
