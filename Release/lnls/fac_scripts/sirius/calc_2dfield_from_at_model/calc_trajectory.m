function r = calc_trajectory(path_length, init_position, runge_kutta_flags)
% function traj = calc_trajectory(path_length, init_position)
%
% INPUT
%   path_length [mm]:       comprimento total de trajet?ria. A metade do comprimento em s<0 e metade em s>0.
%   initial_pos [mm/a.]:    condicoes iniciais [x;y;z;beta_x;beta_y;beta_z] em s=0mm
%
% OUTPUT
%   traj:   estrutura com dados referentes aa trajetoria calculada. Seus campos sao:
%
%           traj.init_position: vetor com condicao inicial em s=0mm.
%
%           traj.traj.s:        vetor com posicao s [mm] ao longo da trajet?ria;
%           traj.traj.x:        vetor com coordenada x [mm] ao longo da trajet?ria;
%           traj.traj.y:        vetor com coordenada y [mm] ao longo da trajet?ria;
%           traj.traj.z:        vetor com coordenada z [mm] ao longo da trajet?ria;
%           traj.traj.beta_x:   vetor com velocidade beta_x [mm] ao longo da trajet?ria;
%           traj.traj.beta_y:   vetor com velocidade beta_y [mm] ao longo da trajet?ria;
%           traj.traj.beta_z:   vetor com velocidade beta_z [mm] ao longo da trajet?ria;
%           traj.traj.theta_x:  vetor com ?ngulo de deflex?o horizontal [rad] ao longo da trajet?ria;
%           traj.traj.theta_y:  vetor com ?ngulo de deflex?o vertical [rad] ao longo da trajet?ria;
%           traj.traj.bx:       vetor com componente bx [T] do campo sobre a trajet?ria;
%           traj.traj.by:       vetor com componente by [T] do campo sobre a trajet?ria;
%           traj.traj.bz:       vetor com componente bz [T] do campo sobre a trajet?ria;
%
%           traj.traj_center.s: posi??o do arco [mm] do centro da trajet?ria (que divide em duas partes com deflex?es id?nticas)
%           traj.traj_center.x: posi??o horizontal [mm] do centro da trajet?ria (que divide em duas partes com deflex?es id?nticas)
%           traj.traj_center.y: posi??o vertical [mm] do centro da trajet?ria (que divide em duas partes com deflex?es id?nticas)
%           traj.traj_center.z: posi??o longitudinal [mm] do centro da trajet?ria (que divide em duas partes com deflex?es id?nticas)
%
%           traj.power:         pot?ncia total (Watts) irradiada sobre a trajet?ria calculada.
%
% History:
%   2011-11-25: versao revisada e comentada (Ximenes).

% Runge-Kutta downstream
t = calc_traj([0  path_length], init_position, runge_kutta_flags);

% registers coords of tracked particle
r.s = t(:,7);
r.x = t(:,1);
r.y = t(:,2);
r.z = t(:,3);
r.beta_x  = t(:,4);
r.beta_y  = t(:,5);
r.beta_z  = t(:,6);
r.angle_x = atan(r.beta_x ./ r.beta_z);
r.angle_y = atan(r.beta_y ./ r.beta_z);


function traj = calc_traj(s, p1, runge_kutta)

% coordenadas iniciais
x      = p1(1);
y      = p1(2);
z      = p1(3);
beta_x = p1(4);
beta_y = p1(5);
beta_z = p1(6);

% calcula orbita de referencia a partir do centro mecanico do dipolo
options = odeset('RelTol', runge_kutta.RelTol,'AbsTol', runge_kutta.AbsTol,'MaxStep', runge_kutta.MaxStep);
[T,P] = ode45(@newton_lorentz_equation, s, [x y z beta_x beta_y beta_z], options);
traj = [P T];

