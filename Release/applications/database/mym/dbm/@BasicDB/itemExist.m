function answer = itemExist(a_f, a_id)
% ITEMEXIST - test if given items exist
%   itemExist(f, id) return a boolean vector, its elements are true if the
%   identifiers at the corresponding positions in id are present in the
%   database.

q = 'SELECT id FROM {S} WHERE id={Si}';
answer = false(numel(a_id), 1);
for i = 1:numel(a_id)
  res = mym(a_f.conInfo.id, q, a_f.ctx.collection, a_id(i));
  answer(i) = ~isempty(res);
end