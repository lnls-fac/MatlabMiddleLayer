function fftest
% function fftest
%
% FFTEST:  Tests the feed forward tables
%
%          Data is saved default directories on w:\public\matlab\gaptrack


% Initialize
global BPMs BPMelem GeV IDBPMlist

GeVnum = GeV;
GeVstr = num2str(GeVnum);
  
FFDate = date;
FFClock = clock;

t=0:.5:7*60;
N=length(t);


f1=figure;
f2=figure;
f3=figure;
f4=figure;


% Display test setup
disp([' ']); disp([' ']); 
disp(['         INSERTION DEVICE FEEDFORWARD TABLE TESTING APPLICATION']);
disp([' ']);
disp(['  This program will test a feedforward table at ',num2str(GeV), ' GeV.']);
disp(['  If this is not the correct beam energy, exit (enter 0 for Sector) and run alsinit.']);
disp(['  Before continuing, make sure the following conditions are true.  ']);
disp(['                    *  Multi-bunch mode.']);
disp(['                    *  FF is enabled.']);
disp(['                    *  Velocity Profile is on.']);
disp(['                    *  Gap Control is disabled.']);
disp(['                    *  Current range: 90-110 mAmps.']);
disp(['                    *  Production corrector magnet set.']);
disp(['                    *  Bumps off.']);
disp(['                    *  BPMs calibrated.']);
disp([' ']);

Sector = input('                    Sector (0-exit, 4, 5, 7, 8, 9, 10, 11, 12) = ');
disp(' ');


if Sector == 0
  disp(['  fftest test aborted.']);
  return;
end


% Minimum and maximum gap
[GAPmin, GAPmax] = gaplimit(Sector);
IDVel = maxsp('IDvel', Sector);

disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                   Maximum Gap = ',num2str(GAPmax),' mm']);
disp(['                   Mimimum Gap = ',num2str(GAPmin),' mm']);
disp([' ']);
disp(['  Data collection started.']);


% Create output file names
matfn   = sprintf('id%02de%.0f', Sector, 10*GeV);
textfn1 = sprintf('id%02de%.0f.txt', Sector, 10*GeV);


% Change to w: drive
DirStart = pwd;
gotodata
cd gaptrack


% Set gap to maximum, set velocity to maximum
setid(Sector, GAPmax, IDVel);  
sleep(2);

% Closing test
DCCT=zeros(1,N);
BPMx=zeros(96,N); 
BPMy=zeros(96,N);
IDBPMx=zeros(size(IDBPMlist,1),N); 
IDBPMy=zeros(size(IDBPMlist,1),N);
tout=zeros(1,N);
Gap =zeros(1,N);
Vel =zeros(1,N);
VCM4=zeros(1,N);
VCM1=zeros(1,N);
HCM4=zeros(1,N);
HCM1=zeros(1,N);

[BPMx0, BPMy0] = getbpm(1,1);
[IDBPMx0, IDBPMy0] = getidbpm(1,1);

setid(Sector, GAPmin, IDVel, 0)

t0 = gettime;
for i = 1:length(t);
	while ((gettime-t0) < t(i))
	end

	tout(1,i) = gettime-t0;

	BPMx(:,i) = getx(1) - BPMx0;
	BPMy(:,i) = gety(1) - BPMy0;

	IDBPMx(:,i) = getidx(1) - IDBPMx0;
	IDBPMy(:,i) = getidy(1) - IDBPMy0;

	[Gap(:,i), Vel(:,i)] = getid(Sector);

	HCM4(:,i) = getsp('HCM', [Sector-1 8]);
	HCM1(:,i) = getsp('HCM', [Sector   1]);

	VCM4(:,i) = getsp('VCM', [Sector-1 8]);
	VCM1(:,i) = getsp('VCM', [Sector   1]);

	DCCT(1,i) = getdcct;
	
	if abs(Gap(i)-GAPmin) < .1
		break;
	end

%	if DCCT(1,i) < 10
%		error('    Beam current drop below 10 milliamps.  Test aborted!');
%	end

end

[BPMx1, BPMy1] = getbpm(1,1);
[IDBPMx1, IDBPMy1] = getidbpm(1,1);

DCCT=DCCT(:,1:i);
BPMx=BPMx(:,1:i);
BPMy=BPMy(:,1:i);
IDBPMx=IDBPMx(:,1:i);
IDBPMy=IDBPMy(:,1:i);
t   =   t(:,1:i);
tout=tout(:,1:i);
Gap = Gap(:,1:i);
Vel = Vel(:,1:i);
VCM4=VCM4(:,1:i);
VCM1=VCM1(:,1:i);
HCM4=HCM4(:,1:i);
HCM1=HCM1(:,1:i);


% Save data
eval(['save id', num2str(Sector), 'clos Sector DCCT BPMx0 BPMy0 BPMx1 BPMy1 BPMx BPMy IDBPMx0 IDBPMy0 IDBPMx1 IDBPMy1 IDBPMx IDBPMy t tout Gap Vel VCM4 VCM1 HCM4 HCM1 FFClock FFDate']);


% Plot orbit data
figure(f1); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMx))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMx))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


figure(f2); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMy))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMy))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


% Plot Corrector Magnets 
% Load the data tables
Datafn = sprintf('id%02de%.0f', Sector, 10*GeVnum);
eval(['load ', Datafn]);

