%clear


% Power supply TF
w = 2 * pi * 10;
sys = tf(1,[1/w 1]);
%bode(H)


% High frequency poles for the compensation
Fc = 2 * pi * 100000000;



% Input
if ~exist('BEND','var')
    BEND =         [ones(1,50) linspace(1,400,2000) 400*ones(1,50)]';
    QFcommand = .6*[ones(1,50) linspace(1,100,2000) 100*ones(1,50)]';
    QDcommand = .6*[ones(1,50) linspace(1,100,2000) 100*ones(1,50)]';

    % Monitor sample rate
    fs = 4000;
    t = (0:(length(BEND)-1)) / fs;

else
    QFcommand = QFcommand + BEND .* dQFcommand;
    QDcommand = QDcommand + BEND .* dQDcommand;
end


% Simulate the power supply response
[QF, t1, x1] = lsim(sys, QFcommand-QFcommand(1), t); 
QF = QF + QFcommand(1);
[QD, t1, x1] = lsim(sys, QDcommand-QDcommand(1), t);
QD = QD + QDcommand(1);


% Goal 
QFratio = QF./BEND; 
QDratio = QD./BEND;

xLabelString = 'Time [Seconds]';


B2 = 18;
B100 = 309;
dB = (B100-B2)/98;

i2   = find(BEND < B2,   1, 'last');
i100 = find(BEND < B100, 1, 'last');

B = linspace(B2-dB,B100,100);


figure(1);
clf reset
subplot(4,1,1);
plot(t, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;

subplot(4,1,2);
plot(t, QFratio);
hold on
plot([min(t) max(t)],[.520 .520],':r');
hold off
ylabel('QF/BEND (Goal .520)');
axis tight;
%yaxis([.45 .6]);
grid on;

orient tall


figure(2);
clf reset
subplot(4,1,1);
plot(t, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;

subplot(4,1,2);
plot(t, QDratio);
hold on;
plot([min(t) max(t)],[.535 .535],':r');
hold off
ylabel('QD/BEND (Goal .535)');
axis tight;
%yaxis([.45 .6]);
grid on;

orient tall




% Track the following system
%QFratio = sin(2*pi*5*t);
%QFratio = sin(2*pi*5*t) + .25*square(2*pi*5*t) - .25;
%QFratio = step(sys, t);
%randn('state',0);
%QFratio = randn(length(t));
%QFratio = QFratio(:);


% The inverse system
sysinv = tf([1/w 1],conv([1/Fc 1],[1/Fc 1]));


for i = 1:length(B)
    Index(i) = max(find(BEND < B(i))); 
end
dIndex = median(diff(Index));
Index = dIndex*(0:length(Index)-1)+Index(1);


% Put the waveform to track through the inverse system
[dQFcommand, tinv, xinv] = lsim(sysinv, .520-QFratio, t);
[dQDcommand, tinv, xinv] = lsim(sysinv, .535-QDratio, t);

[dQFcommandILC, tinv, xinv] = lsim(sysinv, .520-QFratio(Index), t(Index));
[dQDcommandILC, tinv, xinv] = lsim(sysinv, .535-QDratio(Index), t(Index));

dQFcommand = dQFcommand * 0;
for i = 0:dIndex-1
    dQFcommand(Index+i-dIndex) = dQFcommandILC;  % Or start the simulator sooner!
end

% % May want to low pass the command but don't add phase delay
% [b,a] = butter(5,.2);
% dQFcommand1 = filtfilt(b, a, dQFcommand);


% Simulate the result
[QFsim, t1, x1] = lsim(sys, dQFcommand, t);
[QDsim, t1, x1] = lsim(sys, dQDcommand, t);


% % Put the offset back on
% dQFcommand = dQFcommand + .520;
% dQDcommand = dQDcommand + .520;
% QFsim = QFsim + .535;
% QDsim = QDsim + .535;


% Zero out the first step
%dQFcommand(1:40) = NaN;
%dQDcommand(1:40) = NaN;


% for i = 1:length(B)
%     j = max(find(BEND < B(i)));
%     QFtable(i) = BEND(j) .* dQFcommand(j);
%     QDtable(i) = BEND(j) .* dQDcommand(j);
%     i_table(i) = j;
%     t_table(i) = t(j);
% end


figure(1);
subplot(4,1,3);
plot(t,[QFratio-.520 dQFcommand QFsim QFratio-.535+QFsim]);
ylabel('QF/BEND Error');
legend('QF/BEND-.520', '\DeltaQFcommand', '\DeltaQFsim', 'QF/BEND-.535+\DeltaQFsim', 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);

subplot(4,1,4);
plot(t, BEND .* dQFcommand);
hold on
plot(t(Index), BEND(Index) .* dQFcommand(Index), '.');
ylabel('\DeltaQF [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;


figure(2);
subplot(4,1,3);
%plot(t, [QDratio dQDcommand QDsim QDratio+QDsim]);
plot(t, [QDratio-.535 dQDcommand QDsim QDratio-.535+QDsim]);
ylabel('QD/BEND Error');
legend('QD/BEND-.535', '\DeltaQDcommand', '\DeltaQDsim', 'QD/BEND-.535+\DeltaQDsim', 0);
axis tight;
%yaxis([-.1 .1]);

subplot(4,1,4);
plot(t, BEND .* dQDcommand);
ylabel('\DeltaQD [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;


