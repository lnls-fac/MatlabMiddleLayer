function [r, lattice_title] = sirius_si_lattice(varargin)
% the_ring = sirius_si_lattice       : retorna o modelo atual do anel;
%
% the_ring = sirius_si_lattice(mode) : Ateh o momento, pode ser 'A', 'B' or 'C'(default).
%
% the_ring = sirius_si_lattice(mode,version): mode_version define o ponto de operacao 
%              e a otimizacao sextupolar a ser usada. Exemplos: '01', '02'...
% the_ring = sirius_si_lattice(mode,version, energy): energia em eV;
%
% [the_ring, title] = sirius_si_lattice(...): Also return the name of the
%                       lattice.
%
% Todos os inputs comutam e podem ser passados independentemente.
%
% 2012-08-28: nova rede. (xrr)
% 2013-08-08: inseri marcadores de IDs de 2 m nos trechos retos. (xrr)
% 2013-08-12: corretoras rapidas e atualizacao das lentas e dos BPMs (desenho CAD da Liu). (xrr)
% 2013-10-02: adicionei o mode_version como parametro de input. (Fernando)
% 2014-09-17: modificacao das corretoras para apenas uma par integrado de CV e CH rapidas e lentas no mesmo elemento. (Natalia) 
% 2014-10-07: atualizados nomes de alguns elementos. (xrr)

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'C';   % a = ac20, b = ac10(beta=4m), c = ac10(beta=1.5m)
version = '01';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V10';
% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i}) && length(varargin{i})==1
        mode = varargin{i};
    elseif ischar(varargin{i})
        version = varargin{i};
    elseif isa(varargin{i},'function_handle')
        strengths = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

lattice_title = [lattice_version '.' mode version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);

% carrega forcas dos imas de acordo com modo de operacao
strengths();

%% passmethods
%  ===========
bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========
% marker to define points where momentum acceptance will be calculated:
MOMACCEP = marker('calc_mom_accep', 'IdentityPass');     

% -- drifts --
LIA  = drift('lia2', 1.5679,'DriftPass');
LIB  = drift('lib2', 1.3279,'DriftPass');
L035 = drift('l035', 0.0350,'DriftPass');
L050 = drift('l050', 0.0500,'DriftPass');
L077 = drift('l077', 0.0770,'DriftPass');
L083 = drift('l083', 0.0830,'DriftPass');
L085 = drift('l085', 0.0850,'DriftPass');
L100 = drift('l100', 0.1000,'DriftPass');
L112 = drift('l112', 0.1120,'DriftPass');
L116 = drift('l116', 0.1160,'DriftPass');
L118 = drift('l118', 0.1180,'DriftPass');
L124 = drift('l124', 0.1240,'DriftPass');
L125 = drift('l125', 0.1250,'DriftPass');
L135 = drift('l135', 0.1350,'DriftPass');
L150 = drift('l150', 0.1500,'DriftPass');
L155 = drift('l155', 0.1550,'DriftPass');
L170 = drift('l170', 0.1700,'DriftPass');
L185 = drift('l185', 0.1850,'DriftPass');
L200 = drift('l200', 0.2000,'DriftPass');
L230 = drift('l230', 0.2300,'DriftPass');
L275 = drift('l275', 0.2750,'DriftPass');
L300 = drift('l300', 0.3000,'DriftPass');
L340 = drift('l340', 0.3400,'DriftPass');
L460 = drift('l460', 0.4600,'DriftPass');
L488 = drift('l488', 0.4880,'DriftPass');
L500 = drift('l500', 0.5000,'DriftPass');
L610 = drift('l610', 0.6100,'DriftPass');
L788 = drift('l788', 0.7880,'DriftPass');
L800 = drift('l800', 0.8000,'DriftPass');
L888 = drift('l888', 0.8880,'DriftPass');
LKK  = drift('lkk',  2.0250,'DriftPass');
LPMU = drift('lpmu', 0.3070,'DriftPass');
LPMD = drift('lpmd', 0.2359,'DriftPass');

