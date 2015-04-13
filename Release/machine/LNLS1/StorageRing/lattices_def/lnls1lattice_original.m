function lat = lnls1_lattice(varargin)

% Creates the LNLS-1 lattice containing all the elements and in the end
% calculates the initial tunes, total length and RF frequency that will be
% used for the calculations.

global THERING

Energy = 1.37e9;

disp(['   Loading LNLS1 VUV Lattice: ', mfilename]);

L0 = 93.200;    % design length [m]
C0 = 2.99792458e8;   % speed of light [m/s]
CavityHarmNumber = 148;

corrector_length       = 0.0005;
dipole_length          = 1.432;
quadrupole_length      = 0.32;
skew_quadrupole_length = 0.10;
delta_dipole_length    = 1*2.5 * 0.010;
AON11_length = 2.8;


% auxiliary length parameters 
sep_ACH05A_AQS05A = (1.335 - 1.106 - skew_quadrupole_length/2);
sep_ACH05B_AQS05B = (1.334 - 1.084 - skew_quadrupole_length/2);
dcp_bpm  = 26/1000; % distancia do passante (onde as poss dos bpms foram medidas) ao centro do bpm.


qf_str = 2.784616623067428;
qd_str = -2.988217449872700;
qfc_str = 1.963399173488587;

skew_quad_str   = 0;

sd_str = -34.983921246554814; % cromaticidade zero
sf_str = 53.063121966483770; % cromaticidade zero


rbend_pass_method      = 'BendLinearPass';
drift_pass_method      = 'DriftPass';
%quadrupole_pass_method = 'StrMPoleSymplectic4Pass';
quadrupole_pass_method = 'FFQuadLinearPass';
corrector_pass_method  = 'CorrectorPass';
sextupole_pass_method  = 'StrMPoleSymplectic4Pass';
bpm_pass_method        = 'IdentityPass';


% TEMPLATES

q_length = [0.03 0.03 0.10];
veck = [42/90 0.7 1];


q1 = ffquadrupole ('QFC', quadrupole_length/2, qfc_str, 3, q_length, veck, quadrupole_pass_method);
q2 = ffquadrupole ('QFC', quadrupole_length/2, qfc_str, 3, flipdim(q_length,2), flipdim(veck,2), quadrupole_pass_method);
cv = corrector  ('VCM', 0.00000, [0 0], corrector_pass_method);
qfc_element = [q1 cv q2];

q1 = ffquadrupole ('QF', quadrupole_length/2, qf_str, 3, q_length, veck, quadrupole_pass_method);
q2 = ffquadrupole ('QF', quadrupole_length/2, qf_str, 3, flipdim(q_length,2), flipdim(veck,2), quadrupole_pass_method);

qf_element = [q1 q2];

q1 = ffquadrupole ('QD', quadrupole_length/2, qd_str, 3, q_length, veck, quadrupole_pass_method);
q2 = ffquadrupole ('QD', quadrupole_length/2, qd_str, 3, flipdim(q_length,2), flipdim(veck,2), quadrupole_pass_method);
qd_element = [q1 q2];

d1 = rbend      ('BEND', (dipole_length+delta_dipole_length)*(4/30) , (2*pi/12)*(4/30), (2*pi/12)/2, 0, 0, rbend_pass_method);
d2 = rbend      ('BEND', (dipole_length+delta_dipole_length)*(11/30), (2*pi/12)*(11/30), 0, 0, 0, rbend_pass_method);
d3 = rbend      ('BEND', (dipole_length+delta_dipole_length)*(15/30), (2*pi/12)*(15/30), 0, (2*pi/12)/2, 0, rbend_pass_method);
adi_element = [d1 d2 d3];

skew_quad_element = ffquadrupole ('SKEWQUAD', skew_quadrupole_length, skew_quad_str, 1, 1, 1, quadrupole_pass_method);


s1 = sextupole  ('SF', 0.05000, sf_str, sextupole_pass_method);
sf_element = [s1 s1];

s1 = sextupole  ('SD', 0.10000, sd_str, sextupole_pass_method);
sd_element = [s1];

