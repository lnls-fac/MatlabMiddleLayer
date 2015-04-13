function a_f = tableNew(a_f, a_colname, varargin)
% COLLNEW - create a new collection
%   tableNew(f, colname) create a new collection with name colname.
%
%   tableNew(..., 'ITEM_REPRESENTATION', rep) specify the item
%     representation (see mYm for more info).
%
%   tableNew(..., 'TAG', str) tag the collection with str.
%
%   tableNew(..., 'PARENTS', par1, par2, ...) specify that the parent of the
%     collection are par1, par2, etc.

if a_f.ctx.readonly
  error('read only instance')
end

%% item representation
idx = find(strcmp(varargin, 'ITEM_REPRESENTATION'));
if isempty(idx)
  item_rep = '{M}';
else
  if strcmp(varargin{idx+1}, 'STRING')
    item_rep = '{S}';
  elseif strcmp(varargin{idx+1}, 'BINARY')
    item_rep = '{B}';
  elseif strcmp(varargin{idx+1}, 'MATLAB')
    item_rep = '{M}';
  elseif strcmp(varargin{idx+1}, 'FILE')
    item_rep = '{F}';
  else
    item_rep = varargin{idx+1};
  end    
end

parents.coll = {};
parents.schema = {};

idx = find(strcmp(varargin, 'TAG'));
if isempty(idx)
  tag = [];
else
  tag = varargin{idx+1};
end

idx = find(strcmp(varargin, 'PARENTS'));
if ~isempty(idx)
  parents.nParents = 1;
else
  parents.nParents = 0;
end

while true&&parents.nParents>0
  if numel(varargin)<(idx+parents.nParents)||~isa(varargin{idx+parents.nParents}, 'BasicDB')
    if parents.nParents==1
      error('expecting at least one object of type ''BasicDB''')
    end
    break
  end
  parents.class{parents.nParents} = class(varargin{idx+parents.nParents});
  parents.coll{parents.nParents} = varargin{idx+parents.nParents}.ctx.collection ;
  if isempty(parents.coll{parents.nParents})
    error(['parent #' num2str(parents.nParents) ': no collection set']);
  end
  parents.schema{parents.nParents} = varargin{idx+parents.nParents}.conInfo.schema;
  parents.nParents = parents.nParents+1;
end
if parents.nParents>1
  parents.nParents = parents.nParents-1;
end

% create the collection
% table 'a_colnameName' exists?
res = mym(a_f.conInfo.id, 'SHOW TABLES');
if any(cell2mat(regexp(res, a_colname)))
  disp(['the collection ''' a_colname ''' already exists']);
  a_f = tableUse(a_f, a_colname);
  if numel(a_f.ctx.parent)~=parents.nParents
    error(['the existing collection has ' num2str(a_f.ctx.parentnParents) ' parents, expecting ' num2str(parents.nParents)])
  end
  
  for i = 1:parents.nParents
    if ~strcmp(parents.coll{i}, a_f.ctx.parent{i}.ctx.collection)
      error(['collections for parent #' num2str(i) ' differ'])
    end
    if ~strcmp(parents.schema{i}, a_f.ctx.parent{i}.conInfo.schema)
      error(['schemas for parent #' num2str(i) ' differ'])
    end
  end
  return
end
%%
foreign_key = [];
fields_str = [];
for i = 1:parents.nParents
  % create the list
  fields_str = [fields_str 'parent' num2str(i) '_id INTEGER DEFAULT NULL,'];
  foreign_key = [foreign_key ',FOREIGN KEY (parent'  num2str(i) '_id) REFERENCES ' parents.schema{i} '.' parents.coll{i} ' (id) ON DELETE CASCADE'];
end
q = ['CREATE TABLE {S} ('...
  'id INTEGER AUTO_INCREMENT NOT NULL,'...
  fields_str...
  'item LONGBLOB,'...
  'tag CHAR(32) DEFAULT NULL,'...
  'PRIMARY KEY(id)'...
  foreign_key...
  ') ENGINE=' a_f.conInfo.engine...
  ];
mym(a_f.conInfo.id, q, a_colname);
%%
q = 'INSERT INTO _collections (collection,item_rep,parents) VALUES ("{S}","{S}", "{M}")';
mym(a_f.conInfo.id, q, a_colname, item_rep, parents);
if ~isempty(tag)
  q = 'UPDATE _collections SET tag="{S}" WHERE collection="{S}"';
  mym(a_f.conInfo.id, q, tag, a_colname);
end
%% use the new collection
a_f = tableUse(a_f, a_colname);