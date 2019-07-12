function [gbest, k, f_best] = pso(dim, npart, niter, X, Y, Z)

    % sirius_commis.common.initializations();
    w = 0.7984;
    c1 = 1.49618;
    c2 =  c1;
    
    self.c = 299792458; % [m/s]
    self.E0 = 0.51099895e6; % [eV]
    self.L0_drift = 615e-3; % [m]
    self.f = 499.658e6; % [Hz]
    self.lambda = self.c/self.f; % [m]
    self.step = 1e-3; % [m]
    self.nmax = round(self.L0_drift/self.step) + 0 * 1;
    self.npoint = 51;
    self.bun_len = pi;
    
    self.upper_limits = [pi, 40e3];
    self.lower_limits = [-pi, 10e3];
    max_delta = [pi, 10e3];
    min_delta = [0, 0];
    dlim = self.upper_limits - self.lower_limits;
    
    gcf();
    
    targ = 7.210493275086779;
    
    for d = 1:dim    
        for i = 1:npart
            x0(i, d) = dlim(d) * rand() + self.lower_limits(d);
            v0(i, d) = 0;
            pbest(i, d) = x0(i, d);
        end
    end
    
    for i = 1:npart
        f(i) = fig_merit(self, squeeze(x0(i, :)));
    end
    
    [~, imin] = min(f);
    gbest = repmat(squeeze(x0(imin, :)), npart, 1);
    
    for k = 1:niter
       xold = x0;
       for i = 1:npart
          r1 = rand();
          r2 = rand();
          v_ind(i, :) = pbest(i, :) - x0(i, :);
          v_col(i, :) = gbest(i, :) - x0(i, :);
          v0(i, :) = w .* v0(i, :) + (c1 * r1) .* v_ind(i, :) + (c2 * r2) .* v_col(i, :);
          f_old(i) = fig_merit(self, squeeze(x0(i, :)));
          x0(i, :) = x0(i, :) + v0(i, :);
          x0(i, :) = set_lim(self, x0(i, :));
          f_new(i) = fig_merit(self, squeeze(x0(i, :)));

          if f_new(i) < f_old(i)
             pbest(i, :) = x0(i, :);
          end
       end
       
       [~, imin] = min(f_new);
       gbest = repmat(squeeze(pbest(imin, :)), npart, 1);
       
       hold off;
       % quiver(xold(:,1), xold(:, 2)*1e-3, v0(:, 1), v0(:, 2)*1e-3);
       % hold on
       % plot(xold(:, 1), xold(:, 2)*1e-3, 'o', 'MarkerSize', 5, 'MarkerEdgeColor','blue', 'MarkerFaceColor', [0, 0, 1]);
       mesh(X, Y, Z);
       hold on;
       scatter3(xold(:, 1).*180/pi, xold(:, 2)*1e-3, -1.04*f_old(:), 'filled', 'MarkerEdgeColor','k','MarkerFaceColor',[1, 0, 0])
       
       if abs(max(-f_old) - targ) < 1e-5
           fprintf('Best Solution Found with %i Steps \n', k)
           fprintf('Phase %f deg \n', gbest(1,1)*180/pi);
           fprintf('Voltage %f kV \n', gbest(1,2)*1e-3);
           f_best = max(-f_old);
           return
       end
       % plot(target(1), target(2), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','red', 'MarkerFaceColor', [1, 0, 0]);
       xlim([-180, 180])
       ylim([10, 40])
       pause(1e-2);
       grid on
       f_best = max(-f_old);
    end
    
    % fprintf('Maximum iteractions reached!\n');
    % fprintf('Best Value is %f \n', gbest(1, :));
end

function v_out = set_lim(self, v_in)
    v_out = v_in;
    up = v_in > self.upper_limits;
    down = v_in < self.lower_limits;
    v_out(up) = self.upper_limits(up);
    v_out(down) = self.lower_limits(down);    
end


function f = fig_merit(self, v)
    phi_center = v(1);
    Vg_in = v(2);
    phi_min = phi_center - self.bun_len/2;
    phi_max = phi_center + self.bun_len/2;
    phi_lin = linspace(phi_min, phi_max, self.npoint);
    Vg = Vg_in;
    
    for j = 1:self.npoint
        phi(1, j) = phi_lin(j);
        Emin = self.E0 +  90e3*(1 + 0*lnls_generate_random_numbers(1, 1, 'norm', 2, 0));
        gamma0 = Emin/self.E0;
        beta0 = sqrt(1 - 1/gamma0^2);
        E(j) = Emin - Vg * sin(phi(1, j));
        gamma = E(j)/self.E0;
        beta = sqrt(1 - 1/gamma^2);
        phi(2, j) = phi(1, j) +  self.L0_drift * (2 * pi / self.lambda) * (1/beta0 - 1/beta);
    end
    % t0 = abs(max(phi(1, :)) - min(phi(1, :)));
    % tf = abs(max(phi(end, :)) - min(phi(end, :)));
    t0 = std(phi(1, :));
    tf = std(phi(end, :));
    
    f = -t0/tf;
end

