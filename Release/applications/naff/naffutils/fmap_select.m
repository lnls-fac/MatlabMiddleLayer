function xy = fmap_select

xy = [];
% Loop, picking up the points.
disp('Left mouse button picks points.')
disp('Right mouse button picks last point.')
hold on
button = 1;
n=0;
while button == 1
    [xi,yi,button] = ginput(1);
    plot(xi,yi,'ro')
    n = n+1;
    xy(:,n) = [xi;yi];
end
