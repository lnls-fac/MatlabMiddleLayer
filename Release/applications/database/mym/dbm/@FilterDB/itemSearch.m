function [id, item] =  itemSearch(a_f, a_tag, varargin)

[id, item] = itemSearch(a_f.BasicDB, a_tag, varargin{:});
if ~isempty(id)
  item = char(item(:)');
  if item(1)=='@'
    item = eval(item);
  else
    item = str2func(item);
  end
end