% -- dipoles -- 
deg2rad = pi/180.0;

B1E = rbend_sirius('b1', 0.828/2,  2.7553*deg2rad/2, 1.4143*deg2rad/2, 0,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
MB1 = marker('mb1', 'IdentityPass');
B1S = rbend_sirius('b1', 0.828/2,  2.7553*deg2rad/2, 0, 1.4143*deg2rad/2,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
B1  = [MOMACCEP,B1E,MOMACCEP,MB1,B1S,MOMACCEP];


B2E = rbend_sirius('b2', 1.231/3, 4.0964*deg2rad/3, 1.4143*deg2rad/2, 0,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
B2M = rbend_sirius('b2', 1.231/3, 4.0964*deg2rad/3, 0, 0,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
B2S = rbend_sirius('b2', 1.231/3, 4.0964*deg2rad/3, 0, 1.4143*deg2rad/2,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
B2  = [MOMACCEP,B2E,MOMACCEP,B2M,MOMACCEP,B2S,MOMACCEP];

BC1  = rbend_sirius('bc_hf', 0.015, 0.2800*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.005 0], bend_pass_method); 
BC2  = rbend_sirius('bc_hf', 0.005, 0.0900*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.057 0], bend_pass_method); 
BC3  = rbend_sirius('bc_hf', 0.005, 0.0780*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.112 0], bend_pass_method); 
BC4  = rbend_sirius('bc_hf', 0.005, 0.0590*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.103 0], bend_pass_method); 
BC5  = rbend_sirius('bc_hf', 0.010, 0.0850*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.066 0], bend_pass_method); 
BC6  = rbend_sirius('bc_hf', 0.010, 0.0590*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.047 0], bend_pass_method); 
BC7  = rbend_sirius('bc_hf', 0.015, 0.0640*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.080 0], bend_pass_method); 
BC8  = rbend_sirius('bc_lf', 0.020, 0.0720*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.388 0], bend_pass_method); 
BC9  = rbend_sirius('bc_lf', 0.325/2, 1.2700/2*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.891 0], bend_pass_method); 
BC10 = rbend_sirius('bc_lf', 0.325/2, 1.2700/2*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.891 0], bend_pass_method); 
BC11 = rbend_sirius('bc_lf', 0.010, 0.0310*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.689 0], bend_pass_method); 
BC12 = rbend_sirius('bc_lf', 0.010, 0.0220*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.325 0], bend_pass_method); 
BC13 = rbend_sirius('bc_lf', 0.010, 0.0150*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.128 0], bend_pass_method); 
BC14 = rbend_sirius('bc_lf', 0.020, 0.0233*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0  0.009 0], bend_pass_method);

MC = marker('mc', 'IdentityPass');
BCE = [BC14, BC13, BC12, BC11, MOMACCEP, BC10, MOMACCEP, BC9,...
        MOMACCEP, BC8, BC7, BC6, BC5, BC4, BC3, BC2, BC1];
BCS = [BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, MOMACCEP, ...
        BC9, MOMACCEP, BC10, MOMACCEP, BC11, BC12, BC13, BC14];
BC  = [BCE,MC, MOMACCEP,BCS];

% -- quadrupoles --
QFA  = quadrupole('qfa',  0.200, qfa_strength,  quad_pass_method);
QDA  = quadrupole('qda',  0.140, qda_strength,  quad_pass_method);
QDB2 = quadrupole('qdb2', 0.140, qdb2_strength, quad_pass_method);
QFB  = quadrupole('qfb',  0.300, qfb_strength,  quad_pass_method);
QDB1 = quadrupole('qdb1', 0.140, qdb1_strength, quad_pass_method);
QF1  = quadrupole('qf1',  0.200, qf1_strength,  quad_pass_method);
QF2  = quadrupole('qf2',  0.200, qf2_strength,  quad_pass_method);
QF3  = quadrupole('qf3',  0.200, qf3_strength,  quad_pass_method);
QF4  = quadrupole('qf4',  0.200, qf4_strength,  quad_pass_method);

