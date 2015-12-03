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
% 2015-11-03: agora modelo do BC é segmentado

global THERING;


%% global parameters 
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'C';   % a = ac20, b = ac10(beta=4m), c = ac10(beta=1.5m)
version = '02';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V14';
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
% marker to define points where momentum acceptance will be calculated
m_accep_fam_name = 'calc_mom_accep';
MOMACCEP = marker(m_accep_fam_name, 'IdentityPass');  %    

% -- drifts --

LKK   = drift('lkk',   1.8630, 'DriftPass');
LPMU  = drift('lpmu',  0.3220, 'DriftPass');
LPMD  = drift('lpmd',  0.4629, 'DriftPass');
LIA   = drift('lia2',  1.6179, 'DriftPass');
LIB   = drift('lib2',  1.0879, 'DriftPass');


L0350 = drift('l0350', 0.0350, 'DriftPass');
L0420 = drift('l0420', 0.0420, 'DriftPass');
L0515 = drift('l0515', 0.0515, 'DriftPass');
L0675 = drift('l0675', 0.0675, 'DriftPass');
L0740 = drift('l0740', 0.0740, 'DriftPass');
L0780 = drift('l0780', 0.0780, 'DriftPass');
L0785 = drift('l0785', 0.0785, 'DriftPass');
L0810 = drift('l0810', 0.0810, 'DriftPass');
L0830 = drift('l0830', 0.0830, 'DriftPass');
L0835 = drift('l0835', 0.0835, 'DriftPass');
L1000 = drift('l1000', 0.1000, 'DriftPass');
L1050 = drift('l1050', 0.1050, 'DriftPass');
L1120 = drift('l1120', 0.1120, 'DriftPass');
L1175 = drift('l1175', 0.1175, 'DriftPass');
L1240 = drift('l1240', 0.1240, 'DriftPass');
L1265 = drift('l1265', 0.1265, 'DriftPass');
L1350 = drift('l1350', 0.1350, 'DriftPass');
L1365 = drift('l1365', 0.1365, 'DriftPass');
L1400 = drift('l1400', 0.1400, 'DriftPass');
L1515 = drift('l1515', 0.1515, 'DriftPass');
L1565 = drift('l1565', 0.1565, 'DriftPass');
L1700 = drift('l1700', 0.1700, 'DriftPass');
L1715 = drift('l1715', 0.1715, 'DriftPass');
L1850 = drift('l1850', 0.1850, 'DriftPass');
L2315 = drift('l2315', 0.2315, 'DriftPass');
L2400 = drift('l2400', 0.2400, 'DriftPass');
L2415 = drift('l2415', 0.2415, 'DriftPass');
L2550 = drift('l2550', 0.2550, 'DriftPass');
L2765 = drift('l2765', 0.2765, 'DriftPass');
L3415 = drift('l3415', 0.3415, 'DriftPass');
L4190 = drift('l4190', 0.4190, 'DriftPass');
L4615 = drift('l4615', 0.4615, 'DriftPass');
L4950 = drift('l4950', 0.4950, 'DriftPass');
L5000 = drift('l5000', 0.5000, 'DriftPass');
L6115 = drift('l6115', 0.6115, 'DriftPass');
L7150 = drift('l7150', 0.7150, 'DriftPass');


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

[BC, ~] = sirius_si_bc_segmented_model(bend_pass_method, m_accep_fam_name);

% -- quadrupoles --
[QFA,  ~] = sirius_si_q20_segmented_model('qfa',  qfa_strength,  quad_pass_method);
[QDA,  ~] = sirius_si_q14_segmented_model('qda',  qda_strength,  quad_pass_method);
[QDB2, ~] = sirius_si_q14_segmented_model('qdb2', qdb2_strength, quad_pass_method);
[QFB,  ~] = sirius_si_q30_segmented_model('qfb',  qfb_strength,  quad_pass_method);
[QDB1, ~] = sirius_si_q14_segmented_model('qdb1', qdb1_strength, quad_pass_method);
[QF1,  ~] = sirius_si_q20_segmented_model('qf1',  qf1_strength,  quad_pass_method);
[QF2,  ~] = sirius_si_q20_segmented_model('qf2',  qf2_strength,  quad_pass_method);
[QF3,  ~] = sirius_si_q20_segmented_model('qf3',  qf3_strength,  quad_pass_method);
[QF4,  ~] = sirius_si_q20_segmented_model('qf4',  qf4_strength,  quad_pass_method);

