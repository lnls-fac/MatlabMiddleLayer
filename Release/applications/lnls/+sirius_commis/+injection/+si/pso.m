function gbest = pso(dim, npart, niter, target, conv)

    % sirius_commis.common.initializations();
    w = 0.7984;
    c1 = 1.49618;
    c2 = c1;
    
    lim = 1;
    
    x = linspace(-lim, lim);
    y = linspace(-lim, lim);
    [X, Y] = meshgrid(x, y);
    Z = X.^4 - X.^2 + Y.^4 - Y.^2;
    % Z = (1.5 - X + X .* Y).^2 + (2.25 - X + X .* Y.^2).^2 + (2.625 - X + X .* Y.^3).^2;
    % Z = 0.5 + (cos(sin(abs(X.^2 - Y.^2))).^2 - 0.5)./(1 + 0.001.*(X.^2 + Y.^2)).^2;
    
    for d = 1:dim    
        for i = 1:npart
            x0(i, d) = lim * (1 - 2 * rand());
            v0(i, d) = lim * (1 - 2 * rand());
            pbest(i, d) = x0(i, d);
        end
    end
    
    for i = 1:npart
        f(i) = fig_merit(squeeze(x0(i, :)));
    end
    
    [~, imin] = min(f);
    gbest = repmat(squeeze(x0(imin, :)), npart, 1);
   
    gcf();
    
    for k = 1:niter
       xold = x0;
       for i = 1:npart
          r1 = rand();
          r2 = rand();
          v_ind(i, :) = pbest(i, :) - x0(i, :);
          v_col(i, :) = gbest(i, :) - x0(i, :);
          v0(i, :) = w .* v0(i, :) + (c1 * r1) .* v_ind(i, :) + (c2 * r2) .* v_col(i, :);
          f_old(i) = fig_merit(squeeze(x0(i, :)));
          x0(i, :) = x0(i, :) + v0(i, :);
          f_new(i) = fig_merit(squeeze(x0(i, :)));

          if f_new(i) < f_old(i)
             pbest(i, :) = x0(i, :);
          end
       end
       
       [~, imin] = min(f_new);
       gbest = repmat(squeeze(pbest(imin, :)), npart, 1);

       if all(abs(gbest(1, :) - target) < conv)
           fprintf('Number of iterations %i \n', k);
           fprintf('Best Value is %f \n', gbest(1, :));
           break
       end
       
       hold off;
       quiver(xold(:,1), xold(:, 2), v0(:, 1), v0(:, 2), 0);
       hold on;
       plot(xold(:, 1), xold(:, 2), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','blue', 'MarkerFaceColor', [0, 0, 1]);
       plot(target(1), target(2), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','red', 'MarkerFaceColor', [1, 0, 0]);
       contour(X, Y, Z);
       xlim([-lim, lim]);
       ylim([-lim, lim]);
       pause(0.5);
       grid on
    end
    
    % fprintf('Maximum iteractions reached!\n');
    % fprintf('Best Value is %f \n', gbest(1, :));
end

function f = fig_merit(v)
    % f = v(1)^4 - v(1)^2 + v(2)^4 - v(2)^2;
    X = v(1);
    Y = v(2);
    % f = (1.5 - X + X .* Y).^2 + (2.25 - X + X .* Y.^2).^2 + (2.625 - X + X .* Y.^3).^2;
    f = X.^4 - X.^2 + Y.^4 - Y.^2;
    % f = 0.5 + (cos(sin(abs(X.^2 - Y.^2))).^2 - 0.5)./((1 + 0.001.*(X.^2 + Y.^2))).^2;
end

