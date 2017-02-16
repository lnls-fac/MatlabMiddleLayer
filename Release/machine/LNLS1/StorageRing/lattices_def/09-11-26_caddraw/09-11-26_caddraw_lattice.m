function r = lnls1_lattice

%%% HEADER SECTION %%%

global THERING
energy = 1370000000;

%%% TEMPLATE SECTION %%%

% QF Template %
e1 = quadrupole('QF', 0.30/2, 2.517371467317083, 'QuadLinearPass');
e2 = quadrupole('QF', 0.30/2, 2.517371467317083, 'QuadLinearPass');
QF_element = [e1 e2];

% QD Template %
e1 = quadrupole('QD', 0.30/2, -2.696107818970809, 'QuadLinearPass');
e2 = quadrupole('QD', 0.30/2, -2.696107818970809, 'QuadLinearPass');
QD_element = [e1 e2];

% QFC Template %
e1 = quadrupole('QFC', 0.30/2, 1.769473070824602, 'QuadLinearPass');
e2 = corrector  ('VCM', 0.00000, [0 0], 'CorrectorPass');
e3 = quadrupole('QFC', 0.30/2, 1.769473070824602, 'QuadLinearPass');
QFC_element = [e1 e2 e3];

% SKEWQUAD Template %
e1 = quadrupole('SKEWQUAD', 0.1/2, 0, 'QuadLinearPass');
e2 = quadrupole('SKEWQUAD', 0.1/2, 0, 'QuadLinearPass');
SKEWQUAD_element = [e1 e2];

% BEND Template %
e1 = rbend('BEND', 1.432*(4/30),  (2*pi/12)*(4/30), (2*pi/12)/2, 0, 0, 'BndMPoleSymplectic4Pass');
e2 = rbend('BEND', 1.432*(11/30), (2*pi/12)*(11/30), 0, 0, 0, 'BndMPoleSymplectic4Pass');
e3 = rbend('BEND', 1.432*(15/30), (2*pi/12)*(15/30), 0, (2*pi/12)/2, 0, 'BndMPoleSymplectic4Pass');
BEND_element = [e1 e2 e3];

% SD Template %
e1 = sextupole('SD', 0.1/2, -34.619552516400347, 'StrMPoleSymplectic4Pass');
e2 = sextupole('SD', 0.1/2, -34.619552516400347, 'StrMPoleSymplectic4Pass');
SD_element = [e1 e2];

% SF Template %
e1 = sextupole('SF', 0.1/2, 52.625252960900269, 'StrMPoleSymplectic4Pass');
e2 = sextupole('SF', 0.1/2, 52.625252960900269, 'StrMPoleSymplectic4Pass');
SF_element = [e1 e2];

% MBEGIN Template %
e1 = marker('BEGIN', 'IdentityPass');
MBEGIN_element = [e1];

% RF Template %
e1 = rfcavity('RF', 0, 0.3e+6, 476065680, 148, 'CavityPass');
RF_element = [e1];

% BPM Template %
e1 = marker('BPM', 'IdentityPass');
BPM_element = [e1];

% ACH Template %
e1 = corrector('HCM', 0*0.081, [0 0], 'CorrectorPass');
ACH_element = [e1];

% ACV Template %
e1 = corrector('VCM', 0*0.081, [0 0], 'CorrectorPass');
ACV_element = [e1];

% AWI09 Template %
e1 = drift('ID', 1.1, 'DriftPass');
AWI09_element = [e1];

% AON11 Template %
e1 = drift('ID', 2.8, 'DriftPass');
AON11_element = [e1];

%%% LATTICE SECTION %%%

% CELL: TR01

TR01_1 = drift('ATR', 0.806496667, 'DriftPass');
AQD01A = QD_element;
TR01_2 = drift('ATR', 0.1695, 'DriftPass');
ACV01A = ACV_element;
TR01_3 = drift('ATR', 0.1715, 'DriftPass');
AQF01A = QF_element;
TR01_4 = drift('ATR', 0.16546, 'DriftPass');
AMP01A = BPM_element;
TR01_5 = drift('ATR', 0.13204, 'DriftPass');
ACH01A = ACH_element;
TR01_6 = drift('ATR', 2.08317, 'DriftPass');
MBEGIN = MBEGIN_element;
TR01_7 = drift('ATR', 2.08517, 'DriftPass');
ACH01B = ACH_element;
TR01_8 = drift('ATR', 0.17272, 'DriftPass');
AMP01B = BPM_element;
TR01_9 = drift('ATR', 0.12278, 'DriftPass');
AQF01B = QF_element;
TR01_10 = drift('ATR', 0.1685, 'DriftPass');
ACV01B = ACV_element;
TR01_11 = drift('ATR', 0.1705, 'DriftPass');
AQD01B = QD_element;
TR01_12 = drift('ATR', 0.808496667, 'DriftPass');
TR01 = [TR01_1 AQD01A TR01_2 ACV01A TR01_3 AQF01A TR01_4 AMP01A TR01_5 ACH01A TR01_6 MBEGIN TR01_7 ACH01B TR01_8 AMP01B TR01_9 AQF01B TR01_10 ACV01B TR01_11 AQD01B TR01_12 ];


