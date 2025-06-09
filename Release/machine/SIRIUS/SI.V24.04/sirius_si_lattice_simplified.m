function [r, lattice_title] = sirius_si_lattice(varargin)
global THERING;

% --- system parameters ---
energy = 3e9;
mode   = 'S05';
version = '01';
harmonic_number = 864;
lattice_version = 'SI.V24.04';

% magnets strengths
% QUADRUPOLES
% ===========
Q1_strength   = +2.818370601288;
Q2_strength   = +4.340329381668;
Q3_strength   = +3.218430939674;
Q4_strength   = +3.950686823494;

QDA_strength  = -1.619529595236;
QFA_strength  = +3.573170639946;
QDB1_strength = -2.006761160751;
QDB2_strength = -3.420551898839;
QFB_strength  = +4.115074652461;
QDP1_strength = -2.006761160751;
QDP2_strength = -3.420551898839;
QFP_strength  = +4.115074652461;

% SEXTUPOLES
% ==========
SDA0_strength = -80.8337;
SDB0_strength = -64.9422;
SDP0_strength = -64.9422;
SFA0_strength = +52.5696;
SFB0_strength = +73.7401;
SFP0_strength = +73.7401;

SDA1_strength = -163.00673496033022;
SDA2_strength = -88.88283372136254;
SDA3_strength = -139.94196759537465;
SFA1_strength = +191.76918761338641;
SFA2_strength = +150.74751943200232;
SDB1_strength = -141.68731012406636;
SDB2_strength = -122.31611630101850;
SDB3_strength = -173.83532728484047;
SFB1_strength = +227.74260050056122;
SFB2_strength = +197.75140194181881;
SDP1_strength = -142.31458860004548;
SDP2_strength = -122.28494860530658;
SDP3_strength = -174.17505598949975;
SFP1_strength = +229.17864087362835;
SFP2_strength = +198.45436904861020;

%% passmethods
%  ===========
bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';

% -- drifts --
LKK   = drift('lkk',  1.9150, 'DriftPass');
LPMU  = drift('lpmu', 0.0600, 'DriftPass');
LPMD  = drift('lpmd', 0.4929, 'DriftPass');
LIA   = drift('lia',  1.5179, 'DriftPass');
LIB   = drift('lib',  1.0879, 'DriftPass');
LIP   = drift('lip',  1.0879, 'DriftPass');

L011  = drift('l011', 0.011, 'DriftPass');
L049  = drift('l049', 0.049, 'DriftPass');
L052  = drift('l052', 0.052, 'DriftPass');
L056  = drift('l056', 0.056, 'DriftPass');
L074  = drift('l074', 0.074, 'DriftPass');
L075  = drift('l075', 0.075, 'DriftPass');
L081  = drift('l081', 0.081, 'DriftPass');
L082  = drift('l082', 0.082, 'DriftPass');
L090  = drift('l090', 0.090, 'DriftPass');
L100  = drift('l100', 0.100, 'DriftPass');
L112  = drift('l112', 0.112, 'DriftPass');
L119  = drift('l119', 0.119, 'DriftPass');
L120  = drift('l120', 0.120, 'DriftPass');
L125  = drift('l125', 0.125, 'DriftPass');
L127  = drift('l127', 0.127, 'DriftPass');
L133  = drift('l133', 0.133, 'DriftPass');
L134  = drift('l134', 0.134, 'DriftPass');
L135  = drift('l135', 0.135, 'DriftPass');
L140  = drift('l140', 0.140, 'DriftPass');
L150  = drift('l150', 0.150, 'DriftPass');
L170  = drift('l170', 0.170, 'DriftPass');
L200  = drift('l200', 0.200, 'DriftPass');
L201  = drift('l201', 0.201, 'DriftPass');
L205  = drift('l205', 0.205, 'DriftPass');
L216  = drift('l216', 0.216, 'DriftPass');
L230  = drift('l230', 0.230, 'DriftPass');
L237  = drift('l237', 0.237, 'DriftPass');
L240  = drift('l240', 0.240, 'DriftPass');
L260  = drift('l260', 0.260, 'DriftPass');
L325  = drift('l325', 0.325, 'DriftPass');
L336  = drift('l336', 0.336, 'DriftPass');
L419  = drift('l419', 0.419, 'DriftPass');
L474  = drift('l474', 0.474, 'DriftPass');
L500  = drift('l500', 0.500, 'DriftPass');
L715  = drift('l715', 0.715, 'DriftPass');

% -- dipoles --

[BC, ~] = sirius_si_bc_segmented_model_simp(bend_pass_method, m_accep_fam_name);
[B1, ~] = sirius_si_b1_segmented_model_simp(bend_pass_method, m_accep_fam_name);
[B2, ~] = sirius_si_b2_segmented_model_simp(bend_pass_method, m_accep_fam_name);

% -- quadrupoles --
[QFA, ~] = sirius_si_q20_segmented_model('QFA', QFA_strength,  quad_pass_method);
[QDA, ~] = sirius_si_q14_segmented_model('QDA', QDA_strength,  quad_pass_method);
[QDB2,~] = sirius_si_q14_segmented_model('QDB2',QDB2_strength, quad_pass_method);
[QFB, ~] = sirius_si_q30_segmented_model('QFB', QFB_strength,  quad_pass_method);
[QDB1,~] = sirius_si_q14_segmented_model('QDB1',QDB1_strength, quad_pass_method);
[QDP2,~] = sirius_si_q14_segmented_model('QDP2',QDP2_strength, quad_pass_method);
[QFP, ~] = sirius_si_q30_segmented_model('QFP', QFP_strength,  quad_pass_method);
[QDP1,~] = sirius_si_q14_segmented_model('QDP1',QDP1_strength, quad_pass_method);
[Q1,  ~] = sirius_si_q20_segmented_model('Q1',  Q1_strength,  quad_pass_method);
[Q2,  ~] = sirius_si_q20_segmented_model('Q2',  Q2_strength,  quad_pass_method);
[Q3,  ~] = sirius_si_q20_segmented_model('Q3',  Q3_strength,  quad_pass_method);
[Q4,  ~] = sirius_si_q20_segmented_model('Q4',  Q4_strength,  quad_pass_method);


