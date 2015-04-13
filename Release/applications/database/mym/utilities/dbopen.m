function dbopen(dbase)
% DBOPEN    Open a MySQL database 
% INPUTS  : DBASE - database name, string
% OUTPUTS : None
% EXAMPLE : dbopen('mydb')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
else
   try 
      a = mym(['use ' dbase]);   %#ok
   catch
      error(['Database ' dbase ' not found. Use DBLIST to list available databases.'])
   end 
end   