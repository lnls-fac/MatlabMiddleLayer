function MDInjOpt = InjCorrectionPSO(MD, niter)

    w = 0.7984; % Inertial Weight
    c1 = 1.49618; % Individual Weigth
    c2 = c1; % Collective Weight
    
    x_lim = 1e-3;
    y_lim = 1e-3;
    xl_lim = 3e-3;
    yl_lim = 3e-3;
    kckr_lim = 3e-3;
    
    nswarm = 10 + 2 * round(sqrt(5));
    delta = zeros(nswarm, 5);
    vlct = delta;
    pbest = delta;
       
    x_error = MD.Inj.R.offset_x_syst - MD.Inj.R0.offset_x0;
    y_error = MD.Inj.R.offset_y_syst - MD.Inj.R0.offset_y0;
    xl_error = MD.Inj.R.offset_xl_syst - MD.Inj.R0.offset_xl0;
    yl_error = MD.Inj.R.offset_yl_syst - MD.Inj.R0.offset_yl0;
    kckr_error = MD.Inj.R.kckr_syst - MD.Inj.R0.kckr0;
    
    for i = 1:nswarm-1
        delta(i, 1) = x_lim * (1 - 2 * rand());
        delta(i, 2) = xl_lim * (1 - 2 * rand());
        delta(i, 3) = y_lim * (1 - 2 * rand());
        delta(i, 4) = yl_lim * (1 - 2 * rand());
        delta(i, 5) = kckr_lim * (1 - 2 * rand());
        vlct(i, 1) = 0 * w * x_lim * (1 - 2 * rand());
        vlct(i, 2) = 0 * w * xl_lim * (1 - 2 * rand());
        vlct(i, 3) = 0 * w * yl_lim * (1 - 2 * rand());
        vlct(i, 4) = 0 * w * yl_lim * (1 - 2 * rand());
        vlct(i, 5) = 0 * w * kckr_lim * (1 - 2 * rand());
        pbest(i, :) = delta(i, :);
    end

    for i = 1:nswarm
        f_old(i) = calc_f(MD, squeeze(delta(i, :)));
    end
    
    [~, imax] = max(f_old);
    gbest = repmat(squeeze(pbest(imax, :)), nswarm, 1);
   
    % fig1 = figure();
    
    for k = 1:niter
       fprintf('Iteration Number %i \n', k);
       delta_old = delta;
       for i = 1:nswarm
          r1 = rand();
          r2 = rand();
          v_ind(i, :) = pbest(i, :) - delta(i, :);
          v_col(i, :) = gbest(i, :) - delta(i, :);
          vlct(i, :) = w .* vlct(i, :) + (c1 * r1) .* v_ind(i, :) + (c2 * r2) .* v_col(i, :);
          delta(i, :) = delta(i, :) + vlct(i, :);
          f_new(i) = calc_f(MD, squeeze(delta(i, :)));

          if f_new(i) > f_old(i)
             pbest(i, :) = delta(i, :);
             f_old(i) = f_new(i);
          end
       end
         
       [~, imax] = max(f_old);
        
       gbest = repmat(squeeze(pbest(imax, :)), nswarm, 1);
       
%        hold off;
%        figure(fig1); quiver(MD.Inj.R.offset_xl_syst + delta_old(:,1), MD.Inj.R.kckr_syst + delta_old(:, 3), vlct(:, 1), vlct(:, 3), 0);
%        hold on;
%        figure(fig1); plot(MD.Inj.R.offset_xl_syst + delta(:,1), MD.Inj.R.kckr_syst +  delta(:, 3), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','blue', 'MarkerFaceColor', [0, 0, 1]);
%        figure(fig1); plot(MD.Inj.R.offset_xl_syst + delta_old(:,1), MD.Inj.R.kckr_syst + delta_old(:, 3), 'o', 'MarkerSize', 5, 'MarkerEdgeColor','red', 'MarkerFaceColor', [1, 0, 0]);
%        % angle_error = 0 * 3 * (param.offset_xl_syst - param.offset_xl0);
%        % figure(fig1); plot(MD.Inj.R0.offset_xl0 + angle_error, MD.Inj.R0.kckr0 - angle_error, 'o', 'MarkerSize', 5, 'MarkerEdgeColor','black', 'MarkerFaceColor', [0, 0, 0]);
%        x = linspace(MD.Inj.R0.offset_xl0 - 5 * xl_lim, MD.Inj.R0.offset_xl0 + 5 * xl_lim, 100);
%        figure(fig1); plot(x, -x, 'k-');
%        % contour(X, Y, Z);
%        % xlim(sort([x(1), x(end)]));
%        % ylim(sort([param.kckr0 - 5 * kckr_lim, param.kckr0 + 5 * kckr_lim]));
%        % pause(1e-7);
%        grid on
%        drawnow()

       % if all(abs(max(f1) - target) <= conv)
       %     fprintf('Number of iterations %i \n', k);
       %     fprintf('Best Value is %f \n', gbest(1, :));
       %     break
       % end
    end
    
    best_param = squeeze(gbest(1, :));
    
    MDInjOpt = MD;
    MDInjOpt.Inj.R.offset_x_syst= MD.Inj.R.offset_x_syst + best_param(1);
    MDInjOpt.Inj.R.offset_xl_syst= MD.Inj.R.offset_xl_syst + best_param(2);
    MDInjOpt.Inj.R.offset_y_syst= MD.Inj.R.offset_y_syst + best_param(3);
    MDInjOpt.Inj.R.offset_yl_syst= MD.Inj.R.offset_yl_syst + best_param(4);
    MDInjOpt.Inj.R.kckr_syst = MD.Inj.R.kckr_syst + best_param(5);
end

function [f1, MD] = calc_f(MD, delta)

    MD.Inj.R.offset_x_syst= MD.Inj.R.offset_x_syst + delta(1);
    MD.Inj.R.offset_xl_syst= MD.Inj.R.offset_xl_syst + delta(2);
    MD.Inj.R.offset_y_syst= MD.Inj.R.offset_y_syst + delta(3);
    MD.Inj.R.offset_yl_syst= MD.Inj.R.offset_yl_syst + delta(4);
    MD.Inj.R.kckr_syst = MD.Inj.R.kckr_syst + delta(5);
    
    MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', 'errorON');
    
    for PulseIdx = 1:MD.Inj.NPulses
        BPMPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMPos;
        SumPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMSum;
    end
    r_bpm = squeeze(nanmean(BPMPbP, 1));
    sum_bpm = squeeze(nanmean(SumPbP, 1));
   
    % fi = (length(sum_bpm) - (1:1:length(sum_bpm))) * sum_bpm;
    fi = (1:1:length(sum_bpm)) * sum_bpm;
    eff = 0.5;
    GoodBPM = sum_bpm > eff;
    GoodBPM = GoodBPM(1:8);
    
    fo = sqrt(sum(r_bpm(1, GoodBPM).^2 + r_bpm(2, GoodBPM).^2));
    p1 = 1; p2 = 1e-1;
    if fo ~= 0
        f1 = p1*fi + p2/fo;
    else
        f1 = p1*fi;
    end
end

