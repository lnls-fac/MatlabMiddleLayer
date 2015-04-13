function a_f = tableDrop(a_f, a_colName)
% COLLDROP - delete a collection
%   tableDrop(f, colname) deletes the collection named colname on the
%   BasicDB f.

if a_f.ctx.readonly
  error('read only instance')
end

try
  a_f = tableUse(a_f, a_colName);
catch
  disp(['no collection named ``' a_colName '´´, continuing'])
end
try
  mym(a_f.conInfo.id, 'DROP TABLE {S}', a_colName);
catch
  disp(['no table named ``' a_colName '´´, continuing'])
end
q = 'DELETE FROM _collections  WHERE collection ="{S}"';
mym(a_f.conInfo.id, q, a_colName);
a_f = tableUse(a_f);