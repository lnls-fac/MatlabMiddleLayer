function dbadd(dbase)
% DBADD     Create a MySQL database 
% INPUTS  : DBASE - database name, string 
% OUPUTS  : None
% EXAMPLE : dbadd('newdb')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
else
   try 
      mym(['create database ' dbase])
   catch
      error(['Database ' dbase ' could not be created. Check if ' dbase ' already exists.'])
   end
end   