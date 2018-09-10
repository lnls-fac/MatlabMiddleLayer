function [the_ring, lattice_title] = sirius_bo_lattice(varargin)
%
% 2012-08-15 maquina com simetria 50, formada por dipolos e quadrupolos com sextupolos integrados - Fernando
% 2014-04-10 modelo segmentado dos dipolos, mudança de padrao para baixa energia.
% 2015-09-03 novo modelo QD: Leff = 100.74 mm - Ximenes.
% 2015-09-08 novo modelo QF: Leff = 227.46 mm - Ximenes.
% 2015-09-14 novos modelos de corretoras com Leff = 150.18 mm - Ximenes.
% 2015-11-04 modelos com comprimentos multiplos de mil??metros - Ximenes.
% 2015-11-04 segmented model of B corrected (last element had 5 mm, instead of 50 mm)
% 2016-10-14 skew quadrupole QS added at sector 02U to introduce coupling up to 5%
% 2016-11-23 dipole magnet model updated (model09)
% 2016-11-29 quadrupole QF model updated (model06)
% 2018-08-15 adding dipole models based on hallprobe measurements - Ximenes

%%% HEADER SECTION %%%

global THERING

energy = 0.15e9; % eV

lattice_version = 'BO.V05.03';
for i=1:length(varargin)
	energy = varargin{i} * 1e9;
end
mode = 'M';
version = '0';

harmonic_number = 828;
rf_voltage = sirius_bo_rf_voltage(energy);

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

% --- segmented dipole model ---

% b_len_hdedge   = 1.152; % [m]
% [B, b_len_seg] = sirius_bo_b_segmented_model(energy, 'B', bend_pass_method);
% lenDif         = (b_len_seg - b_len_hdedge)/2.0;

[B, ~] = sirius_bo_b_segmented_model(energy, 'B', bend_pass_method);


% --- drifts ---

L008100 = drift('l008100', 0.08100, 'DriftPass');
L008800 = drift('l008800', 0.08800, 'DriftPass');
L010350 = drift('l010350', 0.10350, 'DriftPass');
L010600 = drift('l010600', 0.10600, 'DriftPass');
L013350 = drift('l013350', 0.13350, 'DriftPass');
L013600 = drift('l013600', 0.13600, 'DriftPass');
L016100 = drift('l016100', 0.16100, 'DriftPass');
L016750 = drift('l016750', 0.16750, 'DriftPass');
L018860 = drift('l018860', 0.18860, 'DriftPass');
L027250 = drift('l027250', 0.27250, 'DriftPass');
L035000 = drift('l035000', 0.35000, 'DriftPass');
L038600 = drift('l038600', 0.38600, 'DriftPass');
L045000 = drift('l045000', 0.45000, 'DriftPass');
L053572 = drift('l053572', 0.53572, 'DriftPass');
L062000 = drift('l062000', 0.62000, 'DriftPass');
L069811 = drift('l069811', 0.69811, 'DriftPass');
L072500 = drift('l072500', 0.72500, 'DriftPass');
L109600 = drift('l109600', 1.09600, 'DriftPass');
L115740 = drift('l115740', 1.15740, 'DriftPass');
L130389 = drift('l130389', 1.30389, 'DriftPass');
L134600 = drift('l134600', 1.34600, 'DriftPass');
L137100 = drift('l137100', 1.37100, 'DriftPass');
L144600 = drift('l144600', 1.44600, 'DriftPass');
L151200 = drift('l151200', 1.51200, 'DriftPass');
L159628 = drift('l159628', 1.59628, 'DriftPass');
L165200 = drift('l165200', 1.65200, 'DriftPass');
L168300 = drift('l168300', 1.68300, 'DriftPass');
L172600 = drift('l172600', 1.72600, 'DriftPass');
L177100 = drift('l177100', 1.77100, 'DriftPass');
L179350 = drift('l179350', 1.79350, 'DriftPass');
L179600 = drift('l179600', 1.79600, 'DriftPass');
L182100 = drift('l182100', 1.82100, 'DriftPass');
L189350 = drift('l189350', 1.89350, 'DriftPass');
L200200 = drift('l200200', 2.00200, 'DriftPass');
L213200 = drift('l213200', 2.13200, 'DriftPass');

% --- markers ---

STR  = marker('start',    'IdentityPass'); % start of the model
FIM  = marker('end',      'IdentityPass'); % end of the model
GIR  = marker('girder',   'IdentityPass');

SIN  = marker('InjSept',  'IdentityPass'); % end of BO injection septum at TB transport line
SEX  = marker('EjeSeptF', 'IdentityPass'); % start of BO ejection thin septum at TS transport line

DCCT     = marker('DCCT',     'IdentityPass');
BPM      = marker('BPM',      'IdentityPass');
Scrn     = marker('Scrn',     'IdentityPass');
GSL      = marker('GSL',      'IdentityPass');
TunePkup = marker('TunePkup', 'IdentityPass');
TuneShkr = marker('TuneShkr', 'IdentityPass');


% --- lattice elements ---

