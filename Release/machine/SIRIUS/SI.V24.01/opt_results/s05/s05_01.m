%% Version SI.V24.01-S05.01 
%  ========================
%
% goal_tunes = [49.096188917357331, 14.151971558423915];
% goal_chrom = [2.549478494984214, 2.527086095938103];
% tw1 = calctwiss(the_ring);
% all(abs([tw1.mux(end), tw1.muy(end)]/2/pi - goal_tunes) <= 0.0001) && all(abs([tw1.chromx, tw1.chromy] - goal_chrom) <= 0.01)

    
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