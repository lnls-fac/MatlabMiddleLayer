function [r, lattice_title] = sirius_si_lattice(varargin)
% r = sirius_si_lattice       : retorna o modelo atual do anel;
%
% r = sirius_si_lattice(mode) : Ateh o momento, pode ser 'AC10'(default) or 'AC20'.
%
% r = sirius_si_lattice(mode,mode_version): mode_version define o ponto de operacao 
%      e a otimizacao sextupolar a ser usada. Exemplos: 'AC10_1', 'AC10_2',
%      'AC10_5'(default)...
%r = sirius_si_lattice(mode,mode_version, energy): energia em eV;
%
% Todos os inputs comutam e podem ser passados independentemente.
%
% 2012-08-28: nova rede. (xrr)
% 2013-08-08: inseri marcadores de IDs de 2 m nos trechos retos. (xrr)
% 2013-08-12: corretoras rapidas e atualizacao das lentas e dos BPMs (desenho CAD da Liu). (xrr)
% 2013-10-02: adicionei o mode_version como parametro de input. (Fernando)
% 2014-09-17: modificacao das corretoras para apenas uma par integrado de CV e CH rapidas e lentas no mesmo elemento. (Natalia) 
% 2014-10-07: atualizados nomes de alguns elementos. (xrr)

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'C';   % a = ac20, b = ac10(beta=4m), c = ac10(beta=1.5m)
version = '03';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V05';
% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i}) && length(varargin{i})==1
        mode = varargin{i};
    elseif ischar(varargin{i})
        version = varargin{i};
    elseif isa(varargin{i},'function_handle')
        strengths = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

