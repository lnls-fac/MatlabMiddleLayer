function datelabel(opts)
% datelabel(opts)  Make x-axis have nice date/time format
%    opts = 1    No year labels

if nargin<1;  opts=0;  end

tlim = get(gca,'XLim');
if size(tlim)~=[ 1 2 ]
   error('Cant get x-axis limits');
end
if tlim(1) >= tlim(2)
   error('x-axis limits are not in proper order');
end

%  Clean up the endpoints a bit
ylim = get(gca,'YLim');
if size(ylim)~=[ 1 2 ]
   error('Cant get y-axis limits');
end
dleft = floor(tlim(1));
dright = ceil(tlim(2));
%axis( [ dleft dright ylim(1) ylim(2) ] );

[ yr1, mon1, day1 ] = datevec(dleft);
[ yr2, mon2, day2 ] = datevec(dright);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxtick = 14;     %  maximum number of ticks to put across
maxlabl = 8;      %  maximum number of ticks with labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  First, decide the tick interval

yrlo=yr1+1;  if mon1==1 & day1==1;  yrlo=yr1; end  % first whole year in plot
yrhi=yr2;                                          % last whole year in plot

monlo=mon1+1;   if day1==1;  monlo=mon1; end    % first whole month in plot
monhi=mon2;                                     % last whole month in plot

wklo = dleft + rem( 9 - weekday(dleft), 7 );  % first Monday in plot
wkhi = dright - rem( 5 + weekday(dright), 7 );  % last Monday in plot

%disp(sprintf('yrlo=%d  yrhi=%d  monlo=%d  monhi=%d  wklo=%s wkhi=%s', ...
%      yrlo,yrhi,monlo,monhi, datestr(wklo,1), datestr(wkhi,1) ));

% These quantities are the total number of ticks we would have
%  if we put them at intervals of 10 years, 5 years, ... 3 months, 1 month
n10yr = floor(yrhi/10) - ceil(yrlo/10) + 1; % numbr of ticks at 10-yr intrvls
n5yr = floor(yrhi/5) - ceil(yrlo/5) + 1;    % numbr of ticks at 5-yr intrvls
n2yr = floor(yrhi/2) - ceil(yrlo/2) + 1;    % numbr of ticks at 2-yr intrvls
n1yr = yrhi - yrlo + 1;                     % numbr of ticks at 1-yr intrvls

n3mon = 4*(yr2-yr1) + floor((monhi-1)/3) - ceil((monlo-1)/3) + 1;
n1mon = 12*(yr2-yr1) + monhi - monlo + 1;

n1wk = ((wkhi-wklo)/7) + 1;
n1day = dright-dleft+1;

xtick = zeros(1,0);
year_intrvl = 0;       % Set at most one of these to a positive integer,
month_intrvl = 0;      %  to indicate that the tick interval is that
week_intrvl = 0;       %  many of the appropriate unit
day_intrvl = 0;

if n1day<=maxtick
   xtick = dleft + (0:(n1day-1));
   day_intrvl = 1;
elseif n1wk<=maxtick
   xtick = wklo + 7*(0:(n1wk-1));
   week_intrvl = 1;
elseif n1mon<=maxtick
   xtick = datenum( yr1, monlo + (0:(n1mon-1)), 1 );
   month_intrvl = 1;
elseif n3mon<=maxtick
   xtick = datenum( yr1, 3*( ceil((monlo-1)/3) + (0:(n3mon-1)) )+1, 1 );
   month_intrvl = 3;
elseif n1yr<=maxtick
   xtick = datenum( yrlo + (0:(n1yr-1)), 1, 1);
   year_intrvl = 1;
elseif n2yr<=maxtick
   xtick = datenum( 2*( ceil(yrlo/2) + (0:(n2yr-1)) ), 1, 1);
   year_intrvl = 2;
elseif n5yr<=maxtick
   xtick = datenum( 5*( ceil(yrlo/5) + (0:(n5yr-1)) ), 1, 1 );
   year_intrvl = 5;
elseif n10yr<=maxtick
   xtick = datenum( 10*( ceil(yrlo/10) + (0:(n10yr-1)) ), 1, 1 );
   year_intrvl = 10;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Next, decide the tick labels
if year_intrvl>=1;       datestrparam = 10;   % 1995
elseif month_intrvl>=1;  datestrparam = 12;   % Mar95
elseif week_intrvl>=1;   datestrparam = 2;    % 03/01/95
elseif day_intrvl>=1;    datestrparam = 6;    % 03/01
end

if opts==1
   datestrparam = 3
end

%  Construct the date labels according to the chosen string
xlabl = cell(size(xtick));
for i=1:length(xtick)
   xlabl{i} = datestr(xtick(i),datestrparam);
end

%  If the interval is one unit, shift the labels right a bit
if year_intrvl==1 | month_intrvl==1 | day_intrvl==1
   for i=1:length(xtick)
      xlabl{i} = [ '     ' xlabl{i} ];
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Finally, implement the result

if length(xtick)~=length(xlabl)
    error( [ 'xtick has size ' num2str(size(xtick)) ...
         '     xlabl has size ' num2str(size(xlabl)) ] );
end

%disp(datestr(dleft))
%for i=1:length(xtick)
%   disp(sprintf('   %s  --  %s',datestr(xtick(i)),xlabl{i}));
%end
%disp(datestr(dright))

if any(xtick<datenum(dleft)) | any(xtick>datenum(dright))
   error('Internal error -- Tick labels exceed bounds of original plot');
end

set( gca, 'XTick', xtick, 'XTickLabel', xlabl );