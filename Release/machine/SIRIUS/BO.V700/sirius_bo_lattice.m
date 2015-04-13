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
RFC = rfcavity('cav', 0, 1.0e+6, 499654000, harmonic_number, 'CavityPass');

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';

B_length = 1.1520;
B_angle  = 360 / 50;
B_gap    = 0.028;
B_fint1  = 0.0;
B_fint2  = 0.0;
B_edge   = (B_angle/2)*(pi/180)*0;

%carrega as forcas dos magnetos;
set_magnets_strength_booster;

%qd   = quadrupole('QD', 0.20, qd_strength, quad_pass_method);
hqd   = quadrupole('QD', 0.10, qd_strength, quad_pass_method);
mqd   = marker('MQD', 'IdentityPass');
qd    = [hqd mqd hqd];

qf   = quadrupole('QF', 0.10, qf_strength, quad_pass_method);
mqf   = marker('MQF', 'IdentityPass');

%sf = sextupole('SF', 0.20, sf_strength, sext_pass_method);
hsf = sextupole('SF', 0.10, sf_strength, sext_pass_method);
msf = marker('MSF', 'IdentityPass');
sf  = [hsf msf hsf];

%sd = sextupole('SD', 0.20, sd_strength, sext_pass_method);
hsd = sextupole('SD', 0.10, sd_strength, sext_pass_method);
msd = marker('MSD', 'IdentityPass');
sd  = [hsd msd hsd];


mb = multipole('B', 0.0, [0 0 0 0],[0 mb_quad mb_sext 0], 'ThinMPolePass');

inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');
inj      = marker('inj', 'IdentityPass');
mon      = marker('BPM', 'IdentityPass');
kick_ex  = marker('kick_ex', 'IdentityPass');
sept_ex  = marker('sept_ex', 'IdentityPass');

           
%tirei os edge_fringe para ficar compativel com o tracy3. La, o passmethod
%contempla a funcao que aplica a focalizacao, mas a rotina que le a rede
%nao le esses parametros.
% bd = rbend_sirius('B', B_length, B_angle*(pi/180), B_edge, B_edge, ...
%     B_gap, B_fint1, B_fint2, [0 0 0 0], [0, B_strength, B_sext, 0], bend_pass_method);
% b = [mb,bd,mb];

b1 = rbend_sirius('B', B_length/2, B_angle*(pi/180)/2, B_edge, 0*B_edge, ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0, B_strength, B_sext, 0], bend_pass_method);
b2 = rbend_sirius('B', B_length/2, B_angle*(pi/180)/2, 0*B_edge, B_edge, ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0, B_strength, B_sext, 0], bend_pass_method);
mbd = marker('MB', 'IdentityPass');
b = [mb, b1, mbd, b2, mb];


ch = corrector('HCM', 0, [0 0], 'CorrectorPass');
cv = corrector('VCM', 0, [0 0], 'CorrectorPass');

hlt      = drift('hlt',  2.146000/2, 'DriftPass');
l20      = drift('l20',  0.200000, 'DriftPass');
l25      = drift('l25',  0.250000, 'DriftPass');
l30      = drift('l30',  0.300000, 'DriftPass');
l55      = drift('l55',  0.550000, 'DriftPass');
lm25     = drift('lm25', 1.896000, 'DriftPass');
lm30     = drift('lm30', 1.846000, 'DriftPass');
lm40     = drift('lm40', 1.746000, 'DriftPass');
lm45     = drift('lm45', 1.696000, 'DriftPass');
lm55     = drift('lm55', 1.596000, 'DriftPass');

kick_in  = drift('kick_in', 0.200, 'DriftPass');
lm90     = drift('lm70', 1.246000, 'DriftPass');

sept_in  = drift('sept_in', 0.400, 'DriftPass');
lm95     = drift('lm55', 1.196000, 'DriftPass');

mlt      = marker('mlt', 'IdentityPass');


lfree   = [hlt mlt hlt];

lqd     = [lm45, qd, l25];
lsd     = [lm45, sd, l25];
lsf     = [lm40, sf, l20];
lch     = [lm25, ch, l25];
lcv     = [lm30, cv, l30];
lke     = [l55, kick_ex, lm55];
lse     = [l30, sept_ex, lm30];
lsich   = [lm95, sept_in, l30, ch, l25];
lkisf   = [lm90, kick_in, l30, sf, l20];
fodo1   = [mqf, qf, lfree, lfree, b, lfree, mon, lsf, qf];
fodo2   = [mqf, qf, lfree, lqd, b, fliplr(lcv), mon, lch, qf];
fodo1sd = [mqf, qf, lfree, lsd, b, lfree, mon, lsf, qf];
fodo2ke = [mqf, qf, lke, lqd, b, fliplr(lcv), mon, lch, qf];
fodo1se = [mqf, qf, lse, lfree, b, lfree, mon, lsf, qf];
fodo2si = [mqf, qf, lfree, lqd, b, inj, fliplr(lcv), mon, lsich, qf];
fodo1ki = [mqf, qf, lfree, lfree, b, lfree, mon, lkisf, qf];
fodo1rf = [mqf, qf, lfree, RFC, lfree, b, lfree, mon, lsf, qf];
boos    = [fodo1sd, fodo2, fodo1, fodo2, fodo1, fodo2, fodo1, fodo2, fodo1, fodo2];
boosrf  = [fodo1sd, fodo2, fodo1, fodo2, fodo1rf, fodo2, fodo1, fodo2, fodo1, fodo2];
boosinj = [fodo1sd, fodo2ke, fodo1se, fodo2si, fodo1ki, fodo2, fodo1, fodo2, fodo1, fodo2];
boocor  = [inicio, boosinj, boos, boosrf, boos, boos, fim];


%%% TAIL SECTION %%%

elist = boocor;
THERING = buildlat(elist);
mbegin = findcells(THERING, 'FamName', 'BEGIN');
if ~isempty(mbegin), THERING = circshift(THERING, [0 -(mbegin(1)-1)]); end
THERING{end+1} = struct('FamName','END','Length',0,'PassMethod','IdentityPass');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);


% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'cav');
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
