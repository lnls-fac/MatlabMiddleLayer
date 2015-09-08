function Wd = genWd(data, Ts, fsin_fixed, bwsin_fixed)

Fs = 1/Ts;
nd = size(data,2);

% Narrow-band disturbance
wdw = flattopwin(size(data,1));
PG_wdw = sum(wdw)/length(wdw);
[A,f] = fourierseries(data, Fs, wdw);

for i = 1:length(fsin_fixed)
    for j = 1:size(A,2)
        Asin(j,i) = linterp(f,A(:,j),fsin_fixed(i))/PG_wdw;
    end
    
    
    [b,a] = iirpeak(fsin_fixed(i)/Fs*2, bwsin_fixed(i)/Fs*2);
    tfs{i} = tf(b,a,Ts);
end
tf_sin = Asin*blkdiag(tfs{:});


% 1/f^2 disturbance
[A,f] = fourierseries(data, Fs);
Af2 = 100*A(2,:)*f(2); % FIXME: factor 100

tf_Af2 = tf(2*pi*Ts,[1 -1+1e-6],Ts)*Af2';


Wd = parallel(tf_sin, tf_Af2, [], [], 1:nd, 1:nd);