% -- sextupoles and slow correctors --
sext_len = 150 * 1e-3; 
SDA  = sextupole('sda' , sext_len, sda_strength , sext_pass_method); %
SFA  = sextupole('sfa' , sext_len, sfa_strength , sext_pass_method); % chs/cvs
SDB  = sextupole('sdb' , sext_len, sdb_strength , sext_pass_method); %
SFB  = sextupole('sfb' , sext_len, sfb_strength , sext_pass_method); % chs/cvs
SD1J = sextupole('sd1j', sext_len, sd1j_strength, sext_pass_method); % chs/cvs
SF1J = sextupole('sf1j', sext_len, sf1j_strength, sext_pass_method); %
SD2J = sextupole('sd2j', sext_len, sd2j_strength, sext_pass_method); % chs
SD3J = sextupole('sd3j', sext_len, sd3j_strength, sext_pass_method); % cvs
SF2J = sextupole('sf2j', sext_len, sf2j_strength, sext_pass_method); % chs
SD1K = sextupole('sd1k', sext_len, sd1k_strength, sext_pass_method); % chs/cvs
SF1K = sextupole('sf1k', sext_len, sf1k_strength, sext_pass_method); %
SD2K = sextupole('sd2k', sext_len, sd2k_strength, sext_pass_method); % chs
SD3K = sextupole('sd3k', sext_len, sd3k_strength, sext_pass_method); % cvs
SF2K = sextupole('sf2k', sext_len, sf2k_strength, sext_pass_method); % chs

% -- pulsed magnets --

KICKIN = sextupole('kick_in', 0.5, 0, sext_pass_method); % injection kicker
PMM    = sextupole('pmm',     0.5, 0, sext_pass_method); % pulsed multipole magnet

% -- bpms and fast correctors --
BPM    = marker('bpm', 'IdentityPass');
CF     = sextupole('cf', 0.100, 0.0, quad_pass_method);
RBPM   = marker('rbpm', 'IdentityPass');

% -- rf cavities --
RFC = rfcavity('cav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');

% -- lattice markers --
START  = marker('start',  'IdentityPass');     % start of the model
END    = marker('end',  'IdentityPass');       % end of the model
MIA    = marker('mia', 'IdentityPass');        % center of long straight sections (even-numbered)
MIB    = marker('mib', 'IdentityPass');        % center of short straight sections (odd-numbered)
GIR    = marker('girder', 'IdentityPass');     % marker used to delimitate girders. one marker at begin and another at end of girder.
MIDA   = marker('id_enda', 'IdentityPass');    % marker for the extremities of IDs in long straight sections
MIDB   = marker('id_endb', 'IdentityPass');    % marker for the extremities of IDs in short straight sections
SEPTIN = marker('eseptinf', 'IdentityPass');   % end of thin injection septum
DCCT1  = marker('dcct1', 'IdentityPass');      % dcct1 to measure beam current
DCCT2  = marker('dcct2', 'IdentityPass');      % dcct2 to measure beam current


%% transport lines

