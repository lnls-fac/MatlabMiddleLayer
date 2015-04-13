function f = BasicDB(varargin)
% BASICDB - create a basic database
%   BasicDB('USER', user, 'PASSWORD', password, 'SCHEMA', schema) connects
%     to the database on localhost.'schema' using user name 'user',
%     password 'password'. The user name and password are loaded into
%     private members of the class instance; if for security reason this is
%     to be avoided use the switch 'SECURE' (parented database cannot be
%     used). 
%
%   BasicDB(..., 'SERVER', server) works as above but on the server
%   `server´.
%
%   BasicDB(..., 'ENGINE', engine) works as above but the tables are
%   created using the engine 'engine' (should be one of 'MyISAM', 'HEAP',
%   'MERGE', 'InnoDB', 'BDB', 'NDBCluster').
%
%   BasicDB(db) use the same connection information as these used in db
%   (an instance of a BasicDB class).

%% connection information
if numel(varargin)==1&&isa(varargin{1}, 'BasicDB')
  f.conInfo = varargin{1}.conInfo;
else
  % get server
  idx = find(strcmp(varargin, 'SERVER'));
  if ~isempty(idx)
    f.conInfo.server = varargin{idx+1};
  else
    f.conInfo.server = 'localhost';
  end
  % get user
  idx = find(strcmp(varargin, 'USER'));
  if ~isempty(idx)
    f.conInfo.user = varargin{idx+1};
  else
    error('username: none provided')
  end
  % get password
  idx = find(strcmp(varargin, 'PASSWORD'));
  if ~isempty(idx)
    f.conInfo.pass = varargin{idx+1};
  else
    error('password: none provided')
  end
  % get schema
  idx = find(strcmp(varargin, 'SCHEMA'));
  if ~isempty(idx)
    f.conInfo.schema = varargin{idx+1};
  else
    error('schema: none provided')
  end
  % get engine
  idx = find(strcmp(varargin, 'ENGINE'));
  if ~isempty(idx)
    f.conInfo.engine = varargin{idx+1};
    if any(strcmp(f.conInfo.engine, {'MyISAM', 'HEAP', 'MERGE', 'InnoDB', 'BDB', 'NDBCluster'}))
      error('engine: unknown')
    end
  else
    f.conInfo.engine = 'InnoDB';
  end
  % secure?
  if ~any(strcmp(varargin, 'SECURE'))
    f.conInfo.secure = false;
  else
    f.conInfo.secure = true;
  end
end
% connection id
f.conInfo.id = 0;
%% current context
f.ctx.collection = [];
f.ctx.nParents = 0;
f.ctx.itemRepresentation = [];
f.ctx.parent = [];
f.ctx.readonly = false;
%% timer (to refresh connection from time to time)
f.timer = [];
%% create the imageDB class
f = class(f, 'BasicDB');
% create schema and allLists table, if needed
createBasicDB_(f);
%% connect to the MySQL Server
try
  f.conInfo.id = mym(-1, 'open', f.conInfo.server, f.conInfo.user, f.conInfo.pass);
  mym(f.conInfo.id, 'use', f.conInfo.schema);
catch
  error(['Impossible to connect to ' f.conInfo.schema ' database on ' f.conInfo.server]);
end
%% to refresh connection from time to time
f.timer = timer('TimerFcn', {@refreshConnection, f.conInfo.id}, 'Period', 300.0, 'ExecutionMode', 'fixedRate');
start(f.timer);
%% clear user name and password
if f.conInfo.secure
  f.conInfo.user = [];
  f.conInfo.pass = [];
end