function [ring, lattice_title] = local_si5_lattice(varargin)
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

%% global parameters
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'C';   % a = ac20, b = ac10(beta=4m), c = ac10(beta=1.5m)
version = '03';
strengths = @magnet_strengths;
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
%MOMACCEP = marker(m_accep_fam_name, 'IdentityPass');  %

% -- drifts --

LKK   = drift('lkk',  1.7630, 'DriftPass');
LPMU  = drift('lpmu', 0.3220, 'DriftPass');
LPMD  = drift('lpmd', 0.4629, 'DriftPass');
LIA   = drift('lia2', 1.5179, 'DriftPass');
LIB   = drift('lib2', 1.0879, 'DriftPass');

L035  = drift('l035', 0.035, 'DriftPass');
L050  = drift('l050', 0.050, 'DriftPass');
L061  = drift('l061', 0.061, 'DriftPass');
L066  = drift('l066', 0.066, 'DriftPass');
L074  = drift('l074', 0.074, 'DriftPass');
L077  = drift('l077', 0.077, 'DriftPass');
L081  = drift('l081', 0.081, 'DriftPass');
L083  = drift('l083', 0.083, 'DriftPass');
L105  = drift('l105', 0.105, 'DriftPass');
L112  = drift('l112', 0.112, 'DriftPass');
L125  = drift('l125', 0.125, 'DriftPass');
L134  = drift('l134', 0.134, 'DriftPass');
L135  = drift('l135', 0.135, 'DriftPass');
L140  = drift('l140', 0.140, 'DriftPass');
L150  = drift('l150', 0.150, 'DriftPass');
L155  = drift('l155', 0.155, 'DriftPass');
L170  = drift('l170', 0.170, 'DriftPass');
L216  = drift('l216', 0.216, 'DriftPass');
L230  = drift('l230', 0.230, 'DriftPass');
L240  = drift('l240', 0.240, 'DriftPass');
L275  = drift('l275', 0.275, 'DriftPass');
L336  = drift('l336', 0.336, 'DriftPass');
L419  = drift('l419', 0.419, 'DriftPass');
L474  = drift('l474', 0.474, 'DriftPass');
L500  = drift('l500', 0.500, 'DriftPass');
L537  = drift('l537', 0.537, 'DriftPass');
L715  = drift('l715', 0.715, 'DriftPass');


% -- dipoles --

