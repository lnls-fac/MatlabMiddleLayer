function lst = dirtree(rdir, rfirst)
% DIRTREE directory tree
%   dirtree(dir) returns all directories in the directory tree having
%   for root the directory dir (including the root). 

if nargin>1
  if rfirst~=false
    error('dir_tree takes only one argument')
  end
else
  rfirst = true;
end
entries = dir(rdir);
if rfirst&&numel(entries) == 0
  error([rdir ' not found'])
end
% list the directories at that node
direcs = find([entries.isdir]);
if rfirst
  lst = {rdir};
else
  lst = {};
end
for i = 3:length(direcs) % leave out directories '.', '..')
  % take a look into every subdirectories
  rec = dirtree(fullfile(rdir, entries(direcs(i)).name), false);
  lst = {lst{:} fullfile(rdir, entries(direcs(i)).name) rec{:}};
end