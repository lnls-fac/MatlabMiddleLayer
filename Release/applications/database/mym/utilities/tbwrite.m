function tbwrite(table_tbwrite,vecs_tbwrite,varargin)
% TBWRITE   Write to a MySQL table 
% INPUTS  : TABLE  - table name, string
%           VECS   - list of input vectors,  (m x 1) or (1 x m) cell array  
%           COLS   - list of output columns, (m x 1) or (1 x m) cell array 
%                    (optional, VECS if COLS = {} or omitted)
%           BUFFER - rows per INSERT VALUES command, scalar (optional, 1000 default) 
% OUTPUTS : None
% EXAMPLE : global name dob age 
%           vecs  = {'name','dob','age'};
%           cols  = {'employee_name','employee_dob','employee_age'};
%           types = {'varchar(30)','date','double'};
%           tbadd('staff',cols,types,'replace')
%           name = {'Brad','Angelina'};
%           dob  = {'1963-12-18',''};
%           age  = [42 NaN];
%           tbwrite('staff',vecs,cols)
%           name = [];  % cannot CLEAR the variables 
%           dob  = [];
%           age  = [];
%           tbread('staff',vecs,cols) 
%           name, dob, age
%
% NOTES   : 1. Variables referenced in VECS must  be (n x 1) numeric or cell arrays.
%           2. Variables referenced in VECS must  be declared  global before TBWRITE
%              is invoked.
%           3. VECS elements are case-sensitive. COLS elements are  case-insensitive 
%              if MySQL runs on Windows, but case-sensitive  under Unix. Leading and
%              trailing blanks are removed from strings in both arrays.
%           4. TABLE columns not in COLS will have NULL values in appended rows. 
%           5. Numeric values except dates are converted to strings when  written to
%              MySQL, as follows: s = num2str(x,8). Edit line 135 to  change digits-
%              of-precision parameter.
%           6. Use mym.m to work with BLOB columns.
%           7. Use DBASE.TABLE syntax to refer to tables not in current database. 
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 8/7/06
error(nargchk(2,4,nargin))
if ~mycheck
   error('No MySQL instance detected. Use MYOPEN to connect.')
end
try 
   [a,b,c,d,e,f] = mym(['describe ' table_tbwrite]);    %#ok
catch  
   error(['Table ' table_tbwrite ' not found. Use TBLIST to list available tables.'])
end
if nargin > 2
   string_tbwrite = strtrim(varargin{1});
   if length(string_tbwrite) 
      cols_tbwrite = string_tbwrite;
   else
      cols_tbwrite = vecs_tbwrite;
   end
else
   cols_tbwrite = vecs_tbwrite; 
end
if ~iscell(cols_tbwrite)
   error('COLS must be a cell array.')
end
if ~iscell(vecs_tbwrite) 
   error('VECS must be a cell array.')
end
if ~isvector(cols_tbwrite)
   error('COLS must be a cell vector.')
end
if ~isvector(vecs_tbwrite) 
   error('VECS must be a cell vector.')
end
K_tbwrite = length(cols_tbwrite);
if K_tbwrite ~= length(vecs_tbwrite)
   error('COLS and VECS have different lengths.')
end
if any(cellfun('isempty',cols_tbwrite))
   error('COLS contains empty cells.')
end 
if any(cellfun('isempty',vecs_tbwrite))
   error('VECS contains empty cells.')
end     
if nargin > 3 && ~isempty(varargin{2})
   buff_tbwrite = varargin{2};
   if buff_tbwrite ~= floor(buff_tbwrite) || buff_tbwrite < 1
      error('BUFFER must be a positive integer.')
   end   
else
   buff_tbwrite = 1000;
end
collist_tbwrite = cols_tbwrite{1};
for k_tbwrite = 2:K_tbwrite
    collist_tbwrite = [collist_tbwrite ',' cols_tbwrite{k_tbwrite}];
