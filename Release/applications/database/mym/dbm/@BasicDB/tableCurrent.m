function current = tableCurrent(a_f)
% COLLCURRENT - return the current collection
%   collcurrent(f) return the current collection on the BasicDB f.

current = a_f.ctx.collection;