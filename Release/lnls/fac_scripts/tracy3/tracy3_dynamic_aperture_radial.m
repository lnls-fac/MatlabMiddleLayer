function tracy3_dynamic_aperture_radial(nr_calcs, the_ring, idx)

global THERING;

colors = {[0,0,1],[1,0,0],[0,0.8,0],[1,1,0],[0,1,1],[1,0,1]};

if ~exist('nr_calcs', 'var')
    nr_calcs = 1;
    colors = {[0,0,0]};
end

if ~exist('the_ring','var')
    the_ring = THERING;
    idx = 1;
end


fig = [];
for i=1:nr_calcs
    fig = plot_rms(fig, colors{i});
end

% plots physical acceptance
if (~isempty(fig)) && (~isempty(the_ring))
    [x, y, x1, y1] = lnls_calc_physical_acceptance(the_ring, 1, 50);
    plot(1e3*x, 1e3*y, 'k--', 'Color', [0,0,0], 'LineWidth', 2);
    %plot(1e3*x1, 1e3*y1, '--', 'Color', [0,0,0], 'LineWidth', 2);
end


function fig = plot_rms(fig0, color)

fig = fig0;

path = '/home/fac_files/data/sirius_tracy/';
path = uigetdir(path,'Em qual pasta estao os dados?');
if (path==0); return; end;

if isempty(fig)
    fig = figure; hold all;
end

[~, result] = system(['find ' path ' -type d | grep rms | wc -l']);
n_pastas = str2double(result);

x = []; y = [];
for i=1:n_pastas
    fname = fullfile(path, ['rms' num2str(i, '%02i')], 'daxy_radial.out');
    if exist(fname, 'file')
        data = importdata(fname, ' ', 3); data = data.data;
        plot(1000*data(:,1), 1000*data(:,2), 'x', 'MarkerSize', 10, 'Color', color);
        x = [x; data(:,1)'];
        y = [y; data(:,2)'];
    end
end
plot(1000*mean(x), 1e3*mean(y), 'Color', color, 'LineWidth', 2);

