function synchronism_ramp()

freq = 2;
T0 = 496.8/299792458;
dt = T0:10*T0:(0.5/freq-T0);
Ei = 0.150;
Ef = 3;

[E dEdt] = energy_ramp(Ef, Ei, freq, dt);

alpha = 4e-3;

deltat = alpha*E./dEdt;

fi = figure('Units','normalized', 'Position',[0.31 0.37 0.57 0.52] );
axes1 = axes('Parent',fi,'YGrid','on','XGrid','on','FontSize',20);
hold all;
plot(E, deltat*1000);
title(axes1,'Synchromism during ramp','FontSize',20);
xlabel(axes1,'Energy [GeV]','FontSize',20);
ylabel(axes1,'Synchronism [ms]','FontSize',20);
ylim(axes1,[0 1]);
box(axes1,'on');




% deltak = alpha*Ef*2.3/1.8821./E;
% 
% the_ring = sirius_bo_lattice;
% a = findcells(the_ring,'FamName','QF');
% kf = getcellstruct(the_ring,'PolynomB',a(1),2);
% for i=1:(length(dt))
%     the_ring = setcellstruct(the_ring,'PolynomB',a,kf*(1+ deltak(i)),2);
%     [~, tunes(i,:), ~] = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom', 1e-8);
% end
% 
% fi = figure('Units','normalized', 'Position',[0.31 0.37 0.57 0.52] );
% axes1 = axes('Parent',fi,'YGrid','on','XGrid','on','FontSize',20);
% hold all;
% plot(E, [(tunes(:,1)-tunes(1,1)) (tunes(:,2)-tunes(1,2))]);
% title(axes1,'Synchromism during ramp','FontSize',20);
% xlabel(axes1,'Energy [GeV]','FontSize',20);
% ylabel(axes1,'Synchronism [ms]','FontSize',20);
% ylim(axes1,[0 1]);
% box(axes1,'on');

