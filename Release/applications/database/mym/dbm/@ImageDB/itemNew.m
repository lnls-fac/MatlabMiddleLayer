function id = itemNew(a_f, a_item, a_tag, varargin)
% INEW - add a new item

if ~isempty(a_item)
  item = jpm('compress', im2uint8(a_item), 90);
  id = itemNew(a_f.BasicDB, item, a_tag);
  return
end

idx = find(strcmp(varargin, 'DIRECTORY'));
if isempty(idx)
  error('support only ''DIRECTORY''')
end
if ~isempty(a_tag)
  error('tag: should be empty')
end
if ~isempty(a_item)
  error('item: should be empty')
end
path = varargin{idx+1};
idx = find(strcmp(varargin, 'MIN_BYTES'));
if isempty(idx)
  n_min_byte = 0;
else
  n_min_byte = varargin{idx+1};
end
% get directory tree
dir_lst = dirtree(path);
% get all the JPEG images contained in the directory tree
n_img = 0;
for c_dir = 1:numel(dir_lst)
  filename = dir([dir_lst{c_dir} filesep '*.jpg']);
  num_bytes = [filename.bytes];
  filename = {filename.name};
  for  i = 1:numel(filename)
    c_file = filename{i};
    if num_bytes(i)<n_min_byte
      continue
    end
    full_name = [dir_lst{c_dir} filesep c_file];
    n_img = n_img+1;
    id(n_img) = itemNew(a_f, imread(full_name), c_file);
  end
end