function yn = tableExist(a_f, a_tableName)
% CLIST - list all collections existing for the tableCurrent connection
%   clist(f) returns the collection names in a cell array.

tables = tableList(a_f);
yn = any(strcmp(tables, a_tableName));