figure(f3); clf
subplot(2,1,1);
plot(Gap,HCM4,tableX(:,1),tableX(:,2)+HCM4(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);
plot(Gap,HCM1,tableX(:,1),tableX(:,3)+HCM1(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

figure(f4); clf
subplot(2,1,1);
plot(Gap,VCM4,tableY(:,1),tableY(:,2)+VCM4(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);
plot(Gap,VCM1,tableY(:,1),tableY(:,3)+VCM1(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


drawnow;
disp('  Closing measurement completed.  Hit return to start the opening measurement.');
pause;
disp('  Opening gap.');


% Opening test
DCCT=zeros(1,N);
BPMx=zeros(96,N); 
BPMy=zeros(96,N);
IDBPMx=zeros(size(IDBPMlist,1),N); 
IDBPMy=zeros(size(IDBPMlist,1),N);
tout=zeros(1,N);
Gap =zeros(1,N);
Vel =zeros(1,N);
VCM4=zeros(1,N);
VCM1=zeros(1,N);
HCM4=zeros(1,N);
HCM1=zeros(1,N);

[BPMx0, BPMy0] = getbpm(1,1);
[IDBPMx0, IDBPMy0] = getidbpm(1,1);

setid(Sector, GAPmax, IDVel, 0)

t0 = gettime;
for i = 1:length(t);
	while ((gettime-t0) < t(i))
	end

	tout(1,i) = gettime-t0;

	BPMx(:,i) = getx(1) - BPMx0;
	BPMy(:,i) = gety(1) - BPMy0;

	IDBPMx(:,i) = getidx(1) - IDBPMx0;
	IDBPMy(:,i) = getidy(1) - IDBPMy0;

	[Gap(:,i), Vel(:,i)] = getid(Sector);

	HCM4(:,i) = getsp('HCM', [Sector-1 8]);
	HCM1(:,i) = getsp('HCM', [Sector   1]);

	VCM4(:,i) = getsp('VCM', [Sector-1 8]);
	VCM1(:,i) = getsp('VCM', [Sector   1]);

	DCCT(1,i) = getdcct;
	
	if abs(Gap(i)-GAPmax) < .1
		break;
	end

%	if DCCT(1,i) < 10
%		error('    Beam current drop below 10 milliamps.  Test aborted!');
%	end
end

[BPMx1, BPMy1] = getbpm(1,1);
[IDBPMx1, IDBPMy1] = getidbpm(1,1);
	
DCCT=DCCT(:,1:i);
BPMx=BPMx(:,1:i);
BPMy=BPMy(:,1:i);
IDBPMx=IDBPMx(:,1:i);
IDBPMy=IDBPMy(:,1:i);
t   =   t(:,1:i);
tout=tout(:,1:i);
Gap = Gap(:,1:i);
Vel = Vel(:,1:i);
VCM4=VCM4(:,1:i);
VCM1=VCM1(:,1:i);
HCM4=HCM4(:,1:i);
HCM1=HCM1(:,1:i);


% Save data
eval(['save id', num2str(Sector), 'open Sector DCCT BPMx0 BPMy0 BPMx1 BPMy1 BPMx BPMy IDBPMx0 IDBPMy0 IDBPMx1 IDBPMy1 IDBPMx IDBPMy t tout Gap Vel VCM4 VCM1 HCM4 HCM1 FFClock FFDate']);


% Plot orbit data
figure(f1); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMx))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMx))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


figure(f2); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMy))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMy))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


% Plot Corrector Magnets 
% Load the data tables
Datafn = sprintf('id%02de%.0f', Sector, 10*GeVnum);
eval(['load ', Datafn]);

figure(f3); clf
subplot(2,1,1);
plot(Gap,HCM4,tableX(:,1),tableX(:,2)+HCM4(max(size(HCM4))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);  
plot(Gap,HCM1,tableX(:,1),tableX(:,3)+HCM1(max(size(HCM1))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

figure(f4); clf
subplot(2,1,1);
plot(Gap,VCM4,tableY(:,1),tableY(:,2)+VCM4(max(size(VCM4))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);
plot(Gap,VCM1,tableY(:,1),tableY(:,3)+VCM1(max(size(VCM1))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


% Return of original directory
eval(['cd ', DirStart]);


disp(['  Data collection finished.  Insertion device is at maximum gap.']);
disp([' ']);







%figure(1); clf
%plotyy(Gap, mean(BPMx), '-r', Gap, std(BPMx),'--g')
%xlabel('Gap position [mm]');
%ylabel('Mean Horizontal Diff. Orbit [mm]');
%y2label('RMS Horizontal Diff. orbit [mm]');
%title(['ID ',num2str(Sector),', Horizontal Difference Orbit']);
%
%figure(2); clf
%plotyy(Gap, mean(BPMy), '-r', Gap, std(BPMy),'--g')
%xlabel('Gap position [mm]');
%ylabel('Mean Vertical Diff. Orbit [mm]');
%y2label('RMS Vertical Diff. orbit [mm]');
%title(['ID ',num2str(Sector),', Vertical Difference Orbit']);


%figure(5); clf
%subplot(2,1,1);
%plot(BPMs, 1000*max(abs(BPMx'))' );
%xlabel('BPM Position [meters]');
%ylabel('Max. Hor. Change [microns]');
%title(['ID ',num2str(Sector),', Maximum Orbit Distortion']);
%
%subplot(2,1,2);
%plot(BPMs, 1000*max(abs(BPMy'))' );
%xlabel('BPM Position [meters]');
%ylabel('Max. Vert. Change [microns]');

