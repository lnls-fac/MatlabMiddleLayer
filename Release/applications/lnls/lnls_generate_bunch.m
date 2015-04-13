function Rin = lnls_generate_bunch(emitx, emity, sigmae, sigmas,twiss, n_part, cutoff)
%Rin = lnls_generate_bunch(emitx, emity, sigmae, sigmas,twiss, n_part, cutoff)
%
% emitx = horizontal emittance;
% emity = vertical emittance;
% sigmae= energy dispersion;
% sigmas= bunch length;
% twiss = [betax, alphax, betay, alphay, etax, etaxl, etay, etayl];
% n_part = number of particles
% cutoff = number of sigmas to cut the distribution (in bunch size, not
% emittance. e.g. if cutoof =3 particles with up to 9*emitx will be included)


% get the twiss parameters;
betx = twiss(1); alpx = twiss(2);
bety = twiss(3); alpy = twiss(4);
etax = twiss(5); etpx = twiss(6);
etay = twiss(7); etpy = twiss(8);

%generate the longitudinal phase space;
sigmaep = lnls_generate_random_numbers(sigmae, n_part, 'norm', cutoff, 0);
sigmasp = lnls_generate_random_numbers(sigmas, n_part, 'norm', cutoff, 0);

% generate transverse phase space;
emitx = lnls_generate_random_numbers(emitx, n_part,'exponential',cutoff^2,0);
phasx = 2*pi*rand(1, n_part);
emity = lnls_generate_random_numbers(emity, n_part,'exponential',cutoff^2,0);
phasy = 2*pi*rand(1, n_part);
x  = sqrt(emitx*betx).*cos(phasx) + etax*sigmaep;
xp = -sqrt(emitx/betx).*(alpx*cos(phasx) + sin(phasx)) + etpx*sigmaep;
y  = sqrt(emity*bety).*cos(phasy) + etay*sigmaep;
yp = -sqrt(emity/bety).*(alpy*cos(phasy) + sin(phasy)) + etpy*sigmaep;

% return the results:
Rin = [x;xp;y;yp;sigmaep;sigmasp];

