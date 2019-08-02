%% opt_2:

% qf_strength = 1.8821;
% qd_strength = 0.0;
% sf_strength = 6.331497;
% sd_strength = 0.0;

% 2014-12-05 Fernando
% Result firstRun-209 of moga optimization to improve DA
% tunex  = 19.20433
% tuney  =  7.31417
% chromx =  +0.5
% chromy =  +0.5
% qd_strength = 0.01121907309893941;
% qf_strength = 1.876071307737087;
% sf_strength = 12.34910246282437/2;
% sd_strength = 7.051860735882379/2;


% % 2014-10-29 ximenes
% % with new segmented b model
% % tunes corrected to [19.20475, 7.30744]
% % chroms set to [0.5,0.5]
% qf_strength = +1.882118628753756;
% qd_strength = -0.883587030955089e-3;
% sf_strength = 6.167352183794390; 
% sd_strength = 2.989839869932359; 

% % 2014-12-01 ximenes
% % final fieldmap analysis of model6
% % tunex  = 19.20433
% % tuney  =  7.31417
% % chromx =  +0.5
% % chromy =  +0.5
% qf_strength =  1.882125768941849;
% qd_strength = -0.002846148623370;
% sf_strength = 11.9534110297414080; 
% sd_strength =  7.217452258059838; 

% % 2015-09-03 ximenes
% % fieldmap analysis of sextupole new_model1 (100 mm physical length)
% % tunex  = 19.20433
% % tuney  =  7.31417
% % chromx =  +0.5
% % chromy =  +0.5
% qf_strength =  1.882125768941849;
% qd_strength = -0.002846148623370;
% sf_strength = 11.349989133773295;
% sd_strength = 7.206900815548799;


% 2015-09-03 ximenes
% fieldmap analysis of model1 QD (100 mm physical length)
% tunex  = 19.20433
% tuney  =  7.31417
% chromx =  +0.5
% chromy =  +0.5
% 
% qf_strength =  1.882125768941849;
% qd_strength = -0.002825241833800;
% sf_strength = 11.349989133773295;
% sd_strength = 7.206900815548799;

% % 2015-09-08 ximenes
% % changes eff. length of QF to match the one from fieldmap analysis.
% % corrected tunes and chormaticies
% qf_strength =  1.657897577214302;
% qd_strength = -0.010004424317613;
% sf_strength = 11.327922565223286;
% sd_strength =  7.330541690089150;

% % 2015-09-10 ximenes
% % updated dipole model multipoles. 
% % corrected tunes  = [19.204378646902239   7.314313778087979]
% % corrected chroms = [0.5 0.5] 
% qf_strength =  1.657881617545217;
% qd_strength = -0.009637589230525;
% sf_strength = 11.327508716063402;
% sd_strength =  7.064290473083006;

% % 2015-11-04 ximenes
% % after segmented model of dipole was corrected (last element was 5 mm long, instead of 50 mm)
% qf_strength =  1.654531766801048;
% qd_strength = -0.009834018323292;
% sf_strength = 11.327508716063402;
% sd_strength =  6.669827683440462;

% % 2015-11-05 ximenes
% % tunes fitted to [19.20433 7.31417]
% % chroms fitted to [0.5 0.5]
% qf_strength = 1.661204884438163;
% qd_strength = -0.009683797310216;
% sf_strength = 11.327047617231438;
% sd_strength = 6.700042815533210;

% % 2016-04-08 ximenes (overall checking of model)
% % tunes fitted to [19.20433 7.31417]
% % chroms fitted to [0.5 0.5]
% qf_strength = 1.661222805216001;
% qd_strength = -0.011484791886341;
% sf_strength = 11.327047617231438;
% sd_strength = 6.700042815533210;

% % 2016-11-23 ximenes (overall checking of model - dipole model09)
% % tunes fitted to [19.20433 7.31417] with "[THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'qf','qd'},'svd','add',10,1e-9)"
% % chroms fitted to [0.5 0.5] with "THERING = fitchrom2(THERING, [0.5, 0.5], 'sd', 'sf')"
% qf_strength = 1.661214083215930;
% qd_strength = -0.005159016503686;
% sf_strength = 11.327040434943536;
% sd_strength = 6.278086202577062;


% % 2016-11-29 ximenes (overall checking of model - quadrupole qf model 06)
% % tunes fitted to [19.20433 7.31417] with "[THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9)"
% % chroms fitted to [0.5 0.5] with "THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF')"
% % effective length changed from 227 mm to 228 mm.
% % added model data for injection energy (2016-12-06 - ximenes)
% 
% qf_strength_3gev = 1.654036901202666;
% qd_strength_3gev = -0.005420679200790;
% sf_strength_3gev = 11.326236886929777;
% sd_strength_3gev = 6.282585994172798;
% 
% qf_strength_150mev = 1.653947030508554;
% qd_strength_150mev = 0.011087086666236;  % this is correct! the sign has changed!
% sf_strength_150mev = 11.331918086866839;
% sd_strength_150mev = 5.007982664695219;
% 
% qf_strength = qf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qf_strength_3gev - qf_strength_150mev);
% qd_strength = qd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qd_strength_3gev - qd_strength_150mev);
% sf_strength = sf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sf_strength_3gev - sf_strength_150mev);
% sd_strength = sd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sd_strength_3gev - sd_strength_150mev);