% % -- sextupoles --
SDA0 = sextupole('SDA0', 0.150, SDA0_strength, sext_pass_method); %
SDB0 = sextupole('SDB0', 0.150, SDB0_strength, sext_pass_method); %
SDP0 = sextupole('SDP0', 0.150, SDP0_strength, sext_pass_method); %
SDA1 = sextupole('SDA1', 0.150, SDA1_strength, sext_pass_method); %
SDB1 = sextupole('SDB1', 0.150, SDB1_strength, sext_pass_method); %
SDP1 = sextupole('SDP1', 0.150, SDP1_strength, sext_pass_method); %
SDA2 = sextupole('SDA2', 0.150, SDA2_strength, sext_pass_method); %
SDB2 = sextupole('SDB2', 0.150, SDB2_strength, sext_pass_method); %
SDP2 = sextupole('SDP2', 0.150, SDP2_strength, sext_pass_method); %
SDA3 = sextupole('SDA3', 0.150, SDA3_strength, sext_pass_method); %
SDB3 = sextupole('SDB3', 0.150, SDB3_strength, sext_pass_method); %
SDP3 = sextupole('SDP3', 0.150, SDP3_strength, sext_pass_method); %
SFA0 = sextupole('SFA0', 0.150, SFA0_strength, sext_pass_method); %
SFB0 = sextupole('SFB0', 0.150, SFB0_strength, sext_pass_method); %
SFP0 = sextupole('SFP0', 0.150, SFP0_strength, sext_pass_method); %
SFA1 = sextupole('SFA1', 0.150, SFA1_strength, sext_pass_method); %
SFB1 = sextupole('SFB1', 0.150, SFB1_strength, sext_pass_method); %
SFP1 = sextupole('SFP1', 0.150, SFP1_strength, sext_pass_method); %
SFA2 = sextupole('SFA2', 0.150, SFA2_strength, sext_pass_method); %
SFB2 = sextupole('SFB2', 0.150, SFB2_strength, sext_pass_method); %
SFP2 = sextupole('SFP2', 0.150, SFP2_strength, sext_pass_method); %

% --- slow correctors ---
CV   = sextupole('CV', 0.150, 0.0, sext_pass_method);   % same model as BO correctors

% -- pulsed magnets --
InjDpKckr = sextupole('InjDpKckr', 0.400, 0.0, sext_pass_method); % injection kicker
InjNLKckr = sextupole('InjNLKckr',  0.450, 0.0, sext_pass_method); % pulsed multipole magnet

% -- BPMs and fast correctors --
FC1 = sextupole('FC1', 0.084, 0.0, sext_pass_method); % 70 magnets: skew quad poles (CH+CV adn CH+CV+QS)
FC2 = sextupole('FC2', 0.082, 0.0, sext_pass_method); % 10 magnets: normal quad poles (CH+CV adn CH+CV+QS)

% -- rf cavities --
RFC = rfcavity('SRFCav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');
HCav = marker('H3Cav', 'IdentityPass');

% -- lattice markers --
START  = marker('start',    'IdentityPass'); % start of the model
END    = marker('end',      'IdentityPass'); % end of the model
InjSeptF  = marker('InjSeptF',    'IdentityPass'); % end of thin injection septum

% -- diagnostics markers --
BPM    = marker('BPM',    'IdentityPass');
%% transport lines
M1A      = [L134,QDA,L150,SDA0,L074,FC1,L082,QFA,L150,SFA0,L135,BPM];                 % high beta xxM1 girder (with fasc corrector)
M1B      = [L134,QDB1,L150,SDB0,L240,QFB,L150,SFB0,L049,FC1,L052,QDB2,L140,BPM];      % low beta xxM1 girder
M1P      = [L134,QDP1,L150,SDP0,L240,QFP,L150,SFP0,L049,FC1,L052,QDP2,L140,BPM];      % low beta xxM1 girder
M2A      = fliplr(M1A);                                                                          % high beta xxM2 girder (with fast correctors)
M2B      = fliplr(M1B);                                                                          % low beta xxM2 girder
M2P      = fliplr(M1P);

M1B_BbBPkup = [L134,QDB1,L150,SDB0,L120,BbBPkup,L120,QFB,L150,SFB0,L049,FC1,L052,QDB2,L140,BPM];

IDA        = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                              % high beta ID straight section
IDA_INJ    = [L500,TuneShkrH,LIA,L419,InjSeptF,L081,L500,L500,END,START,MIA,...
              LKK,InjDpKckr,LPMU,ScrapV,L100,ScrapV,L100,InjNLKckr,LPMD];                                  % high beta INJ straight section and Scrapers
IDA_BbBKckrH  = [L500,BbBKckrH,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                  % high beta ID straight section
IDA_ScrapH    = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,ScrapH,LIA,L500];                    % high beta ID straight section
IDA17         = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,BbBKckrH,LIA,L500];                  % high beta ID straight section

IDB        = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,L500];                              % low beta ID straight section
IDB_GSL07    = [L500,GSL07,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,L500];                      % low beta ID straight section
IDB_TunePkup = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,TunePkup,LIB,L500];                   % low beta ID straight section
IDB02      = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,HCav,LIB,L500];                         % low beta ID straight section
IDB16      = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,BbBKckL,LIB,L500];                      % low beta ID straight section

