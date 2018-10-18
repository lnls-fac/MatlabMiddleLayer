function [r, lattice_title, IniCond] = sirius_tb_lattice(varargin)
% 2013-08-19 created  Fernando.
% 2013-12-02 V200 - from OPA (Ximenes)
% 2014-10-20 V300 - new version (Liu)
% 2015-08-26 V01 - new version (Liu)
% 2016-09-28 V01.02 - new version (Ximenes)
% 2017-08-25 V02.01 - new dipole model 02 (Ximenes) - see 'VERSIONS.txt' in Release/machine/SIRIUS
% 2018-10-02 V03.01 - Updated number and positions of corretors, screens, bpms and other diagnostics elements according to AutoCad drawing (Liu)
%
%
% Beta plot:
%
% [ring, ~, tw0] = sirius_tb_lattice();
% global THERING;
% TD = twissline(ring,0,tw0,1:length(ring)+1);
% BETA = cat(1,TD.beta);
% S = cat(1,TD.SPos);
% figure; plot(S,BETA(:,1))
% figure; plot(S,BETA(:,2))

%% global parameters
%  =================

% --- system parameters ---
energy = 0.15e9;
lattice_version = 'TB.V03.01';
mode = 'M';
version = '1';
mode_version = [mode version];

% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i})
        mode_version = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

lattice_title = [lattice_version '.' mode_version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);

% carrega forcas dos imas de acordo com modo de operacao
IniCond = struct('ElemIndex',1,'Spos',0,'ClosedOrbit',[0;0;0;0],'mu',[0,0]);
set_parameters_tb;


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========

% --- drift spaces ---
lp2  = drift('lp2',  0.0002, 'DriftPass');
lp3  = drift('lp3',  0.0003, 'DriftPass');
lp4  = drift('lp4',  0.0004, 'DriftPass');
lp5  = drift('lp5',  0.0005, 'DriftPass');
lp6  = drift('lp6',  0.0006, 'DriftPass');
lp7  = drift('lp7',  0.0007, 'DriftPass');

l1   = drift('l1',   0.001,  'DriftPass');
l2   = drift('l2',   0.002,  'DriftPass');
l3   = drift('l3',   0.003,  'DriftPass');
l4   = drift('l4',   0.004,  'DriftPass');
l5   = drift('l5',   0.005,  'DriftPass');
l6   = drift('l6',   0.006,  'DriftPass');
l7   = drift('l7',   0.007,  'DriftPass');
l8   = drift('l8',   0.008,  'DriftPass');
l9   = drift('l9',   0.009,  'DriftPass');
l10  = drift('l10',  0.010,  'DriftPass');
l30  = drift('l30',  0.030,  'DriftPass');
l40  = drift('l40',  0.040,  'DriftPass');
l60  = drift('l60',  0.060,  'DriftPass');
l70  = drift('l70',  0.070,  'DriftPass');
l80  = drift('l80',  0.080,  'DriftPass');
l90  = drift('l90',  0.090,  'DriftPass');
l100 = drift('l100', 0.100,  'DriftPass');
l200 = drift('l200', 0.200,  'DriftPass');

% --- markers ---
inicio   = marker('start', 'IdentityPass');
fim      = marker('end',   'IdentityPass');

% --- slits ---
slith    = marker('SlitH', 'IdentityPass');
slitv    = marker('SlitV', 'IdentityPass');

% --- beam screens ---
scrn     = marker('Scrn',  'IdentityPass');

% --- beam current monitors ---
ict      = marker('ICT',   'IdentityPass');
fct      = marker('FCT',   'IdentityPass');

% --- beam position monitors ---
bpm      = marker('BPM',   'IdentityPass');

% --- correctors ---
chv   = sextupole ('CHV',   0.082, 0.0, sext_pass_method);

% --- quadrupoles ---
qf2L  = quadrupole('QF2L',  0.112, qf2L_strength, quad_pass_method);   % LINAC TRIPLET
qd2L  = quadrupole('QD2L',  0.162, qd2L_strength, quad_pass_method);   % LINAC TRIPLET
qf3L  = quadrupole('QF3L',  0.112, qf3L_strength, quad_pass_method);   % LINAC QUADRUPOLE

qd1   = quadrupole('QD1',   0.100, qd1_strength,  quad_pass_method);
qf1   = quadrupole('QF1',   0.100, qf1_strength,  quad_pass_method);
qd2a  = quadrupole('QD2A',  0.100, qd2a_strength, quad_pass_method);
qf2a  = quadrupole('QF2A',  0.100, qf2a_strength, quad_pass_method);
qf2b  = quadrupole('QF2B',  0.100, qf2b_strength, quad_pass_method);
qd2b  = quadrupole('QD2B',  0.100, qd2b_strength, quad_pass_method);
qf3   = quadrupole('QF3',   0.100, qf3_strength,  quad_pass_method);
qd3   = quadrupole('QD3',   0.100, qd3_strength,  quad_pass_method);
qf4   = quadrupole('QF4',   0.100, qf4_strength,  quad_pass_method);
qd4   = quadrupole('QD4',   0.100, qd4_strength,  quad_pass_method);


