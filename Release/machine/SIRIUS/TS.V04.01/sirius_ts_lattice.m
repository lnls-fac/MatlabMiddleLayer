function [r, lattice_title, IniCond] = sirius_ts_lattice(varargin)
% 2013-11-26 created Ximenes (from V100)
% 2016-09-28 V01.02 - new version (Ximenes) - see 'VERSIONS.txt' in Release/machine/SIRIUS

%% global parameters
%  =================

d2r = pi/180;

% --- system parameters ---
energy = 3e9;
lattice_version = 'TS.V04.01';
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
set_parameters_ts;


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========
% --- drift spaces ---
ldif     = 0.1442;
lcv      = 0.150;
l015     = drift('l015',  0.15, 'DriftPass');
l020     = drift('l020',  0.20, 'DriftPass');
l0125    = drift('l0125', 0.20-lcv/2, 'DriftPass');
l025     = drift('l025',  0.25, 'DriftPass');
l0175    = drift('l0175', 0.25-lcv/2, 'DriftPass');
l060     = drift('l060',  0.60, 'DriftPass');
l0525    = drift('l0525', 0.60-lcv/2, 'DriftPass');
l080     = drift('l080',  0.80, 'DriftPass');
l0825    = drift('l0825', 0.90-lcv/2, 'DriftPass');
l160     = drift('l160',  1.60, 'DriftPass');
l280     = drift('l280',  2.80, 'DriftPass');
la2p     = drift('la2p', 0.08323, 'DriftPass');
la3p     = drift('la3p', 0.232-ldif, 'DriftPass');
lb1p     = drift('lb1p', 0.220-ldif, 'DriftPass');
lb2p     = drift('lb2p', 0.83251, 'DriftPass');
lb3p     = drift('lb3p', 0.30049, 'DriftPass');
lb4p     = drift('lb4p', 0.19897-ldif, 'DriftPass');
lc1p     = drift('lc1p', 1.314-ldif, 'DriftPass');
lc2p     = drift('lc2p', 0.07304, 'DriftPass');
lc3p     = drift('lc3p', 0.19934-lcv/2, 'DriftPass');
lc4p     = drift('lc4p', 0.72666-ldif-lcv/2, 'DriftPass');
ld1p     = drift('ld1p', 0.25700 + ldif -ldif, 'DriftPass'); % drift length in the drawing is specified different
ld2p     = drift('ld2p', 0.05428, 'DriftPass');
ld3p     = drift('ld3p', 0.35361-lcv/2, 'DriftPass');
ld4p     = drift('ld4p', 0.192, 'DriftPass');
ld5p     = drift('ld5p', 0.45593, 'DriftPass');
ld6p     = drift('ld6p', 0.48307-lcv/2, 'DriftPass');
ld7p     = drift('ld7p', 0.175-lcv/2, 'DriftPass');

% --- markers ---
start    = marker('start',  'IdentityPass');
fim      = marker('end',    'IdentityPass');

% --- beam screen monitors
scrn   = marker('Scrn', 'IdentityPass');

% --- beam current monitors ---
ict    = marker('ICT', 'IdentityPass');
fct    = marker('FCT', 'IdentityPass');

% --- beam position monitors ---
bpm    = marker('BPM', 'IdentityPass');

% --- correctors ---
% CHs are inside quadrupoles
cv = sextupole('CV', lcv, 0.0, sext_pass_method); % same model as BO correctors

% --- quadrupoles ---

[qf1a, ~] = sirius_ts_q14_segmented_model('QF1A', qf1ah_strength,  quad_pass_method);
[qf1b, ~] = sirius_ts_q14_segmented_model('QF1B', qf1bh_strength,  quad_pass_method);
[qd2, ~]  = sirius_ts_q14_segmented_model('QD2', qd2h_strength,  quad_pass_method);
[qf2, ~]  = sirius_ts_q20_segmented_model('QF2', qf2h_strength,  quad_pass_method);
[qf3, ~]  = sirius_ts_q20_segmented_model('QF3', qf3h_strength,  quad_pass_method);
[qd4a, ~] = sirius_ts_q14_segmented_model('QD4A', qd4ah_strength,  quad_pass_method);
[qf4, ~]  = sirius_ts_q20_segmented_model('QF4', qf4h_strength,  quad_pass_method);
[qd4b, ~] = sirius_ts_q14_segmented_model('QD4B', qd4bh_strength,  quad_pass_method);

% --- bending magnets ---

[bend, ~] = sirius_ts_b_segmented_model(energy, 'B', bend_pass_method);

% -- pulsed magnets --

% thick and thin ejection septa are identical in the point of view of the
% dynamics

