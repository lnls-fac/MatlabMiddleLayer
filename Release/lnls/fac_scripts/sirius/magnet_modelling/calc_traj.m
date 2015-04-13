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
