function param = pso_run(machine, param, param_errors, n_part, n_pulse, nswarm, niter, target, conv)

    w = 0.7984; % Inertial Weight
    c1 = 1.49618; % Individual Weigth
    c2 = c1; % Collective Weight
    
    x_lim = 1e-3;
    y_lim = 1e-3;
    xl_lim = 10e-3;
    yl_lim = 10e-3;
    kckr_lim = 10e-3;
    
    delta = zeros(nswarm, 5);
    vlct = delta;
    pbest = delta;
    
    close all
    
    x_error = param.offset_x_syst - param.offset_x0;
    y_error = param.offset_y_syst - param.offset_y0;
    xl_error = param.offset_xl_syst - param.offset_xl0;
    yl_error = param.offset_yl_syst - param.offset_yl0;
    kckr_error = param.kckr_syst - param.kckr0;
    
    for i = 1:nswarm
        delta(i, 1) = x_lim * (1 - 2 * rand());
        delta(i, 2) = xl_lim * (1 - 2 * rand());
        delta(i, 3) = y_lim * (1 - 2 * rand());
        delta(i, 4) = yl_lim * (1 - 2 * rand());
        delta(i, 5) = kckr_lim * (1 - 2 * rand());
        vlct(i, 1) = w * x_lim * (1 - 2 * rand());
        vlct(i, 2) = w * xl_lim * (1 - 2 * rand());
        vlct(i, 3) = w * yl_lim * (1 - 2 * rand());
        vlct(i, 4) = w * yl_lim * (1 - 2 * rand());
        vlct(i, 5) = w * kckr_lim * (1 - 2 * rand());
        pbest(i, :) = delta(i, :);
    end

    for i = 1:nswarm
        f1_old(i) = calc_f(machine, param, param_errors, n_part, n_pulse, squeeze(delta(i, :)));
    end
    
    [~, imax] = max(f1_old);
    gbest = repmat(squeeze(pbest(imax, :)), nswarm, 1);
   
    fig1 = figure();
    
    for k = 1:niter
       fprintf('Iterations Number %i \n', k);
       delta_old = delta;
       for i = 1:nswarm
          r1 = rand();
          r2 = rand();
          v_ind(i, :) = pbest(i, :) - delta(i, :);
          v_col(i, :) = gbest(i, :) - delta(i, :);
          vlct(i, :) = w .* vlct(i, :) + (c1 * r1) .* v_ind(i, :) + (c2 * r2) .* v_col(i, :);
          delta(i, :) = delta(i, :) + vlct(i, :);
          f1_new(i) = calc_f(machine, param, param_errors, n_part, n_pulse, squeeze(delta(i, :)));

          if f1_new(i) > f1_old(i)
             pbest(i, :) = delta(i, :);
             f1_old(i) = f1_new(i);
          end
       end
         
       [~, imax] = max(f1_old);
        
       gbest = repmat(squeeze(pbest(imax, :)), nswarm, 1);
       
       hold off;
       figure(fig1); quiver(param.offset_xl_syst + delta_old(:,1), param.kckr_syst + delta_old(:, 3), vlct(:, 1), vlct(:, 3), 0);
       hold on;
       figure(fig1); plot(param.offset_xl_syst + delta(:,1), param.kckr_syst +  delta(:, 3), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','blue', 'MarkerFaceColor', [0, 0, 1]);
       figure(fig1); plot(param.offset_xl_syst + delta_old(:,1), param.kckr_syst + delta_old(:, 3), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','red', 'MarkerFaceColor', [1, 0, 0]);
       angle_error = 0 * 3 * (param.offset_xl_syst - param.offset_xl0);
       figure(fig1); plot(param.offset_xl0 + angle_error, param.kckr0 - angle_error, 'o', 'MarkerSize', 5, 'MarkerEdgeColor','black', 'MarkerFaceColor', [0, 0, 0]);
       x = linspace(param.offset_xl0 - 5 * xl_lim, param.offset_xl0 + 5 * xl_lim, 100);
       figure(fig1); plot(x, -x, 'k-');
       % contour(X, Y, Z);
       % xlim(sort([x(1), x(end)]));
       % ylim(sort([param.kckr0 - 5 * kckr_lim, param.kckr0 + 5 * kckr_lim]));
       % pause(1e-7);
       grid on
       drawnow()

       % if all(abs(max(f1) - target) <= conv)
       %     fprintf('Number of iterations %i \n', k);
       %     fprintf('Best Value is %f \n', gbest(1, :));
       %     break
       % end
    end
    
    best_param = squeeze(gbest(1, :));
    
    param.offset_x_syst= param.offset_x_syst + best_param(1);
    param.offset_xl_syst= param.offset_xl_syst + best_param(2);
    param.offset_y_syst= param.offset_y_syst + best_param(3);
    param.offset_yl_syst= param.offset_yl_syst + best_param(4);
    param.kckr_syst = param.kckr_syst + best_param(5);
end

function [f1, param] = calc_f(machine, param, param_errors, n_part, n_pulse, delta)

    param.offset_x_syst= param.offset_x_syst + delta(1);
    param.offset_xl_syst= param.offset_xl_syst + delta(2);
    param.offset_y_syst= param.offset_y_syst + delta(3);
    param.offset_yl_syst= param.offset_yl_syst + delta(4);
    param.kckr_syst = param.kckr_syst + delta(5);
    r = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    sum_bpm = r.sum_bpm;
    % fi = (length(sum_bpm) - (1:1:length(sum_bpm))) * sum_bpm;
    fi = (1:1:length(sum_bpm)) * sum_bpm;
    eff = 0.5;
    fo = sqrt(sum(r.r_bpm(1, sum_bpm > eff).^2 + r.r_bpm(2, sum_bpm > eff).^2));
    p1 = 1; p2 = 1e-1;
    if fo ~= 0
        f1 = p1*fi + p2/fo;
    else
        f1 = p1*fi;
    end
end

