function n = nParents(a_f)
% NPARENTS - return an BasicDB object connected to the parent
%   n = nParents(f) return the number of parents.

n = numel(a_f.ctx.parent);