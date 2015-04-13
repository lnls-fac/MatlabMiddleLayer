function induced_amplitude6D
%function induced_amplitude
%
% Plot induced amplitudes in achromat and straight section
% transported back to the beginning of the lattice
% NB: use files computed w/ solamor2.lat
%
% Written by Laurent S. Nadolski, SOLEIL 04/2004

hold_state = ishold;
hold on

%% Doesnot work for Pascale
%PATH=[getenv('HOME') '/matlab/soleil/']
PATH='/home/nadolski/matlab/soleil/';

%% amplitude induite dans les achromates
file = [PATH 'amp_ind_achromat.out']; 
[header data] = hdrload(file);
x_achromat = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;

%% amplitude induite dans sections moyennes
file = [PATH 'amp_ind_SDM.out']; 
[header data] = hdrload(file);
x_SDM = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;

%% amplitude induite dans sections courtes
file = [PATH 'amp_ind_SDC.out']; 
[header data] = hdrload(file);
x_SDC = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;

%% ampltudes induites dans sections longues
file = [PATH 'amp_ind_SDL.out']; 
[header data] = hdrload(file);
x_SDL = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;
delta = data(:,1)*100;

h=plot(delta,2*x_SDL,'k-.',delta,2*x_SDC,'k--',delta,2*x_achromat,'k-');
set(h,'LineWidth',3)
legend('SDL/SDM','SDC', 'Achromat', 'Physical')