% CELL: ADI01

ADI01 = BEND_element;
ADI01 = [ADI01 ];


% CELL: TR02

TR02_1 = drift('ATR', 0.7205, 'DriftPass');
ASD02A = SD_element;
TR02_2 = drift('ATR', 0.1875, 'DriftPass');
AMP02A = BPM_element;
TR02_3 = drift('ATR', 0.0915, 'DriftPass');
AQF02A = QFC_element;
TR02_4 = drift('ATR', 0.759, 'DriftPass');
ASF02 = SF_element;
TR02_5 = drift('ATR', 0.2845, 'DriftPass');
ACH02 = ACH_element;
TR02_6 = drift('ATR', 0.4705, 'DriftPass');
AQF02B = QFC_element;
TR02_7 = drift('ATR', 0.115, 'DriftPass');
AMP02B = BPM_element;
TR02_8 = drift('ATR', 0.171, 'DriftPass');
ASD02B = SD_element;
TR02_9 = drift('ATR', 0.7135, 'DriftPass');
TR02 = [TR02_1 ASD02A TR02_2 AMP02A TR02_3 AQF02A TR02_4 ASF02 TR02_5 ACH02 TR02_6 AQF02B TR02_7 AMP02B TR02_8 ASD02B TR02_9 ];


% CELL: ADI02

ADI02 = BEND_element;
ADI02 = [ADI02 ];


% CELL: TR03

TR03_1 = drift('ATR', 0.806566667, 'DriftPass');
AQD03A = QD_element;
TR03_2 = drift('ATR', 0.17143, 'DriftPass');
ACV03A = ACV_element;
TR03_3 = drift('ATR', 0.1675, 'DriftPass');
AQF03A = QF_element;
TR03_4 = drift('ATR', 0.16126, 'DriftPass');
AMP03A = BPM_element;
TR03_5 = drift('ATR', 0.14024, 'DriftPass');
ACH03A = ACH_element;
TR03_6 = drift('ATR', 4.16334, 'DriftPass');
ACH03B = ACH_element;
TR03_7 = drift('ATR', 0.3005, 'DriftPass');
AQF03B = QF_element;
TR03_8 = drift('ATR', 0.11733, 'DriftPass');
ACV03B = ACV_element;
TR03_9 = drift('ATR', 0.22167, 'DriftPass');
AQD03B = QD_element;
TR03_10 = drift('ATR', 0.493282, 'DriftPass');
AMP03B = BPM_element;
TR03_11 = drift('ATR', 0.313214667, 'DriftPass');
TR03 = [TR03_1 AQD03A TR03_2 ACV03A TR03_3 AQF03A TR03_4 AMP03A TR03_5 ACH03A TR03_6 ACH03B TR03_7 AQF03B TR03_8 ACV03B TR03_9 AQD03B TR03_10 AMP03B TR03_11 ];


% CELL: ADI03

ADI03 = BEND_element;
ADI03 = [ADI03 ];


% CELL: TR04

TR04_1 = drift('ATR', 0.717, 'DriftPass');
ASD04A = SD_element;
TR04_2 = drift('ATR', 0.1665, 'DriftPass');
AMP04A = BPM_element;
TR04_3 = drift('ATR', 0.1155, 'DriftPass');
AQF04A = QFC_element;
TR04_4 = drift('ATR', 0.759, 'DriftPass');
ASF04 = SF_element;
TR04_5 = drift('ATR', 0.2045, 'DriftPass');
ACH04 = ACH_element;
TR04_6 = drift('ATR', 0.5515, 'DriftPass');
AQF04B = QFC_element;
TR04_7 = drift('ATR', 0.11655, 'DriftPass');
AMP04B = BPM_element;
TR04_8 = drift('ATR', 0.16845, 'DriftPass');
ASD04B = SD_element;
TR04_9 = drift('ATR', 0.714, 'DriftPass');
TR04 = [TR04_1 ASD04A TR04_2 AMP04A TR04_3 AQF04A TR04_4 ASF04 TR04_5 ACH04 TR04_6 AQF04B TR04_7 AMP04B TR04_8 ASD04B TR04_9 ];


