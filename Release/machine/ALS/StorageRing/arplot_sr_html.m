%% ALS ARCHIVE DATA REPORT
%

%% General Beam Quality Information 
h1 = open('ARPlot_Fig1.fig');
%

%% Orbit Stability - Horizontal Orbit Across the Straight Sections
h2 = open('ARPlot_Fig2.fig');
%
close(h1);

%% Orbit Stability - Horizontal Orbit Around the Center BEND
h3 = open('ARPlot_Fig3.fig');
%
close(h2);

%% Orbit Stability - Vertical Orbit Across the Straight Sections
h4 = open('ARPlot_Fig4.fig');
%
close(h3);

%% Orbit Stability - Vertical Orbit Around the Center BEND
h5 = open('ARPlot_Fig5.fig');
%
close(h4);

%% Storage Ring Orbit vs Time (All Bergoz BPMs)
h6 = open('ARPlot_Fig6.fig');
%
close(h5);

%% Storage Ring Orbit vs S-Position (All Bergoz BPMs)
h7 = open('ARPlot_Fig7.fig');
%
close(h6);

%% RMS Orbit Motion & Beam Size
h8 = open('ARPlot_Fig8.fig');
%
close(h7);

%% Storage Ring Air & LCW Temperatures 
h9 = open('ARPlot_Fig9.fig');
%
close(h8);

%% Cooling Water Data
h10 = open('ARPlot_Fig10.fig');
%
close(h9);

%% Storage Ring Air Temperature at the Insertion Devices 
h11 = open('ARPlot_Fig11.fig');
%
close(h10);

%% Insertion Device Backing Beam Temperatures
h12 = open('ARPlot_Fig12.fig');
%
close(h11);

%% RF Frequency
h13 = open('ARPlot_Fig13.fig');
%
close(h12);

%% Booster RF parameters plot 1
h14 = open('ARPlot_Fig14.fig');
%
close(h13);

%% Booster RF parameters plot 2
h15 = open('ARPlot_Fig15.fig');
%
close(h14);

%% Booster RF parameters plot 3
h16 = open('ARPlot_Fig16.fig');
%
close(h15);

%% Booster RF parameters plot 4
h17 = open('ARPlot_Fig17.fig');
%
close(h16);

%% SuperBend Sector  4
h18 = open('ARPlot_Fig18.fig');
%
close(h17);

%% SuperBend Sector  8
h19 = open('ARPlot_Fig19.fig');
%
close(h18);

%% SuperBend Sector 12
h20 = open('ARPlot_Fig20.fig');

drawnow;
pause(1);
close(h19);



%% Useful Websites
% ALS Main Page:  http://www.als.lbl.gov
%
%
% ALS Physics:  http://als.lbl.gov/als_physics
%
%
% ALS Data Access Facilities:  http://als.lbl.gov/data_access.html
%
%
% ALS Weekly Performance Data:  http://als.lbl.gov/als_physics/performance_reports/weekly
%
%
% ALS Current Schedule:  http://www-als.lbl.gov/als/schedules/current_ltsch.html
%

close(h20);