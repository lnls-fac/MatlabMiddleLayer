function [s2 bx2 bz2 etax2 etaz2 ax2 az2] = tracy_readsigma(file,cell)
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

DisplayFlag = 1;

if nargin == 0
    file = 'sigma.out';
end

if (nargin ==2 && ~isempty(cell))
    cell = 4;
else
    cell = 1;
end

[dummy s bx mux by muy sqrtSx sqrtSxp sqrtSy sqrtSyp sxy twist delta sqrtSxoSy sqrtexbx sqrteyby sqrtsI sqrtsII sIII sqrtsIosII] = ...
    textread(file,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',4);
[s idx] = unique(s);
bx = bx(idx); by = by(idx);
mux = mux(idx); muy = muy(idx);
sqrtSx = sqrtSx(idx);
sqrtSxp = sqrtSxp(idx);
sqrtSy = sqrtSy(idx);
sqrtSyp = sqrtSyp(idx);
sxy = sxy(idx);
delta = delta(idx);
sqrtSxoSy = sqrtSxoSy(idx);
sqrtexbx = sqrtexbx(idx);
sqrteyby = sqrteyby(idx);
sqrtsI = sqrtsI(idx); 
sqrtsII = sqrtsII(idx);
sIII = sIII(idx);
twist = twist(idx);
sqrtsIosII = sqrtsIosII(idx); 

%invariant
epsX = sqrtexbx.*sqrtexbx./bx;
epsY = sqrteyby.*sqrteyby./by;

if 0
    [s2 bx2 by2 etax2 etay2 ax2 ay2] = tracy_readtwiss;

    % projected emittance ?? look like invariant
    epsXp = (sqrtSx.*sqrtSx-etax2.*etax2*1.016e-3*1.016e-3)./bx2;
    epsYp = (sqrtSy.*sqrtSy-etay2.*etay2*1.016e-3*1.016e-3)./by2;
%     epsXp = (sqrtsI.*sqrtsI-etax2.*etax2*1.016e-3*1.016e-3)./bx2;
%     epsYp = (sqrtsII.*sqrtsII-etay2.*etay2*1.016e-3*1.016e-3)./by2;
    fprintf('Mean projected emittance epsX = %e (nm.rad) epsY = %e (nm.rad)\n', mean(epsX), mean(epsY));
    fprintf('Entrance projected emittance epsX = %e (nm.rad) epsY = %e (nm.rad)\n', epsX(1), epsY(1));
    fprintf('Mean projected emittance ratio  = %e\n', mean(epsY./epsX));
    figure
    subplot(2,1,1)
    plot(s,epsXp); hold on
    plot(s,epsYp); axis tight;
    subplot(2,1,2)
    plot(s,epsYp./epsXp*100); axis tight;
end

%%
if DisplayFlag
    h = figure(21)
    cla
    plot(s,bx,'r.',s,by,'b.');
    %drawlattice(0,2,gca)
    %plotlattice(0,2)
    legend('\beta_x','\beta_z')
    xaxis([0 s(end)/cell])
    title('Optical functions')
    xlabel('s (m)')
    datalabel on
    %%
    %% interpolation
    si    = (s(1):0.2:s(end))';
    bxi   = interp1(s,bx,si,'pchip');
    byi   = interp1(s,by,si,'pchip');

    hold on;
    plot(si,bxi,'r-',si,byi,'b-');
    drawlattice(0,2,gca)
    xaxis([0 s(end)/cell])
    title('Optical functions')
    xlabel('s (m)')
    
    figure
    plot(s,epsY./epsX*100)
    ylabel('Coupling value (%)')
    axis tight

    figure
    subplot(2,1,1)
    plot(s,sqrtsI,s,sqrtsII)
    ylabel('Beam sizes (%)')
    axis tight
    subplot(2,1,2)
    plot(s,sqrtsIosII)
    ylabel('Beam size ratio (%)')
    axis tight

    figure
    subplot(2,2,2)
    plot(s,epsX*1e9)
    ylabel('H-emittance (nm.rad)')
    axis tight
    subplot(2,2,4)
    plot(s,epsY*1e9)
    ylabel('V-emittance (nm.rad)')
    axis tight
    subplot(2,2,1)
    plot(s,twist*180/pi)
    ylabel('twist (degree)')
    axis tight
    subplot(2,2,3)
    plot(s,sqrtSx*1e6,'b', s, sqrtSy*1e6,'g')
    ylabel('Beam sizes (µm)')
    axis tight
end
