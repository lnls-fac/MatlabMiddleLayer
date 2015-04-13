
% Libera data acquition frequencies - data flows
Fadc  = 112583200;            % ADC sampling frequency
Ftbt  = 3216662;              % Turn by Turn sampling frequency
Ftbtd = 50260;                % Turn by Turn 64x Decimated sampling frequency
Ffa   = 9806;                 % Fast Acquisition sampling frequency
Fsa   = 10;                   % Slow Acquition

% Defines the simulation frequency
Fs = Ftbt;               

% Acquisition Parameters
Ts = 1/Fs;                    % Sampling period
N  = 500;                     % Number of samples
t = (0:N-1)*Ts;               % Time vector and total acquisition time

% Defines signal's components
DC = 8191;
f1 = 4*25000;
A1 = 8191;
f2 = 4*50000;
A2 = 0;
f3 = 4*150000;
A3 = 0;
f4 = 4*250000;
A4 = 0;
Ar = 0;  % amplitude sinal randomico

% Defines signal plus noise
y = DC+A1*sin(2*pi*f1*t)+A2*sin(2*pi*f2*t)+A3*sin(2*pi*f3*t)+A4*sin(2*pi*f4*t)+Ar*randn(size(t));
plot(t*1000,y)
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('Time (ms)')
ylabel('Simulated Signal (V)')

% Generates the FFT with and without windowing...
y = y - mean(y); % deletes DC component
Y = fft(y)/N;
Z = fft(y.*flattopwin(N)')/N;
f = Fs/2*linspace(0,1,N/2+1);
length(f)


% Plot single-sided amplitude spectrum.
figure;
subplot(2,1,1); 

Y(1)=Y(1)/2;
plot(f,2*abs(Y(1:N/2+1)))
length(2*abs(Y(1:N/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
axis([-0.03*Fs,1.03*Fs/2,0,10000])

subplot(2,1,2);
Z(1)=Z(1)/2;
plot(f,4.76*2*abs(Z(1:N/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)*flattop(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
axis([-0.03*Fs,1.03*Fs/2,0,10000])

% wvtool(flattopwin(N)); % observacao da respota em f do janelamento

% Para um dado conjunto de amplitudes do sinal de entrada, o janelamento,
% no caso do tipo flattop (indicado para obter melhor resolução em
% amplitude), realmente faz com que as amplitudes obtidas fiquem bastante
% próximas do valores nominais, mesmo para baixos números de amostras. A
% FFT com ou sem janelamento converge para os valores originais de amplitude
% quando o número de amostras é muito alto, ou quanto dentro do tempo de
% amostragem cabem muitos ciclos das frequencias que estão sendo
% observadas!

% Desta forma, podemos concluir que o janelamento auxilia na questão de
% vazamento espectral desde que no período de amostragem caibam alguns
% ciclos das frequencias de interesse.







