function M = respmcorr(THERING, orbit_points, indexes, plane, delta_exc)

if nargin < 5 || isempty(delta_exc)
    delta_exc = 1e-5;
end

n_orbit_points = length(orbit_points);

nelements = size(indexes,1);
M = zeros(n_orbit_points, nelements, 4);
for i=1:nelements
    if strcmpi(plane, 'h')
        planenum = 1;
    elseif strcmpi(plane, 'v')
        planenum = 2;
    else
        error('Unknown plane.');
    end
    original_kick = THERING{indexes(i,:)}.KickAngle(planenum);
    THERING{indexes(i,:)}.KickAngle(planenum) = original_kick - (delta_exc/2);
    orbit1 = findorbit4(THERING, 0, orbit_points);
    THERING{indexes(i,:)}.KickAngle(planenum) = original_kick + (delta_exc/2);
    orbit2 = findorbit4(THERING, 0, orbit_points);
    THERING{indexes(i,:)}.KickAngle(planenum) = original_kick;
    
    M(:,i,:)  = (orbit2 - orbit1)'/delta_exc;
end