function  [ChannelName, ErrorFlag] = lnls1_getname(Family, Field, DeviceList)
%LNLS1_GETNAME - Returns channelnames for machine families.
%
% ChannelName = lnls1_getname(Family, Field, DeviceList)
%
%   INPUTS
%   1. Family name
%   2. Field
%   3. DeviceList ([Sector Device #] or [element #]) (default: whole family)
%
%   OUTPUTS
%   1. ChannelName = IOC channel name corresponding to the family and DeviceList
%
%Hist�ria
%
%2010-09-13: c�digo fonte com coment�rios iniciais.


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
            ChannelName = ['AMP01B'; ...
                'AMP02A'; 'AMP02B'; 'AMP03A'; 'AMP03C'; 'AMP03B'; ...
                'AMP04A'; 'AMP04B'; 'AMP05A'; 'AMP05B'; ...
                'AMP06A'; 'AMP06B'; 'AMP07A'; 'AMP07B'; ...
                'AMP08A'; 'AMP08B'; 'AMP09A'; 'AMP09B'; ...
                'AMP10A'; 'AMP10B'; 'AMU11A'; ...
                'AMU11B'; 'AMP12A'; 'AMP12B'; ...
                'AMP01A'
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
            'ACH01B'; ...
            'ACH02 ';  'ACH03A'; 'ACH03B'; 'ACH04 ';  'ACH05A'; 'ACH05B'; ...
            'ACH06 ';  'ACH07A'; 'ACH07B'; 'ACH08 ';  'ACH09A'; 'ACH09B'; ...
            'ACH10 ';  'ACH11A'; 'ACH11B'; 'ACH12 '; ...
            'ACH01A'];
    case 'VCM'
        ChannelName = [
            'ACV01B'; ...
            'ALV02A'; 'ALV02B'; 'ACV03A'; 'ACV03B'; ...
            'ALV04A'; 'ALV04B'; 'ACV05A'; 'ACV05B'; ...
            'ALV06A'; 'ALV06B'; 'ACV07A'; 'ACV07B'; ...
            'ALV08A'; 'ALV08B'; 'ACV09A'; 'ACV09B'; ...
            'ALV10A'; 'ALV10B'; 'ACV11A'; 'ACV11B'; ...
            'ALV12A'; 'ALV12B'; ...
            'ACV01A'];
        
    case 'ALV'
        ChannelName = [
            'ALV02A'; 'ALV02B'; ...
            'ALV04A'; 'ALV04B'; ...
            'ALV06A'; 'ALV06B'; ...
            'ALV08A'; 'ALV08B'; ...
            'ALV10A'; 'ALV10B'; ...
            'ALV12A'; 'ALV12B'; ...
            ];
        
    case 'ACV'
        ChannelName = [
            'ACV01B'; ...
            'ACV03A'; 'ACV03B'; ...
            'ACV05A'; 'ACV05B'; ...
            'ACV07A'; 'ACV07B'; ...
            'ACV09A'; 'ACV09B'; ...
            'ACV11A'; 'ACV11B'; ...
            'ACV01A'];
        
        
    case 'QF'
        ChannelName = [ ...
            'A2QF01'; ...
            'A2QF03'; 'A2QF03'; 'A2QF05'; 'A2QF05'; ...
            'A2QF07'; 'A2QF07'; 'A2QF09'; 'A2QF09'; ...
            'A2QF11'; 'A2QF11'; ...
            'A2QF01';];
        
    case 'QD'
        ChannelName = [ ...
            'A2QD01'; ...
            'A2QD03'; 'A2QD03'; 'A2QD05'; 'A2QD05'; ...
            'A2QD07'; 'A2QD07'; 'A2QD09'; 'A2QD09'; ...
            'A2QD11'; 'A2QD11'; ...
            'A2QD01';];
        
    case 'QFC'
        ChannelName = [ ...
            'A6QF01'; 'A6QF02'; ...
            'A6QF02'; 'A6QF01'; ...
            'A6QF01'; 'A6QF02'; ...
            'A6QF02'; 'A6QF01'; ...
            'A6QF01'; 'A6QF02'; ...
            'A6QF02'; 'A6QF01'; ...
            ];
        
    case 'SF'
        ChannelName = [ 'A6SF'; 'A6SF'; 'A6SF'; 'A6SF'; 'A6SF'; 'A6SF'; ];
        
    case 'SD'
        ChannelName = [ ...
            'A6SD01'; 'A6SD02'; ...
            'A6SD02'; 'A6SD01'; ...
            'A6SD01'; 'A6SD02'; ...
            'A6SD02'; 'A6SD01'; ...
            'A6SD01'; 'A6SD02'; ...
            'A6SD02'; 'A6SD01'; ...
            ];
        
    case 'A2QF01'
        ChannelName = ['A2QF01'; 'A2QF01';];
    case 'A2QF03'
        ChannelName = ['A2QF03'; 'A2QF03';];
    case 'A2QF05'
        ChannelName = ['A2QF05'; 'A2QF05';];
    case 'A2QF07'
        ChannelName = ['A2QF07'; 'A2QF07';];
    case 'A2QF09'
        ChannelName = ['A2QF09'; 'A2QF09';];
    case 'A2QF11'
        ChannelName = ['A2QF11'; 'A2QF11';];
        
        
        
    case 'A2QD01'
        ChannelName = ['A2QD01'; 'A2QD01';];
    case 'A2QD03'
        ChannelName = ['A2QD03'; 'A2QD03';];
    case 'A2QD05'
        ChannelName = ['A2QD05'; 'A2QD05';];
    case 'A2QD07'
        ChannelName = ['A2QD07'; 'A2QD07';];
    case 'A2QD09'
        ChannelName = ['A2QD09'; 'A2QD09';];
    case 'A2QD11'
        ChannelName = ['A2QD11'; 'A2QD11';];
        
    case 'A6QF01'
        ChannelName = ['A6QF01'; 'A6QF01'; 'A6QF01'; 'A6QF01'; 'A6QF01'; 'A6QF01'; ];
    case 'A6QF02'
        ChannelName = ['A6QF02'; 'A6QF02'; 'A6QF02'; 'A6QF02'; 'A6QF02'; 'A6QF02'; ];
        
        
    case 'QUADSHUNT'
        ChannelName = [
            'AQF01B'; 'AQD01B'; 'AQF02A'; 'AQF02B'; 'AQD03A'; 'AQF03A'; ...
            'AQF03B'; 'AQD03B'; 'AQF04A'; 'AQF04B'; 'AQD05A'; 'AQF05A'; ...
            'AQF05B'; 'AQD05B'; 'AQF06A'; 'AQF06B'; 'AQD07A'; 'AQF07A'; ...
            'AQF07B'; 'AQD07B'; 'AQF08A'; 'AQF08B'; 'AQD09A'; 'AQF09A'; ...
            'AQF09B'; 'AQD09B'; 'AQF10A'; 'AQF10B'; 'AQD11A'; 'AQF11A'; ...
            'AQF11B'; 'AQD11B'; 'AQF12A'; 'AQF12B'; 'AQD01A'; 'AQF01A'; ...
            ];
          
    case 'A6SF'
        ChannelName = ['A6SF';'A6SF';'A6SF';'A6SF';'A6SF';'A6SF'];
    case 'A6SD01'
        ChannelName = ['A6SD01';'A6SD01';'A6SD01';'A6SD01';'A6SD01';'A6SD01'];
    case 'A6SD02'
        ChannelName = ['A6SD02';'A6SD02';'A6SD02';'A6SD02';'A6SD02';'A6SD02'];
        
    case 'A2QS05'
        ChannelName = ['A2QS05';'A2QS05';];
        
    case 'SKEWCORR'
        ChannelName = ['AQS09';'AQS11';'AQS01';];
        
    case 'KICKER'
        ChannelName = ['AKC02'; 'AKC03'; 'AKC04'];
        
    case 'BEND'
        ChannelName = ['A12DI'; 'A12DI'; 'A12DI';'A12DI'; 'A12DI'; 'A12DI';'A12DI'; 'A12DI'; 'A12DI';'A12DI'; 'A12DI'; 'A12DI'];
    case 'TUNE'
        ChannelName = ['ASINT_H'; 'ASINT_V'; 'ASINT_S'];
    case 'RF'
        ChannelName = ['GRFF02'];
        
    case 'FOFB'
        switch Field
            case 'Setpoint'
                ChannelName = ['AFOFB_MODO_SP';];
            case 'Monitor'
                ChannelName = ['AFOFB_MODO_AM';];
            case 'ExcitationFlag'
                ChannelName = ['AFOFB_CR_ON';];
            case 'HorizontalGainSP'
                ChannelName = ['AFOFB_GH_SP';];
            case 'HorizontalGainAM'
                ChannelName = ['AFOFB_GH_AM';];
            case 'VerticalGainSP'
                ChannelName = ['AFOFB_GV_SP';];
            case 'VerticalGainAM'
                ChannelName = ['AFOFB_GV_AM';];
            case 'ReferenceOrbitSP'
                ChannelName = ['AFOFB_OR_SP';];
            case 'ReferenceOrbitAM'
                ChannelName = ['AFOFB_OR_AM';];
            case 'CorrectionMatrixSP'
                ChannelName = ['AFOFB_MC_SP';];
            case 'CorrectionMatrixAM'
                ChannelName = ['AFOFB_MC_AM';];
            case 'HorizontalOrbiThresholdSP'
                ChannelName = ['AFOFB_LH_SP';];
            case 'HorizontalOrbiThresholdAM'
                ChannelName = ['AFOFB_LH_AM';];
            case 'VerticalOrbiThresholdSP'
                ChannelName = ['AFOFB_LV_SP';];
            case 'VerticalOrbiThresholdAM'
                ChannelName = ['AFOFB_LV_AM';];
        end
        
    case 'ID'
        ChannelName = ['AWG01GAP'; 'AON11GAP';];
    case 'AWG01'
        ChannelName = ['AWG01GAP';];
    case 'AWG09'
        ChannelName = ['AWG09FIELD';];
    case 'AON11'
        switch Field
            case 'Setpoint'
                ChannelName = ['AON11GAP_SP';];
            case 'Monitor'
                ChannelName = ['AON11GAP_AM';];
            case 'GapSpeedAM'
                ChannelName = ['AON11VGAP_AM';];
            case 'GapSpeedSP'
                ChannelName = ['AON11VGAP_SP';];
            case 'PhaseSpeedAM'
                ChannelName = ['AON11VFASE_AM';];
            case 'PhaseSpeedSP'
                ChannelName = ['AON11VFASE_SP';];
            case 'PhaseAM'
                ChannelName = ['AON11FASE_AM';];
            case 'PhaseSP'
                ChannelName = ['AON11FASE_SP';];
        end
end

if any(strcmpi(Family, {'ID', 'HCM', 'VCM', 'ACV', 'ALV', 'QUADSHUNT', 'SKEWCORR', 'KICKER', 'A2QF01', 'A2QF03', 'A2QF05', 'A2QF07', 'A2QF09', 'A2QF11', 'QF', 'QD', 'QFC', 'A2QD01', 'A2QD03', 'A2QD05', 'A2QD07', 'A2QD09', 'A2QD11', 'A6QF01', 'A6QF02', 'A2QS05', 'SF', 'SD', 'A6SF', 'A6SD01', 'A6SD02', 'BEND','RF','AWG01','AWG09'}))
    if strcmpi(Field, 'Monitor')
        ChannelName = strcat(ChannelName, '_AM');
    elseif strcmpi(Field, 'Setpoint')
        ChannelName = strcat(ChannelName, '_SP');
    elseif strcmpi(Field, 'ON');
        ChannelName = strcat(ChannelName, '_ON');
    elseif strcmpi(Field, 'CommonNames');
        ChannelName = strcat(ChannelName, '');
    elseif strcmpi(Field, 'OperationMode');
        ChannelName = strcat(ChannelName, '_OP');
    else
        error('Don''t know how to make the channel name for family %s', Family);
    end
end


