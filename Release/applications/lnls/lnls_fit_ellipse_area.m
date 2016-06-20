function area = lnls_fit_ellipse_area(X,Y)
% function area = lnls_fit_ellipse_area(x,y)
%
% the function fits an ellipse with the points x and y and return its area

%a*x^2 + b*x*y + c*y^2 + d*x + f*y + g
area = zeros(1,size(X,1));

for ii=1:size(X,1)
    x = X(ii,:)';
    y = Y(ii,:)';
    D = [x.*x, x.*y, y.*y, x, y, 1+0*x];
    S = D'*D;
    C = zeros(6,6);
    C(1,3) = 2; C(3,1) = 2; C(2,2) = -1;
    [V, D] = eig(S\C);
    [~,n] = max(abs(diag(D)));
    vec = V(:,n);
    a = vec(1);
    b = vec(2)/2;
    c = vec(3);
    d = vec(4)/2;
    f = vec(5)/2;
    g = vec(6);
    up    = 2*(a*f*f+c*d*d+g*b*b-2*b*d*f-a*c*g);
    if a ~= c
        down1 = (b*b-a*c)*( (c-a)*sqrt(1+4*b*b/((a-c)*(a-c)))-(c+a));
        down2 = (b*b-a*c)*( (a-c)*sqrt(1+4*b*b/((a-c)*(a-c)))-(c+a));
    else
        down1 = (b*b-a*c)*(-2*b-(c+a));
        down2 = (b*b-a*c)*( 2*b-(c+a));
    end
    res1 = sqrt(up/down1);
    res2 = sqrt(up/down2);
    area(ii) = real(res1 * res2 * pi);
end