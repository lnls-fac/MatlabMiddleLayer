function [Mx, My] = respmquadripple(THERING, orbit_points, indexes)

delta_mis = 1e-6;
delta_exc = 1e-5;

n_orbit_points = length(orbit_points);
n_elements = size(indexes,1);

Mx = zeros(n_orbit_points, n_elements, 4);
My = zeros(n_orbit_points, n_elements, 4);

TR0 = THERING;
for i=1:n_elements

    idx = indexes(i,:);
    K = THERING{idx(1)}.PolynomB(2);
    
    % positive misalignment
    THERING = TR0;
    THERING = lnls_add_misalignmentX(ones(size(idx)) * delta_mis/2, idx, THERING);
    TR1 = THERING;
    
    THERING = TR1;
    THERING = lnls_add_excitation(ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_p = findorbit4(THERING, 0, orbit_points);
    
    THERING = TR1;
    THERING = lnls_add_excitation(-ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_n = findorbit4(THERING, 0, orbit_points);
    
    dorbit_p = (orbit_p-orbit_n)'/(delta_exc *.2/59/ K);
    
    % negative misalignment
    THERING = TR0;
    THERING = lnls_add_misalignmentX(-delta_mis/2, idx, THERING);
    TR1 = THERING;
    
    THERING = TR1;
    THERING = lnls_add_excitation(ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_p = findorbit4(THERING, 0, orbit_points);
    
    THERING = TR1;
    THERING = lnls_add_excitation(-ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_n = findorbit4(THERING, 0, orbit_points);
    
    dorbit_n = (orbit_p-orbit_n)'/(delta_exc * K);
    
    Mx(:,i,:) = (dorbit_p - dorbit_n)/delta_mis;
    
    
    
    % positive misalignment
    THERING = TR0;
    THERING = lnls_add_misalignmentY(delta_mis/2, idx, THERING);
    TR1 = THERING;
    
    THERING = TR1;
    THERING = lnls_add_excitation(ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_p = findorbit4(THERING, 0, orbit_points);
    
    THERING = TR1;
    THERING = lnls_add_excitation(-ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_n = findorbit4(THERING, 0, orbit_points);
    
    dorbit_p = (orbit_p-orbit_n)'/(delta_exc * K);
    
    % negative misalignment
    THERING = TR0;
    THERING = lnls_add_misalignmentY(-delta_mis/2, idx, THERING);
    TR1 = THERING;
    
    THERING = TR1;
    THERING = lnls_add_excitation(ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_p = findorbit4(THERING, 0, orbit_points);
    
    THERING = TR1;
    THERING = lnls_add_excitation(-ones(size(idx)) * delta_exc/2, idx, THERING);
    orbit_n = findorbit4(THERING, 0, orbit_points);
    
    dorbit_n = (orbit_p-orbit_n)'/(delta_exc * K);
    
    My(:,i,:) = (dorbit_p - dorbit_n)/delta_mis;
    
end