% CELL: ADI04

ADI04 = BEND_element;
ADI04 = [ADI04 ];


% CELL: TR05

TR05_1 = drift('ATR', 0.820326667, 'DriftPass');
AQD05A = QD_element;
TR05_2 = drift('ATR', 0.1455, 'DriftPass');
ACV05A = ACV_element;
TR05_3 = drift('ATR', 0.1935, 'DriftPass');
AQF05A = QF_element;
TR05_4 = drift('ATR', 0.13856, 'DriftPass');
AMP05A = BPM_element;
TR05_5 = drift('ATR', 0.13794, 'DriftPass');
ACH05A = ACH_element;
TR05_6 = drift('ATR', 0.1435, 'DriftPass');
AQS05A = SKEWQUAD_element;
TR05_7 = drift('ATR', 1.82385, 'DriftPass');
ACB05 = RF_element;
TR05_8 = drift('ATR', 0.94646, 'DriftPass');
ACA05 = RF_element;
TR05_9 = drift('ATR', 0.92737, 'DriftPass');
AQS05B = SKEWQUAD_element;
TR05_10 = drift('ATR', 0.1435, 'DriftPass');
ACH05B = ACH_element;
TR05_11 = drift('ATR', 0.19004, 'DriftPass');
AMP05B = BPM_element;
TR05_12 = drift('ATR', 0.08646, 'DriftPass');
AQF05B = QF_element;
TR05_13 = drift('ATR', 0.1615, 'DriftPass');
ACV05B = ACV_element;
TR05_14 = drift('ATR', 0.1775, 'DriftPass');
AQD05B = QD_element;
TR05_15 = drift('ATR', 0.820326667, 'DriftPass');
TR05 = [TR05_1 AQD05A TR05_2 ACV05A TR05_3 AQF05A TR05_4 AMP05A TR05_5 ACH05A TR05_6 AQS05A TR05_7 ACB05 TR05_8 ACA05 TR05_9 AQS05B TR05_10 ACH05B TR05_11 AMP05B TR05_12 AQF05B TR05_13 ACV05B TR05_14 AQD05B TR05_15 ];


% CELL: ADI05

ADI05 = BEND_element;
ADI05 = [ADI05 ];


% CELL: TR06

TR06_1 = drift('ATR', 0.716, 'DriftPass');
ASD06A = SD_element;
TR06_2 = drift('ATR', 0.1665, 'DriftPass');
AMP06A = BPM_element;
TR06_3 = drift('ATR', 0.1175, 'DriftPass');
AQF06A = QFC_element;
TR06_4 = drift('ATR', 0.758, 'DriftPass');
ASF06 = SF_element;
TR06_5 = drift('ATR', 0.2015, 'DriftPass');
ACH06 = ACH_element;
TR06_6 = drift('ATR', 0.5535, 'DriftPass');
AQF06B = QFC_element;
TR06_7 = drift('ATR', 0.12276, 'DriftPass');
AMP06B = BPM_element;
TR06_8 = drift('ATR', 0.16424, 'DriftPass');
ASD06B = SD_element;
TR06_9 = drift('ATR', 0.713, 'DriftPass');
TR06 = [TR06_1 ASD06A TR06_2 AMP06A TR06_3 AQF06A TR06_4 ASF06 TR06_5 ACH06 TR06_6 AQF06B TR06_7 AMP06B TR06_8 ASD06B TR06_9 ];


% CELL: ADI06

ADI06 = BEND_element;
ADI06 = [ADI06 ];


% CELL: TR07

TR07_1 = drift('ATR', 0.814466667, 'DriftPass');
AQD07A = QD_element;
TR07_2 = drift('ATR', 0.1675, 'DriftPass');
ACV07A = ACV_element;
TR07_3 = drift('ATR', 0.1725, 'DriftPass');
AQF07A = QF_element;
TR07_4 = drift('ATR', 0.14359, 'DriftPass');
AMP07A = BPM_element;
TR07_5 = drift('ATR', 0.15191, 'DriftPass');
ACH07A = ACH_element;
TR07_6 = drift('ATR', 4.1514, 'DriftPass');
ACH07B = ACH_element;
TR07_7 = drift('ATR', 0.1914, 'DriftPass');
AMP07B = BPM_element;
TR07_8 = drift('ATR', 0.1091, 'DriftPass');
AQF07B = QF_element;
TR07_9 = drift('ATR', 0.1665, 'DriftPass');
ACV07B = ACV_element;
TR07_10 = drift('ATR', 0.1735, 'DriftPass');
AQD07B = QD_element;
TR07_11 = drift('ATR', 0.814466667, 'DriftPass');
TR07 = [TR07_1 AQD07A TR07_2 ACV07A TR07_3 AQF07A TR07_4 AMP07A TR07_5 ACH07A TR07_6 ACH07B TR07_7 AMP07B TR07_8 AQF07B TR07_9 ACV07B TR07_10 AQD07B TR07_11 ];


