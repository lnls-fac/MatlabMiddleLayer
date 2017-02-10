function r = lnls1_lattice

%%% HEADER SECTION %%%

global THERING
energy = 1370000000;

%%% TEMPLATE SECTION %%%

% MARKER Template %
e1 = marker('MARKER', 'IdentityPass');
MARKER_element = [e1];

% A2QF01 Template %
e1 = quadrupole('A2QF01', 0.27/2, 2.772739745354088, 'QuadLinearPass');
e2 = quadrupole('A2QF01', 0.27/2, 2.772739745354088, 'QuadLinearPass');
A2QF01_element = [e1 e2];

% A2QF03 Template %
e1 = quadrupole('A2QF03', 0.27/2, 2.772739745354088, 'QuadLinearPass');
e2 = quadrupole('A2QF03', 0.27/2, 2.772739745354088, 'QuadLinearPass');
A2QF03_element = [e1 e2];

% A2QF05 Template %
e1 = quadrupole('A2QF05', 0.27/2, 2.772739745354088, 'QuadLinearPass');
e2 = quadrupole('A2QF05', 0.27/2, 2.772739745354088, 'QuadLinearPass');
A2QF05_element = [e1 e2];

% A2QF07 Template %
e1 = quadrupole('A2QF07', 0.27/2, 2.772739745354088, 'QuadLinearPass');
e2 = quadrupole('A2QF07', 0.27/2, 2.772739745354088, 'QuadLinearPass');
A2QF07_element = [e1 e2];

% A2QF09 Template %
e1 = quadrupole('A2QF09', 0.27/2, 2.772739745354088, 'QuadLinearPass');
e2 = quadrupole('A2QF09', 0.27/2, 2.772739745354088, 'QuadLinearPass');
A2QF09_element = [e1 e2];

% A2QF11 Template %
e1 = quadrupole('A2QF11', 0.27/2, 2.772739745354088, 'QuadLinearPass');
e2 = quadrupole('A2QF11', 0.27/2, 2.772739745354088, 'QuadLinearPass');
A2QF11_element = [e1 e2];

% A2QD01 Template %
e1 = quadrupole('A2QD01', 0.27/2, -2.968598060859317, 'QuadLinearPass');
e2 = quadrupole('A2QD01', 0.27/2, -2.968598060859317, 'QuadLinearPass');
A2QD01_element = [e1 e2];

% A2QD03 Template %
e1 = quadrupole('A2QD03', 0.27/2, -2.968598060859317, 'QuadLinearPass');
e2 = quadrupole('A2QD03', 0.27/2, -2.968598060859317, 'QuadLinearPass');
A2QD03_element = [e1 e2];

% A2QD05 Template %
e1 = quadrupole('A2QD05', 0.27/2, -2.968598060859317, 'QuadLinearPass');
e2 = quadrupole('A2QD05', 0.27/2, -2.968598060859317, 'QuadLinearPass');
A2QD05_element = [e1 e2];

% A2QD07 Template %
e1 = quadrupole('A2QD07', 0.27/2, -2.968598060859317, 'QuadLinearPass');
e2 = quadrupole('A2QD07', 0.27/2, -2.968598060859317, 'QuadLinearPass');
A2QD07_element = [e1 e2];

% A2QD09 Template %
e1 = quadrupole('A2QD09', 0.27/2, -2.968598060859317, 'QuadLinearPass');
e2 = quadrupole('A2QD09', 0.27/2, -2.968598060859317, 'QuadLinearPass');
A2QD09_element = [e1 e2];

% A2QD11 Template %
e1 = quadrupole('A2QD11', 0.27/2, -2.968598060859317, 'QuadLinearPass');
e2 = quadrupole('A2QD11', 0.27/2, -2.968598060859317, 'QuadLinearPass');
A2QD11_element = [e1 e2];

