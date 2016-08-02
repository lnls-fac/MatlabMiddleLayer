function [tune ampl] = lnls_calcnaff(X, Xl, n)
% INPUT:
%
%  X  - matrix such that each line represents a set of data
%  Xl - matrix such that each line represents a set of data
%  n  - number of main frequencies - 2 {Default}
%
%  OUTPUT
%  tune =  colunm vector with the fractionary part of the tune
%  ampl =  amplitudes associated with the tunes
%
%  NOTES
%  1. This function uses calcnaff to calculate the tune. It considers only the n
%     main frequencies returned and pick those that are different from zero;
%  2. Mimimum size of first dimension of X and Xl is 67;
%  3. Size of first dimension of X and Xl minus one has to be a multiple of 6
%     for internal optimization reason. Example: ((size(X,1) == 1027) - 1) is divisible by 6.

if ~exist('n','var'), n = 1; end

ndata = size(X,1);

tune = zeros(ndata,n);
ampl = zeros(ndata,n);

for ii = 1:ndata
    [nu a_nu] = calcnaff(X(ii,:) + 1i*Xl(ii,:), false, 1, n+1);
    nu = abs(nu);

    if numel(nu) > 1
        a_nu = a_nu(nu > 1e-4);
        nu   =   nu(nu > 1e-4);
    end

    if numel(nu)>n
        nu   =   nu(1:n);
        a_nu = a_nu(1:n);
    end

    tune(ii,:) = [nu'/2/pi zeros(1,n-length(  nu))];
    ampl(ii,:) = [a_nu'    zeros(1,n-length(a_nu))];

end
