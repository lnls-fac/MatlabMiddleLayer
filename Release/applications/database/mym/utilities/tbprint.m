function tbprint(table,varargin)
% TBPRINT   Show several rows of a MySQL table
% INPUTS  : TABLE - table name, string
% OUTPUTS : None 
% EXAMPLE : tbprint('mytable')
% NOTES   : All rows of TABLE  will be  displayed if their number  is below
%           50; otherwise, 10 first and 10 last rows will be shown. You can
%           change TBPRINT behavior by editing line 16, e.g. adding a LIMIT 
%           clause.
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(1,2, nargin))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
try 
  mym(['select * from ' table]); 
catch
  error(['Table ' table ' not found. Use TBLIST to list available tables.'])
end