end
[allcols_tbwrite,alltypes_tbwrite] = tbattr(table_tbwrite);
n_tbwrite = zeros(K_tbwrite,1);
for k_tbwrite = 1:K_tbwrite
    vec_tbwrite = vecs_tbwrite{k_tbwrite};
    par_tbwrite = findstr(vec_tbwrite,'(');
    if par_tbwrite > 0
       vec_reduced_tbwrite = vec_tbwrite(1:par-1);
    else
       vec_reduced_tbwrite = vec_tbwrite; 
    end  
    warning('off','MATLAB:declareGlobalBeforeUse')
    eval(['global ' vec_reduced_tbwrite]);
    if ~exist(vec_reduced_tbwrite,'var')
        cleanup
        error(['Vector ' vec_reduced_tbwrite ' not accessible to TBWRITE. Check if it was declared global.'])
    end
    x_tbwrite = eval(vec_reduced_tbwrite);
    n_tbwrite(k_tbwrite) = length(x_tbwrite);
    if ~(islogical(x_tbwrite) || ...
         isnumeric(x_tbwrite) || ...
            iscell(x_tbwrite))
        cleanup
        error(['Type mismatch. ' vec_tbwrite ' is  not a numeric or cell vector.'])
    end    
    if ~any(strcmpi(allcols_tbwrite,cols_tbwrite{k_tbwrite}))
       cleanup 
       error(['Column ' cols_tbwrite{k_tbwrite} ' not found in table ' table_tbwrite '. Use TBATTR to list available columns.'])
    end
    if iscell(x_tbwrite)
       actual_maxlength_tbwrite = max(cellfun('length',x_tbwrite));
       coltype_tbwrite = alltypes_tbwrite{k_tbwrite};
       par_tbwrite     = findstr(coltype_tbwrite,'char');
       if par_tbwrite
          p1_tbwrite = findstr(coltype_tbwrite,'(') + 1;
          p2_tbwrite = findstr(coltype_tbwrite,')') - 1;
          declared_maxlength_tbwrite = str2double(coltype_tbwrite(p1_tbwrite:p2_tbwrite));
          if declared_maxlength_tbwrite < actual_maxlength_tbwrite 
             cleanup 
             error(['Maximum string length in ' vec_tbwrite ' exceeds declared limit. Use ALTER TABLE to resize the column.'])
          end
       end
    end   
end
if var(n_tbwrite) > 0
   cleanup 
   error('Vectors with different lengths referenced in VECS.')
else
   n_tbwrite = n_tbwrite(1);  
end
flushes_tbwrite= ceil(n_tbwrite/buff_tbwrite);
S_tbwrite = cell(1,K_tbwrite);
mym(['lock tables ' table_tbwrite ' write'])
for flush_tbwrite = 1:flushes_tbwrite
    firstrow_tbwrite = 1 + buff_tbwrite*(flush_tbwrite - 1);
    lastrow_tbwrite  = min(firstrow_tbwrite + buff_tbwrite,n_tbwrite);
    for k_tbwrite = 1:K_tbwrite
        y_tbwrite = eval(vecs_tbwrite{k_tbwrite});
        x_tbwrite = y_tbwrite(firstrow_tbwrite:lastrow_tbwrite);
        x_tbwrite = reshape(x_tbwrite,[],1);
        if isnumeric(x_tbwrite) 
           S_tbwrite{k_tbwrite} = {num2str(x_tbwrite,8)};
        end   
        if iscell(x_tbwrite)
           S_tbwrite{k_tbwrite} = {strcat('''',char(x_tbwrite),'''')};
        end  
    end    
    Z_tbwrite = strcat('(',char(S_tbwrite{1}));
    for k_tbwrite = 2:K_tbwrite
        Z_tbwrite = strcat(Z_tbwrite,',',char(S_tbwrite{k_tbwrite})); 
    end  
    Z_tbwrite = strcat(Z_tbwrite,'),');
    Z_tbwrite = reshape(Z_tbwrite',1,[]);
    Z_tbwrite = strrep(Z_tbwrite,'NaN','NULL');
    Z_tbwrite = strrep(Z_tbwrite,'''''','NULL');
    s_tbwrite = ['insert into ' table_tbwrite '(' collist_tbwrite ') values ' Z_tbwrite];
    s_tbwrite = strtrim(s_tbwrite);
    s_tbwrite = s_tbwrite(1:length(s_tbwrite)-1);
    try
       mym(s_tbwrite)   
    catch
       cleanup 
       error(['Values could not be inserted into table ' table_tbwrite '. Try a smaller value of BUFFER parameter.'])
    end
end


function cleanup
mym('unlock tables')
warning('on','MATLAB:declareGlobalBeforeUse')