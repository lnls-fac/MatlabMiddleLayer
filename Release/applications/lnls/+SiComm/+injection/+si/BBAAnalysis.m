function BBAResults = BBAAnalysis(R0, DeltaR, n_bpm, plane, plot_graph)

QuadSum = squeeze(nansum((DeltaR(:, :, n_bpm+1:end)).^2, 3));

for k = 1:size(DeltaR, 1)
    nBPM = squeeze(sum(~isnan(DeltaR(k, 1, n_bpm+1:end))));
    obj_fun_quad(k, :) = QuadSum(k, :) / nBPM;
end

% obj_fun_quad = QuadSum / size(DeltaR, 3);
% sigma_res = 1e-6;
% sigma_offset = 500e-6;
% obj_fun_quad = squeeze(nansum((Ri - Rf).^2, 3)) / (2 * sigma_res^2) + squeeze(nansum((Rf).^2, 3)) / (sigma_res^2 + sigma_offset^2);
obj_fun_lin = DeltaR(:, :, n_bpm+1:end);
r_bpm = squeeze(R0(:, :, n_bpm));
% if any(isnan(r_bpm))
%    r_bpm = squeeze(Ri(:, :, n_bpm + 1));
% end

if strcmp(plane, 'x')
    bpm_pos = squeeze(r_bpm(:, 1));
    fm_quad = squeeze(obj_fun_quad(:, 1));
    fm_linear = squeeze(obj_fun_lin(:, 1, :));    
elseif strcmp(plane, 'y')
    bpm_pos = squeeze(r_bpm(:, 2));
    fm_quad = squeeze(obj_fun_quad(:, 2));
    fm_linear = squeeze(obj_fun_lin(:, 2, :));   
end

if ~exist('plot_graph', 'var')
    flag_plot = false;
elseif strcmp(plot_graph, 'plot')
    flag_plot = true;
end

[prbla, S_quad, mu_quad] = polyfit(bpm_pos, fm_quad, 2);
x_fit = [min(bpm_pos):1e-8:max(bpm_pos)];
[px, ~] = polyval(prbla, x_fit, S_quad, mu_quad);    
[poly_quad, erro_fit_quad] = polyval(prbla, bpm_pos, S_quad, mu_quad);    
[~, i_min] = min(px);
offset_quad = x_fit(i_min);
erro_fit_quad = mean(erro_fit_quad);

% if flag_plot
%     close(gcf());
%     hold off;
%     gcf(); plot(bpm_pos * 1e6, fm_quad, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); hold all; plot(bpm_pos * 1e6, poly_quad, 'blue', 'LineWidth', 2);
%     y = get(gca, 'ylim');
%     plot([offset_quad*1e6 offset_quad*1e6], y, 'black', 'LineWidth', 2);
%     legend('Data points', 'Fitting', 'Location', 'northeast');
%     xlabel('BPM position [um]');
%     ylabel('Fig. of merit [m²]');
%     title(['BPM #' , num2str(n_bpm)]);
%     grid on;
% end

for i = 1:size(fm_linear, 2)
    [straight, S_linear, mu_linear] = polyfit(bpm_pos, fm_linear(:, i), 1);
    x_fit = [min(bpm_pos):1e-8:max(bpm_pos)];
    % [px, ~] = polyval(straight, x_fit, S_linear, mu_linear);    
    [poly_linear(i, :), erro_fit_linear] = polyval(straight, bpm_pos, S_linear, mu_linear);    
    offset_linear_bpm(i) = - straight(2) / straight(1) * mu_linear(2) + mu_linear(1);
    % [~, erro_fit_linear] = polyval(straight, bpm_pos, S_linear, mu_linear);
    error_fit_linear_bpm(i) = mean(erro_fit_linear);
    angle_coef(i) = straight(1);    
end

off_std = nanstd(offset_linear_bpm);
off_mean = nanmean(offset_linear_bpm);
lower = off_mean - 3 * off_std;
upper = off_mean + 3 * off_std;
sel = offset_linear_bpm >= lower & offset_linear_bpm <= upper;
outliers = offset_linear_bpm(offset_linear_bpm < lower | offset_linear_bpm > upper);
off_sel = offset_linear_bpm(sel);
angle_sel = angle_coef(sel);

