function [dfdx dfdz] = kickmap_calc_derivatives(f, posx, posz)

dfdx = zeros(length(posz), length(posx));
for i=1:length(posz)
    x = posx;
    y = f(i,:);
    xp = x + [0.2*diff(x) 0];
    xn = x - [0 0.2*diff(x)];
    fp = interp1(x, y, xp, 'cubic');
    fn = interp1(x, y, xn, 'cubic');
    dx = xp - xn;
    dfdx(i,:) = (fp - fn) ./ dx;
end

dfdz  = zeros(length(posz), length(posx));
for i=1:length(posx)
    x = posz;
    y = f(:,i)';
    xp = x + [0.2*diff(x) 0];
    xn = x - [0 0.2*diff(x)];
    fp = interp1(x, y, xp, 'cubic');
    fn = interp1(x, y, xn, 'cubic');
    dx = xp - xn;
    dfdz(:,i) = ((fp - fn) ./ dx)';
end