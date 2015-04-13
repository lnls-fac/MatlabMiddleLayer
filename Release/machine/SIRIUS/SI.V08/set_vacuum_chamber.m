function the_ring = set_vacuum_chamber(the_ring0)

% y = +/- y_lim * (1 - (x/x_lim)^n)^(1/n);

the_ring = the_ring0;
bends_vchamber = [0.0117 0.0117 100]; % n = 100: ~rectangular
other_vchamber = [0.0117 0.0117 2];   % n = 2;   circular/eliptica
ivu_vchamber   = [0.0117 0.00225 2];   
ovu_vchamber   = [0.0117 0.004 2];

bends = findcells(the_ring, 'BendingAngle');
ivu   = sort([findcells(the_ring, 'FamName', 'id_endb') ...%   findcells(the_ring, 'FamName', 'mia') ...
              findcells(the_ring, 'FamName', 'dib1')]);
ovu   = sort([findcells(the_ring, 'FamName', 'id_enda') ...%   findcells(the_ring, 'FamName', 'mia') ...
              findcells(the_ring, 'FamName', 'dia1')]);
other = setdiff(1:length(the_ring), [bends ivu ovu]);

for i=1:length(bends)
    the_ring{bends(i)}.VChamber = bends_vchamber;
end
for i=1:length(ivu)
    the_ring{ivu(i)}.VChamber = ivu_vchamber;
end
for i=1:length(ovu)
    the_ring{ovu(i)}.VChamber = ovu_vchamber;
end
for i=1:length(other)
    the_ring{other(i)}.VChamber = other_vchamber;
end