function [AM, SP, BPMName] = getlibera(Port, DevList, TriggerFlag)
%  [AM, SP, BPMName] = getlibera(Port, DevList)
%
%  INPUTS
%  1. Port - ADC, DD1, DD2, DD3, DD4, ENV, FA, PM, SA
%  2. DevList - BPM device list (or EPICS name) {Default: getbpmlist('Libera')}
%
%  NOTES
%  1. The Libera assumes an RF frequency of 499.642 
%     ADC:   Runs at the oscillator rate (115.9169 MHz or 8.6268697 nsec/sample) (1024 waveform)
%     DD1-4: Decimation =   29 from ADC  (  3.9971 MHz or 250.17922 nsec/sample) (1k, 10k, 30k, 400k waveforms)
%     FA:    Decimation =  399 from DD   ( 10.0179 kHz or .09982151 msec/sample) (8192 waveform)
%     SA:    Decimation = 1024 from FA   (  9.7831  Hz or .10221722  sec/sample) (no waveform?)
%
%  2. For DD1-DD4, set DD_REQUEST_CMD = 1 to get new data
%     You might also want to set, ENV:ENV_DSC_SP = 0
%                                 ENV:ENV_SWITCHES_SP = 0
%
%  3. getbpmlist('Libera') returns the device list for all the Libera BPMs.
%


if nargin < 1 || isempty(Port)
    %Port = 'SA';
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
    TriggerFlag = 0;
end


% More than 1 libera
if size(DevList,1) > 1
    for i = 1:size(DevList,1)
        if strcmpi(Port, 'SA')
            [AM(i,1), SP, BPMName{i,1}] = getlibera(Port, DevList(i,:), TriggerFlag);
        else
            [AM(i,1), SP(i,1), BPMName{i,1}] = getlibera(Port, DevList(i,:), TriggerFlag);
        end
    end
    return
end

AM = [];
SP = [];

if ischar(DevList)
    % Input can be BPMName directly
    BPMName = DevList;
else
    % Convert DeviceList to a Libera BPM name
    BPMName = 'LIBERA_0A7E';  % 0-d0-50-31-a-7e.dhcp.lbl.gov
end