% A6QF01 Template %
e1 = quadrupole('A6QF01', 0.27/2, 1.961093182324501, 'QuadLinearPass');
e2 = corrector  ('VCM', 0.00000, [0 0], 'CorrectorPass');
e3 = quadrupole('A6QF01', 0.27/2, 1.961093182324501, 'QuadLinearPass');
A6QF01_element = [e1 e2 e3];

% A6QF02 Template %
e1 = quadrupole('A6QF02', 0.27/2, 1.961093182324501, 'QuadLinearPass');
e2 = corrector  ('VCM', 0.00000, [0 0], 'CorrectorPass');
e3 = quadrupole('A6QF02', 0.27/2, 1.961093182324501, 'QuadLinearPass');
A6QF02_element = [e1 e2 e3];

% SKEWQUAD Template %
e1 = quadrupole('SKEWQUAD', 0.1/2, 0, 'QuadLinearPass');
e2 = quadrupole('SKEWQUAD', 0.1/2, 0, 'QuadLinearPass');
SKEWQUAD_element = [e1 e2];

% A12DI Template %
e1 = rbend('BEND', 1.432*(4/30),  (2*pi/12)*(4/30), (2*pi/12)/2, 0, 0, 'BndMPoleSymplectic4Pass');
e2 = rbend('BEND', 1.432*(11/30), (2*pi/12)*(11/30), 0, 0, 0, 'BndMPoleSymplectic4Pass');
e3 = rbend('BEND', 1.432*(15/30), (2*pi/12)*(15/30), 0, (2*pi/12)/2, 0, 'BndMPoleSymplectic4Pass');
A12DI_element = [e1 e2 e3];

% A6SF Template %
e1 = sextupole('A6SF', 0.1/2, 52.690335419566956, 'StrMPoleSymplectic4Pass');
e2 = sextupole('A6SF', 0.1/2, 52.690335419566956, 'StrMPoleSymplectic4Pass');
A6SF_element = [e1 e2];

% A6SD01 Template %
e1 = sextupole('A6SD01', 0.1/2, -34.696842207727805, 'StrMPoleSymplectic4Pass');
e2 = sextupole('A6SD01', 0.1/2, -34.696842207727805, 'StrMPoleSymplectic4Pass');
A6SD01_element = [e1 e2];

% A6SD02 Template %
e1 = sextupole('A6SD02', 0.1/2, -34.619552516400347, 'StrMPoleSymplectic4Pass');
e2 = sextupole('A6SD02', 0.1/2, -34.619552516400347, 'StrMPoleSymplectic4Pass');
A6SD02_element = [e1 e2];

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

% INJKICKER Template %
e1 = corrector('INJKICKER', 0, [0 0], 'CorrectorPass');
INJKICKER_element = [e1];

% AWI01 Template %
e1 = drift('ID', 2.7/2, 'DriftPass');
e2 = marker('BEGIN','IdentityPass');
e3 = drift('ID', 2.7/2, 'DriftPass');
AWI01_element = [e1 e2 e3];

% AWI09 Template %
e1 = drift('ID', 1.1/2, 'DriftPass');
e2 = marker('AWI09','IdentityPass');
e3 = drift('ID', 1.1/2, 'DriftPass');
AWI09_element = [e1 e2 e3];

% AON11 Template %
e1 = drift('ID', 2.8/2, 'DriftPass');
e2 = marker('AON11','IdentityPass');
e3 = drift('ID', 2.8/2, 'DriftPass');
AON11_element = [e1 e2 e3];

%%% LATTICE SECTION %%%

% CELL: TR01

