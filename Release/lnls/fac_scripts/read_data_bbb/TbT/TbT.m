

% Turn-by-turn data from bunch-by-bunch data
%
% This script averages bunch-by-bunch data of the LNLS 148 bunches,
% proceeding with a FFT next

    % gets data from workspace
    bbb_pacotes = evalin('base','bbb_data')-8191;
    
    num_points = 148*floor(length(bbb_pacotes)/148);
    
    % averages all 148 buckets
    average = zeros(1,num_points/148);
    
    for i=1:1:148
       average = average + bbb_pacotes(i:148:num_points);  
    end
    average = average/148;
    h = figure;
    set(h,'NumberTitle','off','Name','Turn-by-turn Analysis');
    subplot(2,1,1)
    plot(average);
    xlabel('Turn','FontWeight','bold');
    ylabel('Amplitude (Counts)','FontWeight','bold');
    
    % calculates FFT
    N = length(average);
    frev = 476066000/148;
    NFFT = 2^nextpow2(N);
    
    freq=(frev/2)*linspace(0,1,NFFT/2+1);
    average_DC = mean(average);
    average_AC = average - average_DC;
    
    FFT = 4.631*2*abs(fft(average_AC.*flattopwin(N)',NFFT))/N;
    
    fft_freq = freq;
    fft_amp = FFT(1:NFFT/2+1);
    
    subplot(2,1,2);
    semilogy(fft_freq,fft_amp);
    xlabel('Frequency (Hz)','FontWeight','bold');
    ylabel('Amplitude (Counts)','FontWeight','bold');