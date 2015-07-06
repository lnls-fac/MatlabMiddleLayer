function the_ring = ids_insert_set(the_ring_old, ids)

% Start at the last mc marker to preserve sections numbers
idx = findcells(the_ring_old, 'FamName', 'mc');  idx = idx(end)-1;
the_ring = circshift(the_ring_old,[0,-idx]);

% excludes markers for the end of 2-meter IDs
idx = [findcells(the_ring, 'FamName', 'id_enda'), ...
       findcells(the_ring, 'FamName', 'id_endb')];
the_ring(idx) = [];

for i=1:length(ids)
    fprintf('\ninsertion: %12s --> strength: %4.1f;  section: %02d-%s',...
            ids(i).label,ids(i).strength,ids(i).straight_number,ids(i).straight_label);
    
    %find the straight section number
    if strcmp(ids(i).straight_label,'mia'), 
        section_nr = (ids(i).straight_number - 1) * 2 + 1;
    else
        section_nr = ids(i).straight_number * 2;
    end

    % define the elements of that section
    mc = unique([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]);
    elements = mc(section_nr):mc(section_nr+1);
        
    % change family names of local quadrupoles
    quad_idx = setdiff(findcells(the_ring, 'K'), findcells(the_ring, 'BendingAngle'));
    quads = intersect(quad_idx, elements);
    sect_label = num2str(section_nr, '_ID%02i');
    for ii=1:length(quads)
        the_ring{quads(ii)}.FamName = [the_ring{quads(ii)}.FamName  sect_label];
    end
    
    % insert ID kicktable
    center = elements(findcells(the_ring(elements),'FamName',ids(i).straight_label));
    the_ring = lnls_insert_kicktable(the_ring, center, ids(i));
end

% Shift the ring back to its original starting point
idx = findcells(the_ring,'FamName','start') - 1;
if isempty(idx),idx = findcells(the_ring,'FamName','inicio') - 1;end
the_ring = circshift(the_ring,[0,-idx]);
fprintf('\n');
