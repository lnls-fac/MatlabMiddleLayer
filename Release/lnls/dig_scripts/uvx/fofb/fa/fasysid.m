function [syscorrps, sysfofb, sysbpm, eqlcorrps, eqlbpm, r, M, sel_corr] = fasysid(fadata, prbsperiod)

npts = 10e3+1e3;     % FIXME
npts2 = 10e3;        % FIXME
ndiscard_periods = 1;
Ts = 320e-6;

fcn = @arx;
order_corrps = [10 10 2];
order_fofb = [5 5 2];
order_bpm = [2 2 1];

target_corrps = feedback(1,ss([],[],[],1,Ts,'iodelay',3)*tf([Ts 0],[1 -1],Ts)*500);
target_bpm = feedback(1,ss([],[],[],1,Ts,'iodelay',3)*tf([Ts 0],[1 -1],Ts)*300);

nperiods = floor(npts2/prbsperiod);
for i=1:size(fadata.corr_setpoints,2)
    dataset{i} = facutdata(fadata, (i-1)*npts + (npts-npts2) + (1:nperiods*prbsperiod), [], i);
end
nperiods = nperiods - ndiscard_periods;

% Equalizer (tunable transfer function)
eql = ltiblock.tf('eql', 3, 3, Ts);

for i=1:length(dataset)
    % Input data - corrector's setpoint
    indata = detrend(double(dataset{i}.corr_setpoints),0);
    
    % - Correctors
    % -- Average repetitive corrector data
    outdata_corrps = detrend(double(dataset{i}.corr_readings),0);
    aux = reshape(outdata_corrps, prbsperiod, size(outdata_corrps,1)/prbsperiod);
    outdatam_corrps = sum(aux(:,end-nperiods+1:end), 2)/nperiods;
    %plot(aux); hold on; plot(outdatam_corrps,'y','LineWidth',5); hold off, pause
    
    % -- Build identification data
    data = iddata(outdata_corrps, indata, Ts);
    datam = iddata(outdatam_corrps, indata(1:prbsperiod,:), Ts);
    
    % -- Identify correctors
    m_corrps{i} = fcn(datam, order_corrps);
    r_syscorrps{i} = resid(m_corrps{i}, datam, 'Corr');
    fprintf('Corrector: %d\n',i);
    
    % -- Extract state-space model
    syscorrps{i} = ss(m_corrps{i}('meas'));
    syscorrps{i} = syscorrps{i}/dcgain(syscorrps{i});
    syscorrps{i}.name = fadata.corr_names{i};
    
    % -- Synthesize corrector equalizer
    CL0 = feedback(1, syscorrps{i}*eql*tf([Ts 0],[1 -1], Ts))/target_corrps-1;
    set(CL0, 'InputName', 'd', 'OutputName', 'y');
    
    SoftReqs = TuningGoal.Variance('d','y',1/sqrt(Ts));
    CL = systune(CL0, SoftReqs, [], systuneOptions('RandomStart',5));
    eqlcorrps{i} = CL.Blocks.eql;
    eqlcorrps{i} = ss(eqlcorrps{i});
    eqlcorrps{i} = eqlcorrps{i}/dcgain(eqlcorrps{i});
    
    % - FOFB and BPMs
    % -- Modify excitation data to take orbit corrector dynamics into account
    indata_filt = lsim(syscorrps{i}, indata);
    
    % -- Average repetitive BPM data
    outdata_fofb = detrend(double(dataset{i}.bpm_readings),0);    
    
    for j=1:size(outdata_fofb,2)
        aux = reshape(outdata_fofb(:,j), prbsperiod, size(outdata_fofb,1)/prbsperiod);
        outdatam_fofb = sum(aux(:,end-nperiods+1:end), 2)/nperiods;
        %plot(aux); hold on; plot(outdatam_fofb(:,j),'y','LineWidth',5); hold off, pause
        
        % -- Build identification data
        datam = iddata(outdatam_fofb, indata(end-prbsperiod+1:end,:), Ts);
        datam_filt = iddata(outdatam_fofb, indata_filt(end-prbsperiod+1:end,:), Ts);
        
        % -- Identify FOFB
        m_fofb{j,i} = fcn(datam, order_fofb);
        r_sysfofb{j,i} = resid(m_fofb{j,i}, datam, 'Corr');
        fprintf('FOFB (corr x BPM): %d x %d\n', i, j);
        
        % -- Extract state-space model
        sysfofb_ = tf(m_fofb{j,i}('meas'));
        sysfofb_num{j,i} = sysfofb_.num{1};
        sysfofb_den{j,i} = sysfofb_.den{1};
        M(j,i) = dcgain(sysfofb_);
        
        % -- Identify BPMs
        m_bpm{j,i} = fcn(datam_filt, order_bpm);
        r_sysbpm{j,i} = resid(m_bpm{j,i}, datam, 'Corr');
        fprintf('BPM (corr x BPM): %d x %d\n', i, j);
        
        % -- Extract state-space model
        sysbpm_ = tf(m_bpm{j,i}('meas'));
        sysbpm_ = sysbpm_/dcgain(sysbpm_);
        sysbpm_num{j,i} = sysbpm_.num{1};
        sysbpm_den{j,i} = sysbpm_.den{1};
    end
    
end

sysfofb = tf(sysfofb_num, sysfofb_den, Ts);
sysbpm = tf(sysbpm_num, sysbpm_den, Ts);

% For each BPM, select orbit corrector which gives larger response
[~,sel_corr] = max(abs(M),[],2);

for i=1:size(M,1)
    % -- Synthesize BPM equalizer
    CL0 = feedback(1, eqlcorrps{sel_corr(i)}*sysfofb(i,sel_corr(i))*eql*tf([Ts 0],[1 -1], Ts))/target_bpm-1;
    set(CL0, 'InputName', 'd', 'OutputName', 'y');
    SoftReqs = TuningGoal.Variance('d','y',1/sqrt(Ts));
    CL = systune(CL0, SoftReqs, [], systuneOptions('RandomStart',5));
    eqlbpm{i} = CL.Blocks.eql;
    eqlbpm{i} = ss(eqlbpm{i});
    eqlbpm{i} = eqlbpm{i}/dcgain(eqlbpm{i});
    
%     bode(feedback(1, CL.Blocks.eql*eqlcorrps{sel_corr(i)}*sysfofb(i,sel_corr(i))*tf([Ts 0],[1 -1], Ts)),target)
%     pause
end

r.corrps = r_syscorrps;
r.fofb = r_sysfofb;
r.bpm = r_sysbpm;