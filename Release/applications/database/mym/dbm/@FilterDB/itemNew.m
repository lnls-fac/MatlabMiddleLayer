function id = itemNew(a_f, a_item, a_tag)

if ~ischar(a_tag)
  error('tag: expected a string')
end
if ~isa(a_item, 'function_handle')
  error('item: expected a function handler')
end

str_func = func2str(a_item);
[id, fct_handler] = itemSearch(a_f, a_tag);
if ~isempty(id)
  if ~strcmp(func2str(fct_handler), str_func)
    error('tag exists but with a different function')
  else
    disp('tag already exists, do nothing')
  end
else
  id = itemNew(a_f.BasicDB, str_func, a_tag);
end