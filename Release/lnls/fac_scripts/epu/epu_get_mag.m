function mag = epu_get_mag(epu, tags)

mag = [];
for i=1:length(tags);
    m = [];
    if isfield(epu, 'csd')
        idx = [epu.csd(:).tag] == tags(i); 
        m = [m epu.csd(idx).mag];
    end;
    if isfield(epu, 'cse')
        idx = [epu.cse(:).tag] == tags(i); 
        m = [m epu.cse(idx).mag];
    end;
    if isfield(epu, 'cie')
        idx = [epu.cie(:).tag] == tags(i); 
        m = [m epu.cie(idx).mag];
    end;
    if isfield(epu, 'cid')
        idx = [epu.cid(:).tag] == tags(i); 
        m = [m epu.cid(idx).mag];
    end;
    mag = [mag mean(m,2)];
end
    
    