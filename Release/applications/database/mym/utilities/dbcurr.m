function[dbase] = dbcurr
% DBCURR    Show current MySQL database
% INPUTS  : None
% OUTPUTS : DBASE, string, empty if no database open
% EXAMPLE : currdb = dbcurr;
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.') 
else
   dbase = char(mym('select database()'));
end   
