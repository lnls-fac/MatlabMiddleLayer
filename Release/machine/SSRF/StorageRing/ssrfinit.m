function ssrfinit(OperationalMode)
%SSRFINIT - Initialization function for SSRF
%
%  See also setoperationalmode, updateatindex, setpathssrf


% To do:
% 1. Set .DeltaRespMat, .Tolerance, .Range
% 2. Most recent AT model?
% 3. BPM & magnet positions in AT model?
% 4. Channelnames - getname_ssrf
% 5. k2amp / amp2k conversions
% 6. Add the skew quadrupole families


if nargin < 1
    OperationalMode = 1;  % High tune
end


%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%

setao([]);   %clear previous AcceleratorObjects

% Build common devicelist
BPMlist=[];
HCMlist=[];
VCMlist=[];
OnePerSectorList=[];
TwoPerSectorList=[];
FourPerSectorList=[];
for Sector =1:20

    BPMlist = [
        BPMlist;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;];

    %     if any(Sector == [1 5 6 10 11 15 16 20])
    %         BPMlist = [
    %             BPMlist;
    %             Sector 1;
    %             Sector 2;
    %             Sector 3;
    %             Sector 4;
    %             Sector 5;
    %             Sector 6;
    %             Sector 7;
    %             Sector 8;];
    %     else
    %         BPMlist = [
    %             BPMlist;
    %             Sector 1;
    %             Sector 2;
    %             Sector 3;
    %             Sector 4;
    %             Sector 5;
    %             Sector 6;
    %             Sector 7;];
    %     end

    HCMlist = [HCMlist;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];

    VCMlist = [VCMlist;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];

    OnePerSectorList = [OnePerSectorList;
        Sector 1;];

    TwoPerSectorList = [TwoPerSectorList;
        Sector 1;
        Sector 2;];

    FourPerSectorList = [
        FourPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];
end


