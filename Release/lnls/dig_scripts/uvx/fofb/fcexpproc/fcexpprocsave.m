function fcexpprocsave(filenames, expmap)

for i=1:length(expmap)
    data = faload(filenames(expmap(i).filesidx));
    data = facutdata(data, expmap(i).idx);
    timestamp = datestr(fatimelvrt2m(data.time(1)), 'yyyy.mm.dd_HH.MM.ss');
    
    save(sprintf('exp_%s.mat',timestamp),'data');
end