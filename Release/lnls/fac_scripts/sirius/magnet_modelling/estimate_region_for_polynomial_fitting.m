function estimate_region_for_polynomial_fitting(r, the_ring, idx)

global THERING;

if ~exist('the_ring','var')
    the_ring = THERING;
else
    TR0 = THERING;
    THERING = the_ring;
end

if ~exist('idx','var')
    idx = findcells(THERING, 'Length', 0.34); % LONG QFs
end

% r.energy_deviation = 0;
% r.radius_resolution = 0.25 / 1000;
% r.nr_turns = 4*512;
% r.points_angle = repmat(linspace(0,pi,21), length(r.energy_deviation), 1);
% r.points_radius = [ ...
%     0.00850 0.00775 0.00700 0.00550 0.00525 0.00450 0.00400... 
%     0.00450 0.00425 0.00625 0.00475 0.00575 0.00650 0.00700...
%     0.00600 0.00700 0.00850 0.01075 0.01175 0.01650 0.01650];
% r = lnls_dynapt(r); 
%builts matrix with initial tracking conditions
for i=1:length(r.points_x(:))
  p(:,i) = [r.points_x(i) 0 1e-6+r.points_y(i) 0 0 0];
end


x_max = -Inf;
x_min =  Inf;
%p = p(:,2:end-1);
%figure; hold all;
for i=1:r.nr_turns
    p_idx = linepass(the_ring, p, idx);
    %plot(p_idx(1,:)); drawnow;
    %p_idx = p_idx(:,idx);
    x = p_idx(1,:);
    if max(x) > x_max
        x_max = max(x); 
        fprintf('%i %f %f\n', i, x_min, x_max);
    end;

    if min(x) < x_min, x_min = min(x); end;
    
    p = linepass(the_ring, p);
end

fprintf('max x: %f mm \n', 1000*x_max);
fprintf('min x: %f mm \n', 1000*x_min);
%THERING = TR0;





