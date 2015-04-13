function r = sirius_si_lattice(varargin)
% 2012-08-28 Nova rede - Ximenes.

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'AC20';
const  = lnls_constants;
harmonic_number = 864;

% processamento de input (energia e modo de opera��o)
for i=1:length(varargin)
    if ischar(varargin{i})
        mode = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

fprintf(['   Loading lattice SIRIUS_V100 - ' mode ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega for�as dos im�s de acordo com modo de opera��o
if strcmpi(mode, 'AC20')
    set_magnet_strengths_AC20;
elseif strcmpi(mode, 'AC10')
    set_magnet_strengths_AC10;
end


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
%quad_pass_method = 'QuadLinearPass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========

% --- drift spaces ---
lia2     = drift('lia2', 3.514100, 'DriftPass');
lia1     = drift('lia1', 0.170000, 'DriftPass');
lib      = drift('lib',  2.994100, 'DriftPass');
l32      = drift('l32',  0.380000, 'DriftPass');
l31      = drift('l31',  0.170000, 'DriftPass');
l2       = drift('l2',   0.080000, 'DriftPass');
l12      = drift('l12',  0.120000, 'DriftPass');
l11      = drift('l11',  0.170000, 'DriftPass');
lc11     = drift('lc11', 0.290000, 'DriftPass');
lc12     = drift('lc12', 0.170000, 'DriftPass');
lc21     = drift('lc21', 0.170000, 'DriftPass');
lc22     = drift('lc22', 0.170000, 'DriftPass');
lc31     = drift('lc31', 0.290000, 'DriftPass');
lc32     = drift('lc32', 0.170000, 'DriftPass');
lc4      = drift('lc4',  0.410000, 'DriftPass');
lq       = drift('lq',   0.215000, 'DriftPass');
lq1      = drift('lq1',  0.107500, 'DriftPass');
lq2      = drift('lq2',  0.107500, 'DriftPass');
lb       = drift('lb',   0.080000, 'DriftPass');
lbpm     = drift('lb',   0.050000, 'DriftPass');
lcor     = drift('lb',   0.150000, 'DriftPass');

% --- markers ---
mc       = marker('mc',    'IdentityPass');
mia      = marker('mia',   'IdentityPass');
mib      = marker('mcib',  'IdentityPass');
inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');


% --- beam position monitors ---
mon      = marker('bpm', 'IdentityPass');

% --- quadrupoles ---
qaf      = quadrupole('qaf',  0.340000, qaf_strength,  quad_pass_method);
qad      = quadrupole('qad',  0.140000, qad_strength,  quad_pass_method);
qbd2     = quadrupole('qbd2', 0.140000, qbd2_strength, quad_pass_method);
qbf      = quadrupole('qbf',  0.340000, qbf_strength,  quad_pass_method);
qbd1     = quadrupole('qbd1', 0.140000, qbd1_strength, quad_pass_method);
qf1      = quadrupole('qf1',  0.250000, qf1_strength,  quad_pass_method);
qf2      = quadrupole('qf2',  0.250000, qf2_strength,  quad_pass_method);
qf3      = quadrupole('qf3',  0.250000, qf3_strength,  quad_pass_method);
qf4      = quadrupole('qf4',  0.250000, qf4_strength,  quad_pass_method);


% --- bending magnets --- 
deg_2_rad = (pi/180);
b1       = rbend_sirius('b1', 0.833080, 2.766540 * deg_2_rad, 1 * 1.383270 * deg_2_rad, 1 * 1.383270 * deg_2_rad, 0, 0, 0, [0 0], [0 -0.78], bend_pass_method);
b2       = rbend_sirius('b2', 1.240266, 4.118740 * deg_2_rad, 1 * 4.118740 * deg_2_rad, 0 * 4.118740 * deg_2_rad, 0, 0, 0, [0 0], [0 -0.78], bend_pass_method);
b3       = rbend_sirius('b3', 0.426011, 1.414720 * deg_2_rad, 1 * 1.414720 * deg_2_rad, 0 * 1.414720 * deg_2_rad, 0, 0, 0, [0 0], [0 -0.78], bend_pass_method);
bce      = rbend_sirius('bc', 0.062697, 0.700000 * deg_2_rad, 1 * 0.700000 * deg_2_rad, 0 * 0.700000 * deg_2_rad, 0, 0, 0, [0 0 0], [0 0 -18.93], bend_pass_method);
bcs      = rbend_sirius('bc', 0.062697, 0.700000 * deg_2_rad, 0 * 0.700000 * deg_2_rad, 1 * 0.700000 * deg_2_rad, 0, 0, 0, [0 0 0], [0 0 -18.93], bend_pass_method);
           
           
% --- correctors ---
%cor     = corrector('cm',   0, [0 0], 'CorrectorPass');
ch     = corrector('hcm',  0, [0 0], 'CorrectorPass');
cv     = corrector('vcm',  0, [0 0], 'CorrectorPass');

% --- sextupoles ---    
sa1      = sextupole('sa1', 0.150000, sa1_strength, sext_pass_method);
sa2      = sextupole('sa2', 0.150000, sa2_strength, sext_pass_method);
sb1      = sextupole('sb1', 0.150000, sb1_strength, sext_pass_method);
sb2      = sextupole('sb2', 0.150000, sb2_strength, sext_pass_method);
sd1      = sextupole('sd1', 0.150000, sd1_strength, sext_pass_method);
sf1      = sextupole('sf1', 0.150000, sf1_strength, sext_pass_method);
sd2      = sextupole('sd2', 0.150000, sd2_strength, sext_pass_method);
sd3      = sextupole('sd3', 0.150000, sd3_strength, sext_pass_method);
sf2      = sextupole('sf2', 0.150000, sf2_strength, sext_pass_method);
           
% --- rf cavity ---
cav = rfcavity('cav', 0, 2.5e6, 500e6, harmonic_number, 'CavityPass');


%% transport lines
dispi  = [b1, lcor, cv, lc11, ch, lcor, sd1, lc12, qf1, lq1, mon, lq2, sf1, lq, qf2, lc21, ...
         sd2, lcor, ch, lc22, b2, lcor, cv, lc31, sd3, lc32, qf3, lq1, mon, lq2, sf2, lq, qf4,...
         lcor, ch, lc4, cv, lcor, b3, lb, mon, lbpm, bce, mc];
     
dispc  = [mc, bcs, lbpm, lb, b3, lcor, cv, lc4, ch, lcor, qf4, lq, sf2, lq2, mon, lq1, qf3, lc32,...
         sd3, lc31, cv, lcor, b2, lc22, ch, lcor, sd2, lc21, qf2, lq, sf1, lq2, mon, lq1, qf1,...
         lc12, sd1, lcor, ch, lc11, cv, lcor, b1];
     
insa   = [mia, lia2, mon, lbpm, sa2, lia1, qaf, l2, ch, lcor, qad, lbpm, mon, l12, sa1, l11];
insb   = [mib, lib, qbd2, lbpm, mon, l32, sb2, l31, qbf, l2, ch, lcor, qbd1, lbpm, mon, l12, sb1, l11];

hsupia = [insa, dispi];
hsupca = [dispc, fliplr(insa)];
hsupib = [insb, dispi];
hsupcb = [dispc, fliplr(insb)];
supab  = [hsupia, hsupcb];
supba  = [hsupib, hsupca];
anelab = [supab, supba];
anel   = [inicio, repmat(anelab, 1, 10), cav, fim];
 



%% finalization 

elist = anel;
THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% checa se h� elementos com comprimentos negativos
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% Ajuste de frequ�ncia de RF de acordo com comprimento total e n�mero harm�nico
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'cav');
THERING{rf_idx}.Frequency = rev_freq * harmonic_number;
setcavity('on'); 
setradiation('off');

% Ajusta NumIntSteps
THERING = set_num_integ_steps(THERING);

% Define C�mara de V�cuo
THERING = set_vacuum_chamber(THERING);


% pr�-carrega passmethods de forma a evitar problema com bibliotecas rec�m-compiladas
lnls_preload_passmethods;


r = THERING;


function the_ring = set_vacuum_chamber(the_ring0)

% y = +/- y_lim * sqrt(1 - (x/x_lim)^n);

the_ring = the_ring0;
bends_vchamber = [0.014 0.014 100]; % n = 100: rectangular
other_vchamber = [0.014 0.014 1];   % n = 1;   circular
ivu_vchamber   = [0.014 0.014 1];   

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

dl = 0.05;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
