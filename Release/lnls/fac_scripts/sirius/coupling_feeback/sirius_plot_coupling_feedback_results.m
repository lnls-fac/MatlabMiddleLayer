function plot_results

close all; drawnow;

fname = 'v18-01_3.0coup_0.5coup-ids_20b2_results.mat'; data1 = load_data(fname);
fname = 'v18-01_3.0coup_0.5coup-ids_10b2_results.mat'; data2 = load_data(fname);
%fname = 'v18-01_3.0coup_0.5coup-ids_5b2_results.mat';  data3 = load_data(fname);
%fname = 'v18-01_3.0coup_0.5coup-ids_1b2_results.mat';  data4 = load_data(fname);

data3 = 0; data4 = 0;

fprintf('mia: '); plot_at_indices(data1,data2,data3,data4,data1.indices.mia); fprintf('\n');
fprintf('mib: '); plot_at_indices(data1,data2,data3,data4,data1.indices.mib); fprintf('\n');
fprintf('mip: '); plot_at_indices(data1,data2,data3,data4,data1.indices.mip); fprintf('\n');
fprintf('mc : '); plot_at_indices(data1,data2,data3,data4,data1.indices.mic); fprintf('\n');


function plot_at_indices(data1,data2,data3,data4,indices)

fig = figure; hold all;
% dtheta = pi/2/4;
% theta = 0;            add_plot(fig, data4.dtilt1, indices, [cos(theta)^2,0,sin(theta)^2]);
% theta = theta+dtheta; add_plot(fig, data4.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);
% theta = theta+dtheta; add_plot(fig, data3.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);
% theta = theta+dtheta; add_plot(fig, data2.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);
% theta = theta+dtheta; add_plot(fig, data1.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);
dtheta = pi/2/2;
theta = 0;            add_plot(fig, data2.dtilt1, indices, [cos(theta)^2,0,sin(theta)^2]);
theta = theta+dtheta; add_plot(fig, data2.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);
theta = theta+dtheta; add_plot(fig, data1.dtilt2, indices, [cos(theta)^2,0,sin(theta)^2]);



function data = load_data(fname)

load(fname);
data.indices = r.indices;
data.tilt0 = [];
data.tilt1 = [];
data.tilt2 = [];
for i=1:length(r.machines.coupling)
    data.tilt0 = [data.tilt0; r.machines.coupling{i}.tilt];
    data.tilt1 = [data.tilt1; r.machines.coupling_ids{i}.tilt];
    data.tilt2 = [data.tilt2; r.machines.coupling_ids_feedback{i}.tilt];
end
data.dtilt1 = data.tilt1-data.tilt0;
data.dtilt2 = data.tilt2-data.tilt0;


function add_plot(fig, data, idx, pcolor)

dtilt1_rms = sqrt(sum(data(:,idx).^2,2)/length(idx));
d = dtilt1_rms;
davg = mean(d); dstd = std(d);
x = davg + linspace(-3*dstd,3*dstd,1001);
y = exp(-(x-davg).^2/(2*dstd^2));
figure(fig);
plot((180/pi)*x, y, 'Color', pcolor);

fprintf('%5.2f +/- %5.2f | ', (180/pi)*davg, (180/pi)*dstd);





