function lnls1_fittune2(newtunes)

global THERING;

THERING0 = THERING;

QF  = getfamilydata('QF','AT','ATIndex'); QF = QF(:);
QD  = getfamilydata('QD','AT','ATIndex');  QD = QD(:);
QFC = getfamilydata('QFC','AT','ATIndex'); QFC = QFC(:);
THERING = setcellstruct(THERING, 'FamName', QF, 'QF');
THERING = setcellstruct(THERING, 'FamName', QD, 'QD');
THERING = setcellstruct(THERING, 'FamName', QFC, 'QFC');
fittune2(newtunes, 'QF', 'QD');
quads = findcells(THERING, 'K');
K = getcellstruct(THERING, 'K', quads);
THERING = THERING0;
THERING = setcellstruct(THERING, 'K', quads, K);
THERING = setcellstruct(THERING, 'PolynomB', quads, K, 1, 2);





