function[names] = tblist(varargin)
% TBLIST    List tables in a MySQL database 
% INPUTS  : DBASE - database name, string (optional, current database default) 
% OUTPUTS : NAMES - list of table names, (m x 1) cell array
% EXAMPLE : tblist('project1')       
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(0,1,nargin))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
if nargin 
   dbase  = varargin{1};
else   
   dbase = dbcurr; 
   if isempty(dbcurr)
      error('No database currently selected. Use DBOPEN to open a database.')
   end 
end
try
   names = mym(['show tables in ' dbase]);
catch
   error(['Database ' dbase ' not found. Use DBLIST to list available databases.'])
end
