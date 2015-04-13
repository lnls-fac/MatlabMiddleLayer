function f = FilteredDB(varargin)

f = class(struct([]), 'FilteredDB', BasicDB(varargin{:}));