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
% 2015-11-03: agora modelo do BC ?? segmentado
% 2017-02-08: updated dipole B1 and B2 versions, updated FamNames, updated sys multi of fast correctors (xrr)
% 2018-10-16: new BC model-13
% 2-18-12-13: updated girder definitions and updated model with B2 measured integrated quads

global THERING;


%% global parameters
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'S05';
version = '01';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V24.02';
% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i})
        if any(strcmpi(varargin{i},{'01','02','03'}))
            version = varargin{i};
        elseif any(strcmpi(varargin{i},{'S05','S10'}))
            mode = varargin{i};
        else
            fprintf(['%s was not identified as a valid version or mode.\n',...
                     'Continuing with default setup.'],varargin{i});
        end
    elseif isa(varargin{i},'function_handle')
        strengths = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

lattice_title = [lattice_version, '_', mode, '.', version];
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
%MOMACCEP = marker(m_accep_fam_name, 'IdentityPass');  %

% -- drifts --

LKK   = drift('lkk',  1.9150, 'DriftPass');
LPMU  = drift('lpmu', 0.0600, 'DriftPass');
LPMD  = drift('lpmd', 0.4929, 'DriftPass');
LIA   = drift('lia',  1.5179, 'DriftPass');
LIB   = drift('lib',  1.0879, 'DriftPass');
LIP   = drift('lip',  1.0879, 'DriftPass');

L011  = drift('l011', 0.011, 'DriftPass');
L049  = drift('l049', 0.049, 'DriftPass');
L052  = drift('l052', 0.052, 'DriftPass');
L056  = drift('l056', 0.056, 'DriftPass');
L074  = drift('l074', 0.074, 'DriftPass');
L075  = drift('l075', 0.075, 'DriftPass');
L081  = drift('l081', 0.081, 'DriftPass');
L082  = drift('l082', 0.082, 'DriftPass');
L090  = drift('l090', 0.090, 'DriftPass');
L100  = drift('l100', 0.100, 'DriftPass');
L112  = drift('l112', 0.112, 'DriftPass');
L118  = drift('l118', 0.118, 'DriftPass');
L119  = drift('l119', 0.119, 'DriftPass');
L120  = drift('l120', 0.120, 'DriftPass');
L125  = drift('l125', 0.125, 'DriftPass');
L127  = drift('l127', 0.127, 'DriftPass');
L133  = drift('l133', 0.133, 'DriftPass');
L134  = drift('l134', 0.134, 'DriftPass');
L135  = drift('l135', 0.135, 'DriftPass');
L140  = drift('l140', 0.140, 'DriftPass');
L150  = drift('l150', 0.150, 'DriftPass');
L170  = drift('l170', 0.170, 'DriftPass');
L200  = drift('l200', 0.200, 'DriftPass');
L201  = drift('l201', 0.201, 'DriftPass');
L205  = drift('l205', 0.205, 'DriftPass');
L216  = drift('l216', 0.216, 'DriftPass');
L230  = drift('l230', 0.230, 'DriftPass');
L237  = drift('l237', 0.237, 'DriftPass');
L240  = drift('l240', 0.240, 'DriftPass');
L260  = drift('l260', 0.260, 'DriftPass');
L325  = drift('l325', 0.325, 'DriftPass');
L336  = drift('l336', 0.336, 'DriftPass');
L419  = drift('l419', 0.419, 'DriftPass');
L474  = drift('l474', 0.474, 'DriftPass');
L500  = drift('l500', 0.500, 'DriftPass');
L715  = drift('l715', 0.715, 'DriftPass');



% -- dipoles --

[BC, ~] = sirius_si_bc_segmented_model(bend_pass_method, m_accep_fam_name);
[B1, ~] = sirius_si_b1_segmented_model(bend_pass_method, m_accep_fam_name);
[B2, ~] = sirius_si_b2_segmented_model(bend_pass_method, m_accep_fam_name);


% -- quadrupoles --