M2A = [GIR,CF,L085,SFA,L150,QFA,L124,BPM,L116,SDA,L150,QDA,GIR,L170,GIR];                           % high beta xxM2 girder  
M1A = fliplr(M2A);                                                                                  % high beta xxM1 girder
IDA = [L500,RBPM,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,RBPM,L500];                    % high beta ID straight section
CAV = [L500,RBPM,LIA,L500,L500,L500,MIA,RFC,L500,L500,L500,LIA,RBPM,L500];                          % high beta RF cavity straight section 
INJ = [L500,LIA,L500,L200,SEPTIN,L800,END,START,MIA,   LKK, KICKIN, LPMU, PMM, LPMD];          % high beta INJ straight section
M1B = [GIR,L170,GIR,QDB1,L150,SDB,L116,BPM,L124,QFB,L150,SFB,L050,CF,L035,QDB2,GIR];                % low beta xxM1 girder
M2B = fliplr(M1B);                                                                                  % low beta xxM2 girder
IDB = [L500,RBPM,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,RBPM,L500];                    % low beta ID straight section
C1A = [GIR,L610,GIR,SD1J,L170,QF1,L135, BPM,L125,SF1J,L230,QF2,L170,SD2J,GIR,L155,GIR,BPM,L185];    % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C2A = [GIR,L460,GIR,SD3J,L170,QF3,L083,CF,L077,SF2J,L118,BPM,L112,QF4,GIR,L788,GIR,BPM,RBPM,L100];  % arc sector in between B2-BC (high beta odd-numbered straight sections)
C3A = [GIR,L888,GIR,QF4,L112,RBPM,BPM,L118,SF2K,L077,CF,L083,QF3,L170,SD3K,GIR,L275,GIR,BPM,L185];  % arc sector in between BC-B2 (high beta odd-numbered straight sections)
C4A = [GIR,L340,GIR,SD2K,L170,QF2,L230,SF1K,L125,BPM,L135,QF1,L170,SD1K,GIR,L610,GIR];              % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C1B = [GIR,L610,GIR,SD1K,L170,QF1,L135, BPM,L125,SF1K,L230,QF2,L170,SD2K,GIR,L155,GIR,BPM,L185];    % arc sector in between B1-B2 (low beta even-numbered straight sections)
C2B = [GIR,L460,GIR,SD3K,L170,QF3,L083,CF,L077,SF2K,L118,BPM,L112,QF4,GIR,L788,GIR,BPM,RBPM,L100];  % arc sector in between B2-BC (low beta even-numbered straight sections)
C3B = [GIR,L888,GIR,QF4,L112,RBPM,BPM,L118,SF2J,L077,CF,L083,QF3,L170,SD3J,GIR,L275,GIR,BPM,L185];  % arc sector in between BC-B2 (low beta even-numbered straight sections)
C4B = [GIR,L340,GIR,SD2J,L170,QF2,L230,SF1J,L125,BPM,L135,QF1,L170,SD1J,GIR,L610,GIR];              % arc sector in between B2-B1 (low beta even-numbered straight sections)

C2A_DCCT = [GIR,L460,GIR,SD3J,L170,QF3,L083,CF,L077,SF2J,L118,BPM,L112,QF4,GIR,L300,DCCT1,L488,GIR,BPM,RBPM,L100];  % arc sector in between B2-BC with DCCT1 (high beta odd-numbered straight sections)
C2B_DCCT = [GIR,L460,GIR,SD3K,L170,QF3,L083,CF,L077,SF2K,L118,BPM,L112,QF4,GIR,L300,DCCT2,L488,GIR,BPM,RBPM,L100];  % arc sector in between B2-BC with DCCT2 (low beta even-numbered straight sections)

%% GIRDERS

% straight sections
SS_S01 = INJ; SS_S02 = IDB;
SS_S03 = CAV; SS_S04 = IDB;
SS_S05 = IDA; SS_S06 = IDB;
SS_S07 = IDA; SS_S08 = IDB;
SS_S09 = IDA; SS_S10 = IDB;
SS_S11 = IDA; SS_S12 = IDB;
SS_S13 = IDA; SS_S14 = IDB;
SS_S15 = IDA; SS_S16 = IDB;
SS_S17 = IDA; SS_S18 = IDB;
SS_S19 = IDA; SS_S20 = IDB;

% down and upstream straight sections
M1_S01 = M1A; M2_S01 = M2A; M1_S02 = M1B; M2_S02 = M2B;
M1_S03 = M1A; M2_S03 = M2A; M1_S04 = M1B; M2_S04 = M2B;
M1_S05 = M1A; M2_S05 = M2A; M1_S06 = M1B; M2_S06 = M2B;
M1_S07 = M1A; M2_S07 = M2A; M1_S08 = M1B; M2_S08 = M2B;
M1_S09 = M1A; M2_S09 = M2A; M1_S10 = M1B; M2_S10 = M2B;
M1_S11 = M1A; M2_S11 = M2A; M1_S12 = M1B; M2_S12 = M2B;
M1_S13 = M1A; M2_S13 = M2A; M1_S14 = M1B; M2_S14 = M2B;
M1_S15 = M1A; M2_S15 = M2A; M1_S16 = M1B; M2_S16 = M2B;
M1_S17 = M1A; M2_S17 = M2A; M1_S18 = M1B; M2_S18 = M2B;
M1_S19 = M1A; M2_S19 = M2A; M1_S20 = M1B; M2_S20 = M2B;

