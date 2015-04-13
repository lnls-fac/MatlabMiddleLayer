function [x, y, Paa, Pbb, Pcc, Pdd] = libera_adc(chA, chB, chC, chD, DisplayFlag)

if nargin < 5
    if nargout == 0
        DisplayFlag = 1;
    else
        DisplayFlag = 0;
    end
end

if nargin == 0
    % Prompt for a file
else
    if ischar(chA)
        load(chA);

        chA = ADC_AM.ADC_A_MONITOR;
        chB = ADC_AM.ADC_B_MONITOR;
        chC = ADC_AM.ADC_C_MONITOR;
        chD = ADC_AM.ADC_D_MONITOR;

        %x = DD4_AM.DD_X_MONITOR;
        %y = DD4_AM.DD_Y_MONITOR;
    end
end


Fs = 117.294;        % Sampling frequency, [MHz]
Ts = 1/(Fs*1e6);     % Sampling period [seconds]
Rev = 656e-9;        % Revolution period [seconds]
N = round(Rev/Ts);   % Samples per revolution 77


Nfreq = round(N/2.0);
freq = (0:Nfreq-1)*Fs/N;
clock = (1:1024);
t = (0:1023)/Fs;

low  = 15;
high = 28;


% Find the offset in the time series 
chAint = detrend(cumsum(abs(chA)));
if chAint(1) > 0
    i = find(chAint(2:end)<0);
    i = i(1)+1;
else
    i = find(chAint(2:end)>0);
    i = i(1)+1;
end
shift = i(1) - 22;
if shift < 1
    shift = shift + N;
end

NBunchesPerADCBuffer = floor((length(chAint)-shift)/N);
% if shift < 10
%     NBunchesPerADCBuffer = 13;
% else
%     NBunchesPerADCBuffer = 12;
% end


% PSD
for i = 1:NBunchesPerADCBuffer
    [Paa(:,i), Arms(1,i)]  = libera_psd(chA((i-1)*N+1+shift:i*N+shift), low, high);
    [Pbb(:,i), Brms(1,i)]  = libera_psd(chB((i-1)*N+1+shift:i*N+shift), low, high);
    [Pcc(:,i), Crms(1,i)]  = libera_psd(chC((i-1)*N+1+shift:i*N+shift), low, high);
    [Pdd(:,i), Drms(1,i)]  = libera_psd(chD((i-1)*N+1+shift:i*N+shift), low, high);

    x(1,i)=10*(Arms(1,i)-Brms(1,i)-Crms(1,i)+Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    y(1,i)=10*(Arms(1,i)+Brms(1,i)-Crms(1,i)-Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
end



if DisplayFlag
    figure(DisplayFlag);
    clf reset

    subplot(2,1,1);
    plot(clock, [chA; chB; chC; chD]);
    xlabel('ADC Sample Number');
    title('Libera ADC Data', 'interpreter',' none');
    hold on

    xlim([0 1024]);
    lx(1) = 1 + shift;
    lx(2) = 1 + shift;
    ly(1) = min(chA);
    ly(2) = max(chA);
    
    line(lx, ly, 'Color', 'g');

    % PSD
    for i = 1:NBunchesPerADCBuffer
        subplot(2,1,1);
        lx(1) = i*N + shift;
        lx(2) = i*N + shift;
        line(lx, ly, 'Color', 'g');

        subplot(2,1,2);
        loglog(freq, Paa(:,i)/Fs/1e6, 'b');  % Volt^2/Hz
        loglog(freq, Pbb(:,i)/Fs/1e6, 'g');  % Volt^2/Hz
        loglog(freq, Pcc(:,i)/Fs/1e6, 'r');  % Volt^2/Hz
        loglog(freq, Pdd(:,i)/Fs/1e6, 'k');  % Volt^2/Hz
        hold on
    end

    legend('Button #1', 'Button #2', 'Button #3', 'Button #4', 'Location', 'NorthWest');
    axis tight;
    a = axis;
    axis([2 60 1e-8 a(4)]);
    %axis([2 60 1e-8 1]);
    set(gca,'xtick',[2:10 20 30 40 50 60])
    a = logspace(-8,1,10);
    set(gca,'ytick',a(1:2:end))
    
    lx(1) = freq(low);
    lx(2) = lx(1);
    ly(1) = 0.0;
    ly(2) = max(max(Paa))/Fs/1e6;
    line(lx, ly, 'Color', 'm', 'LineWidth', 2);
    lx(1) = freq(high);
    lx(2) = lx(1);
    line(lx, ly, 'Color', 'm', 'LineWidth', 2);

    title(sprintf('Power Spectrum of Each Button for %d Turns', NBunchesPerADCBuffer));
    xlabel('Frequency [MHz]');
    grid on

    subplot(2,1,1);
    hold off
    subplot(2,1,2);
    hold off

    
    figure(DisplayFlag+1);
    clf reset
    subplot(2,1,1);
    %hold on;
    plot(x, '.-r');
    ylabel('ADC Counts');
    title('Libera ADC Data', 'interpreter',' none');
    subplot(2,1,2);
    %hold on;
    plot(y, '.-r');


%     figure(DisplayFlag+2);
%     clf reset
%     subplot(2,1,1);
%     %hold on;
%     plot(DD4_AM.DD_X_MONITOR(1:40)/1e6, '.-r');
%     title('Libera DD Data', 'interpreter',' none');
%     subplot(2,1,2);
%     %hold on;
%     plot(DD4_AM.DD_Y_MONITOR(1:40)/1e6, '.-r');
%     %xaxiss([0 20]);
% 
% 
%     figure(4);
%     clf reset
%     subplot(2,1,1);
%     %hold on;
%     plot(DD4_AM.DD_X_MONITOR/1e6, '-r');
%     title('Libera DD Data', 'interpreter',' none');
%     subplot(2,1,2);
%     %hold on;
%     plot(DD4_AM.DD_Y_MONITOR/1e6, '-r');
%     %xaxiss([0 20]);

end