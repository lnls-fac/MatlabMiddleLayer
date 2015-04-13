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

BPMNewFlag = 1;

if strcmpi(Family,'BPMx')
    if BPMNewFlag
        ChanName = [
            '\\192.168.100.58\Output Library\BPMX01'
            '\\192.168.100.58\Output Library\BPMX02'
            '\\192.168.100.58\Output Library\BPMX03'
            '\\192.168.100.58\Output Library\BPMX04'
            '\\192.168.100.58\Output Library\BPMX05'
            '\\192.168.100.58\Output Library\BPMX06'
            '\\192.168.100.58\Output Library\BPMX07'
            '\\192.168.100.58\Output Library\BPMX08'
            '\\192.168.100.58\Output Library\BPMX09'
            '\\192.168.100.58\Output Library\BPMX10'
            '\\192.168.100.59\Output Library\BPMX01'
            '\\192.168.100.59\Output Library\BPMX02'
            '\\192.168.100.59\Output Library\BPMX03'
           '\\192.168.100.59\Output Library\BPMX04'
            '\\192.168.100.59\Output Library\BPMX05'
            '\\192.168.100.59\Output Library\BPMX06'
            '\\192.168.100.59\Output Library\BPMX07'
            '\\192.168.100.59\Output Library\BPMX08'
            '\\192.168.100.59\Output Library\BPMX09'
            '\\192.168.100.59\Output Library\BPMX10'];
    else
        ChanName = [
            '[BPM-DCS]S_ESM1.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM2.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM3.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM4.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM5.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM6.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM7.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM8.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM9.XPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM10.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM11.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM12.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM13.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM14.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM15.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM16.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM17.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM18.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM19.XPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM20.XPosCal.MonitoredValue'];
            
            %'[BPM-DCS]S_ESM1.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM2.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM3.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM4.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM5.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM6.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM7.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM8.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM9.XY_XPosCal.MonitoredValue '
            %'[BPM-DCS]S_ESM10.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM11.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM12.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM13.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM14.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM15.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM16.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM17.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM18.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM19.XY_XPosCal.MonitoredValue'
            %'[BPM-DCS]S_ESM20.XY_XPosCal.MonitoredValue'];
    end

elseif strcmpi(Family,'BPMy')
    if BPMNewFlag
        ChanName = [
            '\\192.168.100.58\Output Library\BPMY01'
            '\\192.168.100.58\Output Library\BPMY02'
            '\\192.168.100.58\Output Library\BPMY03'
            '\\192.168.100.58\Output Library\BPMY04'
            '\\192.168.100.58\Output Library\BPMY05'
            '\\192.168.100.58\Output Library\BPMY06'
            '\\192.168.100.58\Output Library\BPMY07'
            '\\192.168.100.58\Output Library\BPMY08'
            '\\192.168.100.58\Output Library\BPMY09'
            '\\192.168.100.58\Output Library\BPMY10'
            '\\192.168.100.59\Output Library\BPMY01'
            '\\192.168.100.59\Output Library\BPMY02'
            '\\192.168.100.59\Output Library\BPMY03'
            '\\192.168.100.59\Output Library\BPMY04'
            '\\192.168.100.59\Output Library\BPMY05'
            '\\192.168.100.59\Output Library\BPMY06'
            '\\192.168.100.59\Output Library\BPMY07'
            '\\192.168.100.59\Output Library\BPMY08'
            '\\192.168.100.59\Output Library\BPMY09'
            '\\192.168.100.59\Output Library\BPMY10'];
    else
        ChanName = [
            '[BPM-DCS]S_ESM1.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM2.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM3.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM4.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM5.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM6.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM7.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM8.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM9.XY_YPosCal.MonitoredValue '
            '[BPM-DCS]S_ESM10.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM11.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM12.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM13.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM14.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM15.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM16.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM17.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM18.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM19.XY_YPosCal.MonitoredValue'
            '[BPM-DCS]S_ESM20.XY_YPosCal.MonitoredValue'];
    end

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_STH_M1.MonitoredValue '
        '[STR-DCS2]S_STH_M2.MonitoredValue '
        '[STR-DCS2]S_STH_M3.MonitoredValue '
        '[STR-DCS2]S_STH_M4.MonitoredValue '
        '[STR-DCS2]S_STH_M5.MonitoredValue '
        '[STR-DCS2]S_STH_M6.MonitoredValue '
        '[STR-DCS2]S_STH_M7.MonitoredValue '
        '[STR-DCS2]S_STH_M8.MonitoredValue '
        '[STR-DCS2]S_STH_M9.MonitoredValue '
        '[STR-DCS2]S_STH_M10.MonitoredValue'
        '[STR-DCS2]S_STH_M11.MonitoredValue'
        '[STR-DCS2]S_STH_M12.MonitoredValue'
        '[STR-DCS2]S_STH_M13.MonitoredValue'
        '[STR-DCS2]S_STH_M14.MonitoredValue'
        '[STR-DCS2]S_STH_M15.MonitoredValue'
        '[STR-DCS2]S_STH_M16.MonitoredValue'];

