function M = respmdisp(THERING, orbit_points, indexes, plane)

delta_mis = 1e-6;

n_orbit_points = length(orbit_points);
n_elements = size(indexes,1);

M = zeros(n_orbit_points, n_elements, 4);

TR0 = THERING;
for i=1:n_elements
    if strcmpi(plane{i}, 'h')
        lnls_add_misalignment = @lnls_add_misalignmentX;
    else
        lnls_add_misalignment = @lnls_add_misalignmentY;
    end
    idx = indexes(i,:);
    
    THERING = TR0;
    THERING = lnls_add_misalignment(ones(size(idx))*delta_mis/2, idx, THERING);
    orbit1 = findorbit4(THERING, 0, orbit_points);
    THERING = lnls_add_misalignment(-ones(size(idx))*delta_mis/2, idx, THERING);
    orbit2 = findorbit4(THERING, 0, orbit_points);
    M(:,i,:) = (orbit2-orbit1)'/delta_mis;
end
