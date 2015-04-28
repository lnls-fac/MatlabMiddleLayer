function [orbx, orby] = lnls1_orbit_signature_from_correctors()


switch2sim;

% HORIZONTAL ORBIT
steppv('ACH01B', 0.1, 'Hardware'); % UNITS: [AMPERE]
steppv('ACH02',  0.1, 'Hardware');
steppv('ACH03A', 0.1, 'Hardware');
steppv('ACH03B', 0.1, 'Hardware');
steppv('ACH04',  0.1, 'Hardware');
steppv('ACH05A', 0.1, 'Hardware');
steppv('ACH05B', 0.1, 'Hardware');
steppv('ACH06',  0.1, 'Hardware');
steppv('ACH07A', 0.1, 'Hardware');
steppv('ACH07B', 0.1, 'Hardware');
steppv('ACH08',  0.1, 'Hardware');
steppv('ACH09A', 0.1, 'Hardware');
steppv('ACH09B', 0.1, 'Hardware');
steppv('ACH10',  0.1, 'Hardware');
steppv('ACH11A', 0.1, 'Hardware');
steppv('ACH11B', 0.1, 'Hardware');
steppv('ACH12',  0.1, 'Hardware');
steppv('ACH01A', 0.1, 'Hardware');

% VERTICAL ORBIT
steppv('ACV01B', 0.1, 'Hardware');
steppv('ALV02A', 0.1, 'Hardware');
steppv('ALV02B', 0.1, 'Hardware');
steppv('ACV03A', 0.1, 'Hardware');
steppv('ACV03B', 0.1, 'Hardware');
steppv('ALV04A', 0.1, 'Hardware');
steppv('ALV04B', 0.1, 'Hardware');
steppv('ACV05A', 0.1, 'Hardware');
steppv('ACV05B', 0.1, 'Hardware');
steppv('ALV06A', 0.1, 'Hardware');
steppv('ALV06B', 0.1, 'Hardware');
steppv('ACV07A', 0.1, 'Hardware');
steppv('ACV07B', 0.1, 'Hardware');
steppv('ALV08A', 0.1, 'Hardware');
steppv('ALV08B', 0.1, 'Hardware');
steppv('ACV09A', 0.1, 'Hardware');
steppv('ACV09B', 0.1, 'Hardware');
steppv('ALV10A', 0.1, 'Hardware');
steppv('ALV10B', 0.1, 'Hardware');
steppv('ACV11A', 0.1, 'Hardware');
steppv('ACV11B', 0.1, 'Hardware');
steppv('ALV12A', 0.1, 'Hardware');
steppv('ALV12B', 0.1, 'Hardware');
steppv('ACV01A', 0.1, 'Hardware');

orbx = getx();
orby = gety();

figure; plot(orbx); xlabel('BPM Index'); ylabel('ORBX [mm]');
figure; plot(orby); xlabel('BPM Index'); ylabel('ORBY [mm]');