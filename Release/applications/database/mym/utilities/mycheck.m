function[on] = mycheck
% MYCHECK   Show status of MySQL connection 
% INPUTS  : None
% OUTPUTS : ON, logical, 1 if a connection is open, 0 if not
% EXAMPLE : mycheck
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
if ~mym('status')
   on = true;
else
   on = false;
end   