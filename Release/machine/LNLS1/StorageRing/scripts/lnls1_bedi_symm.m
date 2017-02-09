function lnls1_bedi_symm

disp('THERING should have LOCO-calibrated model...');

QF0  = getpv('QF');
QD0  = getpv('QD');
QFC0 = getpv('QFC');
symmetrize_optics;
QF   = getpv('QF');
QD   = getpv('QD');
QFC  = getpv('QFC');

dQF  = QF - QF0;
dQD  = QD - QD0;
dQFC = QFC - QFC0;
switch2online;
%lnls1_slow_orbcorr_on;
lnls1_fast_orbcorr_on;

nrpts = 20;
for i=1:nrpts
    steppv('QF',  dQF/nrpts);
    steppv('QD',  dQD/nrpts);
    steppv('QFC', dQFC/nrpts);
    pause(0);
end


function symmetrize_optics

r = lnls1_symmetrize_simulation_optics([5;4]+tunes, 'QuadFamiliesWithIDs', 'AllSymmetriesWithIDs', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5;4]+tunes, 'QuadFamiliesWithIDs', 'AllSymmetriesWithIDs', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5;4]+tunes, 'QuadFamiliesWithIDs', 'AllSymmetriesWithIDs', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5;4]+tunes, 'QuadFamiliesWithIDs', 'AllSymmetriesWithIDs', 'BEDI');
r = lnls1_symmetrize_simulation_optics([5;4]+tunes, 'QuadFamiliesWithIDs', 'AllSymmetriesWithIDs', 'BEDI');