%deg2rad = pi/180.0;
% B2E = rbend_sirius('b2', 1.231/3, 4.0964*deg2rad/3, 1.4143*deg2rad/2, 0,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
% B2M = rbend_sirius('b2', 1.231/3, 4.0964*deg2rad/3, 0, 0,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
% B2S = rbend_sirius('b2', 1.231/3, 4.0964*deg2rad/3, 0, 1.4143*deg2rad/2,   0, 0, 0, [0 0 0], [0 -0.78 0], bend_pass_method);
% B2  = [MOMACCEP,B2E,MOMACCEP,B2M,MOMACCEP,B2S,MOMACCEP];

[BC, ~] = sirius_si_bc_segmented_model(bend_pass_method, m_accep_fam_name);
[B1, ~] = sirius_si_b1_segmented_model(bend_pass_method, m_accep_fam_name);
[B2, ~] = sirius_si_b2_segmented_model(bend_pass_method, m_accep_fam_name);


% -- quadrupoles --

[QDA,  ~] = sirius_si_q14_segmented_model('qda',  qda_strength,  quad_pass_method);
[QDB2, ~] = sirius_si_q14_segmented_model('qdb2', qdb2_strength, quad_pass_method);
[QDB1, ~] = sirius_si_q14_segmented_model('qdb1', qdb1_strength, quad_pass_method);
[QFA,  ~] = sirius_si_q20_segmented_model('qfa',  qfa_strength,  quad_pass_method);
[QF1,  ~] = sirius_si_q20_segmented_model('qf1',  qf1_strength,  quad_pass_method);
[QF2,  ~] = sirius_si_q20_segmented_model('qf2',  qf2_strength,  quad_pass_method);
[QF3,  ~] = sirius_si_q20_segmented_model('qf3',  qf3_strength,  quad_pass_method);
[QF4,  ~] = sirius_si_q20_segmented_model('qf4',  qf4_strength,  quad_pass_method);
[QFB,  ~] = sirius_si_q30_segmented_model('qfb',  qfb_strength,  quad_pass_method);

% -- sextupoles --
SFA  = sextupole('sfa',   0.150, sfa_strength,  sext_pass_method); % CH-CV
SFPA = sextupole('sfpa',  0.150, sfpa_strength, sext_pass_method); % CH-CV
SFPB = sextupole('sfpb',  0.150, sfpb_strength, sext_pass_method); % CH-CV
SFB  = sextupole('sfb',   0.150, sfb_strength,  sext_pass_method); % CH-CV
SDA  = sextupole('sda',   0.150, sda_strength,  sext_pass_method); % QS
SDPA = sextupole('sdpa',  0.150, sdpa_strength, sext_pass_method); % QS
SDPB = sextupole('sdpb',  0.150, sdpb_strength, sext_pass_method); % QS
SDB  = sextupole('sdb',   0.150, sdb_strength,  sext_pass_method); % QS
SD1J = sextupole('sd1j',  0.150, sd1j_strength, sext_pass_method); % CH-CV
SD1K = sextupole('sd1k',  0.150, sd1k_strength, sext_pass_method); % CH-CV
SD1L = sextupole('sd1l',  0.150, sd1l_strength, sext_pass_method); % CH-CV
SD1M = sextupole('sd1m',  0.150, sd1m_strength, sext_pass_method); % CH-CV
SD2J = sextupole('sd2j',  0.150, sd2j_strength, sext_pass_method); % --
SD2K = sextupole('sd2k',  0.150, sd2k_strength, sext_pass_method); % --
SD2L = sextupole('sd2l',  0.150, sd2l_strength, sext_pass_method); % --
SD2M = sextupole('sd2m',  0.150, sd2m_strength, sext_pass_method); % --
SD3J = sextupole('sd3j',  0.150, sd3j_strength, sext_pass_method); % CV
SD3K = sextupole('sd3k',  0.150, sd3k_strength, sext_pass_method); % CV
SD3L = sextupole('sd3l',  0.150, sd3l_strength, sext_pass_method); % CV
SD3M = sextupole('sd3m',  0.150, sd3m_strength, sext_pass_method); % CV
SF1J = sextupole('sf1j',  0.150, sf1j_strength, sext_pass_method); % QS
SF1K = sextupole('sf1k',  0.150, sf1k_strength, sext_pass_method); % QS
SF1L = sextupole('sf1l',  0.150, sf1l_strength, sext_pass_method); % QS
SF1M = sextupole('sf1m',  0.150, sf1m_strength, sext_pass_method); % QS
SF2J = sextupole('sf2j',  0.150, sf2j_strength, sext_pass_method); % CH
SF2K = sextupole('sf2k',  0.150, sf2k_strength, sext_pass_method); % CH-CV
SF2L = sextupole('sf2l',  0.150, sf2l_strength, sext_pass_method); % CH
SF2M = sextupole('sf2m',  0.150, sf2m_strength, sext_pass_method); % CH-CV
% SD1N = sextupole('sd1n',  0.150, sd1j_strength, sext_pass_method); % CH-CV
% SD2N = sextupole('sd2n',  0.150, sd2j_strength, sext_pass_method); % --
% SD3N = sextupole('sd3n',  0.150, sd3j_strength, sext_pass_method); % CV
% SF1N = sextupole('sf1n',  0.150, sf1j_strength, sext_pass_method); % QS
% SF2N = sextupole('sf2n',  0.150, sf2j_strength, sext_pass_method); % CH
% SD1O = sextupole('sd1o',  0.150, sd1k_strength, sext_pass_method); % CH-CV
% SD2O = sextupole('sd2o',  0.150, sd2k_strength, sext_pass_method); % --
% SD3O = sextupole('sd3o',  0.150, sd3k_strength, sext_pass_method); % CV
% SF1O = sextupole('sf1o',  0.150, sf1k_strength, sext_pass_method); % QS
% SF2O = sextupole('sf2o',  0.150, sf2k_strength, sext_pass_method); % CH-CV
% SD1P = sextupole('sd1p',  0.150, sd1l_strength, sext_pass_method); % CH-CV
% SD2P = sextupole('sd2p',  0.150, sd2l_strength, sext_pass_method); % --
% SD3P = sextupole('sd3p',  0.150, sd3l_strength, sext_pass_method); % CV
% SF1P = sextupole('sf1p',  0.150, sf1l_strength, sext_pass_method); % QS
% SF2P = sextupole('sf2p',  0.150, sf2l_strength, sext_pass_method); % CH
% SD1Q = sextupole('sd1q',  0.150, sd1m_strength, sext_pass_method); % CH-CV
% SD2Q = sextupole('sd2q',  0.150, sd2m_strength, sext_pass_method); % --
% SD3Q = sextupole('sd3q',  0.150, sd3m_strength, sext_pass_method); % CV
% SF1Q = sextupole('sf1q',  0.150, sf1m_strength, sext_pass_method); % QS
% SF2Q = sextupole('sf2q',  0.150, sf2m_strength, sext_pass_method); % CH-CV


% --- slow correctors ---
CV   = sextupole('cv',        0.150, 0.0, sext_pass_method); % same model as BO correctors

% -- pulsed magnets --
KICKIN = drift('kick_in', 0.500, 'DriftPass'); % injection kicker
PMM    = drift('pmm',     0.470, 'DriftPass'); % pulsed multipole magnet

% -- bpms and fast correctors --
FC     = drift('fc', 0.100, 'DriftPass');

% -- rf cavities --
RFC = rfcavity('cav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');

% -- lattice markers --
START  = marker('start',    'IdentityPass'); % start of the model
END    = marker('end',      'IdentityPass'); % end of the model
MIA    = marker('mia',      'IdentityPass'); % center of long straight sections (even-numbered)
MIB    = marker('mib',      'IdentityPass'); % center of short straight sections (odd-numbered)


%% transport lines

M2A      = [L135,SFA,L150,QFA,L074,FC,L066,SDA,L150,QDA,L134];                          % high beta xxM2 girder (with fasc corrector)
M1A      = fliplr(M2A);                                                                 % high beta xxM1 girder (with fast correctors)
IDA      = [L500,LIA,L500,L500,L500,MIA,L500,L500,L500,LIA,L500];                       % high beta ID straight section
INJ      = [L500,LIA,L419,L500,L500,L081,END,START,MIA, LKK, KICKIN, LPMU, PMM, LPMD];  % high beta INJ straight section
M1B      = [L134,QDB1,L150,SDB,L240,QFB,L150,SFB,L050,FC,L035,QDB2,L140];               % low beta xxM1 girder
M2B      = fliplr(M1B);                                                                 % low beta xxM2 girder
IDB      = [L500,LIB,L500,L500,L500,MIB,L500,L500,L500,LIB,L500];                       % low beta ID straight section
CAV      = [L500,LIB,L500,L500,L500,MIB,RFC,L500,L500,L500,LIB,L500];                   % low beta RF cavity straight section
M1PA     = [L134,QDB1,L150,SDPA,L240,QFB,L150,SFPA,L050,FC,L035,QDB2,L140];               % low beta xxM1 girder
M2PA     = fliplr(M1PA);                                                                 % low beta xxM2 girder
M1PB     = [L134,QDB1,L150,SDPB,L240,QFB,L150,SFPB,L050,FC,L035,QDB2,L140];               % low beta xxM1 girder
M2PB     = fliplr(M1PB);                                                                 % low beta xxM2 girder
IDP      = [L500,LIB,L500,L500,L500,MIB,L500,L500,L500,LIB,L500];                       % low beta ID straight section


C1A      = [L474,SD1J,L170,QF1,L135,L125,SF1J,L230,QF2,L170,SD2J,L155,L061];            % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C1B      = [L474,SD1K,L170,QF1,L135,L125,SF1K,L230,QF2,L170,SD2K,L155,L061];            % arc sector in between B1-B2 (low beta even-numbered straight sections)
C1PA     = [L474,SD1L,L170,QF1,L135,L125,SF1L,L230,QF2,L170,SD2L,L155,L061];            % arc sector in between B1-B2 (low beta even-numbered straight sections)
C1PB     = [L474,SD1M,L170,QF1,L135,L125,SF1M,L230,QF2,L170,SD2M,L155,L061];            % arc sector in between B1-B2 (low beta even-numbered straight sections)
C2A      = [L336,SD3J,L170,QF3,L230,SF2J,L077,FC,L083,QF4,L537,CV,L105,L035];           % arc sector in between B2-BC (high beta odd-numbered straight sections)
C2B      = [L336,SD3K,L170,QF3,L230,SF2K,L077,FC,L083,QF4,L537,CV,L105,L035];           % arc sector in between B2-BC (low beta even-numbered straight sections)
C2PA     = [L336,SD3L,L170,QF3,L230,SF2L,L077,FC,L083,QF4,L537,CV,L105,L035];           % arc sector in between B2-BC (low beta even-numbered straight sections)
C2PB     = [L336,SD3M,L170,QF3,L230,SF2M,L077,FC,L083,QF4,L537,CV,L105,L035];           % arc sector in between B2-BC (low beta even-numbered straight sections)
C3A      = [L715,L112,QF4,L083,FC,L077,SF2J,L230,QF3,L170,SD3J,L275,L061];              % arc sector in between BC-B2 (high beta odd-numbered straight sections)
C3B      = [L715,L112,QF4,L083,FC,L077,SF2K,L230,QF3,L170,SD3K,L275,L061];              % arc sector in between BC-B2 (low beta even-numbered straight sections)
C3PA     = [L715,L112,QF4,L083,FC,L077,SF2L,L230,QF3,L170,SD3L,L275,L061];              % arc sector in between BC-B2 (low beta even-numbered straight sections)
C3PB     = [L715,L112,QF4,L083,FC,L077,SF2M,L230,QF3,L170,SD3M,L275,L061];              % arc sector in between BC-B2 (low beta even-numbered straight sections)
C4A      = [L216,SD2J,L170,QF2,L230,SF1J,L125,L135,QF1,L170,SD1J,L474];                 % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C4B      = [L216,SD2K,L170,QF2,L230,SF1K,L125,L135,QF1,L170,SD1K,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4PA     = [L216,SD2L,L170,QF2,L230,SF1L,L125,L135,QF1,L170,SD1L,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4PB     = [L216,SD2M,L170,QF2,L230,SF1M,L125,L135,QF1,L170,SD1M,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
% C3A      = [L715,L112,QF4,L083,FC,L077,SF2N,L230,QF3,L170,SD3N,L275,L061];              % arc sector in between BC-B2 (high beta odd-numbered straight sections)
% C3B      = [L715,L112,QF4,L083,FC,L077,SF2O,L230,QF3,L170,SD3O,L275,L061];              % arc sector in between BC-B2 (low beta even-numbered straight sections)
% C3PA     = [L715,L112,QF4,L083,FC,L077,SF2P,L230,QF3,L170,SD3P,L275,L061];              % arc sector in between BC-B2 (low beta even-numbered straight sections)
% C3PB     = [L715,L112,QF4,L083,FC,L077,SF2Q,L230,QF3,L170,SD3Q,L275,L061];              % arc sector in between BC-B2 (low beta even-numbered straight sections)
% C4A      = [L216,SD2N,L170,QF2,L230,SF1N,L125,L135,QF1,L170,SD1N,L474];                 % arc sector in between B2-B1 (high beta odd-numbered straight sections)
% C4B      = [L216,SD2O,L170,QF2,L230,SF1O,L125,L135,QF1,L170,SD1O,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
% C4PA     = [L216,SD2P,L170,QF2,L230,SF1P,L125,L135,QF1,L170,SD1P,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
% C4PB     = [L216,SD2Q,L170,QF2,L230,SF1Q,L125,L135,QF1,L170,SD1Q,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)



%% GIRDERS

% straight sections
SS_S01 = INJ; SS_S02 = IDP;
SS_S03 = CAV; SS_S04 = IDP;
SS_S05 = IDA; SS_S06 = IDP;
SS_S07 = IDB; SS_S08 = IDP;
SS_S09 = IDA; SS_S10 = IDP;
SS_S11 = IDB; SS_S12 = IDP;
SS_S13 = IDA; SS_S14 = IDP;
SS_S15 = IDB; SS_S16 = IDP;
SS_S17 = IDA; SS_S18 = IDP;
SS_S19 = IDB; SS_S20 = IDP;

% down and upstream straight sections
M1_S01 = M1A;  M2_S01 = M2A;
M1_S02 = M1PA; M2_S02 = M2PB;
M1_S03 = M1B;  M2_S03 = M2B;
M1_S04 = M1PB; M2_S04 = M2PA;
M1_S05 = M1A;  M2_S05 = M2A;
M1_S06 = M1PA; M2_S06 = M2PB;
M1_S07 = M1B;  M2_S07 = M2B;
M1_S08 = M1PB; M2_S08 = M2PA;
M1_S09 = M1A;  M2_S09 = M2A;
M1_S10 = M1PA; M2_S10 = M2PB;
M1_S11 = M1B;  M2_S11 = M2B;
M1_S12 = M1PB; M2_S12 = M2PA;
M1_S13 = M1A;  M2_S13 = M2A;
M1_S14 = M1PA; M2_S14 = M2PB;
M1_S15 = M1B;  M2_S15 = M2B;
M1_S16 = M1PB; M2_S16 = M2PA;
M1_S17 = M1A;  M2_S17 = M2A;
M1_S18 = M1PA; M2_S18 = M2PB;
M1_S19 = M1B;  M2_S19 = M2B;
M1_S20 = M1PB; M2_S20 = M2PA;

% dispersive arcs
C1_S01 = C1A; C2_S01 = C2A;    C3_S01 = C3PA;C4_S01 = C4PA;
C1_S02 = C1PB;C2_S02 = C2PB;   C3_S02 = C3B; C4_S02 = C4B;
C1_S03 = C1B; C2_S03 = C2B;    C3_S03 = C3PB;C4_S03 = C4PB;
C1_S04 = C1PA;C2_S04 = C2PA;   C3_S04 = C3A; C4_S04 = C4A;
C1_S05 = C1A; C2_S05 = C2A;    C3_S05 = C3PA;C4_S05 = C4PA;
C1_S06 = C1PB;C2_S06 = C2PB;   C3_S06 = C3B; C4_S06 = C4B;
C1_S07 = C1B; C2_S07 = C2B;    C3_S07 = C3PB;C4_S07 = C4PB;
C1_S08 = C1PA;C2_S08 = C2PA;   C3_S08 = C3A; C4_S08 = C4A;
C1_S09 = C1A; C2_S09 = C2A;    C3_S09 = C3PA;C4_S09 = C4PA;
C1_S10 = C1PB;C2_S10 = C2PB;   C3_S10 = C3B; C4_S10 = C4B;
C1_S11 = C1B; C2_S11 = C2B;    C3_S11 = C3PB;C4_S11 = C4PB;
C1_S12 = C1PA;C2_S12 = C2PA;   C3_S12 = C3A; C4_S12 = C4A;
C1_S13 = C1A; C2_S13 = C2A;    C3_S13 = C3PA;C4_S13 = C4PA;
C1_S14 = C1PB;C2_S14 = C2PB;   C3_S14 = C3B; C4_S14 = C4B;
C1_S15 = C1B; C2_S15 = C2B;    C3_S15 = C3PB;C4_S15 = C4PB;
C1_S16 = C1PA;C2_S16 = C2PA;   C3_S16 = C3A; C4_S16 = C4A;
C1_S17 = C1A; C2_S17 = C2A;    C3_S17 = C3PA;C4_S17 = C4PA;
C1_S18 = C1PB;C2_S18 = C2PB;   C3_S18 = C3B; C4_S18 = C4B;
C1_S19 = C1B; C2_S19 = C2B;    C3_S19 = C3PB;C4_S19 = C4PB;
C1_S20 = C1PA;C2_S20 = C2PA;   C3_S20 = C3A; C4_S20 = C4A;

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

ring = buildlat(elist);
ring = setcellstruct(ring, 'Energy', 1:length(ring), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(ring, 'FamName', 'start');
if ~isempty(idx)
    ring = [ring(idx:end) ring(1:idx-1)];
end

% checks if there are negative-drift elements
lens = getcellstruct(ring, 'Length', 1:length(ring));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
const  = lnls_constants;
L0_tot = findspos(ring, length(ring)+1);
%rev_freq    = beta * const.c / L0_tot;
rev_freq    = const.c / L0_tot;

rf_idx      = findcells(ring, 'FamName', 'cav');
rf_frequency = rev_freq * harmonic_number;
ring{rf_idx}.Frequency = rf_frequency;

% by default cavities and radiation is set to off
ring = setcavity('off',ring);
ring = setradiation('off',ring);

% sets default NumIntSteps values for elements
ring = set_num_integ_steps(ring);

% % define vacuum chamber for all elements
% THERING = set_vacuum_chamber(THERING);

% defines girders
ring = set_girders(ring);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

ring = combinebypassmethod(ring,'DriftPass',[],[]);
mia = findcells(ring,'FamName','mia');
ring = ring(1:mia(2));



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
