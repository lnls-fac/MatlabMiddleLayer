function r = sirius_si_lattice(varargin)
% 2012-08-28 Nova rede - Ximenes.

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'AC10';
harmonic_number = 864;

% processamento de input (energia e modo de opera??????o)
for i=1:length(varargin)
    if ischar(varargin{i})
        mode = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

fprintf(['   Loading lattice SIRIUS_V402 - ' mode ' - ' num2str(energy/1e9) ' GeV' '\n']);


% carrega for???as dos im???s de acordo com modo de opera??????o
if strcmpi(mode, 'AC20')
    mode_version = 'AC20_2'; % usado em 'set_magnet_strengths_AC20
    set_magnet_strengths_AC20;
elseif strcmpi(mode, 'AC10')
    mode_version = 'AC10_4'; % usado em 'set_magnet_strengths_AC10
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
dia      = drift('dia', 3.219200, 'DriftPass');
dib      = drift('dib', 2.909200, 'DriftPass');
d10      = drift('d10', 0.100000, 'DriftPass');
d11      = drift('d11', 0.110000, 'DriftPass');
d12      = drift('d12', 0.120000, 'DriftPass');
d13      = drift('d13', 0.130000, 'DriftPass');
d15      = drift('d15', 0.150000, 'DriftPass');
d17      = drift('d17', 0.170000, 'DriftPass');
d18      = drift('d18', 0.180000, 'DriftPass');
d19      = drift('d19', 0.190000, 'DriftPass');
d20      = drift('d20', 0.200000, 'DriftPass');
d22      = drift('d22', 0.220000, 'DriftPass');
d23      = drift('d23', 0.230000, 'DriftPass');
d26      = drift('d26', 0.260000, 'DriftPass');
d32      = drift('d32', 0.320000, 'DriftPass');
d46      = drift('d46', 0.460000, 'DriftPass');
d56      = drift('d56', 0.560000, 'DriftPass');

% --- markers ---
mc       = marker('mc',     'IdentityPass');
mia      = marker('mia',    'IdentityPass');
mib      = marker('mib',    'IdentityPass');
mb1      = marker('mb1',    'IdentityPass');
mb2      = marker('mb2',    'IdentityPass');
mb3      = marker('mb3',    'IdentityPass');
inicio   = marker('inicio', 'IdentityPass');
fim      = marker('fim',    'IdentityPass');

% --- beam position monitors ---
mon      = marker('BPM', 'IdentityPass');

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


% -- b1 --
dip_nam =  'b1';
dip_len =  0.828080;
dip_ang =  2.766540 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B1      = [h1 mb1 h2];

% -- b2 --
dip_nam =  'b2';
dip_len =  1.228262;
dip_ang =  4.103510 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B2      = [h1 mb2 h2];

% -- b3 --
dip_nam =  'b3';
dip_len =  0.428011;
dip_ang =  1.429950 * deg_2_rad;
dip_K   = -0.78;
dip_S   =  0.00;
h1      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
h2      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);                    
B3      = [h1 mb3 h2];

% -- bc --
dip_nam =  'bc';
dip_len =  0.125394;
dip_ang =  1.4 * deg_2_rad;
dip_K   =  0.00;
dip_S   = -18.93;
bce     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
bcs     = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);
BC      = [bce mc bcs];
                    
% --- correctors ---
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



%%% --- lines ---
% dispi  = [ b1, d32, cv, d12, ch, d15, sd1, d17, qf1, d12, mon, d11, ...
%            sf1, d20, qf2, d17, sd2, d12, ch, d10, mon, d10, b2, d18, cv, d26, ...
%            sd3, d17, qf3, d12, mon, d11, sf2, d20, qf4, d15, ch, d46, mon, d10, ...
%            b3, d13, bce ];
%       
% dispc  = [ bcs, d13, b3, d56, ch, d15, qf4, d20, sf2, d11, mon, d12, ...
%            qf3, d17, sd3, d26, cv, d18, b2, d20, ch, d12, sd2, d17, qf2, d20, ...
%            sf1, d11, mon, d12, qf1, d17, sd1, d15, ch, d12, cv, d22, mon, d10, ...
%            b1 ];
%       
% insa   = [ dia, mon, d12, cv, d12, ch, d12, sa2, d17, qaf, d23, qad, ...
%            d17, sa1, d17 ];
%       
% insb   = [ dib, mon, d10, qbd2, d19, cv, d12, ch, d12, sb2, d17, qbf, ...
%            d23, qbd1, d17, sb1, d17 ];
% hsupia = [insa, dispi];
% hsupca = [dispc, fliplr(insa)];
% hsupib = [insb, dispi];
% hsupcb = [dispc, fliplr(insb)];
% supab  = [hsupia, mc, hsupcb];
% supba  = [hsupib, mc, hsupca];
% anelab = [mia, supab, mib, supba];
% anel   = [inicio, anelab, anelab, anelab, anelab, anelab, anelab, anelab, anelab, anelab, anelab, cav, fim];