% -- sextupoles and slow correctors --
SFA  = sextupole('sfa',   0.147, sfa_strength,  sext_pass_method); % CH-CV
SDA  = sextupole('sda',   0.147, sda_strength,  sext_pass_method); % QS
SD1J = sextupole('sd1j',  0.147, sd1j_strength, sext_pass_method); % CH-CV
SF1J = sextupole('sf1j',  0.147, sf1j_strength, sext_pass_method); % QS
SD2J = sextupole('sd2j',  0.147, sd2j_strength, sext_pass_method); % --
SD3J = sextupole('sd3j',  0.147, sd3j_strength, sext_pass_method); % CV
SF2J = sextupole('sf2j',  0.147, sf2j_strength, sext_pass_method); % CH
SF2K = sextupole('sf2k',  0.147, sf2k_strength, sext_pass_method); % CH-CV
SD3K = sextupole('sd3k',  0.147, sd3k_strength, sext_pass_method); % CV
SD2K = sextupole('sd2k',  0.147, sd2k_strength, sext_pass_method); % --
SF1K = sextupole('sf1k',  0.147, sf1k_strength, sext_pass_method); % QS
SD1K = sextupole('sd1k',  0.147, sd1k_strength, sext_pass_method); % CH-CV
SDB  = sextupole('sdb',   0.147, sdb_strength,  sext_pass_method); % QS
SFB  = sextupole('sfb',   0.147, sfb_strength,  sext_pass_method); % CH-CV
CV   = sextupole('cv',    0.150, 0.0,           sext_pass_method); % same model as BO correctors

% -- pulsed magnets --

KICKIN = sextupole('kick_in', 0.5, 0, sext_pass_method); % injection kicker
PMM    = sextupole('pmm',     0.47, 0, sext_pass_method); % pulsed multipole magnet

% -- bpms and fast correctors --
BPM    = marker('bpm', 'IdentityPass');
FC     = sextupole('fc', 0.100, 0.0, sext_pass_method);
RBPM   = marker('rbpm', 'IdentityPass');

% -- rf cavities --
RFC = rfcavity('cav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');

% -- lattice markers --
START  = marker('start',    'IdentityPass'); % start of the model
END    = marker('end',      'IdentityPass'); % end of the model
MIA    = marker('mia',      'IdentityPass'); % center of long straight sections (even-numbered)
MIB    = marker('mib',      'IdentityPass'); % center of short straight sections (odd-numbered)
GIR    = marker('girder',   'IdentityPass'); % marker used to delimitate girders. one marker at begin and another at end of girder.
MIDA   = marker('id_enda',  'IdentityPass'); % marker for the extremities of IDs in long straight sections
MIDB   = marker('id_endb',  'IdentityPass'); % marker for the extremities of IDs in short straight sections
SEPTIN = marker('eseptinj', 'IdentityPass'); % end of thin injection septum
DCCT1  = marker('dcct1',    'IdentityPass'); % dcct1 to measure beam current
DCCT2  = marker('dcct2',    'IdentityPass'); % dcct2 to measure beam current


%% transport lines