elseif strcmpi(Family,'HCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_STH_M1.SetupValue '
        '[STR-DCS2]S_STH_M2.SetupValue '
        '[STR-DCS2]S_STH_M3.SetupValue '
        '[STR-DCS2]S_STH_M4.SetupValue '
        '[STR-DCS2]S_STH_M5.SetupValue '
        '[STR-DCS2]S_STH_M6.SetupValue '
        '[STR-DCS2]S_STH_M7.SetupValue '
        '[STR-DCS2]S_STH_M8.SetupValue '
        '[STR-DCS2]S_STH_M9.SetupValue '
        '[STR-DCS2]S_STH_M10.SetupValue'
        '[STR-DCS2]S_STH_M11.SetupValue'
        '[STR-DCS2]S_STH_M12.SetupValue'
        '[STR-DCS2]S_STH_M13.SetupValue'
        '[STR-DCS2]S_STH_M14.SetupValue'
        '[STR-DCS2]S_STH_M15.SetupValue'
        '[STR-DCS2]S_STH_M16.SetupValue'];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS2]S_STV_M1.MonitoredValue '
        '[STR-DCS2]S_STV_M2.MonitoredValue '
        '[STR-DCS2]S_STV_M3.MonitoredValue '
        '[STR-DCS2]S_STV_M4.MonitoredValue '
        '[STR-DCS2]S_STV_M5.MonitoredValue '
        '[STR-DCS2]S_STV_M6.MonitoredValue '
        '[STR-DCS2]S_STV_M7.MonitoredValue '
        '[STR-DCS2]S_STV_M8.MonitoredValue '
        '[STR-DCS2]S_STV_M9.MonitoredValue '
        '[STR-DCS2]S_STV_M10.MonitoredValue'
        '[STR-DCS2]S_STV_M11.MonitoredValue'
        '[STR-DCS2]S_STV_M12.MonitoredValue'];

elseif strcmpi(Family,'VCM') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS2]S_STV_M1.SetupValue '
        '[STR-DCS2]S_STV_M2.SetupValue '
        '[STR-DCS2]S_STV_M3.SetupValue '
        '[STR-DCS2]S_STV_M4.SetupValue '
        '[STR-DCS2]S_STV_M5.SetupValue '
        '[STR-DCS2]S_STV_M6.SetupValue '
        '[STR-DCS2]S_STV_M7.SetupValue '
        '[STR-DCS2]S_STV_M8.SetupValue '
        '[STR-DCS2]S_STV_M9.SetupValue '
        '[STR-DCS2]S_STV_M10.SetupValue'
        '[STR-DCS2]S_STV_M11.SetupValue'
        '[STR-DCS2]S_STV_M12.SetupValue'];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        '[STR-DCS]S_QF_M1.MonitoredValue'
        ];

elseif strcmpi(Family,'QF') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        '[STR-DCS]S_QF_M1.SetUpValue'
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        '[STR-DCS]S_QD_M2.MonitoredValue'
        ];

elseif strcmpi(Family,'QD') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        '[STR-DCS]S_QD_M2.SetUpValue'
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        '[STR-DCS]S_QF_M3.MonitoredValue'
        ];

elseif strcmpi(Family,'QFA') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        '[STR-DCS]S_QF_M3.SetUpValue'
        ];

elseif strcmpi(Family,'QDA') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_QD_M4.MonitoredValue'
        '[STR-DCS]S_QD_M4.MonitoredValue'
        '[STR-DCS]S_QD_M4.MonitoredValue'
        '[STR-DCS]S_QD_M4.MonitoredValue'
        ];

elseif strcmpi(Family,'QDA') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_QD_M4.SetUpValue'
        '[STR-DCS]S_QD_M4.SetUpValue'
        '[STR-DCS]S_QD_M4.SetUpValue'
        '[STR-DCS]S_QD_M4.SetUpValue'
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        '[STR-DCS]S_SXF_M.MonitoredValue'
        ];

elseif strcmpi(Family,'SF') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        '[STR-DCS]S_SXF_M.SetupValue'
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        '[STR-DCS]S_SXD_M.MonitoredValue'
        ];

elseif strcmpi(Family,'SD') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        '[STR-DCS]S_SXD_M.SetupValue'
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Monitor')
    ChanName = [
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        '[STR-DCS]S_BM_M.MonitoredValue'
        ];

elseif strcmpi(Family,'BEND') && strcmpi(Field,'Setpoint')
    ChanName = [
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        '[STR-DCS]S_BM_M.SetupValue'
        ];

elseif strcmpi(Family,'RF') && strcmpi(Field,'Monitor')
    ChanName = '[GIS-DCS]RFOSC.MonitoredValue';

elseif strcmpi(Family,'RF') && strcmpi(Field,'Setpoint')
    ChanName = '[GIS-DCS]RFOSC.SetupValue';

elseif strcmpi(Family,'DCCT') && strcmpi(Field,'Monitor')
    ChanName = '[CNT-DCS]Beam_Current';

else
    ChanName = strvcat(ChanName, ' ');
end