TR01_1 = drift('ATR', 0.821490086, 'DriftPass');
AQD01A = A2QD01_element;
TR01_2 = drift('ATR', 0.1845, 'DriftPass');
ACV01A = ACV_element;
TR01_3 = drift('ATR', 0.1865, 'DriftPass');
AQF01A = A2QF01_element;
TR01_4 = drift('ATR', 0.18046, 'DriftPass');
AMP01A = BPM_element;
TR01_5 = drift('ATR', 0.13204, 'DriftPass');
ACH01A = ACH_element;
TR01_6 = drift('ATR', 0.73317, 'DriftPass');
AWI01 = AWI01_element;
TR01_7 = drift('ATR', 0.73517, 'DriftPass');
ACH01B = ACH_element;
TR01_8 = drift('ATR', 0.17272, 'DriftPass');
AMP01B = BPM_element;
TR01_9 = drift('ATR', 0.13778, 'DriftPass');
AQF01B = A2QF01_element;
TR01_10 = drift('ATR', 0.1835, 'DriftPass');
ACV01B = ACV_element;
TR01_11 = drift('ATR', 0.1855, 'DriftPass');
AQD01B = A2QD01_element;
TR01_12 = drift('ATR', 0.823490086, 'DriftPass');
TR01 = [TR01_1 AQD01A TR01_2 ACV01A TR01_3 AQF01A TR01_4 AMP01A TR01_5 ACH01A TR01_6 AWI01 TR01_7 ACH01B TR01_8 AMP01B TR01_9 AQF01B TR01_10 ACV01B TR01_11 AQD01B TR01_12 ];


% CELL: ADI01

ADI01 = A12DI_element;
ADI01 = [ADI01 ];


% CELL: TR02

TR02_1 = drift('ATR', 0.7205, 'DriftPass');
ASD02A = A6SD01_element;
TR02_2 = drift('ATR', 0.1875, 'DriftPass');
AMP02A = BPM_element;
TR02_3 = drift('ATR', 0.1065, 'DriftPass');
AQF02A = A6QF01_element;
TR02_4 = drift('ATR', 0.4245, 'DriftPass');
AKC02 = INJKICKER_element;
TR02_5 = drift('ATR', 0.3495, 'DriftPass');
ASF02 = A6SF_element;
TR02_6 = drift('ATR', 0.2845, 'DriftPass');
ACH02 = ACH_element;
TR02_7 = drift('ATR', 0.4855, 'DriftPass');
AQF02B = A6QF02_element;
TR02_8 = drift('ATR', 0.13, 'DriftPass');
AMP02B = BPM_element;
TR02_9 = drift('ATR', 0.171, 'DriftPass');
ASD02B = A6SD02_element;
TR02_10 = drift('ATR', 0.7135, 'DriftPass');
TR02 = [TR02_1 ASD02A TR02_2 AMP02A TR02_3 AQF02A TR02_4 AKC02 TR02_5 ASF02 TR02_6 ACH02 TR02_7 AQF02B TR02_8 AMP02B TR02_9 ASD02B TR02_10 ];


% CELL: ADI02

ADI02 = A12DI_element;
ADI02 = [ADI02 ];


% CELL: TR03

TR03_1 = drift('ATR', 0.821560086, 'DriftPass');
AQD03A = A2QD03_element;
TR03_2 = drift('ATR', 0.18643, 'DriftPass');
ACV03A = ACV_element;
TR03_3 = drift('ATR', 0.1825, 'DriftPass');
AQF03A = A2QF03_element;
TR03_4 = drift('ATR', 0.17626, 'DriftPass');
AMP03A = BPM_element;
TR03_5 = drift('ATR', 0.14024, 'DriftPass');
ACH03A = ACH_element;
TR03_6 = drift('ATR', 0.477184, 'DriftPass');
AKC03 = INJKICKER_element;
TR03_7 = drift('ATR', 1.603986, 'DriftPass');
TR03_CENTER = MARKER_element;
TR03_8 = drift('ATR', 1.770772, 'DriftPass');
AMP03B = BPM_element;
TR03_9 = drift('ATR', 0.311398, 'DriftPass');
ACH03B = ACH_element;
TR03_10 = drift('ATR', 0.3155, 'DriftPass');
AQF03B = A2QF03_element;
TR03_11 = drift('ATR', 0.13233, 'DriftPass');
ACV03B = ACV_element;
TR03_12 = drift('ATR', 0.23667, 'DriftPass');
AQD03B = A2QD03_element;
TR03_13 = drift('ATR', 0.821490086, 'DriftPass');
TR03 = [TR03_1 AQD03A TR03_2 ACV03A TR03_3 AQF03A TR03_4 AMP03A TR03_5 ACH03A TR03_6 AKC03 TR03_7 TR03_CENTER TR03_8 AMP03B TR03_9 ACH03B TR03_10 AQF03B TR03_11 ACV03B TR03_12 AQD03B TR03_13 ];


