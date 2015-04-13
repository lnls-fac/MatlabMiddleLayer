function [Mcorr, Mss, Mdisp, Mrf] = respmuvx

global THERING;
lnls1;
setoperationalmode(1);

% Orbit and light source markers
bpm_markers    = findcells(THERING, 'FamName', 'BPM')';
rad4g_markers  = findcells(THERING, 'FamName', 'RAD4G')';
rad15g_markers = findcells(THERING, 'FamName', 'RAD15G')';
ss_markers     = findcells(THERING, 'FamName', 'LCENTER')';
id_markers = ss_markers([1 5:end]); % Remove injection (2) and cavity (3) long straight sections; remove long straight section without ID (4)
[source_markers, reorder_source_markers] = sort([rad4g_markers; rad15g_markers; id_markers]);
[orbit_markers, reorder_orbit_markers] = sort([bpm_markers; source_markers]);

% Actuator and disturbance markers
hcm_markers = findcells(THERING, 'FamName', 'HCM')';
vcm_markers = findcells(THERING, 'FamName', 'VCM')';

nsegsquad = 2;
quad_markers = ([ ...
    findcells(THERING, 'FamName', 'A2QF01') ...
    findcells(THERING, 'FamName', 'A2QF03') ...
    findcells(THERING, 'FamName', 'A2QF05') ...
    findcells(THERING, 'FamName', 'A2QF07') ...
    findcells(THERING, 'FamName', 'A2QF09') ...
    findcells(THERING, 'FamName', 'A2QF11') ...
    findcells(THERING, 'FamName', 'A2QD01') ...
    findcells(THERING, 'FamName', 'A2QD03') ...
    findcells(THERING, 'FamName', 'A2QD05') ...
    findcells(THERING, 'FamName', 'A2QD07') ...
    findcells(THERING, 'FamName', 'A2QD09') ...
    findcells(THERING, 'FamName', 'A2QD11') ...
    findcells(THERING, 'FamName', 'A6QF01') ...
    findcells(THERING, 'FamName', 'A6QF02') ...
])';
[~, reorder_quad_markers] = sort(quad_markers(1:nsegsquad:end));
quad_markers = reshape(quad_markers, nsegsquad, length(quad_markers)/nsegsquad)';
quad_markers = quad_markers(reorder_quad_markers, :);

rf_markers = sort(findcells(THERING, 'FamName', 'RF'))';

% Orbit and light source markers
bpm_names    = {'01B' '02A' '02B' '03A' '03B' '03C' '04A' '04B' '05A' '05B' '06A' '06B' '07A' '07B' '08A' '08B' '09A' '09B' '10A' '10B' '11A' '11B' '12A' '12B' '01A'};

rad4g_names  = {'D01A' 'D02A (SAXS2)' 'D03A (IR)' 'D04A (SXS)' 'D05A (TGM)' 'D06A (DXAS)' 'D07A' 'D08A (SGM)' 'D09A' 'D10A (XRD2)' 'D11A' 'D12A (XRD1)' };
rad15g_names = {'D01B (SAXS1)' 'D02B (DFX)' 'D03B (MX1)' 'D04B (XAFS1)' 'D05B (DFE)' 'D06B (IMX1)' 'D07B' 'D08B (XAFS2)' 'D09B (XRF)' 'D10B (XPD)' 'D11B' 'D12B'};
ss_names     = {'AWG01', 'INJECTION', 'RF', '(empty SS)', 'AWG09', 'AON11'};
id_names     = {'W01B (MX2)', 'W09A (XDS)', 'U11A (PGM1)'};
source_names = [rad4g_names rad15g_names id_names];
source_names = source_names(reorder_source_markers);
orbit_names  = [bpm_names source_names];
orbit_names  = orbit_names(reorder_orbit_markers);

