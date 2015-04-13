function tf_list = fofb_psresponse_identify(data)

n_ps = size(data.ps_readings, 2);

dt = data.time(2)-data.time(1);

tf_list = cell(n_ps, 1);
for i=1:n_ps
    ps_readings = data.ps_readings(:,i);
    ps_setpoints = data.ps_setpoints(:,i);
    
    n = 5;
    
    amplitude_before = mean(ps_readings(1:n));
    amplitude_after = mean(ps_readings(end-10:end));
    delta_amplitude = amplitude_after - amplitude_before;

    ps_readings = (ps_readings - amplitude_before)./delta_amplitude;
    ps_setpoints = (ps_setpoints - ps_setpoints(1))./(ps_setpoints(end)-ps_setpoints(1));
    %P2ZDU
    sys = tf(pem(iddata(ps_readings, ps_setpoints, dt),'P1D', 'Td', 1, 'Td', {'max', 5}));
    tf_list{i} = c2d(sys(1,1), dt);
    
    figure;
    a=step(tf_list{i}*tf(1,1,dt,'ioDelay',n),data.time);
    plot(data.time, [a,ps_readings]);
end