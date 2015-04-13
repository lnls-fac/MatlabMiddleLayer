function values = getcellstruct(CELLARRAY,field,index,varargin)
%GETCELLSTRUCT retrieves the field values MATLAB cell array of structures 
%
% VALUES = GETCELLSTRUCT(CELLARRAY,'field',INDEX,M,N)
%
% VALUES = GETCELLSTRUCT(CELLARRAY,'field',INDEX,M) can be used 
%   for row vectors. For column vectors use 
% VALUES = GETCELLSTRUCT(CELLARRAY,'field',INDEX,1,M) instead
%
% VALUES = GETCELLSTRUCT(CELLARRAY,'field',INDEX) is the same as 
%   GETCELLSTRUCT(CELLARRAY,'field',index,1,1) if the field data
%   is a scalar. If the field data is not a scalar, then
% 
% VALUES = GETCELLSTRUCT(CELLARRAY,'field',INDEX) is a MATLAB cell array
% 	 of strings or matrices if specified fields contain strings or matrices.


% See also SETCELLSTRUCT FINDCELLS 
if(~iscell(CELLARRAY) || ~isstruct(CELLARRAY{1}) || isempty(CELLARRAY))
   error('The first argument must be a non-empty cell array of structures') 
end
% Chechk if the second argument is a string
if(~ischar(field))
   error('The second argument ''field'' must be a character string')
end

switch nargin
   case 5,
      M = varargin{1};
      N = varargin{2}; 
   case 4,
      M = 1;
      N = varargin{1};
   case 3,
      M = nan;
      N = nan;
   otherwise 
      error('Incorrect number of inputs');
end % switch


NV = length(index);

if isnumeric(CELLARRAY{index(1,1)}.(field))
    if ~isnan(M)
        values = zeros(NV,1);
        for I = 1:NV
            values(I) = CELLARRAY{index(I)}.(field)(M,N);
        end
    else
        if length(CELLARRAY{index(1,1)}.(field)(:))==1
            values = zeros(NV,1);
            for I = 1:NV
                values(I) = CELLARRAY{index(I)}.(field);
            end
        else
            values = cell(NV,1);
            for I = 1:NV
                values{I} = CELLARRAY{index(I)}.(field);
            end
        end
    end
elseif ischar(CELLARRAY{index(1,1)}.(field))
    values = cell(NV,1);
    for I = 1:NV
        values{I} = CELLARRAY{index(I)}.(field);
    end
else
    error('The field data must be numeric or character array')
end



