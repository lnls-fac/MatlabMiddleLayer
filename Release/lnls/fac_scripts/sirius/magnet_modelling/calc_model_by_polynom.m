function [by_polynom errors integ_multipoles stray_multipoles] = calc_model_by_polynom(traj, seg)

by_polynom = NaN(1,size(traj.by_polynom,2));
errors = NaN(1,size(traj.by_polynom,2));
if isempty(seg), return; end;

t = add_seg_points_to_ref_traj(traj, seg);
ds  = diff(t.s);
p1m = 0.5*(t.by_polynom(1:end-1,:) + t.by_polynom(2:end,:));
p2m = 0.5*(t.by_polynom(1:end-1,:).^2 + t.by_polynom(2:end,:).^2);
for i=1:size(p1m,2)
    cinteg1(:,i) = [0; cumsum(ds .* p1m(:,i))]; % cumulative integrals of polynomials
    cinteg2(:,i) = [0; cumsum(ds .* p2m(:,i))]; % cumulative inetgarls of polynomials^2
end
for i=1:length(seg)
    idx(i) = find(seg(i) == t.s, 1);
    if (i>1)
        ds = seg(i) - seg(i-1);
        integ1(i-1,:) = cinteg1(idx(i),:) - cinteg1(idx(i-1),:);
        integ2(i-1,:) = cinteg2(idx(i),:) - cinteg2(idx(i-1),:); 
        by_polynom(i-1,:) = integ1(i-1,:) / ds;
        integ2m(i-1,:) = by_polynom(i-1,:).^2 * ds;
    end
end
try
    errors = 100 * sqrt(sum((integ2m - integ2).^2,1)) ./ sum(integ2,1);
catch
end
integ_multipoles = cinteg1(end,:);
stray_multipoles = cinteg1(end,:) - cinteg1(idx(end), :);



function t = add_seg_points_to_ref_traj(traj, seg)

t = traj;
for i=1:length(seg)
    s = seg(i);
    if ~isempty(find(s == t.s, 1)), continue; end;
    j = find(t.s > s, 1);
    x = interp1q(t.s, t.x, s);
    y = interp1q(t.s, t.y, s);
    z = interp1q(t.s, t.z, s);
    beta_x = interp1q(t.s, t.beta_x, s);
    beta_y = interp1q(t.s, t.beta_y, s);
    beta_z = interp1q(t.s, t.beta_z, s);
    angle_x = atan(beta_x / beta_z);
    angle_y = atan(beta_y / beta_z);
    t.s = [t.s(1:j-1); s; t.s(j:end)];
    t.x = [t.x(1:j-1); x; t.x(j:end)];
    t.y = [t.y(1:j-1); y; t.y(j:end)];
    t.z = [t.z(1:j-1); z; t.z(j:end)];
    t.beta_x  = [t.beta_x(1:j-1); beta_x; t.x(j:end)];
    t.beta_y  = [t.beta_y(1:j-1); beta_y; t.y(j:end)];
    t.beta_z  = [t.beta_z(1:j-1); beta_z; t.z(j:end)];
    t.angle_x = [t.angle_x(1:j-1); angle_x; t.angle_x(j:end)];
    t.angle_y = [t.angle_y(1:j-1); angle_y; t.angle_y(j:end)];
    by_polynom = interp1q(t.s, t.by_polynom, s);
    t.by_polynom = [t.by_polynom(1:j-1,:); by_polynom; t.by_polynom(j:end,:)];
end
if any(diff(t.s) < 0),
    error('problem!');
end
