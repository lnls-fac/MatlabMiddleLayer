function r = faverify(filenames)

r = [];
tlast = [];
j = 1;
for i=1:length(filenames)
    [pathstr, filename, ext] = fileparts(filenames{i}) ;

    if strcmpi(ext, '.dat') && ~strcmpi(filename, 'temp')
        fadata = faload(filenames{i},0,0);
        t = [tlast; fadata.time];
        dt = diff(t);
        tlast = fadata.time(end);

        failed = dt > fadata.period*1e3*1.5;
        if any(failed)
            r(j).filename = filenames{i};
            r(j).failed_transition = (failed(1) == 1);
            r(j).failed = find(failed(2:end))+1;
            j=j+1;
        end
    end
end
