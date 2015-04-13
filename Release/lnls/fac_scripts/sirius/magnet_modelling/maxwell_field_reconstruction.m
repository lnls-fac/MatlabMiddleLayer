function maxwell_field_reconstruction(order)

% Maxwell fiels reconstruction
% ============================
% Bx = Bx^(0) + Bx^(1) y + Bx^(2) y^2 /2 + ...
% By = By^(0) + By^(1) y + By^(2) y^2 /2 + ...
% Bz = Bz^(0) + Bz^(1) y + Bz^(2) y^2 /2 + ...
%
% dBx/dy = dBy/dx      -> Bx^(n+1) = dBy^(n)/dx
% dBz/dy = dBy/dz      -> Bz^(n+1) = dBy^(n)/dz
% dBx/dx+dBy/dy+dBz/dz -> By^(n+1) = - dBx^(n)/dx - dBz^(n)/dz

fields = getappdata(0, 'FIELD_MAPS');
r.x = fields{1}.data.x;
r.z = fields{1}.data.z;
r.fderivs{1}.bx = fields{1}.data.bx;
r.fderivs{1}.by = fields{1}.data.by;
r.fderivs{1}.bz = fields{1}.data.bz;
r.dx = mean(diff(r.x));
r.dz = mean(diff(r.z));
for i=1:order
    r.fderivs{end+1} = calc_next_derivative(r.dx, r.dz, r.fderivs{end});
end
fields{1}.data.fderivs = r.fderivs;
fields{1}.data.dx = r.dx;
fields{1}.data.dz = r.dz;
fields{1}.data = rmfield(fields{1}.data, {'bx','by','bz'});
setappdata(0, 'FIELD_MAPS', fields);


function fderiv = calc_next_derivative(dx, dz, previous_frediv)

bx = previous_frediv.bz;
by = previous_frediv.by;
bz = previous_frediv.bz;

fderiv.bx = zeros(size(bx));
fderiv.by = zeros(size(by));
fderiv.bz = zeros(size(bz));

fderiv.bx(:,2:end-1) = (by(:,3:end) - by(:,1:end-2))/(2*dx);
fderiv.bz(2:end-1,:) = (by(3:end,:) - by(1:end-2,:))/(2*dz);
fderiv.by(:,2:end-1) = fderiv.by(:,2:end-1) - (bx(:,3:end) - bx(:,1:end-2))/(2*dx);
fderiv.by(2:end-1,:) = fderiv.by(2:end-1,:) - (by(3:end,:) - by(1:end-2,:))/(2*dz);







