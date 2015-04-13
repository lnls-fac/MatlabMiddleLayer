function dim = get_dim(the_ring)

dim = '4d';
cav_idx = findcells(the_ring,'Frequency');
if isempty(cav_idx), return; end
cav_state = getcellstruct(the_ring,'PassMethod',cav_idx);
if any(strcmp('CavityPass',cav_state)), dim = '6d'; end

