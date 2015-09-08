function Wn = genWn(data, Ts)

Fs = 1/Ts;
npts = size(data,1)/10;
nn = size(data,2);

fmin = 75;
fmax = 76;

[A,f] = psdrms(data,Fs,fmin,fmax,rectwin(npts),floor(npts*0.5),npts,'rms');

noise_std = A(end,:)/sqrt(fmax-fmin)*sqrt(Fs/2);

Wn = ss([],[],[],diag(noise_std),Ts);