ach_element = corrector  ('HCM', 0.00000, [0 0], corrector_pass_method);
acv_element = corrector  ('VCM', 0.00000, [0 0], corrector_pass_method);
bpm_element = marker     ('BPM', bpm_pass_method);

rf_cavity	= rfcavity   ('RF' , 0 , 0.3e+6 , CavityHarmNumber*C0/L0, CavityHarmNumber ,'CavityPass');  

d1 = drift      ('ID', AON11_length/2, drift_pass_method);
d2 = drift      ('ID', AON11_length/2, drift_pass_method);
AON11  = [d1 d2];

ach_element2 = corrector  ('HCM', 0.00000, [0 0], corrector_pass_method);

FIM   =  marker('FIM', 'IdentityPass');


% ------------------------
% --- chromatic arc 02 ---
% ------------------------


ATRA    = drift      ('ATR', 2.072666+0.0015, drift_pass_method);
ACH01B  = ach_element;
ATRB    = drift      ('ATR', 0.14800+(0.2545-0.148)-dcp_bpm, drift_pass_method);
AMP01B  = bpm_element;
ATRC    = drift      ('ATR', 0.17800+(0.070-0.178)+dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AQF01B  = qf_element;
ATRD    = drift      ('ATR', 0.18500+0.0355-(quadrupole_length-0.25)/2, drift_pass_method);
ACV01B  = acv_element;
ATRE    = drift      ('ATR', 0.20500+(0.1695-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQD01B  = qd_element;
ATRF    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
ssec01B = [ATRA ACH01B ATRB AMP01B ATRC AQF01B ATRD ACV01B ATRE AQD01B ATRF];

ADI01   = adi_element;

ATRA    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
ASD02A  = sd_element;
ATRB    = drift      ('ATR', 0.2120-dcp_bpm, drift_pass_method);
AMP02A  = bpm_element;
ATRC    = drift      ('ATR', 0.0980+dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AQF02A  = qfc_element;
ATRD    = drift      ('ATR', 0.78200-(quadrupole_length-0.25)/2, drift_pass_method);
disp02A = [ATRA ASD02A ATRB AMP02A ATRC AQF02A ATRD];

ASF02 = sf_element;

ATRA    = drift      ('ATR', 0.2845, drift_pass_method);
ACH02B  = ach_element;
ATRB    = drift      ('ATR', 0.49750-(quadrupole_length-0.25)/2, drift_pass_method);
AQF02B  = qfc_element;
ATRC    = drift      ('ATR', 0.18300-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);       
AMP02B  = bpm_element;
ATRD    = drift      ('ATR', 0.12700+dcp_bpm, drift_pass_method);   
ASD02B  = sd_element;
ATRE    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
disp02B = [ATRA ACH02B ATRB AQF02B ATRC AMP02B ATRD ASD02B ATRE];

ADI02   = adi_element;

ATRA    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
AQD03A  = qd_element;
ATRB    = drift      ('ATR', 0.20500+(0.1965-0.20500)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV03A  = acv_element;
ATRC    = drift      ('ATR', 0.18500-(0.1965-0.20500)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF03A  = qf_element;
ATRD    = drift      ('ATR', 0.22400-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP03A  = bpm_element;
ATRE    = drift      ('ATR', 0.10200+(0.1025-0.102)+dcp_bpm, drift_pass_method);
ACH03A  = ach_element;
ATRF    = drift      ('ATR', 2.072666-(0.1025-0.102), drift_pass_method);
ssec03A = [ATRA AQD03A ATRB ACV03A ATRC AQF03A ATRD AMP03A ATRE ACH03A ATRF];


sup02   = [ssec01B ADI01 disp02A ASF02 disp02B ADI02 ssec03A];


% ------------------------
% --- chromatic arc 04 ---
% ------------------------

ATRA    = drift      ('ATR', 2.072666-(0.273-0.148)-(0.3255-0.178), drift_pass_method);
AMP03B  = bpm_element;
ATRB    = drift      ('ATR', 0.14800+(0.273-0.148), drift_pass_method);
ACH03B  = ach_element;
ATRC    = drift      ('ATR', 0.17800+(0.3255-0.178)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF03B  = qf_element;
ATRD    = drift      ('ATR', 0.18500-(quadrupole_length-0.25)/2, drift_pass_method);
ACV03B  = acv_element;
ATRE    = drift      ('ATR', 0.20500-(quadrupole_length-0.25)/2, drift_pass_method);
AQD03B  = qd_element;
ATRF    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
ssec03B = [ATRA AMP03B ATRB ACH03B ATRC AQF03B ATRD ACV03B ATRE AQD03B ATRF];

ADI03   = adi_element;

ATRA    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
ASD04A  = sd_element;
ATRB    = drift      ('ATR', 0.18700-dcp_bpm, drift_pass_method);
AMP04A  = bpm_element;
ATRC    = drift      ('ATR', 0.12300+dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AQF04A  = qfc_element;
ATRD    = drift      ('ATR', 0.78200-(quadrupole_length-0.25)/2, drift_pass_method);
disp04A = [ATRA ASD04A ATRB AMP04A ATRC AQF04A ATRD];

ASF04   = sf_element;

ATRA    = drift      ('ATR', 0.12000-(0.5795-0.662), drift_pass_method);
ACH04B  = ach_element;
ATRB    = drift      ('ATR', 0.66200+(0.5795-0.662)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF04B  = qfc_element;
ATRC    = drift      ('ATR', 0.18200-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP04B  = bpm_element;
ATRD    = drift      ('ATR', 0.12800+dcp_bpm, drift_pass_method);
ASD04B  = sd_element;
ATRE    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
disp04B = [ATRA ACH04B ATRB AQF04B ATRC AMP04B ATRD ASD04B ATRE];

ADI04   = adi_element;

ATRA    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
AQD05A  = qd_element;
ATRB    = drift      ('ATR', 0.20500+(0.1705-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV05A  = acv_element;
ATRC    = drift      ('ATR', 0.18500-(0.1705-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF05A  = qf_element;
ATRD    = drift      ('ATR', 0.16300-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP05A  = bpm_element;
ATRE    = drift      ('ATR', 0.16300+(0.0945-0.163)+dcp_bpm, drift_pass_method);
ACH05A  = ach_element;
ATRF    = drift      ('ATR', sep_ACH05A_AQS05A, drift_pass_method);
AQS05A  = skew_quad_element;
ATRG    = drift      ('ATR', (2.072666-(0.0945-0.163)) - (sep_ACH05A_AQS05A + skew_quadrupole_length), drift_pass_method);
ssec05A = [ATRA AQD05A ATRB ACV05A ATRC AQF05A ATRD AMP05A ATRE ACH05A ATRF AQS05A ATRG];


sup04       = [ssec03B ADI03 disp04A ASF04 disp04B ADI04 ssec05A];


% ------------------------
% --- chromatic arc 06 ---
% ------------------------

RFCAVA  = rf_cavity;
ATRa    = drift      ('ATR', 0.92147, drift_pass_method);
RFCAVB  = rf_cavity;
ATRA    = drift      ('ATR', 2.072666-(0.1335-0.224) - (sep_ACH05B_AQS05B + skew_quadrupole_length)-0.92147, drift_pass_method);
AQS05B  = skew_quad_element;
ATRB    = drift      ('ATR', sep_ACH05B_AQS05B, drift_pass_method);
ACH05B  = ach_element;
ATRC    = drift      ('ATR', 0.22400+(0.1335-0.224)-dcp_bpm, drift_pass_method);
AMP05B  = bpm_element;
ATRD    = drift      ('ATR', 0.10200+dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AQF05B  = qf_element;
ATRE    = drift      ('ATR', 0.18500-(0.2025-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV05B  = acv_element;
ATRF    = drift      ('ATR', 0.20500+(0.2025-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQD05B  = qd_element;
ATRG    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
ssec05B = [RFCAVA ATRa RFCAVB ATRA AQS05B ATRB ACH05B ATRC AMP05B ATRD AQF05B ATRE ACV05B ATRF AQD05B ATRG];

ADI05   = adi_element;

ATRA    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
ASD06A  = sd_element;
ATRB    = drift      ('ATR', 0.21100-dcp_bpm, drift_pass_method);
AMP06A  = bpm_element;
ATRC    = drift      ('ATR', 0.09900+dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);                      
AQF06A  = qfc_element;
ATRD    = drift      ('ATR', 0.78200-(quadrupole_length-0.25)/2, drift_pass_method);
disp06A = [ATRA ASD06A ATRB AMP06A ATRC AQF06A ATRD];

ASF06   = sf_element;

ATRA    = drift      ('ATR', 0.12000-(0.5785-0.662), drift_pass_method);
ACH06B  = ach_element;
ATRB    = drift      ('ATR', 0.66200+(0.5785-0.662)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF06B  = qfc_element;
ATRC    = drift      ('ATR', 0.17400-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP06B  = bpm_element;
ATRD    = drift      ('ATR', 0.13600+dcp_bpm, drift_pass_method);
ASD06B  = sd_element;
ATRE    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
disp06B = [ATRA ACH06B ATRB AQF06B ATRC AMP06B ATRD ASD06B ATRE];

ADI06   = adi_element;

ATRA    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
AQD07A  = qd_element;
ATRB    = drift      ('ATR', 0.20500+(0.1705-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV07A  = acv_element;
ATRC    = drift      ('ATR', 0.18500-(0.1705-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF07A  = qf_element;
ATRD    = drift      ('ATR', 0.16900-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP07A  = bpm_element;
ATRE    = drift      ('ATR', 0.15700+(0.1515-0.157)+dcp_bpm, drift_pass_method);
ACH07A  = ach_element;
ATRF    = drift      ('ATR', 2.072666-(0.1515-0.157), drift_pass_method);
ssec07A = [ATRA AQD07A ATRB ACV07A ATRC AQF07A ATRD AMP07A ATRE ACH07A ATRF];


sup06   = [ssec05B ADI05 disp06A ASF06 disp06B ADI06 ssec07A];


% ------------------------
% --- chromatic arc 08 ---
% ------------------------

ATRA    = drift      ('ATR', 2.072666-(0.1925-0.193), drift_pass_method);
ACH07B  = ach_element;
ATRB    = drift      ('ATR', 0.19300+(0.1925-0.193), drift_pass_method);
AMP07B  = bpm_element;
ATRC    = drift      ('ATR', 0.13300-(quadrupole_length-0.25)/2, drift_pass_method); 
AQF07B  = qf_element;
ATRD    = drift      ('ATR', 0.18500-(0.1985-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV07B  = acv_element;
ATRE    = drift      ('ATR', 0.20500+(0.1985-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQD07B  = qd_element;
ATRF    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
ssec07B = [ATRA ACH07B ATRB AMP07B ATRC AQF07B ATRD ACV07B ATRE AQD07B ATRF];

ADI07   = adi_element;

ATRA    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
ASD08A  = sd_element;
ATRB    = drift      ('ATR', 0.18400, drift_pass_method);
AMP08A  = bpm_element;
ATRC    = drift      ('ATR', 0.12600-(quadrupole_length-0.25)/2, drift_pass_method);
AQF08A  = qfc_element;
ATRD    = drift      ('ATR', 0.78200-(quadrupole_length-0.25)/2, drift_pass_method);
disp08A = [ATRA ASD08A ATRB AMP08A ATRC AQF08A ATRD];

ASF08   = sf_element;

ATRA    = drift      ('ATR', 0.12000-(0.5905-0.662), drift_pass_method);
ACH08B  = ach_element;
ATRB    = drift      ('ATR', 0.66200+(0.5905-0.662)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF08B  = qfc_element;
ATRC    = drift      ('ATR', 0.13800-(quadrupole_length-0.25)/2, drift_pass_method);
AMP08B  = bpm_element;
ATRD    = drift      ('ATR', 0.17200, drift_pass_method);
ASD08B  = sd_element;
ATRE    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
disp08B = [ATRA ACH08B ATRB AQF08B ATRC AMP08B ATRD ASD08B ATRE];

ADI08   = adi_element;

ATRA    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
AQD09A  = qd_element;
ATRB    = drift      ('ATR', 0.20500+(0.1975-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV09A  = acv_element;
ATRC    = drift      ('ATR', 0.18500-(0.1975-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF09A  = qf_element;
ATRD    = drift      ('ATR', 0.13250-(quadrupole_length-0.25)/2, drift_pass_method);
AMP09A  = bpm_element;
ATRE    = drift      ('ATR', 0.19350+(0.194-0.1935), drift_pass_method);
ACH09A  = ach_element;
ATRF    = drift      ('ATR', 2.072666-(0.194-0.1935), drift_pass_method);
ssec09A = [ATRA AQD09A ATRB ACV09A ATRC AQF09A ATRD AMP09A ATRE ACH09A ATRF];


sup08   = [ssec07B ADI07 disp08A ASF08 disp08B ADI08 ssec09A];



% ------------------------
% --- chromatic arc 10 ---
% ------------------------

ATRA    = drift      ('ATR', 2.072666-(0.1675-0.196), drift_pass_method);
ACH09B  = ach_element;
ATRB    = drift      ('ATR', 0.19600+(0.1675-0.196), drift_pass_method);
AMP09B  = bpm_element;
ATRC    = drift      ('ATR', 0.13000-(quadrupole_length-0.25)/2, drift_pass_method);
AQF09B  = qf_element;
ATRD    = drift      ('ATR', 0.18500-(0.1805-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV09B  = acv_element;
ATRE    = drift      ('ATR', 0.20500+(0.1805-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQD09B  = qd_element;
ATRF    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
ssec09B = [ATRA ACH09B ATRB AMP09B ATRC AQF09B ATRD ACV09B ATRE AQD09B ATRF];

ADI09   = adi_element;

ATRA    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
ASD10A  = sd_element;
ATRB    = drift      ('ATR', 0.17750, drift_pass_method);
AMP10A  = bpm_element;
ATRC    = drift      ('ATR', 0.13250-(quadrupole_length-0.25)/2, drift_pass_method);
AQF10A  = qfc_element;
ATRD    = drift      ('ATR', 0.78200-(quadrupole_length-0.25)/2, drift_pass_method);
disp10A = [ATRA ASD10A ATRB AMP10A ATRC AQF10A ATRD];

ASF10   = sf_element;

ATRA    = drift      ('ATR', 0.12000-(0.5495-0.662), drift_pass_method);
ACH10B  = ach_element;
ATRB    = drift      ('ATR', 0.66200+(0.5495-0.662)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF10B  = qfc_element;
ATRC    = drift      ('ATR', 0.14900-(quadrupole_length-0.25)/2, drift_pass_method);
AMP10B  = bpm_element;
ATRD    = drift      ('ATR', 0.16100, drift_pass_method);
ASD10B  = sd_element;
ATRE    = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
disp10B = [ATRA ACH10B ATRB AQF10B ATRC AMP10B ATRD ASD10B ATRE];

ADI10   = adi_element;

ATRA    = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
AQD11A  = qd_element;
ATRB    = drift      ('ATR', 0.20500+(0.1715-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV11A  = acv_element;
ATRC    = drift      ('ATR', 0.18500-(0.1715-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF11A  = qf_element;
ATRD    = drift      ('ATR', 0.17800-(quadrupole_length-0.25)/2, drift_pass_method);
AMP11A  = bpm_element;
ATRE    = drift      ('ATR', 0.14800+(0.1455-0.148), drift_pass_method);
ACH11A  = ach_element; 
ATRF    = drift      ('ATR', 0.367, drift_pass_method);
AMU11A  = bpm_element;
ATRG  = drift      ('ATR', 1.70567-(0.1455-0.148)-AON11_length/2, drift_pass_method);
ssec11A = [ATRA AQD11A ATRB ACV11A ATRC AQF11A ATRD AMP11A ATRE ACH11A ATRF AMU11A ATRG];

sup10   = [ssec09B ADI09 disp10A ASF10 disp10B ADI10 ssec11A];



% ------------------------
% --- chromatic arc 12 ---
% ------------------------
ATRA   = drift      ('ATR', 1.69267-(0.1425-0.148)-AON11_length/2, drift_pass_method);
AMU11B   = bpm_element;
ATRB   = drift      ('ATR', 0.3800, drift_pass_method);
ACH11B   = ach_element;
ATRC   = drift      ('ATR', 0.14800+(0.1425-0.148), drift_pass_method);                       
AMP11B   = bpm_element; 
ATRD   = drift      ('ATR', 0.17800-(quadrupole_length-0.25)/2, drift_pass_method);
AQF11B = qf_element;
ATRE   = drift      ('ATR', 0.18500-(0.2015-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV11B   = acv_element;
ATRF   = drift      ('ATR', 0.20500+(0.2015-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQD11B = qd_element;
ATRG   = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
ssec11B   = [ATRA AMU11B ATRB ACH11B ATRC AMP11B ATRD AQF11B ATRE ACV11B ATRF AQD11B ATRG];

ADI11   = adi_element;

ATRA   = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
ASD12A   = sd_element;
ATRB   = drift      ('ATR', 0.18400-dcp_bpm, drift_pass_method);
AMP12A   = bpm_element;
ATRC   = drift      ('ATR', 0.12600+dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AQF12A = qfc_element;
ATRD   = drift      ('ATR', 0.66200+(0.5305-0.662)-(quadrupole_length-0.25)/2, drift_pass_method);
ACH12A   = ach_element;
ATRE   = drift      ('ATR', 0.12000-(0.5305-0.662), drift_pass_method);
disp12A   = [ATRA ASD12A ATRB AMP12A ATRC AQF12A ATRD ACH12A ATRE];

ASF12 = sf_element;

ATRA   = drift      ('ATR', 0.78200-(quadrupole_length-0.25)/2, drift_pass_method);
AQF12B = qfc_element;
ATRB   = drift      ('ATR', 0.18500-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP12B   = bpm_element;
ATRC   = drift      ('ATR', 0.12500+dcp_bpm, drift_pass_method);
ASD12B   = sd_element;
ATRD   = drift      ('ATR', 0.71500-delta_dipole_length/2-corrector_length, drift_pass_method);
disp12B   = [ATRA AQF12B ATRB AMP12B ATRC ASD12B ATRD];

ADI12   = adi_element;

ATRA   = drift      ('ATR', 0.84000-(quadrupole_length-0.25)/2-delta_dipole_length/2-corrector_length, drift_pass_method);
AQD01A = qd_element;
ATRB   = drift      ('ATR', 0.20500+(0.1945-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
ACV01A   = acv_element;
ATRC   = drift      ('ATR', 0.18500-(0.1945-0.205)-(quadrupole_length-0.25)/2, drift_pass_method);
AQF01A = qf_element;
ATRD   = drift      ('ATR', 0.17200-dcp_bpm-(quadrupole_length-0.25)/2, drift_pass_method);
AMP01A   = bpm_element;
ATRE   = drift      ('ATR', 0.15400+(0.1535-0.154)+dcp_bpm, drift_pass_method);
ACH01A   = ach_element;
ATRF   = drift      ('ATR', 2.072666-(0.1535-0.154), drift_pass_method);
ssec01A   = [ATRA AQD01A ATRB ACV01A ATRC AQF01A ATRD AMP01A ATRE ACH01A ATRF];


sup12     = [ssec11B ADI11 disp12A ASF12 disp12B ADI12 ssec01A];



% --- ring ---

elist = [sup02 sup04 sup06 sup08 sup10 AON11 sup12 FIM];

THERING = buildlat(elist);


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f m   (design length 93.2 m)\n', L0_tot);
fprintf('   RF = %.6f MHz\n', CavityHarmNumber*C0/L0_tot/1e6);

%radiationoff;
%cavityoff;

% Compute initial tunes before loading errors
[InitialTunes, InitialChro]= tunechrom(THERING,0,'chrom','coupling');
fprintf('   Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
fprintf('   Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('   Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));

% Generates rotation of skewquads
skquads = findcells(THERING, 'FamName', 'SKEWQUAD');
fprintf('   Generating pi/4 rotation of %i skew quadrupoles\n', length(skquads));
settilt(skquads, (pi/4)*ones(1,length(skquads)));

clear global FAMLIST GLOBVAL;
evalin('base','clear LOSSFLAG');

lat = THERING;


