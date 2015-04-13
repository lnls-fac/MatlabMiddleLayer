function [id, item] = itemSearch(a_f, a_tag, a_parentId, a_parentTag)
% ITEMSEARCH - search item
%   [id, item] = itemSearch(f, tag, pid, ptag) search item in the current
%     collection with a given tag, parent ids, and parent tags. Unimportant
%     search criteria are set to [].

if ~isempty(a_tag)
  if ~ischar(a_tag)
    error('tag: expected a string')
  else
    q = 'SELECT id FROM {S} WHERE tag="{S}"';
    id = mym(a_f.conInfo.id, q, a_f.ctx.collection, a_tag);
  end
end

if nargin>=3&&~isempty(a_parentId)
  if numel(a_parentId)~=numel(a_f.ctx.parent)
    error('parents: expected the same numbers')
  end
  q = 'SELECT id FROM {S} WHERE ';
  for i = 1:numel(a_f.ctx.parent)
    q = [q 'parent' num2str(i) '_id=' num2str(a_parentId(i))];
    if i~=numel(a_f.ctx.parent)
      q = [q ' AND '];
    end
  end
  id_ = mym(a_f.conInfo.id, q, a_f.ctx.collection);
  if exist('id', 'var')
    id = intersect(id_, id);
  else
    id = id_;
  end
end

if nargin>=4&&~isempty(a_parentTag)
  if ~ischar(a_parentTag)
    error('parent tag: expected a string')
  end
  for i = 1:numel(a_f.ctx.parent)
    id__ = itemSearch(a_f.ctx.parent{i}, a_parentTag);
    if i>1
      id_ = intersect(id__, id_);
    else
      id_ = id__;
    end
    if isempty(id_)
      break
    end
  end
  if exist('id', 'var')
    id = intersect(id_, id);
  else
    id = id_;
  end
end

if nargout==2
  q = 'SELECT item FROM {S} WHERE id={Si}';
  item = cell(numel(id), 1);
  for i = 1:numel(id)
    item(i) = mym(a_f.conInfo.id, q, a_f.ctx.collection, id(i));
  end
end