[QFA, ~] = sirius_si_q20_segmented_model('QFA', QFA_strength,  quad_pass_method);
[QDA, ~] = sirius_si_q14_segmented_model('QDA', QDA_strength,  quad_pass_method);
[QDB2,~] = sirius_si_q14_segmented_model('QDB2',QDB2_strength, quad_pass_method);
[QFB, ~] = sirius_si_q30_segmented_model('QFB', QFB_strength,  quad_pass_method);
[QDB1,~] = sirius_si_q14_segmented_model('QDB1',QDB1_strength, quad_pass_method);
[QDP2,~] = sirius_si_q14_segmented_model('QDP2',QDP2_strength, quad_pass_method);
[QFP, ~] = sirius_si_q30_segmented_model('QFP', QFP_strength,  quad_pass_method);
[QDP1,~] = sirius_si_q14_segmented_model('QDP1',QDP1_strength, quad_pass_method);
[Q1,  ~] = sirius_si_q20_segmented_model('Q1',  Q1_strength,  quad_pass_method);
[Q2,  ~] = sirius_si_q20_segmented_model('Q2',  Q2_strength,  quad_pass_method);
[Q3,  ~] = sirius_si_q20_segmented_model('Q3',  Q3_strength,  quad_pass_method);
[Q4,  ~] = sirius_si_q20_segmented_model('Q4',  Q4_strength,  quad_pass_method);


% % -- sextupoles --
SDA0 = sextupole('SDA0', 0.150, SDA0_strength, sext_pass_method); %
SDB0 = sextupole('SDB0', 0.150, SDB0_strength, sext_pass_method); %
SDP0 = sextupole('SDP0', 0.150, SDP0_strength, sext_pass_method); %
SDA1 = sextupole('SDA1', 0.150, SDA1_strength, sext_pass_method); %
SDB1 = sextupole('SDB1', 0.150, SDB1_strength, sext_pass_method); %
SDP1 = sextupole('SDP1', 0.150, SDP1_strength, sext_pass_method); %
SDA2 = sextupole('SDA2', 0.150, SDA2_strength, sext_pass_method); %
SDB2 = sextupole('SDB2', 0.150, SDB2_strength, sext_pass_method); %
SDP2 = sextupole('SDP2', 0.150, SDP2_strength, sext_pass_method); %
SDA3 = sextupole('SDA3', 0.150, SDA3_strength, sext_pass_method); %
SDB3 = sextupole('SDB3', 0.150, SDB3_strength, sext_pass_method); %
SDP3 = sextupole('SDP3', 0.150, SDP3_strength, sext_pass_method); %
SFA0 = sextupole('SFA0', 0.150, SFA0_strength, sext_pass_method); %
SFB0 = sextupole('SFB0', 0.150, SFB0_strength, sext_pass_method); %
SFP0 = sextupole('SFP0', 0.150, SFP0_strength, sext_pass_method); %
SFA1 = sextupole('SFA1', 0.150, SFA1_strength, sext_pass_method); %
SFB1 = sextupole('SFB1', 0.150, SFB1_strength, sext_pass_method); %
SFP1 = sextupole('SFP1', 0.150, SFP1_strength, sext_pass_method); %
SFA2 = sextupole('SFA2', 0.150, SFA2_strength, sext_pass_method); %
SFB2 = sextupole('SFB2', 0.150, SFB2_strength, sext_pass_method); %
SFP2 = sextupole('SFP2', 0.150, SFP2_strength, sext_pass_method); %

% --- slow correctors ---
CV   = sextupole('CV', 0.150, 0.0, sext_pass_method);   % same model as BO correctors

% -- pulsed magnets --
InjDpKckr = sextupole('InjDpKckr', 0.400, 0.0, sext_pass_method); % injection kicker
InjNLKckr = sextupole('InjNLKckr',  0.450, 0.0, sext_pass_method); % pulsed multipole magnet
PingV  = marker('PingV', 'IdentityPass');                    % Vertical Pinger

% -- BPMs and fast correctors --
FC1 = sextupole('FC1', 0.084, 0.0, sext_pass_method); % 70 magnets: skew quad poles (CH+CV adn CH+CV+QS)
FC2 = sextupole('FC2', 0.082, 0.0, sext_pass_method); % 10 magnets: normal quad poles (CH+CV adn CH+CV+QS)


% -- rf cavities --
RFC = rfcavity('SRFCav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');
HCav = marker('H3Cav', 'IdentityPass');

