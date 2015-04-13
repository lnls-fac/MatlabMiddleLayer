% Check the power supply BW
% Compensation TF should be applied on QF not QF/BEND
% Test what the delay should be?  Sample rate or BW reasoning?
% Test the tolerance to parameter uncertainty (TF high poles)
% Timing should not independent of BEND setpoint!
% Check the timing of a point in the middle of the sequence

clear



Fig1 = 3;
Fig2 = 4;


% Power supply TF
w = 2 * pi * 7.8;
sys = tf(1,[1/w 1]);
%bode(H)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compensation Transfer Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The inverse system
Fc = 2 * pi * 100;      % High frequency poles for the compensation
sysinv = tf([1/w 1], conv([1/Fc 1],[1/Fc 1]));
sysinv1 = sysinv;

% Add a pole (sample rate & compensation)
wc = 2 * pi * 10;
sysinv = sysinv * tf(1, [1/wc 1]);

figure(20);
step(sysinv);
%bode(sysinv1, sysinv);


QF   = getpv('QF',   'DVM'); 
QD   = getpv('QD',   'DVM');
BEND = getpv('BEND', 'DVM');

QF = QF(:);
QD = QD(:);
BEND = BEND(:);


% May want to low pass the BEND but don't add phase delay
% [b,a] = butter(5,.1);
% BEND = filtfilt(b, a, BEND);



fs = 4000;
t = (0:(length(QF)-1)) / fs;


% Goal 
QFratio = QF./BEND; 
QDratio = QD./BEND; 


if 1
    TimeFlag = 1;
    x = t;
    xLabelString = 'Time [Seconds]';
else
    TimeFlag = 0;
    x = BEND;
    xLabelString = 'BEND Current [Amps]';
end


B2 = 18;
B100 = 309;
dB = (B100-B2)/98;

i2   = max(find(BEND < B2));
i100 = max(find(BEND < B100));

% 100 point bend table (last point gets dropped later)
B = linspace(B2,B100+dB,100);