% CELL: ADI07

ADI07 = BEND_element;
ADI07 = [ADI07 ];


% CELL: TR08

TR08_1 = drift('ATR', 0.7145, 'DriftPass');
ASD08A = SD_element;
TR08_2 = drift('ATR', 0.175, 'DriftPass');
AMP08A = BPM_element;
TR08_3 = drift('ATR', 0.109, 'DriftPass');
AQF08A = QFC_element;
TR08_4 = drift('ATR', 0.7546, 'DriftPass');
ASF08 = SF_element;
TR08_5 = drift('ATR', 0.1959, 'DriftPass');
ACH08 = ACH_element;
TR08_6 = drift('ATR', 0.5655, 'DriftPass');
AQF08B = QFC_element;
TR08_7 = drift('ATR', 0.1094, 'DriftPass');
AMP08B = BPM_element;
TR08_8 = drift('ATR', 0.1766, 'DriftPass');
ASD08B = SD_element;
TR08_9 = drift('ATR', 0.7125, 'DriftPass');
TR08 = [TR08_1 ASD08A TR08_2 AMP08A TR08_3 AQF08A TR08_4 ASF08 TR08_5 ACH08 TR08_6 AQF08B TR08_7 AMP08B TR08_8 ASD08B TR08_9 ];


% CELL: ADI08

ADI08 = BEND_element;
ADI08 = [ADI08 ];


% CELL: TR09

TR09_1 = drift('ATR', 0.811266667, 'DriftPass');
AQD09A = QD_element;
TR09_2 = drift('ATR', 0.1725, 'DriftPass');
ACV09A = ACV_element;
TR09_3 = drift('ATR', 0.1655, 'DriftPass');
AQF09A = QF_element;
TR09_4 = drift('ATR', 0.1571, 'DriftPass');
AMP09A = BPM_element;
TR09_5 = drift('ATR', 0.1444, 'DriftPass');
ACH09A = ACH_element;
TR09_6 = drift('ATR', 1.5274, 'DriftPass');
AWI09 = AWI09_element;
TR09_7 = drift('ATR', 1.5304, 'DriftPass');
ACH09B = ACH_element;
TR09_8 = drift('ATR', 0.1914, 'DriftPass');
AMP09B = BPM_element;
TR09_9 = drift('ATR', 0.1071, 'DriftPass');
AQF09B = QF_element;
TR09_10 = drift('ATR', 0.1615, 'DriftPass');
ACV09B = ACV_element;
TR09_11 = drift('ATR', 0.1795, 'DriftPass');
AQD09B = QD_element;
TR09_12 = drift('ATR', 0.808266667, 'DriftPass');
TR09 = [TR09_1 AQD09A TR09_2 ACV09A TR09_3 AQF09A TR09_4 AMP09A TR09_5 ACH09A TR09_6 AWI09 TR09_7 ACH09B TR09_8 AMP09B TR09_9 AQF09B TR09_10 ACV09B TR09_11 AQD09B TR09_12 ];


% CELL: ADI09

ADI09 = BEND_element;
ADI09 = [ADI09 ];


% CELL: TR10

TR10_1 = drift('ATR', 0.7155, 'DriftPass');
ASD10A = SD_element;
TR10_2 = drift('ATR', 0.1732, 'DriftPass');
AMP10A = BPM_element;
TR10_3 = drift('ATR', 0.1118, 'DriftPass');
AQF10A = QFC_element;
TR10_4 = drift('ATR', 0.758, 'DriftPass');
ASF10 = SF_element;
TR10_5 = drift('ATR', 0.2295, 'DriftPass');
ACH10 = ACH_element;
TR10_6 = drift('ATR', 0.5245, 'DriftPass');
AQF10B = QFC_element;
TR10_7 = drift('ATR', 0.1268, 'DriftPass');
AMP10B = BPM_element;
TR10_8 = drift('ATR', 0.1602, 'DriftPass');
ASD10B = SD_element;
TR10_9 = drift('ATR', 0.7135, 'DriftPass');
TR10 = [TR10_1 ASD10A TR10_2 AMP10A TR10_3 AQF10A TR10_4 ASF10 TR10_5 ACH10 TR10_6 AQF10B TR10_7 AMP10B TR10_8 ASD10B TR10_9 ];