% dispersive arcs
C1_S01 = C1A; C2_S01 = C2A; C3_S01 = C3A; C4_S01 = C4A;
C1_S02 = C1B; C2_S02 = C2B; C3_S02 = C3B; C4_S02 = C4B;
C1_S03 = C1A; C2_S03 = C2A; C3_S03 = C3A; C4_S03 = C4A;
C1_S04 = C1B; C2_S04 = C2B; C3_S04 = C3B; C4_S04 = C4B;
C1_S05 = C1A; C2_S05 = C2A; C3_S05 = C3A; C4_S05 = C4A;
C1_S06 = C1B; C2_S06 = C2B; C3_S06 = C3B; C4_S06 = C4B;
C1_S07 = C1A; C2_S07 = C2A; C3_S07 = C3A; C4_S07 = C4A;
C1_S08 = C1B; C2_S08 = C2B; C3_S08 = C3B; C4_S08 = C4B;
C1_S09 = C1A; C2_S09 = C2A; C3_S09 = C3A; C4_S09 = C4A;
C1_S10 = C1B; C2_S10 = C2B; C3_S10 = C3B; C4_S10 = C4B;
C1_S11 = C1A; C2_S11 = C2A; C3_S11 = C3A; C4_S11 = C4A;
C1_S12 = C1B; C2_S12 = C2B; C3_S12 = C3B; C4_S12 = C4B;
C1_S13 = C1A; C2_S13 = C2A_DCCT; C3_S13 = C3A; C4_S13 = C4A;
C1_S14 = C1B; C2_S14 = C2B_DCCT; C3_S14 = C3B; C4_S14 = C4B;
C1_S15 = C1A; C2_S15 = C2A; C3_S15 = C3A; C4_S15 = C4A;
C1_S16 = C1B; C2_S16 = C2B; C3_S16 = C3B; C4_S16 = C4B;
C1_S17 = C1A; C2_S17 = C2A; C3_S17 = C3A; C4_S17 = C4A;
C1_S18 = C1B; C2_S18 = C2B; C3_S18 = C3B; C4_S18 = C4B;
C1_S19 = C1A; C2_S19 = C2A; C3_S19 = C3A; C4_S19 = C4A;
C1_S20 = C1B; C2_S20 = C2B; C3_S20 = C3B; C4_S20 = C4B;

%% SECTORS # 01..20

