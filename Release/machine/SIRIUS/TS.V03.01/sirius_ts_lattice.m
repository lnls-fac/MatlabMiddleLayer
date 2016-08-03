function [r, lattice_title, IniCond] = sirius_ts_lattice(varargin)
% 2013-11-26 created Ximenes (from V100)

%% global parameters 
%  =================

d2r = pi/180;

% --- system parameters ---
energy = 3e9;
lattice_version = 'TS.V03.01';
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


%% elements
%  ========
% --- drift spaces ---
ldif     = 0.1442; 
l10      = drift('l10',  0.10, 'DriftPass');
l15      = drift('l15',  0.15, 'DriftPass');
l20      = drift('l20',  0.20, 'DriftPass');
l25      = drift('l25',  0.25, 'DriftPass');
la2p     = drift('la2p', 0.08341, 'DriftPass');
la3p     = drift('la3p', 0.232-ldif, 'DriftPass');
lb1p     = drift('lb1p', 0.220-ldif, 'DriftPass');
lb2p     = drift('lb2p', 0.133, 'DriftPass');
lb3p     = drift('lb3p', 0.19842-ldif, 'DriftPass');
lc1p     = drift('lc1p', 0.18704-ldif, 'DriftPass');
lc2p     = drift('lc2p', 0.226-ldif, 'DriftPass');
ld1p     = drift('ld1p', 0.21409-ldif, 'DriftPass');
ld2p     = drift('ld2p', 0.242, 'DriftPass');
ld3p     = drift('ld3p', 0.143, 'DriftPass');

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
bpm    = marker('bpm', 'IdentityPass');

% --- correctors ---
ch     = corrector('ch',  0, [0 0], 'CorrectorPass');
cv     = corrector('cv',  0, [0 0], 'CorrectorPass');

% --- bending magnets --- 

      
% -- bend --
%dip_nam =  'bend';
%dip_len =  1.151658;
%dip_ang =  5.333333 * deg_2_rad;
%dip_K   =  -0.1526;
%dip_S   =  0.00;
%h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
%           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
%h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
%           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
%bend      = [h1 mbend h2];      
f = 5.011542/5.333333;
h1  = rbend_sirius('bend', 0.196, d2r * 0.8597 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.163 -1.443 0] * f, bend_pass_method);
h2  = rbend_sirius('bend', 0.192, d2r * 0.8467 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.154 -1.418 0] * f, bend_pass_method);
h3  = rbend_sirius('bend', 0.182, d2r * 0.8099 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.14 -1.403 0] * f, bend_pass_method);
h4  = rbend_sirius('bend', 0.010, d2r * 0.0379 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.175 -1.245 0] * f, bend_pass_method);
h5  = rbend_sirius('bend', 0.010, d2r * 0.0274 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.115 -0.902 0] * f, bend_pass_method);
h6  = rbend_sirius('bend', 0.013, d2r * 0.0244 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.042 -1.194 0] * f, bend_pass_method);
h7  = rbend_sirius('bend', 0.017, d2r * 0.0216 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.008 -1.408 0] * f, bend_pass_method);
h8  = rbend_sirius('bend', 0.020, d2r * 0.0166 * f, 0, 0, 0, 0, 0, [0 0 0], [0 0.004 -1.276 0] * f, bend_pass_method);
h9  = rbend_sirius('bend', 0.030, d2r * 0.0136 * f, 0, 0, 0, 0, 0, [0 0 0], [0 0.006 -0.858 0] * f, bend_pass_method);
h10 = rbend_sirius('bend', 0.05,  d2r * 0.0089 * f, 0, 0, 0, 0, 0, [0 0 0], [0 0 -0.05 0] * f, bend_pass_method);

bend = [h10 h9 h8 h7 h6 h5 h4 h3 h2 h1 mbend h1 h2 h3 h4 h5 h6 h7 h8 h9 h10];

% -- bo extraction septum --
dip_nam =  'septex';
dip_len =  0.5774;
dip_ang =  -3.6 * d2r;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,   0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bseptex = marker('bseptex', 'IdentityPass'); % marker at the beginning of extraction septum
mseptex = marker('mseptex', 'IdentityPass'); % marker at the center of extraction septum
eseptex = marker('eseptex', 'IdentityPass'); % marker at the end of extraction septum
septex  = [bseptex, h1, mseptex, h2, eseptex];

% -- thick septum --
dip_nam  =  'sept_thick';
dip_len  =  0.5774;
dip_ang  =  3.6 * d2r;
dip_K    =  0.0;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);

bsept_thick = marker('bsept_thick', 'IdentityPass'); % marker at the beginning of thick septum
msept_thick = marker('msept_thick', 'IdentityPass'); % marker at the center of thick septum
esept_thick = marker('esept_thick', 'IdentityPass'); % marker at the end of thick septum
sept_thick  = [bsept_thick, h1, msept_thick, h2, esept_thick];

% -- si injection septum --
dip_nam  =  'septin';
dip_len  =  0.5;
dip_ang  =  0.05430;
dip_K    =  0.0;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);

bseptin = marker('bseptin', 'IdentityPass'); % marker at the beginning of injection septum
mseptin = marker('mseptin', 'IdentityPass'); % marker at the center of injection septum
eseptin = marker('eseptin', 'IdentityPass'); % marker at the end of injection septum
septin  = [bseptin, h1, mseptin, h2, eseptin];
           
% --- lines ---
la1   = [l20, l20, l20, cv, l20, l20, l20, l20, l10];
la2   = [la2p, repmat(l20,1,14), bpm, l20, ch, l20];
la3   = [l20, cv, l20, la3p];
lb1   = [l20, l20, l20, l20, lb1p];
lb2   = [lb2p, l20, l20, l20, l20, bpm, l20];
lb3   = [l20, ch, l25, cv, l15, lb3p];
lc1   = [lc1p, repmat(l20,1,21)];
lc2   = [l25, bpm, l20, ch, l25, cv, lc2p];
ld1   = [ld1p, repmat(l20,1,6), l10];
ld2   = [ld2p, repmat(l20,1,6)];
ld3   = [ld3p, l20];
ld4   = [repmat(l20,1,6), bpm, l20, cv, l20];
lnlk  = [repmat(l25,1,14), l20, l20];

line1 = [septex, ch, l25, septex, la1, qf1a, la2, qf1b, la3];
line2 = [bend, lb1, qd2, lb2, qf2, lb3];
line3 = [bend, lc1, qf3, lc2];
line4 = [bend, ld1, qd4a, ld2, qf4, ld3, qd4b, ld4];
line5 = [sept_thick, ch, l25, sept_thick, l25, septin, bpm];
ltba  = [start, line1, line2, line3, line4, line5, fim];

%% line extension to PMM

% ltba_estendido  = [start, line1, line2, line3, line4, line5, lnlk, fim];

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
