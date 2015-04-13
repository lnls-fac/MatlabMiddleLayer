function y = lnls_meansqr(x,dim)
%   For vectors, Y = lnls_meansqr(X) returns the mean square of the values in X.  For
%   matrices, Y is a row vector containing the mean square of each column of
%   X.  For N-D arrays, lnls_meansqr operates along the first non-singleton
%   dimension of X.
%
%   VAR normalizes Y by N-1 if N>1, where N is the sample size.  This is
%   an unbiased estimator of the variance of the population from which X is
%   drawn, as long as X consists of independent, identically distributed
%   samples. For N=1, Y is normalized by N. 
%
%   Y = lnls_meansquare(X,DIM) takes the mean square along the dimension DIM of X. 

if isinteger(x) 
    error(message('MATLAB:var:integerClass'));
end

if nargin < 2
    % The output size for [] is a special case when DIM is not given.
    if isequal(x,[]), y = NaN(class(x)); return; end

    % Figure out which dimension sum will work along.
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end
n = size(x,dim);
y = sum(abs(x).^2, dim) ./ n; % abs guarantees a real result


