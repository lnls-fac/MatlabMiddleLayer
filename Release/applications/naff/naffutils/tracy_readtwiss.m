function [s2 bx2 bz2 etax2 etaz2 ax2 az2] = tracy_readtwiss(file,cell)
%function tracy_readtwiss(file,cell) - Plot Twiss functions from TRacy output file
%
%  OUPUTS
%  1. s2 - s-position alon the ring
%  2. bx2 - Horizontal beta function
%  3. bz2 - Vertical beta function
%  4. etax2 - Horizontal dispersion
%  5. etaz2 - Vertical dispersion
%  6. ax2 - Horizontal alpha function
%  7. az2 - Vertical alpha function
%
% cell = 1 show all the ring
% cell = 4 show one out of 4 periods

%
%% Written by Laurent S. Nadolski, 27/09/08, SOLEIL

DisplayFlag = 0;

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
if DisplayFlag
    h = figure(21)
    cla
    plot(s,bx,'r-',s,bz,'b-');
    hold on;
    plot(s,10*etax,'g-',s,10*etaz,'k--')
    drawlattice(0,2,gca)
    %plotlattice(0,2)
    legend('\beta_x','\beta_z','10\eta_x','10\eta_z')
    xaxis([0 s(end)/cell])
    title('Optical functions')
    xlabel('s (m)')
    datalabel on
    %%
    %% interpolation
    si    = (s2(1):0.2:s2(end))';
    bxi   = interp1(s2,bx2,si,'pchip');
    bzi   = interp1(s2,bz2,si,'pchip');
    etaxi = interp1(s2,etax2,si,'pchip');
    etazi = interp1(s2,etaz2,si,'pchip');

    figure(22)
    cla
    hold on;
    plot(si,bxi,'r-',si,bzi,'b-');
    plot(si,10*etaxi,'g-',si,10*etazi,'k--')
    drawlattice(0,2,gca)
    legend('\beta_x','\beta_z','10\eta_x','10\eta_z')
    xaxis([0 s(end)/cell])
    title('Optical functions')
    xlabel('s (m)')
end
