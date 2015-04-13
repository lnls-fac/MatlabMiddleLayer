function r = sirius_bo_lattice(varargin)
%maquina com simetria 50, formada por dipolos e quadrupolos com sextupolos
%integrados. 15/08/2012 - Fernando.

%%% HEADER SECTION %%%

global THERING

const = lnls_constants;
energy = 3e9; % eV

for i=1:length(varargin)
	energy = varargin{i} * 1e9;
end

harmonic_number = 828;
RFC = rfcavity('CAV', 0, 0.95e+6, 499654000, harmonic_number, 'CavityPass');

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';

B_length = 1.1520;
B_angle  = 360 / 50;
B_gap    = 0.028;
B_fint1  = 0.0;
B_fint2  = 0.0;
B_edge   = (B_angle/2)*(pi/180)*1;

%carrega as forcas dos magnetos;
set_magnets_strength_booster;


b1 = rbend_sirius('B', B_length, B_angle*(pi/180), B_edge, B_edge, ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0, B_strength, B_sext, 0], bend_pass_method);
pb = marker('PB', 'IdentityPass');
b = [pb, b1, pb];

qd   = quadrupole('QD', 0.20, qd_strength, quad_pass_method);

%coef do mapa de campo.
polB = [[0 2.35824E-01], 0*[0 5.80904E+00 0 -1.10084E+05 0 +8.17767E+08 0 -3.13863E+12 ...
     0 +6.58302E+15 0 -7.11141E+18 0 +3.54236E+21 0 -6.05227E+23 ]];
 
polB = polB/polB(2)* qf_strength;
qf   = quadrupole_sirius('QF', 0.10, polB*0, polB, quad_pass_method);
% qf   = quadrupole('qf', 0.10, qf_strength, quad_pass_method);
mqf   = marker('MQF', 'IdentityPass');

sf = sextupole('SF', 0.20, sf_strength, sext_pass_method);

sd = sextupole('SD', 0.20, sd_strength, sext_pass_method);

inicio   = marker('INICIO', 'IdentityPass');
fim      = marker('FIM',    'IdentityPass');
inj      = marker('INJ', 'IdentityPass');
mon      = marker('BPM', 'IdentityPass');


ch = corrector('HCM', 0, [0 0], 'CorrectorPass');
cv = corrector('VCM', 0, [0 0], 'CorrectorPass');

hlt      = drift('HLT',  2.146000/2, 'DriftPass');
l20      = drift('L20',  0.200000, 'DriftPass');
l25      = drift('L25',  0.250000, 'DriftPass');
l30      = drift('L30',  0.300000, 'DriftPass');
l81      = drift('L70',  0.800581, 'DriftPass');
lm25     = drift('LM25', 1.896000, 'DriftPass');
lm30     = drift('LM30', 1.846000, 'DriftPass');
lm40     = drift('LM40', 1.746000, 'DriftPass');
lm45     = drift('LM45', 1.696000, 'DriftPass');
lm70     = drift('LM70', 1.446000, 'DriftPass');
lm114    = drift('LM100',1.045419, 'DriftPass');


%kicker de injecao
kick_in  = drift('KICK_IN', 0.500, 'DriftPass');
l37      = drift('L37',  0.370000, 'DriftPass');
lm87     = drift('LM87', 1.276000, 'DriftPass');
lki     = [l37, kick_in, lm87]; % kicker de injecao
%septum de injecao
sept_in  = drift('SEPT_IN', 0.500, 'DriftPass');
lm145     = drift('LM145', 0.596000, 'DriftPass');
l80      = drift('L80',  0.800000, 'DriftPass');
%kicker de extracao
kick_ex  = drift('KICK_EX',0.500, 'DriftPass');
l42      = drift('L42',  0.426000, 'DriftPass');
l28      = drift('L24',  0.281044, 'DriftPass');
l22      = drift('L23',  0.219478, 'DriftPass');
kick_e   = [l22, kick_ex, l28, kick_ex, l22]; % ao todo dah 1.72m
%septum de extracao: tamanho nao realista. projecao na orbita do booster eh
%menor
sept_ex  = drift('SEPT_EX', 0.800, 'DriftPass');
sept_ex = [sept_ex l20 sept_ex];
l04      = drift('l04',  0.0460000, 'DriftPass');

