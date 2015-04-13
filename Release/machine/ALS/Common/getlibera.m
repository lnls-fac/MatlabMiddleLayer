function [AM, SP, BPMName] = getlibera(Port, DevList, TriggerFlag)
%GETLIBERA - Gets data from all the different ports for the Libera BPM
%  [Monitors, Setpoints, BPMName] = getlibera(Port, DevList, TriggerFlag)
%
%  INPUTS
%  1. Port - ADC, DD1, DD2, DD3, DD4, ENV, FA, PM, SA
%  2. DevList - BPM device list (or EPICS name) {Default: getbpmlist('Libera')}
%  3. TriggerFlag
%
%  OUTPUTS
%  1. Monitors  - All the monitor  channels for the port
%  2. Setpoints - All the setpoint channels for the port
%  3. BPMName   - First field of the EPICS BPM name
%
%  NOTES
%  1. For ADC, DD1-DD4 ports, the following are set:
%         ENV:ENV_DSC_SP      = 0
%         ENV:ENV_SWITCHES_SP = 0
%         ENV:ENV_AGC_SP      = 0
%  
%  2. The Libera assumes an RF frequency of 499.642
%
%     Storage Ring
%     ADC:   Runs at the oscillator rate (117.2940 MHz or 8.525585 nsec/sample) (1024 waveform)
%     DD1-4: Decimation =   77 from ADC  (  1.5233 MHz or 656.4700 nsec/sample) (1k, 10k, 30k, 400k waveforms)
%     FA:    Decimation =  150 from DD   ( 10.1553 kHz or .0984705 msec/sample) (8192 waveform)
%     SA:    Decimation = 1024 from FA   (  9.9173  Hz or .1008338  sec/sample) (no waveform?)
%
%     Booster Ring
%     ADC:   Runs at the oscillator rate (115.9169 MHz or 8.6268697 nsec/sample) (1024 waveform)
%     DD1-4: Decimation =   29 from ADC  (  3.9971 MHz or 250.17922 nsec/sample) (1k, 10k, 30k, 400k waveforms)
%     FA:    Decimation =  399 from DD   ( 10.0179 kHz or .09982151 msec/sample) (8192 waveform)
%     SA:    Decimation = 1024 from FA   (  9.7831  Hz or .10221722  sec/sample) (no waveform?)
%
%  3. getbpmlist('Libera') returns the device list for all the Libera BPMs.
%
%  4. For manual AGC setting (sector 3 example)
%     setpv('LIBERA_0AB3:ENV:ENV_AGC_SP', 0)
%     setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP', NewGain);  % -33 dBms is 0 attenuation
%     getpv('LIBERA_0AB3:ENV:ENV_GAIN_MONITOR')
%
%     If ENV_AGC_SP=1 (AUTO), then ENV_GAIN_MONITOR=NaN
%
%  See also liberainit, libera

%  Written by Greg Portmann


% Sector 3
% Slow data setup:
% [root@xcep root]# /opt/bin/libera -l
%        Temp [C]: 48
%      Fans [rpm]: 5310 5130
%   Voltages [mV]: 1495 1814 2493 3293 5077 12293 -12656 -4997 
%          SC PLL: unlocked
%          MC PLL: unlocked
%        TRIGmode: 1
%         Kx [nm]: 10000000
%         Ky [nm]: 10000000
%    Xoffset [nm]: 0
%    Yoffset [nm]: 0
%    Qoffset [nm]: 0
%        Switches: 255
%     Level [dBm]: -62
%             AGC: 1
%             DSC: 2
%       Interlock: 3 -1000000 1000000 -1000000 1000000 1900 5 -40
% 
% Fast data setup:
% [root@xcep root]# /opt/bin/libera -l
%        Temp [C]: 49
%      Fans [rpm]: 5340 5130
%   Voltages [mV]: 1492 1813 2493 3290 5077 12293 -12656 -4997 
%          SC PLL: unlocked
%          MC PLL: unlocked
%        TRIGmode: 1
%         Kx [nm]: 10000000
%         Ky [nm]: 10000000
%    Xoffset [nm]: 0
%    Yoffset [nm]: 0
%    Qoffset [nm]: 0
%        Switches: 0
%     Level [dBm]: -61
%             AGC: 0
%             DSC: 0
%       Interlock: 3 -1000000 1000000 -1000000 1000000 1900 5 -40


% To-do
% 1. Input strings:
%    'Trigger' or 'NoTrigger'
%    'DSC', 'On'
%    'Switching', ...
% 2. Does the ADC port requires a trigger?
% 3. Add plotting for no output


if nargin < 1 || isempty(Port)
    FieldCell = {'ADC','DD1','DD2','DD3','DD4','ENV','FA','PM','SA'};
    [ModeNumber, OKFlag] = listdlg('Name','Libera Fields','PromptString','Libera Fields:', 'SelectionMode','single', 'ListString', FieldCell, 'ListSize', [120 150]);
    if OKFlag
        Port = FieldCell{ModeNumber};
    else
        return;
    end
