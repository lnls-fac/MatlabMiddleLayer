function tunes = lnls_naff(data, init_tunes)
% lnls_naff
% 
% Analise de Frequencias Fundamentais
%
% Examplo:
%
% global THERING;
% data = ringpass(THERING, [0.0001 0 0.0001 0 0 0]', 1024);
% tunes = lnls_naff(data(1,:), [24.26, 13.18]);


options.Display = 'off';
options.TolFun = 1e-15;

[x,fval,exitflag,output] = fminsearch(@(freqs) get_rms(freqs,data),init_tunes, options);
tunes = x;

function rms = get_rms(freqs, data)

[m b f] = get_m_b(freqs, data);

a = m \ b;

rms = data;
for i=1:length(a)
    rms = rms - a(i) * f(i,:);
end
rms = sqrt(sum(rms .^ 2)/length(rms));





function [m b f] = get_m_b(freqs, data)

v = 2 * pi * (1:(length(data)));

m = zeros(2*length(freqs));
b = zeros(2*length(freqs),1);
f = zeros(2*length(freqs), length(data));

for i=1:length(freqs)
    f(i,:) = sin(freqs(i)*v);
    f(i+length(freqs),:) = cos(freqs(i)*v);
end

for i=1:size(f,1)
    fi = f(i,:);
    for j=i:size(f,1)
        fj = f(j,:);
        m(i,j) = sum(fi .* fj);
        m(j,i) = m(i,j);
    end
    b(i)  = sum(data .* fi);
end
