function r = sirius_si_lattice(varargin)
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
%
%
% 2012-08-28 Nova rede - Ximenes.
% 2013-08-08: inseri marcadores de IDs de 2 m nos trechos retos. (X.R.R.)
% 2013-08-12: corretoras rapidas e atualizacao das lentas e dos BPMs (desenho CAD da Liu). (X.R.R.)
% 2013-10-02: adicionei o mode_version como parametro de input. Fernando.

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'AC10';
mode_version = 'AC10.5';
harmonic_number = 864;

% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i}) && length(varargin{i})==4
        mode = varargin{i};
    elseif ischar(varargin{i})
        mode_version = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

fprintf(['   Loading lattice SIRIUS_V500 - ' mode ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega forcas dos imas de acordo com modo de operacao
if strcmpi(mode, 'AC20')
    set_magnet_strengths_AC20;
elseif strcmpi(mode, 'AC10')
    set_magnet_strengths_AC10;
end


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
%quad_pass_method = 'QuadLinearPass';
sext_pass_method = 'StrMPoleSymplectic4Pass';
mult_pass_method = 'ThinMPolePass';


%% elements
%  ========


% --- drift spaces ---

id_length = 2.0; % [m]

dia      = drift('dia', 3.269200 + 3.65e-3, 'DriftPass');
dia1     = drift('dia', id_length/2, 'DriftPass');
dia2     = drift('dia', 3.26920 + 3.65e-3 - id_length/2, 'DriftPass');
dib      = drift('dib', 2.909200 + 3.65e-3, 'DriftPass');
dib1     = drift('dib', id_length/2, 'DriftPass');
dib2     = drift('dib', 2.909200 + 3.65e-3 - id_length/2, 'DriftPass');
d10      = drift('d10', 0.100000, 'DriftPass');
d11      = drift('d11', 0.110000, 'DriftPass');
d12      = drift('d12', 0.120000, 'DriftPass');
d13      = drift('d13', 0.130000, 'DriftPass');
d15      = drift('d15', 0.150000, 'DriftPass');
d17      = drift('d17', 0.170000, 'DriftPass');
d18      = drift('d18', 0.180000, 'DriftPass');
d20      = drift('d20', 0.200000, 'DriftPass');
d22      = drift('d22', 0.220000, 'DriftPass');
d23      = drift('d23', 0.230000, 'DriftPass');
d26      = drift('d26', 0.260000, 'DriftPass');
d32      = drift('d32', 0.320000, 'DriftPass');
d44      = drift('d44', 0.440000, 'DriftPass');

% --- markers ---
mc       = marker('mc',      'IdentityPass');
mia      = marker('mia',     'IdentityPass');
mib      = marker('mib',     'IdentityPass');
mb1      = marker('mb1',     'IdentityPass');
mb2      = marker('mb2',     'IdentityPass');
mb3      = marker('mb3',     'IdentityPass');
inicio   = marker('inicio',  'IdentityPass');
fim      = marker('fim',     'IdentityPass');
mida     = marker('id_enda',  'IdentityPass');
midb     = marker('id_endb',  'IdentityPass');
%mgirder  = marker('mgirder', 'IdentityPass');

% --- beam position monitors ---
mon      = marker('BPM', 'IdentityPass');

% --- quadrupoles ---
qaf      = quadrupole('qaf',  0.340000, qaf_strength,  quad_pass_method);
qad      = quadrupole('qad',  0.140000, qad_strength,  quad_pass_method);
qbd2     = quadrupole('qbd2', 0.140000, qbd2_strength, quad_pass_method);
qbf      = quadrupole('qbf',  0.340000, qbf_strength,  quad_pass_method);
qbd1     = quadrupole('qbd1', 0.140000, qbd1_strength, quad_pass_method);
qf1      = quadrupole('qf1',  0.250000, qf1_strength,  quad_pass_method);
qf2      = quadrupole('qf2',  0.250000, qf2_strength,  quad_pass_method);
qf3      = quadrupole('qf3',  0.250000, qf3_strength,  quad_pass_method);
qf4      = quadrupole('qf4',  0.250000, qf4_strength,  quad_pass_method);


% --- bending magnets --- 
deg_2_rad = (pi/180);


% -- b1 --
dip_nam =  'b1';
dip_len =  0.828080;
dip_ang =  2.766540 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B1      = [h1 mb1 h2];

% -- b2 --
dip_nam =  'b2';
dip_len =  1.228262;
dip_ang =  4.103510 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);    
B2      = [h1 mb2 h2];

% -- b3 --
dip_nam =  'b3';
dip_len =  0.428011;
dip_ang =  1.429950 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B3      = [h1 mb3 h2];

% -- bc --
dip_nam =  'bc';
dip_len =  0.125394;
dip_ang =  1.4 * deg_2_rad;
dip_K   =  0.00;
dip_S   = -18.93;
bce     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bcs     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
BC      = [bce mc bcs];


% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');
crhv   = corrector('crhv', 0, [0,0], 'CorrectorPass');

% ch     = sextupole('hcm',  0, 1*5e-4, 'ThinMPolePass');  % 2.5% rollof at 10 mm
% cv     = sextupole('vcm',  0, 1*5e-4, 'ThinMPolePass');

%IDm = multipole('IDsmulti', 0, [0 0 0 0], [0 0 0 0], 'ThinMPolePass'); 

% --- sextupoles ---    
sa1      = sextupole('sa1', 0.150000, sa1_strength, sext_pass_method);
sa2      = sextupole('sa2', 0.150000, sa2_strength, sext_pass_method);
sb1      = sextupole('sb1', 0.150000, sb1_strength, sext_pass_method);
sb2      = sextupole('sb2', 0.150000, sb2_strength, sext_pass_method);
sd1      = sextupole('sd1', 0.150000, sd1_strength, sext_pass_method);
sf1      = sextupole('sf1', 0.150000, sf1_strength, sext_pass_method);
sd2      = sextupole('sd2', 0.150000, sd2_strength, sext_pass_method);
sd3      = sextupole('sd3', 0.150000, sd3_strength, sext_pass_method);
sf2      = sextupole('sf2', 0.150000, sf2_strength, sext_pass_method);
           
% --- rf cavity ---
cav = rfcavity('cav', 0, 2.5e6, 500e6, harmonic_number, 'CavityPass');

%% lines 

insa   = [ dia1, mida, dia2, crhv, cv, d12, ch, d12, sa2, d12, mon, d12, qaf, d23, qad, d17, sa1, d17];
insb   = [ dib1, midb, dib2, d10, crhv, qbd2, d12, cv, d12, ch, d12, sb2, d12, mon, d12, qbf, d23, qbd1, d17, sb1, d17];

cline1 = [ d32, cv,  d12, ch,  d15, sd1, d17, qf1, d12, mon, d11, sf1, d20, qf2, d17, sd2, d12, ch, d10, mon, d10];
cline2 = [ d18, cv,  d26, sd3, d17, qf3, d12, mon, d11, sf2, d20, qf4, d15, ch,  crhv, d12, mon, d44];
cline3 = [ d44, mon, d12, ch,  d15, qf4, d20, sf2, d11, mon, d12, qf3, d17, sd3, d26, cv, crhv, d18];
cline4 = [ d20, ch,  d12, sd2, d17, qf2, d20, sf1, d11, mon, d12, qf1, d17, sd1, d15, ch,  d12, cv, d22, mon, d10];

%% Injection Section
dmiainj  = drift('dmiainj', 0.3, 'DriftPass');
dinjk3   = drift('dinjk3' , 0.3, 'DriftPass');
dk3k4    = drift('dk3k4'  , 0.6, 'DriftPass');
dk4pmm   = drift('dk4pmm' , 0.2, 'DriftPass');
dpmmcv   = drift('dpmmcv' , (3.2692 + 3.65e-3 - 0.3 - 0.3 - 0.6 - 0.2 - 3*0.6), 'DriftPass');
dcvk1    = drift('dcvk1'  ,(3.2692 + 3.65e-3 - 0.6 - 1.4 - 2*0.6), 'DriftPass');
dk1k2    = drift('dk1k2'  , 0.6, 'DriftPass');
sef      = sextupole('sef', 0.6, 0.0, sext_pass_method); %corrector('sef', 0.6, [0 0], 'CorrectorPass');
dk2sef   = drift('dk2mia' , 0.8, 'DriftPass');

kick     = corrector('kick',0.6, [0 0], 'CorrectorPass');
pmm      = sextupole('pmm', 0.6, 0.0, sext_pass_method);
inj = marker('inj','IdentityPass');

insaend  = [cv, d12, ch, d12, sa2, d12, mon, d12, qaf, d23, qad, d17, sa1, d17];
insainj  = [dmiainj, inj, dinjk3, kick, dk3k4, kick, dk4pmm, pmm, dpmmcv, insaend];
injinsa  = [fliplr(insaend), dcvk1, kick, dk1k2, kick, dk2sef, sef];



B3BCB3 = [ B3, d13, BC, d13, B3];     


%% the_ring

% Lattice Ordering
% ----------------
% 
% R01 C01 R02 C02 R03 C03 R04 C04 R05 C05 R06 C06 R07 C07 R08 C08 R09 C09 R10 C10
% R11 C11 R12 C12 R13 C13 R14 C14 R15 C15 R16 C16 R17 C17 R18 C18 R19 C19 R20 C20
% 
% High Beta (mia) : R01, R03, R05, R07, R09, R11, R13, R15, R17, R19
% Low  Beta (mib) : R02, R04, R06, R08, R10, R12, R14, R16, R18, R20
%
% injection: straight section R01
% cavities:  straight section R03


sector_01S = [injinsa fim inicio mia insainj];  % injection sector, marker of the lattice model starting element
sector_03S = [fliplr(insa) mia cav insa];       % sector with cavities
sector_05S = [fliplr(insa) mia insa];
sector_07S = [fliplr(insa) mia insa];
sector_09S = [fliplr(insa) mia insa];
sector_11S = [fliplr(insa) mia insa];
sector_13S = [fliplr(insa) mia insa];
sector_15S = [fliplr(insa) mia insa];
sector_17S = [fliplr(insa) mia insa];
sector_19S = [fliplr(insa) mia insa];
 
sector_02S = [fliplr(insb) mib insb];
sector_04S = [fliplr(insb) mib insb];
sector_06S = [fliplr(insb) mib insb];
sector_08S = [fliplr(insb) mib insb];
sector_10S = [fliplr(insb) mib insb];
sector_12S = [fliplr(insb) mib insb];
sector_14S = [fliplr(insb) mib insb];
sector_16S = [fliplr(insb) mib insb];
sector_18S = [fliplr(insb) mib insb];
sector_20S = [fliplr(insb) mib insb];


C01 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C02 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C03 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C04 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C05 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C06 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C07 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C08 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C09 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C10 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C11 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C12 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C13 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C14 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C15 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C16 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C17 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C18 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C19 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C20 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];

