function camdat

disp(['   Loading CAMD magnet lattice ', mfilename]);
global FAMLIST THERING

Energy = 1.3e9;

AP =  aperture('AP',  [-1, 1, -1,  1],'AperturePass');
 
L0 = 55.2;	     % design length [m]
C0 = 299792458;  % speed of light [m/s]
HarmNumber = 92;
CAV	= rfcavity('RF', 0, 350000, HarmNumber*C0/L0, HarmNumber , 'CavityPass');  

HCM = corrector('HCM', 0.0, [0 0], 'CorrectorPass');
VCM = corrector('VCM', 0.0, [0 0], 'CorrectorPass');
BPM = marker('BPM', 'IdentityPass');

D1A  = drift('D1A' ,1.47,'DriftPass');
D1B  = drift('D1B' ,0.13,'DriftPass');
D2   = drift('D2'  ,0.40,'DriftPass');
D3A  = drift('D3A' ,0.20,'DriftPass');
D3B  = drift('D3B' ,0.25,'DriftPass');
D4   = drift('D4'  ,0.40,'DriftPass');
D5   = drift('D5'  ,0.60,'DriftPass');
D5A  = drift('D5A' ,0.47,'DriftPass');
D5B  = drift('D5B' ,0.13,'DriftPass');
D6   = drift('D6'  ,0.20,'DriftPass');

QF = quadrupole('QF' , 0.30, 1.896272,  'StrMPoleSymplectic4Pass');
QD = quadrupole('QD' , 0.30, -1.452834, 'StrMPoleSymplectic4Pass');
QA = quadrupole('QFA' , 0.30, 2.682153,  'StrMPoleSymplectic4Pass');

SF = sextupole('SF' , 0.1, +17.34186/2,'StrMPoleSymplectic4Pass');
SD = sextupole('SD' , 0.1, -25.31921/2,'StrMPoleSymplectic4Pass');

%BEND = rbend('BEND'  , 2.30, 2*pi/8, pi/8, pi/8, 0, 'BndMPoleSymplectic4Pass');  %k=0
BEND = rbend('BEND'  , 2.30/4, 2*pi/8/4, pi/8,  0,  0, 'BndMPoleSymplectic4Pass');  %k=0
BEND = rbend('BEND'  , 2.30/4, 2*pi/8/4,   0,   0,  0, 'BndMPoleSymplectic4Pass');  %k=0
BEND = rbend('BEND'  , 2.30/4, 2*pi/8/4,   0,   0,  0, 'BndMPoleSymplectic4Pass');  %k=0
BEND = rbend('BEND'  , 2.30/4, 2*pi/8/4,   0, pi/8, 0, 'BndMPoleSymplectic4Pass');  %k=0

SUP =[
    AP D1A BPM D1B HCM QF D2 VCM QD D3A BPM D3B HCM ...
    BEND BEND BEND BEND D4 SD D5A BPM D5B SF D6 VCM QA D6 SF D5 SD D4 HCM ...
    BEND BEND BEND BEND D3B BPM D3A VCM QD D2 HCM QF D1B BPM D1A];

ELIST = [SUP SUP SUP CAV SUP];
buildlat(ELIST);


% Compute total length and RF frequency
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   L0 = %.4f m (Design length is %.4f meters)\n', L0_tot, L0);


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

% LOSSFLAG is in workspace in AT1.3
evalin('base','clear LOSSFLAG');

% New AT does not use FAMLIST
clear global FAMLIST

