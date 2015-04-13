function tbrename(old,new)
% TBRENAME  Rename a MySQL table
% INPUTS  : OLD - old table name, string
%           NEW - new table name, string
% OUTPUTS : None
% EXAMPLE : dbrename('mytable','mytb')
% NOTES   : The table must reside in current database.
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
if isempty(dbcurr)
   error('No database currently selected. Use DBOPEN to open a database.')
end
if ~isempty(strfind(old,'.')) || ~isempty(strfind(new,'.'))
   error('TBRENAME does not accept DBASE.TABLE syntax.')
end
if ~any(strcmpi(tblist,strtrim(old)))
   error(['Table ' old ' not found in current database. Use TBLIST to list available tables.'])
end
if any(strcmpi(tblist,strtrim(new)))
   error(['Table ' new ' already exists in current database. Use TBDROP to delete a table.'])
end
try 
  mym(['rename table ' old ' to ' new])
catch
  error(['Table ' old ' not renamed. Check if ' new ' is a valid name.'])
end 