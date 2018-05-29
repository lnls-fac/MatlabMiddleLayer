%lnls_elastic_lifetime: calculates the rate due to elastic scattering
%of electrons with nuclei of residual gas in vacuum chamber
%
%Reference: H. Wiedemann - "Particle Accelerator Physics" - Third Edition
%Section 8.8.1 - Beam Lifetime and Vacuum (Elastic Scattering)
%
%Input:   Z   : atomic number of equivalent gas on vacuum chamber (N2)
%         T   : temperature of vacuum chamber [K]
%         E0  : nominal energy of electron [GeV]
%         theta_x: horizontal angular acceptance [rad]
%         theta_y: vertical angular acceptance [rad]
%         s_B : position where the twiss parameters were calculated [m]
%         P   : pressure profile [mbar]
%Output:  W:  vector with elastic loss rate for each position of ring
%         Wm: average loss rate due to elastic scattering over the ring
%==========================================================================
%May 24, 2018 - Murilo Barbosa Alves
%==========================================================================
function [W,Wm] = lnls_lifetime_elastic(Z,T,E0,theta_x,theta_y,s_B,P)

[s_B, uni] = unique(s_B,'first');
theta_x = theta_x(uni);
theta_y = theta_y(uni);
R = theta_y./theta_x;

qe = 1.60217662e-19; % electron charge [C]
r0 = 2.8179403227e-15; % classic electron radius [m]
c  = 2.99792458e8;  % speed of light [m/s]
epsilon0 = 8.854187817e-12; %Vacuum permittivity [F/m]
Kb = 1.3806505e-23; %Boltzmann Constant [J/K]

Const = c*qe^4/(4*pi^2*epsilon0^2*Kb); % [m, K, J, m*rad, Pa]
Const = Const*1e8/(qe*1e9)^2; % [m, K, GeV, mm*mrad, mbar];

%Fx = zeros(length(s_B),1);
%Fy = zeros(length(s_B),1);

n = 1000;
x = linspace(0, 1, n);
X = bsxfun(@times, atan(R), x);
th = repmat(theta_x, 1, n);
fx = cot(th./2./cos(X)).^2;
Fx = trapz(fx, 2) .* atan(R) / n;

Y = bsxfun(@times, (pi/2 - atan(R)), x);
Y = Y + repmat(atan(R), 1, n);
th = repmat(theta_y, 1, n);
fy = cot(th./2./sin(Y)).^2;
Fy = trapz(fy, 2) .* (pi/2 - atan(R)) / n;

W = Const*Z^2/(T*E0^2).*(Fx + Fy).*P;
Wm = trapz(s_B,W) / ( s_B(length(s_B)) - s_B(1) );

% funx  = @(theta,r) quad(@(x) cot(theta./2./cos(x)).^2,0,atan(r));
% funy  = @(theta,r) quad(@(x) cot(theta./2./sin(x)).^2,atan(r),pi/2);
% 
% respx = arrayfun(funx,theta_x,R);
% respy = arrayfun(funy,theta_y,R);
% 
% W = Const*Z^2/(T*E0^2).*(respx + respy).*P;

%{
tic
for j=1:length(s_B);
  fx{j} = @(x) cot(theta_x(j)./2./cos(x)).^2;
  fy{j} = @(x) cot(theta_y(j)./2./sin(x)).^2;
  Fx(j) = quad(fx{j},0,atan(R(j)));
  Fy(j) = quad(fy{j},atan(R(j)),pi/2);
  W(j) = Const*Z^2/(T*E0^2)*(Fx(j) + Fy(j))*P(j);
end
Wm = trapz(s_B,W) / ( s_B(length(s_B)) - s_B(1) );
toc
%}  

%{  
%Approximated model (Wiedemann)

F = pi + (R.^2+1).*sin(2.*atan(R)) + 2.*(R.^2-1).*atan(R);
W = Const*Z^2/(E0^2)/T./theta_y.^2.*F.*P;

%W = Const*Z^2/(cp^2)/T*(By./EA_y)*F.*P;
Wm = trapz(s_B,W) / ( s_B(length(s_B)) - s_B(1) );
%}