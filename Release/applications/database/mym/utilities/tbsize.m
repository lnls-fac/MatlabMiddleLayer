function[size] = tbsize(table,varargin)
% TBSIZE    Show size of a MySQL table 
% INPUTS  : TABLE - table name, string
%           DIM   - dimension, 1 or 2 (optional, both rows and columns
%                   counted by default
% OUTPUTS : SIZE  - dimension length(s), scalar or (1 x 2) vector
% EXAMPLE : [r,c] = tbsize('mytb')
% NOTES   : Use DBASE.TABLE syntax to refer to a table not in the current 
%           database 
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(1,2,nargin))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
if nargin > 1
   d = varargin{1};
   if ~isscalar(d) || ~(d == 1 || d == 2) 
      error('Invalid DIM argument.')
   end
else
   d = 3; 
end
try 
   switch d
   case 1, size = getrows(table); 
   case 2, size = getcols(table); 
   case 3, size = [getrows(table) getcols(table)];
   end    
catch
  error(['Table ' table ' not found. Use TBLIST to list available tables.'])
end
 

function[r] = getrows(table)
r = mym(['select count(*) from ' table]');

function[c] = getcols(table)
[a,b,c,d,e,f] = mym(['describe ' table]);    %#ok
c = length(a);