M2A_FC   = [GIR,BPM,RBPM,L1365,SFA,L1515,QFA,L0740,FC,L0675,SDA,L1515,QDA,GIR,L1700,GIR];                                        % high beta xxM2 girder (with fasc corrector)
M2A      = [GIR,BPM,RBPM,L1365,SFA,L1515,QFA,L1240,L1175,SDA,L1515,QDA,GIR,L1700,GIR];                                           % high beta xxM2 girder (without fast corrector)
M1A_FC   = fliplr(M2A_FC);                                                                                                       % high beta xxM1 girder (with fast correctors)
M1A      = fliplr(M2A);                                                                                                          % high beta xxM1 girder (without fast corrector)
IDA      = [L5000,LIA,L5000,MIDA,L5000,L5000,MIA,L5000,L5000,MIDA,L5000,LIA,L5000];                                              % high beta ID straight section
CAV      = [L5000,LIA,L5000,L5000,L5000,MIA,RFC,L5000,L5000,L5000,LIA,L5000];                                                    % high beta RF cavity straight section 
INJ      = [L5000,LIA,L4190,SEPTIN,L5000,L5000,L0810,END,START,MIA, LKK, KICKIN, LPMU, PMM, LPMD];                               % high beta INJ straight section
M1B_FC   = [GIR,L1700,L1000,GIR,QDB1,L1515,SDB,L2415,QFB,L1515,SFB,L0515,FC,L0350,QDB2,L1400,BPM,RBPM,GIR];                            % low beta xxM1 girder
M2B_FC   = fliplr(M1B_FC);                                                                                                       % low beta xxM2 girder
IDB      = [L5000,LIB,L5000,MIDB,L5000,L5000,MIB,L5000,L5000,MIDB,L5000,LIB,L5000];                                              % low beta ID straight section
C1A      = [GIR,L6115,GIR,SD1J,L1715,QF1,L1350,BPM,L1265,SF1J,L2315,QF2,L1715,SD2J,GIR,L1565,GIR,BPM,L1850];                     % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C1B      = [GIR,L6115,GIR,SD1K,L1715,QF1,L1350,BPM,L1265,SF1K,L2315,QF2,L1715,SD2K,GIR,L1565,GIR,BPM,L1850];                     % arc sector in between B1-B2 (low beta even-numbered straight sections)
C2A      = [GIR,L4615,GIR,SD3J,L1715,QF3,L2315,SF2J,L0780,FC,L0835,QF4,GIR,L4950,GIR,CV,L1050,L0420,BPM,RBPM,L0350];             % arc sector in between B2-BC (high beta odd-numbered straight sections)
C2B      = [GIR,L4615,GIR,SD3K,L1715,QF3,L2315,SF2K,L0780,FC,L0835,QF4,GIR,L4950,GIR,CV,L1050,L0420,BPM,RBPM,L0350];             % arc sector in between B2-BC (low beta even-numbered straight sections)
C2A_DCCT = [GIR,L4615,GIR,SD3J,L1715,QF3,L2315,SF2J,L0780,FC,L0835,QF4,GIR,L2550,DCCT1,L2400,GIR,CV,L1050,L0420,BPM,RBPM,L0350]; % arc sector in between B2-BC with DCCT1 (high beta odd-numbered straight sections)
C2B_DCCT = [GIR,L4615,GIR,SD3K,L1715,QF3,L2315,SF2K,L0780,FC,L0835,QF4,GIR,L2550,DCCT2,L2400,GIR,CV,L1050,L0420,BPM,RBPM,L0350]; % arc sector in between B2-BC with DCCT2 (low beta even-numbered straight sections)
C3A      = [GIR,L7150,GIR,BPM,RBPM,L1120,QF4,L0830,FC,L0785,SF2K,L2315,QF3,L1715,SD3K,GIR,L2765,GIR,BPM,L1850];                  % arc sector in between BC-B2 (high beta odd-numbered straight sections)
C3B      = [GIR,L7150,GIR,BPM,RBPM,L1120,QF4,L0830,FC,L0785,SF2J,L2315,QF3,L1715,SD3J,GIR,L2765,GIR,BPM,L1850];                  % arc sector in between BC-B2 (low beta even-numbered straight sections)
C4A      = [GIR,L3415,GIR,SD2K,L1715,QF2,L2315,SF1K,L1265,BPM,L1350,QF1,L1715,SD1K,GIR,L6115,GIR];                               % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C4B      = [GIR,L3415,GIR,SD2J,L1715,QF2,L2315,SF1J,L1265,BPM,L1350,QF1,L1715,SD1J,GIR,L6115,GIR];                               % arc sector in between B2-B1 (low beta even-numbered straight sections)



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
M1_S01 = M1A;     M2_S01 = M2A;     M1_S02 = M1B_FC;  M2_S02 = M2B_FC;
M1_S03 = M1A;     M2_S03 = M2A;     M1_S04 = M1B_FC;  M2_S04 = M2B_FC;
M1_S05 = M1A_FC;  M2_S05 = M2A_FC;  M1_S06 = M1B_FC;  M2_S06 = M2B_FC;
M1_S07 = M1A_FC;  M2_S07 = M2A_FC;  M1_S08 = M1B_FC;  M2_S08 = M2B_FC;
M1_S09 = M1A_FC;  M2_S09 = M2A_FC;  M1_S10 = M1B_FC;  M2_S10 = M2B_FC;
M1_S11 = M1A_FC;  M2_S11 = M2A_FC;  M1_S12 = M1B_FC;  M2_S12 = M2B_FC;
M1_S13 = M1A_FC;  M2_S13 = M2A_FC;  M1_S14 = M1B_FC;  M2_S14 = M2B_FC;
M1_S15 = M1A_FC;  M2_S15 = M2A_FC;  M1_S16 = M1B_FC;  M2_S16 = M2B_FC;
M1_S17 = M1A_FC;  M2_S17 = M2A_FC;  M1_S18 = M1B_FC;  M2_S18 = M2B_FC;
M1_S19 = M1A_FC;  M2_S19 = M2A_FC;  M1_S20 = M1B_FC;  M2_S20 = M2B_FC;

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

% adjusts RF frequency according to lattice length and synchronous condition
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
%rev_freq    = beta * const.c / L0_tot;
rev_freq    = const.c / L0_tot;
fprintf('   Circumference: %.5f m\n', L0_tot);

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

