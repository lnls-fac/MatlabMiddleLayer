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
L230 = drift('l230', 0.2300,'DriftPass');
L275 = drift('l275', 0.2750,'DriftPass');
L340 = drift('l340', 0.3400,'DriftPass');
L460 = drift('l460', 0.4600,'DriftPass');
L500 = drift('l500', 0.5000,'DriftPass');
L610 = drift('l610', 0.6100,'DriftPass');
L788 = drift('l788', 0.7880,'DriftPass');
L888 = drift('l888', 0.8880,'DriftPass');

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

B3C1  = rbend_sirius('bc_hf', 0.015, 0.2800*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.005 0], bend_pass_method); 
B3C2  = rbend_sirius('bc_hf', 0.005, 0.0900*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.057 0], bend_pass_method); 
B3C3  = rbend_sirius('bc_hf', 0.005, 0.0780*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.112 0], bend_pass_method); 
B3C4  = rbend_sirius('bc_hf', 0.005, 0.0590*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.103 0], bend_pass_method); 
B3C5  = rbend_sirius('bc_hf', 0.010, 0.0850*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.066 0], bend_pass_method); 
B3C6  = rbend_sirius('bc_hf', 0.010, 0.0590*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.047 0], bend_pass_method); 
B3C7  = rbend_sirius('bc_hf', 0.015, 0.0640*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.080 0], bend_pass_method); 
B3C8  = rbend_sirius('bc_lf', 0.020, 0.0720*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.388 0], bend_pass_method); 
B3C9  = rbend_sirius('bc_lf', 0.325/2, 1.2700/2*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.891 0], bend_pass_method); 
B3C10 = rbend_sirius('bc_lf', 0.325/2, 1.2700/2*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.891 0], bend_pass_method); 
B3C11 = rbend_sirius('bc_lf', 0.010, 0.0310*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.689 0], bend_pass_method); 
B3C12 = rbend_sirius('bc_lf', 0.010, 0.0220*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.325 0], bend_pass_method); 
B3C13 = rbend_sirius('bc_lf', 0.010, 0.0150*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0 -0.128 0], bend_pass_method); 
B3C14 = rbend_sirius('bc_lf', 0.020, 0.0233*deg2rad, 0, 0, 0, 0, 0, [0 0 0], [0  0.009 0], bend_pass_method);

MC = marker('mc', 'IdentityPass');
B3CE = [B3C14, B3C13, B3C12, B3C11, MOMACCEP, B3C10, MOMACCEP, B3C9,...
        MOMACCEP, B3C8, B3C7, B3C6, B3C5, B3C4, B3C3, B3C2, B3C1];
B3CS = [B3C1, B3C2, B3C3, B3C4, B3C5, B3C6, B3C7, B3C8, MOMACCEP, ...
        B3C9, MOMACCEP, B3C10, MOMACCEP, B3C11, B3C12, B3C13, B3C14];
B3C  = [B3CE,MC, MOMACCEP,B3CS];

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

% -- bpms and fast correctors --
BPM    = marker('bpm', 'IdentityPass');
CF     = sextupole('cf', 0.100, 0.0, quad_pass_method);
RBPM   = marker('rbpm', 'IdentityPass');

% -- rf cavities --
RFC = rfcavity('cav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');

% -- lattice markers --
START  = marker('start',  'IdentityPass');     % start of the model
END    = marker('end',  'IdentityPass');     % end of the model
MIA    = marker('mia', 'IdentityPass');        % center of long straight sections (even-numbered)
MIB    = marker('mib', 'IdentityPass');        % center of short straight sections (odd-numbered)
GIR    = marker('girder', 'IdentityPass');     % marker used to delimitate girders. one marker at begin and another at end of girder.
MIDA   = marker('id_enda', 'IdentityPass');    % marker for the extremities of IDs in long straight sections
MIDB   = marker('id_endb', 'IdentityPass');    % marker for the extremities of IDs in short straight sections

%% transport lines

