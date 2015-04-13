%clear

Fig1 = 2;


% Power supply TF
w = 2 * pi * 100;
sys = tf(1,[1/w 1]);
%bode(H)


% The inverse system
Fc = 2 * pi * 10000000000000;   % High frequency poles for the compensation
ws = 2 * pi * 100;
sysinv = tf([1/ws 1], conv([1/Fc 1],[1/Fc 1]));

%wc = 2 * pi * 10;
%sysinv = tf([1/ws 1], conv(conv([1/Fc 1],[1/Fc 1]),[1/wc 1]));



% Input
if ~exist('BEND','var')
    BEND =         [ones(1,50) linspace(1,400,2000) 400*ones(1,50)]';
    QFcommand = .6*[ones(1,50) linspace(1,100,2000) 100*ones(1,50)]';

    % Monitor sample rate
    fs = 4000;
    t = (0:(length(BEND)-1)) / fs;

else
    QFcommand = QFcommand + dQFcommand;
end


% Simulate the power supply response
[QF, t1, x1] = lsim(sys, QFcommand-QFcommand(1), t); 
QF = QF + QFcommand(1);


% Goal 
QFratio = QF./BEND; 


figure(Fig1);
clf reset
subplot(4,1,1);
plot(t, [QF(:) BEND(:)]);
legend('QF', 'BEND', 0);
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


% Base on time
[tmp, i2]   = max(find(t < .0177));
[tmp, i100] = max(find(t < .4135));
Index = linspace(i2,i100,100);
dIndex = round(mean(diff(Index)));
Index = dIndex*(0:length(Index)-1)+Index(1);


% Put the waveform to track through the inverse system
[dQFcommand, tinv, xinv] = lsim(sysinv, BEND.*(.520-QFratio), t);

[dQFcommandILC, tinv, xinv] = lsim(sysinv, BEND(Index).*(.520-QFratio(Index)), t(Index));


% Simulate on 4096 point wave form
dQFcommand = dQFcommand * 0;
for i = 0:dIndex-1
    %dQFcommand(Index+i) = dQFcommandILC;
    dQFcommand(Index+i-dIndex) = dQFcommandILC;
end


% % May want to low pass the command but don't add phase delay
% [b,a] = butter(5,.2);
% dQFcommand1 = filtfilt(b, a, dQFcommand);


% Simulate the result
[QFsim, t1, x1] = lsim(sys, dQFcommand, t);



figure(Fig1);
subplot(4,1,3);
plot(t,[(QFratio-.520) dQFcommand./BEND QFsim./BEND (QFratio-.520)+QFsim./BEND]);
ylabel('QF/BEND Error');
legend('QF/BEND-.520', '\DeltaQFcommand/BEND', '\DeltaQFsim/BEND', 'QF/BEND-.520+\DeltaQFsim/BEND', 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);

subplot(4,1,4);
plot(t, dQFcommand);
hold on
plot(t(Index), dQFcommand(Index), '.');
ylabel('\DeltaQF [Amps]');
xlabel('Time [Seconds]');
axis tight;
%yaxis([-20 20]);
grid on;

