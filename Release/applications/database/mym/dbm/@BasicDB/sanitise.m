function sanitise(a_f)
% SANITISE - some cleaning
%   sanitise(f)

if a_f.ctx.readonly
  error('read only instance')
end

all_tables = mym(a_f.conInfo.id, 'SHOW TABLES');
all_tables = setdiff(all_tables, {'_collections', '_types'});
all_lists = tableList(a_f);
[dummy, idx_a, idx_b] = intersect(all_tables, all_lists);
id_to_drop = setdiff(1:numel(all_tables), idx_a);
for i = 1:numel(id_to_drop)
  tableDrop(a_f, all_tables(id_to_drop));
end
id_to_drop = setdiff(1:numel(all_lists), idx_b);
q = 'DELETE FROM _collections WHERE collection="{S}"';
for i = 1:numel(id_to_drop)
  mym(a_f.conInfo.id, q, all_lists{i});
end