function varargout = mysql(varargin)
%MYSQL - Just an aliase to mym

if nargout == 0
    mym(varargin{:});
elseif nargout == 1
    varargout{1} = mym(varargin{:});
elseif nargout == 2
   [varargout{1}, varargout{2}] = mym(varargin{:});
elseif nargout == 3
   [varargout{1}, varargout{2}, varargout{3}] = mym(varargin{:});
elseif nargout == 4
   [varargout{1}, varargout{2}, varargout{3}, varargout{4}] = mym(varargin{:});
else
    error('Outputs not handled properly, use mym directly.');
end