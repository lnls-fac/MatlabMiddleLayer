alpha = 7e-4;
E0 = 3;
T0 = 518.25/299792458;
wh = 864*2*pi/T0;
rho0 = 1.952*50/2/pi;
U0 = 493 %88.5*(E0).^4/rho0;
V = 2500;


delta = (-0.01:0.0001:0.01)*5;
tau = (-0.30:0.001:0.30)/299792458;
[T D] = meshgrid(tau,delta);


for V = 2000:50:2500
q = V/U0;
phi = 1/2*alpha^2*D.^2 + alpha*U0/E0/1e6/T0*(q/wh*(1-cos(wh.*T))-T);
contour(T, D, phi,10);
sleep(0.05);
end

