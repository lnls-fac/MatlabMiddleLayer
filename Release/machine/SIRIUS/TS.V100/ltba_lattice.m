function [r IniCond] = sirius_ts_lattice(varargin)
% 2013-08-19 created  Fernando.


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
caso   = 'matched';

% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i})
        caso = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

fprintf(['   Loading LTBA_V100 - ' caso ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions
IniCond.ElemIndex = 1;
IniCond.Spos = 0;
IniCond.ClosedOrbit = [0,0,0,0]';
IniCond.mu = [0,0];
IniCond.Dispersion = [0.3448,-0.0692,0,0]';
IniCond.beta = [20.4713, 6.0196];
IniCond.alpha= [4.0892,-1.1444];
%%% Quadrupole strengths:
set_parameters_ltba;


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========
% --- drift spaces ---
l20      = drift('l20', 0.2, 'DriftPass');

la1p     = drift('la1p', 0.100, 'DriftPass');
la2p     = drift('la2p', 0.117, 'DriftPass');
la3p     = drift('la3p', 0.043, 'DriftPass');
la4p     = drift('la4p',0.07418, 'DriftPass');

lb1p     = drift('lb1p', 0.136, 'DriftPass');
lb2p     = drift('lb2p', 0.032, 'DriftPass');
lb3p     = drift('lb3p', 0.184, 'DriftPass');
lb4p     = drift('lb4p', 0.0403,'DriftPass');

lc1p     = drift('lc1p', 0.056, 'DriftPass');
lc2p     = drift('lc2p', 0.140, 'DriftPass');
lc3p     = drift('lc3p', 0.194, 'DriftPass');
lc4p     = drift('lc4p', 0.13552,'DriftPass');
lc5p     = drift('lc5p', 0.050, 'DriftPass');


% --- markers ---

mbp      = marker('mbp',    'IdentityPass');
msf      = marker('msf',    'IdentityPass');
msg      = marker('msg',    'IdentityPass');
mseb     = marker('mseb',   'IdentityPass');
inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');

% --- quadrupoles ---
qa1      = quadrupole('qa1', 0.2, qa1_strength, quad_pass_method);
qa2      = quadrupole('qa2', 0.2, qa2_strength, quad_pass_method);
qa3      = quadrupole('qa3', 0.2, qa3_strength, quad_pass_method);
qb1      = quadrupole('qb1', 0.2, qb1_strength, quad_pass_method);
qb2      = quadrupole('qb2', 0.2, qb2_strength, quad_pass_method);
qb3      = quadrupole('qb3', 0.2, qb3_strength, quad_pass_method);
qc1      = quadrupole('qc1', 0.2, qc1_strength, quad_pass_method);
qc2      = quadrupole('qc2', 0.2, qc2_strength, quad_pass_method);
qc3      = quadrupole('qc3', 0.2, qc3_strength, quad_pass_method);
qc4      = quadrupole('qc4', 0.2, qc4_strength, quad_pass_method);


% --- bending magnets --- 
deg_2_rad = (pi/180);

      
% -- bp --
dip_nam =  'bp';
dip_len =  0.900;
dip_ang =  7.1 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
BP      = [h1 mbp h2];      

% -- sep booster --
dip_nam =  'seb';
dip_len =  0.80;
dip_ang =  -3.58 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
SEB      = [h1 mseb h2];

% -- sep grosso --
dip_nam =  'seg';
dip_len =  1.0004;
dip_ang =  5.8 * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
SG      = [h1 msg h2];

% -- sep fino --
dip_nam =  'sef';
dip_len =  1.4012;
dip_ang =  4.8 * deg_2_rad;
dip_K   =  0.00;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2,...
           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
SF      = [h1 msf h2];


% --- beam position monitors ---
mon      = marker('BPM', 'IdentityPass');
% --- correctors ---
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');
           

%% % --- lines ---
la1      = [repmat(l20,1,15),la1p];
la2      = [repmat(l20,1,3), la2p];
la3      = [repmat(l20,1,7), la3p];
la4      = [repmat(l20,1,4), la4p];

sx = sextupole('sx', 0.20, -230*0, quad_pass_method);

lb1      = [repmat(l20,1,4), lb1p];
lb2      = [repmat(l20,1,8), lb2p];
lb3      = [repmat(l20,1,2), lb3p];
lb4      = [repmat(l20,1,2), lb4p];

lc1      = [l20, lc1p];
lc2      = [repmat(l20,1,6), lc2p];
lc3      = [repmat(l20,1,10), lc3p];
lc4      = [repmat(l20,1,3), sx, repmat(l20,1,3), lc4p];
lc5      = [repmat(l20,1,7), lc5p];

ld1      = repmat(l20,1,5);

line1    = [SEB, l20, SEB, la1, qa1, la2, qa2, la3, qa3, la4];
arc1     = [BP, lb1, qb1, lb2, qb2, lb3, qb3, lb4, BP];
line2    = [lc1, qc1, lc2, qc2, lc3, qc3, lc4, qc4, lc5];
arc2     = [SG, ld1, SF];

part1    = [line1, arc1, line2];
LTBA     = [inicio, part1, arc2, fim];


%% finalization 

elist = LTBA;
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
