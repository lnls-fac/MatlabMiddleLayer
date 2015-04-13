function [r, lattice_title, IniCond] = sirius_tb_lattice(varargin)
% 2013-08-19 created  Fernando.
% 2013-12-02 V200 - from OPA (Ximenes)

%% global parameters 
%  =================

% --- system parameters ---
energy = 0.15e9;
lattice_version = 'TB.V200';
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
set_parameters_tb;


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========
% --- drift spaces ---
l50      = drift('l50', 0.50, 'DriftPass');
l30      = drift('l30', 0.30, 'DriftPass');
l20      = drift('l20', 0.20, 'DriftPass');
l15      = drift('l15', 0.15, 'DriftPass');
l10      = drift('l10', 0.10, 'DriftPass');

la1      = drift('la1', 0.115, 'DriftPass');
la2p     = drift('la2p', 0.0588, 'DriftPass');

lb2p     = drift('lb2p', 0.008, 'DriftPass');
lb4p     = drift('lb4p', 0.0185, 'DriftPass');

lc1p     = drift('lc1p', 0.026, 'DriftPass');
lc2p     = drift('lc2p', 0.076, 'DriftPass');
lc3p     = drift('lc3p', 0.0301, 'DriftPass');
lc4p     = drift('lc4p', 0.0717, 'DriftPass');

ld1p     = drift('ld1p', 0.0, 'DriftPass');
ld2p     = drift('ld2p', 0.05, 'DriftPass');
ld3p     = drift('ld3p', 0.0714, 'DriftPass');

le1p     = drift('le1p', 0.06, 'DriftPass');
le2p     = drift('le2p', 0.09, 'DriftPass');
le3p     = drift('le3p', 0.0671, 'DriftPass');

% --- markers ---
mbspec   = marker('mbspec', 'IdentityPass');
mbn      = marker('mbn',    'IdentityPass');
mbp      = marker('mbp',    'IdentityPass');
msep     = marker('msep',   'IdentityPass');
inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');
fenda    = marker('fenda',  'IdentityPass');

% --- quadrupoles ---
qa1      = quadrupole('qa1', 0.05, qa1_strength, quad_pass_method);
qa2      = quadrupole('qa2', 0.1,  qa2_strength, quad_pass_method);
qb1      = quadrupole('qb1', 0.2, qb1_strength, quad_pass_method);
qb2      = quadrupole('qb2', 0.2, qb2_strength, quad_pass_method);
qb3      = quadrupole('qb3', 0.2, qb3_strength, quad_pass_method);
qc1      = quadrupole('qc1', 0.2, qc1_strength, quad_pass_method);
qc2      = quadrupole('qc2', 0.2, qc2_strength, quad_pass_method);
qc3      = quadrupole('qc3', 0.2, qc3_strength, quad_pass_method);
qd1      = quadrupole('qd1', 0.2, qd1_strength, quad_pass_method);
qd2      = quadrupole('qd2', 0.2, qd2_strength, quad_pass_method);
qe1      = quadrupole('qe1', 0.2, qe1_strength, quad_pass_method);
qe2      = quadrupole('qe2', 0.2, qe2_strength, quad_pass_method);

% --- bending magnets --- 
deg_2_rad = (pi/180);

% -- bspec --
dip_nam =  'bspec';
dip_len =  0.45003;
dip_ang =  -15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0, 0,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0, 0,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bspec   = [h1 mbspec h2];

% -- bn --
dip_nam =  'bn';
dip_len =  0.300858;
dip_ang =  -15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bn      = [h1 mbn h2];
      
% -- bp --
dip_nam =  'bp';
dip_len =  0.300858;
dip_ang =  15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bp      = [h1 mbp h2];      

% -- sep --
dip_nam =  'sep';
dip_len =  0.50;
dip_ang =  21.75 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
sep      = [h1 msep h2];


% --- beam position monitors ---
bpm      = marker('BPM', 'IdentityPass');
% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');
           

%% % --- lines ---

la2   = [ l10, l20, l20, l20, la2p];
lb1   = [ l20, l20, l20, l20];
lb2   = [ l20, ch, l10, cv, l20, lb2p];
lb3   = [ l10, l10, l10];
lb4   = [ l20, l20, l20, l20, l10, fenda, l10, bpm, l10, ch, l10, l30, lb4p];
lc1   = [ l30, l10, l20, l50, lc1p];
lc2   = [ l10, bpm, l10, ch, l10, cv, l10, lc2p];
lc3   = [ l50, l50, l50, l50, l50, l20, l20, l10, l10, l30, lc3p];
lc4   = [ l50, l50, l50, l50, l50, l10, bpm, l10, l10, l10, lc4p];
ld1   = [ l10, l10, l10, ch, l10, cv, l10, l20, l20, l20, ld1p];
ld2   = [ l50, l50, l20, ld2p];
ld3   = [ l20, bpm, l20, ld3p];
le1   = [ l20, ch, l10, cv, l20, le1p];
le2   = [ l50, l10, le2p];
le3   = [ l50, cv, bpm, l20, le3p];
line1 = [ la1, qa1, l10, qa2, l10, qa1, l15, la2];
arc1  = [ bspec, lb1, qb1, lb2, qb2, lb3, qb3, lb4, bn];
line2 = [ lc1, qc1, lc2, qc2, lc3, qc3, lc4];
arc2  = [ bp, ld1, qd1, ld2, qd2, ld3, bp, le1, qe1, le2, qe2, le3, sep];
ltlb  = [inicio, line1, arc1, line2, arc2, fim];
elist = ltlb;


%% finalization 
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
bends_vchamber = [0.014 0.014 100]; % n = 100: ~rectangular
other_vchamber = [0.014 0.014 2];   % n = 2;   circular/eliptica
ivu_vchamber   = [0.014 0.014 2];   

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
