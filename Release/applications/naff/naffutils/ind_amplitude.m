function ind_amplitude
%function induced_amplitude
%
% Plot induced amplitudes in achromat and straight section
% transported back to the beginning of the lattice
% NB: use files computed w/ solamor2.lat
%

% Written by Laurent S. Nadolski, SOLEIL 04/2004
% Updated September 2009 with last lattice 

hold_state = ishold;
hold on

%% Doesnot work for Pascale
%PATH=[getenv('HOME') '/matlab/soleil/']
PATH='/home/nadolski/matlab/soleil/';

%% amplitude induite dans les achromates
%file = [PATH 'amp_ind_achromat.out']; 
file = [PATH 'amp_ind_achromat_soleil2009.out']; 
[header data] = hdrload(file);
x_achromat = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;
%x_achromat = sqrt(data(:,8).*data(:,4)).*(data(:,1))*1e3;

%% amplitude induite dans sections moyennes
%file = [PATH 'amp_ind_SDM.out']; 
file = [PATH 'amp_ind_SDM_soleil2009.out']; 
[header data] = hdrload(file);
x_SDM = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;
%x_SDM = sqrt(data(:,8).*data(:,4)).*(data(:,1))*1e3;

%% amplitude induite dans sections courtes
%file = [PATH 'amp_ind_SDC.out']; 
file = [PATH 'amp_ind_SDC_soleil2009.out']; 
[header data] = hdrload(file);
x_SDC = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;
%x_SDC = sqrt(data(:,8).*data(:,4)).*(data(:,1))*1e3;

%% amplitudes induites dans sections longues
%file = [PATH 'amp_ind_SDL.out']; 
file = [PATH 'amp_ind_SDL_soleil2009.out']; 
[header data] = hdrload(file);
x_SDL = sqrt(data(:,8).*data(:,4)).*abs(data(:,1))*1e3;
%x_SDL = sqrt(data(:,8).*data(:,4)).*(data(:,1))*1e3;
delta = data(:,1)*100;


%h=plot(delta,x_SDL,'k-.',delta,x_SDC,'k--',delta,x_achromat,'k-',[delta(delta<0); 0; 0; delta(delta>0)], [-(20+x_SDL(delta<0)); -20; 35; 35-x_SDL(delta>0)],'r:');
h=plot(delta,x_SDL,'k-.',delta,x_SDC,'k--',delta,x_achromat,'k-',delta,min(20-x_SDL,35-x_SDL),'r:');
%h=plot(delta,x_SDL,'k-.',delta,x_SDM,'c--',delta,x_SDC,'k--',delta,x_achromat,'k-',delta,min(20-x_SDL,35-x_SDL),'r:');
%h=plot(delta,x_SDL,'g-.',delta,x_SDC,'g--',delta,x_achromat,'g-',delta,20-x_SDL,'g:');
set(h,'LineWidth',3)
legend('SDL/SDM','SDC', 'Achromat', 'Physical')
