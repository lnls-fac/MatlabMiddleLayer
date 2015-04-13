function [r IniCond] = sirius_lb_lattice(varargin)
% 2013-08-19 created  Fernando.


%% global parameters 
%  =================

% --- system parameters ---
energy = 0.15e9;
caso   = 'caso1';

% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i})
        caso = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

fprintf(['   Loading LTLB_V100 - ' caso ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions
IniCond.ElemIndex = 1;
IniCond.Spos = 0;
IniCond.ClosedOrbit = [0,0,0,0]';
IniCond.mu = [0,0];
%%% Quadrupole strengths:
set_parameters_ltlb;


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========
% --- drift spaces ---
l20      = drift('l20', 0.2, 'DriftPass');
l10      = drift('l10', 0.1, 'DriftPass');

la1      = drift('la1', 0.1353, 'DriftPass');
la2p     = drift('la2p', 0.0272, 'DriftPass');

lb2p     = drift('lb2p', 0.108, 'DriftPass');
lb3p     = drift('lb3p', 0.100, 'DriftPass');
lb4p     = drift('lb4p', 0.1185, 'DriftPass');

lc1p     = drift('lc1p', 0.126, 'DriftPass');
lc2p     = drift('lc2p', 0.076, 'DriftPass');
lc3p     = drift('lc3p', 0.0301, 'DriftPass');
lc4p     = drift('lc4p', 0.17, 'DriftPass');

ld1p     = drift('ld1p', 0.10, 'DriftPass');
ld2p     = drift('ld2p', 0.05, 'DriftPass');
ld3p     = drift('ld3p', 0.0714, 'DriftPass');

le1p     = drift('le1p', 0.16, 'DriftPass');
le2p     = drift('le2p', 0.09, 'DriftPass');
le3p     = drift('le3p', 0.1671, 'DriftPass');

% --- markers ---
mbspec   = marker('mbspec', 'IdentityPass');
mbn      = marker('mbn',    'IdentityPass');
mbp      = marker('mbp',    'IdentityPass');
msep     = marker('msep',   'IdentityPass');
inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');

% --- quadrupoles ---
qa1      = quadrupole('qa1', 0.05, qa1_strength, quad_pass_method);
qa2      = quadrupole('qa2', 0.1,  qa2_strength, quad_pass_method);
qa3      = quadrupole('qa3', 0.05, qa3_strength, quad_pass_method);
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
BSPEC   = [h1 mbspec h2];

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
BN      = [h1 mbn h2];
      
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
BP      = [h1 mbp h2];      

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
SEP      = [h1 msep h2];


% --- beam position monitors ---
mon      = marker('BPM', 'IdentityPass');
% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');
           

%% % --- lines ---
la2      = [repmat(l20,1,4), la2p];

lb1      = repmat(l20,1,4);
lb2      = [repmat(l20,1,2), lb2p];
lb3      = [l20, lb3p];
lb4      = [repmat(l20,1,7), lb4p];

lc1      = [repmat(l20,1,5), lc1p];
lc2      = [repmat(l20,1,2), lc2p];
lc3      = [repmat(l20,1,17), lc3p];
lc4      = [repmat(l20,1,14), lc4p];

ld1      = [repmat(l20,1,5), ld1p];
ld2      = [repmat(l20,1,6), ld2p];
ld3      = [repmat(l20,1,2), ld3p];

le1      = [repmat(l20,1,2), le1p];
le2      = [repmat(l20,1,3), le2p];
le3      = [repmat(l20,1,3), le3p];

linea    = [la1, qa1, l10, qa2, l10, qa1, l10, qa3, la2, BSPEC];
lineb    = [lb1, qb1, lb2, qb2, lb3, qb3, lb4, BN];
linec    = [lc1, qc1, lc2, qc2, lc3, qc3, lc4, BP];
lined    = [ld1, qd1, ld2, qd2, ld3, BP];
linee    = [le1, qe1, le2, qe2, le3, SEP];

LTLB     = [inicio, linea, lineb, linec, lined, linee, fim];


%% finalization 

elist = LTLB;
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
