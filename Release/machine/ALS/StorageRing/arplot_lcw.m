function arplot_lcw(monthStr, days, year1, month2Str, days2, year2)
%ARPLOT_LCW - Plots various data from the ALS archiver for some LCW parameters
%  arplot_lcw(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
%
%  EXAMPLE
%  arplot_lcw('September',1:19,2008);
%


% Inputs
if nargin < 2
    monthStr = 'August';
    days = 5;
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

LeftGraphColor = 'b';
RightGraphColor = 'r';

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
LCWparams = [];
lcw = [];
CWTemp = [];
CWValve = [];
RingLCWSupPx = [];
RingLCWRetPx = [];
LCWSupPx = [];
LCWRetPx = [];
LCWSupTemp = [];
LCWRetTemp = [];
WBasinTemp = [];
EBasinTemp = [];

ChanNames = {
    'GP100_SPEED','Exchanger Pump Speed'
    'GP101_SPEED','Exchanger Pump Speed'
    'GP110_SPEED','Treated Water Pump Speed'
    'GP114_SPEED','LCW Pump Speed'
    'GP115_SPEED','LCW Pump Speed'
    'GP116_SPEED','LCW Pump Speed'
    'GP117_SPEED','Treated Water Pump Speed'
    'CT100_SPEED','Fan Speed'
    'CT101_SPEED','Fan Speed'
    'GP102_STATE','Exchanger Pump On Off'
    'GP103_STATE','Exchanger Pump On Off'
    'GP104_STATE','Exchanger Pump On Off'
    'GP112_STATE','LCW Pump On Off'
    'GP113_STATE','LCW Pump On Off'
    };

exchangerind = [];
for loop=1:length(ChanNames)
    if strfind(ChanNames{loop,2},'Exchanger')==1
        exchangerind=[exchangerind loop];
    end
end

booleanind = [];
for loop=1:length(ChanNames)
    if ~isempty(strfind(ChanNames{loop,2},'On Off'))
        booleanind=[booleanind loop];
    end
end

fanind = [];
for loop=1:length(ChanNames)
    if ~isempty(strfind(ChanNames{loop,2},'Fan'))
        fanind=[fanind loop];
    end
end

waterind = 1:length(ChanNames);
waterind([booleanind fanind])=[];

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
    t = [t ARt+(day-StartDay)*24*60*60];

    % Add Channels Here (and below)
    LCWparams = [LCWparams arselect(cell2mat(ChanNames(:,1)))];

    lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
    CWTemp = [CWTemp arselect('6_______CW__T__AM00')]; %chilled H20 supply temp. bld 6 AHU's F
    CWValve = [CWValve arselect('6_______CWV____AM00')]; %chilled water valve
    RingLCWSupPx = [RingLCWSupPx arselect('SR11U___H2OPX1_AM00')]; %Bldg 6 LCW supply pressure in PSI
    RingLCWRetPx = [RingLCWRetPx arselect('SR11U___H2OPX2_AM01')]; %Bldg 6 LCW return pressure in PSI
    LCWSupPx = [LCWSupPx arselect('37LCW___SPPAVG_AM00')]; %LCW supply pressure average in PSI
    LCWRetPx = [LCWRetPx arselect('37LCW___RTP____AM00')]; %LCW return pressure in PSIG
    LCWSupTemp = [LCWSupTemp arselect('37LCW___SPTAVG_AM00')]; %LCW supply temperature average in deg. F
    LCWRetTemp = [LCWRetTemp arselect('37LCW___RTT')]; %LCW return temperature (3 entries)
    WBasinTemp = [WBasinTemp arselect('37CT100_TW_ST__AM00')]; %North Cooling tower supply (basin) temperature
    EBasinTemp = [EBasinTemp arselect('37CT101_TW_ST__AM00')]; %South Cooling tower supply (basin) temperature
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
        LCWparams = [LCWparams arselect(cell2mat(ChanNames(:,1)))];

        lcw = [lcw arselect('SR03S___LCWTMP_AM00')];
        CWTemp = [CWTemp arselect('6_______CW__T__AM00')]; %chilled H20 supply temp. bld 6 AHU's F
        CWValve = [CWValve arselect('6_______CWV____AM00')]; %chilled water valve
        RingLCWSupPx = [RingLCWSupPx arselect('SR11U___H2OPX1_AM00')]; %Bldg 6 LCW supply pressure in PSI
        RingLCWRetPx = [RingLCWRetPx arselect('SR11U___H2OPX2_AM01')]; %Bldg 6 LCW return pressure in PSI
        LCWSupPx = [LCWSupPx arselect('37LCW___SPPAVG_AM00')]; %LCW supply pressure average in PSI
        LCWRetPx = [LCWRetPx arselect('37LCW___RTP____AM00')]; %LCW return pressure in PSIG
        LCWSupTemp = [LCWSupTemp arselect('37LCW___SPTAVG_AM00')]; %LCW supply temperature average in deg. F
        LCWRetTemp = [LCWRetTemp arselect('37LCW___RTT')]; %LCW return temperature (3 entries)
        WBasinTemp = [WBasinTemp arselect('37CT100_TW_ST__AM00')]; %North Cooling tower supply (basin) temperature
        EBasinTemp = [EBasinTemp arselect('37CT101_TW_ST__AM00')]; %South Cooling tower supply (basin) temperature
    end
end

% Convert to celcius
LCWSupTemp = (LCWSupTemp-32)*5/9;
LCWRetTemp = (LCWRetTemp-32)*5/9;
WBasinTemp = (WBasinTemp-32)*5/9;
EBasinTemp = (EBasinTemp-32)*5/9;
CWTemp     = (CWTemp-32)*5/9;

ind=find(all(LCWparams<5));
LCWparams(:,ind)=NaN;
lcw(:,ind) = NaN;
CWTemp(:,ind) = NaN;
CWValve(:,ind) = NaN;
RingLCWSupPx(:,ind) = NaN;
RingLCWRetPx(:,ind) = NaN;
LCWSupPx(:,ind) = NaN;
LCWRetPx(:,ind) = NaN;
LCWSupTemp(:,ind) = NaN;
LCWRetTemp(:,ind) = NaN;
WBasinTemp(:,ind) = NaN;
EBasinTemp(:,ind) = NaN;

ind=find(all(LCWparams(exchangerind,:)<5));
LCWparams(:,ind)=NaN;
lcw(:,ind) = NaN;
CWTemp(:,ind) = NaN;
CWValve(:,ind) = NaN;
RingLCWSupPx(:,ind) = NaN;
RingLCWRetPx(:,ind) = NaN;
LCWSupPx(:,ind) = NaN;
LCWRetPx(:,ind) = NaN;
LCWSupTemp(:,ind) = NaN;
LCWRetTemp(:,ind) = NaN;
WBasinTemp(:,ind) = NaN;
EBasinTemp(:,ind) = NaN;

% Remove unrealistic data
LCWSupPx(find(LCWSupPx<10)) = NaN;
LCWRetPx(find(LCWRetPx<10)) = NaN;
LCWSupTemp(find(LCWSupTemp<15)) = NaN;
LCWRetTemp(find(LCWRetTemp<15)) = NaN;
WBasinTemp(find(WBasinTemp<15)) = NaN;
EBasinTemp(find(EBasinTemp<15)) = NaN;

[ind1,ind2]=find(LCWparams(booleanind,:)>1.1);
LCWparams(booleanind(ind1),ind2)=NaN;

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


h = figure;
subfig(1,1,1,h);
clf reset

%h = subplot(2,1,1);
subplot(3,1,1)
plot(t, LCWparams(waterind,:));
xaxis([0 MaxTime]);
grid on;
title(['LCW Parameters: ',titleStr]);
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Frequency [Hz]');
h=legend(ChanNames(waterind,2));

subplot(3,1,2)
plot(t, LCWparams(fanind,:));
xaxis([0 MaxTime]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('Frequency [Hz]');
h=legend(ChanNames(fanind,2));

subplot(3,1,3)
plot(t,LCWparams(booleanind,:)+(ones(length(LCWparams),1)*[0:0.01:0.01*(length(booleanind)-1)])');
axis([0 MaxTime 0 1.1]);
grid on;
ChangeAxesLabel(t, Days, DayFlag);
ylabel('On/Off');
h=legend(ChanNames(booleanind,2));
orient tall

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

%set(h,'interpreter','none');


% Hill and water temperatures

h = figure;
subfig(1,1,1, h);
%p = get(h, 'Position');
%set(h, 'Position', FigurePosition);
clf reset;

subplot(5,1,1);
[ax, h1, h2] = plotyy(t,RingLCWSupPx, t,RingLCWRetPx);
set(get(ax(1),'Ylabel'), 'String', {'Ring LCW [PSI]',' ','Px_{supply}'});
set(get(ax(2),'Ylabel'), 'String', {'Ring LCW [PSI]',' ','Px_{return}'}, 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
%axisvals = axis;
%yaxis([axisvals(3)-.5 axisvals(4)+.5]);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

title(['Cooling Water Parameters: ',titleStr]);


subplot(5,1,2);
[ax, h1, h2] = plotyy(t,LCWSupPx, t,RingLCWRetPx);
set(get(ax(1),'Ylabel'), 'String', {'Tower [PSI]',' ','Px_{supply}'});
set(get(ax(2),'Ylabel'), 'String', {'Tower [PSI]',' ','Px_{return}'}, 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');

subplot(5,1,3);
[ax, h1, h2] = plotyy(t,WBasinTemp, t,EBasinTemp);
set(get(ax(1),'Ylabel'), 'String', '\fontsize{10}W.Basin (chiller) \fontsize{10}[C]');
set(get(ax(2),'Ylabel'), 'String', '\fontsize{10}E.Basin (LCW) \fontsize{10}[C]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


subplot(5,1,4);
[ax, h1, h2] = plotyy(t,LCWSupTemp, t,LCWRetTemp);
set(get(ax(1),'Ylabel'), 'String', 'LCW_{supply} [C]');
set(get(ax(2),'Ylabel'), 'String', 'LCW_{return} [C]', 'Color', RightGraphColor);
set(ax(2), 'YColor', RightGraphColor);
set(h2, 'Color', RightGraphColor);
grid on
axes(ax(1));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
axes(ax(2));
aa = axis;
aa(1) = 0;
aa(2) = MaxTime;
axis(aa);
if DayFlag
    MaxDay = round(max(t));
    set(ax(1),'XTick',[0:MaxDay]');
    set(ax(2),'XTick',[0:MaxDay]');
end
set(ax(1),'XTickLabel','');
set(ax(2),'XTickLabel','');


subplot(5,1,5);
plot(t, lcw, 'b'); grid on;
ylabel({'LCW [C]','(SR03 Sensor)'}, 'Color', LeftGraphColor);
set(gca,'YColor', LeftGraphColor);
xaxis([0 MaxTime]);

xlabel(xlabelstring);
ChangeAxesLabel(t, Days, DayFlag);

yaxesposition(1.15);
setappdata(2, 'ArchiveDate', DirectoryDate);
orient tall


if isunix
    cd('/home/als/physdata/matlab/srdata/LCW')
else
    cd('\\Als-filer\physdata\matlab\srdata\LCW')
end

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