% -- lattice markers --
START  = marker('start',    'IdentityPass'); % start of the model
END    = marker('end',      'IdentityPass'); % end of the model
MIA    = marker('mia',      'IdentityPass'); % center of long straight sections (even-numbered)
MIB    = marker('mib',      'IdentityPass'); % center of short straight sections (odd-numbered)
MIP    = marker('mip',      'IdentityPass'); % center of short straight sections (even-numbered)
% GIR    = marker('girder',   'IdentityPass'); % marker used to delimitate girders. one marker at begin and another at end of girder.
MIDA   = marker('id_enda',  'IdentityPass'); % marker for the extremities of IDs in long straight sections
MIDB   = marker('id_endb',  'IdentityPass'); % marker for the extremities of IDs in short straight sections
MIDP   = marker('id_endp',  'IdentityPass'); % marker for the extremities of IDs in short straight sections
InjSeptF  = marker('InjSeptF',    'IdentityPass'); % end of thin injection septum

% -- diagnostics markers --
BPM    = marker('BPM',    'IdentityPass');
DCCT   = marker('DCCT',   'IdentityPass'); % DCCT to measure beam current
ScrapH = marker('ScrapH', 'IdentityPass'); % horizontal scraper
ScrapV = marker('ScrapV', 'IdentityPass'); % vertical scraper
GSL15  = marker('GSL15',  'IdentityPass'); % Generic Stripline (lambda/4)
GSL07  = marker('GSL07',  'IdentityPass'); % Generic Stripline (lambda/8)
GBPM   = marker('GBPM',   'IdentityPass'); % General BPM
BbBPkup   = marker('BbBPkup',   'IdentityPass'); % Bunch-by-Bunch Pickup
BbBKckrH  = marker('BbBKckrH',  'IdentityPass'); % Horizontal Bunch-by-Bunch Shaker
BbBKckrV  = marker('BbBKckrV',  'IdentityPass'); % Vertical Bunch-by-Bunch Shaker

BbBKckL   = marker('BbBKckrL',  'IdentityPass'); % Longitudinal Bunch-by-Bunch Shaker

TuneShkrH = marker('TuneShkrH', 'IdentityPass'); % Horizontal Tune Shaker
TuneShkrV = marker('TuneShkrV', 'IdentityPass'); % Vertical Tune Shaker
TunePkup = marker('TunePkup', 'IdentityPass'); % Tune Pickup


%% transport lines
M1A      = [L134,QDA,L150,SDA0,L074,FC1,L082,QFA,L150,SFA0,L135,BPM];                % high beta xxM1 girder (with fast corrector)
M1B      = [L134,QDB1,L150,SDB0,L240,QFB,L150,SFB0,L049,FC1,L052,QDB2,L140,BPM];     % low beta xxM1 girder
M1P      = [L134,QDP1,L150,SDP0,L240,QFP,L150,SFP0,L049,FC1,L052,QDP2,L140,BPM];     % low beta xxM1 girder
M2A      = fliplr(M1A);                                                              % high beta xxM2 girder (with fast correctors)
M2B      = fliplr(M1B);                                                              % low beta xxM2 girder
M2P      = fliplr(M1P);                                                              % low beta xxM2 girder

M1B_BbBPkup = [L134,QDB1,L150,SDB0,L120,BbBPkup,L120,QFB,L150,SFB0,L049,FC1,L052,QDB2,L140,BPM];

IDA        = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                              % high beta ID straight section
IDA_INJ    = [L500,TuneShkrH,LIA,L419,InjSeptF,L081,L500,L500,END,START,MIA,...
              LKK,InjDpKckr,LPMU,ScrapV,L100,ScrapV,L100,InjNLKckr,LPMD];                                  % high beta INJ straight section and Scrapers
IDA_BbBKckrH  = [L500,BbBKckrH,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                  % high beta ID straight section
IDA_ScrapH    = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,ScrapH,LIA,L500];                    % high beta ID straight section
IDA17         = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,BbBKckrH,LIA,L500];                  % high beta ID straight section

IDB        = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,L500];                              % low beta ID straight section
IDB_GSL07    = [L500,GSL07,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,L500];                      % low beta ID straight section
IDB_TunePkup = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,TunePkup,LIB,L500];                   % low beta ID straight section
IDB02      = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,HCav,LIB,L500];                         % low beta ID straight section
IDB16      = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,BbBKckL,LIB,L500];                      % low beta ID straight section

