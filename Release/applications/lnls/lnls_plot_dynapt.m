function lnls_plot_dynapt(angles, radius, color)

x = 1000 * radius .* cos(angles);
y = 1000 * radius .* sin(angles);
% line(x,y,color);
% return;

xx = x;
yy = y;
for i=(length(x)-1:-1:1)
    xx = [xx 0 x(i)];
    yy = [yy 0 y(i)];
end
line(xx,yy,'Color',color);
%axis([-20 20 0 12]);