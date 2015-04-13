function [id, items] = itemParent(a_f, a_id)
% ITEMPARENT - give the parent of a specified item
%   [pids, items] = itemParent(f, id) give the id of the parent of id (and
%   optionally return the actual items).

id = zeros(numel(a_id), a_f.ctx.nParents);
q = 'SELECT parent{Si}_id FROM {S} WHERE id={Si}';
for i = 1:numel(a_id)
  for j = 1:a_f.ctx.nParents
    id(i, j) = mym(a_f.conInfo.id, q, j, a_f.ctx.collection, a_id(i));
  end
end

if nargout==2
  items = cell(numel(a_id), numel(a_f.ctx.nParents));
  for i = 1:numel(a_id)
    for j = 1:a_f.ctx.nParents
      items(i, j) = itemGet(a_f.ctx.parent{j}, id(i, j));
    end
  end
end