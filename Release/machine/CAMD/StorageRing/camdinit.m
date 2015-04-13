function camdinit(OperationalMode)
%CAMDINIT - MML initialization function for CAMD


% To do:
% 1. All families need channel names (getname_camd), max/min, tol, etc.
% 2. amp2k and k2amp need work!
% 3. Tune family needs work.
% 4. If you want to work at different energies, bend2gev and gev2bend need work.
% 5. Run monmags and set tolerance field based on the output.


if nargin < 1
    OperationalMode = 1;
end


setao([]);   %clear previous AcceleratorObjects


% Build the various device lists
OnePerSectorList=[];
TwoPerSectorList=[];
ThreePerSectorList=[];
FourPerSectorList=[];
FivePerSectorList=[];
for Sector =1:4
    OnePerSectorList = [OnePerSectorList;
        Sector 1;];
    TwoPerSectorList = [TwoPerSectorList;
        Sector 1;
        Sector 2;];
    ThreePerSectorList = [ThreePerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;];
    FourPerSectorList = [FourPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];
    FivePerSectorList = [FivePerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM'; 'BPMx'; 'HBPM'};
AO.BPMx.DeviceList = FivePerSectorList;
AO.BPMx.ElementList = (1:size(FivePerSectorList,1))';
AO.BPMx.Status = ones(size(FivePerSectorList,1),1);

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_camd('BPMx', 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMx.Monitor.Physics2HWParams = 1e+3;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM'; 'BPMy'; 'VBPM'};
AO.BPMy.DeviceList = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status = AO.BPMx.Status;

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_camd('BPMy', 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMy.Monitor.Physics2HWParams = 1e+3;



% Correctors
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = FourPerSectorList;
AO.HCM.ElementList = (1:size(FourPerSectorList,1))';
AO.HCM.Status = ones(size(FourPerSectorList,1),1);

AO.HCM.Monitor.MemberOf = {'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_camd('HCM', 'Monitor', AO.HCM.DeviceList);
%AO.HCM.Monitor.HW2PhysicsParams = 9.9254e-5;
%AO.HCM.Monitor.Physics2HWParams = 1/AO.HCM.Monitor.HW2PhysicsParams;
AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCM.Monitor.Physics2HWFcn = @k2amp;
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
AO.HCM.Monitor.Units = 'Hardware';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_camd('HCM', 'Setpoint', AO.HCM.DeviceList);
%AO.HCM.Setpoint.HW2PhysicsParams = AO.HCM.Monitor.HW2PhysicsParams;
%AO.HCM.Setpoint.Physics2HWParams = AO.HCM.Monitor.Physics2HWParams;
AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn = @k2amp;
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Units = 'Hardware';


AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = ThreePerSectorList;
AO.VCM.ElementList = (1:size(ThreePerSectorList,1))';
AO.VCM.Status = ones(size(ThreePerSectorList,1),1);

AO.VCM.Monitor.MemberOf = {'COR'; 'VCM'; 'Magnet'; 'Monitor'};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_camd('VCM', 'Monitor', AO.VCM.DeviceList);
%AO.VCM.Monitor.HW2PhysicsParams = [9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5 8.9440e-5 9.2252e-5]';
%AO.VCM.Monitor.Physics2HWParams = 1./AO.VCM.Monitor.HW2PhysicsParams;
AO.VCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.VCM.Monitor.Physics2HWFcn = @k2amp;
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
AO.VCM.Monitor.Units = 'Hardware';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_camd('VCM', 'Setpoint', AO.VCM.DeviceList);
%AO.VCM.Setpoint.HW2PhysicsParams = AO.VCM.Monitor.HW2PhysicsParams;
%AO.VCM.Setpoint.Physics2HWParams = AO.VCM.Monitor.Physics2HWParams;
AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.VCM.Setpoint.Physics2HWFcn = @k2amp;
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Units = 'Hardware';



% Quadrupoles
AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QF.DeviceList = TwoPerSectorList;
AO.QF.ElementList = (1:size(TwoPerSectorList,1))';
AO.QF.Status = ones(size(TwoPerSectorList,1),1);

AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_camd('QF', 'Monitor', AO.QF.DeviceList);
%AO.QF.Monitor.HW2PhysicsParams = 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
%AO.QF.Monitor.Physics2HWParams = 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QF.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF.Monitor.Physics2HWFcn = @k2amp;
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_camd('QF', 'Setpoint', AO.QF.DeviceList);
%AO.QF.Setpoint.HW2PhysicsParams = AO.QF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.QF.Setpoint.Physics2HWParams = AO.QF.Monitor.Physics2HWParams;
AO.QF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF.Setpoint.Physics2HWFcn = @k2amp;
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD'; 'QUAD'; 'Magnet'};
AO.QD.DeviceList = TwoPerSectorList;
AO.QD.ElementList = (1:size(TwoPerSectorList,1))';
AO.QD.Status = ones(size(TwoPerSectorList,1),1);

AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_camd('QD', 'Monitor', AO.QD.DeviceList);
%AO.QD.Monitor.HW2PhysicsParams = -6.431778e-3;    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.Monitor.Physics2HWParams = 1 ./ AO.QD.Monitor.HW2PhysicsParams;
AO.QD.Monitor.HW2PhysicsFcn = @amp2k;
AO.QD.Monitor.Physics2HWFcn = @k2amp;
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_camd('QD', 'Setpoint', AO.QD.DeviceList);
%AO.QD.Setpoint.HW2PhysicsParams = AO.QD.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.Setpoint.Physics2HWParams = AO.QD.Monitor.Physics2HWParams;
AO.QD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QD.Setpoint.Physics2HWFcn = @k2amp;
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';


AO.QFA.FamilyName = 'QFA';
AO.QFA.MemberOf   = {'PlotFamily'; 'Dispersion Corrector'; 'QUAD'; 'Magnet'};
AO.QFA.DeviceList = OnePerSectorList;
AO.QFA.ElementList = (1:size(OnePerSectorList,1))';
AO.QFA.Status = ones(size(OnePerSectorList,1),1);

AO.QFA.Monitor.Mode = 'Simulator';
AO.QFA.Monitor.DataType = 'Scalar';
AO.QFA.Monitor.ChannelNames = getname_camd('QFA', 'Monitor', AO.QFA.DeviceList);
%AO.QFA.Monitor.HW2PhysicsParams = 6.506781e-3;    % K/Ampere:  HW2Physics*Amps=K
%AO.QFA.Monitor.Physics2HWParams = 1 ./ AO.QFA.Monitor.HW2PhysicsParams;
AO.QFA.Monitor.HW2PhysicsFcn = @amp2k;
AO.QFA.Monitor.Physics2HWFcn = @k2amp;
AO.QFA.Monitor.Units = 'Hardware';
AO.QFA.Monitor.HWUnits = 'Ampere';
AO.QFA.Monitor.PhysicsUnits = '1/Meter^2';

AO.QFA.Setpoint.MemberOf = {'MachineConfig'};
AO.QFA.Setpoint.Mode = 'Simulator';
AO.QFA.Setpoint.DataType = 'Scalar';
AO.QFA.Setpoint.ChannelNames = getname_camd('QFA', 'Setpoint', AO.QFA.DeviceList);
%AO.QFA.Setpoint.HW2PhysicsParams = AO.QFA.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.QFA.Setpoint.Physics2HWParams = AO.QFA.Monitor.Physics2HWParams;
AO.QFA.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QFA.Setpoint.Physics2HWFcn = @k2amp;
AO.QFA.Setpoint.Units = 'Hardware';
AO.QFA.Setpoint.HWUnits = 'Ampere';
AO.QFA.Setpoint.PhysicsUnits = '1/Meter^2';


% Sextupoles
AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = TwoPerSectorList;
AO.SF.ElementList = (1:size(TwoPerSectorList,1))';
AO.SF.Status = ones(size(TwoPerSectorList,1),1);

AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_camd('SF', 'Monitor', AO.SF.DeviceList);
%AO.SF.Monitor.HW2PhysicsParams = 1.367376/2;
%AO.SF.Monitor.Physics2HWParams = 1 ./ AO.SF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SF.Monitor.HW2PhysicsFcn = @amp2k;
AO.SF.Monitor.Physics2HWFcn = @k2amp;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_camd('SF', 'Setpoint', AO.SF.DeviceList);
%AO.SF.Setpoint.HW2PhysicsParams = AO.SF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.SF.Setpoint.Physics2HWParams = AO.SF.Monitor.Physics2HWParams;
AO.SF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SF.Setpoint.Physics2HWFcn = @k2amp;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = TwoPerSectorList;
AO.SD.ElementList = (1:size(TwoPerSectorList,1))';
AO.SD.Status = ones(size(TwoPerSectorList,1),1);

AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_camd('SD', 'Monitor', AO.SD.DeviceList);
%AO.SD.Monitor.HW2PhysicsParams = -1.37117/2;    % K/Ampere:  HW2Physics*Amps=K
%AO.SD.Monitor.Physics2HWParams = 1 ./ AO.SD.Monitor.HW2PhysicsParams;
AO.SD.Monitor.HW2PhysicsFcn = @amp2k;
AO.SD.Monitor.Physics2HWFcn = @k2amp;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_camd('SD', 'Setpoint', AO.SD.DeviceList);
%AO.SD.Setpoint.HW2PhysicsParams = AO.SD.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.SD.Setpoint.Physics2HWParams = AO.SD.Monitor.Physics2HWParams;
AO.SD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SD.Setpoint.Physics2HWFcn = @k2amp;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';



% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = TwoPerSectorList;
AO.BEND.ElementList = (1:size(TwoPerSectorList,1))';
AO.BEND.Status = ones(size(TwoPerSectorList,1),1);

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_camd('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @amp2k;
AO.BEND.Monitor.Physics2HWFcn = @k2amp;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_camd('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @amp2k;
AO.BEND.Setpoint.Physics2HWFcn = @k2amp;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

AO.RF.Monitor.Mode = 'Simulator'; 
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = getname_camd('RF', 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.SpecialFunctionGet = 'getrf_camd';
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator'; 
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.SpecialFunctionSet = 'setrf_camd';
AO.RF.Setpoint.SpecialFunctionGet = 'getrf_camd';
AO.RF.Setpoint.ChannelNames = getname_camd('RF', 'Setpoint', AO.RF.DeviceList);
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [0 Inf];


% Tune
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.Status = [1;1;0];
AO.TUNE.Position = 0;
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];

AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
%AO.TUNE.Monitor.ChannelNames = getname_camd('TUNE', 'Monitor', AO.RF.DeviceList);
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_camd';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units = 'Hardware';
AO.TUNE.Monitor.HWUnits = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


% DCCT
AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {};
AO.DCCT.Status = 1;
AO.DCCT.Position = 0;
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = 1;
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = getname_camd('DCCT', 'Monitor', AO.DCCT.DeviceList);
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Range (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Range  = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.VCM.Setpoint.Range  = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.QF.Setpoint.Range   = [local_minsp(AO.QF.FamilyName)   local_maxsp(AO.QF.FamilyName)];
AO.QD.Setpoint.Range   = [local_minsp(AO.QD.FamilyName)   local_maxsp(AO.QD.FamilyName)];
AO.QFA.Setpoint.Range  = [local_minsp(AO.QFA.FamilyName)  local_maxsp(AO.QFA.FamilyName)];
AO.SF.Setpoint.Range   = [local_minsp(AO.SF.FamilyName)   local_maxsp(AO.SF.FamilyName)];
AO.SD.Setpoint.Range   = [local_minsp(AO.SD.FamilyName)   local_maxsp(AO.SD.FamilyName)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];
AO.RF.Setpoint.Range   = [local_minsp(AO.RF.FamilyName)   local_maxsp(AO.RF.FamilyName)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName);
AO.QF.Setpoint.Tolerance   = gettol(AO.QF.FamilyName);
AO.QD.Setpoint.Tolerance   = gettol(AO.QD.FamilyName);
AO.QFA.Setpoint.Tolerance  = gettol(AO.QF.FamilyName);
AO.SF.Setpoint.Tolerance   = gettol(AO.SF.FamilyName);
AO.SD.Setpoint.Tolerance   = gettol(AO.SD.FamilyName);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName);
AO.RF.Setpoint.Tolerance   = gettol(AO.RF.FamilyName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response matrix kick size (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .5e-4, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .5e-4, AO.VCM.DeviceList, 'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat  = 1;
AO.QD.Setpoint.DeltaRespMat  = 1;
AO.QFA.Setpoint.DeltaRespMat = 1;
AO.SF.Setpoint.DeltaRespMat  = 2;
AO.SD.Setpoint.DeltaRespMat  = 2;

setao(AO);




function [Amps] = local_minsp(Family, List)
%   local_minsp = local_minsp(Family, List {entire list});
%
%   Inputs:  Family must be a string (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is minimum strength for that family


% Input checking
if nargin < 1 || nargin > 2
    error('local_minsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family, 0);
end


if isempty(List)
    error('local_minsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_minsp: List must be 1 or 2 columns only');
end

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = -33;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -25;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QFA')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SD')        
        Amps(i,1) = 0;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 0;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 0;
    else
        fprintf('   Min setpoint unknown for %s family, hence set to -Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List)
%   Amps = local_maxsp(Family, List {entire list});
%
%   Inputs:  Family must be a string (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is maximum strength for that family


% Input checking
if nargin < 1 || nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family,0);
end

if isempty(List)
    error('local_maxsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_maxsp: List must be 1 or 2 columns only');
end

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = 33;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = 25;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 500;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 500;
    elseif strcmp(Family,'QFA')
        Amps(i,1) = 400;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 31;
    elseif strcmp(Family,'SD')
        Amps(i,1) = 31;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 2000;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 150e6;  % 150Mhz
    else
        fprintf('   Max setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  tolerance on the SP-AM for that family
%
%  Note: the real tolerance is in gplink
%

% Input checking
if nargin < 1 || nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family,0);
end

if isempty(List)
    error('local_maxsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_maxsp: List must be 1 or 2 columns only');
end


if strcmp(Family,'HCM')
    tol = 0.25;
elseif strcmp(Family,'VCM')
    tol = 0.15;
elseif strcmp(Family,'QF')
    tol = 1.0;
elseif strcmp(Family,'QD')
    tol = 2.5;
elseif strcmp(Family,'QFA')
    tol = 2.5;
elseif strcmp(Family,'SQSF')
    tol = 0.25;
elseif strcmp(Family,'SQSD')
    tol = 0.25;
elseif strcmp(Family,'SF')
    tol = 0.15;
elseif strcmp(Family,'SD')
    tol = 0.1;
elseif strcmp(Family,'BEND')
    tol = 0.5;
elseif strcmp(Family,'RF')
    tol = 0.5;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end

tol = tol * ones(size(List,1),1);
