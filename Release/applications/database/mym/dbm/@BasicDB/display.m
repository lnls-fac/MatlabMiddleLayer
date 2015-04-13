function display(a_f, varargin)

preamble = [];
if nargin>1
  idx = find(strcmp(varargin, 'PREAMBLE'));
  if ~isempty(idx) 
    preamble = varargin{idx+1};
  end
end

only_id = false;
if nargin>1
  only_id = any(find(strcmp(varargin, 'ONLY_ID')));
end

if ~only_id
  display([preamble 'class         : ' class(a_f)])
  if isempty(a_f)
    display([preamble 'connection ID : disconnected' ])
    return
  end
  display([preamble 'connection ID : ' num2str(a_f.conInfo.id)])
  display([preamble 'current table : ' a_f.ctx.collection])
  display([preamble 'item mYm tag  : ' a_f.ctx.itemRepresentation])
  display([preamble 'read only     : ' num2str(a_f.ctx.readonly)])
  display([preamble '#parents      : ' num2str(a_f.ctx.nParents)])
  fprintf([preamble 'parent ID     :'])
  for i = 1:a_f.ctx.nParents
    display(a_f.ctx.parent{i}, 'PREAMBLE', ' ', 'ONLY_ID')
  end
  fprintf('\n')
else
  if isempty(a_f)
    fprintf([preamble 'disconnected'])
    return
  end
  fprintf([preamble num2str(a_f.conInfo.id)])
  if a_f.ctx.nParents>0
    fprintf('(')
    for i = 1:a_f.ctx.nParents
      display(a_f.ctx.parent{i}, 'PREAMBLE', ' ', 'ONLY_ID')
    end
    fprintf(')')
  end
end


