
function [s_intersection, x_perp, idx] = find_intersection_point(traj, sf_coord)
% function s_intersection = find_intersection_point(traj, sf_coord)
%
% finds s position in 'traj' at which normal line defined in 'sf_coord' intersects the trajectory
%
% Obs:
%   O algortimo funciona da seguinte maneira: a trajet?ria ? composta por uma sequencia ordenada em s de pontos:
%   p_1, p_2, ..., p_n. Para cada par de pontos consecutivos (p_i,p_(i+1)) calcula-se o ponto em que a reta que os
%   une cruza a reta definida pela dire??o normal (versor 'sf_coord.n'). Para isto calculam-se os par?metros 
%   (alpha,beta) de forma a garantir que
%                                       sf_coord.r + alpha * sf_coord.n = p_i + beta * (p_(i+1) - p_i)
%   o par (alpha,beta) define o ponto de intersecao das duas retas.  Se 0 <= beta <= 1 ent?o a reta normal definida
%   por sf_coord.n cruza a trajetoria em um ponto entre p_i e p_(i+1).
%   idx e o indice do ponto de intersecao da trajetoria com a reta
%   perpendicular.
%   
% History:
%   2014-09-18: retorna 'idx' agora.
%   2011-11-25: vers?o revisada e comentada (Ximenes).

p0 = [sf_coord.r(1); sf_coord.r(3)];
n  = [sf_coord.n(1); sf_coord.n(3)];
for i=1:(size(traj.s)-1)
    p1  = [traj.x(i); traj.z(i)];
    p2  = [traj.x(i+1); traj.z(i+1)];
    M   = [n(1) (p1(1)-p2(1)); n(2) (p1(2) - p2(2))];
    b   = [(p1(1) - p0(1)); (p1(2) - p0(2))];
    res = M \ b;
    alpha(i) = res(1);
    beta(i)  = res(2);
end
idx = find((beta >= 0) & (beta <= 1),1);
s1 = traj.s(idx);
s2 = traj.s(idx+1);
x_perp = alpha(idx);
s_intersection  = s1 + beta(idx) * (s2 - s1);