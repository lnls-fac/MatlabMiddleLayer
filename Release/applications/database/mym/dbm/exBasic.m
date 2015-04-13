
con1 = BasicDB('USER', 'root', 'PASSWORD', 'sql123', 'SCHEMA', 'test');
con1 = tableNew(con1, 'collection_1', 'TAG', 'a new tag...');
NUM_MAT = 100;
MAX_SIZE = 100;
id1 = zeros(NUM_MAT, 1);
for i = 1:NUM_MAT
  id1(i) = itemNew(con1, rand(ceil(rand*MAX_SIZE), ceil(rand*MAX_SIZE)));
end
items = itemGet(con1, id1(1:ceil(rand*NUM_MAT)));

%% test parent
% one parent
con2 = BasicDB('USER', 'root', 'PASSWORD', 'sql123', 'SCHEMA', 'test');
con2 = tableNew(con2, 'collection_2', 'PARENTS', con1);
id2 = zeros(NUM_MAT, 1);
tags = {'test 1', 'test 2', 'test 3', 'grrr'};
for i = 1:NUM_MAT
  id2(i) = itemNew(con2, rand(ceil(rand*MAX_SIZE), ceil(rand*MAX_SIZE)), tags{ceil(rand*numel(tags))}, id1(i));
end
[id_tag, item2] = itemSearch(con2, tags{1});

% two parent
con3 = BasicDB('USER', 'root', 'PASSWORD', 'sql123', 'SCHEMA', 'test');
con3 = tableNew(con3, 'collection_3', 'PARENTS', con1, con2);
id3 = zeros(NUM_MAT, 1);
for i = 1:NUM_MAT
  id3(i) = itemNew(con3, rand(ceil(rand*MAX_SIZE), ceil(rand*MAX_SIZE)), [], [id1(i) id2(end-i+1)], []);
end
parent_id = itemParent(con3, id3(NUM_MAT-1));
item3 = itemGet(con3, id3(NUM_MAT-1));
id_ = itemSearch(con3, [], parent_id(1, :));

%% quite nicely
save all
clear all
load all
con3
con3 = tableDrop(con3, 'collection_3');
con3 = close(con3);
con2 = tableDrop(con2, 'collection_2');
con2 = close(con2);
con1 = tableDrop(con1, 'collection_1');
con1 = close(con1);
delete all.mat