IDP        = [L500,LIP,L500,MIDP,L500,L500,MIP,L500,L500,MIDP,L500,LIP,L500];                              % low beta ID straight section
IDP_CAV    = [L500,LIP,L500,L500,L500,MIP,RFC,L500,L500,L500,LIP,L500];                                    % low beta RF cavity straight section
IDP_GSL15  = [L500,GSL15,LIP,L500,MIDP,L500,L500,MIP,L500,L500,MIDP,L500, LIP,L500];                       % low beta ID straight section

C1A      = [L474,SDA1,L170,Q1,L135,BPM,L125,SFA1,L230,Q2,L170,SDA2,L205,BPM,L011];         % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C1B      = [L474,SDB1,L170,Q1,L135,BPM,L125,SFB1,L230,Q2,L170,SDB2,L205,BPM,L011];         % arc sector in between B1-B2 (low beta even-numbered straight sections)
C1P      = [L474,SDP1,L170,Q1,L135,BPM,L125,SFP1,L230,Q2,L170,SDP2,L205,BPM,L011];         % arc sector in between B1-B2 (low beta even-numbered straight sections)

C2A      = [L336,SDA3,L170,Q3,L230,SFA2,L260,Q4,L200,CV,L201,FC2,L119,BPM,L075];           % arc sector in between B2-BC (high beta odd-numbered straight sections)
C2B      = [L336,SDB3,L170,Q3,L230,SFB2,L260,Q4,L200,CV,L200,FC1,L119,BPM,L075];           % arc sector in between B2-BC (low beta even-numbered straight sections)
C2P      = [L336,SDP3,L170,Q3,L230,SFP2,L260,Q4,L200,CV,L201,FC2,L119,BPM,L075];           % arc sector in between B2-BC (low beta even-numbered straight sections)

C3A      = [L715,L112,Q4,L133,BPM,L127,SFA2,L056,FC1,L090,Q3,L170,SDA3,L325,BPM,L011];     % arc sector in between BC-B2 (high beta odd-numbered straight sections)
C3B      = [L715,L112,Q4,L133,BPM,L127,SFB2,L056,FC1,L090,Q3,L170,SDB3,L325,BPM,L011];     % arc sector in between BC-B2 (low beta even-numbered straight sections)
C3P      = [L715,L112,Q4,L133,BPM,L127,SFP2,L056,FC1,L090,Q3,L170,SDP3,L325,BPM,L011];     % arc sector in between BC-B2 (low beta even-numbered straight sections)

C4A          = [L216,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,L474];               % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C4A_BbBKckrV = [L216,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,L237,BbBKckrV,L237]; % arc sector in between B2-B1 (high beta odd-numbered straight sections)

C4B        = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_GBPM   = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,GBPM,L474];            % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_DCCT   = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,DCCT,L237];       % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_TunePkup = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,TunePkup,L237]; % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_PingV  = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,PingV,L237];      % arc sector in between B2-B1 (low beta even-numbered straight sections)

C4P        = [L216,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L474];                   % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4P_DCCT   = [L216,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L237,DCCT,L237];         % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4P_TuneShkrV = [L216,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L237,TuneShkrV,L237]; % arc sector in between B2-B1 (low beta even-numbered straight sections)

%% GIRDERS

% straight sections
SS_S01 = IDA_INJ;
SS_S02 = IDB02;
SS_S03 = IDP_CAV;
SS_S04 = IDB;
SS_S05 = IDA_ScrapH;
SS_S06 = IDB;
SS_S07 = IDP;
SS_S08 = IDB;
SS_S09 = IDA;
SS_S10 = IDB;
SS_S11 = IDP;
SS_S12 = IDB;
SS_S13 = IDA_BbBKckrH;
SS_S14 = IDB;
SS_S15 = IDP;
SS_S16 = IDB16;
SS_S17 = IDA17;
SS_S18 = IDB_TunePkup;
SS_S19 = IDP_GSL15;
SS_S20 = IDB_GSL07;

% down and upstream straight sections
M1_S01 = M1A;       M2_S01 = M2A;       M1_S02 = M1B;      M2_S02 = M2B;
M1_S03 = M1P;       M2_S03 = M2P;       M1_S04 = M1B;      M2_S04 = M2B;
M1_S05 = M1A;       M2_S05 = M2A;       M1_S06 = M1B;      M2_S06 = M2B;
M1_S07 = M1P;       M2_S07 = M2P;       M1_S08 = M1B;      M2_S08 = M2B;
M1_S09 = M1A;       M2_S09 = M2A;       M1_S10 = M1B;      M2_S10 = M2B;
M1_S11 = M1P;       M2_S11 = M2P;       M1_S12 = M1B_BbBPkup; M2_S12 = M2B;
M1_S13 = M1A;       M2_S13 = M2A;       M1_S14 = M1B;      M2_S14 = M2B;
M1_S15 = M1P;       M2_S15 = M2P;       M1_S16 = M1B;      M2_S16 = M2B;
M1_S17 = M1A;       M2_S17 = M2A;       M1_S18 = M1B;      M2_S18 = M2B;
M1_S19 = M1P;       M2_S19 = M2P;       M1_S20 = M1B;      M2_S20 = M2B;

