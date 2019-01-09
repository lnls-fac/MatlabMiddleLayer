%% Version SI.V24.02-S05.01 
%  ========================
%
% goal_tunes = [49.096188917357331, 14.151971558423915];
% goal_chrom = [2.549478494984214, 2.527086095938103];
% tw1 = calctwiss(the_ring);
% all(abs([tw1.mux(end), tw1.muy(end)]/2/pi - goal_tunes) <= 0.0001) && all(abs([tw1.chromx, tw1.chromy] - goal_chrom) <= 0.01)


% original SI.V24.01 strengths
    
% QUADRUPOLES
% ===========
QDA_strength  = -1.622404771059;
QFA_strength  = +3.574849741767;
QDB1_strength = -2.008744908636;
QDB2_strength = -3.403732690455;
QFB_strength  = +4.112048429299;
QDP1_strength = -2.008744908636;
QDP2_strength = -3.403732690455;
QFP_strength  = +4.112048429299;

Q1_strength   = +2.82467581344;
Q2_strength   = +4.33553230561;
Q3_strength   = +3.226244592296;
Q4_strength   = +3.941477483915;

% SEXTUPOLES
% ==========
SDA0_strength = -80.8337;
SDB0_strength = -64.9422;
SDP0_strength = -64.9422;
SFA0_strength = +52.5696;
SFB0_strength = +73.7401;
SFP0_strength = +73.7401;

SDA1_strength = -162.86481428205505;
SDA2_strength =  -88.80496224467488;
SDA3_strength = -139.88675100750922;
SFA1_strength = +191.66622097823435;
SFA2_strength = +150.64804173247722;
SDB1_strength = -141.39698214193538;
SDB2_strength = -122.12536071422329;
SDB3_strength = -173.68733738100065;
SFB1_strength = +227.51676106242556;
SFB2_strength = +197.58343817406129;
SDP1_strength = -142.18842705218736;
SDP2_strength = -122.20521709826868;
SDP3_strength = -174.10041688365578;
SFP1_strength = +229.06017410501138;
SFP2_strength = +198.36906930890160;


% % strengths for -0.46% quad in B1 and B2 (comparison with wiki spec)
% 
% % QUADRUPOLES
% % ===========
% QDA_strength  = -1.66566531266965;
% QFA_strength  = +3.57480572012915;
% QDB1_strength = -2.09365374660819;
% QDB2_strength = -3.42322306690850;
% QFB_strength  = +4.12805567664421;
% QDP1_strength = -2.05207931440737;
% QDP2_strength = -3.41376860176673;
% QFP_strength  = +4.11947532977193;
% 
% Q1_strength   = +2.82467581344;
% Q2_strength   = +4.33553230561;
% Q3_strength   = +3.226244592296;
% Q4_strength   = +3.941477483915;
% 
% % SEXTUPOLES
% % ==========
% SDA0_strength = -80.8337;
% SDB0_strength = -64.9422;
% SDP0_strength = -64.9422;
% SFA0_strength = +52.5696;
% SFB0_strength = +73.7401;
% SFP0_strength = +73.7401;
% 
% SDA1_strength = -162.45103724721599;
% SDA2_strength = -87.40851605641727;
% SDA3_strength = -139.54733338837121;
% SFA1_strength = +193.88784278942353;
% SFA2_strength = +152.07185553704150;
% SDB1_strength = -145.81165533311764;
% SDB2_strength = -124.09809678214370;
% SDB3_strength = -174.92281424396970;
% SFB1_strength = +228.50763696793553;
% SFB2_strength = +199.68827915115133;
% SDP1_strength = -141.76970196626380;
% SDP2_strength = -120.79544801537089;
% SDP3_strength = -173.72254299617654;
% SFP1_strength = +232.32518927594458;
% SFP2_strength = +199.28899961446936;


% strengths for -0.32% quad in B2 (comparison with AT nominal model)


% % QUADRUPOLES
% % ===========
% QDA_strength  = -1.67362115423803;
% QFA_strength  = +3.56455859751440;
% QDB1_strength = -2.04355786778865;
% QDB2_strength = -3.41196239608702;
% QFB_strength  = +4.13552649154465;
% QDP1_strength = -2.06674825526365;
% QDP2_strength = -3.42113581799991;
% QFP_strength  = +4.09671667198963;
%    
% Q1_strength   = +2.82467581344;
% Q2_strength   = +4.33553230561;
% Q3_strength   = +3.226244592296;
% Q4_strength   = +3.941477483915;
% 
% % SEXTUPOLES
% % ==========
% SDA0_strength = -80.8337;
% SDB0_strength = -64.9422;
% SDP0_strength = -64.9422;
% SFA0_strength = +52.5696;
% SFB0_strength = +73.7401;
% SFP0_strength = +73.7401;
% 
% SDA1_strength = -163.97622673650585;
% SDA2_strength = -88.04944732472927;
% SDA3_strength = -139.60400701828203;
% SFA1_strength = +192.39376294716115;
% SFA2_strength = +151.94352006199705;
% SDB1_strength = -144.93040285427494;
% SDB2_strength = -122.85201405144309;
% SDB3_strength = -174.26600938181988;
% SFB1_strength = +231.25808599493746;
% SFB2_strength = +201.08132621915547;
% SDP1_strength = -143.75542892332223;
% SDP2_strength = -123.87828184436435;
% SDP3_strength = -174.97067573971580;
% SFP1_strength = +230.46714932680285;
% SFP2_strength = +198.47942939809661;
