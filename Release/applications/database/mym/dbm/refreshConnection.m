function refreshConnection(a_obj, varargin)
% REFRESHCONNECTION - refresh mySQL connection
%   this is a helper function for the class BasicDB, and should not be called
%   separatly.
% See also BasicDB

if isa(a_obj, 'BasicDB')
  mym(a_obj.conInfo.id, 'SHOW DATABASES');
  return
end

try
  % refresh id
  mym(varargin{2}, 'SHOW DATABASES');
catch
  % specified id does not correspond to a valid connection
  % -> stop/delete/clear timer
  stop(a_obj)
  name = get(a_obj, 'Name');
  delete(a_obj);
  clear(name);
end