function [Mcorr, Mss, Mdisp, Mrf] = respmsirius(plane)
%RESPMSIRIUS Orbit response matrices and disturbance matrices.
%   M = fofb_orbit_respm_sirius(THERING) calculates Sirius's orbit response
%   matrices in 4-D transverse phase space:
%
%           corrector magnet kicks inputs [rad]
%           RF frequency steps inputs [Hz]
%           insertion device residual dipolar field disturbance [rad]
%           quadrupoles displacements [m]
%           bending magnets displacements [m]
%
%   Inputs:
%       THERING: AT accelerator model of Sirius ring
%
%   Outputs:
%       M: 
%
%   All response matrices are 3-D matrices where each dimension has the
%   following meaning:
%       Dim 1: index of beam orbit value in a given ring position
%       Dim 2: index of input or disturbance affecting the beam orbit
%       Dim 3: 4-D transverse phase space variable: 
%              1 = horizontal beam position [m]
%              2 = horizontal beam angle [rad]
%              3 = vertical beam position [m]
%              4 = vertical beam angle [rad]
%
%   *** FIXME: must include explanation about chosen orbit points; return
%   orbit point indexes, input and disturbance indexes ***

global THERING;
% sirius;
% setoperationalmode(1);

fprintf('\n   -------------------------------\n    Starting "sirius_orbit_respm"\n   -------------------------------\n');

% Dipoles segmentation numbers
nsegs_bc = 2;
nsegs_b1 = 2;
nsegs_b2 = 2;
nsegs_b3 = 2;

% Markers

% Insertion devices
mc = findcells(THERING, 'FamName', 'mc')';
mia  = findcells(THERING, 'FamName', 'mia')';
mib  = findcells(THERING, 'FamName', 'mib')';

% Quadrupoles
qad = findcells(THERING, 'FamName', 'qad')';
qaf  = findcells(THERING, 'FamName', 'qaf')';
qbf  = findcells(THERING, 'FamName', 'qbf')';
qf1  = findcells(THERING, 'FamName', 'qf1')';
qf2  = findcells(THERING, 'FamName', 'qf2')';
qf3  = findcells(THERING, 'FamName', 'qf3')';
qf4  = findcells(THERING, 'FamName', 'qf4')';
qbd1  = findcells(THERING, 'FamName', 'qbd1')';
qbd2 = findcells(THERING, 'FamName', 'qbd2')';

% Dipoles
bc = findcells(THERING, 'FamName', 'bc')';
b1 = findcells(THERING, 'FamName', 'b1')';
b2 = findcells(THERING, 'FamName', 'b2')';
b3 = findcells(THERING, 'FamName', 'b3')';

% Takes dipole segmentation into account
bc = reshape(bc, nsegs_bc, []);
b1 = reshape(b1, nsegs_b1, []);
b2 = reshape(b2, nsegs_b2, []);
b3 = reshape(b3, nsegs_b3, []);

bpm = findcells(THERING, 'FamName', 'BPM')';
id = sort([mia; mib]);
source =  sort([mc; id]);
hcm = findcells(THERING, 'FamName', 'hcm')';
vcm = findcells(THERING, 'FamName', 'vcm')';
crhv = findcells(THERING, 'FamName', 'crhv')';
quad = sort([qad; qaf; qbd1; qbd2; qbf; qf1; qf2; qf3; qf4]);
dipole = sort([bc b1 b2 b3])';
rf = findcells(THERING, 'FamName', 'cav')';

if strcmpi(plane, 'h')
    cm = hcm;
elseif strcmpi(plane, 'v')
    cm = vcm;
end

markers = struct( ...
    'orbit', bpm, ...
    'corr', crhv, ...
    'ss', id, ...
    'disp', quad, ...
    'rf', rf ...
);

[Mcorr, Mss, Mdisp, Mrf] = respmorbit(THERING, markers, plane);