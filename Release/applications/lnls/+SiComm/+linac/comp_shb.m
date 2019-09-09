function comp_shb(phi1, vg1, phi2, vg2)

L0_drift = 615e-3; % [m]
step = 1e-3; % [m]
nmax = round(L0_drift/step);
E0 = 0.51099895000e6;

[Phi1, E1] = sirius_commis.linac.shb(phi1, vg1, false);
[Phi2, E2] = sirius_commis.linac.shb(phi2, vg2, false);

figure; 

for i = 2:nmax
   plot(Phi1(i, :), E1, 'DisplayName', 'Config 1');
   hold on;
   plot(Phi2(i, :), E2, 'DisplayName', 'Config 2');
   hold off
   xlim([min(Phi1(1, :)), max(E1(1, :))]);
   grid on
   xlabel('Phase [deg]');
   ylabel('Energy [keV]');
   pause(1e-10);
end

legend show

end

