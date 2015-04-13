function fcexpprocsave(filenames, meas)

for i=1:length(meas)
    exper = meas{i};

    file_len = 100000;
    idx = [];
    data = faload(filenames(exper.file));
    for ii=1:length(exper.file),
        idx = [idx, ((ii-1)*file_len + exper.idx{ii})];
    end
    data = facutdata(data,idx);
    
    switch (mod(i-1,3)+1)
        case 1
            data_respmsin = data;
            save(sprintf('data_respmsin_%02d',ceil(i/3)),'data_respmsin');
        case 2
            data_respm = data;
            save(sprintf('data_respm_%02d',ceil(i/3)),'data_respm');
        case 3
    end
end