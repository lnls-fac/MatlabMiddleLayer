function  [ChannelName, ErrorFlag] = lnls1_getname(Family, Field, DeviceList)
% ChannelName = lnls1_getname(Family, Field, DeviceList)
%
%   INPUTS
%   1. Family name
%   2. Field
%   3. DeviceList ([Sector Device #] or [element #]) (default: whole family)
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

%
%if isempty(DeviceList)
%   DeviceList = getlist(Family);
%elseif (size(DeviceList,2) == 1)
%   DeviceList = elem2dev(Family, DeviceList);
%end

ChannelName = [];

switch Family
    
    case {'BPMx','BPMy'}
        if (strcmpi(Field, 'Monitor'))
            ChannelName = [ ...
                'SMP01'; 'SMP02'; 'SMP03'; 'SMP04'; 'SMP05'; 'SMP06'; ...
                'SMP07'; 'SMP08'; 'SMP09'; 'SMP10'; 'SMP11'; 'SMP12'; ...
                ];
            ao = getao;
            if ~isempty(ao)
                selection = dev2elem(Family, DeviceList);
                ChannelName = ChannelName(selection,:);
            end
            if strcmpi(Family, 'BPMx')
                ChannelName = strcat(ChannelName, '_H');
            else
                ChannelName = strcat(ChannelName, '_V');                
            end
        else
            error('Don''t know how to make the channel name for family %s', Family);
        end
    case 'HCM'
        ChannelName = [
            'SCH02'; 'SCH04'; 'SCH05'; 'SCH06'; ...
            'SCH07'; 'SCH08'; 'SCH09'; 'SCH10'; 'SCH12'; 'SCH01'; ...
            ];
    case 'VCM'
        ChannelName = [
            'SCV01'; 'SCV03'; 'SCV05'; ...
            'SCV07'; 'SCV09'; 'SCV11'; ...
            ];
                                                                                 
    case 'S2QD01'
        ChannelName = ['S2QD01'; 'S2QD01';];
    case 'S2QD07'
        ChannelName = ['S2QD07'; 'S2QD07';];
    case 'S2QF01'
        ChannelName = ['S2QF01'; 'S2QF01';];
    case 'S2QF03'
        ChannelName = ['S2QF03'; 'S2QF03';];
    case 'S2QF04'
        ChannelName = ['S2QF04'; 'S2QF04';];
    case 'S2QF07'
        ChannelName = ['S2QF07'; 'S2QF07';];
    case 'S2QF08'
        ChannelName = ['S2QF08'; 'S2QF08';];
    case 'S2QF09'
        ChannelName = ['S2QF09'; 'S2QF09';];
        
     
  
    case 'S4SF'
        ChannelName = ['S4SF';'S4SF';'S4SF';'S4SF';];
    case 'S4SD'
        ChannelName = ['S4SD';'S4SD';'S4SD';'S4SD';];
        
    case 'SKEWQUAD'
        ChannelName = ['S2QS07'; 'S2QS07';];
        
    case 'KICKER'
        ChannelName = ['SKC02'; 'SKC12';];
   
    case 'BEND'
        ChannelName = ['S12DI'; 'S12DI'; 'S12DI';'S12DI'; 'S12DI'; 'S12DI';'S12DI'; 'S12DI'; 'S12DI';'S12DI'; 'S12DI'; 'S12DI'];
    case 'TUNE'
        ChannelName = ['SSINT_H'; 'SSINT_V'; 'SSINT_S'];
    case 'RF'
        ChannelName = ['GRFF02_FREQ'];           
        
end

if any(strcmpi(Family, {'HCM', 'VCM', 'KICKER', 'S2QD01', 'S2QD07', 'S2QF01', 'S2QF03', 'S2QF04', 'S2QF07', 'S2QF08', 'S2QF09', 'S4SF', 'S4SD', 'SKEWQUAD', 'BEND','RF'}))
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(ChannelName, '_AM');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(ChannelName, '_SP');
    elseif strcmpi(Field, 'ON');
        ChannelName = strcat(ChannelName, '_ON');
    elseif strcmpi(Field, 'CommonNames');
        ChannelName = strcat(ChannelName, '');
    else
        error('Don''t know how to make the channel name for family %s', Family);
    end
end


