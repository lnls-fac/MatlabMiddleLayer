%% Version SI.V21-S05.02 
%  =====================
%% 2017-03-28 - Liu
% Optics assymetries introduced by new B1 and B2 models in previous version (SI.V21-S05.01) were corrected using MAD. In addition, 
% the dispersion function has been corrected to zero at ID straights and first order optics in sectors B and P are now identical.
 

%% Version SI.V21-S05.01 
%  =====================
% same optics as optimization run2_000491.m of tux49.tuy14.sext14.defConf
%% 2017-02-02 New B1 and B2 models - Ximenes
% B1 model-08: fieldmap '2017-02-01_B1_Model08_Sim_X=-32_32mm_Z=-1000_1000mm_Imc=451.8A.txt', init_rx is set to  4.860 mm at s=0   
% B2 model-07: fieldmap '2017-02-01_B2_Model07_Sim_X=-63_27mm_Z=-1000_1000mm_Imc=451.8A.txt', init_rx is set to  5.444 mm at s=0
% local script 'sirius_si_correct_tune_chrom' used.


% QUADRUPOLES
% ===========
QFA_strength  = +3.608739606508;
QFB_strength  = +4.10005064998;
QFP_strength  = +4.10005064998;
QDA_strength  = -1.631837596683;
QDB1_strength = -2.064059916372;
QDB2_strength = -3.289153348774;
QDP1_strength = -2.064059916372;
QDP2_strength = -3.289153348774;
Q1_strength   = +2.905491953297;
Q2_strength   = +4.267969717459;
Q3_strength   = +3.29693631929;
Q4_strength   = +3.849644587816;

% SEXTUPOLES
% ==========
SDA0_strength = -80.833699999999993;
SDB0_strength = -64.942200000000000;
SDP0_strength = -64.942200000000000;
SFA0_strength = +52.569600000000001;
SFB0_strength = +73.740099999999998;
SFP0_strength = +73.740099999999998;
SDA1_strength = -164.290379560089548;
SDB1_strength = -144.560891591434284;
SDP1_strength = -143.529201102231468;
SDA2_strength = -89.445119869211069;
SDB2_strength = -123.497057498919773;
SDP2_strength = -122.928948154723642;
SDA3_strength = -140.526016852275035;
SDB3_strength = -175.157535493184838;
SDP3_strength = -174.791144298971204;
SFA1_strength = +193.914825089860784;
SFB1_strength = +232.069959601419356;
SFP1_strength = +231.285894569649344;
SFA2_strength = +152.134269401114096;
SFB2_strength = +200.507468026663645;
SFP2_strength = +199.875886055435359;

% %% 2017-01-23 Ximenes
% 
% % B1 model 2017-01-19 (3GeV)
% % ===========================
% % dipole model-07
% % filename: 2017-01-19_B1_Model07_Sim_X=-32_32mm_Z=-1000_1000mm_Imc=452.4A.txt
% % trajectory centered in good-field region. 
% % init_rx is set to  4.86 mm at s=0
% 
% % B2 model 2017-01-19 (3GeV)
% % ===========================
% % dipole model-06
% % filename: 2017-01-19_B2_Model06_Sim_X=-63_27mm_Z=-1000_1000mm_Imc=452.4A.txt
% % trajectory centered in good-field region. 
% % init_rx is set to  5.444 mm at s=0
% 
% % [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[49.110128921637788, 14.165190071737401], {'QFA','QDA','QFB','QDB1','QDB2','QDP1','QFP','QDP2'},'svd', 'prop',10,1e-9);
% % THERING = lnls_correct_chrom(THERING, [2.4 2.4], {'SDA1','SDA2','SDA3','SFA1','SFA2','SDB1','SDB2','SDB3','SFB1','SFB2','SDP1','SDP2','SDP3','SFP1','SFP2'})
% 
% 
% %  QUADRUPOLOS
% %  ===========
% QFA_strength  = 3.550905012535578;
% QDA_strength  =-1.551004069827368;
% QDB2_strength =-3.297576400422193;
% QFB_strength  = 4.108614513009897;
% QDB1_strength =-2.071005160655107;
% QDP2_strength =-3.297864922796637;
% QFP_strength  = 4.099670512865042;
% QDP1_strength =-2.054950574942503;
% Q1_strength	  = 2.901583657954850;
% Q2_strength	  = 4.268615906892407;
% Q3_strength	  = 3.290111749178743;
% Q4_strength	  = 3.870354374149453;
% 
% %  SEXTUPOLOS
% %  ===========
% SDA0_strength  = -80.8337;
% SDB0_strength  = -64.9422;
% SDP0_strength  = -64.9422;
% SFA0_strength  =  52.5696;
% SFB0_strength  =  73.7401;
% SFP0_strength  =  73.7401;
% SDA1_strength  = -1.645116391704012e+02;
% SDB1_strength  = -1.450672333001238e+02;
% SDP1_strength  = -1.437344958397774e+02;
% SDA2_strength  = -8.964697869827918e+01;
% SDB2_strength  = -1.239469161025598e+02;
% SDP2_strength  = -1.231003495490488e+02;
% SDA3_strength  = -1.406366886318429e+02;
% SDB3_strength  = -1.754225327236701e+02;
% SDP3_strength  = -1.749022344674353e+02;
% SFA1_strength  =  1.938828417047730e+02;
% SFB1_strength  =  2.319946431324937e+02;
% SFP1_strength  =  2.312922104671202e+02;
% SFA2_strength  =  1.521739068451551e+02;
% SFB2_strength  =  2.005615175766435e+02;
% SFP2_strength  =  1.999109278043157e+02;



