function r = lnls1_lattice
%LNLS1_LATTICE - LNLS1 Lattice Model (automatically created with <build_lattice_model>

%%% HEADER SECTION %%%

global THERING
energy = 500000000;

%%% TEMPLATE SECTION %%%

% MBEGIN Template %
e1 = marker('BEGIN', 'IdentityPass');
MBEGIN_element = [e1];

% S2QF01 Template %
e1 = quadrupole('S2QF01', 0.2, 2.943934403269779, 'QuadLinearPass');
S2QF01_element = [e1];

% S2QF07 Template %
e1 = quadrupole('S2QF07', 0.2, 2.943934403269779, 'QuadLinearPass');
S2QF07_element = [e1];

% S2QD01 Template %
e1 = quadrupole('S2QD01', 0.2, -2.050960154943163, 'QuadLinearPass');
S2QD01_element = [e1];

% S2QD07 Template %
e1 = quadrupole('S2QD07', 0.2, -2.050960154943163, 'QuadLinearPass');
S2QD07_element = [e1];

% S2QF02 Template %
e1 = quadrupole('S2QF02', 0.2, 3.23603188474, 'QuadLinearPass');
S2QF02_element = [e1];

% S2QF03 Template %
e1 = quadrupole('S2QF03', 0.2, 3.166907854112, 'QuadLinearPass');
S2QF03_element = [e1];

% S2QF04 Template %
e1 = quadrupole('S2QF04', 0.2, 2.407269293516, 'QuadLinearPass');
S2QF04_element = [e1];

% S2QF08 Template %
e1 = quadrupole('S2QF08', 0.2, 3.23603188474, 'QuadLinearPass');
S2QF08_element = [e1];

% S2QF09 Template %
e1 = quadrupole('S2QF09', 0.2, 3.166907854112, 'QuadLinearPass');
S2QF09_element = [e1];

% S2QS07 Template %
e1 = quadrupole('SKEWQUAD', 0.2, 0, 'QuadLinearPass');
S2QS07_element = [e1];

% S12DI Template %
e1 = rbend2('BEND', 0.54253,  (2*pi/12), (2*pi/12)/2, (2*pi/12)/2, -0.098122104639, 0.032, 0.6512, 0.6512, 'BndMPoleSymplectic4Pass');
S12DI_element = [e1];

% S4SF Template %
e1 = sextupole('S4SF', 0.1, 0, 'StrMPoleSymplectic4Pass');
S4SF_element = [e1];

% S4SD Template %
e1 = sextupole('S4SD', 0.1, 0, 'StrMPoleSymplectic4Pass');
S4SD_element = [e1];

% RF Template %
e1 = rfcavity('RF', 0, 0.3e+6, 476065680, 54, 'CavityPass');
RF_element = [e1];

% BPM Template %
e1 = marker('BPM', 'IdentityPass');
BPM_element = [e1];

% SCH Template %
e1 = corrector('HCM', 0*0.081, [0 0], 'CorrectorPass');
SCH_element = [e1];

% SCV Template %
e1 = corrector('VCM', 0*0.081, [0 0], 'CorrectorPass');
SCV_element = [e1];

% KICKER Template %
e1 = corrector('KICKER', 0, [0 0], 'CorrectorPass');
KICKER_element = [e1];

%%% LATTICE SECTION %%%

% CELL: TR01

TR01_1 = drift('ATR', 0.330939149, 'DriftPass');
SQD01A = S2QD01_element;
TR01_2 = drift('ATR', 0.2, 'DriftPass');
SQF01A = S2QF01_element;
TR01_3 = drift('ATR', 0.2, 'DriftPass');
SCH01 = SCH_element;
TR01_4 = drift('ATR', 1.84914, 'DriftPass');
BEGIN = MBEGIN_element;
TR01_5 = drift('ATR', 0.15, 'DriftPass');
SMP01 = BPM_element;
TR01_6 = drift('ATR', 0.17, 'DriftPass');
SCV01 = SCV_element;
TR01_7 = drift('ATR', 1.72914, 'DriftPass');
SQF01B = S2QF01_element;
TR01_8 = drift('ATR', 0.2, 'DriftPass');
SQD01B = S2QD01_element;
TR01_9 = drift('ATR', 0.330939149, 'DriftPass');
TR01 = [TR01_1 SQD01A TR01_2 SQF01A TR01_3 SCH01 TR01_4 BEGIN TR01_5 SMP01 TR01_6 SCV01 TR01_7 SQF01B TR01_8 SQD01B TR01_9 ];


% CELL: SDI01

SDI01 = S12DI_element;
SDI01 = [SDI01 ];


% CELL: TR02

TR02_1 = drift('ATR', 0.278735, 'DriftPass');
SMP02 = BPM_element;
TR02_2 = drift('ATR', 0.2, 'DriftPass');
SCH02 = SCH_element;
TR02_3 = drift('ATR', 0.2, 'DriftPass');
SQF02 = S2QF02_element;
TR02_4 = drift('ATR', 0.27, 'DriftPass');
SKC02 = KICKER_element;
TR02_5 = drift('ATR', 0.408735, 'DriftPass');
TR02 = [TR02_1 SMP02 TR02_2 SCH02 TR02_3 SQF02 TR02_4 SKC02 TR02_5 ];


% CELL: SDI02

SDI02 = S12DI_element;
SDI02 = [SDI02 ];


% CELL: TR03

TR03_1 = drift('ATR', 0.458735, 'DriftPass');
SCV03 = SCV_element;
TR03_2 = drift('ATR', 0.02, 'DriftPass');
SSD03 = S4SD_element;
TR03_3 = drift('ATR', 0.1, 'DriftPass');
SQF03 = S2QF03_element;
TR03_4 = drift('ATR', 0.15, 'DriftPass');
SMP03 = BPM_element;
TR03_5 = drift('ATR', 0.528735, 'DriftPass');
TR03 = [TR03_1 SCV03 TR03_2 SSD03 TR03_3 SQF03 TR03_4 SMP03 TR03_5 ];


% CELL: SDI03

SDI03 = S12DI_element;
SDI03 = [SDI03 ];


% CELL: TR04

TR04_1 = drift('ATR', 0.378735, 'DriftPass');
SCH04 = SCH_element;
TR04_2 = drift('ATR', 0.12, 'DriftPass');
SSF04A = S4SF_element;
TR04_3 = drift('ATR', 0.08, 'DriftPass');
SQF04 = S2QF04_element;
TR04_4 = drift('ATR', 0.08, 'DriftPass');
SSF04B = S4SF_element;
TR04_5 = drift('ATR', 0.12, 'DriftPass');
SMP04 = BPM_element;
TR04_6 = drift('ATR', 0.378735, 'DriftPass');
TR04 = [TR04_1 SCH04 TR04_2 SSF04A TR04_3 SQF04 TR04_4 SSF04B TR04_5 SMP04 TR04_6 ];


% CELL: SDI04

SDI04 = S12DI_element;
SDI04 = [SDI04 ];


% CELL: TR05

TR05_1 = drift('ATR', 0.358735, 'DriftPass');
SCV05 = SCV_element;
TR05_2 = drift('ATR', 0.17, 'DriftPass');
SCH05 = SCH_element;
TR05_3 = drift('ATR', 0.15, 'DriftPass');
SQF05 = S2QF03_element;
TR05_4 = drift('ATR', 0.1, 'DriftPass');
SSD05 = S4SD_element;
TR05_5 = drift('ATR', 0.12, 'DriftPass');
SMP05 = BPM_element;
TR05_6 = drift('ATR', 0.358735, 'DriftPass');
TR05 = [TR05_1 SCV05 TR05_2 SCH05 TR05_3 SQF05 TR05_4 SSD05 TR05_5 SMP05 TR05_6 ];


% CELL: SDI05

SDI05 = S12DI_element;
SDI05 = [SDI05 ];


% CELL: TR06

TR06_1 = drift('ATR', 0.528735, 'DriftPass');
SCH06 = SCH_element;
TR06_2 = drift('ATR', 0.15, 'DriftPass');
SQF06 = S2QF02_element;
TR06_3 = drift('ATR', 0.15, 'DriftPass');
SMP06 = BPM_element;
TR06_4 = drift('ATR', 0.528735, 'DriftPass');
TR06 = [TR06_1 SCH06 TR06_2 SQF06 TR06_3 SMP06 TR06_4 ];


% CELL: SDI06

SDI06 = S12DI_element;
SDI06 = [SDI06 ];


% CELL: TR07

TR07_1 = drift('ATR', 0.330939149, 'DriftPass');
SQD07A = S2QD07_element;
TR07_2 = drift('ATR', 0.2, 'DriftPass');
SQF07A = S2QF07_element;
TR07_3 = drift('ATR', 0.05, 'DriftPass');
SQS07A = S2QS07_element;
TR07_4 = drift('ATR', 1.79914, 'DriftPass');
CAV = RF_element;
TR07_5 = drift('ATR', 1.29914, 'DriftPass');
SMP07B = BPM_element;
TR07_6 = drift('ATR', 0.2, 'DriftPass');
SCV07 = SCV_element;
TR07_7 = drift('ATR', 0.2, 'DriftPass');
SCH07 = SCH_element;
TR07_8 = drift('ATR', 0.1, 'DriftPass');
SQS07B = S2QS07_element;
TR07_9 = drift('ATR', 0.05, 'DriftPass');
SQF07B = S2QF07_element;
TR07_10 = drift('ATR', 0.2, 'DriftPass');
SQD07B = S2QD07_element;
TR07_11 = drift('ATR', 0.330939149, 'DriftPass');
TR07 = [TR07_1 SQD07A TR07_2 SQF07A TR07_3 SQS07A TR07_4 CAV TR07_5 SMP07B TR07_6 SCV07 TR07_7 SCH07 TR07_8 SQS07B TR07_9 SQF07B TR07_10 SQD07B TR07_11 ];


% CELL: SDI07

SDI07 = S12DI_element;
SDI07 = [SDI07 ];


% CELL: TR08

TR08_1 = drift('ATR', 0.528735, 'DriftPass');
SMP08 = BPM_element;
TR08_2 = drift('ATR', 0.15, 'DriftPass');
SQF08 = S2QF08_element;
TR08_3 = drift('ATR', 0.15, 'DriftPass');
SCH08 = SCH_element;
TR08_4 = drift('ATR', 0.528735, 'DriftPass');
TR08 = [TR08_1 SMP08 TR08_2 SQF08 TR08_3 SCH08 TR08_4 ];


% CELL: SDI08

SDI08 = S12DI_element;
SDI08 = [SDI08 ];


% CELL: TR09

TR09_1 = drift('ATR', 0.378735, 'DriftPass');
SMP09 = BPM_element;
TR09_2 = drift('ATR', 0.1, 'DriftPass');
SSD09 = S4SD_element;
TR09_3 = drift('ATR', 0.1, 'DriftPass');
SQF09 = S2QF09_element;
TR09_4 = drift('ATR', 0.15, 'DriftPass');
SCH09 = SCH_element;
TR09_5 = drift('ATR', 0.17, 'DriftPass');
SCV09 = SCV_element;
TR09_6 = drift('ATR', 0.358735, 'DriftPass');
TR09 = [TR09_1 SMP09 TR09_2 SSD09 TR09_3 SQF09 TR09_4 SCH09 TR09_5 SCV09 TR09_6 ];


% CELL: SDI09

SDI09 = S12DI_element;
SDI09 = [SDI09 ];


% CELL: TR10

TR10_1 = drift('ATR', 0.378735, 'DriftPass');
SMP10 = BPM_element;
TR10_2 = drift('ATR', 0.12, 'DriftPass');
SSF10A = S4SF_element;
TR10_3 = drift('ATR', 0.08, 'DriftPass');
SQF10 = S2QF04_element;
TR10_4 = drift('ATR', 0.08, 'DriftPass');
SSF10B = S4SF_element;
TR10_5 = drift('ATR', 0.12, 'DriftPass');
SCH10 = SCH_element;
TR10_6 = drift('ATR', 0.378735, 'DriftPass');
TR10 = [TR10_1 SMP10 TR10_2 SSF10A TR10_3 SQF10 TR10_4 SSF10B TR10_5 SCH10 TR10_6 ];


% CELL: SDI10

SDI10 = S12DI_element;
SDI10 = [SDI10 ];


% CELL: TR11

TR11_1 = drift('ATR', 0.528735, 'DriftPass');
SMP11 = BPM_element;
TR11_2 = drift('ATR', 0.15, 'DriftPass');
SQF11 = S2QF09_element;
TR11_3 = drift('ATR', 0.1, 'DriftPass');
SSD11 = S4SD_element;
TR11_4 = drift('ATR', 0.12, 'DriftPass');
SCV11 = SCV_element;
TR11_5 = drift('ATR', 0.358735, 'DriftPass');
TR11 = [TR11_1 SMP11 TR11_2 SQF11 TR11_3 SSD11 TR11_4 SCV11 TR11_5 ];


% CELL: SDI11

SDI11 = S12DI_element;
SDI11 = [SDI11 ];


% CELL: TR12

TR12_1 = drift('ATR', 0.408735, 'DriftPass');
SKC12 = KICKER_element;
TR12_2 = drift('ATR', 0.27, 'DriftPass');
SQF12 = S2QF08_element;
TR12_3 = drift('ATR', 0.2, 'DriftPass');
SCH12 = SCH_element;
TR12_4 = drift('ATR', 0.2, 'DriftPass');
SMP12 = BPM_element;
TR12_5 = drift('ATR', 0.278735, 'DriftPass');
TR12 = [TR12_1 SKC12 TR12_2 SQF12 TR12_3 SCH12 TR12_4 SMP12 TR12_5 ];


% CELL: SDI12

SDI012 = S12DI_element;
SDI12 = [SDI012 ];


%%% TAIL SECTION %%%

elist = [TR01 SDI01 TR02 SDI02 TR03 SDI03 TR04 SDI04 TR05 SDI05 TR06 SDI06 TR07 SDI07 TR08 SDI08 TR09 SDI09 TR10 SDI10 TR11 SDI11 TR12 SDI12 ];
THERING = buildlat(elist);
mbegin = findcells(THERING, 'FamName', 'BEGIN');
if ~isempty(mbegin), THERING = circshift(THERING, [0 -(mbegin(1)-1)]); end
THERING{end+1} = struct('FamName','END','Length',0,'PassMethod','IdentityPass');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);
r = THERING;

% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   Length: %.6f m   (design length 34.0054 m)\n', L0_tot);

% Compute initial tunes before loading errors
[InitialTunes, InitialChro] = tunechrom(THERING,0,'chrom','coupling');
fprintf('   Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
fprintf('   Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('   Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));
