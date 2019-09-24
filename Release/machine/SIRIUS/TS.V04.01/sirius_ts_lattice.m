function [r, lattice_title, IniCond] = sirius_ts_lattice(varargin)
% 2013-11-26 created Ximenes (from V100)
% 2016-09-28 V01.02 - new version (Ximenes) - see 'VERSIONS.txt' in Release/machine/SIRIUS

%% global parameters 
%  =================

d2r = pi/180;

% --- system parameters ---
energy = 3e9;
lattice_version = 'TS.V04.01';
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
l015     = drift('l015',  0.15, 'DriftPass');
l020     = drift('l020',  0.20, 'DriftPass');
l025     = drift('l025',  0.25, 'DriftPass');
l060     = drift('l060',  0.60, 'DriftPass');
l080     = drift('l080',  0.80, 'DriftPass');
l090     = drift('l090',  0.90, 'DriftPass');
l160     = drift('l160',  1.60, 'DriftPass');
l280     = drift('l280',  2.80, 'DriftPass');
l400     = drift('l400',  4.00, 'DriftPass');
la2p     = drift('la2p', 0.08323, 'DriftPass');
la3p     = drift('la3p', 0.232-ldif, 'DriftPass');
lb1p     = drift('lb1p', 0.220-ldif, 'DriftPass');
lb2p     = drift('lb2p', 0.83251, 'DriftPass');
lb3p     = drift('lb3p', 0.30049, 'DriftPass');
lb4p     = drift('lb4p', 0.19897-ldif, 'DriftPass');
lc1p     = drift('lc1p', 0.18704-ldif, 'DriftPass');
lc2p     = drift('lc2p', 0.07304, 'DriftPass');
lc3p     = drift('lc3p', 0.19934, 'DriftPass');
lc4p     = drift('lc4p', 0.72666-ldif, 'DriftPass');
ld1p     = drift('ld1p', 0.25700-ldif, 'DriftPass');
ld2p     = drift('ld2p', 0.05389, 'DriftPass');
ld3p     = drift('ld3p', 0.154, 'DriftPass');
ld4p     = drift('ld4p', 0.192, 'DriftPass');
ld5p     = drift('ld5p', 0.456, 'DriftPass');
ld6p     = drift('ld6p', 0.258, 'DriftPass');
ld7p     = drift('ld7p', 0.175, 'DriftPass');

% --- markers ---
start    = marker('start',  'IdentityPass');
fim      = marker('end',    'IdentityPass');

% --- beam screen monitors
scrn   = marker('Scrn', 'IdentityPass');

% --- beam current monitors ---
ict    = marker('ICT', 'IdentityPass');
fct    = marker('FCT', 'IdentityPass');

% --- beam position monitors ---
bpm    = marker('BPM', 'IdentityPass');

% --- correctors ---
ch     = corrector('CH',  0, [0 0], 'CorrectorPass');
cv     = corrector('CV',  0, [0 0], 'CorrectorPass');

% --- quadrupoles ---
  
qf1a    = quadrupole('QF1A', 0.14, qf1ah_strength, quad_pass_method); % qf
qf1b    = quadrupole('QF1B', 0.14, qf1bh_strength, quad_pass_method); % qf
qd2     = quadrupole('QD2',  0.14, qd2h_strength,  quad_pass_method); % qd
qf2     = quadrupole('QF2',  0.20, qf2h_strength,  quad_pass_method); % qf
qf3     = quadrupole('QF3',  0.20, qf3h_strength,  quad_pass_method); % qf
qd4a    = quadrupole('QD4A', 0.14, qd4ah_strength, quad_pass_method); % qd
qf4     = quadrupole('QF4',  0.20, qf4h_strength,  quad_pass_method); % qf
qd4b    = quadrupole('QD4B', 0.14, qd4bh_strength, quad_pass_method); % qd

% [qf1a, ~] = sirius_si_q20_segmented_model('QF1A', qf1ah_strength,  quad_pass_method);
% [qf1b, ~] = sirius_si_q30_segmented_model('QF1B', qf1bh_strength,  quad_pass_method);

% --- bending magnets --- 

      
% -- bend --
%dip_nam =  'B';
%dip_len =  1.151658;
%dip_ang =  5.333333 * deg_2_rad;
%dip_K   =  -0.1526;
%dip_S   =  0.00;
%h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2,...
%           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);        
%h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2,...
%           0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
%bend      = [h1 mbend h2];      

