function drds = newton_lorentz_equation(s,r)

% function drds = newton_lorentz_equation(s,r)
%
% Funcao que calcula as derivadas das variaveis dinamicas do el?tron sujeito ao campo magnetost?tico em fun??o da 
% vari?veil independente. Esta fun??o ? passada como argumento para o solver Runge-Kutta.
%
% INPUT
%   s [mm]:         comprimento de arco de trajet?ria (vari?vel independente das equs de movimento)
%   r [mm/a.]:    vetor [x;y;z;beta_x;beta_y;beta_z] com as vari?veis din?micas dependentes
%
% OUTPUT
%   drds [a./(1/mm)]: derivadas das vari?veis din?micas.
%
% Obs:
%   As equa??es de movimento do el?tron est?o escritas em um sistema de coordenadas em que a vari?vel independente ? 
%   o comprimento de arco de trajet?ria e as coordenadas din?micas s?o, em ordem x [mm], y[mm], z[mm], beta_x [a.], 
%   beta_y [a.] e beta_z[a.] de um sistema cartesiano. 
%
%   Sobre o sistema de coordenadas adotado:
%   a) Z ? a coordenada longitudinal (sentido positivo equivale ao sentido de propaga??o do feixe
%   b) Y ? a coordenada vertical (sentido positivo corresponde ? dire??o para cima)
%   c) X ? a dire??o radial-horizontal (sentido positivo corresponde ? dire??o para fora do anel)
%   Deste modo, Z = X x Y (valendo a regra da m?o direita aplicada sobre X e Y gerando Z na longitudinal)
%
%   Beta_x, beta_y e beta_z s?o as tr?s componentes de velocidade normalizadas pela velocidade escalar (constante de 
%   movimento) de modo que beta_x^2 + beta_y^2 + beta_z^2 = 1. Sendo assim, a tangente do ?ngulo da trajet?ria com 
%   rela??o ao eixo longitudinal z ? dada por (beta_x / beta_z).
%
% Equacao do movimento:
%
%   d\vec{beta}/ds = -\alpha \vec{beta} \times \vec{B}
%   com 
%   1. \vec{beta} = \vec{v} / v
%   2. \alpha = |e|c/(\beta E)/(v/c) = (1/b_rho)/(v/c)
%
% History:
%   2011-11-25: versao revisada e comentada (Ximenes).



% consulta P_CONFIG para usar rigidez magn?tica
config = getappdata(0, 'P_CONFIG');
alpha  = (1/config.b_rho/config.beta);

% variaveis dinamicas
x  = r(1);
y  = r(2);
z  = r(3);
beta_x = r(4);
beta_y = r(5);
beta_z = r(6);

% interpola campo magnetico no ponto r
field = interpolate_field([x; y; z]);
Bx = field(1);
By = field(2);
Bz = field(3);

% calcula derivadas das variaveis dinamicas
drds = zeros(6,1);   
drds(1) = beta_x;
drds(2) = beta_y;
drds(3) = beta_z;
drds(4) = - alpha * (beta_y * Bz - beta_z * By);
drds(5) = - alpha * (beta_z * Bx - beta_x * Bz);
drds(6) = - alpha * (beta_x * By - beta_y * Bx);