% CELL: ADI10

ADI10 = BEND_element;
ADI10 = [ADI10 ];


% CELL: TR11

TR11_1 = drift('ATR', 0.813966667, 'DriftPass');
AQD11A = QD_element;
TR11_2 = drift('ATR', 0.1695, 'DriftPass');
ACV11A = ACV_element;
TR11_3 = drift('ATR', 0.1675, 'DriftPass');
AQF11A = QF_element;
TR11_4 = drift('ATR', 0.1772, 'DriftPass');
AMP11A = BPM_element;
TR11_5 = drift('ATR', 0.1213, 'DriftPass');
ACH11A = ACH_element;
TR11_6 = drift('ATR', 0.41242, 'DriftPass');
AMU11A = BPM_element;
TR11_7 = drift('ATR', 0.26628, 'DriftPass');
AON11 = AON11_element;
TR11_8 = drift('ATR', 0.26569, 'DriftPass');
AMU11B = BPM_element;
TR11_9 = drift('ATR', 0.41301, 'DriftPass');
ACH11B = ACH_element;
TR11_10 = drift('ATR', 0.2126, 'DriftPass');
AMP11B = BPM_element;
TR11_11 = drift('ATR', 0.0829, 'DriftPass');
AQF11B = QF_element;
TR11_12 = drift('ATR', 0.1635, 'DriftPass');
ACV11B = ACV_element;
TR11_13 = drift('ATR', 0.1765, 'DriftPass');
AQD11B = QD_element;
TR11_14 = drift('ATR', 0.813966667, 'DriftPass');
TR11 = [TR11_1 AQD11A TR11_2 ACV11A TR11_3 AQF11A TR11_4 AMP11A TR11_5 ACH11A TR11_6 AMU11A TR11_7 AON11 TR11_8 AMU11B TR11_9 ACH11B TR11_10 AMP11B TR11_11 AQF11B TR11_12 ACV11B TR11_13 AQD11B TR11_14 ];


% CELL: ADI11

ADI11 = BEND_element;
ADI11 = [ADI11 ];


% CELL: TR12

TR12_1 = drift('ATR', 0.718, 'DriftPass');
ASD12A = SD_element;
TR12_2 = drift('ATR', 0.1858, 'DriftPass');
AMP12A = BPM_element;
TR12_3 = drift('ATR', 0.0982, 'DriftPass');
AQF12A = QFC_element;
TR12_4 = drift('ATR', 0.5055, 'DriftPass');
ACH12 = ACH_element;
TR12_5 = drift('ATR', 0.2485, 'DriftPass');
ASF12 = SF_element;
TR12_6 = drift('ATR', 0.755, 'DriftPass');
AQF12B = QFC_element;
TR12_7 = drift('ATR', 0.120555, 'DriftPass');
AMP12B = BPM_element;
TR12_8 = drift('ATR', 0.170445, 'DriftPass');
ASD12B = SD_element;
TR12_9 = drift('ATR', 0.711, 'DriftPass');
TR12 = [TR12_1 ASD12A TR12_2 AMP12A TR12_3 AQF12A TR12_4 ACH12 TR12_5 ASF12 TR12_6 AQF12B TR12_7 AMP12B TR12_8 ASD12B TR12_9 ];


% CELL: ADI12

ADI012 = BEND_element;
ADI12 = [ADI012 ];


%%% TAIL SECTION %%%

elist = [TR01 ADI01 TR02 ADI02 TR03 ADI03 TR04 ADI04 TR05 ADI05 TR06 ADI06 TR07 ADI07 TR08 ADI08 TR09 ADI09 TR10 ADI10 TR11 ADI11 TR12 ADI12  marker('END','IdentityPass') ];
THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);
mbegin = findcells(THERING, 'FamName', 'BEGIN');
if ~isempty(mbegin), THERING = circshift(THERING, [0 -mbegin(1)]); end
skquads = findcells(THERING, 'FamName', 'SKEWQUAD');
if ~isempty(skquads)
   fprintf('   Generating %i skew quadrupoles by rotating normal quads.\n', length(skquads));
   settilt(skquads, (pi/4)*ones(1,length(skquads)));
end
r = THERING;

% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   Length: %.6f m   (design length 93.2 m)\n', L0_tot);

% Compute initial tunes before loading errors
[InitialTunes, InitialChro] = tunechrom(THERING,0,'chrom','coupling');
fprintf('   Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
fprintf('   Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('   Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));