% % 2017-01-11 ximenes (overall checking of model - quadrupole qd model 02)
% % tunes fitted to [19.20433 7.31417] with "[THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9)"
% % chroms fitted to [0.5 0.5] with "THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF')"
% % effective length changed from 227 mm to 228 mm.
% % added model data for injection energy (2016-12-06 - ximenes)
% 
% qf_strength_3gev = 1.654036900448982;
% qd_strength_3gev = -0.005474886350700;
% qs_strength_3gev = 0.0;
% sf_strength_3gev = 11.326236792215228;
% sd_strength_3gev = 6.282586036135388;
% 
% qf_strength_150mev = 1.653947031926041;
% qd_strength_150mev = 0.011197961538728;  % this is correct! the sign has changed!
% qs_strength_150mev = 0.0;
% sf_strength_150mev = 11.331918124055948;
% sd_strength_150mev = 5.007982970980575;
% 
% qf_strength = qf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qf_strength_3gev - qf_strength_150mev);
% qd_strength = qd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qd_strength_3gev - qd_strength_150mev);
% qs_strength = qs_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qs_strength_3gev - qs_strength_150mev);
% sf_strength = sf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sf_strength_3gev - sf_strength_150mev);
% sd_strength = sd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sd_strength_3gev - sd_strength_150mev);


% 2018-08-16 ximenes 
% updated dipolo model-09 with fmap analysis x0 = 9.1013 mm (x-ref = 28.255 mm)
%
% Tune and Chrom fitting:
%
% global THERING
% THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF');
% THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF');
% THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF');
% THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF');
% THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF');
% THERING = fitchrom2(THERING, [0.5, 0.5], 'SD', 'SF');
% [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9);
% [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9);
% [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9);
% [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9);
% [THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'QF','QD'},'svd','add',10,1e-9);
% idx = findcells(THERING, 'FamName', 'QF'); disp(THERING{idx(1)}.PolynomB(2));
% idx = findcells(THERING, 'FamName', 'QD'); disp(THERING{idx(1)}.PolynomB(2));
% idx = findcells(THERING, 'FamName', 'SF'); disp(THERING{idx(1)}.PolynomB(3));
% idx = findcells(THERING, 'FamName', 'SD'); disp(THERING{idx(1)}.PolynomB(3));

% % NOTE: if magnet models based on measurements are used, these strength
% % values will be different. see 'sirius_bo_models_from_measurements.m'
% 
% qf_strength_3gev = 1.653948476924229;
% qd_strength_3gev = 0.004348693222430; % this is correct! the sign has changed!
% qs_strength_3gev = 0.0;
% sf_strength_3gev = 11.331409123896279;
% sd_strength_3gev = 6.254896348595790;
% 
% qf_strength_150mev = 1.653944034925625;
% qd_strength_150mev = 0.011836698177126; % this is correct! the sign has changed!
% qs_strength_150mev = 0.0;
% sf_strength_150mev = 11.332065904774284;
% sd_strength_150mev = 4.973798424490276;
% 
% qf_strength = qf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qf_strength_3gev - qf_strength_150mev);
% qd_strength = qd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qd_strength_3gev - qd_strength_150mev);
% qs_strength = qs_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qs_strength_3gev - qs_strength_150mev);
% sf_strength = sf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sf_strength_3gev - sf_strength_150mev);
% sd_strength = sd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sd_strength_3gev - sd_strength_150mev);

% 2019-08-01 Murilo

qf_strength_3gev = 1.65458216649285;
qd_strength_3gev = -0.11276026973021;
qs_strength_3gev = 0.0;
sf_strength_3gev = +11.30745884748409;
sd_strength_3gev = +10.52221952522381;

qf_strength_150mev = 1.65380213538720;
qd_strength_150mev = -0.00097311784326;
qs_strength_150mev = 0.0;
sf_strength_150mev = 11.32009586848142;
sd_strength_150mev = 10.37672159358045;

qf_strength = qf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qf_strength_3gev - qf_strength_150mev);
qd_strength = qd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qd_strength_3gev - qd_strength_150mev);
qs_strength = qs_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qs_strength_3gev - qs_strength_150mev);
sf_strength = sf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sf_strength_3gev - sf_strength_150mev);
sd_strength = sd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sd_strength_3gev - sd_strength_150mev);

