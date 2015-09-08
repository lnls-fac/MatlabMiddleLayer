function Wz = genWz(gains, tau, Ts)

Fs = 1/Ts;

for i=1:length(tau)
    if tau > Ts
        [b,a] = butter(1,Ts/tau(i));
        sys{i} = ss(tf(b,a,Ts));
    else
        sys{i} = ss([],[],[],1,Ts);
    end
end

Wz = blkdiag(sys{:})*diag(gains);