% -- bo thin ejection septum --
ejeseptf_strength.kxl = ejeseptf_kxl_strength;
ejeseptf_strength.kyl = ejeseptf_kyl_strength;
ejeseptf_strength.ksxl = ejeseptf_ksxl_strength;
ejeseptf_strength.ksyl = ejeseptf_ksyl_strength;
ejesf = sirius_ts_septa_segmented_model('EjeSeptF', 0.5773, -3.6, ejeseptf_strength, 6);

% -- bo thick ejection septum --
ejeseptg_strength.kxl = ejeseptg_kxl_strength;
ejeseptg_strength.kyl = ejeseptg_kyl_strength;
ejeseptg_strength.ksxl = ejeseptg_ksxl_strength;
ejeseptg_strength.ksyl = ejeseptg_ksyl_strength;
ejesg = sirius_ts_septa_segmented_model('EjeSeptG', 0.5773, -3.6, ejeseptg_strength, 6);

% -- si thick injection septum (2 of these are used) --
injseptg_strength.kxl = injseptg_kxl_strength;
injseptg_strength.kyl = injseptg_kyl_strength;
injseptg_strength.ksxl = injseptg_ksxl_strength;
injseptg_strength.ksyl = injseptg_ksyl_strength;
injsg = sirius_ts_septa_segmented_model('InjSeptG', 0.5773, +3.6, injseptg_strength, 6);

% -- si thin injection septum --
injseptf_strength.kxl = injseptf_kxl_strength;
injseptf_strength.kyl = injseptf_kyl_strength;
injseptf_strength.ksxl = injseptf_ksxl_strength;
injseptf_strength.ksyl = injseptf_ksyl_strength;
injsf = sirius_ts_septa_segmented_model('InjSeptF', 0.5773, +3.118, injseptf_strength, 6);

% --- lines ---
sec01 = [ejesf,l025,ejesg,l0525,cv,l0825,qf1a,la2p,ict,l280,scrn,bpm,...
         l020,l020,qf1b,l0125,cv,l0125,la3p,bend];
sec02 = [l080,lb1p,qd2,lb2p,scrn,bpm,lb3p,qf2,l0125,cv,l0175,l015,lb4p,bend];
sec03 = [lc1p,l280,scrn,bpm,l020,lc2p,qf3,lc3p,cv,lc4p,bend];
sec04 = [ld1p,l060,qd4a,ld2p,l160,bpm,scrn,ld3p,cv,l0125,qf4,ld4p,fct, ...
         ld4p,ict,ld4p,qd4b,ld5p,bpm,scrn,ld6p,cv,ld7p,injsg,l025,injsg,l025,injsf,scrn];

ltba  = [start,sec01,sec02,sec03,sec04,fim];
%% finalization

elist = ltba;
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

% Luana
pb = findcells(the_line, 'PolynomB');
for i=1:length(pb)
    the_line{pb(i)}.NPA = the_line{pb(i)}.PolynomA;
    the_line{pb(i)}.NPB = the_line{pb(i)}.PolynomB;
end

% Ajusta NumIntSteps
the_line = set_num_integ_steps(the_line);

% Define Camara de Vacuo
the_line = set_vacuum_chamber(the_line);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
% lnls_preload_passmethods;


r = the_line;


function the_ring = set_vacuum_chamber(the_ring0)

% y = +/- y_lim * (1 - (x/x_lim)^n)^(1/n);


the_ring = the_ring0;

% -- default physical apertures --
for i=1:length(the_ring)
    the_ring{i}.VChamber = [0.012, 0.012, 2];
end

% -- bo ejection septa --
mbeg = findcells(the_ring, 'FamName', 'bEjeSeptG');
mend = findcells(the_ring, 'FamName', 'eEjeSeptF');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0015, 0.004, 2];
end

% -- si thick injection septum --
mbeg = findcells(the_ring, 'FamName', 'bInjSeptG');
mend = findcells(the_ring, 'FamName', 'eInjSeptG');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0045, 0.0035, 2];
end

% -- si thin injection septum --
mbeg = findcells(the_ring, 'FamName', 'bInjSeptF');
mend = findcells(the_ring, 'FamName', 'eInjSeptF');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0015, 0.0035, 2];
end




function the_ring = set_num_integ_steps(the_ring0)

the_ring = the_ring0;

% bends = findcells(the_ring, 'BendingAngle');
% quads = setdiff(findcells(the_ring, 'K'), bends);
% sexts = setdiff(findcells(the_ring, 'PolynomB'), [bends quads]);
% kicks = findcells(the_ring, 'XGrid');

mags = findcells(the_ring, 'PolynomB');
cv = findcells(the_ring, 'FamName', 'CV');
bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(mags, bends);
quads = setdiff(quads, cv);

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
% the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
% the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
