function the_ring = set_vacuum_chamber(the_ring)

% y = +/- y_lim * (1 - (x/x_lim)^n)^(1/n);

bc_vchamber    = [0.012 0.004 100]; % n = 100: ~rectangular
other_vchamber = [0.012 0.012 2];   % n = 2;   circular/eliptica
ivu_vchamber   = [0.012 0.00225 2];   
ovu_vchamber   = [0.012 0.004 2];
inj_vchamber   = [0.030 0.012 2];

% Set ordinary Vacuum Chamber
for i=1:length(the_ring)
    the_ring{i}.VChamber = other_vchamber;
end

% Shift the ring to do not begin between id markers
bpm = findcells(the_ring,'FamName','bpm');
the_ring = circshift(the_ring,[0,-bpm(1)]);

% Set bc vacuum chamber
bcs = findcells(the_ring, 'FamName','bc_hf');
for i=1:length(bcs)
    the_ring{bcs(i)}.VChamber = bc_vchamber;
end

% Set in-vacuum ids vacuum chamber
idb = findcells(the_ring, 'FamName', 'id_endb');
ivu_ini = idb(1:2:end);  ivu_end = idb(2:2:end);
for i=1:length(ivu_ini)
    for j=ivu_ini(i):ivu_end(i)
     the_ring{j}.VChamber = ivu_vchamber;
    end
end

% Set other ids vacuum chamber
ida = findcells(the_ring, 'FamName', 'id_enda');
ovu_ini = ida(1:2:end);  ovu_end = ida(2:2:end);
for i=1:length(ovu_ini)
    for j=ovu_ini(i):ovu_end(i)
     the_ring{j}.VChamber = ovu_vchamber;
    end
end

% Shift the ring back.
the_ring = circshift(the_ring,[0,bpm(1)]);

% Set injection vacuum chamber
inj = findcells(the_ring, 'FamName', 'eseptinf');
kickin = findcells(the_ring, 'FamName', 'kick_in');
if (inj(end) > kickin(1))
    for i=[inj(end):length(the_ring) 1:kickin(end)]
        the_ring{i}.VChamber = inj_vchamber;
    end
else
    for i=inj:kickin(1)
        the_ring{i}.VChamber = inj_vchamber;
    end
end