% CELL: ADI03

ADI03 = A12DI_element;
ADI03 = [ADI03 ];


% CELL: TR04

TR04_1 = drift('ATR', 0.717, 'DriftPass');
ASD04A = A6SD02_element;
TR04_2 = drift('ATR', 0.1665, 'DriftPass');
AMP04A = BPM_element;
TR04_3 = drift('ATR', 0.1305, 'DriftPass');
AQF04A = A6QF02_element;
TR04_4 = drift('ATR', 0.47146, 'DriftPass');
AKC04 = INJKICKER_element;
TR04_5 = drift('ATR', 0.30254, 'DriftPass');
ASF04 = A6SF_element;
TR04_6 = drift('ATR', 0.2045, 'DriftPass');
ACH04 = ACH_element;
TR04_7 = drift('ATR', 0.5665, 'DriftPass');
AQF04B = A6QF01_element;
TR04_8 = drift('ATR', 0.13155, 'DriftPass');
AMP04B = BPM_element;
TR04_9 = drift('ATR', 0.16845, 'DriftPass');
ASD04B = A6SD01_element;
TR04_10 = drift('ATR', 0.714, 'DriftPass');
TR04 = [TR04_1 ASD04A TR04_2 AMP04A TR04_3 AQF04A TR04_4 AKC04 TR04_5 ASF04 TR04_6 ACH04 TR04_7 AQF04B TR04_8 AMP04B TR04_9 ASD04B TR04_10 ];


% CELL: ADI04

ADI04 = A12DI_element;
ADI04 = [ADI04 ];


% CELL: TR05

TR05_1 = drift('ATR', 0.835320086, 'DriftPass');
AQD05A = A2QD05_element;
TR05_2 = drift('ATR', 0.1605, 'DriftPass');
ACV05A = ACV_element;
TR05_3 = drift('ATR', 0.2085, 'DriftPass');
AQF05A = A2QF05_element;
TR05_4 = drift('ATR', 0.15356, 'DriftPass');
AMP05A = BPM_element;
TR05_5 = drift('ATR', 0.13794, 'DriftPass');
ACH05A = ACH_element;
TR05_6 = drift('ATR', 0.1435, 'DriftPass');
AQS05A = SKEWQUAD_element;
TR05_7 = drift('ATR', 1.82385, 'DriftPass');
ACB05 = RF_element;
TR05_8 = drift('ATR', 0.02499, 'DriftPass');
TR05_CENTER = MARKER_element;
TR05_9 = drift('ATR', 0.92147, 'DriftPass');
ACA05 = RF_element;
TR05_10 = drift('ATR', 0.92737, 'DriftPass');
AQS05B = SKEWQUAD_element;
TR05_11 = drift('ATR', 0.1435, 'DriftPass');
ACH05B = ACH_element;
TR05_12 = drift('ATR', 0.19004, 'DriftPass');
AMP05B = BPM_element;
TR05_13 = drift('ATR', 0.10146, 'DriftPass');
AQF05B = A2QF05_element;
TR05_14 = drift('ATR', 0.1765, 'DriftPass');
ACV05B = ACV_element;
TR05_15 = drift('ATR', 0.1925, 'DriftPass');
AQD05B = A2QD05_element;
TR05_16 = drift('ATR', 0.835320086, 'DriftPass');
TR05 = [TR05_1 AQD05A TR05_2 ACV05A TR05_3 AQF05A TR05_4 AMP05A TR05_5 ACH05A TR05_6 AQS05A TR05_7 ACB05 TR05_8 TR05_CENTER TR05_9 ACA05 TR05_10 AQS05B TR05_11 ACH05B TR05_12 AMP05B TR05_13 AQF05B TR05_14 ACV05B TR05_15 AQD05B TR05_16 ];


