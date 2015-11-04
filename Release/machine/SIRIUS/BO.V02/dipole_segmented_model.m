function [bd, b_length_segmented, b_model] = dipole_segmented_model(bend_pass_method)

% dipole model 2015-10-27
% =======================
% this model is based on the same approved model6 dipole
% new python script was used to derived integrated multipoles around
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% *** interpolation of fields is now cubic ***
% *** dipole angles were normalized to better close 360 degrees ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
b_model = [ ...
%len[m]   angle[rad]               PolynomB(n=0)            PolynomB(n=1)            PolynomB(n=2)            PolynomB(n=3)            PolynomB(n=4)            PolynomB(n=5)            PolynomB(n=6)  
0.19600,  +1.1571254998824179e+00, +0.0000000000000000e+00, -2.2725645996131713e-01, -1.9824292412154298e+00, -6.3577298335477055e+00, -3.0906670288681238e+02, -2.0502879040531414e+04, -7.4854738548974553e+05;... 
0.19200,  +1.1428186629380708e+00, +0.0000000000000000e+00, -2.1199407350431240e-01, -1.9264602244518325e+00, -3.5354105878167066e+00, -1.1827660627985085e+02, -7.1405868044921253e+03, -4.7638136769773805e+05;... 
0.18200,  +1.0965765199118298e+00, +0.0000000000000000e+00, -1.8593058981329488e-01, -1.9012892575503810e+00, +3.3146675067946330e-01, -1.7365269781117280e+02, +3.0824212751753753e+03, -1.1412425972406262e+05;... 
0.01000,  +5.1507589907362414e-02, +0.0000000000000000e+00, -2.6073321352382689e-01, -1.7522060670536854e+00, +1.5672614426170275e+01, -3.4530068595098965e+02, +6.6473172582071711e+03, -6.0092884950365173e+05;... 
0.01000,  +3.7156720094290829e-02, +0.0000000000000000e+00, -1.8343680017122291e-01, -1.1573505205500421e+00, +2.2284419537975065e+01, -7.7442945562478167e+02, +1.3965649782587237e+04, -7.4129957934230671e+05;... 
0.01300,  +3.2970967989940335e-02, +0.0000000000000000e+00, -6.6853789446829168e-02, -1.6924712178129568e+00, +2.6662130118072952e+01, -9.3712047518698250e+02, +1.2104203339502001e+04, -1.7907910559905047e+05;... 
0.01700,  +2.9196819243476602e-02, +0.0000000000000000e+00, -9.8973469833417843e-03, -2.0216551834319354e+00, +2.0964379508730495e+01, -5.7196753581755115e+02, +1.7203764291740931e+03, +6.1754872115574202e+04;... 
0.02000,  +2.2401936476517000e-02, +0.0000000000000000e+00, +9.9825166323110892e-03, -1.8010801333012409e+00, +1.0050283345755533e+01, -1.8290354814660407e+02, -2.0895796189473654e+03, +6.3199821197421115e+04;...
0.03000,  +1.8309794091672198e-02, +0.0000000000000000e+00, +1.1869525013373863e-02, -1.1899611827296144e+00, +2.6594502324329357e+00, -1.3977534590977038e+01, -9.5348288392813993e+02, +1.5461820760627408e+04;... 
0.00500,  +1.1935489464422026e-02, -9.9691022253933781e-05, +5.4550851042850124e-02, -4.4683152517904503e+00, +3.5661984588676277e-01, +1.7969583278960039e+02, -2.0934072258968959e+03, +8.1582971615794566e+04;... 
];