M2A = [GIR,CF,L085,SFA,L150,QFA,L124,BPM,L116,SDA,L150,QDA,GIR,L170,GIR];                             % high beta xxM2 girder  
M1A = fliplr(M2A);                                                                                      % high beta xxM1 girder
IDA = [LIA,RBPM,L500,L500,MIDA,L500,L500,MIA,MOMACCEP,L500,L500,MIDA,L500,L500,RBPM,LIA]; % high beta ID straight section
CAV = [LIA,RBPM,L500,L500,L500,L500,MIA,MOMACCEP,RFC,L500,L500,L500,L500,RBPM,LIA];       % high beta RF cavity straight section 
INJ = [LIA,RBPM,L500,L500,L500,L500,END,START,MIA,MOMACCEP,L500,L500,L500,L500,RBPM,LIA]; % high beta INJ straight section
M1B = [GIR,L170,GIR,QDB1,L150,SDB,L116,BPM,L124,QFB,L150,SFB,L050,CF,L035,QDB2,GIR];                  % low beta xxM1 girder
M2B = fliplr(M1B);                                                                                      % low beta xxM2 girder
IDB = [LIB,RBPM,L500,L500,MIDB,L500,L500,MIB,MOMACCEP,L500,L500,MIDB,L500,L500,RBPM,LIB]; % low beta ID straight section
C1A = [GIR,L610,GIR,SD1J,L170,QF1,L135, BPM,L125,SF1J,L230,QF2,L170,SD2J,GIR,L155,GIR,BPM,L185];          % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C2A = [GIR,L460,GIR,SD3J,L170,QF3,L083,CF,L077,SF2J,L118,BPM,L112,QF4,GIR,L788,GIR,BPM,RBPM,L100];        % arc sector in between B2-B3 (high beta odd-numbered straight sections)
C3A = [GIR,L888,GIR,QF4,L112,RBPM,BPM,L118,SF2K,L077,CF,L083,QF3,L170,SD3K,GIR,L275,GIR,BPM,L185];             % arc sector in between B3-B2 (high beta odd-numbered straight sections)
C4A = [GIR,L340,GIR,SD2K,L170,QF2,L230,SF1K,L125,BPM,L135,QF1,L170,SD1K,GIR,L610,GIR];                    % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C1B = [GIR,L610,GIR,SD1K,L170,QF1,L135, BPM,L125,SF1K,L230,QF2,L170,SD2K,GIR,L155,GIR,BPM,L185];          % arc sector in between B1-B2 (low beta even-numbered straight sections)
C2B = [GIR,L460,GIR,SD3K,L170,QF3,L083,CF,L077,SF2K,L118,BPM,L112,QF4,GIR,L788,GIR,BPM,RBPM,L100];        % arc sector in between B2-B3 (low beta even-numbered straight sections)
C3B = [GIR,L888,GIR,QF4,L112,RBPM,BPM,L118,SF2J,L077,CF,L083,QF3,L170,SD3J,GIR,L275,GIR,BPM,L185];             % arc sector in between B3-B2 (low beta even-numbered straight sections)
C4B = [GIR,L340,GIR,SD2J,L170,QF2,L230,SF1J,L125,BPM,L135,QF1,L170,SD1J,GIR,L610,GIR];                    % arc sector in between B2-B1 (low beta even-numbered straight sections)


%% GIRDERS

% straight sections
GIRDER_01S = INJ; GIRDER_02S = IDB;
GIRDER_03S = CAV; GIRDER_04S = IDB;
GIRDER_05S = IDA; GIRDER_06S = IDB;
GIRDER_07S = IDA; GIRDER_08S = IDB;
GIRDER_09S = IDA; GIRDER_10S = IDB;
GIRDER_11S = IDA; GIRDER_12S = IDB;
GIRDER_13S = IDA; GIRDER_14S = IDB;
GIRDER_15S = IDA; GIRDER_16S = IDB;
GIRDER_17S = IDA; GIRDER_18S = IDB;
GIRDER_19S = IDA; GIRDER_20S = IDB;

