function calc_beam_parameters(energy)
% function config = calc_beam_parameters(energy)
%
% this function calculates the beam rigidity from its energy
%
% History:
%   2013-05-17: start of new version
%   2011-11-25: init version (Ximenes).

% magnetic rigidity [T.m]
[config.beta config.gamma config.b_rho] = lnls_beta_gamma(energy);
config.energy = energy;

% registra dados em espa?o global acesso de outras rotinas
setappdata(0, 'P_CONFIG', config);