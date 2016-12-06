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


% 2016-11-29 ximenes (overall checking of model - quadrupole qf model 06)
% tunes fitted to [19.20433 7.31417] with "[THERING, conv, t2, t1] = lnls_correct_tunes(THERING,[19.20433 7.31417],{'qf','qd'},'svd','add',10,1e-9)"
% chroms fitted to [0.5 0.5] with "THERING = fitchrom2(THERING, [0.5, 0.5], 'sd', 'sf')"
% effective length changed from 227 mm to 228 mm.
% added model data for injection energy (2016-12-06 - ximenes)

qf_strength_3gev = 1.653861341941806;
qd_strength_3gev = -0.004822541503476;
sf_strength_3gev = 11.327309449559875;
sd_strength_3gev = 6.281530681569274;

qf_strength_150mev = 1.653771340966689;
qd_strength_150mev = 0.011692191830813;  % this is correct! the sign has changed!
sf_strength_150mev = 11.332998999039631;
sd_strength_150mev = 5.006605035910315;

qf_strength = qf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qf_strength_3gev - qf_strength_150mev);
qd_strength = qd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (qd_strength_3gev - qd_strength_150mev);
sf_strength = sf_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sf_strength_3gev - sf_strength_150mev);
sd_strength = sd_strength_150mev + ((energy-150e6)/(3e9-150e6)) * (sd_strength_3gev - sd_strength_150mev);





