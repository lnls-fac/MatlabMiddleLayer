function sirius_nominal_dipole_trajectory(dipole_famname)

global THERING

if strcmpi(dipole_famname, 'B')
    s_step = 0.1/1000;
    s_max = 742.1/1000;
    x0 = 9.1013/1000;
    x_ref = 28.255/1000;
%     p0 = [0;9.1013]/1000;
    data = sirius_bo_family_data(THERING);
    idx = data.B.ATIndex(1,:); % first dipole
    idx = idx(length(idx)/2+1:end); % z>0 half dipole
elseif strcmpi(dipole_famname, 'B1')
    s_step = 0.1/1000;
    s_max = 742.1/1000;
    x0 = 9.1013/1000;
    x_ref = 28.255/1000;
%     p0 = [0;9.1013]/1000;
    data = sirius_bo_family_data(THERING);
    idx = data.B.ATIndex(1,:); % first dipole
    idx = idx(length(idx)/2+1:end); % z>0 half dipole
else
    error('Not implemented for accelerator other than BO.')
end

ang = getcellstruct(THERING, 'BendingAngle', idx);
len = getcellstruct(THERING, 'Length', idx);
rho = len ./ ang;

% loop through segments of dipole model
s(1) = 0.0;
% p(:,1) = p0;
p(:,1) = [0;0];
v(:,1) = [1;0];
r90 = [cos(pi/2), sin(pi/2); -sin(pi/2), cos(pi/2)];
for i=1:length(ang)
    u = r90 * v(:,end);
    n = -u * rho(i);
    o = p(:,end) - n; 
    np = ceil(len(i)/s_step);
    av = linspace(0,ang(i), np);
    v0 = v(:,end);
    s0 = s(end);
    for a=av(2:end)
        m = [cos(a), sin(a); -sin(a), cos(a)];
        nr = m * n;
        p(:,end+1) = o + nr;
        v(:,end+1) = m * v0;
        s(end+1) = s0 + a * rho(i);
    end
end

% finds segmodel x0 ans shifts radially
p1 = p(:,end);
p2 = p(:,end-1);
l0 = - p1(1)/(p2(1)-p1(1));
p0 = p1 + l0*(p2-p1);
x_ref_segmodel = x_ref - p0(2);
p(2,:) = p(2,:) + x_ref_segmodel;

% extrapolate straight line
while s(end) < s_max
    s(end+1) = s(end) + s_step;
    v(:,end+1) = v(:,end);
    p(:,end+1) = p(:,end) + v(:,end)*s_step;
end

% plot(1000*p(1,:), 1000*p(2,:), 'o');

fp = fopen('trajectory-pos.txt', 'w');
fprintf(fp, '# trajectory\n');
fprintf(fp, '# s[mm] rx[mm] ry[mm] rz[mm] px py pz\n');
for i=1:length(s)
    fprintf(fp, '%+.14e %+.14e %+.14e %+.14e %+.14e %+.14e %+.14e\n', 1e3*s(i), 1e3*p(2,i), 0.0, 1e3*p(1,i), v(2,i), 0.0, v(1,i));
end

fp = fopen('trajectory-neg.txt', 'w');
fprintf(fp, '# trajectory\n');
fprintf(fp, '# s[mm] rx[mm] ry[mm] rz[mm] px py pz\n');
for i=1:length(s)
    fprintf(fp, '%+.14e %+.14e %+.14e %+.14e %+.14e %+.14e %+.14e\n', -1e3*s(i), 1e3*p(2,i), 0.0, -1e3*p(1,i), -v(2,i), 0.0, v(1,i));
end