% CELL: ADI05

ADI05 = A12DI_element;
ADI05 = [ADI05 ];


% CELL: TR06

TR06_1 = drift('ATR', 0.716, 'DriftPass');
ASD06A = A6SD01_element;
TR06_2 = drift('ATR', 0.1665, 'DriftPass');
AMP06A = BPM_element;
TR06_3 = drift('ATR', 0.1325, 'DriftPass');
AQF06A = A6QF01_element;
TR06_4 = drift('ATR', 0.773, 'DriftPass');
ASF06 = A6SF_element;
TR06_5 = drift('ATR', 0.2015, 'DriftPass');
ACH06 = ACH_element;
TR06_6 = drift('ATR', 0.5685, 'DriftPass');
AQF06B = A6QF02_element;
TR06_7 = drift('ATR', 0.13776, 'DriftPass');
AMP06B = BPM_element;
TR06_8 = drift('ATR', 0.16424, 'DriftPass');
ASD06B = A6SD02_element;
TR06_9 = drift('ATR', 0.713, 'DriftPass');
TR06 = [TR06_1 ASD06A TR06_2 AMP06A TR06_3 AQF06A TR06_4 ASF06 TR06_5 ACH06 TR06_6 AQF06B TR06_7 AMP06B TR06_8 ASD06B TR06_9 ];


% CELL: ADI06

ADI06 = A12DI_element;
ADI06 = [ADI06 ];


% CELL: TR07

TR07_1 = drift('ATR', 0.829460086, 'DriftPass');
AQD07A = A2QD07_element;
TR07_2 = drift('ATR', 0.1825, 'DriftPass');
ACV07A = ACV_element;
TR07_3 = drift('ATR', 0.1875, 'DriftPass');
AQF07A = A2QF07_element;
TR07_4 = drift('ATR', 0.15859, 'DriftPass');
AMP07A = BPM_element;
TR07_5 = drift('ATR', 0.15191, 'DriftPass');
ACH07A = ACH_element;
TR07_6 = drift('ATR', 2.0782, 'DriftPass');
TR07_CENTER = MARKER_element;
TR07_7 = drift('ATR', 2.0732, 'DriftPass');
ACH07B = ACH_element;
TR07_8 = drift('ATR', 0.1914, 'DriftPass');
AMP07B = BPM_element;
TR07_9 = drift('ATR', 0.1241, 'DriftPass');
AQF07B = A2QF07_element;
TR07_10 = drift('ATR', 0.1815, 'DriftPass');
ACV07B = ACV_element;
TR07_11 = drift('ATR', 0.1885, 'DriftPass');
AQD07B = A2QD07_element;
TR07_12 = drift('ATR', 0.829460086, 'DriftPass');
TR07 = [TR07_1 AQD07A TR07_2 ACV07A TR07_3 AQF07A TR07_4 AMP07A TR07_5 ACH07A TR07_6 TR07_CENTER TR07_7 ACH07B TR07_8 AMP07B TR07_9 AQF07B TR07_10 ACV07B TR07_11 AQD07B TR07_12 ];


% CELL: ADI07

ADI07 = A12DI_element;
ADI07 = [ADI07 ];


% CELL: TR08

