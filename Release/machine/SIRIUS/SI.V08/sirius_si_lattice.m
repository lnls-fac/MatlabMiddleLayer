function [r, lattice_title] = sirius_si_lattice(varargin)
% r = sirius_si_lattice       : retorna o modelo atual do anel;
%
% r = sirius_si_lattice(mode) : Ateh o momento, pode ser 'AC10'(default) or 'AC20'.
%
% r = sirius_si_lattice(mode,mode_version): mode_version define o ponto de operacao 
%      e a otimizacao sextupolar a ser usada. Exemplos: 'AC10_1', 'AC10_2',
%      'AC10_5'(default)...
%r = sirius_si_lattice(mode,mode_version, energy): energia em eV;
%
% Todos os inputs comutam e podem ser passados independentemente.
%
% 2012-08-28: nova rede. (xrr)
% 2013-08-08: inseri marcadores de IDs de 2 m nos trechos retos. (xrr)
% 2013-08-12: corretoras rapidas e atualizacao das lentas e dos BPMs (desenho CAD da Liu). (xrr)
% 2013-10-02: adicionei o mode_version como parametro de input. (Fernando)
% 2014-09-17: modificacao das corretoras para apenas uma par integrado de CV e CH rapidas e lentas no mesmo elemento. (Natalia) 
% 2014-10-07: atualizados nomes de alguns elementos. (xrr)
% 2015-03-04: testes com ideia de colocar corretores skew fora dos sextupolos e junto com corretoras rápidas

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'C';   % a = ac20, b = ac10(beta=4m), c = ac10(beta=1.5m)
version = '04';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V08';
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

MOMACCEP = marker('calc_mom_accep', 'IdentityPass');     % marker to define points where momentum acceptance will be calculated

% -- drifts --
LIA = drift('lia', 2.4129, 'DriftPass');
LIB = drift('lib', 2.0429, 'DriftPass');
LBC = drift('lbc', 0.0630, 'DriftPass');
L11 = drift('l11', 0.1100, 'DriftPass');
L12 = drift('l12', 0.1200, 'DriftPass');
L13 = drift('l13', 0.1300, 'DriftPass');
L14 = drift('l14', 0.1400, 'DriftPass');
L15 = drift('l15', 0.1500, 'DriftPass');
L17 = drift('l17', 0.1700, 'DriftPass');
L19 = drift('l19', 0.1900, 'DriftPass');
L21 = drift('l21', 0.2100, 'DriftPass');
L23 = drift('l23', 0.2300, 'DriftPass');
L24 = drift('l24', 0.2400, 'DriftPass');
L25 = drift('l25', 0.2500, 'DriftPass');
L34 = drift('l34', 0.3400, 'DriftPass');
L38 = drift('l38', 0.3800, 'DriftPass');
L46 = drift('l46', 0.4600, 'DriftPass');
L48 = drift('l48', 0.4800, 'DriftPass');
L50 = drift('l50', 0.5000, 'DriftPass');
L61 = drift('l61', 0.6100, 'DriftPass');
L73 = drift('l73', 0.7300, 'DriftPass');

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

