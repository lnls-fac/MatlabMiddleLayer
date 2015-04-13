function [collections, tag] = tableList(a_f)
% COLLLIST - return all tables existing for the current connection
%   [c, t] = tableList(f) returns the collection names c in a cell array, as
%     well as any existing tags t.

[collections, tag] = mym(a_f.conInfo.id, 'SELECT collection,tag FROM _collections');