TR08_1 = drift('ATR', 0.7145, 'DriftPass');
ASD08A = A6SD02_element;
TR08_2 = drift('ATR', 0.175, 'DriftPass');
AMP08A = BPM_element;
TR08_3 = drift('ATR', 0.124, 'DriftPass');
AQF08A = A6QF02_element;
TR08_4 = drift('ATR', 0.7696, 'DriftPass');
ASF08 = A6SF_element;
TR08_5 = drift('ATR', 0.1959, 'DriftPass');
ACH08 = ACH_element;
TR08_6 = drift('ATR', 0.5805, 'DriftPass');
AQF08B = A6QF01_element;
TR08_7 = drift('ATR', 0.1244, 'DriftPass');
AMP08B = BPM_element;
TR08_8 = drift('ATR', 0.1766, 'DriftPass');
ASD08B = A6SD01_element;
TR08_9 = drift('ATR', 0.7125, 'DriftPass');
TR08 = [TR08_1 ASD08A TR08_2 AMP08A TR08_3 AQF08A TR08_4 ASF08 TR08_5 ACH08 TR08_6 AQF08B TR08_7 AMP08B TR08_8 ASD08B TR08_9 ];


% CELL: ADI08

ADI08 = A12DI_element;
ADI08 = [ADI08 ];


% CELL: TR09

TR09_1 = drift('ATR', 0.826260086, 'DriftPass');
AQD09A = A2QD09_element;
TR09_2 = drift('ATR', 0.1875, 'DriftPass');
ACV09A = ACV_element;
TR09_3 = drift('ATR', 0.1805, 'DriftPass');
AQF09A = A2QF09_element;
TR09_4 = drift('ATR', 0.1721, 'DriftPass');
AMP09A = BPM_element;
TR09_5 = drift('ATR', 0.1444, 'DriftPass');
ACH09A = ACH_element;
TR09_6 = drift('ATR', 1.5274, 'DriftPass');
AWI09 = AWI09_element;
TR09_7 = drift('ATR', 1.5304, 'DriftPass');
ACH09B = ACH_element;
TR09_8 = drift('ATR', 0.1914, 'DriftPass');
AMP09B = BPM_element;
TR09_9 = drift('ATR', 0.1221, 'DriftPass');
AQF09B = A2QF09_element;
TR09_10 = drift('ATR', 0.1765, 'DriftPass');
ACV09B = ACV_element;
TR09_11 = drift('ATR', 0.1945, 'DriftPass');
AQD09B = A2QD09_element;
TR09_12 = drift('ATR', 0.823260086, 'DriftPass');
TR09 = [TR09_1 AQD09A TR09_2 ACV09A TR09_3 AQF09A TR09_4 AMP09A TR09_5 ACH09A TR09_6 AWI09 TR09_7 ACH09B TR09_8 AMP09B TR09_9 AQF09B TR09_10 ACV09B TR09_11 AQD09B TR09_12 ];


% CELL: ADI09

ADI09 = A12DI_element;
ADI09 = [ADI09 ];


% CELL: TR10

TR10_1 = drift('ATR', 0.7155, 'DriftPass');
ASD10A = A6SD01_element;
TR10_2 = drift('ATR', 0.1732, 'DriftPass');
AMP10A = BPM_element;
TR10_3 = drift('ATR', 0.1268, 'DriftPass');
AQF10A = A6QF01_element;
TR10_4 = drift('ATR', 0.773, 'DriftPass');
ASF10 = A6SF_element;
TR10_5 = drift('ATR', 0.2295, 'DriftPass');
ACH10 = ACH_element;
TR10_6 = drift('ATR', 0.5395, 'DriftPass');
AQF10B = A6QF02_element;
TR10_7 = drift('ATR', 0.1418, 'DriftPass');
AMP10B = BPM_element;
TR10_8 = drift('ATR', 0.1602, 'DriftPass');
ASD10B = A6SD02_element;
TR10_9 = drift('ATR', 0.7135, 'DriftPass');
TR10 = [TR10_1 ASD10A TR10_2 AMP10A TR10_3 AQF10A TR10_4 ASF10 TR10_5 ACH10 TR10_6 AQF10B TR10_7 AMP10B TR10_8 ASD10B TR10_9 ];


% CELL: ADI10

