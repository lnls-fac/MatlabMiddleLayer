function dbrename(oldname,newname)
% DBRENAME  Rename a MySQL database
% INPUTS  : OLDNAME - old database name, string
%           NEWNAME - new database name, string
% OUTPUTS : None
% NOTES   : Untested! Will not work with MySQL versions prior to 5.1.7
% EXAMPLE : dbrename('mydatabase','mydb')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
oldname = strtrim(oldname);
if ~any(strcmpi(dblist,oldname))
   error(['Database ' oldname ' not found. Use DBLIST to list available databases.'])
end
newname = strtrim(newname);
if any(strcmpi(dblist,newname))
   error(['Database ' newname ' already exists. Use DBDROP to delete a database.'])
end
try 
  mym(['rename database ' oldname ' to ' newname])
catch
  error(['Database ' oldname ' not renamed. Check if ' newname ' is  a valid name.'])
end 