function createBasicDB_(a_f)

% temporarily connect the database
cid = mym(-1, 'open', a_f.conInfo.server, a_f.conInfo.user, a_f.conInfo.pass);
% verify that the correct schemas exists, and create them accordingly
schemas = mym(cid, 'SHOW DATABASES');
if ~any(strcmp(schemas, a_f.conInfo.schema))
    res = mym(cid, ['CREATE DATABASE ' a_f.conInfo.schema]);
    disp(['created schema: ' a_f.conInfo.schema]);
end
% create replica operators table if it does not exist exist yet
mym(cid, 'use', a_f.conInfo.schema);
all_tables = mym(cid, 'SHOW TABLES');
% create the list table if it does not exist yet
if ~any(strcmp(all_tables, '_collections'))
  % create 'lists'
  query = ['CREATE TABLE _collections ('...
     'collection CHAR(32) NOT NULL,'...
     'item_rep CHAR(16) NOT NULL,'...
     'tag char(32) DEFAULT NULL,'...
     'parents LONGBLOB DEFAULT NULL,'...
     'PRIMARY KEY(collection)'...
     ')'];
  res = mym(cid, query);
  disp('created collection list: _collections')
end
% release the temporary connection
mym(cid, 'close');