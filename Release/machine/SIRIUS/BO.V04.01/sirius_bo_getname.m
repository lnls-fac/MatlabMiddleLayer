function  [ChannelName, ErrorFlag] = sirius_bo_getname(Family, Field, DeviceList)
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

prefix = getenv('VACA_PREFIX');

switch Family

    case {'BPMx', 'BPMy'}
        if (strcmpi(Field, 'Monitor') || strcmpi(Field, 'CommonNames'))
            ChannelName = [
                'BO-01U:DI-BPM'; 'BO-02U:DI-BPM'; 'BO-03U:DI-BPM'; 'BO-04U:DI-BPM' ;...
                'BO-05U:DI-BPM'; 'BO-06U:DI-BPM'; 'BO-07U:DI-BPM'; 'BO-08U:DI-BPM' ;...
                'BO-09U:DI-BPM'; 'BO-10U:DI-BPM'; 'BO-11U:DI-BPM'; 'BO-12U:DI-BPM' ;...
                'BO-13U:DI-BPM'; 'BO-14U:DI-BPM'; 'BO-15U:DI-BPM'; 'BO-16U:DI-BPM' ;...
                'BO-17U:DI-BPM'; 'BO-18U:DI-BPM'; 'BO-19U:DI-BPM'; 'BO-20U:DI-BPM' ;...
                'BO-21U:DI-BPM'; 'BO-22U:DI-BPM'; 'BO-23U:DI-BPM'; 'BO-24U:DI-BPM' ;...
                'BO-25U:DI-BPM'; 'BO-26U:DI-BPM'; 'BO-27U:DI-BPM'; 'BO-28U:DI-BPM' ;...
                'BO-29U:DI-BPM'; 'BO-30U:DI-BPM'; 'BO-31U:DI-BPM'; 'BO-32U:DI-BPM' ;...
                'BO-33U:DI-BPM'; 'BO-34U:DI-BPM'; 'BO-35U:DI-BPM'; 'BO-36U:DI-BPM' ;...
                'BO-37U:DI-BPM'; 'BO-38U:DI-BPM'; 'BO-39U:DI-BPM'; 'BO-40U:DI-BPM' ;...
                'BO-41U:DI-BPM'; 'BO-42U:DI-BPM'; 'BO-43U:DI-BPM'; 'BO-44U:DI-BPM' ;...
                'BO-45U:DI-BPM'; 'BO-46U:DI-BPM'; 'BO-47U:DI-BPM'; 'BO-48U:DI-BPM' ;...
                'BO-49U:DI-BPM'; 'BO-50U:DI-BPM'; ];
            if strcmpi(Family, 'BPMx')
                ChannelName = strcat(ChannelName, ':PosX-Mon');
            else
                ChannelName = strcat(ChannelName, ':PosY-Mon');
            end
        else
            error('Don''t know how to make the channel name for family %s', Family);
        end

    case 'B'
        ChannelName = repmat('BO-Fam:MA-B', size(DeviceList,1), 1);

	case 'QD'
		ChannelName = repmat('BO-Fam:MA-QD', size(DeviceList,1), 1);

	case 'QF'
		ChannelName = repmat('BO-Fam:MA-QF', size(DeviceList,1), 1);

    case 'QS'
		ChannelName = 'BO-02D:MA-QS';

	case 'SD'
		ChannelName = repmat('BO-Fam:MA-SD', size(DeviceList,1), 1);

	case 'SF'
		ChannelName = repmat('BO-Fam:MA-SF', size(DeviceList,1), 1);

	case 'CV'
		ChannelName = [
			'BO-01U:MA-CV'; 'BO-03U:MA-CV'; 'BO-05U:MA-CV'; 'BO-07U:MA-CV'; ...
			'BO-09U:MA-CV'; 'BO-11U:MA-CV'; 'BO-13U:MA-CV'; 'BO-15U:MA-CV'; ...
			'BO-17U:MA-CV'; 'BO-19U:MA-CV'; 'BO-21U:MA-CV'; 'BO-23U:MA-CV'; ...
			'BO-25U:MA-CV'; 'BO-27U:MA-CV'; 'BO-29U:MA-CV'; 'BO-31U:MA-CV'; ...
			'BO-33U:MA-CV'; 'BO-35U:MA-CV'; 'BO-37U:MA-CV'; 'BO-39U:MA-CV'; ...
			'BO-41U:MA-CV'; 'BO-43U:MA-CV'; 'BO-45U:MA-CV'; 'BO-47U:MA-CV'; ...
			'BO-49U:MA-CV' ];

	case 'CH'
		ChannelName = [
			'BO-01U:MA-CH'; 'BO-03U:MA-CH'; 'BO-05U:MA-CH'; 'BO-07U:MA-CH'; ...
			'BO-09U:MA-CH'; 'BO-11U:MA-CH'; 'BO-13U:MA-CH'; 'BO-15U:MA-CH'; ...
			'BO-17U:MA-CH'; 'BO-19U:MA-CH'; 'BO-21U:MA-CH'; 'BO-23U:MA-CH'; ...
			'BO-25U:MA-CH'; 'BO-27U:MA-CH'; 'BO-29U:MA-CH'; 'BO-31U:MA-CH'; ...
			'BO-33U:MA-CH'; 'BO-35U:MA-CH'; 'BO-37U:MA-CH'; 'BO-39U:MA-CH'; ...
			'BO-41U:MA-CH'; 'BO-43U:MA-CH'; 'BO-45U:MA-CH'; 'BO-47U:MA-CH'; ...
			'BO-49D:MA-CH' ];

    case 'RF'
        ChannelName = 'AS-Glob:RF-Gen';

    case 'DCCT'
        ChannelName = 'BO-35D:DI-DCCT:Current-Mon';

    case 'TUNE'
        ChannelName = ['BO-04D:DI-TunePkup:TuneX-Mon';
                       'BO-04D:DI-TunePkup:TuneY-Mon' ];

    otherwise
        error('Don''t know how to make the channel name for family %s', Family);

end

if any(strcmpi(Family, {'BPMx', 'BPMy', 'DCCT', 'TUNE'}))
    ChannelName = strcat(prefix, ChannelName);
elseif strcmpi(Family, 'RF')
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(prefix, ChannelName, ':Frequency-Mon');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(prefix, ChannelName, ':Frequency-SP');
    elseif strcmpi(Field, 'VoltageMonitor')
        ChannelName = strcat(prefix, ChannelName, ':Voltage-Mon');
    elseif strcmpi(Field, 'VoltageSetpoint')
        ChannelName = strcat(prefix, ChannelName, ':Voltage-SP');
    end

else %Bends, Quads, Sexts and Correctors
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(prefix, ChannelName, ':Current-Mon');
    elseif strcmpi(Field, 'Readback')
        ChannelName = strcat(prefix, ChannelName, ':Current-RB');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(prefix, ChannelName, ':Current-SP');
    elseif strcmpi(Field, 'ReferenceMonitor')
        ChannelName = strcat(prefix, ChannelName, ':CurrentRef-Mon');
    end
end

end
