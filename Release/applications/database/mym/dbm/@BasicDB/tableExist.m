function answer = tableExist(a_f, a_colName)
% COLLEXIST - check if a given collection exists
%   tableExist(f, colname) return true or false whether a collection exist
%   or not.

res = mym(a_f.conInfo.id, 'SHOW TABLES FROM {S} LIKE "{S}"', a_f.conInfo.schema, a_colName);
answer = ~isempty(res);