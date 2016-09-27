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

corr_length = 0.07;

%% elements
%  ========
% --- drift spaces ---
l100     = drift('l100', 0.10,   'DriftPass');
l150     = drift('l150', 0.15,   'DriftPass');
l200     = drift('l200', 0.20,   'DriftPass');
la1      = drift('la1',  0.115,  'DriftPass');
la2p     = drift('la2p', 0.1588, 'DriftPass');
lb1p     = drift('lb1p', 0.125,  'DriftPass');
lb2p     = drift('lb2p', 0.275,  'DriftPass');
lb3p     = drift('lb3p', 0.2765, 'DriftPass');
lc2      = drift('lc2',  0.27,   'DriftPass');
lc3p     = drift('lc3p', 0.2138, 'DriftPass');
lc4      = drift('lc4',  0.27,   'DriftPass');
ld1p     = drift('ld1p', 0.2892, 'DriftPass');
ld2      = drift('ld2',  0.22,   'DriftPass');
ld3p     = drift('ld3p', 0.18,   'DriftPass');
le1p     = drift('le1p', 0.1856, 'DriftPass');
le2      = drift('le2',  0.216,  'DriftPass');

l100c  = drift('l100c', 0.1000 - corr_length/2, 'DriftPass');
l150c  = drift('l150c', 0.1500 - corr_length/2, 'DriftPass');
l200c  = drift('l200c', 0.2000 - corr_length/2, 'DriftPass');
l100cc = drift('l100c', 0.1000 - corr_length, 'DriftPass');

% --- markers ---
inicio   = marker('start',  'IdentityPass');
fim      = marker('end',    'IdentityPass');
fenda    = marker('fenda',  'IdentityPass');

% --- beam position monitors ---
bpm      = marker('bpm', 'IdentityPass');

% --- correctors ---
ch   = sextupole ('ch', corr_length, 0.0, sext_pass_method);
cv   = sextupole ('cv', corr_length, 0.0, sext_pass_method);

% --- linac correctors ---
lch  = corrector('ch',  0, [0 0], 'CorrectorPass');
lcv  = corrector('cv',  0, [0 0], 'CorrectorPass');


% --- quadrupoles ---
q1a   = quadrupole('q1al',  0.05, q1al_strength,  quad_pass_method);   %
q1b   = quadrupole('q1bl',  0.10, q1bl_strength,  quad_pass_method);   % LINAC TRIPLET
q1c   = quadrupole('q1cl',  0.05, q1cl_strength,  quad_pass_method);   %
qd2   = quadrupole('qd2l',  0.10, qd2l_strength,  quad_pass_method); 
qf2   = quadrupole('qf2l',  0.10, qf2l_strength,  quad_pass_method); 
qd3a  = quadrupole('qd3al', 0.10, qd3al_strength, quad_pass_method); 
qf3a  = quadrupole('qf3al', 0.10, qf3al_strength, quad_pass_method); 
qf3b  = quadrupole('qf3bl', 0.10, qf3bl_strength, quad_pass_method); 
qd3b  = quadrupole('qd3bl', 0.10, qd3bl_strength, quad_pass_method); 
qf4   = quadrupole('qf4l',  0.10, qf4l_strength,  quad_pass_method); 
qd4   = quadrupole('qd4l',  0.10, qd4l_strength,  quad_pass_method); 
qf5   = quadrupole('qf5l',  0.10, qf5l_strength,  quad_pass_method);
qd5   = quadrupole('qd5l',  0.10, qd5l_strength,  quad_pass_method);

% --- bending magnets --- 
deg_2_rad = (pi/180);

% -- spec --
dip_nam =  'spec';
dip_len =  0.45003;
dip_ang =  -15 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
spech      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0, 0, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
spec   = [spech, spech];

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
septin  = [bseptin, septine, septins,eseptin]; % excluded ch to make it consistent with other codes. the corrector can be implemented in the polynomB.


%% % --- lines ---

la2   = [la2p, l200, l200, l200];
lb1   = [lb1p, l200, l200, bpm, l150c, ch, l100cc, cv, l150c];
lb2   = [lb2p, l200];
lb3   = [l200, l200, l200, l200, l200, fenda, l200, bpm, l150c, cv, l100cc, ch, l200c, l200, lb3p];
lc1   = [l200, l200, l200, l200, l100];
lc3   = [l200, bpm, l150c, cv, l100cc, ch, l200c, repmat(l200,1,25), lc3p];
lc5   = [l150, l150, l150, bpm, l150c, ch, l100cc, cv, l200c];
ld1   = [ld1p, repmat(l200,1,10)];
ld3   = [ld3p, bpm, l150c, ch, l200c];
le1   = [l200c, cv, l200c, l200, l200, l200, l200, l200, le1p];
le3   = [l150, bpm, l150c, cv, l100c];
line1 = [lch, lcv, la1, q1a, l100, q1b, l100, q1a, l100, q1c, la2]; 
arc1  = [lb1, qd2, lb2, qf2, lb3];
line2 = [lc1, qd3a, lc2, qf3a, lc3, qf3b, lc4, qd3b, lc5];
arc2  = [ld1, qf4, ld2, qd4, ld3];
line3 = [le1, qf5, le2, qd5, le3];
ltlb  = [inicio, line1, spec, arc1, bn, line2, bp, arc2, bp, line3, septin, bpm, fim];
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