% Build Family Structure
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'BPM'; 'BPMx'};
AO.BPMx.DeviceList = BPMlist;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status = ones(size(AO.BPMx.DeviceList,1),1);

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.MemberOf = {'PlotFamily'};
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_ssrf('BPMx', 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'BPM'; 'BPMy'};
AO.BPMy.DeviceList = BPMlist;
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status = ones(size(AO.BPMy.DeviceList,1),1);

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.MemberOf = {'PlotFamily'};
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames =  getname_ssrf('BPMy', 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;



AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = HCMlist;
AO.HCM.ElementList = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Status = ones(size(HCMlist,1),1);

AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.MemberOf = {'PlotFamily'};
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_ssrf('HCM', 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCM.Monitor.Physics2HWFcn = @k2amp;
AO.HCM.Monitor.Units = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.MemberOf = {'MachineConfig'};
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_ssrf('HCM', 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn = @k2amp;
AO.HCM.Setpoint.Units = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';

AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = HCMlist;
AO.VCM.ElementList = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Status = ones(size(HCMlist,1),1);

AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.MemberOf = {'PlotFamily'};
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_ssrf('VCM', 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.VCM.Monitor.Physics2HWFcn = @k2amp;
AO.VCM.Monitor.Units = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.MemberOf = {'MachineConfig'};
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_ssrf('VCM', 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.VCM.Setpoint.Physics2HWFcn = @k2amp;
AO.VCM.Setpoint.Units = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';


AO.Q1.FamilyName = 'Q1';
AO.Q1.MemberOf   = {'Tune Corrector'; 'Q1'; 'QUAD'; 'Magnet'};
AO.Q1.DeviceList = TwoPerSectorList;
AO.Q1.ElementList = ones(size(AO.Q1.DeviceList,1),1);
AO.Q1.Status = 1;

AO.Q1.Monitor.Mode = 'Simulator';
AO.Q1.Monitor.MemberOf = {'PlotFamily'};
AO.Q1.Monitor.DataType = 'Scalar';
AO.Q1.Monitor.ChannelNames = getname_ssrf('Q1', 'Monitor', AO.Q1.DeviceList);
AO.Q1.Monitor.HW2PhysicsFcn = @amp2k;
AO.Q1.Monitor.Physics2HWFcn = @k2amp;
AO.Q1.Monitor.Units = 'Hardware';
AO.Q1.Monitor.HWUnits      = 'Ampere';
AO.Q1.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q1.Setpoint.Mode = 'Simulator';
AO.Q1.Setpoint.MemberOf = {'MachineConfig'};
AO.Q1.Setpoint.DataType = 'Scalar';
AO.Q1.Setpoint.ChannelNames = getname_ssrf('Q1', 'Setpoint', AO.Q1.DeviceList);
AO.Q1.Setpoint.HW2PhysicsFcn = @amp2k;
AO.Q1.Setpoint.Physics2HWFcn = @k2amp;
AO.Q1.Setpoint.Units = 'Hardware';
AO.Q1.Setpoint.HWUnits      = 'Ampere';
AO.Q1.Setpoint.PhysicsUnits = '1/Meter^2';


AO.Q2.FamilyName = 'Q2';
AO.Q2.MemberOf   = {'Tune Corrector'; 'Q2'; 'QUAD'; 'Magnet'};
AO.Q2.DeviceList = TwoPerSectorList;
AO.Q2.ElementList = ones(size(AO.Q2.DeviceList,1),1);
AO.Q2.Status = 1;

AO.Q2.Monitor.Mode = 'Simulator';
AO.Q2.Monitor.MemberOf = {'PlotFamily'};
AO.Q2.Monitor.DataType = 'Scalar';
AO.Q2.Monitor.ChannelNames = getname_ssrf('Q2', 'Monitor', AO.Q2.DeviceList);
AO.Q2.Monitor.HW2PhysicsFcn = @amp2k;
AO.Q2.Monitor.Physics2HWFcn = @k2amp;
AO.Q2.Monitor.Units = 'Hardware';
AO.Q2.Monitor.HWUnits      = 'Ampere';
AO.Q2.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q2.Setpoint.Mode = 'Simulator';
AO.Q2.Setpoint.MemberOf = {'MachineConfig'};
AO.Q2.Setpoint.DataType = 'Scalar';
AO.Q2.Setpoint.ChannelNames = getname_ssrf('Q2', 'Setpoint', AO.Q2.DeviceList);
AO.Q2.Setpoint.HW2PhysicsFcn = @amp2k;
AO.Q2.Setpoint.Physics2HWFcn = @k2amp;
AO.Q2.Setpoint.Units = 'Hardware';
AO.Q2.Setpoint.HWUnits      = 'Ampere';
AO.Q2.Setpoint.PhysicsUnits = '1/Meter^2';


AO.Q3.FamilyName = 'Q3';
AO.Q3.MemberOf   = {'Tune Corrector'; 'Q3'; 'QUAD'; 'Magnet'};
AO.Q3.DeviceList = TwoPerSectorList;
AO.Q3.ElementList = ones(size(AO.Q3.DeviceList,1),1);
AO.Q3.Status = 1;

AO.Q3.Monitor.Mode = 'Simulator';
AO.Q3.Monitor.MemberOf = {'PlotFamily'};
AO.Q3.Monitor.DataType = 'Scalar';
AO.Q3.Monitor.ChannelNames = getname_ssrf('Q3', 'Monitor', AO.Q3.DeviceList);
AO.Q3.Monitor.HW2PhysicsFcn = @amp2k;
AO.Q3.Monitor.Physics2HWFcn = @k2amp;
AO.Q3.Monitor.Units = 'Hardware';
AO.Q3.Monitor.HWUnits      = 'Ampere';
AO.Q3.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q3.Setpoint.Mode = 'Simulator';
AO.Q3.Setpoint.MemberOf = {'MachineConfig'};
AO.Q3.Setpoint.DataType = 'Scalar';
AO.Q3.Setpoint.ChannelNames = getname_ssrf('Q3', 'Setpoint', AO.Q3.DeviceList);
AO.Q3.Setpoint.HW2PhysicsFcn = @amp2k;
AO.Q3.Setpoint.Physics2HWFcn = @k2amp;
AO.Q3.Setpoint.Units = 'Hardware';
AO.Q3.Setpoint.HWUnits      = 'Ampere';
AO.Q3.Setpoint.PhysicsUnits = '1/Meter^2';


AO.Q4.FamilyName = 'Q4';
AO.Q4.MemberOf   = {'Dispersion Corrector'; 'Q4'; 'QUAD'; 'Magnet'};
AO.Q4.DeviceList = TwoPerSectorList;
AO.Q4.ElementList = ones(size(AO.Q4.DeviceList,1),1);
AO.Q4.Status = 1;

AO.Q4.Monitor.Mode = 'Simulator';
AO.Q4.Monitor.MemberOf = {'PlotFamily'};
AO.Q4.Monitor.DataType = 'Scalar';
AO.Q4.Monitor.ChannelNames = getname_ssrf('Q4', 'Monitor', AO.Q4.DeviceList);
AO.Q4.Monitor.HW2PhysicsFcn = @amp2k;
AO.Q4.Monitor.Physics2HWFcn = @k2amp;
AO.Q4.Monitor.Units = 'Hardware';
AO.Q4.Monitor.HWUnits      = 'Ampere';
AO.Q4.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q4.Setpoint.Mode = 'Simulator';
AO.Q4.Setpoint.MemberOf = {'MachineConfig'};
AO.Q4.Setpoint.DataType = 'Scalar';
AO.Q4.Setpoint.ChannelNames = getname_ssrf('Q4', 'Setpoint', AO.Q4.DeviceList);
AO.Q4.Setpoint.HW2PhysicsFcn = @amp2k;
AO.Q4.Setpoint.Physics2HWFcn = @k2amp;
AO.Q4.Setpoint.Units = 'Hardware';
AO.Q4.Setpoint.HWUnits      = 'Ampere';
AO.Q4.Setpoint.PhysicsUnits = '1/Meter^2';


AO.Q5.FamilyName = 'Q5';
AO.Q5.MemberOf   = {'Dispersion Corrector'; 'Q5'; 'QUAD'; 'Magnet'};
AO.Q5.DeviceList = TwoPerSectorList;
AO.Q5.ElementList = ones(size(AO.Q5.DeviceList,1),1);
AO.Q5.Status = 1;

AO.Q5.Monitor.Mode = 'Simulator';
AO.Q5.Monitor.MemberOf = {'PlotFamily'};
AO.Q5.Monitor.DataType = 'Scalar';
AO.Q5.Monitor.ChannelNames = getname_ssrf('Q5', 'Monitor', AO.Q5.DeviceList);
AO.Q5.Monitor.HW2PhysicsFcn = @amp2k;
AO.Q5.Monitor.Physics2HWFcn = @k2amp;
AO.Q5.Monitor.Units = 'Hardware';
AO.Q5.Monitor.HWUnits      = 'Ampere';
AO.Q5.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q5.Setpoint.Mode = 'Simulator';
AO.Q5.Setpoint.MemberOf = {'MachineConfig'};
AO.Q5.Setpoint.DataType = 'Scalar';
AO.Q5.Setpoint.ChannelNames = getname_ssrf('Q5', 'Setpoint', AO.Q5.DeviceList);
AO.Q5.Setpoint.HW2PhysicsFcn = @amp2k;
AO.Q5.Setpoint.Physics2HWFcn = @k2amp;
AO.Q5.Setpoint.Units = 'Hardware';
AO.Q5.Setpoint.HWUnits      = 'Ampere';
AO.Q5.Setpoint.PhysicsUnits = '1/Meter^2';



AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = OnePerSectorList;
AO.SF.ElementList = ones(size(AO.SF.DeviceList,1),1);
AO.SF.Status = 1;

AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.MemberOf = {'PlotFamily'};
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_ssrf('SF', 'Monitor', AO.SF.DeviceList);
AO.SF.Monitor.HW2PhysicsFcn = @amp2k;
AO.SF.Monitor.Physics2HWFcn = @k2amp;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.MemberOf = {'MachineConfig'};
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_ssrf('SF', 'Setpoint', AO.SF.DeviceList);
AO.SF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SF.Setpoint.Physics2HWFcn = @k2amp;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits      = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = TwoPerSectorList;
AO.SD.ElementList = ones(size(AO.SD.DeviceList,1),1);
AO.SD.Status = 1;

AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.MemberOf = {'PlotFamily'};
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_ssrf('SD', 'Monitor', AO.SD.DeviceList);
AO.SD.Monitor.HW2PhysicsFcn = @amp2k;
AO.SD.Monitor.Physics2HWFcn = @k2amp;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.MemberOf = {'MachineConfig'};
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_ssrf('SD', 'Setpoint', AO.SD.DeviceList);
AO.SD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SD.Setpoint.Physics2HWFcn = @k2amp;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits      = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';

% AO.SD.RampRate.Mode = 'Simulator';
% AO.SD.RampRate.MemberOf = {'MachineConfig', 'PlotFamily'};
% AO.SD.RampRate.DataType = 'Scalar';
% AO.SD.RampRate.ChannelNames = getname_ssrf('SD', 'Setpoint', AO.SD.DeviceList);
% AO.SD.RampRate.HW2PhysicsFcn = @amp2k;
% AO.SD.RampRate.Physics2HWFcn = @k2amp;
% AO.SD.RampRate.Units = 'Hardware';
% AO.SD.RampRate.HWUnits      = 'Ampere/second';
% AO.SD.RampRate.PhysicsUnits = '1/Meter^3/second';


AO.S1.FamilyName = 'S1';
AO.S1.MemberOf   = {'Harmonic Sextupole'; 'S1'; 'SEXT'; 'Magnet'};
AO.S1.DeviceList = [1 1;5 2; 6 1; 10 2; 11 1;15 2;16 1; 20 2];
AO.S1.ElementList = ones(size(AO.S1.DeviceList,1),1);
AO.S1.Status = 1;

AO.S1.Monitor.Mode = 'Simulator';
AO.S1.Monitor.MemberOf = {'PlotFamily'};
AO.S1.Monitor.DataType = 'Scalar';
AO.S1.Monitor.ChannelNames = getname_ssrf('S1', 'Monitor', AO.S1.DeviceList);
AO.S1.Monitor.HW2PhysicsFcn = @amp2k;
AO.S1.Monitor.Physics2HWFcn = @k2amp;
AO.S1.Monitor.Units = 'Hardware';
AO.S1.Monitor.HWUnits      = 'Ampere';
AO.S1.Monitor.PhysicsUnits = '1/Meter^3';

AO.S1.Setpoint.Mode = 'Simulator';
AO.S1.Setpoint.MemberOf = {'MachineConfig'};
AO.S1.Setpoint.DataType = 'Scalar';
AO.S1.Setpoint.ChannelNames = getname_ssrf('S1', 'Setpoint', AO.S1.DeviceList);
AO.S1.Setpoint.HW2PhysicsFcn = @amp2k;
AO.S1.Setpoint.Physics2HWFcn = @k2amp;
AO.S1.Setpoint.Units = 'Hardware';
AO.S1.Setpoint.HWUnits      = 'Ampere';
AO.S1.Setpoint.PhysicsUnits = '1/Meter^3';


AO.S2.FamilyName = 'S2';
AO.S2.MemberOf   = {'Harmonic Sextupole'; 'S2'; 'SEXT'; 'Magnet'};
AO.S2.DeviceList = [1 1;5 2; 6 1; 10 2; 11 1;15 2;16 1; 20 2];
AO.S2.ElementList = ones(size(AO.S2.DeviceList,1),1);
AO.S2.Status = 1;

AO.S2.Monitor.Mode = 'Simulator';
AO.S2.Monitor.MemberOf = {'PlotFamily'};
AO.S2.Monitor.DataType = 'Scalar';
AO.S2.Monitor.ChannelNames = getname_ssrf('S2', 'Monitor', AO.S2.DeviceList);
AO.S2.Monitor.HW2PhysicsFcn = @amp2k;
AO.S2.Monitor.Physics2HWFcn = @k2amp;
AO.S2.Monitor.Units = 'Hardware';
AO.S2.Monitor.HWUnits      = 'Ampere';
AO.S2.Monitor.PhysicsUnits = '1/Meter^3';

AO.S2.Setpoint.Mode = 'Simulator';
AO.S2.Setpoint.MemberOf = {'MachineConfig'};
AO.S2.Setpoint.DataType = 'Scalar';
AO.S2.Setpoint.ChannelNames = getname_ssrf('S2', 'Setpoint', AO.S2.DeviceList);
AO.S2.Setpoint.HW2PhysicsFcn = @amp2k;
AO.S2.Setpoint.Physics2HWFcn = @k2amp;
AO.S2.Setpoint.Units = 'Hardware';
AO.S2.Setpoint.HWUnits      = 'Ampere';
AO.S2.Setpoint.PhysicsUnits = '1/Meter^3';


AO.S3.FamilyName = 'S3';
AO.S3.MemberOf   = {'Harmonic Sextupole'; 'S3'; 'SEXT'; 'Magnet'};
AO.S3.DeviceList = [1 2;2 1;4 2;5 1;6 2;7 1;9 2;10 1;11 2;12 1;14 2;15 1;16 2;17 1;19 2;20 1];
AO.S3.ElementList = ones(size(AO.S3.DeviceList,1),1);
AO.S3.Status = 1;

AO.S3.Monitor.Mode = 'Simulator';
AO.S3.Monitor.MemberOf = {'PlotFamily'};
AO.S3.Monitor.DataType = 'Scalar';
AO.S3.Monitor.ChannelNames = getname_ssrf('S3', 'Monitor', AO.S3.DeviceList);
AO.S3.Monitor.HW2PhysicsFcn = @amp2k;
AO.S3.Monitor.Physics2HWFcn = @k2amp;
AO.S3.Monitor.Units = 'Hardware';
AO.S3.Monitor.HWUnits      = 'Ampere';
AO.S3.Monitor.PhysicsUnits = '1/Meter^3';

AO.S3.Setpoint.Mode = 'Simulator';
AO.S3.Setpoint.MemberOf = {'MachineConfig'};
AO.S3.Setpoint.DataType = 'Scalar';
AO.S3.Setpoint.ChannelNames = getname_ssrf('S3', 'Setpoint', AO.S3.DeviceList);
AO.S3.Setpoint.HW2PhysicsFcn = @amp2k;
AO.S3.Setpoint.Physics2HWFcn = @k2amp;
AO.S3.Setpoint.Units = 'Hardware';
AO.S3.Setpoint.HWUnits      = 'Ampere';
AO.S3.Setpoint.PhysicsUnits = '1/Meter^3';


AO.S4.FamilyName = 'S4';
AO.S4.MemberOf   = {'Harmonic Sextupole'; 'S4'; 'SEXT'; 'Magnet'};
AO.S4.DeviceList = [1 2;2 1;4 2;5 1;6 2;7 1;9 2;10 1;11 2;12 1;14 2;15 1;16 2;17 1;19 2;20 1];
AO.S4.ElementList = ones(size(AO.S4.DeviceList,1),1);
AO.S4.Status = 1;

AO.S4.Monitor.Mode = 'Simulator';
AO.S4.Monitor.MemberOf = {'PlotFamily'};
AO.S4.Monitor.DataType = 'Scalar';
AO.S4.Monitor.ChannelNames = getname_ssrf('S4', 'Monitor', AO.S4.DeviceList);
AO.S4.Monitor.HW2PhysicsFcn = @amp2k;
AO.S4.Monitor.Physics2HWFcn = @k2amp;
AO.S4.Monitor.Units = 'Hardware';
AO.S4.Monitor.HWUnits      = 'Ampere';
AO.S4.Monitor.PhysicsUnits = '1/Meter^3';

AO.S4.Setpoint.Mode = 'Simulator';
AO.S4.Setpoint.MemberOf = {'MachineConfig'};
AO.S4.Setpoint.DataType = 'Scalar';
AO.S4.Setpoint.ChannelNames = getname_ssrf('S4', 'Setpoint', AO.S4.DeviceList);
AO.S4.Setpoint.HW2PhysicsFcn = @amp2k;
AO.S4.Setpoint.Physics2HWFcn = @k2amp;
AO.S4.Setpoint.Units = 'Hardware';
AO.S4.Setpoint.HWUnits      = 'Ampere';
AO.S4.Setpoint.PhysicsUnits = '1/Meter^3';


AO.S5.FamilyName = 'S5';
AO.S5.MemberOf   = {'Harmonic Sextupole'; 'S5'; 'SEXT'; 'Magnet'};
AO.S5.DeviceList = [2 2;3 1;3 2;4 1;7 2;8 1;8 2;9 1;12 2;13 1;13 2;14 1;17 2;18 1;18 2;19 1];
AO.S5.ElementList = ones(size(AO.S5.DeviceList,1),1);
AO.S5.Status = 1;

AO.S5.Monitor.Mode = 'Simulator';
AO.S5.Monitor.MemberOf = {'PlotFamily'};
AO.S5.Monitor.DataType = 'Scalar';
AO.S5.Monitor.ChannelNames = getname_ssrf('S5', 'Monitor', AO.S5.DeviceList);
AO.S5.Monitor.HW2PhysicsFcn = @amp2k;
AO.S5.Monitor.Physics2HWFcn = @k2amp;
AO.S5.Monitor.Units = 'Hardware';
AO.S5.Monitor.HWUnits      = 'Ampere';
AO.S5.Monitor.PhysicsUnits = '1/Meter^3';

AO.S5.Setpoint.Mode = 'Simulator';
AO.S5.Setpoint.MemberOf = {'MachineConfig'};
AO.S5.Setpoint.DataType = 'Scalar';
AO.S5.Setpoint.ChannelNames = getname_ssrf('S5', 'Setpoint', AO.S5.DeviceList);
AO.S5.Setpoint.HW2PhysicsFcn = @amp2k;
AO.S5.Setpoint.Physics2HWFcn = @k2amp;
AO.S5.Setpoint.Units = 'Hardware';
AO.S5.Setpoint.HWUnits      = 'Ampere';
AO.S5.Setpoint.PhysicsUnits = '1/Meter^3';


AO.S6.FamilyName = 'S6';
AO.S6.MemberOf   = {'Harmonic Sextupole'; 'S6'; 'SEXT'; 'Magnet'};
AO.S6.DeviceList = [2 2;3 1;3 2;4 1;7 2;8 1;8 2;9 1;12 2;13 1;13 2;14 1;17 2;18 1;18 2;19 1];;
AO.S6.ElementList = ones(size(AO.S6.DeviceList,1),1);
AO.S6.Status = 1;

AO.S6.Monitor.Mode = 'Simulator';
AO.S6.Monitor.MemberOf = {'PlotFamily'};
AO.S6.Monitor.DataType = 'Scalar';
AO.S6.Monitor.ChannelNames = getname_ssrf('S6', 'Monitor', AO.S6.DeviceList);
AO.S6.Monitor.HW2PhysicsFcn = @amp2k;
AO.S6.Monitor.Physics2HWFcn = @k2amp;
AO.S6.Monitor.Units = 'Hardware';
AO.S6.Monitor.HWUnits      = 'Ampere';
AO.S6.Monitor.PhysicsUnits = '1/Meter^3';

AO.S6.Setpoint.Mode = 'Simulator';
AO.S6.Setpoint.MemberOf = {'MachineConfig'};
AO.S6.Setpoint.DataType = 'Scalar';
AO.S6.Setpoint.ChannelNames = getname_ssrf('S6', 'Setpoint', AO.S6.DeviceList);
AO.S6.Setpoint.HW2PhysicsFcn = @amp2k;
AO.S6.Setpoint.Physics2HWFcn = @k2amp;
AO.S6.Setpoint.Units = 'Hardware';
AO.S6.Setpoint.HWUnits      = 'Ampere';
AO.S6.Setpoint.PhysicsUnits = '1/Meter^3';


% AO.SFM.FamilyName = 'SFM';
% AO.SFM.MemberOf   = {'Harmonic Sextupole'; 'SFM'; 'SEXT'; 'Magnet'};
% AO.SFM.DeviceList = TwoPerSectorList;
% AO.SFM.ElementList = ones(size(AO.SFM.DeviceList,1),1);
% AO.SFM.Status = 1;
% 
% AO.SFM.Monitor.Mode = 'Simulator';
% AO.SFM.Monitor.MemberOf = {'PlotFamily'};
% AO.SFM.Monitor.DataType = 'Scalar';
% AO.SFM.Monitor.ChannelNames = getname_ssrf('SFM', 'Monitor', AO.SFM.DeviceList);
% AO.SFM.Monitor.HW2PhysicsFcn = @amp2k;
% AO.SFM.Monitor.Physics2HWFcn = @k2amp;
% AO.SFM.Monitor.Units = 'Hardware';
% AO.SFM.Monitor.HWUnits      = 'Ampere';
% AO.SFM.Monitor.PhysicsUnits = '1/Meter^3';
% 
% AO.SFM.Setpoint.Mode = 'Simulator';
% AO.SFM.Setpoint.MemberOf = {'MachineConfig'};
% AO.SFM.Setpoint.DataType = 'Scalar';
% AO.SFM.Setpoint.ChannelNames = getname_ssrf('SFM', 'Setpoint', AO.SFM.DeviceList);
% AO.SFM.Setpoint.HW2PhysicsFcn = @amp2k;
% AO.SFM.Setpoint.Physics2HWFcn = @k2amp;
% AO.SFM.Setpoint.Units = 'Hardware';
% AO.SFM.Setpoint.HWUnits      = 'Ampere';
% AO.SFM.Setpoint.PhysicsUnits = '1/Meter^3';
% 
% 
% AO.SDM.FamilyName = 'SDM';
% AO.SDM.MemberOf   = {'Harmonic Sextupole'; 'SDM'; 'SEXT'; 'Magnet'};
% AO.SDM.DeviceList = TwoPerSectorList;
% AO.SDM.ElementList = ones(size(AO.SDM.DeviceList,1),1);
% AO.SDM.Status = 1;
% 
% AO.SDM.Monitor.Mode = 'Simulator';
% AO.SDM.Monitor.MemberOf = {'PlotFamily'};
% AO.SDM.Monitor.DataType = 'Scalar';
% AO.SDM.Monitor.ChannelNames = getname_ssrf('SDM', 'Monitor', AO.SDM.DeviceList);
% AO.SDM.Monitor.HW2PhysicsFcn = @amp2k;
% AO.SDM.Monitor.Physics2HWFcn = @k2amp;
% AO.SDM.Monitor.Units = 'Hardware';
% AO.SDM.Monitor.HWUnits      = 'Ampere';
% AO.SDM.Monitor.PhysicsUnits = '1/Meter^3';
% 
% AO.SDM.Setpoint.Mode = 'Simulator';
% AO.SDM.Setpoint.MemberOf = {'MachineConfig'};
% AO.SDM.Setpoint.DataType = 'Scalar';
% AO.SDM.Setpoint.ChannelNames = getname_ssrf('SDM', 'Setpoint', AO.SDM.DeviceList);
% AO.SDM.Setpoint.HW2PhysicsFcn = @amp2k;
% AO.SDM.Setpoint.Physics2HWFcn = @k2amp;
% AO.SDM.Setpoint.Units = 'Hardware';
% AO.SDM.Setpoint.HWUnits      = 'Ampere';
% AO.SDM.Setpoint.PhysicsUnits = '1/Meter^3';



AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'BEND'; 'Magnet'};
AO.BEND.Status = 1;
AO.BEND.DeviceList = TwoPerSectorList;
AO.BEND.ElementList = ones(size(AO.BEND.DeviceList,1),1);

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.MemberOf = {'PlotFamily'};
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_ssrf('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @amp2k;
AO.BEND.Monitor.Physics2HWFcn = @k2amp;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.MemberOf = {'MachineConfig'};
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_ssrf('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @amp2k;
AO.BEND.Setpoint.Physics2HWFcn = @k2amp;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'RF'};
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;
AO.RF.Status = 1;

AO.RF.Monitor.Mode = 'Simulator';
AO.RF.Monitor.MemberOf = {'PlotFamily'};
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = getname_ssrf('RF', 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator';
AO.RF.Setpoint.MemberOf = {'MachineConfig'};
AO.RF.Setpoint.DataType = 'Scalar';
%AO.RF.Setpoint.SpecialFunctionSet = 'setrf_ssrf';
%AO.RF.Setpoint.SpecialFunctionGet = 'getrf_ssrf';
AO.RF.Setpoint.ChannelNames = getname_ssrf('RF', 'Setpoint', AO.RF.DeviceList);
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';

% AO.RF.Power.Mode = 'Simulator';
% AO.RF.Power.DataType = 'Scalar';
% AO.RF.Power.ChannelNames = getname_ssrf(RF, 'Power', AO.RF.DeviceList);
% AO.RF.Power.HW2PhysicsParams = 1;
% AO.RF.Power.Physics2HWParams = 1;
% AO.RF.Power.Units = 'Hardware';
% AO.RF.Power.HWUnits       = 'MV';
% AO.RF.Power.PhysicsUnits  = 'MV';


AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1;1;0];

AO.TUNE.Monitor.Mode = 'Simulator';  
AO.TUNE.Monitor.DataType = 'Scalar';
%AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_ssrf';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units = 'Hardware';
AO.TUNE.Monitor.HWUnits = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT'};
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = 1;
AO.DCCT.Status = 1;

AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = getname_ssrf('DCCT', 'Monitor', AO.DCCT.DeviceList);
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Position not definited in updateatindex %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.TUNE.Position = 0;
AO.DCCT.Position = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Range (In Hardware Units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Range  = [-Inf Inf];
AO.VCM.Setpoint.Range  = [-Inf Inf];

AO.Q1.Setpoint.Range   = [-Inf Inf];
AO.Q2.Setpoint.Range   = [-Inf Inf];
AO.Q3.Setpoint.Range   = [-Inf Inf];
AO.Q4.Setpoint.Range   = [-Inf Inf];
AO.Q5.Setpoint.Range   = [-Inf Inf];

AO.SF.Setpoint.Range   = [-Inf Inf];
AO.SD.Setpoint.Range   = [-Inf Inf];
AO.S1.Setpoint.Range  = [-Inf Inf];
AO.S2.Setpoint.Range  = [-Inf Inf];
AO.S3.Setpoint.Range  = [-Inf Inf];
AO.S4.Setpoint.Range  = [-Inf Inf];
AO.S5.Setpoint.Range  = [-Inf Inf];
AO.S6.Setpoint.Range  = [-Inf Inf];

AO.BEND.Setpoint.Range = [-Inf Inf];
AO.RF.Setpoint.Range   = [0 Inf];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (In Hardware Units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = .1;
AO.VCM.Setpoint.Tolerance  = .1;

AO.Q1.Setpoint.Tolerance   = .1;
AO.Q2.Setpoint.Tolerance   = .1;
AO.Q3.Setpoint.Tolerance   = .1;
AO.Q4.Setpoint.Tolerance   = .1;
AO.Q5.Setpoint.Tolerance   = .1;

AO.SF.Setpoint.Tolerance   = .1;
AO.SD.Setpoint.Tolerance   = .1;
AO.S1.Setpoint.Tolerance  = .1;
AO.S2.Setpoint.Tolerance  = .1;
AO.S3.Setpoint.Tolerance  = .1;
AO.S4.Setpoint.Tolerance  = .1;
AO.S5.Setpoint.Tolerance  = .1;
AO.S6.Setpoint.Tolerance  = .1;

AO.BEND.Setpoint.Tolerance = .2;
AO.RF.Setpoint.Tolerance   = .1;  % .5e-6;  


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response Matrix Kick Size (In Hardware Units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% .DeltaRespMat field should be hardware units but amp2k/k2amp
% is not working yet so it will be physics units for now
AO.HCM.Setpoint.DeltaRespMat = .1e-3; %mm2amp('HCM',.5); 
AO.VCM.Setpoint.DeltaRespMat = .1e-3; %mm2amp('VCM',.5); 

AO.Q1.Setpoint.DeltaRespMat = getsp('Q1')/1000;
AO.Q2.Setpoint.DeltaRespMat = getsp('Q2')/1000;
AO.Q3.Setpoint.DeltaRespMat = getsp('Q3')/1000;
AO.Q4.Setpoint.DeltaRespMat = getsp('Q4')/1000;
AO.Q5.Setpoint.DeltaRespMat = getsp('Q5')/1000;

AO.SF.Setpoint.DeltaRespMat  = getsp('SF')/100;
AO.SD.Setpoint.DeltaRespMat  = getsp('SD')/100; 
AO.S1.Setpoint.DeltaRespMat = getsp('S1')/100;
AO.S2.Setpoint.DeltaRespMat = getsp('S2')/100;
AO.S3.Setpoint.DeltaRespMat = getsp('S3')/100;
AO.S4.Setpoint.DeltaRespMat = getsp('S4')/100;
AO.S5.Setpoint.DeltaRespMat = getsp('S5')/100;
AO.S6.Setpoint.DeltaRespMat = getsp('S6')/100;

setao(AO);



