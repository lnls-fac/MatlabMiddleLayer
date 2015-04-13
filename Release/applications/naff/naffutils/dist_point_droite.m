function d = dist_point_droite(m1,m2,m3,pt)
%% calcul la distance entre la droite et un point pt
%% droite m1 *x + m2 *y =m3
% pt =[0 2]
% dist_point_droite(1,2,4,pt)

%% centre de la fenetre
P= [pt 0];

%vecteur directeur normalise
u = [-m2 m1 0];

if (norm(u)~=0) 
    u = u/norm(u);
end

% vecteur AP, ou A appartient a la droite et P est le centre de la fenetre
if (m1 ~= 0)
    A = [m3/m1 0 0];
elseif (m2 ~=0)
    A=[0 m3/m2 0];
else
    A=[0 0 0]
end

AP= P - A;

d = norm(cross(AP,u),2);
