function [items, tags] = itemGet(a_f, a_id)
% IGET - get an items
%   iget(f, id) return the items having id for identifier.
%   iget(..., 'REMOVE_CELL') removes cell when only a 1 by 1 cell is
%     returned.

items = cell(numel(a_id), 1);
tags = items;
for i = 1:numel(a_id)
  [item, tags{i}] = itemGet(a_f.BasicDB, a_id(i));
  item = char(item{1}(:)');
  if item(1)=='@'
    items{i} = eval(item);
  else
    items{i} = str2func(item);
  end
end