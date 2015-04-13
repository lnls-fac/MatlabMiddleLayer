function a_f = tableNew(a_f, a_colname, a_parentImg, a_parentFilter, varargin)

if ~isa(a_parentImg, 'BasicDB')
  error('expect the first parent to be an image database')
end
if ~iscell(a_parentFilter)
  a_parentFilter = {a_parentFilter};
end
for i = 1:numel(a_parentFilter)
  if ~(isa(a_parentFilter{i}, 'FilterDB')||isa(a_parentFilter{i}, 'ParFilterDB'))
    error('expect the second parent to be a filter database')
  end
end

if any(strcmp(varargin, 'TAG'))
  error('tag: cannot be overriden')
end

if any(strcmp(varargin, 'PARENTS'))
  error('parents: cannot be overriden')
end

a_f.BasicDB = tableNew(a_f.BasicDB, a_colname, 'TAG', 'FilteredDB',...
  'PARENTS', a_parentImg, a_parentFilter{:}, varargin{:});