% dipole model 2015-09-16
% =======================
% this model is based on the same approved model6 dipole
% new python script was used to derived integrated multipoles around
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% *** intertpolation of fields is now cubic ***
% *** dipole angles were normalized to better close 360 degrees ***
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
% b_model = [ ...
% %len[m]   angle[rad]   PolynomB(n=0)  PolynomB(n=1)  PolynomB(n=2)  PolynomB(n=3)  PolynomB(n=4)  PolynomB(n=5)  PolynomB(n=6)  
% 0.1960,  d2r* 1.1572,  +0.000000e+00,  -2.272565e-01,  -1.982429e+00,  -6.357730e+00,  -3.090667e+02,  -2.050288e+04,  -7.485474e+05;...   
% 0.1920,  d2r* 1.1428,  +0.000000e+00,  -2.119941e-01,  -1.926460e+00,  -3.535411e+00,  -1.182766e+02,  -7.140587e+03,  -4.763814e+05;...   
% 0.1580,  d2r* 0.9526,  +0.000000e+00,  -1.859630e-01,  -1.881590e+00,  -1.730076e-01,  -1.650540e+02,  +2.652761e+03,  -8.366171e+04;...   
% 0.0340,  d2r* 0.1955,  +0.000000e+00,  -2.077807e-01,  -1.948986e+00,  +7.187891e+00,  -2.640959e+02,  +6.127578e+03,  -3.988633e+05;...   
% 0.0300,  d2r* 0.0836,  +0.000000e+00,  -9.481689e-02,  -1.587599e+00,  +2.464462e+01,  -8.268328e+02,  +1.074123e+04,  -3.337856e+05;...   
% 0.1580,  d2r* 0.0675,  +0.000000e+00,  +5.004115e-03,  -7.199178e-01,  +2.971617e+00,  -5.090294e+01,  -4.863955e+02,  +2.188990e+04;...   
% 0.0010,  d2r* 0.0008,  -4.984551e-04,  +1.062454e-02,  -6.308172e-01,  -4.353379e-01,  +1.842258e+01,  +8.052845e+00,  -4.619714e+02;... 
% ];


% dipole model 2015-09-10
% =======================
% this model is based on the same approved model6 dipole
% new python script was used to derived integrated multipoles around
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% *** intertpolation of fields is now cubic ***
%--- model polynom_b (rz > 0). units: [mm] for length, [rad] for angle and [m],[T] for polynom_b ---
% b_model = [ ...
% %len[m]   angle[rad]   PolynomB(n=0)  PolynomB(n=1)  PolynomB(n=2)  PolynomB(n=3)  PolynomB(n=4)  PolynomB(n=5)  PolynomB(n=6)  
% 0.1960  +2.019565e-02  +0.000000e+00  -2.272565e-01  -1.982429e+00  -6.357730e+00  -3.090667e+02  -2.050288e+04  -7.485474e+05;...   
% 0.1920  +1.994595e-02  +0.000000e+00  -2.119941e-01  -1.926460e+00  -3.535411e+00  -1.182766e+02  -7.140587e+03  -4.763814e+05;...   
% 0.1580  +1.662544e-02  +0.000000e+00  -1.859630e-01  -1.881590e+00  -1.730076e-01  -1.650540e+02  +2.652761e+03  -8.366171e+04;...   
% 0.0340  +3.412404e-03  +0.000000e+00  -2.077807e-01  -1.948986e+00  +7.187891e+00  -2.640959e+02  +6.127578e+03  -3.988633e+05;...   
% 0.0300  +1.459139e-03  +0.000000e+00  -9.481689e-02  -1.587599e+00  +2.464462e+01  -8.268328e+02  +1.074123e+04  -3.337856e+05;...   
% 0.1580  +1.178940e-03  +0.000000e+00  +5.004115e-03  -7.199178e-01  +2.971617e+00  -5.090294e+01  -4.863955e+02  +2.188990e+04;...   
% 0.0010  +1.432861e-05  -4.984551e-04  +1.062454e-02  -6.308172e-01  -4.353379e-01  +1.842258e+01  +8.052845e+00  -4.619714e+02;... 
% ];


% dipole model 2014-12-01
% =======================
% this model is based on the same approved model6 dipole
% new python script was used to derived integrated multipoles around
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% falled back to 'solve' method for polynomial interpolation.

