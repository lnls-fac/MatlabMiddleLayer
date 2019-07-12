function [Phi, Energy] = shb(phi_center, Vg_in, plot_flag)
    close all
    c = 299792458; % [m/s]
    E0 = 0.51099895e6; % [eV]
    % m0 = 9.109e-31;
    % q0 = 1.60217662e-19;
    L0_drift = 615e-3; % [m]
    f = 499.658e6; % [Hz]
    lambda = c/f; % [m]
    step = 1e-3; % [m]
    nmax = round(L0_drift/step) + 0 * 1;
    npoint = 51;
    bun_len = 180;
    
    phi_min = phi_center - bun_len/2;
    phi_max = phi_center + bun_len/2;
    phi_lin = linspace(phi_min, phi_max, npoint).* (pi/180);
    Vg = Vg_in * 1e3;
    Emin = E0 + 90e3;
    gamma0 = Emin/E0;
    beta0 = sqrt(1 - 1/gamma0^2);
    len = linspace(0, L0_drift, nmax);
    
    if plot_flag
        figure;
    end
    
    for j = 1:npoint
        phi(1, j) = phi_lin(j);
        E(j) = Emin - Vg * sin(phi(1, j));
        gamma = E(j)/E0;
        beta = sqrt(1 - 1/gamma^2);

        for i = 2:nmax
           phi(i, j) = phi(i-1, j) +  step * (2 * pi / lambda) * (1/beta0 - 1/beta);
        end
        
        if plot_flag
            hold on
            grid on
            figure(1)
            plot(len, phi(:, j) * 180 / pi, '-b'); 
        end
    end
    
    if plot_flag
        xlim([0, L0_drift]);
        ylim([phi_min, phi_max]);
        ylabel('Phase [deg]')
        xlabel('Length [m]');

        for i = 2:nmax
           figure(2)
           plot(phi(i, :)*180/pi, (E - E0)*1e-3); 
           xlim([phi_min, phi_max]);
           grid on
           xlabel('Phase [deg]');
           ylabel('Energy [keV]');
           pause(1e-16);
        end
    end
    
    Phi = phi.*180/pi;
    Energy = (E - E0)*1e-3;
    
    ph2t = 1 / (2 * pi * f);
    % t0 = abs(max(phi(1, :)) - min(phi(1, :))) * ph2t;
    % tf = abs(max(phi(end, :)) - min(phi(end, :))) * ph2t;
%     t0 = std(phi(1, :)) * ph2t;
%     tf = std(phi(end, :)) * ph2t;
    t0 = sqrt(dot(phi(1, :), phi(1, :))) * ph2t;
    tf = sqrt(dot(phi(end, :), phi(end, :))) * ph2t;
    phif = abs(max(phi(end, :)) - min(phi(end, :))) * 6 * 180/pi;
    fprintf('Initial bunch duration: %f ns \n', t0 * 1e9)
    fprintf('Final bunch duration: %f ns \n', tf * 1e9)
    fprintf('Final bunch phase: %f deg \n', phif)
    fprintf('Bunching factor %f \n', t0/tf)
end

