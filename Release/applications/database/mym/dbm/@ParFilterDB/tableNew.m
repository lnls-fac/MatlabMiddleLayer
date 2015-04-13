function a_f = tableNew(a_f, a_colname, a_filter)
% CNEW - create a new collection
%   tableNew(f, colname) creates a new collection with name colname

if ~isa(a_filter, 'FilterDB')
  error('parent should be a filter database')
end

a_f.BasicDB = tableNew(a_f.BasicDB, a_colname, 'TAG', 'parFilterDB', 'PARENTS', a_filter);