switch upper(Port)
    case 'ADC'
        AMNames = {
            'ADC_A_MONITOR'
            'ADC_B_MONITOR'
            'ADC_C_MONITOR'
            'ADC_D_MONITOR'
            'ADC_MONITOR'
            'ADC_FINISHED_MONITOR'
            };
    case 'PM'
        AMNames = {
            'PM_X_MONITOR'
            'PM_Y_MONITOR'
            'PM_Q_MONITOR'
            'PM_SUM_MONITOR'
            'PM_VA_MONITOR'
            'PM_VB_MONITOR'
            'PM_VC_MONITOR'
            'PM_VD_MONITOR'
            'PM_MONITOR'
            'PM_FINISHED_MONITOR'
            'PM_MT_MONITOR'
            'PM_ST_MONITOR'
            };
    case 'FA'
        AMNames = {
            'FA_MEM_MONITOR'
            };
    case 'SA'
        AMNames = {
            'SA_X_MONITOR'
            'SA_Y_MONITOR'
            'SA_Q_MONITOR'
            'SA_SUM_MONITOR'
            'SA_A_MONITOR'
            'SA_B_MONITOR'
            'SA_C_MONITOR'
            'SA_D_MONITOR'
            'SA_CX_MONITOR'
            'SA_CY_MONITOR'
            'SA_MONITOR'
            'SA_FINISHED_MONITOR'
            'SA_ARRAY_MONITOR'
            };
    case 'DD2'
        AMNames = {
            'DD_IA_MONITOR'
            'DD_IB_MONITOR'
            'DD_IC_MONITOR'
            'DD_ID_MONITOR'
            'DD_QA_MONITOR'
            'DD_QB_MONITOR'
            'DD_QC_MONITOR'
            'DD_QD_MONITOR'
            'DD_MONITOR'
            'DD_FINISHED_MONITOR'
            'DD_MT_MONITOR'
            'DD_ST_MONITOR'
            };
    case {'DD1','DD3','DD4'}
        AMNames = {
            'DD_X_MONITOR'
            'DD_Y_MONITOR'
            'DD_Q_MONITOR'
            'DD_SUM_MONITOR'
            'DD_VA_MONITOR'
            'DD_VB_MONITOR'
            'DD_VC_MONITOR'
            'DD_VD_MONITOR'
            'DD_MONITOR'
            'DD_FINISHED_MONITOR'
            'DD_MT_MONITOR'
            'DD_ST_MONITOR'
            };
    case {'ENV'}
        AMNames = {
            'ENV_AGC_MONITOR'
            'ENV_DSC_MONITOR'
            'ENV_SWITCHES_MONITOR'
            'ENV_GAIN_MONITOR'
            'ENV_KX_MONITOR'  % nm/unit, so 10000000 is 10 mm
            'ENV_KY_MONITOR'
            'ENV_Q_OFFSET_MONITOR'
            'ENV_X_OFFSET_MONITOR'
            'ENV_Y_OFFSET_MONITOR'
            'ENV_MC_PLL_MONITOR'
            'ENV_SC_PLL_MONITOR'
            'ENV_ERROR_MONITOR'
            'ENV_BACK_VENT_ACT_MONITOR'
            'ENV_BACK_VENT_CONF_MONITOR'
            'ENV_FRONT_VENT_ACT_MONITOR'
            'ENV_FRONT_VENT_CONF_MONITOR'
            'ENV_TEMP_MONITOR'
            'ENV_TEMP_MAX_MONITOR'
            'ENV_TEMP_MIN_MONITOR'
            'ENV_VOLTAGE0_MONITOR'
            'ENV_VOLTAGE1_MONITOR'
            'ENV_VOLTAGE2_MONITOR'
            'ENV_VOLTAGE3_MONITOR'
            'ENV_VOLTAGE4_MONITOR'
            'ENV_VOLTAGE5_MONITOR'
            'ENV_VOLTAGE6_MONITOR'
            'ENV_VOLTAGE7_MONITOR'
            'ENV_DDFPGA_ERR_MONITOR'
            'ENV_SADRV_ERR_MONITOR'
            'ENV_SAFPGA_ERR_MONITOR'
            'ENV_INTERLOCK_MONITOR'
            'ENV_ILK_GAIN_LIMIT_MONITOR'
            'ENV_ILK_OF_DUR_MONITOR'
            'ENV_ILK_OF_LIMIT_MONITOR'
            'ENV_ILK_X_HIGH_MONITOR'
            'ENV_ILK_X_LOW_MONITOR'
            'ENV_ILK_Y_HIGH_MONITOR'
            'ENV_ILK_Y_LOW_MONITOR'
            'ENV_ILK_MODE_MONITOR'
            };
    otherwise
        error('Channel type unknown');
end


switch upper(Port)
    case 'ADC'
        SPNames = {
            'ADC_IGNORE_TRIG_SP'
            'ADC_ON_NEXT_TRIG_CMD'
            };
    case 'PM'
        SPNames = {
            'PM_IGNORE_TRIG_SP'
            'PM_ON_NEXT_TRIG_CMD'
            'PM_REQUEST_CMD'
            };
    case 'FA'
        SPNames = {
            'FA_MEM_READ_CMD'
            'FA_MEM_WRITE_CMD'
            'FA_LENGTH_SP'
            'FA_OFFSET_SP'
            'FA_MEM_SP'
            };
    case 'SA'
        SPNames = {
            };
    case {'DD1','DD2','DD3','DD4'}
        SPNames = {
            'DD_IGNORE_TRIG_SP'
            'DD_ON_NEXT_TRIG_CMD'
            'DD_REQUEST_CMD'
            'DD_SEEK_POINT_SP'
            'DD_MT_OFFSET_SP'
            'DD_ST_OFFSET_SP'
            };
    case 'ENV'
        SPNames = {
            'ENV_AGC_SP'
            'ENV_DSC_SP'
            'ENV_SWITCHES_SP'
            'ENV_GAIN_SP'
            'ENV_KX_SP'
            'ENV_KY_SP'
            'ENV_Q_OFFSET_SP'
            'ENV_X_OFFSET_SP'
            'ENV_Y_OFFSET_SP'
            'ENV_COMMIT_MTST_CMD'
            'ENV_COMMIT_MT_CMD'
            'ENV_COMMIT_ST_CMD'
            'ENV_SETMTPHASE_SP'
            'ENV_SETMT_SP'
            'ENV_SETST_SP'
            'ENV_INTERLOCK_CLEAR_CMD'
            'ENV_SET_INTERLOCK_PARAM_CMD'
            'ENV_ILK_GAIN_LIMIT_SP'
            'ENV_ILK_OF_DUR_SP'
            'ENV_ILK_OF_LIMIT_SP'
            'ENV_ILK_X_HIGH_SP'
            'ENV_ILK_X_LOW_SP'
            'ENV_ILK_Y_HIGH_SP'
            'ENV_ILK_Y_LOW_SP'
            'ENV_ILK_MODE_SP'
            };
    otherwise
