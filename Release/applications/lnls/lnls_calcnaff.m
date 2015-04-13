function tune = lnls_calcnaff(X, Xl)    
% INPUT:
%
%  X  = matrix such that each line represents a set of data
%  Xl = matrix such that each line represents a set of data
%
%  OUTPUT
%  tune =  colunm vector with the fractionary part of the tune
%
%  NOTES
%  1. This function uses calcnaff to calculate the tune. It considers only
%  the two main frequncies returned and pick the one that is different from
%  zero with the maximum amplitude;
%  1. Mimimum number of turn is 64 (66)
%  2. Number of turn has to be a multiple of 6 for internal optimization
%  reason and just above a power of 2. Example 1026 is divived by 6 and
%  above 1024 = pow2(10)


ndata = size(X,1);

tune = zeros(ndata,1);
for ii = 1:ndata
    val = abs(calcnaff(X(ii,:),Xl(ii,:),1,2));
    if val(1)<1e-4
        tune(ii) = val(2)/2/pi;
    else
        tune(ii) = val(1)/2/pi;
    end
end
