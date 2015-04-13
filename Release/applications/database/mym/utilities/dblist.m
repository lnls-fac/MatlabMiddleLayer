function[names] = dblist
% DBLIST    List available MySQL databases 
% INPUTS  : None
% OUTPUTS : NAMES - list of database names, (m x 1) cell array
% EXAMPLE : dblist
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 7/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
else
   names = mym('show databases');
end   