anel = [ ...
    sector_01S C01 sector_02S C02 sector_03S C03 sector_04S C04 sector_05S C05 ...
    sector_06S C06 sector_07S C07 sector_08S C08 sector_09S C09 sector_10S C10 ...
    sector_11S C11 sector_12S C12 sector_13S C13 sector_14S C14 sector_15S C15 ...
    sector_16S C16 sector_17S C17 sector_18S C18 sector_19S C19 sector_20S C20 ...
];


%% finalization 

elist = anel;
THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'inicio');
THERING = [THERING(idx:end) THERING(1:idx-1)];

% checa se ha elementos com comprimentos negativos
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% Imprime versao do modo
fprintf(['   Mode Version: ' mode_version '\n']);

% Ajuste de frequencia de RF de acordo com comprimento total e numero harmonico
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'cav');
THERING{rf_idx}.Frequency = rev_freq * harmonic_number;
setcavity('on'); 
setradiation('off');

% Ajusta NumIntSteps
THERING = set_num_integ_steps(THERING);

% Define Camara de Vacuo
THERING = sirius_set_vacuum_chamber(THERING);

% Define Girders
THERING = set_girders(THERING);


% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;


r = THERING;


function the_ring = set_girders(the_ring0)

the_ring = the_ring0;
b1  = findcells(the_ring,'FamName','b1');b1 = b1(2:2:end);
b2  = findcells(the_ring,'FamName','b2');b2 = b2(2:2:end);
b3  = findcells(the_ring,'FamName','b3');b3 = b3(2:2:end);
mia = findcells(the_ring,'FamName','mia');
the_ring(end+1) = the_ring(mia(1));
mia = [mia (length(the_ring))];
mib = findcells(the_ring,'FamName','mib');
mis = sort([mia mib]);
mis = [mis(1) sort([mis(2:end-1) mis(2:end-1)]) mis(end)];
% mag = findcells(the_ring,'PolynomB');
% cor = findcells(the_ring,'KickAngle');
% bpm = findcells(the_ring,'FamName','bpm');


