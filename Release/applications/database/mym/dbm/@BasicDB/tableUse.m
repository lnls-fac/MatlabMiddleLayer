function a_f = tableUse(a_f, a_colName)
% COLLUSE - use a given collection
%   tableUse(f, colname) uses the collection having for name colname.

% control that the collection exists
if nargin<2
  a_f.ctx.collection = [];
  return
end
  
res = mym(a_f.conInfo.id, 'SHOW TABLES');
if ~any(cell2mat(regexp(res, a_colName)))
  error('no collection of the specified name exists');
end
% close previous parents
for i = 1:a_f.ctx.nParents
  if isa(a_f.ctx.parent{i}, 'BasicDB')
    a_f.ctx.parent{i} = close(a_f.ctx.parent{i});
  end
end
% use the specified collection
q = 'SELECT item_rep,parents FROM _collections WHERE collection = "{S}"';
[a_f.ctx.item_rep, parents_] = mym(a_f.conInfo.id, q, a_colName);
a_f.ctx.item_rep = a_f.ctx.item_rep{1};
parents_ = parents_{1};
if isempty(parents_)
  a_f.ctx.nParents = 0;
  return
end
a_f.ctx.nParents = parents_.nParents;
for i = 1:a_f.ctx.nParents
  parent_class = eval(['@' parents_.class{i}]);
  a_f.ctx.parent{i} = parent_class('USER', a_f.conInfo.user, 'PASSWORD', a_f.conInfo.pass,...
    'SCHEMA', parents_.schema{i}, 'SERVER', a_f.conInfo.server);
  a_f.ctx.parent{i} = tableUse(a_f.ctx.parent{i}, parents_.coll{i});
end
a_f.ctx.collection = a_colName;