% down and upstream straight sections
GIRDER_01M1 = M1A; GIRDER_01M2 = M2A; GIRDER_02M1 = M1B; GIRDER_02M2 = M2B;
GIRDER_03M1 = M1A; GIRDER_03M2 = M2A; GIRDER_04M1 = M1B; GIRDER_04M2 = M2B;
GIRDER_05M1 = M1A; GIRDER_05M2 = M2A; GIRDER_06M1 = M1B; GIRDER_06M2 = M2B;
GIRDER_07M1 = M1A; GIRDER_07M2 = M2A; GIRDER_08M1 = M1B; GIRDER_08M2 = M2B;
GIRDER_09M1 = M1A; GIRDER_09M2 = M2A; GIRDER_10M1 = M1B; GIRDER_10M2 = M2B;
GIRDER_11M1 = M1A; GIRDER_11M2 = M2A; GIRDER_12M1 = M1B; GIRDER_12M2 = M2B;
GIRDER_13M1 = M1A; GIRDER_13M2 = M2A; GIRDER_14M1 = M1B; GIRDER_14M2 = M2B;
GIRDER_15M1 = M1A; GIRDER_15M2 = M2A; GIRDER_16M1 = M1B; GIRDER_16M2 = M2B;
GIRDER_17M1 = M1A; GIRDER_17M2 = M2A; GIRDER_18M1 = M1B; GIRDER_18M2 = M2B;
GIRDER_19M1 = M1A; GIRDER_19M2 = M2A; GIRDER_20M1 = M1B; GIRDER_20M2 = M2B;

% dispersive arcs
GIRDER_01C1 = C1A; GIRDER_01C2 = C2A; GIRDER_01C3 = C3A; GIRDER_01C4 = C4A;
GIRDER_02C1 = C1B; GIRDER_02C2 = C2B; GIRDER_02C3 = C3B; GIRDER_02C4 = C4B;
GIRDER_03C1 = C1A; GIRDER_03C2 = C2A; GIRDER_03C3 = C3A; GIRDER_03C4 = C4A;
GIRDER_04C1 = C1B; GIRDER_04C2 = C2B; GIRDER_04C3 = C3B; GIRDER_04C4 = C4B;
GIRDER_05C1 = C1A; GIRDER_05C2 = C2A; GIRDER_05C3 = C3A; GIRDER_05C4 = C4A;
GIRDER_06C1 = C1B; GIRDER_06C2 = C2B; GIRDER_06C3 = C3B; GIRDER_06C4 = C4B;
GIRDER_07C1 = C1A; GIRDER_07C2 = C2A; GIRDER_07C3 = C3A; GIRDER_07C4 = C4A;
GIRDER_08C1 = C1B; GIRDER_08C2 = C2B; GIRDER_08C3 = C3B; GIRDER_08C4 = C4B;
GIRDER_09C1 = C1A; GIRDER_09C2 = C2A; GIRDER_09C3 = C3A; GIRDER_09C4 = C4A;
GIRDER_10C1 = C1B; GIRDER_10C2 = C2B; GIRDER_10C3 = C3B; GIRDER_10C4 = C4B;
GIRDER_11C1 = C1A; GIRDER_11C2 = C2A; GIRDER_11C3 = C3A; GIRDER_11C4 = C4A;
GIRDER_12C1 = C1B; GIRDER_12C2 = C2B; GIRDER_12C3 = C3B; GIRDER_12C4 = C4B;
GIRDER_13C1 = C1A; GIRDER_13C2 = C2A; GIRDER_13C3 = C3A; GIRDER_13C4 = C4A;
GIRDER_14C1 = C1B; GIRDER_14C2 = C2B; GIRDER_14C3 = C3B; GIRDER_14C4 = C4B;
GIRDER_15C1 = C1A; GIRDER_15C2 = C2A; GIRDER_15C3 = C3A; GIRDER_15C4 = C4A;
GIRDER_16C1 = C1B; GIRDER_16C2 = C2B; GIRDER_16C3 = C3B; GIRDER_16C4 = C4B;
GIRDER_17C1 = C1A; GIRDER_17C2 = C2A; GIRDER_17C3 = C3A; GIRDER_17C4 = C4A;
GIRDER_18C1 = C1B; GIRDER_18C2 = C2B; GIRDER_18C3 = C3B; GIRDER_18C4 = C4B;
GIRDER_19C1 = C1A; GIRDER_19C2 = C2A; GIRDER_19C3 = C3A; GIRDER_19C4 = C4A;
GIRDER_20C1 = C1B; GIRDER_20C2 = C2B; GIRDER_20C3 = C3B; GIRDER_20C4 = C4B;


%% SECTORS # 01..20