IDP        = [L500,LIP,L500,MIDP,L500,L500,MIP,L500,L500,MIDP,L500,LIP,L500];                              % low beta ID straight section
IDP_CAV    = [L500,LIP,L500,L500,L500,MIP,RFC,L500,L500,L500,LIP,L500];                                    % low beta RF cavity straight section
IDP_GSL15  = [L500,GSL15,LIP,L500,MIDP,L500,L500,MIP,L500,L500,MIDP,L500, LIP,L500];                       % low beta ID straight section

C1A      = [L474,SDA1,L170,Q1,L135,BPM,L125,SFA1,L230,Q2,L170,SDA2,L205,BPM,L011];         % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C1B      = [L474,SDB1,L170,Q1,L135,BPM,L125,SFB1,L230,Q2,L170,SDB2,L205,BPM,L011];         % arc sector in between B1-B2 (low beta even-numbered straight sections)
C1P      = [L474,SDP1,L170,Q1,L135,BPM,L125,SFP1,L230,Q2,L170,SDP2,L205,BPM,L011];         % arc sector in between B1-B2 (low beta even-numbered straight sections)

C2A      = [L336,SDA3,L170,Q3,L230,SFA2,L260,Q4,L200,CV,L201,FC2,L119,BPM,L075];           % arc sector in between B2-BC (high beta odd-numbered straight sections)
C2B      = [L336,SDB3,L170,Q3,L230,SFB2,L260,Q4,L200,CV,L200,FC1,L118,BPM,L075];           % arc sector in between B2-BC (low beta even-numbered straight sections)
C2P      = [L336,SDP3,L170,Q3,L230,SFP2,L260,Q4,L200,CV,L201,FC2,L119,BPM,L075];           % arc sector in between B2-BC (low beta even-numbered straight sections)

C3A      = [L715,L112,Q4,L133,BPM,L127,SFA2,L056,FC1,L090,Q3,L170,SDA3,L325,BPM,L011];     % arc sector in between BC-B2 (high beta odd-numbered straight sections)
C3B      = [L715,L112,Q4,L133,BPM,L127,SFB2,L056,FC1,L090,Q3,L170,SDB3,L325,BPM,L011];     % arc sector in between BC-B2 (low beta even-numbered straight sections)
C3P      = [L715,L112,Q4,L133,BPM,L127,SFP2,L056,FC1,L090,Q3,L170,SDP3,L325,BPM,L011];     % arc sector in between BC-B2 (low beta even-numbered straight sections)

C4A          = [L216,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,L474];               % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C4A_BbBKckrV = [L216,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,L237,BbBKckrV,L237]; % arc sector in between B2-B1 (high beta odd-numbered straight sections)

C4B        = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L474];                 % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_GBPM   = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,GBPM,L474];            % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_DCCT   = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,DCCT,L237];       % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_TunePkup = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,TunePkup,L237]; % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_PingV  = [L216,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,PingV,L237];      % arc sector in between B2-B1 (low beta even-numbered straight sections)

C4P        = [L216,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L474];                   % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4P_DCCT   = [L216,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L237,DCCT,L237];         % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4P_TuneShkrV = [L216,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L237,TuneShkrV,L237]; % arc sector in between B2-B1 (low beta even-numbered straight sections)

%% GIRDERS

% straight sections
SS_S01 = IDA_INJ;
SS_S02 = IDB02;
SS_S03 = IDP_CAV;
SS_S04 = IDB;
SS_S05 = IDA_ScrapH;
SS_S06 = IDB;
SS_S07 = IDP;
SS_S08 = IDB;
SS_S09 = IDA;
SS_S10 = IDB;
SS_S11 = IDP;
SS_S12 = IDB;
SS_S13 = IDA_BbBKckrH;
SS_S14 = IDB;
SS_S15 = IDP;
SS_S16 = IDB16;
SS_S17 = IDA17;
SS_S18 = IDB_TunePkup;
SS_S19 = IDP_GSL15;
SS_S20 = IDB_GSL07;

