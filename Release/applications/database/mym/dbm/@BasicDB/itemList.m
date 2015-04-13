function [id, items, tags] = itemList(a_f)
% ITEMLIST - list id the identifiers
%   [id, items, tags] = itemList(f) return the elements of the current
%     collection of f.

q = 'SELECT id FROM {S}';
id = mym(a_f.conInfo.id, q, a_f.ctx.collection);
if nargout>=2
  items = itemGet(a_f, id);
end
if nargout>=3
  q = 'SELECT tag FROM {S} WHER id={Si}';
  tags = mym(a_f.conInfo.id, q, a_f.ctx.collection);
end