% dispersive arcs
C1_S01 = C1A; C2_S01 = C2A;    C3_S01 = C3B; C4_S01 = C4B;
C1_S02 = C1B; C2_S02 = C2B;    C3_S02 = C3P; C4_S02 = C4P;
C1_S03 = C1P; C2_S03 = C2P;    C3_S03 = C3B; C4_S03 = C4B;
C1_S04 = C1B; C2_S04 = C2B;    C3_S04 = C3A; C4_S04 = C4A;
C1_S05 = C1A; C2_S05 = C2A;    C3_S05 = C3B; C4_S05 = C4B;
C1_S06 = C1B; C2_S06 = C2B;    C3_S06 = C3P; C4_S06 = C4P;
C1_S07 = C1P; C2_S07 = C2P;    C3_S07 = C3B; C4_S07 = C4B;
C1_S08 = C1B; C2_S08 = C2B;    C3_S08 = C3A; C4_S08 = C4A;
C1_S09 = C1A; C2_S09 = C2A;    C3_S09 = C3B; C4_S09 = C4B;
C1_S10 = C1B; C2_S10 = C2B;    C3_S10 = C3P; C4_S10 = C4P;
C1_S11 = C1P; C2_S11 = C2P;    C3_S11 = C3B; C4_S11 = C4B;
C1_S12 = C1B; C2_S12 = C2B;    C3_S12 = C3A; C4_S12 = C4A;
C1_S13 = C1A; C2_S13 = C2A;    C3_S13 = C3B; C4_S13 = C4B_DCCT;
C1_S14 = C1B; C2_S14 = C2B;    C3_S14 = C3P; C4_S14 = C4P_DCCT;
C1_S15 = C1P; C2_S15 = C2P;    C3_S15 = C3B; C4_S15 = C4B_GBPM;
C1_S16 = C1B; C2_S16 = C2B;    C3_S16 = C3A; C4_S16 = C4A_BbBKckrV;
C1_S17 = C1A; C2_S17 = C2A;    C3_S17 = C3B; C4_S17 = C4B_TunePkup;
C1_S18 = C1B; C2_S18 = C2B;    C3_S18 = C3P; C4_S18 = C4P_TuneShkrV;
C1_S19 = C1P; C2_S19 = C2P;    C3_S19 = C3B; C4_S19 = C4B_PingV;
C1_S20 = C1B; C2_S20 = C2B;    C3_S20 = C3A; C4_S20 = C4A;


%% SECTORS # 01..20

S01 = [M1_S01, SS_S01, M2_S01, B1, C1_S01, B2, C2_S01, BC, C3_S01, B2, C4_S01, B1];
S02 = [M1_S02, SS_S02, M2_S02, B1, C1_S02, B2, C2_S02, BC, C3_S02, B2, C4_S02, B1];
S03 = [M1_S03, SS_S03, M2_S03, B1, C1_S03, B2, C2_S03, BC, C3_S03, B2, C4_S03, B1];
S04 = [M1_S04, SS_S04, M2_S04, B1, C1_S04, B2, C2_S04, BC, C3_S04, B2, C4_S04, B1];
S05 = [M1_S05, SS_S05, M2_S05, B1, C1_S05, B2, C2_S05, BC, C3_S05, B2, C4_S05, B1];
S06 = [M1_S06, SS_S06, M2_S06, B1, C1_S06, B2, C2_S06, BC, C3_S06, B2, C4_S06, B1];
S07 = [M1_S07, SS_S07, M2_S07, B1, C1_S07, B2, C2_S07, BC, C3_S07, B2, C4_S07, B1];
S08 = [M1_S08, SS_S08, M2_S08, B1, C1_S08, B2, C2_S08, BC, C3_S08, B2, C4_S08, B1];
S09 = [M1_S09, SS_S09, M2_S09, B1, C1_S09, B2, C2_S09, BC, C3_S09, B2, C4_S09, B1];
S10 = [M1_S10, SS_S10, M2_S10, B1, C1_S10, B2, C2_S10, BC, C3_S10, B2, C4_S10, B1];
S11 = [M1_S11, SS_S11, M2_S11, B1, C1_S11, B2, C2_S11, BC, C3_S11, B2, C4_S11, B1];
S12 = [M1_S12, SS_S12, M2_S12, B1, C1_S12, B2, C2_S12, BC, C3_S12, B2, C4_S12, B1];
S13 = [M1_S13, SS_S13, M2_S13, B1, C1_S13, B2, C2_S13, BC, C3_S13, B2, C4_S13, B1];
S14 = [M1_S14, SS_S14, M2_S14, B1, C1_S14, B2, C2_S14, BC, C3_S14, B2, C4_S14, B1];
S15 = [M1_S15, SS_S15, M2_S15, B1, C1_S15, B2, C2_S15, BC, C3_S15, B2, C4_S15, B1];
S16 = [M1_S16, SS_S16, M2_S16, B1, C1_S16, B2, C2_S16, BC, C3_S16, B2, C4_S16, B1];
S17 = [M1_S17, SS_S17, M2_S17, B1, C1_S17, B2, C2_S17, BC, C3_S17, B2, C4_S17, B1];
S18 = [M1_S18, SS_S18, M2_S18, B1, C1_S18, B2, C2_S18, BC, C3_S18, B2, C4_S18, B1];
S19 = [M1_S19, SS_S19, M2_S19, B1, C1_S19, B2, C2_S19, BC, C3_S19, B2, C4_S19, B1];
S20 = [M1_S20, SS_S20, M2_S20, B1, C1_S20, B2, C2_S20, BC, C3_S20, B2, C4_S20, B1];
anel = [S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20];
elist = anel;

%% finalization

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'start');
if ~isempty(idx)
    THERING = [THERING(idx:end) THERING(1:idx-1)];
end

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
%rev_freq    = beta * const.c / L0_tot;
rev_freq    = const.c / L0_tot;
fprintf('   Circumference: %.5f m\n', L0_tot);

rf_idx      = findcells(THERING, 'FamName', 'SRFCav');
rf_frequency = rev_freq * harmonic_number;
THERING{rf_idx}.Frequency = rf_frequency;
fprintf(['   RF frequency set to ' num2str(rf_frequency/1e6) ' MHz.\n']);

