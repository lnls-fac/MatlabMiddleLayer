function tbread(table_tbread,varargin)
% TBREAD    Read from a MySQL table 
% INPUTS  : TABLE - table name, string
%           VECS  - list of output vectors, (m x 1) or (1 x m) cell array 
%                   (optional, COLS converted to lower case if VECS = {} or omitted 
%                   but COLS is specified; names of all TABLE columns, converted to
%                   lower case, if VECS = {} or omitted and COLS = {} or omitted) 
%           COLS  - list of input columns,  (m x 1) or (1 x m) cell array 
%                   (optional, all columns retrieved if COLS = {} or omitted)
%           STR   - string containing a combination of WHERE, ORDER BY, GROUP BY,
%                   HAVING or LIMIT clauses, passed within a SELECT query (optional)
%                   Examples: 'where name = ''John''', 'order by x', 'limit 100'
% OUTPUTS : None
% EXAMPLE : cols = {'customer','date','price'};
%           global customer date price
%           tbread('orders',{},cols,'where date > ''1995-01-31'' and price > 100')
%
%           cols = {'my_numeric','my_char'};
%           vecs = {'x','y'};
%           global x y
%           tbread('xytable',vecs,cols)
%
%           global N
%           N = nan(tbsize('ntable',1),10);
%           vecs = cellstr(strcat('N(:,', int2str((1:10)'), ')'));
%           tbread('ntable',vecs)
%
% NOTES   : 1. Variables referenced in VECS must be declared global before TBREAD is
%              invoked.
%           2. VECS elements are case-sensitive. COLS elements are  case-insensitive 
%              if MySQL runs on Windows, but case-sensitive  under Unix. Leading and
%              trailing blanks are removed from strings in both arrays.
%           3. Use mym.m to work with BLOB columns.
%           4. Use DBASE.TABLE syntax to refer to tables not in current database. 
%           5. If the number of columns to retrieve is small, data can be read more 
%              conveniently with mym.m:
%
%              [customer,date,price] = mym('select customer,date,price from orders')
%
%              [x,y] = mym('select my_numeric, my_char from xytable');
% 
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(1,4,nargin))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
try 
   [a,b,c,d,e,f] = mym(['describe ' table_tbread]);    %#ok
catch  
   error(['Table ' table_tbread ' not found. Use TBLIST to list available tables.'])
end
if nargin > 3
   str_tbread = varargin{3};
else
   str_tbread = '';
end   
allcols_tbread = tbattr(table_tbread); 
if nargin > 2 
   cols_tbread = strtrim(varargin{2});
   if isempty(cols_tbread) | cellfun('isempty',cols_tbread)   %#ok
      cols_tbread = allcols_tbread;
   end
else
   cols_tbread = allcols_tbread; 
end
if nargin > 1
   vecs_tbread = strtrim(varargin{1});
   if isempty(vecs_tbread) | cellfun('isempty',vecs_tbread)   %#ok
      vecs_tbread = lower(allcols_tbread);
   end
else
   vecs_tbread = lower(allcols_tbread);
end
if ~iscell(vecs_tbread) 
   error('VECS must be a cell array.')
end
if ~iscell(cols_tbread)
   error('COLS must be a cell array.')
end
if ~ischar(str_tbread)
    error('STR must be a string.')
end    
if ~isvector(vecs_tbread) 
   error('VECS must be a cell vector.')
end
if ~isvector(cols_tbread) 
   error('COLS must be a cell vector.')
end
K_tbread = length(cols_tbread);
if K_tbread ~= length(vecs_tbread)
   error('COLS and VECS have different lengths.')
end
if any(cellfun('isempty',cols_tbread))
   error('COLS contains empty cells.')
end 
if any(cellfun('isempty',vecs_tbread))
   error('VECS contains empty cells.')
end 
mym(['lock tables ' table_tbread ' write'])
for k_tbread = 1:K_tbread
    col_tbread = cols_tbread{k_tbread};
    if ~any(strcmpi(allcols_tbread,col_tbread))
       error(['Column ' col_tbread ' not found in table ' table_tbread '. Use TBATTR to list available columns.'])
    else
       vec_tbread = vecs_tbread{k_tbread};
       par_tbread = findstr(vec_tbread,'(');
       if par_tbread
          vec_reduced_tbread = vec_tbread(1:par_tbread-1);
       else
          vec_reduced_tbread = vec_tbread; 
       end
       warning('off','MATLAB:declareGlobalBeforeUse')
       try
           eval(['global ' vec_reduced_tbread '; ' vec_tbread ' = mym('' select ' cols_tbread{k_tbread} ' from ' table_tbread ' ' str_tbread ' '');'])
       catch
           cleanup 
           error('Read failed. Check if VECS contains valid variable names.')
       end     
    end    
end  
cleanup

function cleanup
mym('unlock tables')
warning('on','MATLAB:declareGlobalBeforeUse')