% Actuator and disturbance names
hcm_names    = {'ACH01B' 'ACH02' 'ACH03A' 'ACH03B' 'ACH04' 'ACH05A' 'ACH05B' 'ACH06' 'ACH07A' 'ACH07B' 'ACH08' 'ACH09A' 'ACH09B' 'ACH10' 'ACH11A' 'ACH11B' 'ACH12' 'ACH01A'};
vcm_names    = {'ACV01B' 'ALV02A' 'ALV02B' 'ACV03A' 'ACV03B' 'ALV04A' 'ALV04B' 'ACV05A' 'ACV05B' 'ALV06A' 'ALV06B' 'ACV07A' 'ACV07B' 'ALV08A' 'ALV08B' 'ACV09A' 'ACV09B' 'ALV10A' 'ALV10B' 'ACV11A' 'ACV11B' 'ALV12A' 'ALV12B' 'ACV01A'};
quad_names   = {'A2QF01B' 'A2QF01A' 'A2QF03A' 'A2QF03B' 'A2QF05A' 'A2QF05B' 'A2QF07A' 'A2QF07B' 'A2QF09A' 'A2QF09B' 'A2QF11A' 'A2QF11B' ...
                'A2QD01B' 'A2QD01A' 'A2QD03A' 'A2QD03B' 'A2QD05A' 'A2QD05B' 'A2QD07A' 'A2QD07B' 'A2QD09A' 'A2QD09B' 'A2QD11A' 'A2QD11B' ...
                'A6QF02A' 'A6QF04B' 'A6QF06A' 'A6QF08B' 'A6QF10A' 'A6QF12B' ...
                'A6QF02B' 'A6QF04A' 'A6QF06B' 'A6QF08A' 'A6QF10B' 'A6QF12A'};
quad_names   = quad_names(reorder_quad_markers);
rf_names     = {'RF A', 'RF B'};

% Calculate response matrices
markers = struct('orbit', orbit_markers, 'corr', hcm_markers, 'ss', ss_markers, 'disp', quad_markers, 'rf', rf_markers);
[Mcorrh, Mssh, Mdisph, Mrf] = respmorbit(THERING, markers, 'h');

markers = struct('orbit', orbit_markers, 'corr', vcm_markers, 'ss', ss_markers, 'disp', quad_markers);
[Mcorrv, Mssv, Mdispv] = respmorbit(THERING, markers, 'v');

% Merge horizontal and vertical plane matrices
Mcorr = mergehv(Mcorrh, Mcorrv);
Mss = mergehv(Mssh, Mssv);
Mdisp = mergehv(Mdisph, Mdispv);
Mrf = mergehv(Mrf, []);

% Build index vectors to find BPM and light source lines on matrices
[~, rereorder_orbit_markers] = sort(reorder_orbit_markers);
bpm_index = rereorder_orbit_markers(1:length(bpm_markers));
source_index = rereorder_orbit_markers(length(bpm_markers)+1:end);

% Set general fields
Mcorr = setfields(Mcorr, bpm_index, source_index, orbit_names, 'Orbit corrector', 'rad', hcm_names, vcm_names);
Mss   = setfields(Mss,   bpm_index, source_index, orbit_names, 'Straight Section', 'rad', ss_names, ss_names);
Mdisp = setfields(Mdisp, bpm_index, source_index, orbit_names, 'Quadrupoles', 'm', quad_names, quad_names);
Mrf   = setfields(Mrf,   bpm_index, source_index, orbit_names, 'RF Cavity', 'Hz', rf_names);


function M = mergehv(Mh, Mv)

M = [];
if ~isempty(Mh)
    M.h.pos = Mh.pos;
    M.h.ang = Mh.ang;
end

if ~isempty(Mv)
    M.v.pos = Mv.pos;
    M.v.ang = Mv.ang;
end


function M = setfields(M, bpm_index, source_index, orbit_names, variable_name, unit, hnames, vnames)

M.bpm_index = bpm_index;
M.source_index = source_index;
M.orbit_names = orbit_names;
M.variable_name = variable_name;
M.unit = unit;

if isfield(M, 'h') && ~isempty(M.h)
    M.h.names = hnames;
end

if isfield(M, 'v') &&  ~isempty(M.v)
    M.v.names = vnames;
end