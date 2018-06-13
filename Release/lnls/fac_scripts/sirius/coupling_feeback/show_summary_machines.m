function coups = show_summary_machines(rand_mach, indices, plot_label)
    f1 = figure;  % tilt angle
    ax1 = axes(f1);
    hold(ax1, 'all');
    grid(ax1, 'on');
    box(ax1, 'on');
    xlim(ax1, [0, indices.pos(end)]);
    xlabel(ax1, 'pos [m]');
    ylabel(ax1, 'angle [deg.]');
    title(ax1, plot_label);
    f2 = figure;  % sigmay
    ax2 = axes(f2);
    hold(ax2, 'all');
    grid(ax2, 'on');
    box(ax2, 'on');
    xlim(ax2, [0, indices.pos(end)]);
    xlabel(ax2, 'pos [m]');
    ylabel(ax2, 'sigmay [um]');
    title(ax2, plot_label);
    drawnow;
    
    bl_all = indices.bl_all;
    pos = indices.pos;
    coups = cell(length(rand_mach),1);
    C_ang = 180/pi;
    C_sig = 1e6;
    C_emi = 100;
    C_qs = 1e3;
    names = {'mia', 'mib', 'mip', 'mic'};
    fprintf('\n\n%s\n\n', strjust(sprintf('%96s', ['Summary of ', plot_label]), 'center'));
    fprintf('ID  ');
    fprintf('ex/ey [%%] ||');
    fprintf('%s||', strjust(sprintf('%21s', 'KL [x1000]'), 'center'));
    fprintf('%s||', strjust(sprintf('%28s', 'angles [°]'), 'center'));
    fprintf('%s\n', strjust(sprintf('%28s', 'sigmay [um]'), 'center'));
    fprintf('%s||', repmat(' ', 14, 1));
    fprintf(' %5s  %5s  %5s ||', 'max', 'mean', 'std');
    for i=1:length(names)
        fprintf('%s', strjust(sprintf('%7s', names{i}), 'center'));
    end
    fprintf('||');
    for i=1:length(names)
        fprintf('%s', strjust(sprintf('%7s', names{i}), 'center'));
    end
    fprintf('\n%s\n', repmat('-', 96, 1))
    ang_mean = cell(size(names));
    sig_mean = cell(size(names));
    emit_r = zeros(1,length(rand_mach));
    max_qs = zeros(1,length(rand_mach));
    mean_qs = zeros(1,length(rand_mach));
    std_qs = zeros(1,length(rand_mach));
    for i=1:length(rand_mach)
        fprintf('%02d: ', i);
        coup = calc_coupling(rand_mach{i});
        plot(ax1, pos, (180/pi)*coup.tilt, 'Color', [1.0,0.6,0.6]);
        scatter(ax1, pos(bl_all), (180/pi)*coup.tilt(bl_all), 50, [1.0,0.4,0.4], 'filled');
        plot(ax2, pos, 1e6*coup.sigmas(2,:), 'Color', [0.6,0.6,1.0]);
        scatter(ax2, pos(bl_all), 1e6*coup.sigmas(2, bl_all), 50, [0.4,0.4,1], 'filled');
        drawnow;
        coups{i} = coup;

        fprintf('%s||', strjust(sprintf('%10.2f', coup.emit_ratio*C_emi), 'center'));
        emit_r(i) = coup.emit_ratio;
        
        qs_st = getcellstruct(rand_mach{i}, 'PolynomA', indices.qs(:), 1, 2);
        L = getcellstruct(rand_mach{i}, 'Length', indices.qs(:));
        qs_st = qs_st .* L;
        qs_st = sum(reshape(qs_st, size(indices.qs)), 2);
        max_qs(i) = max(qs_st);
        mean_qs(i) = mean(qs_st);
        std_qs(i) = std(qs_st);
        fprintf(' %5.2f  %5.2f  %5.2f ||', max_qs(i)*C_qs, mean_qs(i)*C_qs, std_qs(i)*C_qs);
        
        for j=1:length(names)
            name = names{j};
            idx = indices.(name);
            dtilt = coup.tilt(idx);
            d = mean(rms(dtilt));
            fprintf(' %5.2f ', C_ang*d);
            ang_mean{j} = [ang_mean{j}, d];
        end
        fprintf('||');
        for j=1:length(names)
            name = names{j};
            idx = indices.(name);            
            dsigy = coup.sigmas(2, idx);
            d = mean(rms(dsigy));
            fprintf(' %5.2f ', C_sig*d);
            sig_mean{j} = [sig_mean{j}, d];
        end
        fprintf('\n');
    end
    fprintf('%s\n', repmat('-', 96, 1))
    fprintf('    ');
    fprintf('%s||', strjust(sprintf('%10.2f', mean(emit_r)*C_emi), 'center'));
    fprintf(' %5.2f  %5.2f  %5.2f ||', max(max_qs)*C_qs, mean(mean_qs)*C_qs, mean(std_qs)*C_qs);
    for j=1:length(names)
        fprintf(' %5.2f ', C_ang*mean(ang_mean{j}));
    end
    fprintf('||');
    for j=1:length(names)
        fprintf(' %5.2f ', C_sig*mean(sig_mean{j}));
    end
    fprintf('\n\n');