% down and upstream straight sections
M1_S01 = M1A;       M2_S01 = M2A;       M1_S02 = M1B;      M2_S02 = M2B;
M1_S03 = M1P;       M2_S03 = M2P;       M1_S04 = M1B;      M2_S04 = M2B;
M1_S05 = M1A;       M2_S05 = M2A;       M1_S06 = M1B;      M2_S06 = M2B;
M1_S07 = M1P;       M2_S07 = M2P;       M1_S08 = M1B;      M2_S08 = M2B;
M1_S09 = M1A;       M2_S09 = M2A;       M1_S10 = M1B;      M2_S10 = M2B;
M1_S11 = M1P;       M2_S11 = M2P;       M1_S12 = M1B_BbBPkup; M2_S12 = M2B;
M1_S13 = M1A;       M2_S13 = M2A;       M1_S14 = M1B;      M2_S14 = M2B;
M1_S15 = M1P;       M2_S15 = M2P;       M1_S16 = M1B;      M2_S16 = M2B;
M1_S17 = M1A;       M2_S17 = M2A;       M1_S18 = M1B;      M2_S18 = M2B;
M1_S19 = M1P;       M2_S19 = M2P;       M1_S20 = M1B;      M2_S20 = M2B;

% dispersive arcs
C1_S01 = C1A; C2_S01 = C2A;    C3_S01 = C3B; C4_S01 = C4B;
C1_S02 = C1B; C2_S02 = C2B;    C3_S02 = C3P; C4_S02 = C4P;
C1_S03 = C1P; C2_S03 = C2P;    C3_S03 = C3B; C4_S03 = C4B;
C1_S04 = C1B; C2_S04 = C2B;    C3_S04 = C3A; C4_S04 = C4A;
C1_S05 = C1A; C2_S05 = C2A;    C3_S05 = C3B; C4_S05 = C4B;
C1_S06 = C1B; C2_S06 = C2B;    C3_S06 = C3P; C4_S06 = C4P;
C1_S07 = C1P; C2_S07 = C2P;    C3_S07 = C3B; C4_S07 = C4B;
C1_S08 = C1B; C2_S08 = C2B;    C3_S08 = C3A; C4_S08 = C4A;
C1_S09 = C1A; C2_S09 = C2A;    C3_S09 = C3B; C4_S09 = C4B;
C1_S10 = C1B; C2_S10 = C2B;    C3_S10 = C3P; C4_S10 = C4P;
C1_S11 = C1P; C2_S11 = C2P;    C3_S11 = C3B; C4_S11 = C4B;
C1_S12 = C1B; C2_S12 = C2B;    C3_S12 = C3A; C4_S12 = C4A;
C1_S13 = C1A; C2_S13 = C2A;    C3_S13 = C3B; C4_S13 = C4B_DCCT;
C1_S14 = C1B; C2_S14 = C2B;    C3_S14 = C3P; C4_S14 = C4P_DCCT;
C1_S15 = C1P; C2_S15 = C2P;    C3_S15 = C3B; C4_S15 = C4B_GBPM;
C1_S16 = C1B; C2_S16 = C2B;    C3_S16 = C3A; C4_S16 = C4A_BbBKckrV;
C1_S17 = C1A; C2_S17 = C2A;    C3_S17 = C3B; C4_S17 = C4B_TunePkup;
C1_S18 = C1B; C2_S18 = C2B;    C3_S18 = C3P; C4_S18 = C4P_TuneShkrV;
C1_S19 = C1P; C2_S19 = C2P;    C3_S19 = C3B; C4_S19 = C4B_PingV;
C1_S20 = C1B; C2_S20 = C2B;    C3_S20 = C3A; C4_S20 = C4A;


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

