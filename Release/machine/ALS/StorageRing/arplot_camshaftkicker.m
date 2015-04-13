function arplot_camshaftkicker(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_CAMSHAFTKICKER - Plots various data from the ALS archiver for the camshaft fast kicker magnet
%  arplot_camshaftkicker(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLES
%  1. arplot_camshaftkicker('September', 1:19, 2008);
%
%  See also camshaftkickertemperatures


% Inputs
if nargin < 2
    monthStr = 'November';
    days = 6;
end
if nargin < 3
    tmp = clock;
    year1 = tmp(1);
end
if nargin < 4
    monthStr2 = [];
end
if nargin < 5
    days2 = [];
end
if nargin < 6
    year2 = year1;
end


BooleanFlag = 0;

arglobal

if isempty(days2)
    if length(days) == [1]
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [''];
        titleStr = [StartDayStr];
        DirectoryDate = sprintf('%d-%02d-%02d', year1, month, days(1));
    else
        month  = mon2num(monthStr);
        NumDays = length(days);
        StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
        EndDayStr =   [monthStr, ' ', num2str(days(length(days))),', ', num2str(year1)];
        titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
        DirectoryDate = sprintf('%d-%02d-%02d to %d-%02d-%02d', year1, month, days(1), year1, month, days(end));
    end
else
    month  = mon2num(monthStr);
    month2 = mon2num(month2Str);
    NumDays = length(days) + length(days2);
    StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
    EndDayStr =   [month2Str, ' ', num2str(days2(length(days2))),', ', num2str(year2)];
    titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
    DirectoryDate = sprintf('%d-%02d-%02d to %d-%02d-%02d', year1, month, days(1), year2, month2, days2(end));
end

StartDay = days(1);
EndDay = days(length(days));

t = [];
Tempuratures = [];

% Updated 2008-12-01 (GP - Visual inspection)
ChanNames = {
   %'SR02W___TCWAGO_AM00', 'TC-1'
    'SR02W___TCWAGO_AM01', 'No Label, Chamber (Upstream/Beam Height)'   % #1, Silver TC, no label (should be varified!!!)
   %'SR02W___TCWAGO_AM02', 'TC-3'
   %'SR02W___TCWAGO_AM03', 'TC-4'
   %'SR02W___TCWAGO_AM04', 'TC-5' % Not connected
   %'SR02W___TCWAGO_AM05', 'TC-6'
   %'SR02W___TCWAGO_AM06', 'TC-7'
    'SR02W___TCWAGO_AM07', 'TC-8  Chamber     (Upstream/Top)'           % #3
    'SR02W___TCWAGO_AM08', 'TC-9  Chamber     (Downstream/Beam Height)' % #6
    'SR02W___TCWAGO_AM09', 'TC-10 Feedthru    (Downstream/Top)'         % #5
    'SR02W___TCWAGO_AM10', 'TC-11 Feedthru    (Upstream/Top)'           % #2
    'SR02W___TCWAGO_AM11', 'TC-12 Spool Piece (Upstream/Top)'           % #4
    };


% Month #1
for day = days
    year1str = num2str(year1);
    if year1 < 2000
        year1str = year1str(3:4);
        FileName = sprintf('%2s%02d%02d', year1str, month, day);
    else
        FileName = sprintf('%4s%02d%02d', year1str, month, day);
    end
    arread(FileName, BooleanFlag);

    % time vector
    t = [t  ARt+(day-StartDay)*24*60*60];
    
    % Add Channels Here (and below)
    Tempuratures = [Tempuratures arselect(cell2mat(ChanNames(:,1)))];
end


% Month #2
if ~isempty(days2)

    StartDay = days2(1);
    EndDay = days2(length(days2));

    for day = days2
        year2str = num2str(year2);
        if year2 < 2000
            year2str = year2str(3:4);
            FileName = sprintf('%2s%02d%02d', year2str, month2, day);
        else
            FileName = sprintf('%4s%02d%02d', year2str, month2, day);
        end
        arread(FileName, BooleanFlag);

        % time vector
        t = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
        
        % Add Channels Here
        Tempuratures = [Tempuratures arselect(cell2mat(ChanNames(:,1)))];
    end
end


% Hours or days for the x-axis?
if t(end)/60/60/24 > 3
    t = t/60/60/24;
    xlabelstring = ['Date since ', StartDayStr, ' [Days]'];
    DayFlag = 1;
else
    t = t/60/60;
    xlabelstring = ['Time since ', StartDayStr, ' [Hours]'];
    DayFlag = 0;
end
Days = [days days2];
MaxTime = max(t);




%%%%%%%%%%%%%%%%
% Plot figures %
%%%%%%%%%%%%%%%%


%h = figure(1);
clf reset
%subfig(1,1,1,h);

%h = subplot(2,1,1);
plot(t, Tempuratures);
xaxis([0 MaxTime]);
grid on;
title(['Camshaft Kicker Temperaturs  ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Degrees [C]');
h=legend(ChanNames(:,2));
%set(h,'interpreter','none');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel(t, Days, DayFlag)
xaxis([0 max(t)]);

if DayFlag
    if size(Days,2) > 1
        Days = Days'; % Make a column vector
    end

    MaxDay = round(max(t));
    set(gca,'XTick',[0:MaxDay]');
    %xaxis([0 MaxDay]);

    if length(Days) < MaxDay-1
        % Days were skipped
        set(gca,'XTickLabel',strvcat(num2str([0:MaxDay-1]'+Days(1)),' '));
    else
        % All days plotted
        set(gca,'XTickLabel',strvcat(num2str(Days),' '));
    end

    XTickLabelString = get(gca,'XTickLabel');
    if MaxDay < 20
        % ok
    elseif MaxDay < 40
        set(gca,'XTick',[0:2:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:2:end-1,:));
    elseif MaxDay < 63
        set(gca,'XTick',[0:3:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:3:end-1,:));
    elseif MaxDay < 80
        set(gca,'XTick',[0:4:MaxDay]');
        set(gca,'XTickLabel',XTickLabelString(1:4:end-1,:));
    end
end