% b_model = [ ...
% % len  angle                PolynomB[1]          PolynomB[2] ...
% 0.1960 +2.019543e-02 +0.000000e+00 -2.272773e-01 -1.983148e+00 -5.887754e+00 -3.025835e+02 -2.317689e+04 -7.875649e+05;... 
% 0.1920 +1.994573e-02 +0.000000e+00 -2.120079e-01 -1.926535e+00 -3.207544e+00 -1.203679e+02 -8.935228e+03 -4.719305e+05;... 
% 0.1580 +1.662526e-02 +0.000000e+00 -1.859618e-01 -1.882988e+00 -2.007607e-01 -1.432845e+02 +2.788161e+03 -1.791886e+05;... 
% 0.0340 +3.411849e-03 +0.000000e+00 -2.067510e-01 -1.851285e+00 -9.283365e+00 -1.011630e+03 +5.867357e+04 +9.576563e+05;... 
% 0.0300 +1.459518e-03 +0.000000e+00 -9.546626e-02 -1.722479e+00 +3.516586e+01 +3.371373e+02 -2.222028e+04 -2.863012e+06;... 
% 0.1580 +1.179063e-03 +0.000000e+00 +4.997853e-03 -7.327753e-01 +3.067168e+00 +6.866808e+01 -7.770617e+02 -2.591275e+05;... 
% 0.0010 +1.403307e-05 +9.722121e-07 +9.781965e-03 -6.822178e-01 +2.200638e+00 +5.710292e+02 -4.725951e+03 -1.263824e+06;... 
% ];

% dipole model 2014-10-19
% =======================
% this model is based on the same approved model6 dipole
% new python script was used to derived integrated multipoles around
% trajectory centered in good-field region. init_rx is set to +9.045 mm
% model segmentation was preserved (14) but multipoles were rescaled
% from previous integrated values to new ones.
% b_model = [ ...
% % len                angle                PolynomB[1]          PolynomB[2] ...
% +1.9600000000000E-01 +2.0195440847176E-02 +0.0000000000000E+00 -2.2718737794240E-01 -1.9838101973556E+00 -6.7100381692044E+00 +4.9920710941460E-05 -1.3300435827537E-04 +2.4235784274106E-08;...
% +1.9200000000000E-01 +1.9945732400886E-02 +0.0000000000000E+00 -2.1192778004400E-01 -1.9172568031810E+00 -3.7354632993019E+00 -1.9634481701885E-05 -4.9798831271698E-05 +3.4371169036436E-09;...
% +1.5800000000000E-01 +1.6625265049598E-02 +0.0000000000000E+00 -1.8590486931855E-01 -1.8737337003164E+00 -1.6541302326730E-01 -1.9338306308259E-05 +1.2255709898644E-05 +4.1512320572352E-09;...
% +3.4000000000000E-02 +3.4121780697475E-03 +0.0000000000000E+00 -2.0790741807102E-01 -1.9108616811517E+00 +6.0211592722707E+00 -8.0389504785605E-04 +4.2587366778860E-04 -2.0493449755724E-07;...
% +3.0000000000000E-02 +1.4593537587502E-03 +0.0000000000000E+00 -9.5038400635701E-02 -1.6494710898138E+00 +2.5462042127288E+01 +9.5248097990464E-04 +3.3179449011173E-05 +3.3304203270259E-07;...
% +1.5800000000000E-01 +1.1796180861276E-03 +0.0000000000000E+00 +4.8538016476408E-03 -7.1806104227790E-01 +3.1726318161202E+00 -2.1836064393780E-05 -7.5534836079246E-06 -2.5720679947909E-09;...
% +1.0000000000000E-03 +1.4264859509966E-05 +4.1405772719342E-05 +3.0576641299928E-02 -8.2104840247350E+00 -1.3034706925023E+02 -4.3041809412239E-02 -1.1076703523835E-02 -1.0030203613377E-05;...
% ];

