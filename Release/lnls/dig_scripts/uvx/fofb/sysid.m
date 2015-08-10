function [m_bpm,m_bpm_,r_bpm,m_corr,r_corr,comp_bpm,comp_corr,m_bpm_corr,M,sel_corr,gain_bpm_corr,gain_corr]=sysid(fadata, prbsperiod)

npts=10e3+1e3;
npts2=10e3;

for i=1:42
    dataset{i} = facutdata(fadata, (i-1)*npts + (npts-npts2)-100 + (1:floor(npts2/prbsperiod)*prbsperiod), [], i);
end

discard_periods = 1;

nperiods = floor(size(dataset{1}.bpm_readings,1)/prbsperiod);

for i=1:length(dataset)
    dataset{i} = facutdata(dataset{i}, 1:nperiods*prbsperiod);
end

nperiods = nperiods-discard_periods;

fcn = @arx;
order_corr = [5 5 2];
order_bpm = [5 5 2];

Ts = 320e-6;

% outdata = detrend(double(datanoise.bpm_readings),0);
%
% for j=1:size(outdata,2)
%     x = iddata(outdata(:,j), [], Ts);
%     mnoise = ar(x, 500);
%     mnoise.b = mnoise.a;
%     mnoise.a = [];
%     pw{j} = mnoise;
% end


outdatam_bpm = [];
m_bpm = [];
r_bpm = [];

for i=1:length(dataset)
    %outdata = detrend(double(dataset{i}.corr_readings(:,i)),0);
    outdata_bpm = detrend(double(dataset{i}.bpm_readings),0);
    outdata_corr = detrend(double(dataset{i}.corr_readings),0);
    indata = detrend(double(dataset{i}.corr_setpoints),0); %indata = detrend(double(dataset{i}.corr_setpoints(:,i)),0);
    
    data_bpm{i} = iddata(outdata_bpm, indata, Ts);
    data_corr{i} = iddata(outdata_corr, indata, Ts);
    
    for j=1:size(outdata_bpm,2)
        aux = reshape(outdata_bpm(:,j), prbsperiod, size(outdata_bpm,1)/prbsperiod);
        outdatam_bpm(:,j) = sum(aux(:,end-nperiods+1:end), 2)/nperiods;
        %plot(aux); hold on; plot(outdatam_bpm(:,j),'y','LineWidth',5); hold off, pause
    end
    
    aux = reshape(outdata_corr, prbsperiod, size(outdata_corr,1)/prbsperiod);
    outdatam_corr = sum(aux(:,end-nperiods+1:end), 2)/nperiods;
    
    datam_bpm_ = data_bpm{i};
    datam_corr_ = data_corr{i};
    
    set(datam_bpm_, 'OutputData', outdatam_bpm, 'InputData', indata(1:prbsperiod,:));
    set(datam_corr_, 'OutputData', outdatam_corr, 'InputData', indata(1:prbsperiod,:));
    
    datam_bpm{i} = datam_bpm_;
    datam_corr{i} = datam_corr_;
end

for i=1:length(data_bpm)
    data = datam_corr{i};
    m_corr{i} = fcn(data, order_corr);
    r_corr{i} = resid(m_corr{i}, data);
     %resid(m_corr{i}, data)
    
    for j=1:size(data_bpm{i}.OutputData,2)
        data = datam_bpm{i}(:,j);
        
        m_bpm{j,i} = fcn(data, order_bpm);
        r_bpm{j,i} = resid(m_bpm{j,i}, data);
        
%         compare(m{i,j}, data_bpm{i}(:,j));
%         resid(m{i,j}, data_bpm{i}(:,j))
%         
%         [A,f] = fourierseries([data.OutputData r{i,j}.OutputData], 1/Ts);
%         [A2, f2] = fourierseries(data.InputData, 1/Ts);
%         %[A,f] = fourierseries([r{i,j}.OutputData], 1/Ts);
%         figure(1)
%         semilogy(f2,A2,'o-');
%         hold all
%         semilogy(f,A,'.-');
%         hold off
%         title([num2str(i) ' x ' num2str(j)]);
%         %axis([1000 1300 1e-6 0.02])
%         set(gca, 'XTick', floor((0:1/Ts/prbsperiod:1/Ts)*100)/100);
%         grid on
%         figure(2);
%         bode(m{i,j})
%         figure(3);
%         step(m{i,j})
%         pause;
%         
        
        fprintf('%d x %d\n',i, j)
    end
    
     %pause
end

tau_corr = 2.5e-3;

for i=1:42
    m_corr_{i} = ss(m_corr{i}('meas'));
    gain_corr(i) = dcgain(m_corr_{i});
    m_corr_{i} = m_corr_{i}/dcgain(m_corr_{i});
    m_corr_{i}.name = fadata.corr_names{i};
    
    comp_corr{i} = utTuningIMC(m_corr_{i}, tau_corr);
    comp_corr{i}.name = fadata.corr_names{i};
    comp_corr{i} = minreal(comp_corr{i}*tf([1 -1],[1 0],-1));
    comp_corr{i} = comp_corr{i}/dcgain(comp_corr{i});
    comp_corr{i} = balred(comp_corr{i}, 3);
end
m_corr = m_corr_;



tau_bpm = 4e-3;

for i=1:50
    for j=1:42
        aux=tf(m_bpm{i,j}('meas'));
        m_bpm_num{i,j} = aux.num{1};
        m_bpm_den{i,j} = aux.den{1};
        M(i,j) = dcgain(aux);
    end
end

m_bpm_ = tf(m_bpm_num,m_bpm_den,320e-6);

for i=1:50
for j=1:42

end
end


[~,sel_corr] = max(abs(M),[],2);

for i=1:50
    m_bpm_corr{i} = ss(m_bpm{i, sel_corr(i)}('meas'));
    gain_bpm_corr(i) = dcgain(m_bpm_corr{i});
    m_bpm_corr{i} = m_bpm_corr{i}/gain_bpm_corr(i);
    m_bpm_corr{i}.name = fadata.bpm_names{i};
    m_bpm_corr{i}.OutputName = fadata.bpm_names{i};
    m_bpm_corr{i}.InputName = fadata.corr_names{sel_corr(i)};
    
    comp_bpm{i} = utTuningIMC(m_bpm_corr{i}*comp_corr{sel_corr(i)}, tau_bpm);
    comp_bpm{i}.name = fadata.bpm_names{i};
    comp_bpm{i} = minreal(comp_bpm{i}*tf([1 -1],[1 0],-1));
    comp_bpm{i} = comp_bpm{i}/dcgain(comp_bpm{i});
    comp_bpm{i} = balred(comp_bpm{i}, 3);
end


