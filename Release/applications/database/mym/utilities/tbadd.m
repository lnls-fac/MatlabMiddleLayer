function tbadd(table,cols,types,varargin)
% TBADD     Create a MySQL table 
% INPUTS  : TABLE  - table name, string
%           COLS   - list of column names, (m x 1) or (1 x m) cell array
%           TYPES  - list of column types, (m x 1) or (1 x m) cell array
%           OVER   - string 'replace' if overwrites are allowed; if  the 
%                    argument is omitted and TABLE already exists, TBADD 
%                    call will trigger an error 
% OUTPUTS : None
% NOTES   : Use DBASE.TABLE syntax to refer to a table not in the current 
%           database 
% EXAMPLE : cols  = {'customer','date','price'};
%           types = {'varchar(30)', 'date', 'double'}
%           tbadd('orders',cols,types,'replace')
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(3,4,nargin))
if nargin == 4 
   if ~strcmpi(varargin{1},'replace')
       error('Overwrites-allowed argument not recognized.')
   else
       overwrite = true;
   end    
else
   overwrite = false;
end   
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
try   %#ok
  exists = false;
  [a,b,c,d,e,f] = mym(['describe ' table]);  %#ok
  exists = true;
end  
if exists
   if overwrite 
      tbdrop(table)
   else   
      error(['Table ' table ' already exists. Use ''replace'' to overwrite, or TBDROP to delete a table.'])
   end    
end
K = length(cols);
if ~iscell(cols) 
   error('COLS must be a cell array.')
end
if ~iscell(types) 
   error('TYPES must be a cell array.')
end
if ~isvector(cols) 
   error('COLS must be a cell vector.')
end
if ~isvector(types) 
   error('TYPES must be a cell vector.')
end
if K ~= length(types)
   error('COLS and TYPES have different lengths.')
end
if any(cellfun('isempty',cols))
   error('COLS contains empty cells.')
end 
if any(cellfun('isempty',types))
   error('TYPES contains empty cells.')
end 
s = ['create table ' table '('];
for k = 1:K
  s = [s cols{k} ' ' types{k} ', '];
end
mym([s(1:length(s)-2) ')'])