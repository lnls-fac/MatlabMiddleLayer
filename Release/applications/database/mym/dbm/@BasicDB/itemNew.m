function id = itemNew(a_f, a_item, a_tag, a_parents, a_fct)
% ITEMNEW - add a new item
%  itemNew(f, item, [tag, pid, fct]) adds the new item 'item' to the
%   collection. Optionally, a tag can be specified. If the tabel as
%   parents, the parent ids must be given. Finally, a function can be given
%   such that the item stored in the db is given by ftc(item, parent1,
%   parent2, ...).
%
%  id = itemNew(...) returns the new item id.

if a_f.ctx.readonly
  error('read only instance')
end

if nargin<5||isempty(a_fct)
  a_fct = @(x,varargin)x;
elseif ~isa(a_fct, 'function_handle')
  error('expected a function handle or an empty input')
end

if nargin<4
  a_parents = [];
end

if numel(a_parents)~=a_f.ctx.nParents
  error(['expected ' num2str(a_f.ctx.nParents) ' parent(s)'])
end

parent = cell(a_f.ctx.nParents, 1);
for i = 1:a_f.ctx.nParents
  parent(i) = itemGet(a_f.ctx.parent{i}, a_parents(i));
end
item = a_fct(a_item, parent{:});

q = ['INSERT INTO {S} (item) VALUES ("' a_f.ctx.item_rep '")'];
mym(a_f.conInfo.id, q, a_f.ctx.collection, item);
q = 'SELECT id FROM {S} WHERE id=LAST_INSERT_ID()';
id = mym(a_f.conInfo.id, q, a_f.ctx.collection);
q = 'UPDATE {S} SET parent{Si}_id={Si} WHERE id={Si}';
for i = 1:a_f.ctx.nParents
  mym(a_f.conInfo.id, q, a_f.ctx.collection, i, a_parents(i), id);
end
if nargin>=3&&~isempty(a_tag)
  if ~ischar(a_tag)
    error('expected a string')
  end
  q = 'UPDATE {S} SET tag="{S}" WHERE id={Si}';
  mym(a_f.conInfo.id, q, a_f.ctx.collection, a_tag, id);
end
