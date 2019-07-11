function shb_scan()
    close all
    c = 299792458;
    E0 = 0.51099895000e6;
    L0_drift = 615e-3;
    f = 499.658e6;
    lambda = c/f;
    step = 1e-3;
    nmax = round((L0_drift)/step) + 1;
    % len = linspace(0, L0_drift, nmax);
    npoint = 101;
    
    phic_min = -pi/2;
    phic_max = pi/2;
    phic_np = 73;
    phi_center_lin = linspace(phic_min, phic_max, phic_np);
    bun_len = pi;
    
    Vg_min = 10;
    Vg_max = 40;
    Vg_np = 41;
    Vg_lin = linspace(Vg_min, Vg_max, Vg_np) .* 1e3;
    
    
%     phi0 = 8.57 * pi/180;
%     phi_v = linspace(-pi/2, pi/2, 51) + phi0;
%     mu = (lambda/2/pi/L0_drift .* phi_v + 1/beta0);
%     % Voltage = (E_min - E0*sqrt(mu./(mu-1)))./sin(phi_v);
%     Voltage = (E_min - E0 .* mu ./ sqrt(mu.^2 - 1))./sin(phi_v);
%     std_vol = nanstd(Voltage);
%     mean_vol = nanmean(Voltage);
%     % mean_vol = 22.8973e3;
%     
%     gamma = (E_min - mean_vol * sin(phi_v))./ E0;
%     beta = sqrt(1 - 1./gamma.^2);
%     alpha = 2*pi/lambda .* (1/beta0 - 1./beta);
%     phif = phi_v + L0_drift * alpha;
%     bunch = std(phi_v)/std(phif);

    for p = 1:Vg_np
        Vg = Vg_lin(p);

        for k = 1:phic_np
            phi_min = phi_center_lin(k) - bun_len/2;
            phi_max = phi_center_lin(k) + bun_len/2;
            phi_lin = linspace(phi_min, phi_max, npoint);
            Emin = E0 + 90e3*(1+0*lnls_generate_random_numbers(1, 1, 'norm', 1, 0));
            gamma0 = Emin/E0;
            beta0 = sqrt(1 - 1/gamma0^2);

            for j = 1:npoint
                phi(1, j) = phi_lin(j);
                E(j) = Emin - Vg * sin(phi(1, j));
                
                gamma = E(j)/E0;
                beta = sqrt(1 - 1/gamma^2);

%                 for i = 2:nmax
%                    phi(i, j) = phi(i-1, j) +  step * (2 * pi / lambda) * (1/beta0 - 1/beta);
%                 end
                phi(2, j) = phi(1, j) + L0_drift * (2 * pi / lambda) * (1/beta0 - 1/beta);
                hold on
                % plot(phi(:, j) * 180/pi, vel(:));
                % dt(j) = v_final(j) * c / L0;
                % plot(len(idx_shb:end) - L0_SHB, phi(idx_shb:end, j) * 180 / pi); 
                % plot(len, phi(:, j) * 180 / pi); 
                %  plot(phi(:, j), E(:, j));
                
            end

            % xlim([len(idx_shb), len(end)]);
            % xlim([0, L0_drift])
            % ylim([phi_min, phi_max]);
            ph2t = 1e9/f/2/pi;
%             t0 = abs(max(phi(1, :)) - min(phi(1, :))) * ph2t;
%             tf = abs(max(phi(end, :)) - min(phi(end, :))) * ph2t;
%             fprintf('Initial bunch duration: %f ns \n', t0)
%             fprintf('Final bunch duration: %f ns \n', tf)
%             fprintf('Bunching factor %f \n', t0/tf)
            t0 = dot(phi(1, :), phi(1, :));
            tf = dot(phi(end, :), phi(end, :));
            bun(p, k) = sqrt(t0/tf);
        end
        fprintf('%i out of %i \n', p, Vg_np);

        hold on;
        grid on
        txt = ['Vg = ', num2str(Vg*1e-3), ' kV'];
        figure(1)
        plot(phi_center_lin * 180/pi, bun(p, :), 'DisplayName', txt, 'Color', [(p-Vg_np)/(1-Vg_np), 0, (p - 1)/(Vg_np -1)], 'LineWidth', 2)
        drawnow()
        hold off;
    end

    legend show
    xlabel('SHB Phase [deg]')
    ylabel('Bunching Factor');

    for l = 1:phic_np
        hold on;
        txt = ['Phi = ', num2str(phi_center_lin(l)), ' deg'];
        figure(2)
        plot(Vg_lin * 1e-3, bun(:, l), 'DisplayName', txt, 'Color', [0, (l - 1)/(phic_np -1), (l - phic_np)/(1-phic_np)], 'LineWidth', 2);
        drawnow()
        % pause(.5)
    end
    
    [X, Y] = meshgrid(phi_center_lin, Vg_lin*1e-3);
    Z = bun;
    close all
    mesh(X, Y, Z);
    grid on 
    xlabel('Phase [deg]')
    ylabel('Voltage [kV]')
    zlabel('Bunching factor')
    save shb_energy_dist.mat phi_center_lin Vg_lin bun X Y Z
    
%     grid on
%     legend show    
%     xlabel('SHB Voltage [kV]')
%     ylabel('Bunching Factor');
end

