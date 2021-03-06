function [r, lattice_title, IniCond] = sirius_ts_lattice(varargin)
% 2013-11-26 created Ximenes (from V100)

%% global parameters
%  =================


% --- system parameters ---
energy = 3e9;
lattice_version = 'TS.V01';
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
l13      = drift('l13', 0.13, 'DriftPass');
l15      = drift('l15', 0.15, 'DriftPass');
l16      = drift('l16', 0.16, 'DriftPass');
l17      = drift('l17', 0.17, 'DriftPass');
l18      = drift('l18', 0.18, 'DriftPass');
l20      = drift('l20', 0.20, 'DriftPass');
l22      = drift('l22', 0.22, 'DriftPass');
l24      = drift('l24', 0.24, 'DriftPass');
l25      = drift('l25', 0.25, 'DriftPass');
la2p     = drift('la2p', 0.13777, 'DriftPass');
lb3p     = drift('lb3p', 0.24883, 'DriftPass');
lc1p     = drift('lc1p', 0.23400, 'DriftPass');
lc2p     = drift('lc1p', 0.21215, 'DriftPass');
ld2p     = drift('ld2p', 0.13933, 'DriftPass');

% --- markers ---

mbend    = marker('mbend',  'IdentityPass');
start    = marker('start',  'IdentityPass');
fim      = marker('end',    'IdentityPass');

% --- quadrupoles ---

qf1a    = quadrupole('qf1a', 0.14, qf1a_strength, quad_pass_method); % qf
qf1b    = quadrupole('qf1b', 0.14, qf1b_strength, quad_pass_method); % qf
qd2     = quadrupole('qd2',  0.14, qd2_strength,  quad_pass_method); % qd
qf2     = quadrupole('qf2',  0.20, qf2_strength,  quad_pass_method); % qf
qf3     = quadrupole('qf3',  0.20, qf3_strength,  quad_pass_method); % qf
qd4a    = quadrupole('qd4a', 0.14, qd4a_strength, quad_pass_method); % qd
qf4     = quadrupole('qf4',  0.20, qf4_strength,  quad_pass_method); % qf
qd4b    = quadrupole('qd4b', 0.14, qd4b_strength, quad_pass_method); % qd

% --- beam position monitors ---
bpm  = marker('bpm', 'IdentityPass');

% --- correctors ---
ch   = sextupole ('ch', 0.1, 0.0, sext_pass_method);
cv   = sextupole ('cv', 0.1, 0.0, sext_pass_method);

% --- bending magnets ---

deg_2_rad = (pi/180);

% -- bend --
dip_nam =  'bend';
dip_len =  1.151658;
dip_ang =  5.333333 * deg_2_rad;
dip_K   =  -0.1526;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bend      = [h1 mbend h2];


% -- bo extraction septum --
dip_nam =  'septex';
dip_len =  0.85;
dip_ang =  -3.6 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,   0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bseptex = marker('bseptex', 'IdentityPass'); % marker at the beginning of extraction septum
mseptex = marker('mseptex', 'IdentityPass'); % marker at the center of extraction septum
eseptex = marker('eseptex', 'IdentityPass'); % marker at the end of extraction septum
septum  = [h1, mseptex, h2];
septex  = [bseptex, septum, l20, septum, eseptex];  % excluded ch to make it consistent with other codes. the corrector can be implemented in the polynomB.

% -- thick si injection septum --
dip_nam  =  'septing';
dip_len  =  1.10;
dip_ang  =  6.2 * deg_2_rad;
dip_K    =  0.0;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bsepting = marker('bsepting', 'IdentityPass'); % marker at the beginning of thick septum
msepting = marker('msepting', 'IdentityPass'); % marker at the center of thick septum
esepting = marker('esepting', 'IdentityPass'); % marker at the end of thick septum
septgr   = [bsepting, h1, msepting, h2, esepting];  % excluded ch to make it consistent with other codes. the corrector can be implemented in the polynomB.

% -- thin si injection septum --
dip_nam  =  'septinf';
dip_len  =  0.925;
dip_ang  =  3.13 * deg_2_rad;
dip_K    =  0.00;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bseptinf = marker('bseptinf', 'IdentityPass');   % marker at the beginning of thin septum
mseptinf = marker('mseptinf', 'IdentityPass');   % marker at the center of thin septum
eseptinf = marker('eseptinf', 'IdentityPass');   % marker at the end of thin septum
septfi   = [bseptinf, h1, mseptinf, h2, eseptinf];   % we excluded ch to make it consistent with other codes. the corrector can be implemented in the polynomB.


% --- lines ---
la1   = [l20, l13, cv, l15, repmat(l20,1,4), l24];
la2   = [la2p, repmat(l20,1,11), bpm, l15, ch, l15, cv, l15];
la3   = [l16, l16];
lb1   = [l20, l20, l17];
lb2   = [l20, l20, l20];
lb3   = [lb3p, repmat(l20,1,18), bpm, l15, ch, l15, cv, l20];
lc1   = [lc1p, repmat(l20,1,9)];
lc2   = [lc2p, bpm, l15, ch, l15, cv, l20];
ld1   = [repmat(l20,1,5), l15, l15];
ld2   = [ld2p, l20, l20, bpm, l15, cv, l15, ch, l15];
ld3   = [l15, l15];
ld4   = [l15, repmat(l20,1,7), bpm, l15, cv, l20];
line1 = [septex, la1, qf1a, la2, qf1b, la3];
line2 = [bend, lb1, qd2, lb2, qf2, lb3];
line3 = [bend, lc1, qf3, lc2];
line4 = [bend, ld1, qd4a, ld2, qf4, ld3, qd4b, ld4];
line5 = [septgr, l20, l20, septfi, bpm];
ltba  = [start, line1, line2, line3, line4, line5, fim];

%% line extension to PMM
% l10      = drift('l10', 0.10, 'DriftPass');
% lki      = drift('lki', 2.14, 'DriftPass');
% lkipmm   = drift('lkipmm', 0.807, 'DriftPass');
% MIA      = marker('MIA', 'IdentityPass');
% sept_in  = marker('sept_in', 'IdentityPass');
% injkckr  = marker('InjKckr', 'IdentityPass');
% PMM      = marker('PMM', 'IdentityPass');
% AN_kipmm = [sept_in, l10, MIA, lki, lkipmm, PMM];
% ltba_estendido  = [inicio, linea, lineb, linec, lined, linee, AN_kipmm, fim];

%% finalization

%elist = ltba;
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

% -- bo extraction septum --
mbeg = findcells(the_ring, 'FamName', 'bseptex');
mend = findcells(the_ring, 'FamName', 'eseptex');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0015, 0.004, 2];
end

% -- si thick injection septum --
mbeg = findcells(the_ring, 'FamName', 'bsepting');
mend = findcells(the_ring, 'FamName', 'esepting');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0045, 0.0035, 2];
end

% -- si thin injection septum --
mbeg = findcells(the_ring, 'FamName', 'bseptinf');
mend = findcells(the_ring, 'FamName', 'eseptinf');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0015, 0.0035, 2];
end




function the_ring = set_num_integ_steps(the_ring0)

the_ring = the_ring0;

mags = findcells(the_ring, 'PolynomB');
bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(mags,bends);
ch = findcells(the_ring, 'FamName', 'ch');
cv = findcells(the_ring, 'FamName', 'cv');
kicks = findcells(the_ring, 'XGrid');

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', ch, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', cv, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
