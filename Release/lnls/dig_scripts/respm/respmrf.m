function M = respmrf(THERING, orbit_points, indexes)

delta_freq = 1;

original_cavity_status = getcavity;
setcavity('on');
setradiation('on');

n_orbit_points = length(orbit_points);
n_elements = size(indexes,1);

M = zeros(n_orbit_points, n_elements, 4);

for i=1:n_elements
    orbit1 = findorbit6(THERING, orbit_points);
    THERING{indexes(i,:)}.Frequency = THERING{indexes(i,:)}.Frequency + delta_freq/2;
    orbit2 = findorbit6(THERING, orbit_points);
    THERING{indexes(i,:)}.Frequency = THERING{indexes(i,:)}.Frequency - delta_freq/2;
    M(:,i,:)  = (orbit2(1:4,:) - orbit1(1:4,:))'/delta_freq;
end

setradiation('off');
setcavity(original_cavity_status);