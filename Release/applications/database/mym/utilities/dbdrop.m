function dbdrop(varargin)
% DBDROP    Delete a MySQL database 
% INPUTS  : DBNAME - database name, string (optional, current database default)
% OUTPUTS : None
% EXAMPLE : dbdrop('junkdb')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(0,1,nargin))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
if nargin == 0
  if ~isempty(dbcurr)
     mym(['drop database ' dbcurr]) 
  else
     error('No database currently selected. Use DBOPEN to open a database.')
  end    
else
  dbase = varargin{1}; 
  try 
    mym(['drop database ' dbase])
  catch
    error(['Database ' dbase ' could not be deleted. Use DBLIST to list available databases.'])
  end
end   