S01 = [GIRDER_01M1, GIRDER_01S, GIRDER_01M2, B1, GIRDER_01C1, B2, GIRDER_01C2, B3C, GIRDER_01C3, B2, GIRDER_01C4, B1];
S02 = [GIRDER_02M1, GIRDER_02S, GIRDER_02M2, B1, GIRDER_02C1, B2, GIRDER_02C2, B3C, GIRDER_02C3, B2, GIRDER_02C4, B1];
S03 = [GIRDER_03M1, GIRDER_03S, GIRDER_03M2, B1, GIRDER_03C1, B2, GIRDER_03C2, B3C, GIRDER_03C3, B2, GIRDER_03C4, B1];
S04 = [GIRDER_04M1, GIRDER_04S, GIRDER_04M2, B1, GIRDER_04C1, B2, GIRDER_04C2, B3C, GIRDER_04C3, B2, GIRDER_04C4, B1];
S05 = [GIRDER_05M1, GIRDER_05S, GIRDER_05M2, B1, GIRDER_05C1, B2, GIRDER_05C2, B3C, GIRDER_05C3, B2, GIRDER_05C4, B1];
S06 = [GIRDER_06M1, GIRDER_06S, GIRDER_06M2, B1, GIRDER_06C1, B2, GIRDER_06C2, B3C, GIRDER_06C3, B2, GIRDER_06C4, B1];
S07 = [GIRDER_07M1, GIRDER_07S, GIRDER_07M2, B1, GIRDER_07C1, B2, GIRDER_07C2, B3C, GIRDER_07C3, B2, GIRDER_07C4, B1];
S08 = [GIRDER_08M1, GIRDER_08S, GIRDER_08M2, B1, GIRDER_08C1, B2, GIRDER_08C2, B3C, GIRDER_08C3, B2, GIRDER_08C4, B1];
S09 = [GIRDER_09M1, GIRDER_09S, GIRDER_09M2, B1, GIRDER_09C1, B2, GIRDER_09C2, B3C, GIRDER_09C3, B2, GIRDER_09C4, B1];
S10 = [GIRDER_10M1, GIRDER_10S, GIRDER_10M2, B1, GIRDER_10C1, B2, GIRDER_10C2, B3C, GIRDER_10C3, B2, GIRDER_10C4, B1];
S11 = [GIRDER_11M1, GIRDER_11S, GIRDER_11M2, B1, GIRDER_11C1, B2, GIRDER_11C2, B3C, GIRDER_11C3, B2, GIRDER_11C4, B1];
S12 = [GIRDER_12M1, GIRDER_12S, GIRDER_12M2, B1, GIRDER_12C1, B2, GIRDER_12C2, B3C, GIRDER_12C3, B2, GIRDER_12C4, B1];
S13 = [GIRDER_13M1, GIRDER_13S, GIRDER_13M2, B1, GIRDER_13C1, B2, GIRDER_13C2, B3C, GIRDER_13C3, B2, GIRDER_13C4, B1];
S14 = [GIRDER_14M1, GIRDER_14S, GIRDER_14M2, B1, GIRDER_14C1, B2, GIRDER_14C2, B3C, GIRDER_14C3, B2, GIRDER_14C4, B1];
S15 = [GIRDER_15M1, GIRDER_15S, GIRDER_15M2, B1, GIRDER_15C1, B2, GIRDER_15C2, B3C, GIRDER_15C3, B2, GIRDER_15C4, B1];
S16 = [GIRDER_16M1, GIRDER_16S, GIRDER_16M2, B1, GIRDER_16C1, B2, GIRDER_16C2, B3C, GIRDER_16C3, B2, GIRDER_16C4, B1];
S17 = [GIRDER_17M1, GIRDER_17S, GIRDER_17M2, B1, GIRDER_17C1, B2, GIRDER_17C2, B3C, GIRDER_17C3, B2, GIRDER_17C4, B1];
S18 = [GIRDER_18M1, GIRDER_18S, GIRDER_18M2, B1, GIRDER_18C1, B2, GIRDER_18C2, B3C, GIRDER_18C3, B2, GIRDER_18C4, B1];
S19 = [GIRDER_19M1, GIRDER_19S, GIRDER_19M2, B1, GIRDER_19C1, B2, GIRDER_19C2, B3C, GIRDER_19C3, B2, GIRDER_19C4, B1];
S20 = [GIRDER_20M1, GIRDER_20S, GIRDER_20M2, B1, GIRDER_20C1, B2, GIRDER_20C2, B3C, GIRDER_20C3, B2, GIRDER_20C4, B1];

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