end

if nargin < 2 || isempty(DevList)
    DevList = getbpmlist('Libera');
end

if nargin < 3
    if any(strcmpi(Port, {'ADC','FA','PM','DD1','DD2','DD3'}))
        % Typically triggered
        TriggerFlag = 1;
    else
        % Typically trigger ignored
        TriggerFlag = 0;
    end
end


% More than 1 libera
if size(DevList,1) > 1
    for i = 1:size(DevList,1)
        if strcmpi(Port, 'SA')
            % Setpoint field is empty for an SA port
            [AM(i,1), SP,      BPMName{i,1}] = getlibera(Port, DevList(i,:), TriggerFlag);
        else
            [AM(i,1), SP(i,1), BPMName{i,1}] = getlibera(Port, DevList(i,:), TriggerFlag);
        end
    end
    return
end


% Convert the device list to an EPICS name (first field only)
for i = 1:size(DevList,1)
    if ischar(DevList(i,:))
        % Input can be BPMName directly
        BPMName(i,:) = DevList(i,:);
    else
        % Convert DeviceList to a Libera BPM name
        if isstoragering
            if all(DevList(i,:) == [3 5])
                BPMName(i,:) = 'LIBERA_0AB3';  % Sector 03  (0-d0-50-31-a-b3.dhcp.lbl.gov)
            elseif all(DevList(i,:) == [6 5])
                BPMName(i,:) = 'LIBERA_0AAD';  % Sector 06  (0-d0-50-31-a-ad.dhcp.lbl.gov)
            elseif all(DevList(i,:) == [9 5])
                BPMName(i,:) = 'LIBERA_0AAC';  % Sector 09  (0-d0-50-31-a-ac.dhcp.lbl.gov)
            elseif all(DevList == [12 5])
                BPMName(i,:) = 'LIBERA_0AB2';  % Sector 12  (0-d0-50-31-a-b2.dhcp.lbl.gov)
            else
                error('Device not installed.');
            end
        else
            % Booster
            BPMName(i,:) = 'LIBERA_0A7E';     % 0-d0-50-31-a-7e.dhcp.lbl.gov
        end
    end
end


% Get the data
[AM, SP] = libera(Port, BPMName, TriggerFlag);