rf_idx      = findcells(THERING, 'FamName', 'SRFCav');
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
% THERING = set_girders_new(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

% update models with measurement data
THERING = sirius_si_models_from_measurements(THERING);

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
%the_ring(gir) = [];


function the_ring = set_girders_new(the_ring)


% girders.M2A_01 = {'BPM', 'FC1'};
% girders.B1A_01 = {'SDA0', 'B1'};
% girders.C1_01 = {'SDA1', 'SDA2'};
% girders.B2_01 = {'B2', 'B2'};
% girders.C2_01 = {'SDA3', 'CV'};
% girders.BC_01 = {'FC2', 'BC'};
% girders.C3_01 = {'Q4', 'SDB3'};
% girders.B2_02 = {'B2', 'B2'};
% girders.C4_01 = {'SDB2', 'SDB1'};
% girders.B1B_01 = {'B1', 'QDB1'};
%
% M2A_01 BPM FC1
% M2B_01 BPM QFB
% M2A_02 BPM QFP
% M2B_02 BPM QFB
%
% M2A_01 BPM FC1
% M2B_01 BPM QFB
% M2A_02 BPM QFP
% M2B_02 BPM QFB
%
%
% B1A_01 SDA0 B1
% C1_01 SDA1 SDA2
% B2_01 B2 B2
% C2_01 SDA3 CV
% BC_01 FC2 BC
% C3_01 Q4 SDB3
% B2_02 B2 B2
% C4_01 SDB2 SDB1
% B1B_01 B1 SDB0
% M1B_01 QFB QDB2
%
% B1A_01 SDB0 B1
% C1_02 SDB1 SDB2
% B2_03 B2 B2
% C2_02 SDB3 CV
% BC_02 FC2 BC
% C3_02 Q4 SDP3
% B2_04 B2 B2
% C4_02 SDP2 SDP1
% B1B_02 B1 SDP0
% M1B_02 QFP QDP2
%
% B1A_01 SDA0 B1
% C1_01 SDA1 SDA2
% B2_01 B2 B2
% C2_01 SDA3 CV
% BC_01 FC2 BC
% C3_01 Q4 SDB3
% B2_02 B2 B2
% C4_01 SDB2 SDB1
% B1B_01 B1 SDB0
% M1B_01 QFB QDB2
%
%
%
%
% % loops through lattice, identifying start-stop indices of each girder.
% idx = 1;
% gfs = fields(girders);
% for i=1:length(gfs)
%   girder = gfs{i};
%   disp(girder);
%   start = girders.(girder){1};
%   stop = girders.(girder){2};
%   % search begin of girder
%   while ~strcmp(the_ring{idx}.FamName, start)
%       idx = idx+1;
%   end
%   idx1 = idx;
%   % search end of girder
%   while ~strcmp(the_ring{idx}.FamName, stop)
%       idx = idx+1;
%   end
%   while strcmp(the_ring{idx}.FamName, stop) || strcmp(the_ring{idx}.PassMethod, 'IdentityPass')
%       idx = idx+1;
%   end
%   idx2 = idx-1;
%   % insert girder field in the lattice
%   the_ring = setcellstruct(the_ring, 'Girder', idx1:idx2, girder);
% %   disp([idx1, idx2]);
% %   disp(the_ring{idx1});
% %   disp(the_ring{idx2});
% end
%
% return


famdata = sirius_si_family_data(the_ring);

% --- M2A girders
bpms = famdata.BPM.ATIndex(1:32:end,:);
fc1 = famdata.FC1.ATIndex(1:14:end,:);
for i=1:10
    inds = bpms(i,1):fc1(i,end);
    printlattice(the_ring(inds));
    the_ring = setcellstruct(the_ring, 'Girder', inds, sprintf('M2A_%02d', i));
end


% % --- M2B girders
% bpms = famdata.BPM.ATIndex(8:;
% qfb = famdata.QFB.ATIndex;
% the_ring = setcellstruct(the_ring, 'Girder', bpms(1,1):qfb(1,end), 'M2B_01');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(2,1):fc1(2,end), 'M2B_02');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(3,1):fc1(3,end), 'M2B_03');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(4,1):fc1(4,end), 'M2B_04');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(5,1):fc1(5,end), 'M2B_05');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(6,1):fc1(6,end), 'M2B_06');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(7,1):fc1(7,end), 'M2B_07');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(8,1):fc1(8,end), 'M2B_08');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(9,1):fc1(9,end), 'M2B_09');
% the_ring = setcellstruct(the_ring, 'Girder', bpms(10,1):fc1(10,end), 'M2B_10');


% --- B2 girders
idx = famdata.B2.ATIndex;
for i=1:size(idx,1)
  gname = sprintf('B2_%03d', i);
  the_ring = setcellstruct(the_ring, 'Girder', idx(i,:), gname);
end

