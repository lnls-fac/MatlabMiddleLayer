function r = calibracao_ltx

global THERING;

r = ltx;

XMP03 = findcells(THERING, 'FamName', 'XMP03');
XMP04 = findcells(THERING, 'FamName', 'XMP04');
XMP05 = findcells(THERING, 'FamName', 'XMP05');
XMP06 = findcells(THERING, 'FamName', 'XMP06');

XCV03 = findcells(THERING, 'FamName', 'XCV03');
XCV04 = findcells(THERING, 'FamName', 'XCV04');
XCV05 = findcells(THERING, 'FamName', 'XCV05');

XCH03 = findcells(THERING, 'FamName', 'XCH03');
XCH04 = findcells(THERING, 'FamName', 'XCH04');

XQF04 = findcells(THERING, 'FamName', 'XQF04');
%THERING{XQF04}.K = 0;
%THERING{XQF04}.PolynomB(2) = 0;

init = [0.000 0 0.000 0 0.0 0.00]';

THERING{XCV04}.KickAngle = [0 0];
traj1 = linepass(THERING, init, 1:length(THERING));
THERING{XCV04}.KickAngle = [0 1*0.0005];
traj2 = linepass(THERING, init, 1:length(THERING));

%{
THERING{XCH03}.KickAngle = [0 0];
traj1 = linepass(THERING, init, 1:length(THERING));
THERING{XCH03}.KickAngle = [0.0002 0];
traj2 = linepass(THERING, init, 1:length(THERING));
%}

diff = traj2 - traj1;
r = 1e6 * diff(:,[XMP03 XMP04 XMP05 XMP06]);