KIN  = quadrupole('InjKckr', 0.400, 0.0, quad_pass_method);
KEX  = quadrupole('EjeKckr', 0.400, 0.0, quad_pass_method);
CH   = sextupole ('CH',      0.150, 0.0, sext_pass_method);
CV   = sextupole ('CV',      0.150, 0.0, sext_pass_method);

SF  = sirius_bo_sx_segmented_model(energy, 'SF', sext_pass_method, sf_strength * 0.105);
SD  = sirius_bo_sx_segmented_model(energy, 'SD', sext_pass_method, sd_strength * 0.105);
QD  = sirius_bo_qd_segmented_model(energy, 'QD', quad_pass_method, qd_strength * 0.100);
QF  = sirius_bo_qf_segmented_model(energy, 'QF', quad_pass_method, qf_strength * 0.228);
QS  = sirius_bo_qs_segmented_model(energy, 'QS', quad_pass_method, qs_strength * 0.100);

QF0 = [QF(1), FIM, STR, QF(2:end)]; % inserts markers inside QF model
RFC = rfcavity('P5Cav', 0, rf_voltage, 0, harmonic_number, 'CavityPass'); % RF frequency will be set later.


% --- lines ---

US_SF      = [GIR, L200200, BPM, L189350, GIR, SF, L013350];
US_CS      = [L010350, SD, L027250, CV, GIR, L137100, BPM, L182100, GIR, CH, L016100];
US_CC      = [L008100, CV, GIR, L177100, BPM, L182100, GIR, CH, L016100];
US_SS      = [L010350, SD, GIR, L179350, BPM, L189350, GIR, SF, L013350];
US_SF_Scrn = [GIR, L200200, BPM, L172600, GIR, Scrn, L016750, SF, L013350];
US_SE      = [L008100, CV, GIR, L168300, SEX, L008800, L159628, BPM, L053572, GIR];
US_SI      = [L008100, CV, GIR, L177100, BPM, L109600, SIN, L072500, GIR, CH, L016100];
US_SF_GSL  = [GIR, L165200, GSL, L035000, BPM, L189350, GIR, SF, L013350];
DS         = [GIR, L213200, L200200, GIR];
DS_QD      = [GIR, L213200, L179600, GIR, QD, L010600];
DS_RF      = [GIR, L213200, RFC, L200200, GIR];
DS_KE      = [GIR, L038600, KEX, L134600, L179600, GIR, QD, L010600];
DS_CH      = [L016100, CH, GIR, L182100, L200200, GIR];
DS_KI      = [GIR, L038600, KIN, L018860, Scrn, L115740, L130389, Scrn, L069811, GIR];
DS_QS_TuS  = [L013600, QS, GIR, L144600, TuneShkr, L045000, L179600, GIR, QD, L010600];
DS_DCCT    = [GIR, L213200,  DCCT, L200200, GIR];
DS_QD_TuP  = [GIR, L151200, TunePkup, L062000, L179600, GIR, QD, L010600];


% -- upstream and downstream subsectors

