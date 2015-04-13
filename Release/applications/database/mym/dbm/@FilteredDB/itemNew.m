function id = itemNew(a_f, a_item, a_tag, a_parent, a_fct)

if numel(a_parent)~=nParents(a_f)
  error(['there should have ' num2str(nParents(a_f)) ' parents'])
end
if ~isempty(a_item)
  error('the input ''item'' should be empty')
end

if nargin==4
  fct = @(item, img, varargin)composeFcts(varargin, img);
else
  fct = @(item, img, varargin)a_fct(composeFcts(varargin, img));
end
id = itemNew(a_f.BasicDB, [], a_tag, a_parent, fct);

function a = composeFcts(a_fctHandlers, a_arg)

if ~iscell(a_fctHandlers)
  a = a_fctHandlers(a_arg);
  return
end

a = a_arg;
for i = 1:numel(a_fctHandlers)
  a = a_fctHandlers{i}(a);
end