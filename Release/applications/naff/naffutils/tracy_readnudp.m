function [dp nux nuz] = tracy_readnudp(file)
% function tracy_readnudp(file)
% plot tune shift with energy from tracy output file

DisplayFlag = 1;

if nargin < 1
    file ='nudp.out'
end

try
    [header data] = hdrload(file);
catch
    error('Error while opening filename %s',file)
end

%% energy in percent
dp = data(:,1)*100;

%% fractional tunes
nux = data(:,2);
nuz = data(:,3);
nux(nux==0)=NaN;
nuz(nuz==0)=NaN;

%% closed orbit
xcod = data(:,4)*1e3;
zcod = data(:,5)*1e3;

if DisplayFlag
    %% Set default properties
    set(0,'DefaultAxesXgrid','on');
    set(0,'DefaultAxesYgrid','on');

    %% Plot
    figure(44)
    subplot(1,2,1)
    plot(dp,nux,'.')
    xlabel('\delta (%)')
    ylabel('\nu_x')

    subplot(1,2,2)
    plot(dp,nuz,'.')
    xlabel('\delta (%)')
    ylabel('\nu_z')
    suptitle('Tune shift with energy')

    addlabel(0,0,datestr(now))

    h=figure(45)
    pos=get(h,'Position');
    set(h,'Position', [pos(1:2)  900 380]);
    subplot(1,2,1)
    plot(dp,xcod,'.')
    xlabel('\delta (%)')
    ylabel('xcod (mm)')

    subplot(1,2,2)
    plot(dp,zcod,'.')
    xlabel('\delta (%)')
    ylabel('zcod (mm)')
    suptitle('Closed orbit variation with energy')

    addlabel(0,0,datestr(now))
end
