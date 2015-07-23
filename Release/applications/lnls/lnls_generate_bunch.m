function Rin = lnls_generate_bunch(emitx, emity, sigmae, sigmas,twiss, n_part, cutoff)
%Rin = lnls_generate_bunch(emitx, emity, sigmae, sigmas,twiss, n_part, cutoff)
%
% emitx = horizontal emittance;
% emity = vertical emittance;
% sigmae= energy dispersion;
% sigmas= bunch length;
% twiss = structure with fields: betax,betay,etax,etay,alphax,alphay,etaxl,etayl;
% n_part = number of particles
% cutoff = number of sigmas to cut the distribution (in bunch size, not
% emittance. e.g. if cutoof =3 particles with up to 9*emitx will be included)


% get the twiss parameters;
betx = twiss.betax(1); alpx = twiss.alphax(1);
bety = twiss.betay(1); alpy = twiss.alphay(1);
etax = twiss.etax(1); etpx = twiss.etaxl(1);
etay = twiss.etay(1); etpy = twiss.etayl(1);

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

