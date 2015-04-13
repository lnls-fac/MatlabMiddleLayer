function sf = get_local_SerretFrenet_coord_system(rk_traj, s)

% function sf = get_local_SerretFrenet_coord_system(traj, s)
%
% Retorna par?metros que definem o sistema de coordenadas local Serret-Frenet
% em um ponto da trajet?ria.
%
% INPUT
%   traj  : estrutura com parametros da trajeteria 
%   s [mm]: comprimento de arco at? o ponto no qual o sistema SF ser? calculado
%
% OUTPUT
%   sf :    estrutura com par?metros que definem o sistema de coordenadas local Serret-Frenet
%           sf.s [mm] : comprimento de arco at? o ponto no qual o sistema SF foi calculado
%           sf.r [mm] : vetor [x;y;z] com coordenadas no sistema retangular global (sistema Runge-Kutta) 
%                       do ponto sobre o qual o sistema SF foi definido.
%           sf.p [rad]: vetor [beta_x;beta_y;beta_z] com velocidades no ponto sf.r
%           sf.t [a.] : versor tangente ? trajet?ria no ponto sf.r
%           sf.n [a.] : versor normal ? trajet?ria no ponto sf.r (apontando para fora do anel)
%           sf.k [a.] : versor que aponta na dire??o vertical (no caso de trajet?ria sobre plano horizontal)
%
% Obs:
%   Os versores t,n,k que definem o sistema de coordenadas SF obdecem aa regra da mao direita com k = t x n.
%
% History:
%   2011-11-25: versao revisada e comentada (Ximenes).

x = interp1q(rk_traj.s, rk_traj.x, s);
y = interp1q(rk_traj.s, rk_traj.y, s);
z = interp1q(rk_traj.s, rk_traj.z, s);
beta_x = interp1(rk_traj.s, rk_traj.beta_x, s);
beta_y = interp1(rk_traj.s, rk_traj.beta_y, s);
beta_z = interp1(rk_traj.s, rk_traj.beta_z, s);

sf.s = s;
sf.r = [x; y; z];                                                 % coordenadas na posi??o s da trajet?ria
sf.p = [beta_x; beta_y; beta_z];                                  % velocidades na posi??o s da trajet?ria
sf.t = [beta_x; beta_y; beta_z] / norm([beta_x; beta_y; beta_z]); % vetor tangente
sf.n = [0 0 1; 0 1 0; -1 0 0] * sf.t;                             % vetor normal
sf.k = cross(sf.t, sf.n);                                         % vetor tors?o


% function sf = get_local_SerretFrenet_coord_system(traj, s)
% % function sf = get_local_SerretFrenet_coord_system(traj, s)
% %
% % History:
% %   2011-11-25: versao revisada e comentada (Ximenes).
% 
% x = interp1q(traj.s, traj.x, s);
% y = interp1q(traj.s, traj.y, s);
% z = interp1q(traj.s, traj.z, s);
% beta_x = interp1(traj.s, traj.beta_x, s);
% beta_y = interp1(traj.s, traj.beta_y, s);
% beta_z = interp1(traj.s, traj.beta_z, s);
% 
% sf.s = s;
% sf.r = [x; y; z];                                                 % coordenadas na posicaoo s da trajet?ria
% % sf.p = [beta_x; beta_y; beta_z];                                  % velocidades na posicaoo s da trajet?ria
% sf.t = [beta_x; beta_y; beta_z] / norm([beta_x; beta_y; beta_z]); % versor tangente
% sf.n = [0 0 1; 0 1 0; -1 0 0] * sf.t;                             % versor normal
% sf.k = cross(sf.t, sf.n);                                         % versor torsao