if nargout == 0
    if any(strcmpi(Port,{'SA','ENV','FA'}))

    elseif strcmpi(Port, 'ADC')
        % ADC Port
        s = AM.ADC_A_MONITOR+AM.ADC_B_MONITOR+AM.ADC_C_MONITOR+AM.ADC_D_MONITOR;

        if isstoragering
            DeltaT = 1/117.2940e6;
        else
            DeltaT = 1/115.9169e6;
        end
        t = 1e9 * DeltaT * (0:length(s)-1);

        
        figure(1);
        clf reset
        h(1) = subplot(4,1,1);
        plot(t, AM.ADC_A_MONITOR);
        ylabel('A');
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');

        h(2) = subplot(4,1,2);
        plot(t, AM.ADC_B_MONITOR);
        ylabel('B');

        h(3) = subplot(4,1,3);
        plot(t, AM.ADC_C_MONITOR);
        ylabel('C');

        h(4) = subplot(4,1,4);
        plot(t, AM.ADC_D_MONITOR);
        ylabel('D');
        xlabel('Time [nanoseconds]');

        addlabel(0, 0, sprintf('Trace #%d',  AM.ADC_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.ADC_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
        
        
        figure(2);
        clf reset
        plot(t, [AM.ADC_A_MONITOR; AM.ADC_B_MONITOR; AM.ADC_C_MONITOR; AM.ADC_D_MONITOR]);
        xlabel('Time [nanoseconds]');
        legend('A','B','C','D');
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');
        addlabel(0, 0, sprintf('Trace #%d',  AM.ADC_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.ADC_FINISHED_MONITOR_TIMESTAMP)));

        
        % figure(2);
        % clf reset
        % h(5) = subplot(3,1,1);
        % plot(t, ((AM.ADC_A_MONITOR+AM.ADC_D_MONITOR) - (AM.ADC_B_MONITOR+AM.ADC_C_MONITOR)) ./ s);
        % ylabel('Horizontal');
        % title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');
        % yaxis([-10 10]);
        %
        % h(6) = subplot(3,1,2);
        % plot(t, ((AM.ADC_A_MONITOR+AM.ADC_B_MONITOR) - (AM.ADC_C_MONITOR+AM.ADC_D_MONITOR)) ./ s);
        % ylabel('Vertical');
        % yaxis([-10 10]);
        %
        % h(7) = subplot(3,1,3);
        % plot(t, s);
        % ylabel('Sum');
        % xlabel('Time [nanoseconds]');
        %
        % addlabel(0, 0, sprintf('Trace #%d',  AM.ADC_FINISHED_MONITOR));
        % addlabel(1, 0, sprintf('%s', datestr(AM.ADC_FINISHED_MONITOR_TIMESTAMP)));

        
    elseif strcmpi(Port, 'PM')
        % PM Port
        if isstoragering
            DeltaT = 328/499.642e6;
        else
            DeltaT = 250e-9;
        end
        t = DeltaT * (0:length(AM.PM_SUM_MONITOR)-1);

        figure(1);
        clf reset
        h = subplot(3,1,1);
        plot(t, AM.PM_X_MONITOR);
        ylabel({'Horizontal','(Computed)'});
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');

        h(2) = subplot(3,1,2);
        plot(t, AM.PM_Y_MONITOR);
        ylabel({'Vertical','(Computed)'});

        h(3) = subplot(3,1,3);
        plot(t, AM.PM_SUM_MONITOR);
        ylabel('Sum');
        xlabel('Time [seconds]');

        addlabel(0, 0, sprintf('Trace #%d',  AM.PM_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.PM_FINISHED_MONITOR_TIMESTAMP)));

        
        figure(2);
        clf reset
        h(4) = subplot(4,1,1);
        plot(t, AM.PM_VA_MONITOR);
        ylabel('VA');
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');

        h(5) = subplot(4,1,2);
        plot(t, AM.PM_VB_MONITOR);
        ylabel('VB');

        h(6) = subplot(4,1,3);
        plot(t, AM.PM_VC_MONITOR);
        ylabel('VC');
        
        h(7) = subplot(4,1,4);
        plot(t, AM.PM_VD_MONITOR);
        ylabel('VD'); 
        xlabel('Time [seconds]');

        addlabel(0, 0, sprintf('Trace #%d',  AM.PM_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.PM_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
        
        
    elseif strcmp(Port, 'DD2')
        % DD2 Port
        if isstoragering
            DeltaT = 328/499.642e6;
        else
            DeltaT = 250e-9;
        end
        t = DeltaT * (0:length(AM.DD_QA_MONITOR)-1);

        figure(5);
        clf reset
        h = subplot(4,1,1);
        plot(t,[AM.DD_QA_MONITOR; AM.DD_IA_MONITOR]);
        ylabel('QA & IA');
        title(sprintf('%s Data for %s', Port, BPMName),'interpret','none');

        h(2) = subplot(4,1,2);
        plot(t,[AM.DD_QB_MONITOR; AM.DD_IB_MONITOR]);
        ylabel('QB & IB');

        h(3) = subplot(4,1,3);
        plot(t,[AM.DD_QC_MONITOR; AM.DD_IC_MONITOR]);
        ylabel('QC & IC');
        
        h(4) = subplot(4,1,4);
        plot(t,[AM.DD_QD_MONITOR; AM.DD_ID_MONITOR]);
        ylabel('QD & ID');
        xlabel('Time [seconds]');
        
        addlabel(0, 0, sprintf('Trace #%d',  AM.DD_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.DD_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');

        
    elseif any(strcmp(Port, {'DD1','DD3','DD4'}))
        % DD1, DD3, DD4 Ports
        if isstoragering
            DeltaT = 328/499.642e6;
        else
            DeltaT = 250e-9;
        end
        t = DeltaT * (0:length(AM.DD_SUM_MONITOR)-1);

        figure(3);
        clf reset
        h = subplot(3,1,1);
        plot(t, AM.DD_X_MONITOR/1e6);
        ylabel('Horizontal [mm]');
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');

        h(2) = subplot(3,1,2);
        plot(t, AM.DD_Y_MONITOR/1e6);
        ylabel('Vertical [mm]');

        h(3) = subplot(3,1,3);
        plot(t, AM.DD_SUM_MONITOR/1e6);
        ylabel('Sum');
        xlabel('Time [seconds]');

        addlabel(0, 0, sprintf('Trace #%d',  AM.DD_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.DD_FINISHED_MONITOR_TIMESTAMP)));

        
        figure(4);
        clf reset
        h(4) = subplot(4,1,1);
        plot(t, AM.DD_VA_MONITOR);
        ylabel('VA');
        title(sprintf('BPM(%d,%d)  %s  %s', DevList, Port, BPMName),'interpret','none');

        h(5) = subplot(4,1,2);
        plot(t, AM.DD_VB_MONITOR);
        ylabel('VB');

        h(6) = subplot(4,1,3);
        plot(t, AM.DD_VC_MONITOR);
        ylabel('VC');
        
        h(7) = subplot(4,1,4);
        plot(t, AM.DD_VD_MONITOR);
        ylabel('VD'); 
        xlabel('Time [seconds]');

        addlabel(0, 0, sprintf('Trace #%d',  AM.DD_FINISHED_MONITOR));
        addlabel(1, 0, sprintf('%s', datestr(AM.DD_FINISHED_MONITOR_TIMESTAMP)));
        linkaxes(h, 'x');
    end
end

