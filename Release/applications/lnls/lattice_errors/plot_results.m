% PLOT_RESULTS plots the results obtained by analyse_results.
%
%   plot_results(results)
%
%   INPUT
%       results     results obtained by analyse_results
%
% 2012-10-26 Afonso Haruo Carnielli Mukai

function plot_results(results)

mms = 5;   % main marker size
mmt = 's'; % main marker type
mmc = 'b'; % main marker colour

oms = 3;   % min and max marker size
omt = 'o'; % min and max marker type
omc = 'k'; % min and max marker colour
olt = ':'; % min and max line type

elw = 2;   % rms line width
elc = 'r'; % rms line colour

maxY = 1.05; % max y value for axis

om = [olt omt omc];
el = [mmt elc];

n = length(results);

i             = 1:n;
tilt_rms      = zeros(4,n);
ratio         = zeros(4,n);
skewStr_max   = zeros(4,n);
skewStr_rms   = zeros(4,n);
beamSizeRatio = zeros(4,n);
etay_rms      = zeros(4,n);

xTickIdx = 0:n;
xTick = cell(1,n+2);
xTick{1} = '';
xTick{n+2} = '';

% Get results from cell array
for j=i
    xTick{j+1} = j;
    
    tilt_rms(1,j) = results{j}.tilt_rms.min;
    tilt_rms(2,j) = results{j}.tilt_rms.max;
    tilt_rms(3,j) = results{j}.tilt_rms.mean;
    tilt_rms(4,j) = results{j}.tilt_rms.std;
    
    ratio(1,j) = results{j}.ratio.min;
    ratio(2,j) = results{j}.ratio.max;
    ratio(3,j) = results{j}.ratio.mean;
    ratio(4,j) = results{j}.ratio.std;
    
    skewStr_max(1,j) = results{j}.skewStr_max.min;
    skewStr_max(2,j) = results{j}.skewStr_max.max;
    skewStr_max(3,j) = results{j}.skewStr_max.mean;
    skewStr_max(4,j) = results{j}.skewStr_max.std;
    
    skewStr_rms(1,j) = results{j}.skewStr_rms.min;
    skewStr_rms(2,j) = results{j}.skewStr_rms.max;
    skewStr_rms(3,j) = results{j}.skewStr_rms.mean;
    skewStr_rms(4,j) = results{j}.skewStr_rms.std;
    
    beamSizeRatio(1,j) = results{j}.beamSizeRatio.min;
    beamSizeRatio(2,j) = results{j}.beamSizeRatio.max;
    beamSizeRatio(3,j) = results{j}.beamSizeRatio.mean;
    beamSizeRatio(4,j) = results{j}.beamSizeRatio.std;
    
    etay_rms(1,j) = results{j}.etay_rms.min;
    etay_rms(2,j) = results{j}.etay_rms.max;
    etay_rms(3,j) = results{j}.etay_rms.mean;
    etay_rms(4,j) = results{j}.etay_rms.std;
end

figure;

% Plot RMS tilt
subplot(2,3,1);
hold all;
box on;
for j=i
    t = [j j];
    y = [tilt_rms(1,j) tilt_rms(2,j)];
    plot(t,y,om,'MarkerEdgeColor',omc,'MarkerFaceColor',omc,'MarkerSize',oms);
end
errorbar(i,tilt_rms(3,:),tilt_rms(4,:),...
    el,'MarkerEdgeColor',mmc,'MarkerFaceColor',mmc,'MarkerSize',mms,'LineWidth',elw);
set(gca,'XTick',xTickIdx,'XTickLabel',xTick);
axis([0 (n+1) 0 maxY*max(tilt_rms(2,:))]);
%title('RMS tilt');
xlabel('Configuration');
ylabel('\theta_{rms} [°]');

