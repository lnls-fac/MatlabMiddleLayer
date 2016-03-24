% run_001384.new : result of moga optimization with all ids predicted for
%                  phase2 included in tracking.
%% QUADRUPOLES
% ===============

% original results from si.v14he:
% qfa_strength     =  3.579175;
% qda_strength     = -1.556543;
% qdb2_strength    = -3.211635;
% qfb_strength     =  4.097059;
% qdb1_strength    = -2.043692;

% After tune correction to compensate difference in dipole modeling:
qfa_strength     =  3.68777352075;
qda_strength     = -1.647860556115;
qdb2_strength    = -3.223163045382;
qfb_strength     =  4.133329238449;
qdb1_strength    = -2.093984571361;

qf1_strength     =  2.89559484203;
qf2_strength     =  4.278992094401;
qf3_strength     =  3.312369130091;
qf4_strength     =  3.884439362109;


%% Sextupoles
% ===============
factor = 0.147 / 0.150;

sda_strength     =  -81.6016 * factor;
sfa_strength     =   55.4999 * factor;
sdb_strength     =  -60.9457 * factor;
sfb_strength     =   75.1683 * factor;
sd1j_strength    = -171.9029 * factor;
sf1j_strength    =  195.8578 * factor;
sd2j_strength    =  -93.9185 * factor;
sd3j_strength    = -126.3542 * factor;
sf2j_strength    =  157.8841 * factor;
sd1k_strength    = -132.5925 * factor;
sf1k_strength    =  233.0591 * factor;
sd2k_strength    = -129.2326 * factor;
sd3k_strength    = -186.6984 * factor;
sf2k_strength    =  217.7521 * factor;