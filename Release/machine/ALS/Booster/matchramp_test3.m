%clear

Fig1 = 3;


% Power supply TF
w = 2 * pi * 7.8;
sys = tf(1,[1/w 1]);
%bode(H)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compensation Transfer Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The inverse system
Fc = 2 * pi * 1000;      % High frequency poles for the compensation
sysinv = tf([1/w 1], conv([1/Fc 1],[1/Fc 1]));
sysinv1 = sysinv;

% Add a pole (sample rate & compensation)
%wc = 2 * pi * 10;
%sysinv = sysinv * tf(1, [1/wc 1]);

figure(20);
step(sysinv);
%bode(sysinv1, sysinv);


% May want to low pass the command but don't add phase delay
tt = 0:1/4000:.1;
%[x1,t1] = step(sysinv, tt);
x = sin(2*pi*200*tt);
[x1,t1] = lsim(sysinv, x, tt);

%[b,a] = butter(5, .02, 'low');
[b,a] = fir1(20, .1);
x2 = filtfilt(b, a, x1);

%decfactor = 25;
%x3 = decimate(x1, decfactor, 20,'fir');

clf reset
plot(t1, [x1(:) x2(:)]);
%hold on
%plot(t1(1:decfactor:end), x3, '.-r');


% Input
t = 0:.01:1;
QFcommand = square(2*pi*1.5*t);
QFcommand = -1*QFcommand;
QFcommand = QFcommand - QFcommand(1);
plot(t,QFcommand);


% Simulate the power supply response
[QFcomp, t1, x1] = lsim(sysinv, QFcommand, t); 

% Simulate the power supply response
[QFoutput, t1, x1] = lsim(sys, QFcomp(2:end), t);
%[QFoutput, t1, x1] = lsim(sys, QFcomp(2:end), t(2:end));
%QFoutput(end+1) = 0;

% Simulate the power supply response
[QFtotal, t1, x1] = lsim(sys*sysinv, QFcomp, t); 



figure(Fig1);
clf reset
%subplot(2,1,1);
plot(t, [QFcommand(:) QFcomp(:) QFoutput(:) QFtotal(:)], '.-');
legend('QFcommand', 'QFcompensation', 'QFoutput', 't',0);
axis tight;




% subplot(2,1,2);
% plot(t, QFratio);
% hold on
% plot([min(t) max(t)],[.520 .520],':r');
% hold off
% ylabel('QF/BEND (Goal .520)');
% axis tight;
% %yaxis([.45 .6]);
% grid on;
% 
% 
% % Base on time
% [tmp, i2]   = max(find(t < .0177));
% [tmp, i100] = max(find(t < .4135));
% Index = linspace(i2,i100,100);
% dIndex = round(mean(diff(Index)));
% Index = dIndex*(0:length(Index)-1)+Index(1);
% 
% 
% % Put the waveform to track through the inverse system
% [dQFcommand, tinv, xinv] = lsim(sysinv, BEND.*(.520-QFratio), t);
% [dQDcommand, tinv, xinv] = lsim(sysinv, BEND.*(.535-QDratio), t);
% 
% [dQFcommandILC, tinv, xinv] = lsim(sysinv, BEND(Index).*(.520-QFratio(Index)), t(Index));
% [dQDcommandILC, tinv, xinv] = lsim(sysinv, BEND(Index).*(.535-QDratio(Index)), t(Index));
% 
% 
% % Simulate on 4096 point wave form
% dQFcommand = dQFcommand * 0;
% for i = 0:dIndex-1
%     %dQFcommand(Index+i) = dQFcommandILC;
%     dQFcommand(Index+i-dIndex) = dQFcommandILC;
% end
% 
% 
% % % May want to low pass the command but don't add phase delay
% % [b,a] = butter(5,.2);
% % dQFcommand1 = filtfilt(b, a, dQFcommand);
% 
% 
% % Simulate the result
% [QFsim, t1, x1] = lsim(sys, dQFcommand, t);
% [QDsim, t1, x1] = lsim(sys, dQDcommand, t);
% 
% 
% 
% figure(Fig1);
% subplot(4,1,3);
% plot(t,[(QFratio-.520) dQFcommand./BEND QFsim./BEND (QFratio-.520)+QFsim./BEND]);
% ylabel('QF/BEND Error');
% legend('QF/BEND-.520', '\DeltaQFcommand/BEND', '\DeltaQFsim/BEND', 'QF/BEND-.520+\DeltaQFsim/BEND', 0); %'Location', 'SouthWest');
% axis tight;
% %yaxis([-.1 .1]);
% 
% subplot(4,1,4);
% plot(t, dQFcommand);
% hold on
% plot(t(Index), dQFcommand(Index), '.');
% ylabel('\DeltaQF [Amps]');
% xlabel('Time [Seconds]');
% axis tight;
% %yaxis([-20 20]);
% grid on;
% 
