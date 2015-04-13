function arplot_flexbandtc(monthStr, days, year1, month2Str, days2, year2)
% arplot_flexbandtc(Month1 String, Days1, Year1, Month2 String, Days2, Year2)
% 
% Plots Beam Current and Flexband Thermocouple data.
%
% Example:  arplot_flexbandtc('January',22:24, 1998);
%           plots data from 1/22, 1/23, and 1/24 in 1998


% Inputs
if nargin < 2
   error('ARPLOTS:  You need at least two input arguments.');
elseif nargin == 2
   tmp = clock;
   year1 = tmp(1);
   monthStr2 = [];
   days2 = [];
   year2 = [];
elseif nargin == 3
   monthStr2 = [];
   days2 = [];
   year2 = [];
elseif nargin == 4
   error('ARPLOTS:  You need 2, 3, 5, or 6 input arguments.');
elseif nargin == 5
   tmp = clock;
   year2 = tmp(1);
elseif nargin == 6
else
   error('ARPLOTS:  Inputs incorrect.');
end

global GLOBAL_SR_MODE_TITLE

if strcmp(GLOBAL_SR_MODE_TITLE, '1.9 GeV, Two Bunch')
   dcctplotmax = 60;
else
   dcctplotmax = 500;
end

arglobal


t=[];
dcct=[];
IDgap4=[];
IDgap5=[];
IDgap7=[];
IDgap8=[];
IDgap9=[];
IDgap10=[];
IDgap11=[];
IDgap12=[];

SR01TC1 = []; SR01TC2 = []; SR01TC3 = []; SR01TC4 = []; SR01TC5 = []; SR01TC6 = [];
SR02TC1 = []; SR02TC2 = []; SR02TC3 = []; SR02TC4 = []; SR02TC5 = []; SR02TC6 = [];
SR03TC1 = []; SR03TC2 = []; SR03TC3 = []; SR03TC4 = []; SR03TC5 = []; SR03TC6 = [];
SR04TC1 = []; SR04TC2 = []; SR04TC3 = []; SR04TC4 = []; SR04TC5 = []; SR04TC6 = [];
SR05TC1 = []; SR05TC2 = []; SR05TC3 = []; SR05TC4 = []; SR05TC5 = []; SR05TC6 = [];
SR06TC1 = []; SR06TC2 = []; SR06TC3 = []; SR06TC4 = []; SR06TC5 = []; SR06TC6 = [];
SR07TC1 = []; SR07TC2 = []; SR07TC3 = []; SR07TC4 = []; SR07TC5 = []; SR07TC6 = [];
SR08TC1 = []; SR08TC2 = []; SR08TC3 = []; SR08TC4 = []; SR08TC5 = []; SR08TC6 = [];
SR09TC1 = []; SR09TC2 = []; SR09TC3 = []; SR09TC4 = []; SR09TC5 = []; SR09TC6 = [];
SR10TC1 = []; SR10TC2 = []; SR10TC3 = []; SR10TC4 = []; SR10TC5 = []; SR10TC6 = [];
SR11TC1 = []; SR11TC2 = []; SR11TC3 = []; SR11TC4 = []; SR11TC5 = []; SR11TC6 = [];
SR12TC1 = []; SR12TC2 = []; SR12TC3 = []; SR12TC4 = []; SR12TC5 = []; SR12TC6 = [];

if isempty(days2)
   if length(days) == [1]
      month  = mon2num(monthStr);
      NumDays = length(days);
      StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
      EndDayStr =   [''];
      titleStr = [StartDayStr];
   else
      month  = mon2num(monthStr);
      NumDays = length(days);
      StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
      EndDayStr =   [monthStr, ' ', num2str(days(length(days))),', ', num2str(year1)];
      titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
   end
else
   month  = mon2num(monthStr);
   month2 = mon2num(month2Str);
   NumDays = length(days) + length(days2);
   StartDayStr = [monthStr, ' ', num2str(days(1)),', ', num2str(year1)];
   EndDayStr =   [month2Str, ' ', num2str(days2(length(days2))),', ', num2str(year2)];
   
   titleStr = [StartDayStr,' to ', EndDayStr,' (', num2str(NumDays),' days)'];