% --- B1A girders
b1 = famdata.B1.ATIndex(1:2:end,:);
sda0 = famdata.SDA0.ATIndex(1:2:end,:);
sdb0 = famdata.SDB0.ATIndex(1:2:end,:);
sdp0 = famdata.SDP0.ATIndex(1:2:end,:);
the_ring = setcellstruct(the_ring, 'Girder', sda0(1,1):b1(1,end), 'B1A_01');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(1,1):b1(2,end), 'B1A_02');
the_ring = setcellstruct(the_ring, 'Girder', sdp0(1,1):b1(3,end), 'B1A_03');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(2,1):b1(4,end), 'B1A_04');
the_ring = setcellstruct(the_ring, 'Girder', sda0(2,1):b1(5,end), 'B1A_05');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(3,1):b1(6,end), 'B1A_06');
the_ring = setcellstruct(the_ring, 'Girder', sdp0(2,1):b1(7,end), 'B1A_07');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(4,1):b1(8,end), 'B1A_08');
the_ring = setcellstruct(the_ring, 'Girder', sda0(3,1):b1(9,end), 'B1A_09');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(5,1):b1(10,end), 'B1A_10');
the_ring = setcellstruct(the_ring, 'Girder', sdp0(3,1):b1(11,end), 'B1A_11');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(6,1):b1(12,end), 'B1A_12');
the_ring = setcellstruct(the_ring, 'Girder', sda0(4,1):b1(13,end), 'B1A_13');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(7,1):b1(14,end), 'B1A_14');
the_ring = setcellstruct(the_ring, 'Girder', sdp0(4,1):b1(15,end), 'B1A_15');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(8,1):b1(16,end), 'B1A_16');
the_ring = setcellstruct(the_ring, 'Girder', sda0(5,1):b1(17,end), 'B1A_17');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(9,1):b1(18,end), 'B1A_18');
the_ring = setcellstruct(the_ring, 'Girder', sdp0(5,1):b1(19,end), 'B1A_19');
the_ring = setcellstruct(the_ring, 'Girder', sdb0(10,1):b1(20,end), 'B1A_20');

% --- B1B girders
b1 = famdata.B1.ATIndex(2:2:end,:);
sdb0 = famdata.SDB0.ATIndex(1:2:end,:);
sdp0 = famdata.SDP0.ATIndex(1:2:end,:);
sda0 = famdata.SDA0.ATIndex(2:2:end,:);
the_ring = setcellstruct(the_ring, 'Girder', b1(1,1):sdb0(1,end), 'B1B_01');
the_ring = setcellstruct(the_ring, 'Girder', b1(2,1):sdp0(1,end), 'B1B_02');
the_ring = setcellstruct(the_ring, 'Girder', b1(3,1):sdb0(2,end), 'B1B_03');
the_ring = setcellstruct(the_ring, 'Girder', b1(4,1):sda0(1,end), 'B1B_04');
the_ring = setcellstruct(the_ring, 'Girder', b1(5,1):sdb0(3,end), 'B1B_05');
the_ring = setcellstruct(the_ring, 'Girder', b1(6,1):sdp0(2,end), 'B1B_06');
the_ring = setcellstruct(the_ring, 'Girder', b1(7,1):sdb0(4,end), 'B1B_07');
the_ring = setcellstruct(the_ring, 'Girder', b1(8,1):sda0(2,end), 'B1B_08');
the_ring = setcellstruct(the_ring, 'Girder', b1(9,1):sdb0(5,end), 'B1B_09');
the_ring = setcellstruct(the_ring, 'Girder', b1(10,1):sdp0(3,end), 'B1B_10');
the_ring = setcellstruct(the_ring, 'Girder', b1(11,1):sdb0(6,end), 'B1B_11');
the_ring = setcellstruct(the_ring, 'Girder', b1(12,1):sda0(3,end), 'B1B_12');
the_ring = setcellstruct(the_ring, 'Girder', b1(13,1):sdb0(7,end), 'B1B_13');
the_ring = setcellstruct(the_ring, 'Girder', b1(14,1):sdp0(4,end), 'B1B_14');
the_ring = setcellstruct(the_ring, 'Girder', b1(15,1):sdb0(8,end), 'B1B_15');
the_ring = setcellstruct(the_ring, 'Girder', b1(16,1):sda0(4,end), 'B1B_16');
the_ring = setcellstruct(the_ring, 'Girder', b1(17,1):sdb0(9,end), 'B1B_17');
the_ring = setcellstruct(the_ring, 'Girder', b1(18,1):sdp0(5,end), 'B1B_18');
the_ring = setcellstruct(the_ring, 'Girder', b1(19,1):sdb0(10,end), 'B1B_19');
the_ring = setcellstruct(the_ring, 'Girder', b1(20,1):sda0(5,end), 'B1B_20');