ADI10 = A12DI_element;
ADI10 = [ADI10 ];


% CELL: TR11

TR11_1 = drift('ATR', 0.828960086, 'DriftPass');
AQD11A = A2QD11_element;
TR11_2 = drift('ATR', 0.1845, 'DriftPass');
ACV11A = ACV_element;
TR11_3 = drift('ATR', 0.1825, 'DriftPass');
AQF11A = A2QF11_element;
TR11_4 = drift('ATR', 0.1922, 'DriftPass');
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
TR11_11 = drift('ATR', 0.0979, 'DriftPass');
AQF11B = A2QF11_element;
TR11_12 = drift('ATR', 0.1785, 'DriftPass');
ACV11B = ACV_element;
TR11_13 = drift('ATR', 0.1915, 'DriftPass');
AQD11B = A2QD11_element;
TR11_14 = drift('ATR', 0.828960086, 'DriftPass');
TR11 = [TR11_1 AQD11A TR11_2 ACV11A TR11_3 AQF11A TR11_4 AMP11A TR11_5 ACH11A TR11_6 AMU11A TR11_7 AON11 TR11_8 AMU11B TR11_9 ACH11B TR11_10 AMP11B TR11_11 AQF11B TR11_12 ACV11B TR11_13 AQD11B TR11_14 ];


% CELL: ADI11

ADI11 = A12DI_element;
ADI11 = [ADI11 ];


% CELL: TR12

TR12_1 = drift('ATR', 0.718, 'DriftPass');
ASD12A = A6SD02_element;
TR12_2 = drift('ATR', 0.1858, 'DriftPass');
AMP12A = BPM_element;
TR12_3 = drift('ATR', 0.1132, 'DriftPass');
AQF12A = A6QF02_element;
TR12_4 = drift('ATR', 0.5205, 'DriftPass');
ACH12 = ACH_element;
TR12_5 = drift('ATR', 0.2485, 'DriftPass');
ASF12 = A6SF_element;
TR12_6 = drift('ATR', 0.77, 'DriftPass');
AQF12B = A6QF01_element;
TR12_7 = drift('ATR', 0.135555, 'DriftPass');
AMP12B = BPM_element;
TR12_8 = drift('ATR', 0.170445, 'DriftPass');
ASD12B = A6SD01_element;
TR12_9 = drift('ATR', 0.711, 'DriftPass');
TR12 = [TR12_1 ASD12A TR12_2 AMP12A TR12_3 AQF12A TR12_4 ACH12 TR12_5 ASF12 TR12_6 AQF12B TR12_7 AMP12B TR12_8 ASD12B TR12_9 ];


% CELL: ADI12

ADI012 = A12DI_element;
ADI12 = [ADI012 ];


%%% TAIL SECTION %%%

elist = [TR01 ADI01 TR02 ADI02 TR03 ADI03 TR04 ADI04 TR05 ADI05 TR06 ADI06 TR07 ADI07 TR08 ADI08 TR09 ADI09 TR10 ADI10 TR11 ADI11 TR12 ADI12 ];
THERING = buildlat(elist);
mbegin = findcells(THERING, 'FamName', 'BEGIN');
if ~isempty(mbegin), THERING = circshift(THERING, [0 -(mbegin(1)-1)]); end
THERING{end+1} = struct('FamName','END','Length',0,'PassMethod','IdentityPass');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);
skquads = findcells(THERING, 'FamName', 'SKEWQUAD');
if ~isempty(skquads)
   fprintf('   Generating %i skew quadrupoles by rotating normal quads.\n', length(skquads));
   settilt(skquads, (pi/4)*ones(1,length(skquads)));
end
r = THERING;

% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   Length: %.6f m   (design length 93.1999 m)\n', L0_tot);

% Compute initial tunes before loading errors
[InitialTunes, InitialChro] = tunechrom(THERING,0,'chrom','coupling');
fprintf('   Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
fprintf('   Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('   Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));
