function [Paa, Paa_RMS]  = libera_psd(a, low, high)

a = a(:);

N = length(a);

if exist('hanning') == 0
    w = ones(N,1);            % no window
else
    w = hanning(N);           % hanning window
end
U = sum(w.^2)/N;              % approximately .375 for hanning
%U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)


a_w = a .* w;
A = fft(a_w);
Paa = A.*conj(A)/N;
Paa = Paa/U;
Paa = Paa(1:ceil(N/2));
Paa(2:end) = 2*Paa(2:end);
Paa(1) = 0; % Remove the DC term
Paa_RMS_Total = sqrt(sum(Paa)/N);
Paa_RMS = sqrt(sum(Paa(low:high))/N);
a_RMS = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));

