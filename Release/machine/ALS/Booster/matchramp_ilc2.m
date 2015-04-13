% Check the power supply BW
% Compensation TF should be applied on QF not QF/BEND
% Test what the delay should be?  Sample rate or BW reasoning?
% Test the tolerance to parameter uncertainty (TF high poles)
% Timing should not independent of BEND setpoint!
% Check the timing of a point in the middle of the sequence

clear

Fig1 = 7;
Fig2 = 8;

FigN = 19;

% Power supply TF
w = 2 * pi * 7.8;
sys = tf(1,[1/w 1]);
%bode(H)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compensation Transfer Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gain = 1;

% The inverse system
Fc = 2 * pi * 20;      % High frequency poles for the compensation (avoid phase delay!!!)
sysinv = tf([1/w 1], conv([1/Fc 1],[1/Fc 1]));
sysinv1 = sysinv;

% Add a pole (sample rate & compensation)
%wc = 2 * pi * 10;
%sysinv = sysinv * tf(1, [1/wc 1]);

figure(20);
step(sysinv);
%bode(sysinv1, sysinv);


QF   = getpv('QF',   'DVM'); 
QD   = getpv('QD',   'DVM');
BEND = getpv('BEND', 'DVM');

QF = QF(:);
QD = QD(:);
BEND = BEND(:);


fs = 4000;
t = (0:(length(QF)-1)) / fs;


% Filter the BEND but don't add phase delay
BENDRaw = BEND;
[b,a] = fir1(10, .2);
BEND = filtfilt(b, a, BENDRaw);

freqz(b,a,1024,'whole',4000);

QFRaw = QF;
QF = filtfilt(b, a, QFRaw);

QDRaw = QD;
QD = filtfilt(b, a, QDRaw);

figure(FigN);
subplot(3,1,1);
plot(t, [BEND(:) BENDRaw(:)]);
subplot(3,1,2);
plot(t, [QF(:) QFRaw(:)]);
subplot(3,1,3);
plot(t, [QD(:) QDRaw(:)]);


% Goal 
QFratio = QF./BEND; 
QDratio = QD./BEND; 


% Error
QFerr = BEND.*(.520-QFratio);
QDerr = BEND.*(.535-QDratio);


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


% Zero the error until the system can be controlled
i = find(t < t(Index(1)));
%t_minus_1 = t(Index(1))-(t(Index(2))-t(Index(1)));
%i = find(t < t_minus_1);
%i = find(t < .0225-.004);
%i = find(t < .0225);
QFerr(i) = 0;
QDerr(i) = 0;


% % Slowly zero the error after the top of the ramp
% i = find(t > .85);
% QFerr(i) = linspace(QFerr(i(1)),0,length(i));
% QDerr(i) = linspace(QDerr(i(1)),0,length(i));


% Smooth the error signal without adding phase lag
[b,a] = fir1(20, .02);
QFerrRaw = QFerr;
QFerr = filtfilt(b, a, QFerrRaw);

QDerrRaw = QDerr;
QDerr = filtfilt(b, a, QDerrRaw);

figure(FigN);
subplot(2,1,1);
plot(t, [QFerr(:) QFerrRaw(:)]);
subplot(2,1,2);
plot(t, [QDerr(:) QDerrRaw(:)]);



% Put the waveform to track through the inverse system
[dQFcommand, tinv, xinv] = lsim(sysinv, QFerr, t);
[dQDcommand, tinv, xinv] = lsim(sysinv, QDerr, t);


if 1

    [dQFcommandILC, tinv, xinv] = lsim(sysinv, QFerr(Index), t(Index));
    [dQDcommandILC, tinv, xinv] = lsim(sysinv, QDerr(Index), t(Index));

    % Slide the table 1 point (first point is zero)  ????
    dQFcommandILC(1) = [];
    dQDcommandILC(1) = [];
    Index(end) = [];


    %dQFcommandILC(end) = [];
    %dQDcommandILC(end) = [];
    %Index(end) = [];

elseif 0
    
    % Or be brain dead
    T = .0075;
    NT = round(T/(t(2)-t(1)))
    dQFcommandILC = QFerr(Index+NT);

    dQDcommandILC = QDerr(Index+NT);
    
