function ChanName = getname_sps(Family, Field, DeviceList)
%GETNAME_SPS - Return the channel names for a family
%  ChanName = getname_sps(Family, Field, DeviceList)


ChanName = '';

if nargin < 1
    error('Family name input needed.');
end
if nargin < 2
    Field = '';
end
if isempty(Field)
    Field = 'Monitor';
end


if strcmpi(Family,'BPMx')
    ChanName = [
        ];

elseif strcmpi(Family,'BPMy')
    ChanName = [
        ];

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Monitor')
    ChanName = [
       ];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];
    
elseif strcmpi(Family,'QDA') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'QDA') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Setpoint')
    ChanName = [ 
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Monitor')
    ChanName = [
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Setpoint')
    ChanName = [
        ];

elseif strcmpi(Family,'RF') && strcmpi(Field,'Monitor')
    ChanName = '';

elseif strcmpi(Family,'RF') && strcmpi(Field,'Setpoint')
    ChanName = '';

elseif strcmpi(Family,'DCCT') && strcmpi(Field,'Monitor')
    ChanName = '';

else
    ChanName = strvcat(ChanName, ' ');
end

