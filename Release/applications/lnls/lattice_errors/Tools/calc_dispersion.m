function dispersion = calc_dispersion(the_ring, idx, dim)

if ~exist('dim','var'), dim = get_dim(the_ring); end

if strcmp(dim,'6d')
    df = 10; % approx 1e-8 of the frequency
    cav_idx = findcells(the_ring,'Frequency');
    cav_freq = getcellstruct(the_ring,'Frequency',cav_idx);
    the_ring = setcellstruct(the_ring,'Frequency',cav_idx,cav_freq+df/2);
    orbn = findorbit6(the_ring,idx);
    the_ring = setcellstruct(the_ring,'Frequency',cav_idx,cav_freq-df);
    orbp = findorbit6(the_ring,idx);
    dispersion = (orbp - orbn) / (orbp(5,1) - orbn(5,1));
else
    ddp = 1e-8;
    orbn = findorbit4(the_ring,-ddp,idx);
    orbp = findorbit4(the_ring,+ddp,idx);
    dispersion = (orbp - orbn) / (2*ddp);
end