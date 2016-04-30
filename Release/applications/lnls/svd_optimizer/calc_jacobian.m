function respm = calc_jacobian(x, calc_residue, print)

if ~exist('print','var'),print = true; end;

if print, fprintf('\n\nComputing Jacobian: %2d knobs to go.\n',length(x));end

res = calc_residue(x);
M = zeros(length(res),length(x));
dia = eye(length(x));
for ii = 1:length(x)
    if x(ii) == 0, dx = 0.001; else dx = 1e-4*x(ii);end
    new_x = x + dia(:,ii)*dx/2;
    res_p = calc_residue(new_x);
    
    new_x = x - dia(:,ii)*dx/2;
    res_n = calc_residue(new_x);
    
    M(:,ii) = (res_p - res_n) / dx;
    if print, if ~mod(ii,20), fprintf('%2d \n',ii); else fprintf('%2d, ',ii); end; end
end

if print, fprintf('\n\n'); end;
[U,S,V] = svd(M, 'econ');

respm.M = M;
respm.U = U;
respm.S = diag(S);
respm.V = V;
