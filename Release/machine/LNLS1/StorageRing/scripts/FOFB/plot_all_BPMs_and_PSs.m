close all

%load('\\centaurus\Repositorio\Grupos\DIG\Projetos\Ativos\DT_FOFB\LNLS\Experimentos\Aquisição rápida\fadata_20110528_20h50.mat', 'data');
%load('\\centaurus\Repositorio\Grupos\DIG\Projetos\Ativos\DT_FOFB\LNLS\Experimentos\Aquisição rápida\fadata_20110527_11h31.mat', 'data');

% Number of BPMs in the dataset (consider dataset has concatenated
% horizontal and vertical BPM readings)
n_bpms = size(data.orb,2)/2;
n_ps = size(data.ps,2);
n_ps_setpoint = size(data.ps,2);
% Selected BPM indexes
selected_bpms = 1:n_bpms;
selected_ps   = 1:n_ps;
selected_ps_setpoint = 1:n_ps_setpoint;

% Convert BPM data from mm to um
bpm_position = 1e3*data.orb;

% Remove DC component
bpm_position_dc = mean(bpm_position);
bpm_position_ac = bpm_position - repmat(bpm_position_dc,size(bpm_position,1), 1);
ps_dc = mean(data.ps);
ps_setpoint_dc = mean(data. ps_setpoint);
ps_ac = data.ps - repmat(ps_dc,size(data.ps,1),1);
ps_setpoint_ac=data.ps_setpoint - repmat(ps_setpoint_dc,size(data.ps_setpoint,1),1);
%offsets
offset_step = 200;
offsets = selected_bpms*offset_step-mean(selected_bpms*offset_step);
offset_step = 1;
offsets_ps = selected_ps*offset_step-mean(selected_ps*offset_step);
offsets_setpoints = selected_ps_setpoint*offset_step-mean(selected_ps_setpoint*offset_step);
offsets = [offsets offsets];
offsets_ps = [offsets_ps];
offsets_setpoints = [offsets_setpoints ];
bpm_position_offset = (bpm_position_ac - repmat(offsets,size(bpm_position,1), 1));
ps_offset = (ps_ac-repmat(offsets_ps,size(data.ps,1),1));
ps_setpoint_offset = (ps_setpoint_ac-repmat(offsets_ps,size(data.ps_setpoint,1),1));


% Sampling rate
Fs_rounded = round(1/(data.time(2)-data.time(1))*100)/100;

bpm_indexes = selected_bpms;
ps_indexes = selected_ps;
ps_setpoint_indexes = selected_ps_setpoint;
% plota bpm's
if(length(data.orb)>0) 
fig = figure;
set(fig,'Name',['Horizontal plane BPM readings']);
plot(data.time, bpm_position_offset(:,bpm_indexes));
xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
ylabel('Position (um)','FontSize',12,'FontWeight','bold');
title(['Horizontal plane (' num2str(Fs_rounded) ' kHz acquisition)'],'FontSize',12,'FontWeight','bold');
legend(data.bpm_names(bpm_indexes),'FontSize',8);

bpm_indexes = selected_bpms + n_bpms;
fig = figure;
set(fig,'Name',['Vertical plane BPM readings']);
plot(data.time, bpm_position_offset(:,bpm_indexes));
xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
ylabel('Position (um)','FontSize',12,'FontWeight','bold');
title(['Vertical plane (' num2str(Fs_rounded) ' kHz acquisition)'],'FontSize',12,'FontWeight','bold');
legend(data.bpm_names(bpm_indexes),'FontSize',8);
end
%plota ps
if(length(data.ps)>0)
fig = figure;
set(fig,'Name',['Power Supply Readings']);
plot(data.time, ps_offset(:,selected_ps));
xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
ylabel('Current (A)','FontSize',12,'FontWeight','bold');
title(['Power Supply Readings'],'FontSize',12,'FontWeight','bold');
legend(data.ps_names(ps_indexes),'FontSize',8);

fig = figure;
set(fig,'Name',['Power Supply Setpoints']);
plot(data.time, ps_setpoint_offset(:,selected_ps_setpoint));
xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
ylabel('Current (A)','FontSize',12,'FontWeight','bold');
title(['Power Supply Readings'],'FontSize',12,'FontWeight','bold');
legend(data.ps_setpoint_name(ps_setpoint_indexes),'FontSize',8);
end