mlt      = marker('MLT', 'IdentityPass');


%Standard:
lfree   = [hlt mlt hlt];
lqd     = [lm45, qd, l25];
lsd     = [lm45, sd, l25];
lsf     = [lm40, sf, l20];
lch     = [lm25, ch, l25];
lcv     = [lm30, cv, l30];
lsdcv   = [lm70, cv, l25, sd, l25];
fodo1   = [mqf, qf, lfree, lfree, b, lfree, mon, lsf, qf];
fodo2   = [mqf, qf, lfree, lqd, b, fliplr(lcv), mon, lch, qf];
fodo1sd = [mqf, qf, lfree, lfree, b, fliplr(lsd), mon, lsf, qf];
fodo2sd = [mqf, qf, lfree, lqd, b, fliplr(lsdcv), mon, lch, qf];
boos    = [fodo1sd, fodo2, fodo1, fodo2, fodo1, fodo2sd, fodo1, fodo2, fodo1, fodo2];

%Injection and Extraction
lcvmon  = [l81, mon, lm114, cv, l30]; % 1) desloca bpm do centro p/ cam. vac. elip.
lke     = [l42, kick_e]; % kikcer de extracao
lse     = [l30, sept_ex, l04]; % septum de extracao
lsich   = [lm145, sept_in, l80, ch, l25]; % septum de injecao

fodo2ke  = [mqf, qf, lke, lqd, b, fliplr(lcvmon), lch, qf]; % aplic de 1
fodo1se = [mqf, qf, lse, lfree, b, lfree, mon, lsf, qf];
fodo2si = [mqf, qf, lfree, lqd, b, fliplr(lcv), mon, lsich, qf];
fodo1ki = [mqf, qf, lki, lfree, b, lfree, mon, lsf, qf];
boosinj = [fodo1sd, fodo2ke, fodo1se, fodo2si, fodo1ki, fodo2sd, fodo1, fodo2, fodo1, fodo2];

% RF section
fodo1rf = [mqf, qf, lfree, RFC, lfree, b, lfree, mon, lsf, qf];
boosrf  = [fodo1sd, fodo2, fodo1, fodo2, fodo1rf, fodo2sd, fodo1, fodo2, fodo1, fodo2];

boocor  = [inicio, boosinj, boos, boosrf, boos, boos, fim];


%%% TAIL SECTION %%%

elist = boocor;
THERING = buildlat(elist);
% mbegin = findcells(THERING, 'FamName', 'BEGIN');
% if ~isempty(mbegin), THERING = circshift(THERING, [0 -(mbegin(1)-1)]); end
% THERING{end+1} = struct('FamName','END','Length',0,'PassMethod','IdentityPass');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);


% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'CAV');
THERING{rf_idx}.Frequency = rev_freq * harmonic_number;


% Ajusta NumIntSteps
THERING = set_num_integ_steps(THERING);

% Define Camara de Vacuo
THERING = set_vacuum_chamber(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

r = THERING;


function the_ring = set_vacuum_chamber(the_ring0)

% y = +/- y_lim * sqrt(1 - (x/x_lim)^n);

the_ring = the_ring0;
bends_vchamber = [0.0117 0.0117 1]; % n = 100: ~rectangular
other_vchamber = [0.018  0.018  1];   % n = 1;   circular/eliptica

bends = findcells(the_ring, 'BendingAngle');
other = setdiff(1:length(the_ring), bends);

for i=1:length(bends)
    the_ring{bends(i)}.VChamber = bends_vchamber;
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

dl = 0.03;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);


