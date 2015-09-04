function [the_ring, lattice_title] = sirius_bo_lattice(varargin)
%maquina com simetria 50, formada por dipolos e quadrupolos com sextupolos
%integrados. 15/08/2012 - Fernando.
% modelode segmentado dos dipolos. 10/04/2014
% mudan??a de padr??o para baixa energia.

%%% HEADER SECTION %%%

global THERING

energy = 0.15e9; % eV

lattice_version = 'BO.V01';
for i=1:length(varargin)
	energy = varargin{i} * 1e9;
end
mode = 'M';
version = '0';

harmonic_number = 828;
rf_voltage = sirius_bo_rf_voltage(energy);
%if energy == 0.15e9, rf_voltage = 150e3; else rf_voltage = 950e3; end

lattice_title = [lattice_version '.' mode version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';

% loads magnet strengths
set_magnets_strength_booster;

% a segmented model for the dipole has been created from the
% approved fieldmap. The segmented model has a longer length 
% and the difference has to be accomodated.
% loads dipole segmented model:
[B, b_len_seg] = dipole_segmented_model(bend_pass_method);

b_len_hdedge     = 1.152; % [m]
% b_length_segmented = 1.538; % [m]
lenDif     = (b_len_seg - b_len_hdedge)/2.0;

L01475   = drift('l01475',  0.14750, 'DriftPass');
L0241    = drift('l0241',   0.24100, 'DriftPass');
L02475   = drift('l02475',  0.24750, 'DriftPass');
L0250    = drift('l0250',   0.25000, 'DriftPass');
L0350    = drift('l0350',   0.35000, 'DriftPass');
L0360    = drift('l0360',   0.36000, 'DriftPass');
L0555    = drift('l0555',   0.55500, 'DriftPass');
L0600    = drift('l0600',   0.60000, 'DriftPass');
L0800    = drift('l0800',   0.80000, 'DriftPass');
L1000    = drift('l1000',   1.00000, 'DriftPass');
L1096    = drift('l1096',   1.09600, 'DriftPass');
L1146    = drift('l1146',   1.14600, 'DriftPass');
L1486    = drift('l1486',   1.48600, 'DriftPass');
L1546    = drift('l1546',   1.54600, 'DriftPass');
L17935   = drift('l17935',  1.79350, 'DriftPass');
L179563  = drift('l179563', 1.79563, 'DriftPass');
L1846    = drift('l1846',   1.84600, 'DriftPass');
L18935   = drift('l18935',  1.89350, 'DriftPass');
L1896    = drift('l1896',   1.89600, 'DriftPass');
L2146    = drift('l2146',   2.14600, 'DriftPass');



% drifts affected by the dipole modelling:
D02475   = drift('d02475', 0.2475-lenDif,  'DriftPass');
D024963  = drift('d0250',  0.24963-lenDif, 'DriftPass');
D0300    = drift('d0300',  0.3000-lenDif,  'DriftPass');
D2146    = drift('d2146',  2.1460-lenDif,  'DriftPass');

STR  = marker('start',   'IdentityPass');     % start of the model
FIM  = marker('end',     'IdentityPass');     % end of the model
GIR  = marker('girder',  'IdentityPass');
KIN  = marker('kick_in', 'IdentityPass');
SIN  = marker('sept_in', 'IdentityPass');
SEX  = marker('sept_ex', 'IdentityPass');
mqf  = marker('mqf',     'IdentityPass');

KEX  = quadrupole('kick_ex', 0.5, 0.0, quad_pass_method);

QD   = quadrupole('qd', 0.100740, qd_strength, quad_pass_method);
QFI  = quadrupole('qf', 0.100000, qf_strength, quad_pass_method);
QF   = [QFI,mqf,QFI];
SF   = sextupole ('sf', 0.105000, sf_strength, sext_pass_method);   
SD   = sextupole ('sd', 0.105000, sd_strength, sext_pass_method);

BPM  = marker('bpm', 'IdentityPass');
CH   = corrector('ch', 0, [0, 0], 'CorrectorPass');
CV   = corrector('cv', 0, [0, 0], 'CorrectorPass');

RFC = rfcavity('cav', 0, rf_voltage, 0, harmonic_number, 'CavityPass'); % RF frequency will be set later.

DW    = [GIR, L2146,                            D2146, GIR];
DW_QD = [GIR, L2146,                            L179563, GIR, QD, D024963];
DW_KE = [GIR, L0350, KEX, L0241, KEX, L0555,    L179563, GIR, QD, D024963];
DW_KI = [GIR, L0600, KIN, L1546,                D2146, GIR];
DW_CH = [L0250, CH, GIR, L1896,                 D2146, GIR];
DW_RF = [GIR, L2146, RFC,                       D2146, GIR];
UP_SF = [GIR, D2146, BPM,                       L18935, GIR, SF, L01475];
UP_CC = [D0300, CV, GIR, L1846, BPM,            L1896, GIR, CH, L0250];
UP_CS = [D02475, SD, L02475, CV, GIR, L1546, BPM, L1896, GIR, CH, L0250];
UP_SS = [D02475, SD, GIR, L17935, BPM,           L18935, GIR, SF, L01475];
UP_SE = [D0300, CV, GIR, L1486, SEX, L0360,     L1000, BPM, L1146, GIR];
UP_SI = [D0300, CV, GIR, L1846, BPM,            L1096, SIN, L0800, GIR, CH, L0250];


UP_01 = UP_SI;        DW_01 = DW_KI;        S01 = [UP_01, QFI, FIM, STR, mqf, QFI, DW_01, B];      
UP_02 = UP_SF;        DW_02 = DW_QD;        S02 = [UP_02, QF, DW_02, B];
UP_03 = UP_CS;        DW_03 = DW;           S03 = [UP_03, QF, DW_03, B];   
UP_04 = UP_SF;        DW_04 = DW_QD;        S04 = [UP_04, QF, DW_04, B];
UP_05 = UP_CC;        DW_05 = DW_RF;        S05 = [UP_05, QF, DW_05, B];      
UP_06 = UP_SF;        DW_06 = DW_QD;        S06 = [UP_06, QF, DW_06, B];
UP_07 = UP_CC;        DW_07 = DW;           S07 = [UP_07, QF, DW_07, B];   
UP_08 = UP_SS;        DW_08 = DW_QD;        S08 = [UP_08, QF, DW_08, B];
UP_09 = UP_CC;        DW_09 = DW;           S09 = [UP_09, QF, DW_09, B];   
UP_10 = UP_SF;        DW_10 = DW_QD;        S10 = [UP_10, QF, DW_10, B];
UP_11 = UP_CC;        DW_11 = DW;           S11 = [UP_11, QF, DW_11, B];   
UP_12 = UP_SF;        DW_12 = DW_QD;        S12 = [UP_12, QF, DW_12, B];
UP_13 = UP_CS;        DW_13 = DW;           S13 = [UP_13, QF, DW_13, B];   
UP_14 = UP_SF;        DW_14 = DW_QD;        S14 = [UP_14, QF, DW_14, B];
UP_15 = UP_CC;        DW_15 = DW;           S15 = [UP_15, QF, DW_15, B];   
UP_16 = UP_SF;        DW_16 = DW_QD;        S16 = [UP_16, QF, DW_16, B];
UP_17 = UP_CC;        DW_17 = DW;           S17 = [UP_17, QF, DW_17, B];   
UP_18 = UP_SS;        DW_18 = DW_QD;        S18 = [UP_18, QF, DW_18, B];
UP_19 = UP_CC;        DW_19 = DW;           S19 = [UP_19, QF, DW_19, B];   
UP_20 = UP_SF;        DW_20 = DW_QD;        S20 = [UP_20, QF, DW_20, B];
UP_21 = UP_CC;        DW_21 = DW;           S21 = [UP_21, QF, DW_21, B];   
UP_22 = UP_SF;        DW_22 = DW_QD;        S22 = [UP_22, QF, DW_22, B];
UP_23 = UP_CS;        DW_23 = DW;           S23 = [UP_23, QF, DW_23, B];   
UP_24 = UP_SF;        DW_24 = DW_QD;        S24 = [UP_24, QF, DW_24, B];
UP_25 = UP_CC;        DW_25 = DW;           S25 = [UP_25, QF, DW_25, B];   
UP_26 = UP_SF;        DW_26 = DW_QD;        S26 = [UP_26, QF, DW_26, B];
UP_27 = UP_CC;        DW_27 = DW;           S27 = [UP_27, QF, DW_27, B];   
UP_28 = UP_SS;        DW_28 = DW_QD;        S28 = [UP_28, QF, DW_28, B];
UP_29 = UP_CC;        DW_29 = DW;           S29 = [UP_29, QF, DW_29, B];   
UP_30 = UP_SF;        DW_30 = DW_QD;        S30 = [UP_30, QF, DW_30, B];
UP_31 = UP_CC;        DW_31 = DW;           S31 = [UP_31, QF, DW_31, B];   
UP_32 = UP_SF;        DW_32 = DW_QD;        S32 = [UP_32, QF, DW_32, B];
UP_33 = UP_CS;        DW_33 = DW;           S33 = [UP_33, QF, DW_33, B];   
UP_34 = UP_SF;        DW_34 = DW_QD;        S34 = [UP_34, QF, DW_34, B];
UP_35 = UP_CC;        DW_35 = DW;           S35 = [UP_35, QF, DW_35, B];   
UP_36 = UP_SF;        DW_36 = DW_QD;        S36 = [UP_36, QF, DW_36, B];
UP_37 = UP_CC;        DW_37 = DW;           S37 = [UP_37, QF, DW_37, B];   
UP_38 = UP_SS;        DW_38 = DW_QD;        S38 = [UP_38, QF, DW_38, B];
UP_39 = UP_CC;        DW_39 = DW;           S39 = [UP_39, QF, DW_39, B];   
UP_40 = UP_SF;        DW_40 = DW_QD;        S40 = [UP_40, QF, DW_40, B];
UP_41 = UP_CC;        DW_41 = DW;           S41 = [UP_41, QF, DW_41, B];   
UP_42 = UP_SF;        DW_42 = DW_QD;        S42 = [UP_42, QF, DW_42, B];
UP_43 = UP_CS;        DW_43 = DW;           S43 = [UP_43, QF, DW_43, B];   
UP_44 = UP_SF;        DW_44 = DW_QD;        S44 = [UP_44, QF, DW_44, B];
UP_45 = UP_CC;        DW_45 = DW;           S45 = [UP_45, QF, DW_45, B];   
UP_46 = UP_SF;        DW_46 = DW_QD;        S46 = [UP_46, QF, DW_46, B];
UP_47 = UP_CC;        DW_47 = DW;           S47 = [UP_47, QF, DW_47, B];   
UP_48 = UP_SS;        DW_48 = DW_KE;        S48 = [UP_48, QF, DW_48, B];
UP_49 = UP_SE;        DW_49 = DW_CH;        S49 = [UP_49, QF, DW_49, B];      
UP_50 = UP_SF;        DW_50 = DW_QD;        S50 = [UP_50, QF, DW_50, B];


elist = [S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,...
         S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,...
         S21,S22,S23,S24,S25,S26,S27,S28,S29,S30,...
         S31,S32,S33,S34,S35,S36,S37,S38,S39,S40,...
         S41,S42,S43,S44,S45,S46,S47,S48,S49,S50];

%% finalization 

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'start'
idx = findcells(THERING, 'FamName', 'start');
if numel(idx) == 1
    THERING = circshift(THERING, [0,-(idx-1)]);
end

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
const  = lnls_constants;
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
L0_tot = findspos(THERING, length(THERING)+1);
%rev_freq     = beta * const.c / L0_tot;
rev_freq     = const.c / L0_tot;
rf_idx       = findcells(THERING, 'FamName', 'cav');
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

% defines girders
THERING = set_girders(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

the_ring = THERING;


function the_ring = set_vacuum_chamber(the_ring)

% y = +/- y_lim * sqrt(1 - (x/x_lim)^n);

bends_vchamber = [0.0117 0.0117 1]; % n = 100: ~rectangular
other_vchamber = [0.018  0.018  1];   % n = 1;   circular/eliptica

for i=1:length(the_ring)
    if isfield(the_ring{i}, 'BendingAngle')
        the_ring{i}.VChamber = bends_vchamber;
    else
        the_ring{i}.VChamber = other_vchamber;
    end
end

function the_ring = set_girders(the_ring)
idx = findcells(the_ring,'FamName','bpm'); idx = idx(end);
the_ring = circshift(the_ring,[0,-idx]);

gir = findcells(the_ring,'FamName','girder');

gir_ini = gir(1:2:end);
gir_end = gir(2:2:end);
if isempty(gir), return; end

for ii=1:length(gir_ini)
    indcs = gir_ini(ii):gir_end(ii);
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',indcs,name_girder);
end
the_ring = circshift(the_ring,[0,idx]);
gir = findcells(the_ring,'FamName','girder');
the_ring(gir) = [];

function the_ring = set_num_integ_steps(the_ring)

mags = findcells(the_ring, 'PolynomB');
bends = findcells(the_ring,'BendingAngle');
quad_sext = setdiff(mags,bends);
kicks = findcells(the_ring, 'XGrid');

len_b  = 3e-2;
len_qs = 1.5e-2;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / len_b);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);

quad_sext_len = getcellstruct(the_ring, 'Length', quad_sext);
quad_sext_nis = ceil(quad_sext_len / len_qs);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quad_sext, quad_sext_nis);

the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);

