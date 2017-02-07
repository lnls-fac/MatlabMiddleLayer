function testa_modelo_calibrado

global THERING;

TR0 = getappdata(0, 'TR0');
TRC = getappdata(0, 'TRC');

hcm = findcells(TR0, 'FamName', 'HCM');
vcm = findcells(TR0, 'FamName', 'VCM');
bpm = findcells(TR0, 'FamName', 'BPM');
rad15g = findcells(TR0, 'FamName', 'RAD15G');
dfx = rad15g(2);

hcm_idx = 1;
hcm_devlist = elem2dev('HCM', hcm_idx);


TR0{hcm(hcm_idx)}.KickAngle(1) = 0.1e-3/2;
cod0 = findorbit4(TR0, 0, 1:length(TR0));
cod0 = 1e3 * cod0(1,bpm);
cod0(6) = [];

TRC{hcm(1)}.KickAngle(1) = 0.1e-3/2;
codc = findorbit4(TRC, 0, 1:length(TRC));
codc = 1e3 * codc(1,bpm);
codc(6) = [];

switch2online;
init = [getx gety];
steppv('HCM', 0.05*1e-3, [1 corr], 'Physics');
pause(1);
final = [getx gety];
codm  = final - init;
steppv('HCM', -0.05*1e-3, [1 corr], 'Physics');

figure; hold all;
plot(codm(:,1));
plot(codc);
plot(cod0);

figure; hold all;
plot(codm(:,1)./codc');
plot(codm(:,1)./cod0');