B3E = rbend_sirius('b3', 0.425/2, 1.4143*deg2rad/2, 1.4143*deg2rad/2, 0,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
MB3 = marker('mb3', 'IdentityPass');
B3S = rbend_sirius('b3', 0.425/2, 1.4143*deg2rad/2, 0, 1.4143*deg2rad/2,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
B3  = [MOMACCEP,B3E,MOMACCEP,MB3,B3S,MOMACCEP];

BC1 = rbend_sirius('bc', 0.01,  0.114*deg2rad, 0, 0,   0, 0, 0, [0 0 0], [0 -0.0001586 -28.62886], bend_pass_method);
BC2 = rbend_sirius('bc', 0.01,  0.110*deg2rad, 0, 0,   0, 0, 0, [0 0 0], [0 -0.0032399 -27.61427], bend_pass_method);
BC3 = rbend_sirius('bc', 0.01,  0.096*deg2rad, 0, 0,   0, 0, 0, [0 0 0], [0 -0.0126344 -21.90036], bend_pass_method);
BC4 = rbend_sirius('bc', 0.01,  0.078*deg2rad, 0, 0,   0, 0, 0, [0 0 0], [0 -0.0163734 -14.03515], bend_pass_method);
BC5 = rbend_sirius('bc', 0.01,  0.062*deg2rad, 0, 0,   0, 0, 0, [0 0 0], [0 -0.0145890 -8.797988], bend_pass_method);
BC6 = rbend_sirius('bc', 0.08,  0.274*deg2rad, 0, 0,   0, 0, 0, [0 0 0], [0 -0.0055834 -4.294111], bend_pass_method);
MC = marker('mc', 'IdentityPass');
BCE = [MOMACCEP, BC6, BC5, BC4, BC3, BC2, BC1];
BCS = [BC1, BC2, BC3, BC4, BC5, BC6, MOMACCEP];
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
SDA = sextupole('sda', 0.150, sda_strength, sext_pass_method); %
SFA = sextupole('sfa', 0.150, sfa_strength, sext_pass_method); % chs/cvs
SDB = sextupole('sdb', 0.150, sdb_strength, sext_pass_method); %
SFB = sextupole('sfb', 0.150, sfb_strength, sext_pass_method); % chs/cvs
SD1 = sextupole('sd1', 0.150, sd1_strength, sext_pass_method); % chs/cvs
SF1 = sextupole('sf1', 0.150, sf1_strength, sext_pass_method); %
SD2 = sextupole('sd2', 0.150, sd2_strength, sext_pass_method); % chs
SD3 = sextupole('sd3', 0.150, sd3_strength, sext_pass_method); % cvs
SF2 = sextupole('sf2', 0.150, sf2_strength, sext_pass_method); % chs
SD6 = sextupole('sd6', 0.150, sd6_strength, sext_pass_method); % chs/cvs
SF4 = sextupole('sf4', 0.150, sf4_strength, sext_pass_method); %
SD5 = sextupole('sd5', 0.150, sd5_strength, sext_pass_method); % chs
SD4 = sextupole('sd4', 0.150, sd4_strength, sext_pass_method); % cvs
SF3 = sextupole('sf3', 0.150, sf3_strength, sext_pass_method); % chs

% -- bpms and fast correctors --
BPM    = marker('bpm', 'IdentityPass');
CF     = sextupole('cf', 0.100, 0.0, quad_pass_method);


% -- rf cavities --
RFC = rfcavity('cav', 0, 2.5e6, 500e6, harmonic_number, 'CavityPass');

% -- lattice markers --
START  = marker('start',  'IdentityPass');     % start of the model
END    = marker('end',  'IdentityPass');     % start of the model
MIA    = marker('mia', 'IdentityPass');        % center of long straight sections (even-numbered)
MIB    = marker('mib', 'IdentityPass');        % center of short straight sections (odd-numbered)
GIRDER = marker('girder', 'IdentityPass');     % marker used to delimitate girders. one marker at begin and another at end of girder.
MIDA   = marker('id_enda', 'IdentityPass');    % marker for the extremities of IDs in long straight sections
MIDB   = marker('id_endb', 'IdentityPass');    % marker for the extremities of IDs in short straight sections

%% transport lines

M2A = [GIRDER,CF,L11,SFA,L12,BPM,L14,QFA,L24,QDA,L15,SDA,L19,GIRDER];               % high beta xxM2 girder                                                                                  
M1A = fliplr(M2A);                                                                  % high beta xxM1 girder
IDA = [GIRDER,LIA,MIDA,L50,L50,MIA,MOMACCEP,L50,L50,MIDA,LIA,GIRDER];                        % high beta ID straight section
CAV = [GIRDER,LIA,L50,L50,MIA,MOMACCEP,RFC,L50,L50,LIA,GIRDER];                              % high beta RF cavity straight section 
INJ = [GIRDER,LIA,L50,L50,END,START,MIA,MOMACCEP,L50,L50,LIA,GIRDER];                            % high beta INJ straight section
M1B = [GIRDER,L19,SDB,L15,QDB1,L24,QFB,L14,BPM,L12,SFB,L11,CF,L13,QDB2,GIRDER];     % low beta xxM1 girder
M2B = fliplr(M1B);                                                                  % low beta xxM2 girder
IDB = [GIRDER,LIB,MIDB,L50,L50,MIB,MOMACCEP,L50,L50,MIDB,LIB,GIRDER];                        % low beta ID straight section
C3  = [LBC,BC,LBC];                                                                 % arc sector in between B3-B3
C1A = [GIRDER,L61,SD1,L17,QF1,L14, BPM,L12,SF1,L23,QF2,L17,SD2,L21,BPM,L13,GIRDER]; % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C2A = [GIRDER,L46,SD3,L17,QF3,L23,SF2,L12,BPM,L14,QF4,L12,CF,L38,BPM,L13,GIRDER];   % arc sector in between B2-B3 (high beta odd-numbered straight sections)
C4A = [GIRDER,L73,QF4,L14,BPM,L12,SF3,L23,QF3,L17,SD4,L11,CF,L25,GIRDER];           % arc sector in between B3-B2 (high beta odd-numbered straight sections)
C5A = [GIRDER,L34,SD5,L17,QF2,L23,SF4,L12,BPM,L14,QF1,L17,SD6,L48,BPM,L13,GIRDER];  % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C1B = [GIRDER,L61,SD6,L17,QF1,L14,BPM,L12,SF4,L23,QF2,L17,SD5,L21,BPM,L13,GIRDER];  % arc sector in between B1-B2 (low beta even-numbered straight sections)
C2B = [GIRDER,L46,SD4,L17,QF3,L23,SF3,L12,BPM,L14,QF4,L12,CF,L38,BPM,L13,GIRDER];   % arc sector in between B2-B3 (low beta even-numbered straight sections)
C4B = [GIRDER,L73,QF4,L14,BPM,L12,SF2,L23,QF3,L17,SD3,L11,CF,L25,GIRDER];           % arc sector in between B3-B2 (low beta even-numbered straight sections)
C5B = [GIRDER,L34,SD2,L17,QF2,L23,SF1,L12,BPM,L14,QF1,L17,SD1,L48,BPM,L13,GIRDER];  % arc sector in between B2-B1 (low beta even-numbered straight sections)    


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
GIRDER_01C1 = C1A; GIRDER_01C2 = C2A; GIRDER_01C3 = C3; GIRDER_01C4 = C4A; GIRDER_01C5 = C5A;
GIRDER_02C1 = C1B; GIRDER_02C2 = C2B; GIRDER_02C3 = C3; GIRDER_02C4 = C4B; GIRDER_02C5 = C5B;
GIRDER_03C1 = C1A; GIRDER_03C2 = C2A; GIRDER_03C3 = C3; GIRDER_03C4 = C4A; GIRDER_03C5 = C5A;
GIRDER_04C1 = C1B; GIRDER_04C2 = C2B; GIRDER_04C3 = C3; GIRDER_04C4 = C4B; GIRDER_04C5 = C5B;
GIRDER_05C1 = C1A; GIRDER_05C2 = C2A; GIRDER_05C3 = C3; GIRDER_05C4 = C4A; GIRDER_05C5 = C5A;
GIRDER_06C1 = C1B; GIRDER_06C2 = C2B; GIRDER_06C3 = C3; GIRDER_06C4 = C4B; GIRDER_06C5 = C5B;
GIRDER_07C1 = C1A; GIRDER_07C2 = C2A; GIRDER_07C3 = C3; GIRDER_07C4 = C4A; GIRDER_07C5 = C5A;
GIRDER_08C1 = C1B; GIRDER_08C2 = C2B; GIRDER_08C3 = C3; GIRDER_08C4 = C4B; GIRDER_08C5 = C5B;
GIRDER_09C1 = C1A; GIRDER_09C2 = C2A; GIRDER_09C3 = C3; GIRDER_09C4 = C4A; GIRDER_09C5 = C5A;
GIRDER_10C1 = C1B; GIRDER_10C2 = C2B; GIRDER_10C3 = C3; GIRDER_10C4 = C4B; GIRDER_10C5 = C5B;
GIRDER_11C1 = C1A; GIRDER_11C2 = C2A; GIRDER_11C3 = C3; GIRDER_11C4 = C4A; GIRDER_11C5 = C5A;
GIRDER_12C1 = C1B; GIRDER_12C2 = C2B; GIRDER_12C3 = C3; GIRDER_12C4 = C4B; GIRDER_12C5 = C5B;
GIRDER_13C1 = C1A; GIRDER_13C2 = C2A; GIRDER_13C3 = C3; GIRDER_13C4 = C4A; GIRDER_13C5 = C5A;
GIRDER_14C1 = C1B; GIRDER_14C2 = C2B; GIRDER_14C3 = C3; GIRDER_14C4 = C4B; GIRDER_14C5 = C5B;
GIRDER_15C1 = C1A; GIRDER_15C2 = C2A; GIRDER_15C3 = C3; GIRDER_15C4 = C4A; GIRDER_15C5 = C5A;
GIRDER_16C1 = C1B; GIRDER_16C2 = C2B; GIRDER_16C3 = C3; GIRDER_16C4 = C4B; GIRDER_16C5 = C5B;
GIRDER_17C1 = C1A; GIRDER_17C2 = C2A; GIRDER_17C3 = C3; GIRDER_17C4 = C4A; GIRDER_17C5 = C5A;
GIRDER_18C1 = C1B; GIRDER_18C2 = C2B; GIRDER_18C3 = C3; GIRDER_18C4 = C4B; GIRDER_18C5 = C5B;
GIRDER_19C1 = C1A; GIRDER_19C2 = C2A; GIRDER_19C3 = C3; GIRDER_19C4 = C4A; GIRDER_19C5 = C5A;
GIRDER_20C1 = C1B; GIRDER_20C2 = C2B; GIRDER_20C3 = C3; GIRDER_20C4 = C4B; GIRDER_20C5 = C5B;


%% SECTORS # 01..20

S01 = [GIRDER_01M1, GIRDER_01S, GIRDER_01M2, B1, GIRDER_01C1, B2, GIRDER_01C2, B3, GIRDER_01C3, B3, GIRDER_01C4, B2, GIRDER_01C5, B1];
S02 = [GIRDER_02M1, GIRDER_02S, GIRDER_02M2, B1, GIRDER_02C1, B2, GIRDER_02C2, B3, GIRDER_02C3, B3, GIRDER_02C4, B2, GIRDER_02C5, B1];
S03 = [GIRDER_03M1, GIRDER_03S, GIRDER_03M2, B1, GIRDER_03C1, B2, GIRDER_03C2, B3, GIRDER_03C3, B3, GIRDER_03C4, B2, GIRDER_03C5, B1];
S04 = [GIRDER_04M1, GIRDER_04S, GIRDER_04M2, B1, GIRDER_04C1, B2, GIRDER_04C2, B3, GIRDER_04C3, B3, GIRDER_04C4, B2, GIRDER_04C5, B1];
S05 = [GIRDER_05M1, GIRDER_05S, GIRDER_05M2, B1, GIRDER_05C1, B2, GIRDER_05C2, B3, GIRDER_05C3, B3, GIRDER_05C4, B2, GIRDER_05C5, B1];
S06 = [GIRDER_06M1, GIRDER_06S, GIRDER_06M2, B1, GIRDER_06C1, B2, GIRDER_06C2, B3, GIRDER_06C3, B3, GIRDER_06C4, B2, GIRDER_06C5, B1];
S07 = [GIRDER_07M1, GIRDER_07S, GIRDER_07M2, B1, GIRDER_07C1, B2, GIRDER_07C2, B3, GIRDER_07C3, B3, GIRDER_07C4, B2, GIRDER_07C5, B1];
S08 = [GIRDER_08M1, GIRDER_08S, GIRDER_08M2, B1, GIRDER_08C1, B2, GIRDER_08C2, B3, GIRDER_08C3, B3, GIRDER_08C4, B2, GIRDER_08C5, B1];
S09 = [GIRDER_09M1, GIRDER_09S, GIRDER_09M2, B1, GIRDER_09C1, B2, GIRDER_09C2, B3, GIRDER_09C3, B3, GIRDER_09C4, B2, GIRDER_09C5, B1];
S10 = [GIRDER_10M1, GIRDER_10S, GIRDER_10M2, B1, GIRDER_10C1, B2, GIRDER_10C2, B3, GIRDER_10C3, B3, GIRDER_10C4, B2, GIRDER_10C5, B1];
S11 = [GIRDER_11M1, GIRDER_11S, GIRDER_11M2, B1, GIRDER_11C1, B2, GIRDER_11C2, B3, GIRDER_11C3, B3, GIRDER_11C4, B2, GIRDER_11C5, B1];
S12 = [GIRDER_12M1, GIRDER_12S, GIRDER_12M2, B1, GIRDER_12C1, B2, GIRDER_12C2, B3, GIRDER_12C3, B3, GIRDER_12C4, B2, GIRDER_12C5, B1];
S13 = [GIRDER_13M1, GIRDER_13S, GIRDER_13M2, B1, GIRDER_13C1, B2, GIRDER_13C2, B3, GIRDER_13C3, B3, GIRDER_13C4, B2, GIRDER_13C5, B1];
S14 = [GIRDER_14M1, GIRDER_14S, GIRDER_14M2, B1, GIRDER_14C1, B2, GIRDER_14C2, B3, GIRDER_14C3, B3, GIRDER_14C4, B2, GIRDER_14C5, B1];
S15 = [GIRDER_15M1, GIRDER_15S, GIRDER_15M2, B1, GIRDER_15C1, B2, GIRDER_15C2, B3, GIRDER_15C3, B3, GIRDER_15C4, B2, GIRDER_15C5, B1];
S16 = [GIRDER_16M1, GIRDER_16S, GIRDER_16M2, B1, GIRDER_16C1, B2, GIRDER_16C2, B3, GIRDER_16C3, B3, GIRDER_16C4, B2, GIRDER_16C5, B1];
S17 = [GIRDER_17M1, GIRDER_17S, GIRDER_17M2, B1, GIRDER_17C1, B2, GIRDER_17C2, B3, GIRDER_17C3, B3, GIRDER_17C4, B2, GIRDER_17C5, B1];
S18 = [GIRDER_18M1, GIRDER_18S, GIRDER_18M2, B1, GIRDER_18C1, B2, GIRDER_18C2, B3, GIRDER_18C3, B3, GIRDER_18C4, B2, GIRDER_18C5, B1];
S19 = [GIRDER_19M1, GIRDER_19S, GIRDER_19M2, B1, GIRDER_19C1, B2, GIRDER_19C2, B3, GIRDER_19C3, B3, GIRDER_19C4, B2, GIRDER_19C5, B1];
S20 = [GIRDER_20M1, GIRDER_20S, GIRDER_20M2, B1, GIRDER_20C1, B2, GIRDER_20C2, B3, GIRDER_20C3, B3, GIRDER_20C4, B2, GIRDER_20C5, B1];

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
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
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
%lnls_preload_passmethods;

r = THERING;



function the_ring = set_girders(the_ring)

gir = findcells(the_ring,'FamName','girder');

if isempty(gir), return; end

for ii=1:length(gir)-1
    idx = gir(ii):gir(ii+1)-1;
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
idx = [1:gir(1)-1 gir(end):length(the_ring)];
name_girder = sprintf('%03d',ii+1);
the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);

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