US_01 = US_SI;        DS_01 = DS_KI;        S01 = [US_01, QF0,DS_01, B];
US_02 = US_SF_Scrn;   DS_02 = DS_QS_TuS;    S02 = [US_02, QF, DS_02, B];
US_03 = US_CS;        DS_03 = DS;           S03 = [US_03, QF, DS_03, B];
US_04 = US_SF_GSL;    DS_04 = DS_QD_TuP;    S04 = [US_04, QF, DS_04, B];
US_05 = US_CC;        DS_05 = DS_RF;        S05 = [US_05, QF, DS_05, B];
US_06 = US_SF;        DS_06 = DS_QD;        S06 = [US_06, QF, DS_06, B];
US_07 = US_CC;        DS_07 = DS;           S07 = [US_07, QF, DS_07, B];
US_08 = US_SS;        DS_08 = DS_QD;        S08 = [US_08, QF, DS_08, B];
US_09 = US_CC;        DS_09 = DS;           S09 = [US_09, QF, DS_09, B];
US_10 = US_SF;        DS_10 = DS_QD;        S10 = [US_10, QF, DS_10, B];
US_11 = US_CC;        DS_11 = DS;           S11 = [US_11, QF, DS_11, B];
US_12 = US_SF;        DS_12 = DS_QD;        S12 = [US_12, QF, DS_12, B];
US_13 = US_CS;        DS_13 = DS;           S13 = [US_13, QF, DS_13, B];
US_14 = US_SF;        DS_14 = DS_QD;        S14 = [US_14, QF, DS_14, B];
US_15 = US_CC;        DS_15 = DS;           S15 = [US_15, QF, DS_15, B];
US_16 = US_SF;        DS_16 = DS_QD;        S16 = [US_16, QF, DS_16, B];
US_17 = US_CC;        DS_17 = DS;           S17 = [US_17, QF, DS_17, B];
US_18 = US_SS;        DS_18 = DS_QD;        S18 = [US_18, QF, DS_18, B];
US_19 = US_CC;        DS_19 = DS;           S19 = [US_19, QF, DS_19, B];
US_20 = US_SF;        DS_20 = DS_QD;        S20 = [US_20, QF, DS_20, B];
US_21 = US_CC;        DS_21 = DS;           S21 = [US_21, QF, DS_21, B];
US_22 = US_SF;        DS_22 = DS_QD;        S22 = [US_22, QF, DS_22, B];
US_23 = US_CS;        DS_23 = DS;           S23 = [US_23, QF, DS_23, B];
US_24 = US_SF;        DS_24 = DS_QD;        S24 = [US_24, QF, DS_24, B];
US_25 = US_CC;        DS_25 = DS;           S25 = [US_25, QF, DS_25, B];
US_26 = US_SF;        DS_26 = DS_QD;        S26 = [US_26, QF, DS_26, B];
US_27 = US_CC;        DS_27 = DS;           S27 = [US_27, QF, DS_27, B];
US_28 = US_SS;        DS_28 = DS_QD;        S28 = [US_28, QF, DS_28, B];
US_29 = US_CC;        DS_29 = DS;           S29 = [US_29, QF, DS_29, B];
US_30 = US_SF;        DS_30 = DS_QD;        S30 = [US_30, QF, DS_30, B];
US_31 = US_CC;        DS_31 = DS;           S31 = [US_31, QF, DS_31, B];
US_32 = US_SF;        DS_32 = DS_QD;        S32 = [US_32, QF, DS_32, B];
US_33 = US_CS;        DS_33 = DS;           S33 = [US_33, QF, DS_33, B];
US_34 = US_SF;        DS_34 = DS_QD;        S34 = [US_34, QF, DS_34, B];
US_35 = US_CC;        DS_35 = DS_DCCT;      S35 = [US_35, QF, DS_35, B];
US_36 = US_SF;        DS_36 = DS_QD;        S36 = [US_36, QF, DS_36, B];
US_37 = US_CC;        DS_37 = DS;           S37 = [US_37, QF, DS_37, B];
US_38 = US_SS;        DS_38 = DS_QD;        S38 = [US_38, QF, DS_38, B];
US_39 = US_CC;        DS_39 = DS;           S39 = [US_39, QF, DS_39, B];
US_40 = US_SF;        DS_40 = DS_QD;        S40 = [US_40, QF, DS_40, B];
US_41 = US_CC;        DS_41 = DS;           S41 = [US_41, QF, DS_41, B];
US_42 = US_SF;        DS_42 = DS_QD;        S42 = [US_42, QF, DS_42, B];
US_43 = US_CS;        DS_43 = DS;           S43 = [US_43, QF, DS_43, B];
US_44 = US_SF;        DS_44 = DS_QD;        S44 = [US_44, QF, DS_44, B];
US_45 = US_CC;        DS_45 = DS;           S45 = [US_45, QF, DS_45, B];
US_46 = US_SF;        DS_46 = DS_QD;        S46 = [US_46, QF, DS_46, B];
US_47 = US_CC;        DS_47 = DS;           S47 = [US_47, QF, DS_47, B];
US_48 = US_SS;        DS_48 = DS_KE;        S48 = [US_48, QF, DS_48, B];
US_49 = US_SE;        DS_49 = DS_CH;        S49 = [US_49, QF, DS_49, B];
US_50 = US_SF;        DS_50 = DS_QD;        S50 = [US_50, QF, DS_50, B];


% --- complete ring ---

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
fprintf('   Circumference: %.5f m\n', L0_tot);

%rev_freq     = beta * const.c / L0_tot;
rev_freq     = const.c / L0_tot;
rf_idx       = findcells(THERING, 'FamName', 'P5Cav');
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

% use models built from measurement data
THERING = sirius_bo_models_from_measurements(THERING);

the_ring = THERING;


function the_ring = set_vacuum_chamber(the_ring)

% y = +/- y_lim * sqrt(1 - (x/x_lim)^n);

bends_vchamber =      [0.0117 0.0117 1];   % n = 100: ~rectangular
other_vchamber =      [0.018  0.018  1];   % n = 1;   circular/eliptica
extraction_vchamber = [0.026  0.018  1];   % n = 1;   circular/eliptica


% default
for i=1:length(the_ring)
    the_ring{i}.VChamber = other_vchamber;
end

% bends
b = [findcells(the_ring, 'FamName', 'B') findcells(the_ring, 'FamName', 'mB')];
for i=b
    the_ring{i}.VChamber = bends_vchamber;
end

% ejection bend
EjeKckr = findcells(the_ring, 'FamName', 'EjeKckr');
sept_ex = findcells(the_ring, 'FamName', 'EjeSeptF');
b_ex = b((b > EjeKckr(end)) & (b < sept_ex(1)));
for i=b_ex
    the_ring{i}.VChamber = other_vchamber;
end


% sector from extraction bend to extraction septum
for i=b_ex(end):sept_ex(1)
    the_ring{i}.VChamber = extraction_vchamber;
end


function the_ring = set_girders(the_ring)
idx = findcells(the_ring,'FamName','BPM'); idx = idx(end);
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
