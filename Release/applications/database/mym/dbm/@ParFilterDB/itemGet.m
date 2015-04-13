function items = itemGet(a_f, a_id)
% IGET - get an items
%   iget(f, id) return the items having id for identifier.
%   iget(..., 'REMOVE_CELL') removes cell when only a 1 by 1 cell is
%     returned.

items = cell(numel(a_id), 1);
for i = 1:numel(a_id)
  par = itemGet(a_f.BasicDB, a_id(i));
  par = par{1};
  [dummy, hf] = itemParent(a_f, a_id(i));
  hf = hf{1};
  items{i} = @(x)hf(x, par);
end