% --- bending magnets ---
deg_2_rad = (pi/180);

% -- spec --
ang = 15.0;  % injection mode
dip_nam =  'Spect';
dip_len =  0.45003;
dip_ang =  -ang * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
spech      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0, 0, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
spec   = [spech, spech];

[bp, ~] = sirius_tb_b_segmented_model(energy, 'B', bend_pass_method, +1.0);
[bn, ~] = sirius_tb_b_segmented_model(energy, 'B', bend_pass_method, -1.0);

% -- bo injection septum --
dip_nam =  'InjSept';
dip_len =  0.50;
dip_ang =  21.75 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
septine = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
septins = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bseptin = marker('bInjS','IdentityPass');
eseptin = marker('eInjS','IdentityPass');
septin  = [bseptin, septine, septins,eseptin]; % excluded ch to make it consistent with other codes. the corrector can be implemented in the polynomB.

%% % --- lines ---
s00_1  = [l80, l4, qf2L, l30, l8, qd2L, l30, l8, qf2L, l30, l8, qf3L];
s00_2  = [l80, l7, bpm, l200, l40, l6, ict, l200, l100, l90, l5];
s01_1  = [l200, l200, l200, l80, l4, lp2, scrn, l100, l40, lp2, bpm, l100, l2, lp4];
s01_2  = [l80, l8, lp4, chv, l200, l90, l1, lp2];
s01_3  = [l200, l200, l200, l200, l200, l40, l4, slith, l100, l80, scrn, l100, l40, bpm, l100, l90, l9, chv, l100, l90, l3, lp3, slitv, l200, l10, lp4];
s02_1  = [l100, l90, l4, lp4, ict, l200, l200, l200, l10, l6];
s02_2  = [l200, l70];
s02_3  = [l200, scrn, l100, l40, bpm, l60, l9, chv, repmat(l200,1,26), l100, l70, l3];
s02_4  = [l200, l70];
s02_5  = [l200, scrn, l100, l40, bpm, l60, l8, lp5, chv, l200, l100, l10, l9, lp7];
s03_1  = [repmat(l200,1,10), l100, l90, l9, lp6];
s03_2  = [l200, l6];
s03_3  = [l100, bpm, l100, l40, l4, scrn, l200, l10, lp4];
s04_1  = [l200, l70, l2, lp4, chv, l200, l200, l100, l80, lp5, fct, l100, l40, ict, l200, l100, l5, lp7, bpm, l100, l10, l5, lp6];
s04_2  = [l200, l10, l6];
s04_3  = [l100, l70, scrn, l60, l1, lp2, chv, l80, l6, lp6];

sector00 = [s00_1, s00_2, spec];
sector01 = [s01_1, qd1,  s01_2, qf1,  s01_3, bn];
sector02 = [s02_1, qd2a, s02_2, qf2a, s02_3, qf2b, s02_4, qd2b, s02_5, bp];
sector03 = [s03_1, qf3,  s03_2, qd3,  s03_3, bp];
sector04 = [s04_1, qf4,  s04_2, qd4,  s04_3, septin];

%% TB beamline 
ltlb  = [inicio, sector00, sector01, sector02, sector03, sector04, fim];
elist = ltlb;

%% finalization
the_line = buildlat(elist);
the_line = setcellstruct(the_line, 'Energy', 1:length(the_line), energy);

% shift lattice to start at the marker 'start'
idx = findcells(the_line, 'FamName', 'start');
the_line = [the_line(idx:end) the_line(1:idx-1)];

% checa se ha elementos com comprimentos negativos
lens = getcellstruct(the_line, 'Length', 1:length(the_line));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% Ajusta NumIntSteps
the_line = set_num_integ_steps(the_line);

% Define Camara de Vacuo
the_line = set_vacuum_chamber(the_line);

% use models built from measurement data
the_line = sirius_tb_models_from_measurements(the_line);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
% lnls_preload_passmethods;
r = the_line;


function the_ring = set_vacuum_chamber(the_ring0)

% y = +/- y_lim * (1 - (x/x_lim)^n)^(1/n);
the_ring = the_ring0;

% -- default physical apertures --
for i=1:length(the_ring)
    the_ring{i}.VChamber = [0.018, 0.018, 2];
end

% -- dipoles --
bend = findcells(the_ring, 'FamName', 'B');
for i=bend
    the_ring{i}.VChamber = [0.0117, 0.0117, 2];
end

% -- bo injection septum --
mbeg = findcells(the_ring, 'FamName', 'bInjS');
mend = findcells(the_ring, 'FamName', 'eInjS');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0075, 0.008, 2];
end


function the_ring = set_num_integ_steps(the_ring0)

the_ring = the_ring0;

mags = findcells(the_ring, 'PolynomB');
bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(mags,bends);
chv = findcells(the_ring, 'FamName', 'CHV');
kicks = findcells(the_ring, 'XGrid');

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', chv, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
