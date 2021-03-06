function plot_phase_space_caract(n_v, energy_pass, phase_pass, n_turns)
% Plots the output of sirius_commis.first_turns.bo.phase_space_caract with
% a color scheme related to the number of turns obtained for each initial
% configuration of energy deviation and longitudinal phase contained in
% each vector energy_pass and phase_pass.
%
% See also: sirius_commis.first_turns.bo.phase_space_caract

[E, Phi] = meshgrid(energy_pass, phase_pass);

ind1 = n_v < n_turns / 4;
ind2 = n_turns / 4 < n_v & n_v < n_turns / 2;
ind3 = n_turns / 2 < n_v & n_v < 3 * n_turns / 4;
ind4 = n_v > 3 * n_turns / 4;

E = E(:);
Phi = Phi(:); 
    
figure;
plot(Phi(ind1)*1e2, E(ind1)*100, '*r');
hold all
plot(Phi(ind2)*1e2, E(ind2)*100, '*m'); 
plot(Phi(ind3)*1e2, E(ind3)*100, '*b'); 
plot(Phi(ind4)*1e2, E(ind4)*100, '*k');
xlabel('Phase [cm]')
ylabel('Energy Deviation [%]')
xlim([-max(phase_pass)*1e2*1.1, max(phase_pass)*1e2*1.1]);
ylim([-max(energy_pass)*1e2*1.1, max(energy_pass)*1e2*1.1]);
grid on;
print(gcf, 'phase_space2V0.png', '-dpng', '-r300');
end

