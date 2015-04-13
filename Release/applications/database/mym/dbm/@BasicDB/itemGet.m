function [items, tags] =  itemGet(a_f, a_id, varargin)
% ITEMGET - get an items
%   iget(f, id) return the items having id for identifier.
%   iget(..., 'REMOVE_CELL') removes cell when only a 1 by 1 cell is
%     returned.

query = 'SELECT item,tag FROM {S} WHERE id={Si}';
items = cell(size(a_id));
tags = cell(size(a_id));
for i = 1:numel(a_id)
  [item_, tag_] = mym(a_f.conInfo.id, query, a_f.ctx.collection, a_id(i));
  if isempty(item_)
    error(['items ' num2str(a_id) ' does not exist'])
  end
  items{i} = item_{1};
  tags{i} = tag_{1};
end
if numel(items)==1&&any(strcmp(varargin, 'REMOVE_CELL'))
  items = items{1};
end