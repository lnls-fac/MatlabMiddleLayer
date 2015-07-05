function expmap = fcexpprocmap(filenames)

filenpts = 100e3;

fprintf('\nLoading markers...');
data = faload(filenames,0,0);
t = find(data.marker(2:end) ~= data.marker(1:end-1));

fprintf('\nMapping experiments...');
expmap = struct;
j=1;
for i=1:length(t)-1
    idx = t(i)+1:t(i+1);
    if data.marker(idx(1)) ~= 0
        expmap(j).marker = data.marker(idx(1));

        filesidx = (floor(idx(1)/filenpts)+1):ceil(idx(end)/filenpts);
        idx = idx - (filesidx(1)-1)*filenpts;

        expmap(j).idx = idx;
        expmap(j).filesidx = filesidx;
        
        j=j+1;
    end
end

fprintf('\n%4d files analyzed.\n%4d experiments found.\n',length(filenames),j-1);