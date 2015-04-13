function eddy_current()

% Define energy ramp
freq = 2;
dt = (0.0:0.0001:0.5)/freq;
gama0 = 150/0.511;
gamainf = 3e3/0.511;
L_dip = 1.152;

rho0 = L_dip*50/2/pi;

[gamat dgamatdt] =  energy_ramp(gamainf, gama0, freq, dt(1:end));


the_ring = sirius_bo_lattice;
mu0 = 4*pi*1e-7;
condut = 1.35e6; % aco inox 316L austensitico 
hgap = 0.028/2;
a = 11.7e-3; % half width of vacuum chamber
b = 11.700001e-3; % half height 
d = 1.0e-3; % espessura
F = 1/2*(1 + b^2*asinh(sqrt(a^2-b^2)/b)/a/sqrt(a^2-b^2));
B = gamat*0.511e3/0.299792458/rho0;
dBdt = dgamatdt*0.511e3/0.299792458/rho0;

%Hemmie G. Rosbach J. Eddy Current Effects in the DESYII Dipole Vacuum Chamber
% 3-3-injector-v11q-FINAL    booster for Synchrotrons - Exemplified by ASP
deltaK2 = L_dip*(1/2)*F*mu0*condut*d/hgap./(rho0*B).*dBdt;

%Shafer, Fermilab report RM-991
% candle - Energy ramp and related effects
r = 17.5e-3;
deltak_norm = -7/16*mu0*condut*d*r*dgamatdt./gamat;
r = 11.7e-3;
deltak_norm_dip = -7/16*mu0*condut*d*r*dgamatdt./gamat;


a = findcells(the_ring,'FamName','B');
a = a(7:14:end); % dipolo esta seguimentado em 14 pedaços;
bst = getcellstruct(the_ring,'PolynomB',a(1),3);
L = getcellstruct(the_ring,'Length',a(1));
for i=0:(length(dt)/50)
    the_ring = setcellstruct(the_ring,'PolynomB',a,bst + deltaK2(1 + i*50)/L,3);
    [~, ~, chrom(i+1,:)] = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom', 1e-8);
end
the_ring = setcellstruct(the_ring,'PolynomB',a,bst,3);


a = findcells(the_ring,'FamName','QF');
kf = getcellstruct(the_ring,'PolynomB',a(1),2);
for i=0:(length(dt)/50)
    the_ring = setcellstruct(the_ring,'PolynomB',a,kf*(1+ deltak_norm(1 + i*50)),2);
    [~, tunes(i+1,:), ~] = twissring(the_ring, 0, 1:length(the_ring)+1, 'chrom', 1e-8);
end
the_ring = setcellstruct(the_ring,'PolynomB',a,kf,2);



fi = figure('Units','normalized', 'Position', [0.31 0.37 0.57 0.52]);
axes1 = axes('Parent',fi,'FontSize',20);
box(axes1,'on');
hold(axes1,'all');
plot(0.511e-3*gamat(1:50:end),[chrom(:,1)-1*chrom(1,1) chrom(:,2)-1*chrom(1,2)],'Parent',axes1);
title('Chromaticity dependence on dipoles eddy current effect', 'FontSize',20);
xlabel('energy [GeV]', 'fontSize',20); ylabel('\Delta\xi', 'FontSize',20);
legend('\Delta\xi_x', '\Delta\xi_y');

fi2 = figure('Units','normalized', 'Position', [0.31 0.37 0.57 0.52]);
axes2 = axes('Parent',fi2,'FontSize',20);
box(axes2,'on');
hold(axes2,'all');
plot(0.511e-3*gamat(1:50:end),[(tunes(:,1)-tunes(1,1)) (tunes(:,2)-tunes(1,2))],'Parent',axes2);
title('Tune variation dependence on dipoles eddy current effect', 'FontSize',20);
xlabel('energy [GeV]', 'fontSize',20); ylabel('\Delta\nu', 'FontSize',20);
legend('\Delta\nu_x', '\Delta\nu_y');

