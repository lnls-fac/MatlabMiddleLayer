function equilibrium_parameters()

freq = 2;
T0 = 496.8/299792458;
dt = 0.0:10*T0:(0.5/freq);
gama0 = 150/0.511;
gamainf = 3e3/0.511;

[gamat dgamatdt]   =  energy_ramp(gamainf, gama0, freq, dt(1:end));

%rampa linear:
% tf = sum(dt<0.2);
% Vi = 200e3;
% Vf = 1000e3;
% Vramp  = Vi+(Vf-Vi)/dt(tf)*dt(1:tf); 
% V =  [Vramp, Vf*ones(1,length(dt)-tf)];
%rampa com over-voltage constante:
rho0 = 1.152*50/2/pi;
q = 1.5;
Vf = 1e3;
Vi = 0.2e3;
U0 = 88.5*(0.511e-3*gamat).^4/rho0;
V = q*U0 + Vi;
ind = V >Vf;
V(ind) = Vf;

%% EMITTANCES
%Horizontal
emitx = 3.7;
emit0   = 50e3/gama0;
taux = 10.5e-3;

f = dgamatdt./4/gamat + 2/taux*(gamat/gamainf).^3;
g = 2/taux*(gamat/gamainf).^5;

Tspan = [dt(1) dt(end)]; 
IC = emit0/emitx; % Initial Condition
[Tx X] = ode45(@(t,y) myode(t,y,dt,f,dt,g),Tspan,IC); % Solve ODE

%Vertical
emity = 3.7*0.1;
emit0   = 50e3/gama0;
tauy = 12.7e-3;

f = dgamatdt./4/gamat + 2/tauy*(gamat/gamainf).^3;
g = 2/tauy*(gamat/gamainf).^5;

Tspan = [dt(1) dt(end)]; 
IC = emit0/emity; % Initial Condition
[Ty Y] = ode45(@(t,y) myode(t,y,dt,f,dt,g),Tspan,IC); % Solve ODE


%% ENERGY SPREAD
sigma0 = 0.5;
sigmainf = 0.089;
tamortenerinf = 7.1e-3;

f = - dgamatdt./4/gamat + 1/tamortenerinf*(gamat/gamainf).^3;
g = 1/tamortenerinf*(gamat/gamainf).^7;

Tspan = dt; 
IC = sigma0/sigmainf; % Initial Condition
[T En] = ode45(@(t,y) myode2(t,y,dt,f,dt,g),Tspan,IC); % Solve ODE


%% Energy Acceptance
rho0 = 1.152*50/2/pi;
alphac = 7.014e-4;
h  = 828;
U0 = 88.5*(0.511e-3*gamat).^4/rho0;
q  = V./U0;
F  = 2*(sqrt(q.^2 - 1) - acos(1./q));

eneraccept = sqrt(U0/pi/alphac/h/0.511e3./gamat.*F);

%% Plot Results

fi = figure('Units','normalized', 'Position',[0.31 0.17 0.77 0.72] );

subplot(3,1,1, 'Parent', fi)
[AX, H1, H2] = plotyy(dt, 0.511e-3*gamat, dt, V/1000);
title('Plot of RF Voltage and Energy ramp versus time');
xlabel('Time [s]');
set(get(AX(1),'Ylabel'),'String','Energy [GeV]') 
set(get(AX(2),'Ylabel'),'String','V_{rf} [MeV]')

subplot(3,1,2, 'Parent',fi)
[AX, H1, H2] = plotyy(0.511e-3*energy_ramp(gamainf, gama0, freq, Tx), emitx*X, ...
    0.511e-3*energy_ramp(gamainf, gama0, freq, Ty), emity*Y);
title('Plot of emittances in function of energy');
xlabel('energy [GeV]');
set(get(AX(1),'Ylabel'),'String','\epsilon_x(t) [nm.rad]') 
set(get(AX(2),'Ylabel'),'String','\epsilon_y(t) [nm.rad]')


subplot(3,1,3, 'Parent',fi)
plot(0.511e-3*gamat, [100*eneraccept;sigmainf*En']);
title('Plot of Energies Acceptance and Spread versus ramp');
xlabel('energy [GeV]'); ylabel('%');
legend('Energy Acceptance', 'Energy Spread');


   

function dydt = myode(t,y,ft,f,gt,g)
f = interp1(ft,f,t); % Interpolate the data set (ft,f) at time t
g = interp1(gt,g,t); % Interpolate the data set (gt,g) at time t
dydt = -f.*y + g; % Evalute ODE at time t

function dydt = myode2(t,y,ft,f,gt,g)
f = interp1(ft,f,t); % Interpolate the data set (ft,f) at time t
g = interp1(gt,g,t); % Interpolate the data set (gt,g) at time t
dydt = -f.*y + g./y; % Evalute ODE at time t
