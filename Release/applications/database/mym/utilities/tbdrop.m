function tbdrop(table)
% TBDROP    Delete a MySQL table
% INPUTS  : TABLE - table name, string
% OUTPUTS : None
% NOTE    : Use DBASE.TABLE syntax to refer to a table not in the 
%           current database
% EXAMPLE : tbdrop('project1.old_data')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
try 
  mym(['drop table if exists ' table])
catch
  error(['Table ' table ' could not be deleted. Use TBLIST to list available tables.'])
end
   