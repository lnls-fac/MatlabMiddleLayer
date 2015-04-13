function r = sirius_bo_lattice(varargin)
%m?quina com simetria 48, formada por dipolos e quadrupolos com sextupolos
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

%carrega as forças dos magnetos;
set_magnets_strength_booster;

qd   = quadrupole('QD', 0.10, qd_strength, quad_pass_method);
qf   = quadrupole('QF', 0.15, qf_strength, quad_pass_method);

sf = sextupole('SF', 0.15, sf_strength, sext_pass_method);
sd = sextupole('SD', 0.15, sd_strength, sext_pass_method);

inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');
inj      = marker('inj', 'IdentityPass');
mon      = marker('BPM', 'IdentityPass');
           
%tirei os edge_fringe para ficar compatível com o tracy3. Lá, o passmethod
%contempla a função que aplica a focalização, mas a rotina que lê a rede
%não lê esses parâmetros.
bi = rbend_sirius('B', B_length/2, (B_angle/2)*(pi/180), 1*(B_angle/2)*(pi/180), 0, ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0 B_strength B_sext 0], bend_pass_method);

bf = rbend_sirius('B', B_length/2, (B_angle/2)*(pi/180), 0, 1*(B_angle/2)*(pi/180), ...
    B_gap, B_fint1, B_fint2, [0 0 0 0], [0 B_strength B_sext 0], bend_pass_method);

b = [bi bf];

ch = corrector('HCM', 0, [0 0], 'CorrectorPass');
cv = corrector('VCM', 0, [0 0], 'CorrectorPass');


lf = drift('LF', 1.97100, 'DriftPass');
lfs = drift('LFS', 1.82100, 'DriftPass');
ld = drift('LD', 0.200000, 'DriftPass');
ls = drift('LS', 0.15000, 'DriftPass');

fodo    = [qf, ls, ch, lf, mon, lf, cv, ls, b, ls, lf, lf, ls, qf];    
fodod   = [qf, ls, ch, lf, mon, lf, cv, ls, b, ld, qd, lf, lf, qf];
fodosf  = [qf, ls, sf, ls, ch, lfs, mon, lfs, cv, ls, b, ls, lf, lf, ls, qf];
fodosd  = [qf, ls, ch, lfs, mon, lfs, cv, ls, sd, ls, b, ls, lf, lf, ls, qf];
BOOS    = [fodod, fodosd, fodod, fodosf, fodod, fodosd, fodod, fodo, fodod, fodo];
BOOSTER = [inicio BOOS BOOS BOOS BOOS BOOS RFC fim];

%%% TAIL SECTION %%%

elist = BOOSTER;
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

% Insert sextupole in the qf family
qfind = findcells(THERING, 'FamName', 'QF');
THERING = setcellstruct(THERING, 'PolynomB', qfind, qf_sext, 3);

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
