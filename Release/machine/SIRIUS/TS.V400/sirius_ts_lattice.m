function [r, lattice_title, IniCond] = sirius_ts_lattice(varargin)
% 2013-11-26 created Ximenes (from V100)

%% global parameters 
%  =================


% --- system parameters ---
energy = 3e9;
lattice_version = 'TS.V400';
mode = 'M';
version = '0';
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
l20      = drift('l20', 0.20, 'DriftPass');
l25      = drift('l25', 0.25, 'DriftPass');
l40      = drift('l40', 0.40, 'DriftPass');

la1p     = drift('la1p', 0.18000, 'DriftPass');
la2p     = drift('la2p', 0.26777, 'DriftPass');
la3p     = drift('la3p', 0.26000, 'DriftPass');

lb1p     = drift('lb1p', 0.22000, 'DriftPass');
lb2p     = drift('lb2p', 0.35004, 'DriftPass');

lc1p     = drift('lc1p', 0.23000, 'DriftPass');
lc2p     = drift('lc2p', 0.28004, 'DriftPass');
lc3p     = drift('lc3p', 0.26000, 'DriftPass');

ld1p     = drift('ld1p', 0.16000, 'DriftPass');
ld2p     = drift('ld2p', 0.17726, 'DriftPass');
ld3      = drift('ld3' , 0.25000, 'DriftPass');
ld4p     = drift('ld4p', 0.22000, 'DriftPass');
ld5p     = drift('ld5p', 0.30000, 'DriftPass');

% --- markers ---

mbf      = marker('mbf',    'IdentityPass');
mbd      = marker('mbd',    'IdentityPass');
msf      = marker('msf',    'IdentityPass');
msg      = marker('msg',    'IdentityPass');
mseb     = marker('mseb',   'IdentityPass');
inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');

% --- quadrupoles ---
qa1      = quadrupole('qa1', 0.2, qa1_strength, quad_pass_method);
qa2      = quadrupole('qa2', 0.2, qa2_strength, quad_pass_method);
qb1      = quadrupole('qb1', 0.2, qb1_strength, quad_pass_method);
qc1      = quadrupole('qc1', 0.2, qc1_strength, quad_pass_method);
qc2      = quadrupole('qc2', 0.2, qc2_strength, quad_pass_method);
qd1      = quadrupole('qd1', 0.2, qd1_strength, quad_pass_method);
qd2      = quadrupole('qd2', 0.2, qd2_strength, quad_pass_method);
qd3      = quadrupole('qd3', 0.2, qd3_strength, quad_pass_method);
qd4      = quadrupole('qd4', 0.2, qd4_strength, quad_pass_method);


% --- beam position monitors ---
bpm    = marker('bpm', 'IdentityPass');
%fsc    = marker('mon', 'IdentityPass');

% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');

% --- bending magnets --- 
deg_2_rad = (pi/180);

      
% -- bf --
dip_nam =  'bf';
dip_len =  1.151658;
dip_ang =  5.333333 * deg_2_rad;
dip_K   =  0.1593;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bf      = [h1 mbf h2];      

% -- bd --
dip_nam =  'bf';
dip_len =  1.151658;
dip_ang =  5.333333 * deg_2_rad;
dip_K   =  -0.1593;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bd      = [h1 mbd h2];      

% -- sep booster --
dip_nam =  'seb';
dip_len =  0.85;
dip_ang =  -3.6 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
septex  = [h1 mseb h2];

% -- sep grosso --
dip_nam =  'seg';
dip_len =  1.10;
dip_ang =  6.2 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
septgr  = [h1 msg h2];

% -- sep fino --
dip_nam =  'sef';
dip_len =  0.925;
dip_ang =  3.13 * deg_2_rad;
dip_K   =  0.00;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
septfi  = [h1 msf ch h2];

           
% --- lines ---
la1   = [la1p, l20, cv, l20, l40, l40];
la2   = [la2p, l20, l40, l40, l40];
la3   = [la3p, l40, l40, bpm, l20, ch, l25, cv, l25];
lb1   = [lb1p, l20, l40, l40, l40];
lb2   = [lb2p, l20, l40, l40, l40, l40, bpm, l20, ch, l25, cv, l25];
lc1   = [lc1p, l20, l40, l40, l40];
lc2   = [lc2p, l40];
lc3   = [lc3p, l20, l40, l40, bpm, l20, ch, l25, cv, l25];
ld1   = [ld1p, l20];
ld2   = [ld2p, l40, l40, bpm, l20, ch, l25, cv, l20];
%ld2   = [ld2p, l40, l40, l20, l25, l20];
ld4   = [ld4p, l40];
ld5   = [ld5p, l20, l40, l40, l40, bpm, l20, cv, l25];
linea = [septex, ch, l20, septex, la1, qa1, la2, qa2, la3];
lineb = [bf, lb1, qb1, lb2];
linec = [bd, lc1, qc1, lc2, qc2, lc3];
lined = [bd, ld1, qd1, ld2, qd2, ld3, qd3, ld4, qd4, ld5];
linee = [septgr, l40, septfi, bpm];
ltba  = [inicio, linea, lineb, linec, lined, linee, fim];

%% line extension to PMM
l10      = drift('l10', 0.10, 'DriftPass');
lki      = drift('lki', 2.14, 'DriftPass');
lkipmm   = drift('lkipmm', 0.807, 'DriftPass');
MIA      = marker('MIA', 'IdentityPass');
sept_in  = marker('sept_in', 'IdentityPass');
kick_in  = marker('kick_in', 'IdentityPass');
PMM      = marker('PMM', 'IdentityPass');
AN_kipmm = [sept_in, l10, MIA, lki, lkipmm, PMM];
ltba_estendido  = [inicio, linea, lineb, linec, lined, linee, AN_kipmm, fim];

%% finalization 

%elist = ltba;
elist = ltba;
the_line = buildlat(elist);
the_line = setcellstruct(the_line, 'Energy', 1:length(the_line), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(the_line, 'FamName', 'inicio');
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
bends_vchamber = [0.016 0.016 100]; % n = 100: ~rectangular
other_vchamber = [0.016 0.016 2];   % n = 2;   circular/eliptica
ivu_vchamber   = [0.016 0.016 2];   

bends = findcells(the_ring, 'BendingAngle');
ivu   = findcells(the_ring, 'FamName', 'lia2');
other = setdiff(1:length(the_ring), [bends ivu]);

for i=1:length(bends)
    the_ring{bends(i)}.VChamber = bends_vchamber;
end
for i=1:length(ivu)
    the_ring{ivu(i)}.VChamber = ivu_vchamber;
end
for i=1:length(other)
    the_ring{other(i)}.VChamber = other_vchamber;
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