% by default cavities and radiation is set to off
setcavity('off');
setradiation('off');

% sets default NumIntSteps values for elements
THERING = set_num_integ_steps(THERING);

% define vacuum chamber for all elements
THERING = set_vacuum_chamber(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

r = THERING;


function [model, model_length] = sirius_si_bc_segmented_model_simp(passmethod, m_accep_fam_name)

    if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
    if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

    types = {};
    bc   = 1; types{end+1} = struct('fam_name', 'BC', 'passmethod', passmethod);
    bc_edge = 2; types{end+1} = struct('fam_name', 'BC_EDGE', 'passmethod', 'IdentityPass');
    m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');

    % Average Dipole Model for BC
    % =============================================
    % date: 2019-06-27
    % Based on multipole expansion around average segmented model trajectory calculated
    % from fieldmap analysis of measurement data
    % folder = si-dipoles-bc/model-13/analysis/hallprobe/production/x0-0p079mm-reftraj
    % init_rx =  79 um
    % ref_rx  = 7.7030 mm (average model trajectory)
    % goal_tunes = [49.096188917357331, 14.151971558423915];
    % goal_chrom = [2.549478494984214, 2.527086095938103];

    monomials = [0,1,2,3,4,5,6,7,8,10];
    segmodel = [ ...
    %         len[m]  angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)   PolyB(n=7)   PolyB(n=8)   PolyB(n=10)
    bc,       0.00100, 0.01877, -1.4741e-05, -3.2459e-03, -2.5934e+01, +2.2655e+02, -4.2041e+05, -1.9362e+06, -8.8515e+08, +1.8066e+10, -4.1927e+13, +1.8535e+17;
    bc,       0.00400, 0.07328, -3.5868e-06, -8.0872e-03, -2.3947e+01, +1.9896e+02, -3.8312e+05, -1.5555e+06, -8.7538e+08, +1.5588e+10, -3.4411e+13, +1.5036e+17;
    bc,       0.00500, 0.08149, -1.5878e-06, -2.2156e-02, -1.6636e+01, +9.5225e+01, -2.4803e+05, -2.8667e+05, -6.2015e+08, +5.9788e+09, -1.1795e+13, +5.3967e+16;
    bc,       0.00500, 0.06914, -2.2515e-06, -2.6794e-02, -9.9744e+00, +4.0910e+01, -1.2934e+05, -1.8459e+04, +6.5912e+06, +1.8432e+09, -3.7282e+12, +1.5831e+16;
    bc,       0.00500, 0.05972, +2.4800e-07, -2.6704e-02, -7.1238e+00, +2.8365e+01, -7.1836e+04, -1.7947e+05, +2.5073e+08, +1.9029e+09, -3.3936e+12, +1.2829e+16;
    bc,       0.01000, 0.09814, -7.2919e-07, -2.5788e-02, -5.4243e+00, +1.8297e+01, -3.6399e+04, -1.8928e+05, +2.7961e+08, +1.5270e+09, -3.1054e+12, +1.1735e+16;
    bc,       0.01000, 0.07568, -1.8658e-06, -2.4549e-02, -3.7961e+00, +7.9939e+00, -1.8270e+04, -9.0518e+04, +2.3235e+08, +8.1040e+08, -2.4656e+12, +9.3410e+15;
    bc,       0.01000, 0.05755, -6.9437e-07, -1.9501e-02, -2.2458e+00, +2.9742e+00, -1.0525e+04, -1.8749e+04, +1.6339e+08, +2.9806e+08, -1.6673e+12, +6.2159e+15;
    bc,       0.01000, 0.04544, -1.2861e-07, -1.2764e-03, -8.7276e-01, -4.5371e-01, -5.5830e+03, +2.6585e+04, +9.6483e+07, +1.2858e+06, -1.0053e+12, +3.9069e+15;
    m_accep,  0,0,0,0,0,0,0,0,0,0,0,0;
    bc,       0.03200, 0.11887, -3.6974e-08, +1.2757e-02, +1.1825e+00, +1.8453e+00, -4.6262e+03, +2.4200e+04, +7.3751e+07, -6.3579e+07, -7.8054e+11, +3.0544e+15;
    bc,       0.03200, 0.09720, -9.0591e-07, -1.2063e-01, +5.2835e-01, +1.0917e+01, -3.2323e+03, -1.8683e+03, +4.9009e+07, -4.9946e+07, -4.6379e+11, +1.7988e+15;
    m_accep,  0,0,0,0,0,0,0,0,0,0,0,0;
    bc,       0.16000, 0.62161, -1.1668e-06, -8.9725e-01, +4.4207e-01, +3.2247e+01, +1.9416e+03, -2.8567e+05, -5.0265e+07, +1.4028e+09, +6.1042e+11, -2.5574e+15;
    bc,       0.16000, 0.62274, +2.8034e-07, -9.0717e-01, +2.0879e-01, -6.2815e-01, +1.9822e+03, +2.4218e+05, -4.1507e+07, -1.1837e+09, +4.3276e+11, -1.5769e+15;
    bc,       0.01200, 0.04249, +5.4796e-07, -8.8611e-01, +4.9910e-01, +2.4958e+01, -9.4206e+03, -1.6025e+05, +1.8960e+08, +8.8432e+08, -1.6666e+12, +5.5453e+15;
    bc_edge,  0,0,0,0,0,0,0,0,0,0,0,0;
    bc,       0.01400, 0.03339, -4.4895e-07, -4.4684e-01, -1.8750e+00, +2.2077e+01, -5.5912e+03, -1.6748e+05, +1.0327e+08, +9.3221e+08, -8.6332e+11, +2.7550e+15;
    bc,       0.01600, 0.01935, +7.1551e-07, -1.1215e-01, -1.9597e+00, +1.3313e+01, -3.5424e+03, -1.6337e+05, +6.3653e+07, +8.9179e+08, -5.4044e+11, +1.7393e+15;
    bc,       0.03500, 0.01344, -1.7487e-07, -1.9828e-02, -1.2534e+00, +1.9342e+01, +2.8084e+03, -2.9546e+05, -5.0640e+07, +1.4694e+09, +4.0940e+11, -1.2172e+15;
    ];

    % turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
    segmodel(:,4) = 0;

    % builds half of the magnet model
    d2r = pi/180.0;
    b = zeros(1,size(segmodel,1));
    maxorder = 1+max(monomials);
    for i=1:size(segmodel,1)
        type = types{segmodel(i,1)};
        if strcmpi(type.passmethod, 'IdentityPass')
            b(i) = marker(type.fam_name, 'IdentityPass');
        else
            PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
            PolyB(monomials+1) = segmodel(i,4:end);
            PolyB(1) = 0.0; PolyA(1) = 0.0; % convenience of a nominal lattice with zero 4D closed-orbit.
            b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
        end
    end

    % builds entire magnet model, inserting additional markers
    model_length = 2*sum(segmodel(:,2));
    mc = marker('mc', 'IdentityPass');
    m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
    model = [fliplr(b), mc, m_accep, b];


