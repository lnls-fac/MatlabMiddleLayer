function expmap = fcexpprocmap(filenames)

filenpts = 100e3;

data = faload(filenames,0,0);
t = find(data.marker(2:end) ~= data.marker(1:end-1));

j=1;
for i=1:length(t)-1
    idx = t(i)+1:t(i+1);
    if data.marker(idx(1)) ~= 0
        filesidx = (floor(idx(1)/filenpts)+1):ceil(idx(end)/filenpts);
        fprintf('%d:%d\n',filesidx(1),filesidx(end));
        idx = idx - (filesidx(1)-1)*filenpts;
        
        expmap(j).idx = idx;
        expmap(j).filesidx = filesidx;
        expmap(j).marker = data.marker;
        j=j+1;
    end
end