% f = 5.011542/5.333333;
% h1  = rbend_sirius('B', 0.196, d2r * 0.8597 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.163 -1.443 0] * f, bend_pass_method);
% h2  = rbend_sirius('B', 0.192, d2r * 0.8467 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.154 -1.418 0] * f, bend_pass_method);
% h3  = rbend_sirius('B', 0.182, d2r * 0.8099 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.14 -1.403 0] * f, bend_pass_method);
% h4  = rbend_sirius('B', 0.010, d2r * 0.0379 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.175 -1.245 0] * f, bend_pass_method);
% h5  = rbend_sirius('B', 0.010, d2r * 0.0274 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.115 -0.902 0] * f, bend_pass_method);
% h6  = rbend_sirius('B', 0.013, d2r * 0.0244 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.042 -1.194 0] * f, bend_pass_method);
% h7  = rbend_sirius('B', 0.017, d2r * 0.0216 * f, 0, 0, 0, 0, 0, [0 0 0], [0 -0.008 -1.408 0] * f, bend_pass_method);
% h8  = rbend_sirius('B', 0.020, d2r * 0.0166 * f, 0, 0, 0, 0, 0, [0 0 0], [0 0.004 -1.276 0] * f, bend_pass_method);
% h9  = rbend_sirius('B', 0.030, d2r * 0.0136 * f, 0, 0, 0, 0, 0, [0 0 0], [0 0.006 -0.858 0] * f, bend_pass_method);
% h10 = rbend_sirius('B', 0.05,  d2r * 0.0089 * f, 0, 0, 0, 0, 0, [0 0 0], [0 0 -0.05 0] * f, bend_pass_method);
% mbend = marker('mB',  'IdentityPass');
% bend = [h10 h9 h8 h7 h6 h5 h4 h3 h2 h1 mbend h1 h2 h3 h4 h5 h6 h7 h8 h9 h10];

[bend, ~] = sirius_ts_b_segmented_model(energy, 'B', bend_pass_method);


% -- pulsed magnets --

% thick and thin ejection septa are identical in the point of view of the
% dynamics

% -- bo thin ejection septum --
dip_nam =  'EjeSeptF';
dip_len =  0.5773;
dip_ang =  -3.6 * d2r;
dip_K   =  0.0;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang,   0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bejesf = marker('bEjeSeptF', 'IdentityPass'); % marker at the beginning of thin septum
mejesf = marker('mEjeSeptF', 'IdentityPass'); % marker at the center of thin septum
eejesf = marker('eEjeSeptF', 'IdentityPass'); % marker at the end of thin septum
ejesf = [bejesf, h1, mejesf, h2, eejesf];

% -- bo thick ejection septum --
dip_nam  =  'EjeSeptG';
dip_len  =  0.5773;
dip_ang  =  -3.6 * d2r;
dip_K    =  0.0;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
bejesg = marker('bEjeSeptG', 'IdentityPass'); % marker at the beginning of thick septum
mejesg = marker('mEjeSeptG', 'IdentityPass'); % marker at the center of thick septum
eejesg = marker('eEjeSeptG', 'IdentityPass'); % marker at the end of thick septum
ejesg = [bejesg, h1, mejesg, h2, eejesg];

% -- si thick injection septum (2 of these are used) --
dip_nam  =  'InjSeptG';
dip_len  =  0.5773;
dip_ang  =  +3.6 * d2r;
dip_K    =  0.0;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
binjsg = marker('bInjSeptG', 'IdentityPass'); % marker at the beginning of thick septum
minjsg = marker('mInjSeptG', 'IdentityPass'); % marker at the center of thick septum
einjsg = marker('eInjSeptG', 'IdentityPass'); % marker at the end of thick septum
injsg = [binjsg, h1, minjsg, h2, einjsg];

% -- si thin injection septum --
dip_nam  =  'InjSeptF';
dip_len  =  0.5773;
dip_ang  =  +3.118 * d2r;
dip_K    =  0.0;
dip_S    =  0.00;
h1       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);        
h2       = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang, 1*dip_ang/2, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
binjsf = marker('bInjSeptF', 'IdentityPass'); % marker at the beginning of thin septum
minjsf = marker('mInjSeptF', 'IdentityPass'); % marker at the center of thin septum
einjsf = marker('eInjSeptF', 'IdentityPass'); % marker at the end of thin septum
injsf = [binjsf, h1, minjsf, h2, einjsf];

% --- lines ---
sec01 = [ejesf,l025,ejesg,l060,cv,l090,qf1a,la2p,ict,l280,scrn,bpm,...
         l020,l020,ch,qf1b,l020,cv,l020,la3p,bend];
sec02 = [l080,lb1p,qd2,lb2p,scrn,bpm,lb3p,ch,qf2,l020,cv,l025,l015,lb4p,bend];
sec03 = [lc1p,l400,scrn,bpm,l020,lc2p,ch,qf3,lc3p,cv,lc4p,bend];
sec04 = [ld1p,l060,qd4a,ld2p,l160,bpm,scrn,l020,ld3p,cv,l020,ch,qf4,ld4p,fct, ...
         ld4p,ict,ld4p,qd4b,ld5p,bpm,scrn,ld6p,cv,ld7p,injsg,l025,injsg,l025,injsf,scrn];   
     
ltba  = [start,sec01,sec02,sec03,sec04,fim];


%% finalization 

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

% -- bo ejection septa --
mbeg = findcells(the_ring, 'FamName', 'bEjeSeptG');
mend = findcells(the_ring, 'FamName', 'eEjeSeptF');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0015, 0.004, 2];
end

% -- si thick injection septum --
mbeg = findcells(the_ring, 'FamName', 'bInjSeptG');
mend = findcells(the_ring, 'FamName', 'eInjSeptG');
for i=mbeg:mend
    the_ring{i}.VChamber = [0.0045, 0.0035, 2];
end

% -- si thin injection septum --
mbeg = findcells(the_ring, 'FamName', 'bInjSeptF');
mend = findcells(the_ring, 'FamName', 'eInjSeptF');
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
