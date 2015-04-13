function THERING = define_max_iv

Energy = 3.0;

STR0500 = drift('DS', 5.0000000000E-01, 'DriftPass');
STRa500 = drift('DS', 5.0000000000E-01, 'DriftPass');
STR0420 = drift('DS', 4.2000000000E-01, 'DriftPass');
STRx403 = drift('DS', 4.0311000000E-01, 'DriftPass');
STR0377 = drift('DS', 3.7700000000E-01, 'DriftPass');
STR0355 = drift('DS', 3.5500000000E-01, 'DriftPass');
STR0321 = drift('DS', 3.2100000000E-01, 'DriftPass');
STR0302 = drift('DS', 3.0200000000E-01, 'DriftPass');
STR0280 = drift('DS', 2.8000000000E-01, 'DriftPass');
STR0270 = drift('DS', 2.7000000000E-01, 'DriftPass');
STR0269 = drift('DS', 2.6900000000E-01, 'DriftPass');
STR0252 = drift('DS', 2.5200000000E-01, 'DriftPass');
STRx203 = drift('DS', 2.0311000000E-01, 'DriftPass');
STR0150 = drift('DS', 1.5000000000E-01, 'DriftPass');
STR0100 = drift('DS', 1.0000000000E-01, 'DriftPass');
STR0098 = drift('DS', 9.8000000000E-02, 'DriftPass');
STRx093 = drift('DS', 9.2680000000E-02, 'DriftPass');
STR0075 = drift('DS', 7.5000000000E-02, 'DriftPass');
STR0058 = drift('DS', 5.8000000000E-02, 'DriftPass');
STR0050 = drift('DS', 5.0000000000E-02, 'DriftPass');
STR0025 = drift('DS', 2.5000000000E-02, 'DriftPass');
STRa025 = drift('DS', 2.5000000000E-02, 'DriftPass');
STR0021 = drift('DS', 2.1000000000E-02, 'DriftPass');
STR0020 = drift('DS', 2.0000000000E-02, 'DriftPass');
STRx013 = drift('DS', 1.2500000000E-02, 'DriftPass');
STR0010 = drift('DS', 1.0000000000E-02, 'DriftPass');
STRx006 = drift('DS', 6.0800000000E-03, 'DriftPass');


SD    = drift('DS', 1.0000000000E-01, 'DriftPass');
SDend = drift('DS', 1.0000000000E-01, 'DriftPass');
SFm   = drift('DS', 1.0000000000E-01, 'DriftPass');
SFo   = drift('DS', 1.0000000000E-01, 'DriftPass');
SFi   = drift('DS', 1.0000000000E-01, 'DriftPass');

        
deg2rad = (pi/180);
D0  = rbend('BEND', 3.6189000000E-01, deg2rad * 1.085673, 0, 0, -0.861077, 'BndMPoleSymplectic4Pass');
Df1 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.149940, 0, 0, -0.861077, 'BndMPoleSymplectic4Pass');
Df2 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.149685, 0, 0, -0.860333, 'BndMPoleSymplectic4Pass'); 
Df3 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.107834, 0, 0, -0.587639, 'BndMPoleSymplectic4Pass');
Df4 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.005351, 0, 0, +0.006383, 'BndMPoleSymplectic4Pass');
Df5 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.001543, 0, 0, +0.000120, 'BndMPoleSymplectic4Pass');
Dm6 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.002217, 0, 0, -0.000512, 'BndMPoleSymplectic4Pass');
Dm5 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.053563, 0, 0, -0.290895, 'BndMPoleSymplectic4Pass');
Dm4 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.074264, 0, 0, -0.420126, 'BndMPoleSymplectic4Pass');
Dm3 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.077218, 0, 0, -0.426562, 'BndMPoleSymplectic4Pass');
Dm2 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.116500, 0, 0, -0.603412, 'BndMPoleSymplectic4Pass');
Dm1 = rbend('BEND', 5.0000000000E-02, deg2rad * 0.149165, 0, 0, -0.849425, 'BndMPoleSymplectic4Pass');
Dm0 = rbend('BEND', 2.0424000000E-01, deg2rad * 0.612721, 0, 0, -0.859980, 'BndMPoleSymplectic4Pass');
       
DIP   = [Df5, Df4, Df3, Df2, Df1, D0];
DIPm  = [Dm6, Dm5, Dm4, Dm3, Dm2, Dm1, Dm0, Df1, Df2, Df3, Df4, Df5];
DIPuc = [SD, STR0010, DIP, fliplr(DIP), STR0010, SD];

QF = quadrupole('QUAD', 1.5000000000E-01, 4.030907, 'StrMPoleSymplectic4Pass');
QFm = quadrupole('QUAD', 1.5000000000E-01, 3.776156, 'StrMPoleSymplectic4Pass');
QFend = quadrupole('QUAD', 2.5000000000E-01, 3.656234, 'StrMPoleSymplectic4Pass');
QDend = quadrupole('QUAD', 2.5000000000E-01, -2.507705, 'StrMPoleSymplectic4Pass');
      

BPM_D = drift('DS', 5.0e-2/2.0, 'DriftPass');
BPM = [BPM_D, BPM_D];

CORR_D = drift('DS', 10.0e-2/4.0, 'DriftPass');
CORR = [CORR_D, CORR_D, CORR_D, CORR_D];
CORRs = [CORR_D, CORR_D, CORR_D, CORR_D];


SQFm = [QFm, STR0075, SFm, STRx013, STRx013, QFm, STR0100];
SQFo = [QF,  STR0075, SFo, STRx013, STRx013, QF,  STR0100];
SQFi = [QF,  STR0075, SFi, STRx013, STRx013, QF,  STR0100];

OXX = drift('DS', 1.0e-1, 'DriftPass');
OXY = drift('DS', 1.0e-1, 'DriftPass');
OYY = drift('DS', 1.0e-1, 'DriftPass');
       


LS  = [STR0500, STR0500, STR0500, STR0500, STR0321];
MC1 = [BPM, STR0058, fliplr(CORR), STR0021, OXX, STR0025, QFend, STR0025, OXY, STR0100, QDend, STRx006, DIPm, OYY, STRx093, CORRs, BPM, STR0020, SDend];
MC2 = [BPM, STR0058, fliplr(CORR), STR0021, OXX, STR0025, QFend, STR0025, OXY, STR0100, QDend, STRx006, DIPm, OYY, STRx093, CORR, BPM, STR0020, SDend];
       
SS  = [STR0500, STR0500, STR0302];
UC1 = [SQFm, STRx203, DIPuc, STRx403];
UC2  = [SQFo, STRx203, DIPuc, STRx403];
UC3  = [SQFi, STRx203, DIPuc, STRx203, fliplr(SQFi)];
UC4  = [STRx403, DIPuc, STRx203, fliplr(SQFo)];
UC5  = [STRx403, DIPuc, STRx203, fliplr(SQFm)];

FIM  = marker('END', 'IdentityPass');

ACHR = [LS, MC1, SS, UC1, UC2, UC3, UC4, UC5, fliplr(SS), fliplr(MC2), fliplr(LS)];
nr_cells = 1;
RING = [repmat(ACHR, 1, nr_cells) FIM];

THERING = buildlat(RING);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), 1e9*Energy);

 