%% lines 

cline1 = [ d32, cv, d12, ch,  d15, sd1, d17, qf1, d12, mon, d11, sf1, d20, qf2, d17, sd2, d12, ch, d10, mon, d10 ];
cline2 = [ d18, cv, d26, sd3, d17, qf3, d12, mon, d11, sf2, d20, qf4, d15, ch,  d46, mon, d10 ];
cline3 = [ d56, ch, d15, qf4, d20, sf2, d11, mon, d12, qf3, d17, sd3, d26, cv,  d18 ];
cline4 = [ d20, ch, d12, sd2, d17, qf2, d20, sf1, d11, mon, d12, qf1, d17, sd1, d15, ch, d12, cv, d22, mon, d10 ];
insa   = [ dia, mon, d12, cv, d12, ch, d12, sa2, d17, qaf, d23, qad, d17, sa1, d17 ];
insb   = [ dib, mon, d10, qbd2, d19, cv, d12, ch, d12, sb2, d17, qbf, d23, qbd1, d17, sb1, d17 ];
B3BCB3 = [ B3, d13, BC, d13, B3 ];     


%% the_ring

% Lattice Ordering
% ----------------
% 
% R01 C01 R02 C02 R03 C03 R04 C04 R05 C05 R06 C06 R07 C07 R08 C08 R09 C09 R10 C10
% R11 C11 R12 C12 R13 C13 R14 C14 R15 C15 R16 C16 R17 C17 R18 C18 R19 C19 R20 C20
% 
% High Beta (mia) : R01, R03, R05, R07, R09, R11, R13, R15, R17, R19
% Low  Beta (mib) : R02, R04, R06, R08, R10, R12, R14, R16, R18, R20
%
% injection: straight section R01
% cavities:  straight section R03

R01 = [fliplr(insa) fim inicio mia insa];  % injection sector, marker of the lattice model starting element
R03 = [fliplr(insa) mia cav insa];         % sector with cavities
R05 = [fliplr(insa) mia insa];
R07 = [fliplr(insa) mia insa];
R09 = [fliplr(insa) mia insa];
R11 = [fliplr(insa) mia insa];
R13 = [fliplr(insa) mia insa];
R15 = [fliplr(insa) mia insa];
R17 = [fliplr(insa) mia insa];
R19 = [fliplr(insa) mia insa];

R02 = [fliplr(insb) mib insb];
R04 = [fliplr(insb) mib insb];
R06 = [fliplr(insb) mib insb];
R08 = [fliplr(insb) mib insb];
R10 = [fliplr(insb) mib insb];
R12 = [fliplr(insb) mib insb];
R14 = [fliplr(insb) mib insb];
R16 = [fliplr(insb) mib insb];
R18 = [fliplr(insb) mib insb];
R20 = [fliplr(insb) mib insb];

C01 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C02 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C03 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C04 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C05 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C06 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C07 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C08 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C09 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C10 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C11 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C12 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C13 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C14 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C15 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C16 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C17 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C18 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C19 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];
C20 = [ B1 cline1 B2 cline2 B3BCB3 cline3 B2 cline4 B1 ];

anel = [ ...
    R01 C01 R02 C02 R03 C03 R04 C04 R05 C05 ...
    R06 C06 R07 C07 R08 C08 R09 C09 R10 C10 ...
    R11 C11 R12 C12 R13 C13 R14 C14 R15 C15 ...
    R16 C16 R17 C17 R18 C18 R19 C19 R20 C20 ...
];


%% finalization 

elist = anel;
THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'inicio');
THERING = [THERING(idx:end) THERING(1:idx-1)];

% checa se h??? elementos com comprimentos negativos
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% Imprime vers???o do modo
fprintf(['   Mode Version: ' mode_version '\n']);

% Ajuste de frequ???ncia de RF de acordo com comprimento total e n???mero harm???nico
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
rev_freq    = const.c / L0_tot;
rf_idx      = findcells(THERING, 'FamName', 'cav');
THERING{rf_idx}.Frequency = rev_freq * harmonic_number;
setcavity('on'); 
setradiation('off');

% Ajusta NumIntSteps
THERING = set_num_integ_steps(THERING);

% Define C???mara de V???cuo
THERING = set_vacuum_chamber(THERING);


% pr???-carrega passmethods de forma a evitar problema com bibliotecas rec???m-compiladas
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