function [model, model_length] = sirius_si_b1_segmented_model_simp(passmethod, m_accep_fam_name)

    b_famname = 'B1';
    mb_famname = ['m',b_famname];
    edge_famname = [b_famname, '_edge'];

    if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
    if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

    types = {};
    b1      = 1; types{end+1} = struct('fam_name', b_famname, 'passmethod', passmethod);
    b1_edge = 2; types{end+1} = struct('fam_name', edge_famname, 'passmethod', 'IdentityPass');
    m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


    % Average Dipole Model for B1 at current 403p6A
    % =============================================
    % date: 2019-01-30
    % Based on multipole expansion around average segmented model trajectory calculated
    % from fieldmap analysis of measurement data
    % init_rx =  8.527 mm
    % ref_rx  = 13.693 mm (average model trajectory)
    % goal_tunes = [49.096188917357331, 14.151971558423915];
    % goal_chrom = [2.549478494984214, 2.527086095938103];

    monomials = [0,1,2,3,4,5,6];
    segmodel = [ ...
    %type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
    b1,       0.00200, 0.00633, -1.9696e-06, -7.2541e-01, -5.4213e-01, +5.4347e+00, +2.5091e+02, +4.9772e+02, -1.9113e+06;
    b1,       0.00300, 0.00951, -3.8061e-06, -7.2968e-01, -4.5292e-01, +4.3822e+00, +3.1863e+02, +1.5282e+03, -2.3387e+06;
    b1,       0.00500, 0.01592, -4.7568e-07, -7.4227e-01, -2.1669e-01, +2.9544e+00, +2.9316e+02, +1.4632e+03, -2.0877e+06;
    b1,       0.00500, 0.01603, -1.9480e-06, -7.5771e-01, -1.0657e-02, +3.5007e+00, +2.9571e+02, -1.7742e+03, -2.0010e+06;
    b1,       0.00500, 0.01611, -2.7633e-06, -7.6662e-01, +3.3285e-02, +4.7919e+00, +3.3381e+02, -3.3109e+03, -2.0402e+06;
    b1,       0.01000, 0.03236, -1.9098e-06, -7.7081e-01, +1.6451e-02, +5.3028e+00, +3.7119e+02, -4.8877e+03, -2.0590e+06;
    b1,       0.04000, 0.12963, -1.6309e-06, -7.7247e-01, +4.8673e-02, +4.6505e+00, +3.3306e+02, -2.1646e+03, -1.5868e+06;
    b1,       0.15000, 0.48382, -1.9888e-06, -7.7332e-01, +9.7601e-02, +5.3336e+00, +2.5126e+02, +8.0649e+02, -9.2335e+05;
    b1,       0.10000, 0.32247, -2.1025e-06, -7.7271e-01, +1.1969e-01, +5.6811e+00, +2.1496e+02, +5.2023e+03, -6.0518e+05;
    b1,       0.05000, 0.16165, -2.1257e-06, -7.7203e-01, +5.6224e-02, +4.5293e+00, +6.3908e+01, +6.1651e+03, +3.4951e+05;
    b1,       0.03400, 0.10509, -1.8623e-06, -7.7144e-01, -1.2160e-01, +9.1976e+00, -5.3231e+01, +9.0360e+03, +7.2783e+05;
    b1_edge, 0,0,0,0,0,0,0,0,0;
    b1,       0.01600, 0.03414, -9.6169e-07, -4.5231e-01, -1.8149e+00, +1.9400e+01, -2.2843e+02, +1.6525e+04, -4.0477e+04;
    b1,       0.04000, 0.03296, -5.2504e-07, -8.6643e-02, -1.7536e+00, +8.5147e+00, -5.8350e+01, +4.2954e+03, -3.7834e+04;
    b1,       0.04000, 0.00774, -1.6259e-07, -8.3065e-03, -3.8990e-01, +1.3183e+00, +2.5814e+01, +3.1642e+02, -5.0464e+04;
    b1,       0.05000, 0.00389, -7.9445e-08, -1.0742e-03, -9.8271e-02, +5.0359e-02, -1.0312e+01, +9.0013e+02, +8.2477e+04;
    m_accep, 0,0,0,0,0,0,0,0,0;
    ];


    % turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
    segmodel(:,4) = 0;


    % builds half of the magnet model
    d2r = pi/180.0;
    b = zeros(1,size(segmodel,1));
    maxorder = 1+max(monomials);
    for i=1:size(segmodel,1)
        type = types{segmodel(i,1)};
        if strcmpi(type.passmethod, 'IdentityPass')
            b(i) = marker(type.fam_name, 'IdentityPass');
        else
            PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
            PolyB(monomials+1) = segmodel(i,4:end);
            PolyB(1) = 0.0; PolyA(1) = 0.0; % convenience of a nominal lattice with zero 4D closed-orbit.
            b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
        end
    end

    % builds entire magnet model, inserting additional markers
    model_length = 2*sum(segmodel(:,2));
    mb1 = marker(mb_famname, 'IdentityPass');
    m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
    model = [fliplr(b), mb1, m_accep, b];


    function [model, model_length] = sirius_si_b2_segmented_model_simp(passmethod, m_accep_fam_name)

