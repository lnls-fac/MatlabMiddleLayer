function [tune ampl] = lnls_calcnaff(X, Xl, n)    
% INPUT:
%
%  X  - matrix such that each line represents a set of data
%  Xl - matrix such that each line represents a set of data
%  n - number of main frequencies - 2 {Default}
%
%  OUTPUT
%  tune =  colunm vector with the fractionary part of the tune
%  ampl =  amplitudes associated with the tunes
%
%  NOTES
%  1. This function uses calcnaff to calculate the tune. It considers only
%  the two main frequencies returned and pick the one that is different from
%  zero with the maximum amplitude;
%  2. Mimimum number of turn is 64 (66)
%  3. Number of turn has to be a multiple of 6 for internal optimization
%  reason and just above a power of 2. Example 1026 is divived by 6 and
%  above 1024 = pow2(10) -> In general, numbers of the form: pow2(2k)+2 or
%  pow2(2k+1)+4, for any integer k.

if ~exist('n','var'), n = 1; end

ndata = size(X,1);

tune = zeros(ndata,n);
ampl = zeros(ndata,n);

for ii = 1:ndata
    [nu a_nu] = calcnaff(X(ii,:),Xl(ii,:),1,n+1);
    nu = abs(nu);
    
    if numel(nu) > 1
        a_nu = a_nu(nu > 1e-4);
        nu = nu(nu > 1e-4);
    end
    
    if numel(nu)>n
        nu = nu(1:n);
        a_nu = a_nu(1:n);
    end
    
    tune(ii,:) = [nu'/2/pi zeros(1,n-length(nu))];
    ampl(ii,:) = [a_nu' zeros(1,n-length(a_nu))];
    
end
