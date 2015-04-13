function plotchamberT(TracyVersion)
% Plot vaccum chamber produced by Tracy code
%
% TracyVersion : tracy2 or tracy3 format

if nargin == 0
    TracyVersion='tracy2';
end

% lecture du fichier de structure
% files = fullfile(getmmlroot, 'machine/SOLEIL/common/naff/naffutils/structure');
% try
%     struc=dlmread(files);
% catch
%     error('Error while opening file %s',files)
% end

%% Lecture du fichier de la chambre
file0 = 'chambre.out';

try
    if strcmpi(TracyVersion, 'tracy2')
    % Tracy 2
    [num dummy s mxch pxch vch ] = textread(file0,'%d %s %f %f %f %f','headerlines',3);
    else
    % Tracy 3
    [num dummy s mxch pxch vch vch] = textread(file0,'%d %s %f %f %f %f %f','headerlines',3);
    end
catch
    error('Error while opening file %s',file0)
end

figure(42)
clf
subplot(2,1,1)
plot(s,pxch,'k-');
hold on
plot(s,mxch,'k-');
% plot(struc(:,1),struc(:,2)/2*0.3*max(pxch),'k-');
axis([0 44.2621 1.1*min(mxch) 1.1*max(pxch)]);
grid on
xlabel('s (m)')
ylabel('x (mm)')
title('Vacuum pipe dimensions')

subplot(2,1,2)
plot(s,vch,'k-');
hold on
% plot(struc(:,1),struc(:,2)/2*0.3*max(vch),'k-')
plot(s,-vch,'k-');
axis([0 44.2621 -1.1*max(vch) 1.1*max(vch)]);
grid on
xlabel('s (m)')
ylabel('z (mm)')

addlabel(0,0,datestr(now));