lattice_title = [lattice_version '.' mode version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega forcas dos imas de acordo com modo de operacao
strengths();

%% passmethods
%  ===========
bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========

% --- drift spaces ---

id_length = 2.0; % [m]

dia1     = drift('dia1', id_length/2, 'DriftPass');
dia2     = drift('dia',  3.4828500 + 0.00035 - id_length/2, 'DriftPass');
dib1     = drift('dib1', id_length/2, 'DriftPass');
dib2     = drift('dib',  3.0128500 + 0.00035 -0.03 - id_length/2, 'DriftPass');
d10      = drift('d10',  0.100000, 'DriftPass');
d12      = drift('d12',  0.120000, 'DriftPass');
d13      = drift('d13',  0.130000, 'DriftPass');
d14      = drift('d14',  0.140000, 'DriftPass');
d15      = drift('d15',  0.150000, 'DriftPass');
d16      = drift('d16',  0.160000, 'DriftPass');
d17      = drift('d17',  0.170000, 'DriftPass');
d22      = drift('d22',  0.220000, 'DriftPass');
d23      = drift('d23',  0.230000, 'DriftPass');
d24      = drift('d24',  0.240000, 'DriftPass');
d30      = drift('d30',  0.300000, 'DriftPass');
d33      = drift('d33',  0.330000, 'DriftPass');
d44      = drift('d44',  0.440000, 'DriftPass');
d45      = drift('d45',  0.450000, 'DriftPass');
d56      = drift('d56',  0.560000, 'DriftPass');

% --- markers ---
mc       = marker('mc',      'IdentityPass');
mia      = marker('mia',     'IdentityPass');
mib      = marker('mib',     'IdentityPass');
mb1      = marker('mb1',     'IdentityPass');
mb2      = marker('mb2',     'IdentityPass');
mb3      = marker('mb3',     'IdentityPass');
inicio   = marker('inicio',  'IdentityPass');
fim      = marker('fim',     'IdentityPass');
mida     = marker('id_enda', 'IdentityPass');
midb     = marker('id_endb', 'IdentityPass');
girder   = marker('girder',  'IdentityPass');

% --- beam position monitors ---
mon      = marker('bpm', 'IdentityPass');

% --- quadrupoles ---
qfa      = quadrupole('qfa',  0.200000, qfa_strength,  quad_pass_method);
qda      = quadrupole('qda',  0.200000, qda_strength, quad_pass_method);
qdb2     = quadrupole('qdb2', 0.200000, qdb2_strength, quad_pass_method);
qfb      = quadrupole('qfb',  0.250000, qfb_strength,  quad_pass_method);
qdb1     = quadrupole('qdb1', 0.200000, qdb1_strength, quad_pass_method);
qf1      = quadrupole('qf1',  0.200000, qf1_strength,  quad_pass_method);
qf2      = quadrupole('qf2',  0.200000, qf2_strength,  quad_pass_method);
qf3      = quadrupole('qf3',  0.200000, qf3_strength,  quad_pass_method);
qf4      = quadrupole('qf4',  0.200000, qf4_strength,  quad_pass_method);

% --- bending magnets --- 
deg_2_rad = (pi/180);


dip_ang_b3 = 1.4143 * deg_2_rad;
dip_K      =  -0.78;
dip_S   =  0.00;

% -- b1 --
dip_nam =  'b1';
dip_len =  0.828;
dip_ang_b1 =  2.7553 * deg_2_rad;
h1      =  rbend_sirius(dip_nam, dip_len/2, dip_ang_b1/2, dip_ang_b3/2, 0, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
h2      =  rbend_sirius(dip_nam, dip_len/2, dip_ang_b1/2, 0, dip_ang_b3/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
B1      =  [h1 mb1 h2];

% -- b2 --
dip_nam =  'b2';
dip_len =  1.231;
dip_ang_b2 =  4.0964 * deg_2_rad;
h1      =  rbend_sirius(dip_nam, dip_len/3, dip_ang_b2/3, dip_ang_b3/2, 0, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
h2      =  rbend_sirius(dip_nam, dip_len/3, dip_ang_b2/3, 0,            0, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
h3      =  rbend_sirius(dip_nam, dip_len/3, dip_ang_b2/3, 0, dip_ang_b3/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
B2      =  [h1 mb2 h2 h3];

% -- b3 --
dip_nam =  'b3';
dip_len =  0.425;
dip_ang =  1.4143 * deg_2_rad;
h1      =  rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
h2      =  rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
B3      =  [h1 mb3 h2];

% -- bc --
dip_nam =  'bc';
dip_len =  0.125394;
dip_ang =  1.468 * deg_2_rad;
dip_K   =  0.00;
dip_S   = -21.4;
bce     =  rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bcs     =  rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
BC      =  [bce mc bcs];


% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');
crhv   = corrector('crhv', 0, [0,0], 'CorrectorPass');

% --- sextupoles ---    
sda     = sextupole('sda',  0.150000, sda_strength,  sext_pass_method);
sfa     = sextupole('sfa',  0.150000, sfa_strength,  sext_pass_method);
sdb     = sextupole('sdb',  0.150000, sdb_strength,  sext_pass_method);
sfb     = sextupole('sfb',  0.150000, sfb_strength,  sext_pass_method);

sd1    = sextupole('sd1', 0.150000, sd1_strength, sext_pass_method);
sf1    = sextupole('sf1', 0.150000, sf1_strength, sext_pass_method);
sd2    = sextupole('sd2', 0.150000, sd2_strength, sext_pass_method);
sd3    = sextupole('sd3', 0.150000, sd3_strength, sext_pass_method);
sf2    = sextupole('sf2', 0.150000, sf2_strength, sext_pass_method);

sd6     = sextupole('sd6', 0.150000, sd6_strength, sext_pass_method);
sf4     = sextupole('sf4', 0.150000, sf4_strength, sext_pass_method);
sd5     = sextupole('sd5', 0.150000, sd5_strength, sext_pass_method);
sd4     = sextupole('sd4', 0.150000, sd4_strength, sext_pass_method);
sf3     = sextupole('sf3', 0.150000, sf3_strength, sext_pass_method);
        
% --- rf cavity ---
cav = rfcavity('cav', 0, 2.5e6, 500e6, harmonic_number, 'CavityPass');


% --- injection Section ---
dchinj   = drift('dchinj',   3.1428500 + 0.00035, 'DriftPass');
dinjmia  = drift('dinjmia',  0.34, 'DriftPass');
dmiakick = drift('dmiakick', 1.95000 + 0.00035, 'DriftPass');
dkickpmm = drift('dkickpmm', 0.8070, 'DriftPass');
dpmmch   = drift('dpmmch',   0.7258500, 'DriftPass');
kick     = marker('kick','IdentityPass');
pmm      = marker('pmm','IdentityPass');




%% LINES

tm1a = [girder, d17, sda, d14, qda, d23, qfa, d13, mon, d13, sfa, d12, crhv, cv, ch, girder];              % high beta xxM1 girder
tm2a = fliplr(tm1a);                                                                                                 % high beta xxM2 girder
tida = [dia2, mida, dia1, mia, dia1, mida, dia2];                                                                    % high beta ID straight section
tcav = [dia2, dia1, mia, cav, dia1, dia2];                                                                           % high beta RF cavity straight section 
tinj = [dchinj, dinjmia, fim, inicio, mia, dmiakick, kick, dkickpmm, pmm, dpmmch];                                   % high beta INJ straight section
tm1b = [girder, d17, sdb, d14, qdb1, d24, qfb, d13, mon, d17, sfb, d17, crhv, cv, ch, d15, qdb2, girder];  % low beta xxM1 girder
tm2b = fliplr(tm1b);                                                                                                 % low beta xxM2 girder
tidb = [dib2, midb, dib1, mib, dib1, midb, dib2];                                                                    % low beta ID straight section

tc3  = [d13, BC, d13]; % arc sector between B3-B3 (including BC dipole)
tc1a = [girder, d45, ch, cv, d16, sd1, d17, qf1, d13, mon, d13, sf1, d23, qf2, d17, sd2, d12, ch, d10, mon, d12, girder]; % arc sector in between B1-B2
tc2a = [girder, d30, cv, d16, sd3, d17, qf3, d13, mon, d13, sf2, d23, qf4, d17, ch, crhv, d44, mon, d12, girder];              % arc sector in between B2-B3
tc4a = [girder, d56, ch, d17, qf4, d23, sf3, d13, mon, d13, qf3, d17, sd4, d16, cv, crhv, d30, girder];                        % arc sector in between B3-B2
tc5a = [girder, d22, ch, d12, sd5, d17, qf2, d23, sf4, d13, mon, d13, qf1, d17, sd6, d16, ch, cv, d33, mon, d12, girder]; % arc sector in between B2-B1

tc1b = [girder, d45, ch, cv, d16, sd6, d17, qf1, d13, mon, d13, sf4, d23, qf2, d17, sd5, d12, ch, d10, mon, d12, girder]; % arc sector in between B1-B2
tc2b = [girder, d30, cv, d16, sd4, d17, qf3, d13, mon, d13, sf3, d23, qf4, d17, ch, crhv, d44, mon, d12, girder];              % arc sector in between B2-B3
tc4b = [girder, d56, ch, d17, qf4, d23, sf2, d13, mon, d13, qf3, d17, sd3, d16, cv, crhv, d30, girder];                        % arc sector in between B3-B2
tc5b = [girder, d22, ch, d12, sd2, d17, qf2, d23, sf1, d13, mon, d13, qf1, d17, sd1, d16, ch, cv, d33, mon, d12, girder]; % arc sector in between B2-B1

%% GIRDERS

% straight sections
G01S = tinj; G02S = tidb;
G03S = tcav; G04S = tidb;
G05S = tida; G06S = tidb;
G07S = tida; G08S = tidb;
G09S = tida; G10S = tidb;
G11S = tida; G12S = tidb;
G13S = tida; G14S = tidb;
G15S = tida; G16S = tidb;
G17S = tida; G18S = tidb;
G19S = tida; G20S = tidb;

% down and upstream straight sections
G01M1 = tm1a; G01M2 = tm2a; G02M1 = tm1b; G02M2 = tm2b;
G03M1 = tm1a; G03M2 = tm2a; G04M1 = tm1b; G04M2 = tm2b;
G05M1 = tm1a; G05M2 = tm2a; G06M1 = tm1b; G06M2 = tm2b;
G07M1 = tm1a; G07M2 = tm2a; G08M1 = tm1b; G08M2 = tm2b;
G09M1 = tm1a; G09M2 = tm2a; G10M1 = tm1b; G10M2 = tm2b;
G11M1 = tm1a; G11M2 = tm2a; G12M1 = tm1b; G12M2 = tm2b;
G13M1 = tm1a; G13M2 = tm2a; G14M1 = tm1b; G14M2 = tm2b;
G15M1 = tm1a; G15M2 = tm2a; G16M1 = tm1b; G16M2 = tm2b;
G17M1 = tm1a; G17M2 = tm2a; G18M1 = tm1b; G18M2 = tm2b;
G19M1 = tm1a; G19M2 = tm2a; G20M1 = tm1b; G20M2 = tm2b;

% dispersive arcs
G01C1 = tc1a; G01C2 = tc2a; G01C3 = tc3; G01C4 = tc4a; G01C5 = tc5a;
G02C1 = tc1b; G02C2 = tc2b; G02C3 = tc3; G02C4 = tc4b; G02C5 = tc5b;
G03C1 = tc1a; G03C2 = tc2a; G03C3 = tc3; G03C4 = tc4a; G03C5 = tc5a;
G04C1 = tc1b; G04C2 = tc2b; G04C3 = tc3; G04C4 = tc4b; G04C5 = tc5b;
G05C1 = tc1a; G05C2 = tc2a; G05C3 = tc3; G05C4 = tc4a; G05C5 = tc5a;
G06C1 = tc1b; G06C2 = tc2b; G06C3 = tc3; G06C4 = tc4b; G06C5 = tc5b;
G07C1 = tc1a; G07C2 = tc2a; G07C3 = tc3; G07C4 = tc4a; G07C5 = tc5a;
G08C1 = tc1b; G08C2 = tc2b; G08C3 = tc3; G08C4 = tc4b; G08C5 = tc5b;
G09C1 = tc1a; G09C2 = tc2a; G09C3 = tc3; G09C4 = tc4a; G09C5 = tc5a;
G10C1 = tc1b; G10C2 = tc2b; G10C3 = tc3; G10C4 = tc4b; G10C5 = tc5b;
G11C1 = tc1a; G11C2 = tc2a; G11C3 = tc3; G11C4 = tc4a; G11C5 = tc5a;
G12C1 = tc1b; G12C2 = tc2b; G12C3 = tc3; G12C4 = tc4b; G12C5 = tc5b;
G13C1 = tc1a; G13C2 = tc2a; G13C3 = tc3; G13C4 = tc4a; G13C5 = tc5a;
G14C1 = tc1b; G14C2 = tc2b; G14C3 = tc3; G14C4 = tc4b; G14C5 = tc5b;
G15C1 = tc1a; G15C2 = tc2a; G15C3 = tc3; G15C4 = tc4a; G15C5 = tc5a;
G16C1 = tc1b; G16C2 = tc2b; G16C3 = tc3; G16C4 = tc4b; G16C5 = tc5b;
G17C1 = tc1a; G17C2 = tc2a; G17C3 = tc3; G17C4 = tc4a; G17C5 = tc5a;
G18C1 = tc1b; G18C2 = tc2b; G18C3 = tc3; G18C4 = tc4b; G18C5 = tc5b;
G19C1 = tc1a; G19C2 = tc2a; G19C3 = tc3; G19C4 = tc4a; G19C5 = tc5a;
G20C1 = tc1b; G20C2 = tc2b; G20C3 = tc3; G20C4 = tc4b; G20C5 = tc5b;


%% SECTORS # 01..20

S01 = [G01M1, G01S, G01M2, B1, G01C1, B2, G01C2, B3, G01C3, B3, G01C4, B2, G01C5, B1];
S02 = [G02M1, G02S, G02M2, B1, G02C1, B2, G02C2, B3, G02C3, B3, G02C4, B2, G02C5, B1];
S03 = [G03M1, G03S, G03M2, B1, G03C1, B2, G03C2, B3, G03C3, B3, G03C4, B2, G03C5, B1];
S04 = [G04M1, G04S, G04M2, B1, G04C1, B2, G04C2, B3, G04C3, B3, G04C4, B2, G04C5, B1];
S05 = [G05M1, G05S, G05M2, B1, G05C1, B2, G05C2, B3, G05C3, B3, G05C4, B2, G05C5, B1];
S06 = [G06M1, G06S, G06M2, B1, G06C1, B2, G06C2, B3, G06C3, B3, G06C4, B2, G06C5, B1];
S07 = [G07M1, G07S, G07M2, B1, G07C1, B2, G07C2, B3, G07C3, B3, G07C4, B2, G07C5, B1];
S08 = [G08M1, G08S, G08M2, B1, G08C1, B2, G08C2, B3, G08C3, B3, G08C4, B2, G08C5, B1];
S09 = [G09M1, G09S, G09M2, B1, G09C1, B2, G09C2, B3, G09C3, B3, G09C4, B2, G09C5, B1];
S10 = [G10M1, G10S, G10M2, B1, G10C1, B2, G10C2, B3, G10C3, B3, G10C4, B2, G10C5, B1];
S11 = [G11M1, G11S, G11M2, B1, G11C1, B2, G11C2, B3, G11C3, B3, G11C4, B2, G11C5, B1];
S12 = [G12M1, G12S, G12M2, B1, G12C1, B2, G12C2, B3, G12C3, B3, G12C4, B2, G12C5, B1];
S13 = [G13M1, G13S, G13M2, B1, G13C1, B2, G13C2, B3, G13C3, B3, G13C4, B2, G13C5, B1];
S14 = [G14M1, G14S, G14M2, B1, G14C1, B2, G14C2, B3, G14C3, B3, G14C4, B2, G14C5, B1];
S15 = [G15M1, G15S, G15M2, B1, G15C1, B2, G15C2, B3, G15C3, B3, G15C4, B2, G15C5, B1];
S16 = [G16M1, G16S, G16M2, B1, G16C1, B2, G16C2, B3, G16C3, B3, G16C4, B2, G16C5, B1];
S17 = [G17M1, G17S, G17M2, B1, G17C1, B2, G17C2, B3, G17C3, B3, G17C4, B2, G17C5, B1];
S18 = [G18M1, G18S, G18M2, B1, G18C1, B2, G18C2, B3, G18C3, B3, G18C4, B2, G18C5, B1];
S19 = [G19M1, G19S, G19M2, B1, G19C1, B2, G19C2, B3, G19C3, B3, G19C4, B2, G19C5, B1];
S20 = [G20M1, G20S, G20M2, B1, G20C1, B2, G20C2, B3, G20C3, B3, G20C4, B2, G20C5, B1];


%% THERING

anel = [S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20];
elist = anel;


%% finalization 

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'inicio');
THERING = [THERING(idx:end) THERING(1:idx-1)];

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'cav');
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

r = THERING;


function the_ring = set_girders(the_ring)

gir = findcells(the_ring,'FamName','girder');

if isempty(gir), return; end

for ii=1:length(gir)-1
    idx = gir(ii):gir(ii+1)-1;
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
idx = [1:gir(1)-1 gir(end):length(the_ring)];
name_girder = sprintf('%03d',ii+1);
the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);

function the_ring = set_num_integ_steps(the_ring0)

the_ring = the_ring0;

bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(findcells(the_ring, 'K'), bends);
sexts = setdiff(findcells(the_ring, 'PolynomB'), [bends quads]);
kicks = findcells(the_ring, 'XGrid');

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
