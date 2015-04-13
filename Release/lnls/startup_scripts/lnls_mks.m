function r = lnls_mks

% http://en.wikipedia.org/wiki/SI_base_unit


% BASE UNITS (seven)
meter    = 1; % length
second   = 1; % mass
kilogram = 1; % time
ampere   = 1; % electrinc current
kelvin   = 1; % temperature
candela  = 1; % luminous intensity
mole     = 1; % amount of substance


c = lnls_constants;

% LENGTH SCALES/UNITS
r.M.m  = meter;
r.M.km = 1e3 * meter;
r.M.cm = 1e-2 * meter;
r.M.mm = 1e-3 * meter;
r.M.um = 1e-6 * meter;
r.M.nm = 1e-9 * meter;

% KILOGRAM SCALES/UNITS
r.K.kg = kilogram;
r.K.T  = 1000 * kilogram;
r.K.g  = 0.001 * kilogram;

% TIME SCALES/UNITS
r.S.s  = second;
r.S.h  = 3600 * second;
r.S.m  = 60 * second;

% ELECTRIC CURRENT SCALES/UNITS
r.A.A  = ampere;
r.A.mA = 0.001 * ampere;

% TEMPERATURE SCALES/UNITS
r.T.K = kelvin;

% DERIVED UNITS
% =============

% energy
r.D.V    = r.K.kg * r.M.m^2 / r.A.A / r.S.s^3;
r.D.eV   = abs(c.q0) * r.D.V;
r.D.GeV  = 1e9 * r.D.eV;
% magnetic field
r.D.T     = r.K.kg / r.A.A / r.S.s^2;
r.D.gauss = 1e-4 * r.D.T;

% ADIMENSIONAL UNITS
% ==================
r.N.percent = 0.01;
r.N.rad     = 1.0;
r.N.mrad    = 0.001;






