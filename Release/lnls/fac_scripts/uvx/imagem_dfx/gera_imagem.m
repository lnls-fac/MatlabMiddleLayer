function f = gera_imagem(X,Y)

sigma1 = 100;
sigma2 = 15;
theta  = -0.1*pi/4;

rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
M = rot \ [sigma1^2 0; 0 sigma2^2] * rot;

f = 0 * X;
for i=1:size(X,1)
    for j=1:size(X,2)
        f(i,j) = 255 * exp(-[X(i,j) Y(i,j)]*inv(M)*[X(i,j); Y(i,j)]/2);
    end
end


