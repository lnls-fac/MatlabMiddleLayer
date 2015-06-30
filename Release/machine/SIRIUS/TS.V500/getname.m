function  [ChannelName, ErrorFlag] = sirius3_getname(Family, Field, DeviceList)
% ChannelName = getname_sirius(Family, Field, DeviceList)
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
    
    case 'bend'
        ChannelName = [ ...
            'bend';'bend'; ...
         ];
    case 'qa1'
        ChannelName = 'qa1';
    case 'qa2'
        ChannelName = 'qa2';
    case 'qb1'
        ChannelName = 'qb1';
    case 'qb2'
        ChannelName = 'qb2';
    case 'qc1'
        ChannelName = 'qc1';
    case 'qc2'
        ChannelName = 'qc2';
    case 'qd1'
        ChannelName = 'qd1';
    case 'qd2'
        ChannelName = 'qd2';
    case 'qd3'
        ChannelName = 'qd3';
     
end
    

if any(strcmpi(Family, {'HCM', 'VCM', 'QF', 'QF_Shunts', 'QF_Families', 'QFC', 'QFC_Shunts', 'QFC_Families', 'QD', 'QD_Shunts', 'QD_Families', 'SKEWQUAD', 'SF', 'SD', 'BEND','RF'}))
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(ChannelName, '_AM');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(ChannelName, '_SP');
    elseif strcmpi(Field, 'CommonNames')
    else
        error('Don''t know how to make the channel name for family %s', Family);
    end
end