end


StartDay = days(1);
EndDay = days(length(days));
N=0;

for day = days
   day;
   %t0=clock;
   year1str = num2str(year1);
   if year1 < 2000
      year1str = year1str(3:4);
      FileName = sprintf('%2s%02d%02d', year1str, month, day);
   else
      FileName = sprintf('%4s%02d%02d', year1str, month, day);
   end
   FileName = sprintf('%2s%02d%02d', year1str, month, day);
   arread(FileName);
   %readtime = etime(clock, t0)
   
   [y1, idcct] = arselect('SR05S___DCCTLP_AM01');
   dcct = [dcct y1];
   [y1,i]=arselect('SR05W___GDS1PS_AM00');
   [y2,i]=arselect('SR07U___GDS1PS_AM00');
   [y3,i]=arselect('SR08U___GDS1PS_AM00');
   [y4,i]=arselect('SR09U___GDS1PS_AM00');
   [y5,i]=arselect('SR12U___GDS1PS_AM00');
   IDgap5 =[IDgap5  y1];
   IDgap7 =[IDgap7  y2];
   IDgap8 =[IDgap8  y3];
   IDgap9 =[IDgap9  y4];
   IDgap12=[IDgap12 y5];

if 0
	[y1, i] = arselect('SR01W___TCWAGO');
   SR01TC = [SR01TC y1];
   SR01TCname = ARChanNames(i,:);
   [d,SR01TCdesc] = unix(['caget ' SR01TCname(1:19) '.DESC'])
   SR01TCdesc = SR01TCdesc(end-22:end)
   
   [y1, i] = arselect('SR02W___TCWAGO');
   SR02TC = [SR02TC y1];
   [y1, i] = arselect('SR03W___TCWAGO');
   SR03TC = [SR03TC y1];
   [y1, i] = arselect('SR04W___TCWAGO');
   SR04TC = [SR04TC y1];
   [y1, i] = arselect('SR05W___TCWAGO');
   SR05TC = [SR05TC y1];
   [y1, i] = arselect('SR06W___TCWAGO');
   SR06TC = [SR06TC y1];
   [y1, i] = arselect('SR07W___TCWAGO');
   SR07TC = [SR07TC y1];
   [y1, i] = arselect('SR08W___TCWAGO');
   SR08TC = [SR08TC y1];
   [y1, i] = arselect('SR09W___TCWAGO');
   SR09TC = [SR09TC y1];
   [y1, i] = arselect('SR10W___TCWAGO');
   SR10TC = [SR10TC y1];
   [y1, i] = arselect('SR11W___TCWAGO');
   SR11TC = [SR11TC y1];
   [y1, i] = arselect('SR12W___TCWAGO');
   SR12TC = [SR12TC y1];