S01 = [M1_S01, SS_S01, M2_S01, B1, C1_S01, B2, C2_S01, BC, C3_S01, B2, C4_S01, B1];
S02 = [M1_S02, SS_S02, M2_S02, B1, C1_S02, B2, C2_S02, BC, C3_S02, B2, C4_S02, B1];
S03 = [M1_S03, SS_S03, M2_S03, B1, C1_S03, B2, C2_S03, BC, C3_S03, B2, C4_S03, B1];
S04 = [M1_S04, SS_S04, M2_S04, B1, C1_S04, B2, C2_S04, BC, C3_S04, B2, C4_S04, B1];
S05 = [M1_S05, SS_S05, M2_S05, B1, C1_S05, B2, C2_S05, BC, C3_S05, B2, C4_S05, B1];
S06 = [M1_S06, SS_S06, M2_S06, B1, C1_S06, B2, C2_S06, BC, C3_S06, B2, C4_S06, B1];
S07 = [M1_S07, SS_S07, M2_S07, B1, C1_S07, B2, C2_S07, BC, C3_S07, B2, C4_S07, B1];
S08 = [M1_S08, SS_S08, M2_S08, B1, C1_S08, B2, C2_S08, BC, C3_S08, B2, C4_S08, B1];
S09 = [M1_S09, SS_S09, M2_S09, B1, C1_S09, B2, C2_S09, BC, C3_S09, B2, C4_S09, B1];
S10 = [M1_S10, SS_S10, M2_S10, B1, C1_S10, B2, C2_S10, BC, C3_S10, B2, C4_S10, B1];
S11 = [M1_S11, SS_S11, M2_S11, B1, C1_S11, B2, C2_S11, BC, C3_S11, B2, C4_S11, B1];
S12 = [M1_S12, SS_S12, M2_S12, B1, C1_S12, B2, C2_S12, BC, C3_S12, B2, C4_S12, B1];
S13 = [M1_S13, SS_S13, M2_S13, B1, C1_S13, B2, C2_S13, BC, C3_S13, B2, C4_S13, B1];
S14 = [M1_S14, SS_S14, M2_S14, B1, C1_S14, B2, C2_S14, BC, C3_S14, B2, C4_S14, B1];
S15 = [M1_S15, SS_S15, M2_S15, B1, C1_S15, B2, C2_S15, BC, C3_S15, B2, C4_S15, B1];
S16 = [M1_S16, SS_S16, M2_S16, B1, C1_S16, B2, C2_S16, BC, C3_S16, B2, C4_S16, B1];
S17 = [M1_S17, SS_S17, M2_S17, B1, C1_S17, B2, C2_S17, BC, C3_S17, B2, C4_S17, B1];
S18 = [M1_S18, SS_S18, M2_S18, B1, C1_S18, B2, C2_S18, BC, C3_S18, B2, C4_S18, B1];
S19 = [M1_S19, SS_S19, M2_S19, B1, C1_S19, B2, C2_S19, BC, C3_S19, B2, C4_S19, B1];
S20 = [M1_S20, SS_S20, M2_S20, B1, C1_S20, B2, C2_S20, BC, C3_S20, B2, C4_S20, B1];

anel = [S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20];
elist = anel;


%% finalization 

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'start');
if ~isempty(idx)
    THERING = [THERING(idx:end) THERING(1:idx-1)];
end

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

pb = findcells(THERING, 'PolynomB');
for i=1:length(pb)
    THERING{pb(i)}.NPA = THERING{pb(i)}.PolynomA;
    THERING{pb(i)}.NPB = THERING{pb(i)}.PolynomB;
end

% adjusts RF frequency according to lattice length and synchronous condition
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
%rev_freq    = beta * const.c / L0_tot;
rev_freq    = const.c / L0_tot;

rf_idx      = findcells(THERING, 'FamName', 'cav');
rf_frequency = rev_freq * harmonic_number;
THERING{rf_idx}.Frequency = rf_frequency;
fprintf(['   RF frequency set to ' num2str(rf_frequency/1e6) ' MHz.\n']);

% by default cavities and radiation is set to off 
setcavity('off'); 
setradiation('off');

% sets default NumIntSteps values for elements
THERING = set_num_integ_steps(THERING);

% define vacuum chamber for all elements
THERING = set_vacuum_chamber(THERING);

% defines girders
THERING = set_girders(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

r = THERING;



function the_ring = set_girders(the_ring)

gir = findcells(the_ring,'FamName','girder');

gir_ini = gir(1:2:end);
gir_end = gir(2:2:end);
if isempty(gir), return; end

for ii=1:length(gir_ini)
    idx = gir_ini(ii):gir_end(ii);
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
the_ring(gir) = [];

function the_ring = set_num_integ_steps(the_ring)

mags = findcells(the_ring, 'PolynomB');
bends = findcells(the_ring,'BendingAngle');
quad_sext = setdiff(mags,bends);
kicks = findcells(the_ring, 'XGrid');

% value determined by a convergence study and relaxed by running time:
len_b  = 5e-2;
len_qs = 1.5e-2;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / len_b);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);

quad_sext_len = getcellstruct(the_ring, 'Length', quad_sext);
quad_sext_nis = ceil(quad_sext_len / len_qs);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quad_sext, quad_sext_nis);

the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);

