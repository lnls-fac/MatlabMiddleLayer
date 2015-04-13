function id = itemNew(a_f, a_item, a_tag, a_parent)

if ~isempty(a_tag)
  error('tag: should be empty')
end

if ~ischar(a_parent)
  if ~isinteger(a_parent)||~numel(a_parent)==1
    error('parent: should be an integer scalar')
  end
  id_parent = a_parent;
else
  id_parent = itemSearch(tableParent(a_f, 1), a_parent);
  if isempty(id_parent)
    error('parent: unknow')
  end
end

if isempty(a_item)
  hash_value = hash(0, 'MD5');
else
  hash_value = hash(a_item, 'MD5');
end

[id, item] = itemSearch(a_f.BasicDB, hash_value, id_parent);
already_exist = false;
for i = 1:numel(item)
  if all(item{i}(:)==a_item(:))
    id = id(i);
    already_exist = true;
    break
  end
end
if isempty(id)||~already_exist
  id = itemNew(a_f.BasicDB, a_item, hash_value, id_parent);
end