b_famname = 'B2';
mb_famname = ['m',b_famname];
edge_famname = [b_famname, '_edge'];

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
b2      = 1; types{end+1} = struct('fam_name', b_famname, 'passmethod', passmethod);
b2_edge = 2; types{end+1} = struct('fam_name', edge_famname, 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


% Average Dipole Model for B2 at current 401p8A
% =============================================
% date: 2019-01-30
% Based on multipole expansion around average segmented model trajectory calculated
% from fieldmap analysis of measurement data
% init_rx =  8.153 mm
% ref_rx  = 19.428 mm (average model trajectory)
% goal_tunes = [49.096188917357331, 14.151971558423915];
% goal_chrom = [2.549478494984214, 2.527086095938103];

monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
b2,       0.12500, 0.40623, +2.8141e-07, -7.7535e-01, +3.8504e-02, +1.7048e+00, -2.6809e+02, +8.8090e+03, +1.8541e+06;
b2,       0.05500, 0.17963, +2.4869e-07, -7.7400e-01, +1.8903e-02, +1.3538e+00, -2.7871e+02, +8.4667e+03, +1.7913e+06;
b2,       0.01000, 0.03260, -1.4532e-07, -7.6990e-01, -7.3993e-03, +1.4325e+00, -3.7053e+02, +9.0098e+03, +1.8818e+06;
b2,       0.00500, 0.01624, -9.6976e-07, -7.6272e-01, -4.4905e-02, +3.7505e-01, -4.0759e+02, +1.0527e+04, +1.8729e+06;
b2,       0.00500, 0.01619, -8.5112e-08, -7.5413e-01, -1.7000e-01, +1.3254e-01, -4.2095e+02, +1.2650e+04, +1.8762e+06;
b2,       0.00500, 0.01616, +5.0825e-07, -7.4866e-01, -2.8166e-01, +7.1392e-01, -3.5386e+02, +1.3287e+04, +1.5160e+06;
m_accep,  0,0,0,0,0,0,0,0,0;
b2,       0.00500, 0.01618, +1.7001e-06, -7.5218e-01, -2.1312e-01, +3.8486e-01, -3.9031e+02, +1.2889e+04, +1.7072e+06;
b2,       0.01000, 0.03254, +1.3585e-06, -7.6428e-01, -4.1565e-02, +6.7680e-01, -4.0577e+02, +1.0602e+04, +1.8735e+06;
b2,       0.01000, 0.03269, +2.9027e-07, -7.7165e-01, -8.0002e-03, +1.7812e+00, -3.2568e+02, +8.2067e+03, +1.7365e+06;
b2,       0.17500, 0.57073, -1.1637e-07, -7.7428e-01, +6.8988e-02, +4.1024e+00, -5.1871e+01, +7.5752e+02, +5.9943e+05;
b2,       0.17500, 0.57034, -3.3225e-07, -7.7352e-01, +7.8447e-02, +5.4514e+00, +1.9975e+02, +3.3621e+03, -3.1314e+05;
b2,       0.02000, 0.06315, +2.2577e-08, -7.8534e-01, -1.4538e-01, +9.2976e+00, -1.5715e+02, +1.2311e+04, +1.1408e+06;
b2,       0.01000, 0.02719, +8.7645e-08, -6.7626e-01, -3.1354e-01, +1.6050e+01, -3.9938e+02, +1.6288e+04, +8.1085e+05;
b2_edge, 0,0,0,0,0,0,0,0,0;
b2,       0.01500, 0.02866, +6.3204e-08, -3.6034e-01, -2.3415e+00, +2.0402e+01, -3.9166e+02, +1.9055e+04, +3.1586e+05;
b2,       0.02000, 0.01994, +5.4460e-07, -1.0711e-01, -2.1654e+00, +1.1296e+01, -1.7816e+02, +7.2357e+03, +1.6786e+05;
b2,       0.03000, 0.01188, +1.3393e-07, -2.3886e-02, -8.9207e-01, +3.8284e+00, -1.5146e+01, +5.3693e+02, +7.8230e+04;
b2,       0.03200, 0.00444, -2.8999e-07, -4.5556e-03, -2.6166e-01, +7.8754e-01, +1.5573e+00, +8.3579e+01, +3.8831e+04;
b2,       0.03250, 0.00341, -1.3468e-07, -1.2481e-03, -1.3069e-01, +3.6679e-01, +1.3671e+01, -7.7370e+02, -2.9544e+04;
m_accep,  0,0,0,0,0,0,0,0,0;
];


% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
segmodel(:,4) = 0;


% builds half of the magnet model
d2r = pi/180.0;
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end);
        PolyB(1) = 0.0; PolyA(1) = 0.0; % convenience of a nominal lattice with zero 4D closed-orbit.
        b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end
end

% builds entire magnet model, inserting additional markers
model_length = 2*sum(segmodel(:,2));
mb2 = marker(mb_famname, 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mb2, m_accep, b];