end



% Trigger new data???
if ~any(strcmpi(Port,{'SA','ENV'}))
    % DSC, switching, and AGC should be set somewhere else???
%     
%     % DSC: 0=OFF, 1=UNITY, 2=AUTO, 3=SAVE_LASTGOOD
     setpvonline([BPMName, ':ENV:ENV_DSC_SP'], 0);
%     
%     % Switches: 255=AUTO, 3=DIRECT
     setpvonline([BPMName, ':ENV:ENV_SWITCHES_SP'], 0);
% 
%     % AGC: 0=MANUAL, 1=AUTO
%     setpvonline([BPMName, ':ENV:ENV_AGC_SP'], 1);
%     
    
    % New data
    if TriggerFlag
        if strcmpi(Port, 'ADC')
            % Setup "acquire on trigger" then trigger
            setpvonline([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 0);
            setpvonline([BPMName, ':ADC:ADC_ON_NEXT_TRIG_CMD'], 1);
            pause(.1);
            % Ignore future trigger to reduce load
            %setpvonline([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 1);
        elseif strcmpi(Port, 'PM')
            % Setup "acquire on trigger" then trigger
            setpvonline([BPMName, ':', Port, ':', 'PM_IGNORE_TRIG_SP'], 0);
            setpvonline([BPMName, ':', Port, ':', 'PM_ON_NEXT_TRIG_CMD'], 1);
            setpvonline([BPMName, ':', Port, ':', 'PM_REQUEST_CMD'], 1);
            pause(.1);
            % Ignore future trigger to reduce load
            %setpvonline([BPMName, ':', Port, ':', 'PM_IGNORE_TRIG_SP'], 1);

        elseif strcmpi(Port, 'FA')
            % This should be in the init file
            setpvonline([BPMName, ':', Port, ':', 'FA_LENGTH_SP'], 8192);
            setpvonline([BPMName, ':', Port, ':', 'FA_OFFSET_SP'], 0);
            setpvonline([BPMName, ':', Port, ':', 'FA_MEM_WRITE_CMD'], 1);
            %setpvonline([BPMName, ':', Port, ':', 'FA_MEM_SP'], 0);
            pause(1);

        else
            % DD ports
            
            % Disable the other port acquisitions
            tic
            setpvonline([BPMName, ':DD1:DD_IGNORE_TRIG_SP'], 1,  'double', 0);
            fprintf('Disable DD1 (%f seconds)\n', toc);
            tic
            setpvonline([BPMName, ':DD2:DD_IGNORE_TRIG_SP'], 1,  'double', 0);
            fprintf('Disable DD2 (%f seconds)\n', toc);
            tic
            setpvonline([BPMName, ':DD3:DD_IGNORE_TRIG_SP'], 1,  'double', 0);
            fprintf('Disable DD3 (%f seconds)\n', toc);
            tic
            setpvonline([BPMName, ':DD4:DD_IGNORE_TRIG_SP'], 1,  'double', 0);
            fprintf('Disable DD4 (%f seconds)\n', toc);
            tic
            setpvonline([BPMName, ':ADC:ADC_IGNORE_TRIG_SP'], 1, 'double', 0);
            fprintf('Disable ADC (%f seconds)\n', toc);
            tic
            setpvonline([BPMName, ':PM:PM_IGNORE_TRIG_SP'],   1, 'double', 0);
            fprintf('Disable PM  (%f seconds)\n', toc);
            
            % Setup "acquire on trigger" then trigger
            %tic
            %setpvonline([BPMName, ':', Port, ':', 'DD_IGNORE_TRIG_SP'], 0, 'double', 0);
            %fprintf('Enable %s  (%f seconds)\n', Port, toc);
            %pause(1);
            %tic
            %setpvonline([BPMName, ':', Port, ':', 'DD_REQUEST_CMD'], 1);
            %fprintf('%s:DD_REQUEST_CMD  (%f seconds)\n', Port, toc);
            tic
            setpvonline([BPMName, ':', Port, ':', 'DD_ON_NEXT_TRIG_CMD'], 1, 'double', 0);
            fprintf('%s:DD_ON_NEXT_TRIG_CMD  (%f seconds)\n', Port, toc);
            pause(1.5);

            % Ignore future trigger to reduce load
            %setpvonline([BPMName, ':', Port, ':', 'DD_IGNORE_TRIG_SP'], 1);
        end
    else
            tic
            setpvonline([BPMName, ':', Port, ':', 'DD_REQUEST_CMD'], 1);
            fprintf('%s:DD_REQUEST_CMD  (%f seconds)\n', Port, toc);
    end
end


BPMPrefix = [BPMName, ':', Port, ':'];

for i = 1:size(AMNames,1)
    AM.(AMNames{i}) = getpvonline([BPMPrefix, AMNames{i}]);
end
if nargout >= 2 || nargout == 0
    for i = 1:size(SPNames,1)
        SP.(SPNames{i}) = getpvonline([BPMPrefix, SPNames{i}]);
    end
end


if nargout == 0
    fprintf('\n   %s Monitors\n', Port);
    for i = 1:size(AMNames,1)
        if ischar(AM.(AMNames{i}))
            fprintf('   %02d.  %s  = %s\n', i, [BPMPrefix, AMNames{i}], AM.(AMNames{i}));
        elseif length(AM.(AMNames{i})) == 1
            fprintf('   %02d.  %s  = %f\n', i, [BPMPrefix, AMNames{i}], AM.(AMNames{i}));
        else
            fprintf('   %02d.  %s    (%dx%d)\n', i, [BPMPrefix, AMNames{i}], size(AM.(AMNames{i})));
        end
    end
    if ~isempty(SPNames)
        fprintf('\n   %s Setpoints\n', Port);
        for i = 1:size(SPNames,1)
            if ischar(SP.(SPNames{i}))
                fprintf('   %02d.  %s  = %s\n', i, [BPMPrefix, SPNames{i}], SP.(SPNames{i}));
            elseif length(SP.(SPNames{i})) == 1
                fprintf('   %02d.  %s  = %f\n', i, [BPMPrefix, SPNames{i}], SP.(SPNames{i}));
            else
                fprintf('   %02d.  %s    (%dx%d)\n', i, [BPMPrefix, SPNames{i}], size(SP.(SPNames{i})));
            end
        end
    end
end



% fprintf('\n%s Monitors\n', Port);
% for i = 1:size(AMNames,1)
%     if ischar(AM.(AMNames{i}))
%         fprintf('%s  = %s\n', [BPMPrefix, AMNames{i}], AM.(AMNames{i}));
%     elseif length(AM.(AMNames{i})) == 1
%         fprintf('%s  = %f\n', [BPMPrefix, AMNames{i}], AM.(AMNames{i}));
%     else
%         fprintf('%s    (%dx%d)\n', [BPMPrefix, AMNames{i}], size(AM.(AMNames{i})));
%     end
% end
% if ~isempty(SPNames)
%     fprintf('\n%s Setpoints\n', Port);
%     for i = 1:size(SPNames,1)
%         if ischar(SP.(SPNames{i}))
%             fprintf('%s  = %s\n', [BPMPrefix, SPNames{i}], SP.(SPNames{i}));
%         elseif length(SP.(SPNames{i})) == 1
%             fprintf('%s  = %f\n', [BPMPrefix, SPNames{i}], SP.(SPNames{i}));
%         else
%             fprintf('%s    (%dx%d)\n', [BPMPrefix, SPNames{i}], size(SP.(SPNames{i})));
%         end
%     end
% end

