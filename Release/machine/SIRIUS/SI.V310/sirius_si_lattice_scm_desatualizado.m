function r = sirius_si_lattice_scm(varargin)
% 2012-08-28 Nova rede - Ximenes.
% 2012-10-29 Modifica��o para incluir corretores skew fora dos sextupolos.
%   Afonso

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

fprintf(['   Loading lattice SIRIUS_V200 - ' mode ' - ' num2str(energy/1e9) ' GeV' '\n']);


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
dia      = drift('dia', 3.329200, 'DriftPass');
dib      = drift('dib', 2.909200, 'DriftPass');
d01      = drift('d01', 0.010000, 'DriftPass');
d02      = drift('d02', 0.020000, 'DriftPass');
d03      = drift('d03', 0.030000, 'DriftPass');
d04      = drift('d04', 0.040000, 'DriftPass');
d05      = drift('d05', 0.050000, 'DriftPass');
d06      = drift('d06', 0.060000, 'DriftPass');
d07      = drift('d07', 0.070000, 'DriftPass');
d08      = drift('d08', 0.080000, 'DriftPass');
d09      = drift('d09', 0.090000, 'DriftPass');
d10      = drift('d10', 0.100000, 'DriftPass');
d15      = drift('d15', 0.150000, 'DriftPass');
d17      = drift('d17', 0.170000, 'DriftPass');
d20      = drift('d20', 0.200000, 'DriftPass');
d30      = drift('d30', 0.300000, 'DriftPass');
d50      = drift('d50', 0.500000, 'DriftPass');
dq       = drift('dq', 0.107500, 'DriftPass');

% --- markers ---
mc       = marker('mc',    'IdentityPass');
mia      = marker('mia',   'IdentityPass');
mib      = marker('mib',  'IdentityPass');
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

% --- skew quadrupoles ---
scm1     = quadrupole('scm1', 0.090000, 0, quad_pass_method);
scm2     = quadrupole('scm2', 0.090000, 0, quad_pass_method);
scm3     = quadrupole('scm3', 0.090000, 0, quad_pass_method);
scm4     = quadrupole('scm4', 0.090000, 0, quad_pass_method);
scm5     = quadrupole('scm5', 0.090000, 0, quad_pass_method);


% --- bending magnets --- 
deg_2_rad = (pi/180);


% -- b1 --
dip_nam =  'b1';
dip_len =  0.828080;
dip_ang =  2.766540 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
mdip    = marker(['m' dip_nam], 'IdentityPass');
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
b1      = [h1 mdip h2];

% -- b2 --
dip_nam =  'b2';
dip_len =  1.228262;
dip_ang =  4.103510 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
mdip    = marker(['m' dip_nam], 'IdentityPass');
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
b2      = [h1 mdip h2];

% -- b3 --
dip_nam =  'b3';
dip_len =  0.428011;
dip_ang =  1.429950 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
mdip    = marker(['m' dip_nam], 'IdentityPass');
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
b3      = [h1 mdip h2];

% -- bc --
bce      = rbend_sirius('bc', 0.062697, 0.700000 * deg_2_rad, 1 * 0.700000 * deg_2_rad, ...
    0 * 0.700000 * deg_2_rad, 0, 0, 0, [0 0 0], [0 0 -18.93], bend_pass_method);
bcs      = rbend_sirius('bc', 0.062697, 0.700000 * deg_2_rad, 0 * 0.700000 * deg_2_rad, ...
                        1 * 0.700000 * deg_2_rad, 0, 0, 0, [0 0 0], [0 0 -18.93], bend_pass_method);
           
           
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
dispi  = [b1, lcor, cv, ls21, scm2, ls21, ch, lcor, mon, lbpm, sd1, lc12, qf1, ...
          lq1, mon, lq2, sf1, lq, qf2, lc21, sd2, lcor, ch, lc22, b2, lcor, ...
          cv, ls31, scm3, ls32, mon, lbpm, sd3, lc32, qf3, lq1, lq2, sf2, lq, qf4, ...
          lcor, ch, ls41, scm4, ls42, b3, lb, mon, lbpm, bce];
     
dispc  = [bcs, lbpm, lb, b3, ls42, scm4, ls41, ch, lcor, qf4, lq, ...
          sf2, lq2, lq1, qf3, lc32, sd3, lbpm, mon, ls32, scm3, ls31, cv, lcor, b2, ...
          lc22, ch, lcor, sd2, lc21, qf2, lq, sf1, lq2, mon, lq1, qf1, lc12, ...
          sd1, lbpm, mon, lcor, ch, ls21, scm2, ls21, cv, lcor, b1];
     
insa   = [lia2, scm1, ls11, mon, lbpm, cv, lcor, sa2, lia1, qaf, l2, ch, l2, qad, l12, sa1, l11];
insb   = [lib, mon, lbpm, qbd2, ls52, scm5, ls51, cv, lcor, sb2, l31, qbf, l2, ch, l2, ...
          qbd1, l12, sb1, l11];

hsupia = [insa, dispi];
hsupca = [dispc, fliplr(insa)];
hsupib = [insb, dispi];
hsupcb = [dispc, fliplr(insb)];
supab  = [hsupia, mc, hsupcb];
supba  = [hsupib, mc, hsupca];
anelab = [mia, supab, mib, supba];
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
bends_vchamber = [0.014 0.014 100]; % n = 100: ~rectangular
other_vchamber = [0.014 0.014 1];   % n = 1;   circular/eliptica
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

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', sexts, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