function [model, model_length] = sirius_si_b2_segmented_model_simp(passmethod, m_accep_fam_name)

    b_famname = 'B2';
    mb_famname = ['m',b_famname];
    edge_famname = [b_famname, '_edge'];

    if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
    if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

    types = {};
    b2      = 1; types{end+1} = struct('fam_name', b_famname, 'passmethod', passmethod);
    b2_edge = 2; types{end+1} = struct('fam_name', edge_famname, 'passmethod', 'IdentityPass');
    m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


    % Average Dipole Model for B2 at current 401p8A
    % =============================================
    % date: 2019-01-30
    % Based on multipole expansion around average segmented model trajectory calculated
    % from fieldmap analysis of measurement data
    % init_rx =  8.153 mm
    % ref_rx  = 19.428 mm (average model trajectory)
    % goal_tunes = [49.096188917357331, 14.151971558423915];
    % goal_chrom = [2.549478494984214, 2.527086095938103];

    monomials = [0,1,2,3,4,5,6];
    segmodel = [ ...
    %type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6)
    b2,       0.12500, 0.40623, +2.8141e-07, -7.7535e-01, +3.8504e-02, +1.7048e+00, -2.6809e+02, +8.8090e+03, +1.8541e+06;
    b2,       0.05500, 0.17963, +2.4869e-07, -7.7400e-01, +1.8903e-02, +1.3538e+00, -2.7871e+02, +8.4667e+03, +1.7913e+06;
    b2,       0.01000, 0.03260, -1.4532e-07, -7.6990e-01, -7.3993e-03, +1.4325e+00, -3.7053e+02, +9.0098e+03, +1.8818e+06;
    b2,       0.00500, 0.01624, -9.6976e-07, -7.6272e-01, -4.4905e-02, +3.7505e-01, -4.0759e+02, +1.0527e+04, +1.8729e+06;
    b2,       0.00500, 0.01619, -8.5112e-08, -7.5413e-01, -1.7000e-01, +1.3254e-01, -4.2095e+02, +1.2650e+04, +1.8762e+06;
    b2,       0.00500, 0.01616, +5.0825e-07, -7.4866e-01, -2.8166e-01, +7.1392e-01, -3.5386e+02, +1.3287e+04, +1.5160e+06;
    m_accep,  0,0,0,0,0,0,0,0,0;
    b2,       0.00500, 0.01618, +1.7001e-06, -7.5218e-01, -2.1312e-01, +3.8486e-01, -3.9031e+02, +1.2889e+04, +1.7072e+06;
    b2,       0.01000, 0.03254, +1.3585e-06, -7.6428e-01, -4.1565e-02, +6.7680e-01, -4.0577e+02, +1.0602e+04, +1.8735e+06;
    b2,       0.01000, 0.03269, +2.9027e-07, -7.7165e-01, -8.0002e-03, +1.7812e+00, -3.2568e+02, +8.2067e+03, +1.7365e+06;
    b2,       0.17500, 0.57073, -1.1637e-07, -7.7428e-01, +6.8988e-02, +4.1024e+00, -5.1871e+01, +7.5752e+02, +5.9943e+05;
    b2,       0.17500, 0.57034, -3.3225e-07, -7.7352e-01, +7.8447e-02, +5.4514e+00, +1.9975e+02, +3.3621e+03, -3.1314e+05;
    b2,       0.02000, 0.06315, +2.2577e-08, -7.8534e-01, -1.4538e-01, +9.2976e+00, -1.5715e+02, +1.2311e+04, +1.1408e+06;
    b2,       0.01000, 0.02719, +8.7645e-08, -6.7626e-01, -3.1354e-01, +1.6050e+01, -3.9938e+02, +1.6288e+04, +8.1085e+05;
    b2_edge, 0,0,0,0,0,0,0,0,0;
    b2,       0.01500, 0.02866, +6.3204e-08, -3.6034e-01, -2.3415e+00, +2.0402e+01, -3.9166e+02, +1.9055e+04, +3.1586e+05;
    b2,       0.02000, 0.01994, +5.4460e-07, -1.0711e-01, -2.1654e+00, +1.1296e+01, -1.7816e+02, +7.2357e+03, +1.6786e+05;
    b2,       0.03000, 0.01188, +1.3393e-07, -2.3886e-02, -8.9207e-01, +3.8284e+00, -1.5146e+01, +5.3693e+02, +7.8230e+04;
    b2,       0.03200, 0.00444, -2.8999e-07, -4.5556e-03, -2.6166e-01, +7.8754e-01, +1.5573e+00, +8.3579e+01, +3.8831e+04;
    b2,       0.03250, 0.00341, -1.3468e-07, -1.2481e-03, -1.3069e-01, +3.6679e-01, +1.3671e+01, -7.7370e+02, -2.9544e+04;
    m_accep,  0,0,0,0,0,0,0,0,0;
    ];


    % turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
    segmodel(:,4) = 0;


    % builds half of the magnet model
    d2r = pi/180.0;
    b = zeros(1,size(segmodel,1));
    maxorder = 1+max(monomials);
    for i=1:size(segmodel,1)
        type = types{segmodel(i,1)};
        if strcmpi(type.passmethod, 'IdentityPass')
            b(i) = marker(type.fam_name, 'IdentityPass');
        else
            PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
            PolyB(monomials+1) = segmodel(i,4:end);
            PolyB(1) = 0.0; PolyA(1) = 0.0; % convenience of a nominal lattice with zero 4D closed-orbit.
            b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
        end
    end

    % builds entire magnet model, inserting additional markers
    model_length = 2*sum(segmodel(:,2));
    mb2 = marker(mb_famname, 'IdentityPass');
    m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
    model = [fliplr(b), mb2, m_accep, b];
