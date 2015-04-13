function[varargout] = tbattr(table)
% TBATTR    Show structure of a MySQL table
% INPUTS  : TABLE - table name, string
% OUTPUTS : COLS  - list of column names, (m x 1) cell array 
%           TYPES - list of columns types, (m x 1) cell array  (optional) 
% NOTES   : Use DBASE.TABLE syntax to refer to a table not in the current 
%           database 
% EXAMPLE : [cols,types] = tbattr('orders')
%           tbattr('project5.data') 
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargoutchk(0,2,nargout))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
try 
  [a,b,c,d,e,f] = mym(['describe ' table]);  %#ok
catch
  error(['Table ' table ' not found. Use DBLIST and TBLIST to list available databases and tables.'])
end
varargout{1} = a;  
if nargout == 2
    x = a;
    for k = 1:length(a)
        x{k} = char(cell2mat(b(k))');
    end 
    varargout{2} = x;  
end  
  