function collections = tableList(a_f)
% CLIST - list all collections existing for the tableCurrent connection
%   clist(f) returns the collection names in a cell array.

[collections, tags] = tableList(a_f.BasicDB);
collections(~strcmp(tags, 'parFilterDB')) = [];