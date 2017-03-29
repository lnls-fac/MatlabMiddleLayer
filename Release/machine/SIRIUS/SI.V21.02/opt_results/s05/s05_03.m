%% Version SI.V21-S05.03 
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
QFA_strength  = +3.557799733269;
QFB_strength  = +4.057287204045;
QFP_strength  = +4.057287204045;
QDA_strength  = -1.619644245089;
QDB1_strength = -2.062972760584;
QDB2_strength = -3.124763230447;
QDP1_strength = -2.062972760584;
QDP2_strength = -3.124763230447;
Q1_strength   = +2.814083386204;
Q2_strength   = +4.342691283291;
Q3_strength   = +3.236518712541;
Q4_strength   = +3.930660288075;

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
