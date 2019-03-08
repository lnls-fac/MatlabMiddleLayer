function [quadratic, linear, mresp, mono] = bba_analysis(Ri, Rf, n_bpm, dtheta, plane, plot_graph)

f_merit_quad = squeeze(nansum((Ri - Rf).^2, 3)) / size(Ri, 3);
f_merit_linear = Rf - Ri;
r_bpm = squeeze(Ri(:, :, n_bpm));
if any(isnan(r_bpm))
    r_bpm = squeeze(Ri(:, :, n_bpm + 1));
end

if strcmp(plane, 'x')
    bpm_pos = squeeze(r_bpm(:, 1));
    fm_quad = squeeze(f_merit_quad(:, 1));
    fm_linear = squeeze(f_merit_linear(:, 1, :));
    for k = 1:length(dtheta)-1
        mresp(k) = (r_bpm(k+1, 1) - r_bpm(k, 1)) / (dtheta(k+1) - dtheta(k));
    end
    mresp = mean(mresp);
elseif strcmp(plane, 'y')
    bpm_pos = squeeze(r_bpm(:, 2));
    fm_quad = squeeze(f_merit_quad(:, 2));
    fm_linear = squeeze(f_merit_linear(:, 2, :));
    for k = 1:length(dtheta)-1
        mresp(k) = (r_bpm(k+1, 2) - r_bpm(k, 2)) / (dtheta(k+1) - dtheta(k));
    end
    mresp = mean(mresp);
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
% offset_quad = - prbla(2) / 2 / prbla(1) * mu_quad(2) + mu_quad(1);
erro_fit_quad = mean(erro_fit_quad);

if flag_plot
    close(gcf());
    hold off;
    gcf(); plot(bpm_pos * 1e6, fm_quad, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); hold all; plot(bpm_pos * 1e6, poly_quad, 'blue', 'LineWidth', 2);
    y = get(gca, 'ylim');
    plot([offset_quad*1e6 offset_quad*1e6], y, 'black', 'LineWidth', 2);
    legend('Data points', 'Fitting', 'Location', 'northeast');
    xlabel('BPM position [um]');
    ylabel('Fig. of merit [m²]');
    title(['BPM #' , num2str(n_bpm)]);
    grid on;
end

[prbla_theta, S_theta_quad, mu_theta_quad] = polyfit(dtheta', fm_quad, 2);
theta_fit = [min(dtheta):1e-8:max(dtheta)];
[px, ~] = polyval(prbla_theta, theta_fit, S_theta_quad, mu_theta_quad);    
[poly_theta_quad, erro_fit_theta_quad] = polyval(prbla_theta, dtheta', S_theta_quad, mu_theta_quad);    
[~, i_min] = min(px);
offset_theta_quad = theta_fit(i_min);
% offset_theta_quad = - prbla_theta(2) / 2 / prbla_theta(1) * mu_theta_quad(2) + mu_theta_quad(1);
erro_fit_theta_quad = mean(erro_fit_theta_quad);

% fit_bpm = polyfit(dtheta', bpm_pos, 1);
% offset_quad = fit_bpm(1) * offset_theta_quad + fit_bpm(2);
% figure;
% linha = fit_bpm(1) .* dtheta' + fit_bpm(2);
% plot(dtheta' * 1e6, bpm_pos * 1e6, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); hold all; plot(dtheta' * 1e6, linha * 1e6, 'blue', 'LineWidth', 2);
% y = get(gca, 'ylim');
% plot([offset_theta_quad*1e6 offset_theta_quad*1e6], y, 'black', 'LineWidth', 2);
%{
if flag_plot
    close(gcf());
    hold off;
    gcf(); plot(dtheta' * 1e6, fm_quad, 'o', 'MarkerSize', 6 ,'MarkerEdgeColor','red','MarkerFaceColor',[1 0 0]); hold all; plot(dtheta' * 1e6, poly_theta_quad, 'blue', 'LineWidth', 2);
    y = get(gca, 'ylim');
    plot([offset_theta_quad*1e6 offset_theta_quad*1e6], y, 'black', 'LineWidth', 2);
    legend('Data points', 'Fitting', 'Location', 'northeast');
    xlabel('Corrector kick [urad]');
    ylabel('Fig. of merit [m²]');
    title(['BPM #' , num2str(n_bpm)]);
    grid on;
end
%}
for i = 1:size(fm_linear, 2)
    [straight, S_linear, mu_linear] = polyfit(bpm_pos, fm_linear(:, i), 1);
    offset_linear_bpm(i) = - straight(2) / straight(1) * mu_linear(2) + mu_linear(1);
    [~, erro_fit_linear] = polyval(straight, bpm_pos, S_linear, mu_linear);
    error_fit_linear_bpm(i) = mean(erro_fit_linear);
    angle_coef(i) = straight(1);
end

offset_linear = nansum(abs(angle_coef) .* offset_linear_bpm / nansum(abs(angle_coef)));
erro_fit_linear = nansum(abs(angle_coef) .* error_fit_linear_bpm / nansum(abs(angle_coef)));

for i = 1:size(fm_linear, 2)
    [straight_theta, S_theta_linear, mu_theta_linear] = polyfit(dtheta', fm_linear(:, i), 1);
    offset_theta_linear_bpm(i) = - straight(2) / straight(1) * mu_theta_linear(2) + mu_theta_linear(1);
    [~, erro_fit_theta_linear] = polyval(straight_theta, dtheta', S_theta_linear, mu_theta_linear);
    erro_fit_theta_linear(i) = mean(erro_fit_theta_linear);
    angle_coef_theta(i) = straight_theta(1);
end

offset_theta_linear = nansum(abs(angle_coef_theta) .* offset_theta_linear_bpm ./ nansum(abs(angle_coef_theta)));
erro_theta_linear = nansum(abs(angle_coef_theta) .* erro_fit_theta_linear ./ nansum(abs(angle_coef_theta)));

quadratic.offset_bpm = offset_quad;
quadratic.erro_fit_bpm = erro_fit_quad;
quadratic.offset_theta = offset_theta_quad;
quadratic.erro_fit_theta = erro_fit_theta_quad;

linear.offset_bpm = offset_linear;
linear.erro_fit_bpm = erro_fit_linear;
linear.offset_theta = offset_theta_linear;
linear.erro_fit_theta = erro_theta_linear;

data_sort_asc = sort(fm_quad); data_sort_desc = sort(fm_quad, 'descend');
mono = isequal(fm_quad, data_sort_asc) | isequal(fm_quad, data_sort_desc);
end