% % dipole model 2014-10-19
% % =======================
% % this model is based on the same approved model6 dipole
% % new python script was used to derived integrated multipoles around
% % trajectory centered in good-field region.
% % model segmentation was preserved (14) but multipoles were rescaled
% % from previous integrated values to new ones.
% b_model = [ ...
% % len               angle               PolynomB[1]         PolynomB[2] ...
% 1.9600000000000E-01	2.0195440847176E-02	0.0000000000000E+00	-2.2498523857624E-01	-1.9838101973556E+00	-3.8395034249638E+00	 4.9897118923000E-05	-7.6114588512000E-05	 2.4217805205700E-04; ...
% 1.9200000000000E-01	1.9945732400886E-02	0.0000000000000E+00	-2.0987355277378E-01	-1.9172568031810E+00	-2.1374430025332E+00	-1.9625202646000E-05	-2.8498446214000E-05	 3.4345671137000E-05; ...
% 1.5800000000000E-01	1.6625265049598E-02	0.0000000000000E+00	-1.8410288350933E-01	-1.8737337003164E+00	-9.4649814703477E-02	-1.9329167222000E-05	 7.0135920950000E-06	 4.1481525082000E-05; ...
% 3.4000000000000E-02	3.4121780697475E-03	0.0000000000000E+00	-2.0589216038374E-01	-1.9108616811517E+00	 3.4453249095120E+00	-8.0351513526300E-04	 2.4371531431000E-04	-2.0478246899820E-03; ...
% 3.0000000000000E-02	1.4593537587502E-03	0.0000000000000E+00	-9.4117188351673E-02	-1.6494710898138E+00	 1.4569454821132E+01	 9.5203084711600E-04	 1.8987649287000E-05	 3.3279496888010E-03; ...
% 1.5800000000000E-01	1.1796180861276E-03	0.0000000000000E+00	 4.8067534895050E-03	-7.1806104227791E-01	 1.8153891851240E+00	-2.1825744893000E-05	-4.3226425370000E-06	-2.5701599325000E-05; ...
% 1.0000000000000E-03	1.4264859509966E-05	4.1405772719342E-05	 3.0280260285713E-02	-8.2104840247351E+00	-7.4584973468129E+01	-4.3021468292479E-02	-6.3388804826660E-03	-1.0022762809510E-01; ...
% ];

% % dipole model
% % ============
% % this model is based on the same approved model6 dipole
% % from matlab-derived fieldmap analysis
% b_model = [ ...
% % len               angle                 PolynomB[1]          PolynomB[2] ...
% +1.9600000000000E-01 +2.0195440847176E-02 +0.0000000000000E+00 -2.2725730095568E-01 -1.9937933516712E+00 -6.4749558242816E+00 +2.1792245824426E+02 -2.0052690828560E+04 -7.4402792791901E+06; ...
% +1.9200000000000E-01 +1.9945732400886E-02 +0.0000000000000E+00 -2.1199300650646E-01 -1.9269050399702E+00 -3.6045934816304E+00 -8.5711810551822E+01 -7.5080289102069E+03 -1.0551797865958E+06; ...
% +1.5800000000000E-01 +1.6625265049598E-02 +0.0000000000000E+00 -1.8596208653178E-01 -1.8831629152189E+00 -1.5961787271676E-01 -8.4418894873476E+01 +1.8477587100809E+03 -1.2744100008992E+06; ...
% +3.4000000000000E-02 +3.4121780697475E-03 +0.0000000000000E+00 -2.0797140715917E-01 -1.9204777356836E+00 +5.8102114050328E+00 -3.5093006829292E+03 +6.4207768098161E+04 +6.2913990260072E+07; ...
% +3.0000000000000E-02 +1.4593537587502E-03 +0.0000000000000E+00 -9.5067651254331E-02 -1.6577717450130E+00 +2.4569994061559E+01 +4.1579335040946E+03 +5.0023716629309E+03 -1.0224244064030E+08; ...
% +1.5800000000000E-01 +1.1796180861276E-03 +0.0000000000000E+00 +4.8552955353741E-03 -7.2167455036586E-01 +3.0614804771706E+00 -9.5322537306261E+01 -1.1388173548021E+03 +7.8961357263592E+05; ...
% +1.0000000000000E-03 +1.4264859509966E-05 +4.1405772719342E-05 +3.0586052081966E-02 -8.2518017521740E+00 -1.2578043431903E+02 -1.8789349625640E+05 -1.6700032543536E+06 +3.0792284362095E+09; ...
% ];

d2r = pi/180.0;

b = [];
for i=1:size(b_model,1)
    b = [b rbend_sirius('b', b_model(i,1), d2r * b_model(i,2), 0, 0, 0, 0, 0, zeros(size(b_model(i,3:end))), b_model(i,3:end), bend_pass_method)];
    if (i == 6)
        b = [b marker('b_edge', 'IdentityPass')];
    end
end
pb = marker('pb', 'IdentityPass');
mb = marker('mb', 'IdentityPass');
bd = [pb, fliplr(b) , mb, b, pb];
b_length_segmented = 2*sum(b_model(:,1));