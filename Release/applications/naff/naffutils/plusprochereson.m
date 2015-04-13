function str = plusprochereson(pt,tab)
% function str = plusprochereson(pt,tab)
% Cherche la droite definie dans tab la plus proche du point pt

d= []; 
for k=1:size(tab,1)
    d(k) = dist_point_droite(tab(k,1),tab(k,2),tab(k,3), pt);
end
[a ai]=min(d);
k=ai;

str = sprintf('%d fx + %d fz = %d', tab(k,1), tab(k,2), tab(k,3));
fprintf('Resonance: %d fx + %d fz = %d\n', tab(k,1), tab(k,2), tab(k,3));
