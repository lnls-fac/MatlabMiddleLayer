function respm = ids_calc_response_matrix(the_ring, knobs, residue_function, optionals, print)

if ~exist('print','var'), print = false;end
delta_K = 0.001;

residue = residue_function(the_ring, optionals);
M = zeros(length(residue),length(knobs));
if print, fprintf('number of knobs: %03i\n', length(knobs)); end
for i=1:length(knobs)
    if print, fprintf('%03i ', i); if (mod(i,10) == 0), fprintf('\n'); end; end
    idx = knobs{i};
    K = getcellstruct(the_ring, 'PolynomB', idx, 1, 2);
    
    newK = K + delta_K / 2;
    the_ring_tmp = setcellstruct(the_ring, 'PolynomB', idx, newK, 1, 2);
    residue_p = residue_function(the_ring_tmp, optionals);
    
    newK = K - delta_K / 2;
    the_ring_tmp = setcellstruct(the_ring, 'PolynomB', idx, newK, 1, 2);
    residue_n = residue_function(the_ring_tmp, optionals);
    
    M(:,i) = (residue_p - residue_n) / delta_K;
    
end
if print, fprintf('\n'); end

[U,S,V] = svd(M, 'econ');

respm.M = M;
respm.U = U;
respm.S = diag(S);
respm.V = V;