figure(Fig1);
clf reset
subplot(4,1,1);
plot(x, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;

subplot(4,1,2);
plot(x, QFratio);
hold on;
plot([min(x) max(x)],[.520 .520],'r');
if ~TimeFlag
    plot([B2   B2],  [-10 10],'r');
    plot([B100 B100],[-10 10],'r');
end
hold off;
ylabel('QF/BEND (Goal .520)');
axis tight;
yaxis([.45 .6]);
grid on;

orient tall


figure(Fig2);
clf reset
subplot(4,1,1);
plot(x, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 0);
axis tight;

subplot(4,1,2);
plot(x, QDratio);
hold on;
plot([min(x) max(x)],[.535 .535],'r');
if ~TimeFlag
    plot([B2   B2],  [-10 10],'r');
    plot([B100 B100],[-10 10],'r');
end
hold off;
ylabel('QD/BEND (Goal .535)');
axis tight;
yaxis([.45 .6]);
grid on;

orient tall



% % Zero the error until the system can be controlled (old bend)
% i = find(t < .0225-.002);
% %i = find(t < .0225-.004);
% %i = find(t < .0225);
% QFErr(i) = 0;
% QDErr(i) = 0;
% 
% % Slowly zero the error after the top of the ramp
% i = find(t > .85);
% QFErr(i) = linspace(QFErr(i(1)),0,length(i));
% QDErr(i) = linspace(QDErr(i(1)),0,length(i));



% % Find the time step for the ILC linearity correction
% for i = 1:length(B)
%     Index(i) = max(find(BEND < B(i))); 
% end
% dIndex = median(diff(Index));
% Index = dIndex*(0:length(Index)-1)+Index(1);

% Base on time???
[tmp, i2]   = max(find(t < .0177));
[tmp, i100] = max(find(t < .4135));
Index = linspace(i2,i100,100);
%dIndex = Index(2)-Index(1);
dIndex = round(median(diff(Index)));
Index = dIndex*(0:length(Index)-1)+Index(1);


% Put the waveform to track through the inverse system
[dQFcommand, tinv, xinv] = lsim(sysinv, .520-QFratio, t);
[dQDcommand, tinv, xinv] = lsim(sysinv, .535-QDratio, t);

[dQFcommandILC, tinv, xinv] = lsim(sysinv, .520-QFratio(Index), t(Index));
[dQDcommandILC, tinv, xinv] = lsim(sysinv, .535-QDratio(Index), t(Index));


% Slide the table 1 point (first point is zero)
dQFcommandILC(1) = [];
dQDcommandILC(1) = [];
Index(end) = [];

%dQFcommandILC(end) = [];
%dQDcommandILC(end) = [];
%Index(end) = [];


% % May want to low pass the command but don't add phase delay
% [b,a] = butter(5,.2);
% dQFcommand1 = filtfilt(b, a, dQFcommand);


% Simulate on 4096 point wave form
dQFcommand = dQFcommand * 0;
dQDcommand = dQDcommand * 0;
for i = 0:dIndex-1
    dQFcommand(Index+i) = dQFcommandILC;
    dQDcommand(Index+i) = dQDcommandILC;
end


% Simulate the result
[dQFsim, t1, x1] = lsim(sys, dQFcommand, t);
[dQDsim, t1, x1] = lsim(sys, dQDcommand, t);


% for i = 1:length(t_ILC)
%     j = max(find(t < t_ILC(i)));
%     QFtable(i) = BEND(j) .* QFcommand(j);
%     QDtable(i) = BEND(j) .* QDcommand(j);
% end



figure(Fig1);
subplot(4,1,3);
plot(x,[QFratio-.520 dQFcommand dQFsim QFratio-.520+dQFsim]);
ylabel('QF/BEND Error');
legend('QF/BEND-.520', '\DeltaQFcommand', '\DeltaQFsim', 'QF/BEND-.520+\DeltaQFsim', 0);
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(x, BEND .* dQFcommand);
ylabel('\DeltaQF [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;

if TimeFlag
    hold on;
    plot(t(Index), BEND(Index) .* dQFcommandILC, 'sr', 'MarkerSize',3);
    hold off;
end


figure(Fig2);
subplot(4,1,3);
%plot(x, [QDratio QDcommand QDsim QDratio+QDsim]);
plot(x, [QDratio-.535 dQDcommand dQDsim QDratio-.535+dQDsim]);
ylabel('QD/BEND Error');
legend('QD/BEND-.535', '\DeltaQDcommand', '\DeltaQDsim', 'QD/BEND-.535+\DeltaQDsim', 0);
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(x, BEND .* dQDcommand);
ylabel('\DeltaQD [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;

if TimeFlag
    hold on;
    plot(t(Index), BEND(Index) .* dQDcommandILC, 'sr', 'MarkerSize',3);
    hold off;
end

%QF = getpv('QF', 'ILCTrim');
%QD = getpv('QD', 'ILCTrim');

QF_ILC = getpv('QF', 'ILCTrim');
QD_ILC = getpv('QD', 'ILCTrim');

QF_ILC(2:100) = QF_ILC(2:100) + (BEND(Index) .* dQFcommandILC)';
QD_ILC(2:100) = QD_ILC(2:100) + (BEND(Index) .* dQDcommandILC)';


% tmp = questdlg('Change the linearity correction?','matchramp_ild','Yes','No','No');
% if ~strcmpi(tmp,'Yes')
%     fprintf('  No change made QF or QD linearity correction table.\n');
%     return
% else
%     fprintf('  QF & QD linearity correction table updated.\n');
%     setpv('QF', 'ILCTrim', QF_ILC, [1 1]);
%     setpv('QD', 'ILCTrim', QD_ILC, [1 1]);
% end



%QFtable = [1.8 QFtable];
%QDtable = [1.8 QDtable];


% for i = 1:length(B)
%     j = max(find(BEND < B(i)));
%     QFtable(i) = BEND(j) .* QFcommand(j);
%     QDtable(i) = BEND(j) .* QDcommand(j);
% end
% 
% figure(Fig1);
% subplot(4,1,3);
% plot(x,[QFratio-.520 QFcommand QFsim QFratio-.535+QFsim]);
% ylabel('QF/BEND Error');
% legend('QF/BEND-.520', '\DeltaQFcommand', '\DeltaQFsim', 'QF/BEND-.535+\DeltaQFsim', 'Location', 'SouthWest');
% axis tight;
% yaxis([-.1 .1]);
% 
% subplot(4,1,4);
% plot(x, BEND .* QFcommand);
% if ~TimeFlag
%     hold on;
%     plot(B, QFtable, 'sr', 'MarkerSize',3);
%     plot([B2   B2],  [-1000 1000],'r');
%     plot([B100 B100],[-1000 1000],'r');
%     hold off;
% end
% ylabel('\DeltaQF [Amps]');
% xlabel(xLabelString);
% axis tight;
% yaxis([-20 20]);
% grid on;
% 
% 
% figure(Fig2);
% subplot(4,1,3);
% %plot(x, [QDratio QDcommand QDsim QDratio+QDsim]);
% plot(x, [QDratio-.535 QDcommand QDsim QDratio-.535+QDsim]);
% ylabel('QD/BEND Error');
% legend('QD/BEND-.535', '\DeltaQDcommand', '\DeltaQDsim', 'QD/BEND-.535+\DeltaQDsim', 'Location', 'SouthWest');
% axis tight;
% yaxis([-.1 .1]);
% 
% subplot(4,1,4);
% plot(x, BEND .* QDcommand);
% if ~TimeFlag
%     hold on;
%     plot(B, QDtable, 'sr', 'MarkerSize',3);
%     plot([B2   B2],  [-1000 1000],'r');
%     plot([B100 B100],[-1000 1000],'r');
%     hold off;
% end
% ylabel('\DeltaQD [Amps]');
% xlabel(xLabelString);
% axis tight;
% yaxis([-20 20]);
% grid on;

% ysim = 0;
% clf
% for i = 1:10
%     Err = QFratio - ysim;
%     [yr, tr, xr] = lsim(sysr, Err, t);
% 
%     unew = unew + yr;
%     [ysim, t1, x] = lsim(sys,unew,t);
% 
%     plot(t,[unew(:) yr(:) ysim(:) QFratio(:)]);
% 
%     legend('unew','yr','ysim','QFratio');
%     
%     %[ysim, t1, x] = lsim(sys,unew,t);
%     %plot(t,[unew(:) ysim(:) QFratio(:)]);
%     %unew = unew + (QFratio-ysim(:)');
%     
%     i; %pause;
% end