offset_linear = nansum(dot(abs(angle_sel), off_sel)) / nansum(abs(angle_sel));
erro_fit_linear = nansum(dot(abs(angle_coef), error_fit_linear_bpm)) / nansum(abs(angle_coef));

if ~isappdata(0, 'fig')
    fig = figure('OuterPosition', [100, 100, 800, 900]);
    ax1 = subplottight(3,1,1, 'vspace', 0.05);
    ax2 = subplottight(3,1,2, 'vspace', 0.05);
    setappdata(0, 'fig', fig);
    setappdata(0, 'ax1', ax1);
    setappdata(0, 'ax2', ax2);
else
    fig = getappdata(0, 'fig');
    try
        get(fig, 'type');
    catch
        fig = figure('OuterPosition', [100, 100, 800, 900]);
        ax1 = subplottight(2,1,1, 'vspace', 0.05);
        ax2 = subplottight(2,1,2, 'vspace', 0.05);
        setappdata(0, 'fig', fig);
        setappdata(0, 'ax1', ax1);
        setappdata(0, 'ax2', ax2);
    end
    ax1 = getappdata(0, 'ax1');
    ax2 = getappdata(0, 'ax2');
end
    hold(ax1, 'off');
    hold(ax2, 'off');
    plot(ax1, bpm_pos * 1e6, fm_quad, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); 
    hold(ax1, 'on'); 
    plot(ax1, bpm_pos * 1e6, poly_quad, 'blue', 'LineWidth', 2);
    y = get(ax1, 'ylim');
    plot(ax1, [offset_quad*1e6 offset_quad*1e6], y, 'black', 'LineWidth', 2);
    legend(ax1, 'Data points', 'Fitting', 'Location', 'northeast');
    xlabel(ax1, 'BPM position [um]');
    ylabel(ax1, 'Fig. of merit [m²]');
    title(ax1,['BPM #' , num2str(n_bpm)]);
    for i = n_bpm + 1:size(fm_linear, 2)
        % plot(ax2, bpm_pos * 1e6, fm_linear(:, i) * 1e6, '-', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); 
        plot(ax2, bpm_pos * 1e6, poly_linear(i, :), '-b');
        hold(ax2, 'on');
    end
    y = get(ax2, 'ylim');
    plot(ax2, [offset_linear*1e6 offset_linear*1e6], y, 'black', 'LineWidth', 2);
    xlabel(ax2, 'BPM position [um]');
    ylabel(ax2, 'Fig. of merit [m]');
    grid(ax1, 'on');
    grid(ax2, 'on');
    drawnow();
    
%     close(gcf());
%     hold off;
%     gcf();
%     for i = n_bpm + 1:size(fm_linear, 2)
%         plot(bpm_pos * 1e6, fm_linear(:, i) * 1e6, '-', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); hold all;
%         y = get(gca, 'ylim');
%         plot([offset_linear*1e6 offset_linear*1e6], y, 'black', 'LineWidth', 2);
%     end
%     title(['BPM #' , num2str(n_bpm)]);
%     xlabel('BPMs positions [um]');
%     ylabel('Fig. of merit [um]');
%     grid on;

if strcmp(plane, 'x')
    BBAResults.QuadraticFit.BPMOffsetX = offset_quad;
    BBAResults.QuadraticFit.ErrorX = erro_fit_quad;

    BBAResults.LinearFit.BPMOffsetX = offset_linear;
    BBAResults.LinearFit.ErrorX = erro_fit_linear;
elseif strcmp(plane, 'y')
    BBAResults.QuadraticFit.BPMOffsetY = offset_quad;
    BBAResults.QuadraticFit.ErrorY = erro_fit_quad;

    BBAResults.LinearFit.BPMOffsetY = offset_linear;
    BBAResults.LinearFit.ErrorY = erro_fit_linear;
end

% data_sort_asc = sort(fm_quad); data_sort_desc = sort(fm_quad, 'descend');
% mono = isequal(fm_quad, data_sort_asc) | isequal(fm_quad, data_sort_desc);
end