% Girders entre b1 e b2
diff = abs(b1-b2);
first = min(b1,b2);
for ii=1:length(first)
    idx = (first(ii)+1:first(ii)+diff(ii)-3);
    if mod(ii,2)
        name_girder = sprintf('B1B2-C%02d',ceil(ii/2));
    else
        name_girder = sprintf('B2B1-C%02d',ceil(ii/2));
    end
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end

% Girders entre b2 e b3
first = min(b2,b3);
diff = abs(b2-b3);
for ii=1:length(b2)
    if mod(ii,2)
        name_girder = sprintf('B2B3-C%02d',ceil(ii/2));
    else
        name_girder = sprintf('B3B2-C%02d',ceil(ii/2));
    end
    idx = (first(ii)+1:first(ii)+diff(ii)-3);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end

% Girders entre b1 e centro do trecho reto
first = min(mis,b1);
diff = abs(mis-b1);
for ii=1:length(b2)
    if strcmp(the_ring{first(ii)}.PassMethod,'IdentityPass')
        name_girder = sprintf('MIB1-S%02d',ceil(ii/2));
    else
        name_girder = sprintf('B1MI-S%02d',ceil((ii+1)/2) - floor(ii/length(b2))*(length(b2)/2));
    end
    idx = (first(ii)+1:first(ii)+diff(ii)-1);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end

% suportes dos dipolos
for ii=1:length(b1)
    idx = b1(ii) + [-2 -1 0];
    side = 'B';
    if mod(ii,2), side = 'A'; end
    name_girder = sprintf('B1-C%02d-%s',ceil(ii/2),side);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
for ii=1:length(b2)
    idx = b2(ii) + [-2 -1 0];
    side = 'B';
    if mod(ii,2), side = 'A'; end
    name_girder = sprintf('B2-C%02d-%s',ceil(ii/2),side);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
for ii=1:(length(b3)/2)
    idx = (b3(2*ii-1)-2):b3(2*ii) ;
    name_girder = sprintf('B3BCB3-C%02d',ii);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
the_ring = the_ring(1:end-1);


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