else

    % Low pass the command and resample but don't add phase delay
    %[b,a] = butter(5,.2);
    %[b,a] = butter(5,.08);
    [b,a] = fir1(50, .01);
    dQFcommand1 = filtfilt(b, a, dQFcommand);
    dQFcommandILC = dQFcommand1(Index);

    dQDcommand1 = filtfilt(b, a, dQDcommand);
    dQDcommandILC = dQDcommand1(Index);

    figure(FigN);
    subplot(2,1,1);
    %plot(t, [dQFcommand(:) dQFcommand1(:)], t(Index), dQFcommandILC,'.r', t,10*(QFratio-.520),'k');
    plot(t, [dQFcommand(:) dQFcommand1(:)], t(Index), dQFcommandILC,'.r', t,10*(QFratio-.520), 'k', t,QFerr,'m', t,QFerrRaw,'m');

    subplot(2,1,2);
    plot(t, [dQDcommand(:) dQDcommand1(:)], t(Index), dQDcommandILC,'.r', t,10*(QDratio-.535), 'k', t,QDerr,'m');
    xlabel('Time [seconds]');
end


% Gain
dQFcommandILC = Gain * dQFcommandILC;
dQDcommandILC = Gain * dQDcommandILC;


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
clf reset
subplot(4,1,1);
plot(x, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;

subplot(4,1,2);
plot(x, QFratio);
hold on;
plot(x(Index), QFratio(Index),'.');
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

subplot(4,1,3);
plot(x,[(QFratio-.520) dQFcommand./BEND dQFsim./BEND (QFratio-.520)+dQFsim./BEND]);
ylabel('QF/BEND Error');
%legend('QF/BEND-.520', '\DeltaQFcommand', '\DeltaQFsim', 'QF/BEND-.520+\DeltaQFsim', 0);
legend('QF/BEND-.520', '\DeltaQFcommand/BEND', '\DeltaQFsim/BEND', 'QF/BEND-.520+\DeltaQFsim/BEND', 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(x, dQFcommand);
ylabel('\DeltaQF [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;

if TimeFlag
    hold on;
    plot(t(Index), dQFcommandILC, 'sr', 'MarkerSize',3);
    hold off;
end

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
plot(x(Index), QDratio(Index),'.');
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


subplot(4,1,3);
plot(x,[(QDratio-.520) dQDcommand./BEND dQDsim./BEND (QDratio-.520)+dQDsim./BEND]);
ylabel('QD/BEND Error');
%legend('QD/BEND-.520', '\DeltaQDcommand', '\DeltaQDsim', 'QD/BEND-.520+\DeltaQDsim', 0);
legend('QD/BEND-.520', '\DeltaQDcommand/BEND', '\DeltaQDsim/BEND', 'QD/BEND-.520+\DeltaQDsim/BEND', 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(x, dQDcommand);
ylabel('\DeltaQD [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;

if TimeFlag
    hold on;
    plot(t(Index), dQDcommandILC, 'sr', 'MarkerSize',3);
    hold off;
end

orient tall



%%%%%%%%%%%%%%%%%%%%%
% Set the ILC table %
%%%%%%%%%%%%%%%%%%%%%

QF_ILC = getpv('QF', 'ILCTrim');
QD_ILC = getpv('QD', 'ILCTrim');

if length(dQFcommandILC) == 100
    QF_ILC = QF_ILC + dQFcommandILC';
    QD_ILC = QD_ILC + dQDcommandILC';
else
    QF_ILC(2:100) = QF_ILC(2:100) + dQFcommandILC';
    QD_ILC(2:100) = QD_ILC(2:100) + dQDcommandILC';
end


tmp = questdlg('Change the linearity correction?','matchramp_ild','Yes','No','No');
if ~strcmpi(tmp,'Yes')
    fprintf('  No change made QF or QD linearity correction table.\n');
    return
else
    fprintf('  QF & QD linearity correction table updated.\n');
    setpv('QF', 'ILCTrim', QF_ILC, [1 1]);
    setpv('QD', 'ILCTrim', QD_ILC, [1 1]);
end



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



