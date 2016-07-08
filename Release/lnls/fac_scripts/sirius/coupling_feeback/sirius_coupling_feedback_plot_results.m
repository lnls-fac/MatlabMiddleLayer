function sirius_coupling_feedback_plot_results

close all; drawnow;

% fname = 'v18-01_3.0coup_1.0coup-ids_1b2_results.mat';  data1 = load_data(fname);
% fname = 'v18-01_3.0coup_1.0coup-ids_5b2_results.mat';  data2 = load_data(fname);
% fname = 'v18-01_3.0coup_1.0coup-ids_10b2_results.mat'; data3 = load_data(fname);
% fname = 'v18-01_3.0coup_1.0coup-ids_20b2_results.mat'; data4 = load_data(fname);
% fprintf('mia: '); plot_at_indices({data1,data2,data3,data4},data1.indices.mia); fprintf('\n');
% fprintf('mib: '); plot_at_indices({data1,data2,data3,data4},data1.indices.mib); fprintf('\n');
% fprintf('mip: '); plot_at_indices({data1,data2,data3,data4},data1.indices.mip); fprintf('\n');
% fprintf('mc : '); plot_at_indices({data1,data2,data3,data4},data1.indices.mic); fprintf('\n');

% fname = 'v18-01_3.0coup_0.5coup-ids_1b2_results.mat';  data1 = load_data(fname);
% fname = 'v18-01_3.0coup_0.5coup-ids_5b2_results.mat';  data2 = load_data(fname);
% fname = 'v18-01_3.0coup_0.5coup-ids_10b2_results.mat'; data3 = load_data(fname);
% fname = 'v18-01_3.0coup_0.5coup-ids_20b2_results.mat'; data4 = load_data(fname);
% fprintf('mia: '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mia); fprintf('\n');
% fprintf('mib: '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mib); fprintf('\n');
% fprintf('mip: '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mip); fprintf('\n');
% fprintf('mc : '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mic); fprintf('\n');

prefix = 'v20-01_3.0coup_1.0coup-ids_';
fname = [prefix, '1b2_results.mat'];  data1 = load_data(fname);
fname = [prefix, '5b2_results.mat'];  data2 = load_data(fname);
fname = [prefix, '10b2_results.mat']; data3 = load_data(fname);
fname = [prefix, '20b2_results.mat']; data4 = load_data(fname);
fprintf('mia: '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mia,[prefix, 'xlyl_tilt_mia']); fprintf('\n');
fprintf('mib: '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mib,[prefix, 'xlyl_tilt_mib']); fprintf('\n');
fprintf('mip: '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mip,[prefix, 'xlyl_tilt_mip']); fprintf('\n');
fprintf('mc : '); plot_at_indices_divergence({data1,data2,data3,data4},data1.indices.mic,[prefix, 'xlyl_tilt_mic']); fprintf('\n');


function plot_at_indices(data,indices,figname)

fig = figure; hold all;
dtheta = pi/2/length(data);
theta = 0;
add_plot(fig, data{1}.dtilt1, indices, [cos(theta)^2,0,sin(theta)^2]);
for i=1:length(data)
    theta = theta+dtheta; add_plot(fig, data{i}.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);
end
xlabel('tilt angle [deg]');
ylabel('unnormalized probability');
title(strrep(figname,'_','-'));
saveas(fig, [figname, '.fig'], 'fig');


function plot_at_indices_divergence(data,indices,figname)

fig = figure; hold all;
dtheta = pi/2/length(data);
theta = 0;
add_plot(fig, data{1}.dtiltl1, indices, [cos(theta)^2,0,sin(theta)^2]);
for i=1:length(data)
    theta = theta+dtheta; add_plot(fig, data{i}.dtiltl2, indices, [cos(theta)^2,0,sin(theta)^2]);
end
xlabel('tilt divergence angle [deg]');
ylabel('unnormalized probability');
title(strrep(figname,'_','-'));
saveas(fig, [figname, '.fig'], 'fig');


function data = load_data(fname)

load(fname);
data.machine = r.machines.machine;
data.indices = r.indices;
data.tilt0 = [];
data.tilt1 = [];
data.tilt2 = [];
data.tiltl0 = [];
data.tiltl1 = [];
data.tiltl2 = [];

for i=1:length(r.machines.coupling)
    data.tilt0 = [data.tilt0; r.machines.coupling{i}.tilt];
    data.tilt1 = [data.tilt1; r.machines.coupling_ids{i}.tilt];
    data.tilt2 = [data.tilt2; r.machines.coupling_ids_feedback{i}.tilt];
    data.tiltl0 = [data.tiltl0; r.machines.coupling{i}.tiltl];
    data.tiltl1 = [data.tiltl1; r.machines.coupling_ids{i}.tiltl];
    data.tiltl2 = [data.tiltl2; r.machines.coupling_ids_feedback{i}.tiltl];
end
data.dtilt1 = data.tilt1-data.tilt0;
data.dtilt2 = data.tilt2-data.tilt0;
data.dtiltl1 = data.tiltl1-data.tiltl0;
data.dtiltl2 = data.tiltl2-data.tiltl0;


function add_plot(fig, data, idx, pcolor)

dtilt1_rms = sqrt(sum(data(:,idx).^2,2)/length(idx));
d = dtilt1_rms;
davg = mean(d); dstd = std(d);
x = davg + linspace(-3*dstd,3*dstd,1001);
y = exp(-(x-davg).^2/(2*dstd^2));
figure(fig);
plot((180/pi)*x, y, 'Color', pcolor);

fprintf('%5.2f +/- %5.2f | ', (180/pi)*davg, (180/pi)*dstd);

