function plottwissT(file,cell)
%function plottwissT(file,cell)
%
% plot Twiss function from Tracy output file
% cell = 1 show all the ring
% cell = 4 show one out of 4 periods

%
% Written by Laurent S. Nadolski, 03/04, SOLEIL

if nargin == 0
  file = 'linlat.out';
end

if (nargin ==2 && ~isempty(cell))
    cell = 4;
else
    cell = 1;
end

[dummy s ax bx mux etax etaxp az bz muz etaz etazp] = ...
 textread(file,'%s %f %f %f %f %f %f %f %f %f %f %f','headerlines',4);
[s2 idx] = unique(s);
ax2 = ax(idx); az2 = az(idx);
bx2 = bx(idx); bz2 = bz(idx);
etax2 = etax(idx); etaz2 = etaz(idx);

%%
h = figure(21);
cla
% beta functions
plot(s,bx,'b-',s,bz,'r-');
hold on;
% eta functions
plot(s,10*etax,'g-',s,10*etaz,'k--')
% draw lattice
drawlattice(0,2,gca)
legend('\beta_x','\beta_z','10\eta_x','10\eta_z')
xaxis([0 s(end)/cell])
title('Optical functions')
xlabel('s (m)')
datalabel on

%% interpolation
si    = (s2(1):0.2:s2(end))';
bxi   = interp1(s2,bx2,si,'pchip');
bzi   = interp1(s2,bz2,si,'pchip');
etaxi = interp1(s2,etax2,si,'pchip');
etazi = interp1(s2,etaz2,si,'pchip');

figure(22)
cla
hold on;
plot(si,bxi,'b-',si,bzi,'r-');
plot(si,10*etaxi,'g-',si,10*etazi,'k--')
drawlattice(0,2,gca)
legend('\beta_x','\beta_z','10\eta_x','10\eta_z')
xaxis([0 s(end)/cell])
title('Optical functions with interpolation')
xlabel('s (m)')

