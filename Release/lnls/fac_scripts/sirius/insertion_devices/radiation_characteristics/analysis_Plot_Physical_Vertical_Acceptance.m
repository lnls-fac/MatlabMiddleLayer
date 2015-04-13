function analysis_Plot_Physical_Vertical_Acceptance

global THERING


% Parameters
dipole_chamber_height = 28 / 1000;     % m
straight_chamber_diameter = 40 / 1000; % m
smallest_length = 100 / 1000;           % m

% Loads AT model if necessary
if isempty(THERING)
    sirius;
end

% Defines vaccum chamber 
the_ring = lnls_refine_lattice(THERING, smallest_length);
vchamber = (straight_chamber_diameter/2) * ones(length(the_ring), 1);
bends = [];
bends = [bends findcells(the_ring, 'FamName', 'BO')];
bends = [bends findcells(the_ring, 'FamName', 'BI')];
bends = [bends findcells(the_ring, 'FamName', 'BC')];
vchamber(bends) = (dipole_chamber_height/2);

% Calcs beta functions
r = calctwiss(the_ring);

% Calcs local acceptance
local_vaccept = (vchamber .^ 2) ./ r.betay;
vaccept = min(local_vaccept);
sel  = abs(100 * (local_vaccept - vaccept) / vaccept) < 0.1;
amin = vaccept;
fprintf('Aceitância sem IDs [mm.mrad]: %f\n', vaccept * 1e6);

tamy = sqrt(vaccept * r.betay);
plot(r.pos, 1000 * tamy);
hold all;
scatter(r.pos(sel), 1000*tamy(sel), 10, [0 0 1], 'filled');
drawlattice(-1, 1);
axis([0 r.pos(end)/4 -2 15]);


MS  = findcells(the_ring, 'FamName', 'MS');
MM  = findcells(the_ring, 'FamName', 'MM');
ML  = findcells(the_ring, 'FamName', 'ML');

% IDS

idx = ML(1);
len = 2.98;
pos = 0;
aperture = 4.50 / 1000;
sel = ((r.pos(idx) + pos - (len/2)) <= r.pos) & ((r.pos(idx) + pos + (len/2)) >= r.pos);
vchamber(sel) = aperture/2;

% Calcs local acceptance
local_vaccept = (vchamber .^ 2) ./ r.betay;
vaccept = min(local_vaccept);
sel  = abs(100 * (local_vaccept - vaccept) / vaccept) < 0.1;
fprintf('Aceitância com IDs [mm.mrad]: %f\n', vaccept * 1e6);

tamy = sqrt(vaccept * r.betay);
plot(r.pos, 1000 * tamy, 'r');
hold all;
scatter(r.pos(sel), 1000*tamy(sel), 10, [1 0 0], 'filled');
axis([0 r.pos(end)/4 -2 15]);

% MS
Gmin_ms = 2 * sqrt(amin * r.betay(MS(1)));
Gmin_mm = 2 * sqrt(amin * r.betay(MM(1)));
Gmin_ml = 2 * sqrt(amin * r.betay(ML(1)));
fprintf('MS Gap Mínimo [mm]: %f\n', Gmin_ms * 1000); 
fprintf('MM Gap Mínimo [mm]: %f\n', Gmin_mm * 1000); 
fprintf('ML Gap Mínimo [mm]: %f\n', Gmin_ml * 1000); 

