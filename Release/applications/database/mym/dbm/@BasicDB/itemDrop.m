function itemDrop(a_f, a_id)
% ITEMDROP - drop a given item
%   itemDrop(f, id) drops the items having for identifiers the elements of
%     id. 


if a_f.ctx.readonly
  error('read only instance')
end

q = 'DELETE FROM {S} WHERE id ={Si}';
for i = 1:numel(a_id)
  mym(a_f.conInfo.id, q, a_f.ctx.collection, a_id(i));
end