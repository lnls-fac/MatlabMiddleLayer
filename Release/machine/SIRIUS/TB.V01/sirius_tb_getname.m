function  [ChannelName, ErrorFlag] = sirius_tb_getname(Family, Field, DeviceList)
% ChannelName = getname_tb_sirius(Family, Field, DeviceList)
%
%   INPUTS
%   1. Family name
%   2. Field
%   3. DeviceList ([Sector Device #] or [element #])
%
%   OUTPUTS
%   1. ChannelName = IOC channel name corresponding to the family and DeviceList


if nargin == 0
    error('Must have at least one input (''Family'')!');
end
if nargin < 2
    Field = 'Monitor';
end
if nargin < 3
    DeviceList = [];
end

ChannelName = [];

switch lower(Family)
    
    case {'bpmx', 'bpmy'}
        if (strcmpi(Field, 'Monitor') || strcmpi(Field, 'CommonNames'))
            ChannelName = [
                'TBDI-BPM-02-A'; 'TBDI-BPM-02-B';  'TBDI-BPM-03-A'; 
                'TBDI-BPM-03-B'; 'TBDI-BPM-04  '; 'TBDI-BPM-05  ']; 
    
            if strcmpi(Family, 'bpmx')
                ChannelName = strcat(ChannelName, '-X');
            else
                ChannelName = strcat(ChannelName, '-Y');                
            end
        else
            error('Don''t know how to make the channel name for family %s', Family);
        end
    
    case 'spec'
        ChannelName = 'TBPS-BEND-01';
        
    case 'bn'
        ChannelName = 'TBPS-BEND-02';
        
    case 'bp'
        ChannelName = ['TBPS-BEND-03'; 'TBPS-BEND-04'];
        
    case 'septin'
        ChannelName = 'TBPU-SEPIN-05';
        
    case 'q1a'
        ChannelName = ['TBPS-Q1A-01-A'; 'TBPS-Q1A-01-B'];
        
    case 'q1b'
        ChannelName = 'TBPS-Q1B-01';
        
    case 'q1c'
        ChannelName = 'TBPS-Q1C-01';    
    
    case 'qd2'
        ChannelName = 'TBPS-QD-02';
    
    case 'qf2'
        ChannelName = 'TBPS-QF-02';
        
    case 'qd3a'
        ChannelName = 'TBPS-QD-03-A';
        
    case 'qf3a'
        ChannelName = 'TBPS-QF-03-A';
        
    case 'qf3b'
        ChannelName = 'TBPS-QF-03-B';
        
    case 'qd3b'
        ChannelName = 'TBPS-QD-03-B';
        
    case 'qf4'
        ChannelName = 'TBPS-QF-04';
        
    case 'qd4'
        ChannelName = 'TBPS-QD-04';  
        
    case 'qf5'
        ChannelName = 'TBPS-QF-05';   
        
    case 'qd5'
        ChannelName = 'TBPS-QD-05';  
        
    case {'hcm', 'ch'}
        ChannelName = [
            'TBPS-CH-02-A'; 'TBPS-CH-02-B';  
            'TBPS-CH-03-A'; 'TBPS-CH-03-B'; 'TBPS-CH-04  '];
        
    case {'vcm', 'cv'}
        ChannelName = [
            'TBPS-CV-02-A'; 'TBPS-CV-02-B'; 'TBPS-CV-03-A'; 
            'TBPS-CV-03-B'; 'TBPS-CV-05-A'; 'TBPS-CV-05-B'];
            
    otherwise
        error('Don''t know how to make the channel name for family %s', Family);
        
end
    
if any(strcmpi(Family, {'bpmx', 'bpmy'}))
    
else
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(ChannelName, '-RB');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(ChannelName, '-SP');
    end
end


end


