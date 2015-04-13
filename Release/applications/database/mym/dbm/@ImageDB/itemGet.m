function item =  itemGet(a_f, a_id, varargin)
% IGET - get an item

item = itemGet(a_f.BasicDB, a_id, varargin);
for i = 1:numel(a_id)
  item{i} = jpm('decompress', item{i});
end