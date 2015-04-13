function rk_traj = calc_field_on_rk_trajectory(rk_traj0, perp_grid)

rk_traj = rk_traj0;

xgrid = perp_grid.points;
monomials = perp_grid.monomials;

max_dy_a = 0;
max_dy_b = 0;
on_axis_idx = find(xgrid == 0);

h1 = figure;
h2 = figure;

% removes fields of rk_traj, if rk traj was loaded
if isfield(rk_traj, 'by_polynom'), rk_traj = rmfield(rk_traj,'by_polynom'); end;
if isfield(rk_traj, 'bx_polynom'), rk_traj = rmfield(rk_traj,'bx_polynom'); end;
  
for i=1:length(rk_traj.s)
    
    s = rk_traj.s(i);
    
    % interpolates field at perpendicular grid points
    sf = get_local_SerretFrenet_coord_system(rk_traj, s);
    field = zeros(3, length(xgrid));
    for j=1:length(xgrid)
        p = sf.r + sf.n * xgrid(j);
        field_vector = interpolate_field(p);     
        field(:,j) = field_vector;
    end
    
    % polynomial_b interpolation
    x = xgrid; y = field(2,:) - field(2, on_axis_idx);
    [coeffs_b y_fit] = mypolyfit(x, y, setdiff(monomials, [0]));
    dy = y_fit' - y;
    if (max(abs(dy)) > max_dy_b)
        max_dy_b = max(abs(dy));
        figure(h1); clf(h1); plot(1e3*x, 1e4*dy); xlabel('Pos [mm]'); ylabel('dBy [G]'); title(['Multipole fit error at s = ' num2str(1000*s, '%8.3f mm (worst case).')]);
        drawnow; pause(0);
        set(gcf, 'Name','polynominal_b_fit_residue');
        %fprintf('%7.3f G @ %8.3f mm\n', 1e4*max_dy, 1000*s);
    end
    
    % polynomial_a interpolation
    x = xgrid; y = field(1,:) - field(1, on_axis_idx);
    [coeffs_a y_fit] = mypolyfit(x, y, setdiff(monomials, [0]));
    dy = y_fit' - y;
    if (max(abs(dy)) > max_dy_a)
        max_dy_a = max(abs(dy));
        figure(h2); clf(h2); plot(1e3*x, 1e4*dy); xlabel('Pos [mm]'); ylabel('dBx [G]'); title(['Multipole fit error at s = ' num2str(1000*s, '%8.3f mm (worst case).')]);
        drawnow; pause(0);
        set(gcf, 'Name','polynominal_a_fit_residue');
        %fprintf('%7.3f G @ %8.3f mm\n', 1e4*max_dy, 1000*s);
    end
  
    % stores field data on trajectory
    rk_traj.bx_field(i,1)   = field(1,on_axis_idx);
    rk_traj.by_field(i,1)   = field(2,on_axis_idx);
    rk_traj.bz_field(i,1)   = field(3,on_axis_idx);
    
    if any(monomials == 0) % inserts back original dipolar component (not fitted) if needed
        rk_traj.by_polynom(i,:) = [field(2, on_axis_idx), coeffs_b'];
        rk_traj.bx_polynom(i,:) = [field(1, on_axis_idx), coeffs_a'];
    else
        rk_traj.by_polynom(i,:) = coeffs_b;
        rk_traj.bx_polynom(i,:) = coeffs_a;
    end
        
        
    
end
%close(h1);

rk_traj = filter_polynomial(rk_traj);

% plots fields on trajectory
%plot_fields(rk_traj);

% plots multipoles on trajectory
plot_polynomials(monomials, rk_traj);


function rk_traj = filter_polynomial(old_rk_traj)

% at the edge of the field map there maybe be a discontinuity of the
% perpendicular field (b=0, outside fmap, b<>0(small) inside). This
% generates a very large derivative. this artfact should be filtered out.

% POLYNOM_B

rk_traj = old_rk_traj;
for i=1:size(rk_traj.by_polynom,2)
    for j=2:size(rk_traj.by_polynom,1)-1
        nl = rk_traj.by_polynom(j-1,i);
        nt = rk_traj.by_polynom(j,i);
        nr = rk_traj.by_polynom(j+1,i);
        if ((abs(nt/nl) > 5) && (abs(nt/nr) > 5))
            avg = (rk_traj.by_polynom(j-1,i) + rk_traj.by_polynom(j+1,i))/2;
            rk_traj.by_polynom(j,i) = avg;
        end
    end
end

% POLYNOM_A
rk_traj = old_rk_traj;
for i=1:size(rk_traj.bx_polynom,2)
    for j=2:size(rk_traj.bx_polynom,1)-1
        nl = rk_traj.bx_polynom(j-1,i);
        nt = rk_traj.bx_polynom(j,i);
        nr = rk_traj.bx_polynom(j+1,i);
        if ((abs(nt/nl) > 5) && (abs(nt/nr) > 5))
            avg = (rk_traj.bx_polynom(j-1,i) + rk_traj.bx_polynom(j+1,i))/2;
            rk_traj.bx_polynom(j,i) = avg;
        end
    end
end





function plot_fields(rk_traj)

figure; plot(1000*rk_traj.s, rk_traj.by_field);
xlabel('Pos S [mm]'); ylabel('By [T]'); title('Longitudinal Rolloff of By (on trajectory)');

function plot_polynomials(monomials, rk_traj)

for i=1:1+max(monomials)
    ylabels{i} = ['rk_traj - ' int2str(2*i) '-pole'];
end
ylabels(1:6) = {
    'rk_traj - dipole', ...
    'rk_traj - quadrupole', ...
    'rk_traj - sextupole', ...
    'rk_traj - octupole', ...
    'rk_traj - decapole', ...
    'rk_traj - duodecapole', ...
    };

s = rk_traj.s;

% polynom B
for i=1:size(rk_traj.by_polynom, 2)
    b = rk_traj.by_polynom(:,i);
    figure; 
    plot(1000*s, b);
    xlabel('long. pos [mm]');
    is = int2str(monomials(i)); ylabel(['d^{' is '}B_y/dx^{' is '} [T/m^{' is '}]']);
    set(gcf, 'Name', ['PolynomB - ' ylabels{1+monomials(i)}]);
end

% polynom A
for i=1:size(rk_traj.bx_polynom, 2)
    b = rk_traj.bx_polynom(:,i);
    figure; 
    plot(1000*s, b);
    xlabel('long. pos [mm]');
    is = int2str(monomials(i)); ylabel(['d^{' is '}B_x/dx^{' is '} [T/m^{' is '}]']);
    set(gcf, 'Name', ['PolynomA - ' ylabels{1+monomials(i)}]);
end


function sf = get_local_SerretFrenet_coord_system(rk_traj, s)

% function sf = get_local_SerretFrenet_coord_system(traj, s)
%
% Retorna par?metros que definem o sistema de coordenadas local Serret-Frenet
% em um ponto da trajet?ria.
%
% INPUT
%   traj  : estrutura com par?metros da trajet?ria 
%   s [mm]: comprimento de arco at? o ponto no qual o sistema SF ser? calculado
%
% OUTPUT
%   sf :    estrutura com par?metros que definem o sistema de coordenadas local Serret-Frenet
%           sf.s [mm] : comprimento de arco at? o ponto no qual o sistema SF foi calculado
%           sf.r [mm] : vetor [x;y;z] com coordenadas no sistema retangular global (sistema Runge-Kutta) 
%                       do ponto sobre o qual o sistema SF foi definido.
%           sf.p [rad]: vetor [beta_x;beta_y;beta_z] com velocidades no ponto sf.r
%           sf.t [a.] : versor tangente ? trajet?ria no ponto sf.r
%           sf.n [a.] : versor normal ? trajet?ria no ponto sf.r (apontando para fora do anel)
%           sf.k [a.] : versor que aponta na dire??o vertical (no caso de trajet?ria sobre plano horizontal)
%
% Obs:
%   Os versores t,n,k que definem o sistema de coordenadas SF obdecem ? regra da m?o direita com k = t x n.
%
% History:
%   2011-11-25: vers?o revisada e comentada (Ximenes).

x = interp1(rk_traj.s, rk_traj.x, s);
y = interp1(rk_traj.s, rk_traj.y, s);
z = interp1(rk_traj.s, rk_traj.z, s);
beta_x = interp1(rk_traj.s, rk_traj.beta_x, s);
beta_y = interp1(rk_traj.s, rk_traj.beta_y, s);
beta_z = interp1(rk_traj.s, rk_traj.beta_z, s);

sf.s = s;
sf.r = [x; y; z];                                                 % coordenadas na posi??o s da trajet?ria
sf.p = [beta_x; beta_y; beta_z];                                  % velocidades na posi??o s da trajet?ria
sf.t = [beta_x; beta_y; beta_z] / norm([beta_x; beta_y; beta_z]); % vetor tangente
sf.n = [0 0 1; 0 1 0; -1 0 0] * sf.t;                             % vetor normal
sf.k = cross(sf.t, sf.n);                                         % vetor tors?o