% %% 2017-01-11 Ximenes
% 
% % B1 model 2017-01-11 (3GeV)
% % ===========================
% % dipole model-06
% % filename: 2017-01-10_B1_Model06_Sim_X=-32_32mm_Z=-1000_1000mm_Imc=439A.txt
% % trajectory centered in good-field region. 
% % init_rx is set to 2.475 mm at s=0
% 
% % [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[49.110128921637788, 14.165190071737401], {'QFA','QDA','QFB','QDB1','QDB2','QDP1','QFP','QDP2'},'svd', 'prop',10,1e-9);
% % THERING = lnls_correct_chrom(THERING, [2.4 2.4], {'SDA1','SDA2','SDA3','SFA1','SFA2','SDB1','SDB2','SDB3','SFB1','SFB2','SDP1','SDP2','SDP3','SFP1','SFP2'})
% 
% %  QUADRUPOLOS
% %  ===========
% QFA_strength  = 3.555343441364104;
% QDA_strength  =-1.541251620669793;
% QDB2_strength =-3.277423766308402;
% QFB_strength  = 4.093766713035360;
% QDB1_strength =-2.037732099831163;
% QDP2_strength =-3.277650389934651;
% QFP_strength  = 4.093181415126798;
% QDP1_strength =-2.037960139573961;
% Q1_strength	  = 2.901583657954850;
% Q2_strength	  = 4.268615906892407;
% Q3_strength	  = 3.290111749178743;
% Q4_strength	  = 3.870354374149453;

% %  SEXTUPOLOS
% %  ===========
% 
% SDA0_strength  = -80.8337;
% SDB0_strength  = -64.9422;
% SDP0_strength  = -64.9422;
% SFA0_strength  =  52.5696;
% SFB0_strength  =  73.7401;
% SFP0_strength  =  73.7401;
% 
% SDA1_strength  = -1.636074365682566e+02;
% SDB1_strength  = -1.431104162660654e+02;
% SDP1_strength  = -1.429400131511150e+02;
% SDA2_strength  = -8.911634209216744e+01;
% SDB2_strength  = -1.227203515659564e+02;
% SDP2_strength  = -1.225794407880717e+02;
% SDA3_strength  = -1.402378549642176e+02;
% SDB3_strength  = -1.744869967706330e+02;
% SDP3_strength  = -1.744037211371839e+02;
% SFA1_strength  = 1.932135014635584e+02;
% SFB1_strength  = 2.304762834588780e+02;
% SFP1_strength  = 2.304198399064758e+02;
% SFA2_strength  = 1.515740908888866e+02;
% SFB2_strength  = 1.994245652256068e+02;
% SFP2_strength  = 1.993795676929658e+02;
