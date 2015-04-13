%particle's initial position in relation to the booster's closed orbit:
param.Rin = [0;0.0;0;0;0;0];

%Definition of the bunch to be used:
param.n_part = 1000;
param.cutoff = 5;
param.emitx = 3.8e-9;
param.emity = param.emitx*20/100;
param.sigmae= 9e-4;
param.sigmas= 11.3e-3;

param.number_simu = 20;

%% Definition of Booster's parameters

% Load the Booster lattice;
synchrotron = sirius_bo_lattice;
%carrega maquinas com erros de orbitas:
param.boo.simulate_orbit_errors = true;
% lattice_errors([pwd '/cod_matlab']);
machines = load('/home/fac_files/code/MatlabMiddleLayer/Release/lnls/fac_scripts/sirius/booster/extraction/cod_matlab/CONFIG_machines_cod_corrected.mat');
machines = machines.machine;


% kicker angle
param.boo.kick_ang =1.1e-3;
param.boo.kick_err = 0*5e-3; % tested!
param.boo.seb_leak= 0e-4;


%% Definition of the Transport line parameters

% mode of operation
param.ltba.mode = 'mismatched_pmm';

% Load the transfer line
[transfer_line IniCond] = sirius_ts_lattice(param.ltba.mode);

% Definition of the EXTRACTION SEPTUM's position in relation to the booster:
%                   boo_vac   folga   copper   sep_vac   sep_half_wid
param.ltba.seb_x = (  18    +  0.5  +   3    +  0.5   +   9/2)*1e-3; %position
%if the angle is zero, then the septum and its vacuum chamber are aligned
%with the booster orbit and the exit angle of the incoming beam must be
%achieved by an angle added to the polynomB of the septum
param.ltba.seb_xp = -0.38/180*pi*1;%angle
% septum deflection angle and error (total for both septa)
param.ltba.seb_dang = 1.07e-4; % additional angle of deflection of the particle.
param.ltba.seb_err = 0*7e-4; % tested


% Definition of the THIN SEPTUM's position in relation to the storage ring:
%                   sr_vac   folga   copper   sep_vac   sep_half_wid
% param.ltba.sef_x = -(  12    +  0.5  +   3    +  0.5    +   2)*1e-3; %position
param.ltba.sef_x = -(  12    +  2.5  + 0.5    +   1)*1e-3; %position
%if the angle is zero, then the septum and its vacuum chamber are aligned
%with the booster orbit and the exit angle of the incoming beam must be
%achieved by an angle added to the polynomB of the septum
param.ltba.sef_xp = 0;%angle
% septum deflection angle and error 
param.ltba.sef_dang = -4.05e-3; % additional angle to deflect of the particle.
% param.ltba.sef_dang = 0.45e-3*0;
param.ltba.sef_err  = 0*7e-4; % tested


% THICK SEPTUM's deflection angle, error and leak field 
param.ltba.seg_dang = 0.8e-3; % additional angle to deflect the particle.
% param.ltba.seg_dang = -0.45e-3*0;
param.ltba.seg_err  = 0*7e-4; %tested


%% Definition of the Storage Ring parameters

% Load the sirius lattice;
storage_ring = sirius_si_lattice();

% Simulate injection in the storage ring too?
param.sr.inject = true;

% Injection mode: with four kickers or multipole?
param.sr.mode = 'pmm'; % '4kickers' or 'pmm'
% Number of turns to track the beam after injection
param.sr.nturns = 9;

%leakage field from the thin septum only.
% the leak field will be modeled as a sextupole + a dipole with the dipole:
leak_dip = 1e-6; % times the deflection angle of the septum
% and will have a sextupole component such that the field at
leak_x = 8e-3; % from the center of the chamber will be
leak_field = 5e-6; % of the deflection angle of the septum
param.sr.sef_leak = [leak_dip 0 (leak_field-leak_dip)/leak_x^2 0 ];

% parameters for injection with kickers:
param.sr.kick.nturns = 8.3e-6/518.25*299792458; % half sine pulse width
param.sr.kick.angle  = 6.7e-3; % angle for each kicker
param.sr.kick.pha_err = 0e-4; % phase errors among kickers
param.sr.kick.amp_err = 0e-4; % amplitude errors among kickers
param.sr.kick.deform_err = 0;%2e-5; % a defomation of the shape of the bump
% the deformation error is not included in the simulation of the injected
% beam, only in the perturbation of the stored one.

% parameters for injection with pmm
param.sr.pmm.nturns = 500e-9/518.25*299792458; % pulse duration (# of turn)
% param.sr.pmm.polb = [0,-0.4941*0,1*52]/0.6; %PolynomB of the magnet
polB(2:2:10) = -[-1.565, 757940, -1.29116e10, 7.80222e13, -1.64038e17]/10*(60/100);
param.sr.pmm.polb =polB;
param.sr.pmm.amp_err= 1e-2; %Amplitude error of the magnet

% Do we want to simulate the perturbation in the stored beam?
param.sr.perturb_stored_beam = true;
% number of turns to simulate perturbation after the injection:
param.sr.nturns_pert         = 100; % must be > param.sr.{pmm,kick}.nturns
% septum's half sine pulse width in units of number of turns
%                     per  / circ *   c
param.sr.sef_width = 116e-6/518.396*299792458;

