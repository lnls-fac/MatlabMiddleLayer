function myopen(host,user,pwd)
% MYOPEN    Connect to MySQL 
% INPUTS  : HOST - host name, string
%           USER - user name, string 
%           PWD  - password,  string 
% OUTPUTS : None
% EXAMPLE : myopen('localhost','root','mypwd')
%           myopen('microsoft.com','gates','windows')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
try
   a = mym('open',host,user,pwd);  %#ok
catch
   error('Could not start a MySQL instance. Check login parameters.')
end   