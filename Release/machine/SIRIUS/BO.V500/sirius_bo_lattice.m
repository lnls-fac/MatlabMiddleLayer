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
B_gap    = 0.025;
B_fint1  = 0.0;
B_fint2  = 0.0;

%carrega as forcas dos magnetos;
set_magnets_strength_booster;

qd   = quadrupole('QD', 0.10, qd_strength, quad_pass_method);
qf   = quadrupole('QF', 0.10, qf_strength, quad_pass_method);

sf = sextupole('SF', 0.10, sf_strength, sext_pass_method);
sd = sextupole('SD', 0.10, sd_strength, sext_pass_method);

inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');
inj      = marker('inj', 'IdentityPass');
mon      = marker('BPM', 'IdentityPass');
           
%tirei os edge_fringe para ficar compativel com o tracy3. La, o passmethod
%contempla a funcao que aplica a focalizacao, mas a rotina que le a rede
%nao le esses parametros.
b = rbend_sirius('B', B_length, B_angle*(pi/180), (B_angle/2)*(pi/180), (B_angle/2)*(pi/180), ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0 B_strength B_sext 0], bend_pass_method);

ch = corrector('HCM', 0, [0 0], 'CorrectorPass');
cv = corrector('VCM', 0, [0 0], 'CorrectorPass');

lt       = drift('LT', 2.146, 'DriftPass');
ls       = drift('LS', 1.896, 'DriftPass');
lq       = drift('LQ', 1.896, 'DriftPass');
lc       = drift('LC', 1.946, 'DriftPass');
lcs      = drift('LCS', 1.746, 'DriftPass');
l15      = drift('L15', 0.15, 'DriftPass');
l20      = drift('L20', 0.20, 'DriftPass');

lfree   = [lt];
lqd     = [lq, qd, l15];
lsd     = [ls, sd, l15];
lsf     = [ls, sf, l15];
lch     = [lc, l20];
lcv     = [lc, l20];
fodo    = [qf, lfree, lfree, b, lfree, lfree, qf];
fodo1   = [qf, lfree, lfree, b, lfree, mon, ch, cv, lsf, qf];
fodo2   = [qf, lfree, lqd, b, fliplr(lcv), mon, lch, qf];
fodo1m  = [qf, lfree, lsd, b, lfree, mon, ch, cv, lsf, qf];
boos    = [fodo1, fodo2, fodo1, fodo2, fodo1m, fodo2, fodo1, fodo2, fodo1, fodo2];
booster = [inicio, boos, boos, boos, boos, boos, RFC, fim];


%%% TAIL SECTION %%%

elist = booster;
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

% Define C?mara de V?cuo
THERING = set_vacuum_chamber(THERING);

% pr?-carrega passmethods de forma a evitar problema com bibliotecas rec?m-compiladas
lnls_preload_passmethods;

r = THERING;


function the_ring = set_vacuum_chamber(the_ring0)

% y = +/- y_lim * sqrt(1 - (x/x_lim)^n);

the_ring = the_ring0;
bends_vchamber = [0.011 0.011 1]; % n = 100: ~rectangular
other_vchamber = [0.0175 0.0175 1];   % n = 1;   circular/eliptica
ivu_vchamber   = [0.0175 0.0175 1];   

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

dl = 0.03;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
