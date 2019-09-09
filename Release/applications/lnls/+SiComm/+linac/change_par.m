function change_par()

dim = 3;
niter = 20;
npart = round(10 + 2*sqrt(dim));
const.upper_limits = [2, 2, 2];
const.lower_limits = [0, 0, 0];
dlim = const.upper_limits - const.lower_limits;
w = 0.7984;
c1 = 1.49618;
c2 = c1;
ave = 10;
nmax = 100;

% gcf();

for d = 1:dim
    for i = 1:npart
        x0(i, d) = dlim(d) * rand() + const.lower_limits(d);
        v0(i, d) = 0;
        pbest(i, d) = x0(i, d);
    end
end
    
    for i = 1:npart
        for m = 1:ave
            f_oldm(m) = sirius_commis.linac.pso(2, nmax, squeeze(x0(i,:)));
        end
        f_old(i) = mean(f_oldm);
    end
    
    [~, imin] = min(f_old);
    gbest = repmat(squeeze(x0(imin, :)), npart, 1);
    
    for k = 1:niter
       xold = x0;
       for i = 1:npart
          r1 = rand();
          r2 = rand();
          v_ind(i, :) = pbest(i, :) - x0(i, :);
          v_col(i, :) = gbest(i, :) - x0(i, :);
          v0(i, :) = w .* v0(i, :) + (c1 * r1) .* v_ind(i, :) + (c2 * r2) .* v_col(i, :);
          x0(i, :) = x0(i, :) + v0(i, :);
          x0(i, :) = set_lim(const, x0(i, :));
          for m = 1:ave
            f_newm(i) = sirius_commis.linac.pso(2, nmax, squeeze(x0(i,:)));
          end
          f_new(i) = mean(f_newm);
          if f_new(i) < f_old(i)
             pbest(i, :) = x0(i, :);
             f_old(i) = f_new(i);
          end
      end
       
       [~, imin] = min(f_old);
       gbest = repmat(squeeze(pbest(imin, :)), npart, 1);
       
%        hold off;
%        quiver3(xold(:,1), xold(:, 2), xold(:, 3), v0(:, 1), v0(:, 2), v0(:, 3), 0);
%        hold on
%        scatter3(xold(:, 1), xold(:, 2), xold(:, 3), 'filled', 'MarkerEdgeColor','k','MarkerFaceColor',[1, 0, 0])
%        scatter3(w, c1, c2, 'filled', 'MarkerEdgeColor','k','MarkerFaceColor',[0, 0, 0])
        fprintf('Step Number %i \n', k);
        fprintf('Best Average Steps found %i \n', round(min(f_old)));
        fprintf('Parameters are w = %f | c1 = %f | c2 = %f | \n', gbest(1, 1), gbest(1, 2), gbest(1, 3));
    end    
    
end

function v_out = set_lim(const, v_in)
    v_out = v_in;
    up = v_in > const.upper_limits;
    down = v_in < const.lower_limits;
    v_out(up) = const.upper_limits(up);
    v_out(down) = const.lower_limits(down);    
end



