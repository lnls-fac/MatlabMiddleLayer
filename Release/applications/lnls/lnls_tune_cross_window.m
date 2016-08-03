function ind = lnls_tune_cross_window(tune,intrv,window)
% ind = lnls_tune_cross_window(tune,intrv,window)
%  Function lnls_tune_cross_window finds the first index for which the tune
%  leaves a given window.
%
%  INPUTS:
%   tune          = vector containing the x tune in the first column and
%                   the y tune in the second column;
%   intrv         = 2x2 matrix, where the first row defines the limits for
%                   the x tune and the second row defines the limits for
%                   the y tune;
%	window (opt.) = the window for which the tune must be inside. It is a
%                   matrix of the form [A|B], where A has an arbitrary
%                   number of rows and 2 columns, B is a column vector.
%                   The set that defines the window is given by
%                   {x in R^2 | A*x < B}. In this case, the input intrv
%                   is IGNORED.
%  OUTPUT:
%	ind   = boolean vector indicating if the i-th tune is outside the
%           window.
%
%  EXAMPLE 1:
%
%        intrv = [1 2],      tune(i,:) = [tunex tuney].
%                [4 5]
%
%   Then, the algorithm detects when 1 < tunex < 2 or 4 < tuney < 5 is not
%   satisfied.
%
%  EXAMPLE 2:
%
%                 [-1  0 | -2]
%        window = [ 1 -1 |  0],      tune(i,:) = [tunex tuney].
%                 [ 0  1 |  3]
%                    A     B
%
%   Then, the algorithm detects when A*tune(i,:)' > B, i.e, it detects when
%   2 < tunex < tuney < 3 is not satisfied.

if ~exist('window','var')
    window = [-1  0 -intrv(1,1);
               1  0  intrv(1,2);
               0 -1 -intrv(2,1);
               0  1  intrv(2,2)];
end

A = window(:,[1,2]);
B = window(:,3);

ind = any(A*tune' > repmat(B,1,size(tune,1)),1);

end

% function window = calc_window(ring, symmetry)
% 
% pos = 0.0;
% offset = [0;0;0;0;0;0];
% n = 7;
% nturns = 2*(2^n + 6 - mod(2^n,6)) - 1;
% 
% offset([2,4]) = offset([2,4]) + 1e-6;
% 
% spos = findspos(ring,1:length(ring));
% [~,point] = min(abs(pos-spos));
% ring = ring([point:end,1:point-1]);
% 
% Rin = offset;
% Rou = [Rin, ringpass(ring,Rin,nturns)];
% 
% x0  = reshape(Rou(1,:),[],nturns+1); % +1, because of initial condition
% xl = reshape(Rou(2,:),[],nturns+1);
% y0  = reshape(Rou(3,:),[],nturns+1);
% yl = reshape(Rou(4,:),[],nturns+1);
% 
% tunex = lnls_calcnaff(x0, xl);
% tuney = lnls_calcnaff(y0, yl);
% 
% side = 0.5/symmetry;
% margem = 5e-3/symmetry;
% 
% kx = floor(tunex/side);
% ky = floor(tuney/side);
% 
% window = [-1  0 -kx*side-margem;...
%            0 -1 -ky*side-margem;...
%            1  0 (kx+1)*side-margem;...
%            0  1 (ky+1)*side-margem];