% Plot ratio
subplot(2,3,2);
hold all;
box on;
for j=i
    t = [j j];
    y = [ratio(1,j) ratio(2,j)];
    plot(t,y,om,'MarkerEdgeColor',omc,'MarkerFaceColor',omc,'MarkerSize',oms);
end
errorbar(i,ratio(3,:),ratio(4,:),...
    el,'MarkerEdgeColor',mmc,'MarkerFaceColor',mmc,'MarkerSize',mms,'LineWidth',elw);
set(gca,'XTick',xTickIdx,'XTickLabel',xTick);
axis([0 (n+1) 0 maxY*max(ratio(2,:))]);
%title('Coupling');
xlabel('Configuration');
ylabel('Coupling [%]');

% Plot skewStr_max
subplot(2,3,3);
hold all;
box on;
for j=i
    t = [j j];
    y = [skewStr_max(1,j) skewStr_max(2,j)];
    plot(t,y,om,'MarkerEdgeColor',omc,'MarkerFaceColor',omc,'MarkerSize',oms);
end
errorbar(i,skewStr_max(3,:),skewStr_max(4,:),...
    el,'MarkerEdgeColor',mmc,'MarkerFaceColor',mmc,'MarkerSize',mms,'LineWidth',elw);
set(gca,'XTick',xTickIdx,'XTickLabel',xTick);
axis([0 (n+1) 0 maxY*max(skewStr_max(2,:))]);
%title('Maximum absolute skew strength');
xlabel('Configuration');
ylabel('|K|_{max} [1/m^2]');

% Plot skewStr_rms
subplot(2,3,4);
hold all;
box on;
for j=i
    t = [j j];
    y = [skewStr_rms(1,j) skewStr_rms(2,j)];
    plot(t,y,om,'MarkerEdgeColor',omc,'MarkerFaceColor',omc,'MarkerSize',oms);
end
errorbar(i,skewStr_rms(3,:),skewStr_rms(4,:),...
    el,'MarkerEdgeColor',mmc,'MarkerFaceColor',mmc,'MarkerSize',mms,'LineWidth',elw);
set(gca,'XTick',xTickIdx,'XTickLabel',xTick);
axis([0 (n+1) 0 maxY*max(skewStr_rms(2,:))]);
%title('RMS skew strength');
xlabel('Configuration');
ylabel('K_{rms} [1/m^2]');

% Plot beamSizeRatio
subplot(2,3,5);
hold all;
box on;
for j=i
    t = [j j];
    y = [beamSizeRatio(1,j) beamSizeRatio(2,j)];
    plot(t,y,om,'MarkerEdgeColor',omc,'MarkerFaceColor',omc,'MarkerSize',oms);
end
errorbar(i,beamSizeRatio(3,:),beamSizeRatio(4,:),...
    el,'MarkerEdgeColor',mmc,'MarkerFaceColor',mmc,'MarkerSize',mms,'LineWidth',elw);
set(gca,'XTick',xTickIdx,'XTickLabel',xTick);
axis([0 (n+1) 0 maxY*max(beamSizeRatio(2,:))]);
%title('Vertical beam size ratio');
xlabel('Configuration');
ylabel('\sigma_y/\sigma_{y0}');

% Plot etay_rms
subplot(2,3,6);
hold all;
box on;
for j=i
    t = [j j];
    y = [etay_rms(1,j) etay_rms(2,j)];
    plot(t,y,om,'MarkerEdgeColor',omc,'MarkerFaceColor',omc,'MarkerSize',oms);
end
errorbar(i,etay_rms(3,:),etay_rms(4,:),...
    el,'MarkerEdgeColor',mmc,'MarkerFaceColor',mmc,'MarkerSize',mms,'LineWidth',elw);
set(gca,'XTick',xTickIdx,'XTickLabel',xTick);
axis([0 (n+1) 0 maxY*max(etay_rms(2,:))]);
%title('RMS vertical dispersion');
xlabel('Configuration');
ylabel('\eta_{y,rms} [mm]');