end

   [y1, i] = arselect('SR01W___TCWAGO_AM00');
   SR01TC1 = [SR01TC1 y1]; 
	[y1, i] = arselect('SR01W___TCWAGO_AM01');
   SR01TC2 = [SR01TC2 y1]; 
   [y1, i] = arselect('SR01W___TCWAGO_AM02');
   SR01TC3 = [SR01TC3 y1]; 
   [y1, i] = arselect('SR01W___TCWAGO_AM03');
   SR01TC4 = [SR01TC4 y1]; 
   [y1, i] = arselect('SR01W___TCWAGO_AM04');
   SR01TC5 = [SR01TC5 y1]; 
   [y1, i] = arselect('SR01W___TCWAGO_AM05');
   SR01TC6 = [SR01TC6 y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM00');
   SR02TC1 = [SR02TC1 y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM01');
   SR02TC2 = [SR02TC2 y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM02');
   SR02TC3 = [SR02TC3 y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM03');
   SR02TC4 = [SR02TC4 y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM04');
   SR02TC5 = [SR02TC5 y1]; 
   [y1, i] = arselect('SR02W___TCWAGO_AM05');
   SR02TC6 = [SR02TC6 y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM00');
   SR03TC1 = [SR03TC1 y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM01');
   SR03TC2 = [SR03TC2 y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM02');
   SR03TC3 = [SR03TC3 y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM03');
   SR03TC4 = [SR03TC4 y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM04');
   SR03TC5 = [SR03TC5 y1]; 
   [y1, i] = arselect('SR03W___TCWAGO_AM05');
   SR03TC6 = [SR03TC6 y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM00');
   SR04TC1 = [SR04TC1 y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM01');
   SR04TC2 = [SR04TC2 y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM02');
   SR04TC3 = [SR04TC3 y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM03');
   SR04TC4 = [SR04TC4 y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM04');
   SR04TC5 = [SR04TC5 y1]; 
   [y1, i] = arselect('SR04W___TCWAGO_AM05');
   SR04TC6 = [SR04TC6 y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM00');
   SR05TC1 = [SR05TC1 y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM01');
   SR05TC2 = [SR05TC2 y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM02');
   SR05TC3 = [SR05TC3 y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM03');
   SR05TC4 = [SR05TC4 y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM04');
   SR05TC5 = [SR05TC5 y1]; 
   [y1, i] = arselect('SR05W___TCWAGO_AM05');
   SR05TC6 = [SR05TC6 y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM00');
   SR06TC1 = [SR06TC1 y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM01');
   SR06TC2 = [SR06TC2 y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM02');
   SR06TC3 = [SR06TC3 y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM03');
   SR06TC4 = [SR06TC4 y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM04');
   SR06TC5 = [SR06TC5 y1]; 
   [y1, i] = arselect('SR06W___TCWAGO_AM05');
   SR06TC6 = [SR06TC6 y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM00');
   SR07TC1 = [SR07TC1 y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM01');
   SR07TC2 = [SR07TC2 y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM02');
   SR07TC3 = [SR07TC3 y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM03');
   SR07TC4 = [SR07TC4 y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM04');
   SR07TC5 = [SR07TC5 y1]; 
   [y1, i] = arselect('SR07W___TCWAGO_AM05');
   SR07TC6 = [SR07TC6 y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM00');
   SR08TC1 = [SR08TC1 y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM01');
   SR08TC2 = [SR08TC2 y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM02');
   SR08TC3 = [SR08TC3 y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM03');
   SR08TC4 = [SR08TC4 y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM04');
   SR08TC5 = [SR08TC5 y1]; 
   [y1, i] = arselect('SR08W___TCWAGO_AM05');
   SR08TC6 = [SR08TC6 y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM00');
   SR09TC1 = [SR09TC1 y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM01');
   SR09TC2 = [SR09TC2 y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM02');
   SR09TC3 = [SR09TC3 y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM03');
   SR09TC4 = [SR09TC4 y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM04');
   SR09TC5 = [SR09TC5 y1]; 
   [y1, i] = arselect('SR09W___TCWAGO_AM05');
   SR09TC6 = [SR09TC6 y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM00');
   SR10TC1 = [SR10TC1 y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM01');
   SR10TC2 = [SR10TC2 y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM02');
   SR10TC3 = [SR10TC3 y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM03');
   SR10TC4 = [SR10TC4 y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM04');
   SR10TC5 = [SR10TC5 y1]; 
   [y1, i] = arselect('SR10W___TCWAGO_AM05');
   SR10TC6 = [SR10TC6 y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM00');
   SR11TC1 = [SR11TC1 y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM01');
   SR11TC2 = [SR11TC2 y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM02');
   SR11TC3 = [SR11TC3 y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM03');
   SR11TC4 = [SR11TC4 y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM04');
   SR11TC5 = [SR11TC5 y1]; 
   [y1, i] = arselect('SR11W___TCWAGO_AM05');
   SR11TC6 = [SR11TC6 y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM00');
   SR12TC1 = [SR12TC1 y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM01');
   SR12TC2 = [SR12TC2 y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM02');
   SR12TC3 = [SR12TC3 y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM03');
   SR12TC4 = [SR12TC4 y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM04');
   SR12TC5 = [SR12TC5 y1]; 
   [y1, i] = arselect('SR12W___TCWAGO_AM05');
   SR12TC6 = [SR12TC6 y1]; 
   
%   for j = 1:12
%      [y1, i] = arselect(sprintf('SR%02dC___IG2____AM00',j));
%      IG1(j,N+1:N+length(ARt))=y1;
%   end;

   N = N + length(ARt);
   
   t    = [t  ARt+(day-StartDay)*24*60*60];
   
   disp(' ');
end


if ~isempty(days2)
   
   StartDay = days2(1);
   EndDay = days2(length(days2));
   
   for day = days2
      day;
      %t0=clock;
      year2str = num2str(year2);
      if year2 < 2000
         year2str = year2str(3:4);
         FileName = sprintf('%2s%02d%02d', year2str, month, day);
      else
         FileName = sprintf('%4s%02d%02d', year2str, month, day);
      end
      FileName = sprintf('%2s%02d%02d', year2str, month2, day);
      arread(FileName);
      %readtime = etime(clock, t0)
      
		[y1, idcct] = arselect('SR05S___DCCTLP_AM01');
		dcct = [dcct y1];
		[y1,i]=arselect('SR05W___GDS1PS_AM00');
		[y2,i]=arselect('SR07U___GDS1PS_AM00');
		[y3,i]=arselect('SR08U___GDS1PS_AM00');
		[y4,i]=arselect('SR09U___GDS1PS_AM00');
		[y5,i]=arselect('SR12U___GDS1PS_AM00');
		IDgap5 =[IDgap5  y1];
		IDgap7 =[IDgap7  y2];
		IDgap8 =[IDgap8  y3];
		IDgap9 =[IDgap9  y4];
		IDgap12=[IDgap12 y5];
		
	if 0
		[y1, i] = arselect('SR02W___TCWAGO');
		SR02TC = [SR02TC y1];
		[y1, i] = arselect('SR03W___TCWAGO');
		SR03TC = [SR03TC y1];
		[y1, i] = arselect('SR04W___TCWAGO');
		SR04TC = [SR04TC y1];
		[y1, i] = arselect('SR05W___TCWAGO');
		SR05TC = [SR05TC y1];
		[y1, i] = arselect('SR06W___TCWAGO');
		SR06TC = [SR06TC y1];
		[y1, i] = arselect('SR07W___TCWAGO');
		SR07TC = [SR07TC y1];
		[y1, i] = arselect('SR08W___TCWAGO');
		SR08TC = [SR08TC y1];
		[y1, i] = arselect('SR09W___TCWAGO');
		SR09TC = [SR09TC y1];
		[y1, i] = arselect('SR10W___TCWAGO');
		SR10TC = [SR10TC y1];
		[y1, i] = arselect('SR11W___TCWAGO');
		SR11TC = [SR11TC y1];
		[y1, i] = arselect('SR12W___TCWAGO');
		SR12TC = [SR12TC y1];
	end

		[y1, i] = arselect('SR01W___TCWAGO_AM00');
		SR01TC1 = [SR01TC1 y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM01');
		SR01TC2 = [SR01TC2 y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM02');
		SR01TC3 = [SR01TC3 y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM03');
		SR01TC4 = [SR01TC4 y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM04');
		SR01TC5 = [SR01TC5 y1]; 
		[y1, i] = arselect('SR01W___TCWAGO_AM05');
		SR01TC6 = [SR01TC6 y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM00');
		SR02TC1 = [SR02TC1 y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM01');
		SR02TC2 = [SR02TC2 y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM02');
		SR02TC3 = [SR02TC3 y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM03');
		SR02TC4 = [SR02TC4 y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM04');
		SR02TC5 = [SR02TC5 y1]; 
		[y1, i] = arselect('SR02W___TCWAGO_AM05');
		SR02TC6 = [SR02TC6 y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM00');
		SR03TC1 = [SR03TC1 y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM01');
		SR03TC2 = [SR03TC2 y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM02');
		SR03TC3 = [SR03TC3 y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM03');
		SR03TC4 = [SR03TC4 y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM04');
		SR03TC5 = [SR03TC5 y1]; 
		[y1, i] = arselect('SR03W___TCWAGO_AM05');
		SR03TC6 = [SR03TC6 y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM00');
		SR04TC1 = [SR04TC1 y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM01');
		SR04TC2 = [SR04TC2 y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM02');
		SR04TC3 = [SR04TC3 y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM03');
		SR04TC4 = [SR04TC4 y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM04');
		SR04TC5 = [SR04TC5 y1]; 
		[y1, i] = arselect('SR04W___TCWAGO_AM05');
		SR04TC6 = [SR04TC6 y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM00');
		SR05TC1 = [SR05TC1 y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM01');
		SR05TC2 = [SR05TC2 y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM02');
		SR05TC3 = [SR05TC3 y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM03');
		SR05TC4 = [SR05TC4 y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM04');
		SR05TC5 = [SR05TC5 y1]; 
		[y1, i] = arselect('SR05W___TCWAGO_AM05');
		SR05TC6 = [SR05TC6 y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM00');
		SR06TC1 = [SR06TC1 y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM01');
		SR06TC2 = [SR06TC2 y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM02');
		SR06TC3 = [SR06TC3 y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM03');
		SR06TC4 = [SR06TC4 y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM04');
		SR06TC5 = [SR06TC5 y1]; 
		[y1, i] = arselect('SR06W___TCWAGO_AM05');
		SR06TC6 = [SR06TC6 y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM00');
		SR07TC1 = [SR07TC1 y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM01');
		SR07TC2 = [SR07TC2 y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM02');
		SR07TC3 = [SR07TC3 y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM03');
		SR07TC4 = [SR07TC4 y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM04');
		SR07TC5 = [SR07TC5 y1]; 
		[y1, i] = arselect('SR07W___TCWAGO_AM05');
		SR07TC6 = [SR07TC6 y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM00');
		SR08TC1 = [SR08TC1 y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM01');
		SR08TC2 = [SR08TC2 y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM02');
		SR08TC3 = [SR08TC3 y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM03');
		SR08TC4 = [SR08TC4 y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM04');
		SR08TC5 = [SR08TC5 y1]; 
		[y1, i] = arselect('SR08W___TCWAGO_AM05');
		SR08TC6 = [SR08TC6 y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM00');
		SR09TC1 = [SR09TC1 y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM01');
		SR09TC2 = [SR09TC2 y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM02');
		SR09TC3 = [SR09TC3 y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM03');
		SR09TC4 = [SR09TC4 y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM04');
		SR09TC5 = [SR09TC5 y1]; 
		[y1, i] = arselect('SR09W___TCWAGO_AM05');
		SR09TC6 = [SR09TC6 y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM00');
		SR10TC1 = [SR10TC1 y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM01');
		SR10TC2 = [SR10TC2 y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM02');
		SR10TC3 = [SR10TC3 y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM03');
		SR10TC4 = [SR10TC4 y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM04');
		SR10TC5 = [SR10TC5 y1]; 
		[y1, i] = arselect('SR10W___TCWAGO_AM05');
		SR10TC6 = [SR10TC6 y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM00');
		SR11TC1 = [SR11TC1 y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM01');
		SR11TC2 = [SR11TC2 y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM02');
		SR11TC3 = [SR11TC3 y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM03');
		SR11TC4 = [SR11TC4 y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM04');
		SR11TC5 = [SR11TC5 y1]; 
		[y1, i] = arselect('SR11W___TCWAGO_AM05');
		SR11TC6 = [SR11TC6 y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM00');
		SR12TC1 = [SR12TC1 y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM01');
		SR12TC2 = [SR12TC2 y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM02');
		SR12TC3 = [SR12TC3 y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM03');
		SR12TC4 = [SR12TC4 y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM04');
		SR12TC5 = [SR12TC5 y1]; 
		[y1, i] = arselect('SR12W___TCWAGO_AM05');
		SR12TC6 = [SR12TC6 y1]; 

%     for j = 1:12
%        [y1, i] = arselect(sprintf('SR%02dC___IG2____AM00',j));
%        IG1(j,N+1:N+length(ARt))=y1;
%     end;

      N = N + length(ARt);
      
      
      t    = [t  ARt+(day-StartDay+(days(length(days))-days(1)+1))*24*60*60];
      
      disp(' ');
   end
end

dcct = 100*dcct;
i = find(dcct < 1.);
dcct(i) = NaN;
dlogdcct = diff(log(dcct));
lifetime = -diff(t/60/60)./(dlogdcct);
i = find(lifetime < 0);
lifetime(i) = NaN;

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
xmax = max(t);

% Channel descriptions - mine .DESC fields to get locations
%[d,SR01TC1full] = unix('scaget SR01W___TCWAGO_AM00.DESC');
%SR01TC1desc = SR01TC1full(end-22:end);
%
%SR01TC2desc = []; SR01TC3desc = []; SR01TC4desc = []; SR01TC5desc = []; SR01TC6desc = [];
%SR02TC1desc = []; SR02TC2desc = []; SR02TC3desc = []; SR02TC4desc = []; SR02TC5desc = []; SR02TC6desc = [];
%SR03TC1desc = []; SR03TC2desc = []; SR03TC3desc = []; SR03TC4desc = []; SR03TC5desc = []; SR03TC6desc = [];
%SR04TC1desc = []; SR04TC2desc = []; SR04TC3desc = []; SR04TC4desc = []; SR04TC5desc = []; SR04TC6desc = [];
%SR05TC1desc = []; SR05TC2desc = []; SR05TC3desc = []; SR05TC4desc = []; SR05TC5desc = []; SR05TC6desc = [];
%SR06TC1desc = []; SR06TC2desc = []; SR06TC3desc = []; SR06TC4desc = []; SR06TC5desc = []; SR06TC6desc = [];
%SR07TC1desc = []; SR07TC2desc = []; SR07TC3desc = []; SR07TC4desc = []; SR07TC5desc = []; SR07TC6desc = [];
%SR08TC1desc = []; SR08TC2desc = []; SR08TC3desc = []; SR08TC4desc = []; SR08TC5desc = []; SR08TC6desc = [];
%SR09TC1desc = []; SR09TC2desc = []; SR09TC3desc = []; SR09TC4desc = []; SR09TC5desc = []; SR09TC6desc = [];
%SR10TC1desc = []; SR10TC2desc = []; SR10TC3desc = []; SR10TC4desc = []; SR10TC5desc = []; SR10TC6desc = [];
%SR11TC1desc = []; SR11TC2desc = []; SR11TC3desc = []; SR11TC4desc = []; SR11TC5desc = []; SR11TC6desc = [];
%SR12TC1desc = []; SR12TC2desc = []; SR12TC3desc = []; SR12TC4desc = []; SR12TC5desc = []; SR12TC6desc = [];
%

n=1;
for Sector = 1:12
	for j = 1:6
	   try
           if isunix
               [d,chanstr] = unix(['caget ',sprintf('SR%02dW___TCWAGO_AM%02d.DESC',Sector, j-1)]);
               name{n} = chanstr(end-24:end-1); % end-1 is used to get rid of carriage return
           else
               name{n} = sprintf('SR%02dW TCWAGO AM%02d',Sector,j-1);
           end
       catch
           name{n} = sprintf('SR%02dW TCWAGO AM%02d',Sector,j-1);
       end
       n=n+1;
	end
end

% some of the TCs are on spots that don't fit the pattern (this as of 6-29-04)
name{71} = 'flex band 1-1 body';
name{2}  = 'flex band 1-2 body';
name{16} = [name{16} ' (not BPM FB)']; 
name{17} = [name{17} ' (not BPM FB)'];
name{18} = [name{18} ' (not BPM FB)']; 
name{19} = [name{19} ' (not BPM FB)']; 
name{20} = [name{20} ' (not BPM FB)'];
name{21} = [name{21} ' (not BPM FB)']; 
name{61} = 'flex band 11-2 bellows';
name{62} = 'flex band 11-2 D-flange';
name{63} = 'flex band 11-2 bellows (not BPM FB)';

%plot data
%first page
figure
subplot(4,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,2);
plot(t, SR12TC4, t, SR12TC5, t, SR12TC6, t, SR01TC1, t, SR01TC2, t, SR01TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{[70:72 1:3]},3);

subplot(4,1,3);
plot(t, SR01TC4, t, SR01TC5, t, SR01TC6, t, SR02TC1, t, SR02TC2, t, SR02TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{4:9},3);

subplot(4,1,4);
plot(t, SR02TC4, t, SR02TC5, t, SR02TC6, t, SR03TC1, t, SR03TC2, t, SR03TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
xlabel(xlabelstring);
legend(name{10:15},3);

orient landscape

% second page
figure
subplot(4,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,2);
plot(t, SR03TC4, t, SR03TC5, t, SR03TC6, t, SR04TC1, t, SR04TC2, t, SR04TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{16:21},3);

subplot(4,1,3);
plot(t, SR04TC4, t, SR04TC5, t, SR04TC6, t, SR05TC1, t, SR05TC2, t, SR05TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{22:27},3);

subplot(4,1,4);
plot(t, SR05TC4, t, SR05TC5, t, SR05TC6, t, SR06TC1, t, SR06TC2, t, SR06TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{28:33},3);
xlabel(xlabelstring);

orient landscape

%third page
figure
subplot(4,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,2);
plot(t, SR06TC4, t, SR06TC5, t, SR06TC6, t, SR07TC1, t, SR07TC2, t, SR07TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{34:39},3);

subplot(4,1,3);
plot(t, SR07TC4, t, SR07TC5, t, SR07TC6, t, SR08TC1, t, SR08TC2, t, SR08TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{40:45},3);

subplot(4,1,4);
plot(t, SR08TC4, t, SR08TC5, t, SR08TC6, t, SR09TC1, t, SR09TC2, t, SR09TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{46:51},3);
xlabel(xlabelstring);

orient landscape

%fourth page
figure
subplot(4,1,1);
plot(t, dcct);
grid on;
ylabel('Beam Current [mAmps]');
axis([min(t) max(t) 0 dcctplotmax]);
title(titleStr);
ChangeAxesLabel(t, Days, DayFlag);

subplot(4,1,2);
plot(t, SR09TC4, t, SR09TC5, t, SR09TC6, t, SR10TC1, t, SR10TC2, t, SR10TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{52:57},3);

subplot(4,1,3);
plot(t, SR10TC4, t, SR10TC5, t, SR10TC6, t, SR11TC1, t, SR11TC2, t, SR11TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{58:63},3);

subplot(4,1,4);
plot(t, SR11TC4, t, SR11TC5, t, SR11TC6, t, SR12TC1, t, SR12TC2, t, SR12TC3);
grid on;
ylabel('Temp [deg C]');
axis([min(t) max(t) 15 45])
ChangeAxesLabel(t, Days, DayFlag);
legend(name{64:69},3);
xlabel(xlabelstring);

orient landscape


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ChangeAxesLabel(t, Days, DayFlag)
if DayFlag
   if size(Days,2) > 1
      Days = Days'; % Make a column vector
   end
   
   MaxDay = round(max(t));
   set(gca,'XTick',[0:MaxDay]');
   
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
      set(gca,'XTickLabel',XTickLabelString(1:2:MaxDay-1,:));       
   elseif MaxDay < 63
      set(gca,'XTick',[0:3:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:3:MaxDay-1,:));       
   elseif MaxDay < 80
      set(gca,'XTick',[0:4:MaxDay]');       
      set(gca,'XTickLabel',XTickLabelString(1:4:MaxDay-1,:));       
   end
end
