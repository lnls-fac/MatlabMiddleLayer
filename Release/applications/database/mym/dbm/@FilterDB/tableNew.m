function a_f = tableNew(a_f, a_colname)
% CNEW - create a new collection
%   tableNew(f, colname) creates a new collection with name colname

a_f.BasicDB = tableNew(a_f.BasicDB, a_colname, 'TAG', 'FilterDB');