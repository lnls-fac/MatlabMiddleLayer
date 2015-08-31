function [r, lattice_title, IniCond] = sirius_tb_lattice(varargin)
% 2013-08-19 created  Fernando.
% 2013-12-02 V200 - from OPA (Ximenes)
% 2014-10-20 V300 - new version (Liu)
% 2015-08-26 V01 - new version (Liu)

%% global parameters 
%  =================

% --- system parameters ---
energy = 0.15e9;
lattice_version = 'TB.V01';
mode = 'M';
version = '6';
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
l100     = drift('l100', 0.10, 'DriftPass');
l150     = drift('l150', 0.15, 'DriftPass');
l200     = drift('l200', 0.20, 'DriftPass');

la1      = drift('la1', 0.115, 'DriftPass');
la2p     = drift('la2p', 0.1588, 'DriftPass');

lb1p     = drift('lb1p', 0.125, 'DriftPass');
lb2p     = drift('lb2p', 0.275, 'DriftPass');
lb3p     = drift('lb3p', 0.2765, 'DriftPass');

lc2      = drift('lc2', 0.27, 'DriftPass');
lc3p     = drift('lc3p', 0.2138, 'DriftPass');
lc4      = drift('lc4', 0.27, 'DriftPass');

ld1p     = drift('ld1p', 0.2892, 'DriftPass');
ld2      = drift('ld2', 0.22, 'DriftPass');
ld3p     = drift('ld3p', 0.18, 'DriftPass');

le1p     = drift('le1p', 0.1856, 'DriftPass');
le2      = drift('le2', 0.216, 'DriftPass');

% --- markers ---
mbspec   = marker('mbspec', 'IdentityPass');
mbn      = marker('mbn',    'IdentityPass');
mbp      = marker('mbp',    'IdentityPass');
msep     = marker('msep',   'IdentityPass');
inicio   = marker('start',  'IdentityPass');
fim      = marker('end',    'IdentityPass');
fenda    = marker('fenda',  'IdentityPass');

% --- beam position monitors ---
bpm      = marker('bpm', 'IdentityPass');

% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');

mch    = marker('mch',  'IdentityPass');
mcv    = marker('mcv',  'IdentityPass');


% --- quadrupoles ---
qa1      = quadrupole('qa1', 0.05, qa1_strength, quad_pass_method);
qa2      = quadrupole('qa2', 0.1,  qa2_strength, quad_pass_method);
qa3      = quadrupole('qa3', 0.05, qa3_strength, quad_pass_method);
qb1      = quadrupole('qb1', 0.1, qb1_strength, quad_pass_method);
qb2      = quadrupole('qb2', 0.1, qb2_strength, quad_pass_method);
qc1      = quadrupole('qc1', 0.1, qc1_strength, quad_pass_method);
qc2      = quadrupole('qc2', 0.1, qc2_strength, quad_pass_method);
qc3      = quadrupole('qc3', 0.1, qc3_strength, quad_pass_method);
qc4      = quadrupole('qc4', 0.1, qc4_strength, quad_pass_method);
qd1      = quadrupole('qd1', 0.1, qd1_strength, quad_pass_method);
qd2      = quadrupole('qd2', 0.1, qd2_strength, quad_pass_method);
qe1      = quadrupole('qe1', 0.1, qe1_strength, quad_pass_method);
qe2      = quadrupole('qe2', 0.1, qe2_strength, quad_pass_method);

% --- bending magnets --- 
deg_2_rad = (pi/180);

% -- bspec --
dip_nam =  'bspec';
dip_len =  0.45003;
dip_ang =  -15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
bspech      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0, 0, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
bspec   = [bspech, bspech];

% -- bn --
dip_nam =  'bn';
dip_len =  0.300858;
dip_ang =  -15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
bne     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
bns     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bn      = [bne, bns];
      
% -- bp --
dip_nam =  'bp';
dip_len =  0.300858;
dip_ang =  15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
bpe     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
bps     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bp      = [bpe, bps];      

% -- bo injection septum --
dip_nam =  'septin';
dip_len =  0.50;
dip_ang =  21.75 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
septine = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
septins = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bseptin = marker('bseptin','IdentityPass');
eseptin = marker('eseptin','IdentityPass');
septin  = [bseptin, septine, ch, septins,eseptin];

%booster
l800    = drift('l800', 0.80, 'DriftPass');
l600    = drift('l600', 0.60, 'DriftPass');
l250    = drift('l250', 0.25, 'DriftPass');
qf      = quadrupole('qf', 0.1, 1.8821, quad_pass_method);
kick_in = marker('kick_in', 'IdentityPass');

lbooster = [l800, l250, qf, qf, l600, kick_in];


%% % --- lines ---

la2   = [ la2p, l200, l200, l200];
lb1   = [ lb1p, l200, l200, bpm, l150, ch, l100, cv, l150];
lb2   = [ lb2p, l200];
lb3   = [ l200, l200, l200, l200, l200, fenda, l200, bpm, l150, cv, l100, ch, l200, l200, lb3p];
lc1   = [ l200, l200, l200, l200, l100];
lc3   = [ l200, bpm, l150, cv, l100, ch, repmat(l200,1,26), lc3p];
lc5   = [ l150, l150, l150, bpm, l150, ch, l100, cv, l200];
ld1   = [ ld1p, repmat(l200,1,10)];
ld3   = [ ld3p, bpm, l150, ch, l200];
le1   = [ l200, cv, l200, l200, l200, l200, l200, l200, le1p];
le3   = [ l150, bpm, l150, cv, l100];
line1 = [ ch, cv, la1, qa1, l100, qa2, l100, qa1, l100, qa3, la2];
arc1  = [ bspec, lb1, qb1, lb2, qb2, lb3, bn];
line2 = [ lc1, qc1, lc2, qc2, lc3, qc3, lc4, qc4, lc5];
arc2  = [ bp, ld1, qd1, ld2, qd2, ld3, bp, le1, qe1, le2, qe2, le3, septin, bpm];
ltlb  = [inicio, line1, arc1, line2, arc2, fim];
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
bn = findcells(the_ring, 'FamName', 'bn');
bp = findcells(the_ring, 'FamName', 'bp');
for i=[bn, bp]
    the_ring{i}.VChamber = [0.0117, 0.0117, 2];
end

% -- bo injection septum --
mbeg = findcells(the_ring, 'FamName', 'bseptin');
mend = findcells(the_ring, 'FamName', 'eseptin');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0075, 0.008, 2];
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
