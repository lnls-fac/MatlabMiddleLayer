function bessy2init(OperationalMode)
%BESSy2INIT - MML initialization program for Bessy 2


% To-Do:
% 1. AT Deck needs some work:
%    a. Having a separate marker, quadrupole, sextupole, etc. function for each element
%       is very cpu expensive.  
%    b. All quads, sext, bend have famname QUAD, SEXT, BEND.  This makes setting up the MML more
%       difficult.  If each family was in the AT deck that would be great.
%    c. Give the sextupoles the proper lenght and split them if you need a corrector in the center.
%    d. Remove CQS from the AT deck and use the sextupole (edit updateatindex)
%    e. Make sure the BPM and magnes are in the correct location in the AT model 
%       or LOCO will have trouble. 
%    f. The lattice is unstable.
% 2. hw2physics conversions - everything is done in bessy2at and at2bessy -- needs work!
% 3. gev2bend and bend2gev needs work.
% 4. Check .Ranges, .Tolerances, and .DeltaRespMat
% 5. run monmags to check the .Tolerance field
% 6. Measurements - monbpm, measbpmresp, measdisp
% 7  Copy them to the StorageRingOpsData directory using plotfamily.
% 8. Get tune family working
% 9. Check the BPM delay and set getbpmaverages accordingly.
%    (Edit and try magstep to test the timing.)
%10. getnames_bessy2 needs to be filled with channels names


% NOTES & COMMENTS
% 1. Magnet positions get overwritten in updateatindex.  
%    Ie, positions will come directly from the AT model.
% 2. The units from .DeltaRespMat start in physics units then get converted at the end. 
% 3. If you are not already doing it, I would recommend using LabCA!!!


% Functions to test:
% 1. Try mmlviewer to view and check the MML setup.
% 2. Try measbpmresp, meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model (no noise).
% 3. Try setorbitgui, steptune, stepchro, ...
% 4. To run LOCO
%    1. Measure new data
%       >> measlocodata
%       For the model use
%       >> measlocodata('model');
%    2. Build the LOCO input file
%       >> buildlocoinput
%    3. Run LOCO
%       >> loco
%    4. To set back to the machine see setlocodata (may need some work)
%       >> setlocodata
% 5. Try meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model.


if nargin < 1
    OperationalMode = 1;
end


% Clear the AO 
setao([]); 


% Build common devicelist
OnePerSector = [];
TwoPerSector = [];
BPMlist = [];
HCMlist = [ones(127,1) (1:127)'];  % Not correct, but I need something here
VCMlist = [ones(107,1) (1:107)'];  % Not correct, but I need something here
CQSlist = [ones(15,1)  (1:15)' ];  % Not correct, but I need something here

for Sector = 1:16
    BPMlist = [
        BPMlist;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];

    OnePerSector = [
        OnePerSector;
        Sector 1;];

    TwoPerSector = [
        TwoPerSector;
        Sector 1;
        Sector 2;];
end


%%%%%%%%%%%%%%%
%  BPMx/BPMy  %
%%%%%%%%%%%%%%%

% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = BPMlist;
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
% AO.BPMx.CommonNames = '';

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_bessy2(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';

AO.BPMx.Cross.MemberOf = {'BPMx'; 'Cross';};
AO.BPMx.Cross.Mode = 'Simulator';
AO.BPMx.Cross.DataType = 'Vector';
AO.BPMx.Cross.DataTypeIndex = [1:size(AO.BPMx.DeviceList,1)];
AO.BPMx.Cross.ChannelNames = getname_bessy2(AO.BPMx.FamilyName, 'Cross', AO.BPMx.DeviceList);
AO.BPMx.Cross.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Cross.Physics2HWParams = 1000;
AO.BPMx.Cross.Units        = 'Hardware';
AO.BPMx.Cross.HWUnits      = 'mm';
AO.BPMx.Cross.PhysicsUnits = 'meter';
AO.BPMx.Cross.SpecialFunctionGet = 'getbpmq';

AO.BPMx.Sum.MemberOf = {'BPMx'; 'Sum';};
AO.BPMx.Sum.Mode = 'Simulator';
AO.BPMx.Sum.DataType = 'Vector';
AO.BPMx.Sum.DataTypeIndex = [1:size(AO.BPMx.DeviceList,1)];
AO.BPMx.Sum.ChannelNames = getname_bessy2(AO.BPMx.FamilyName, 'Sum', AO.BPMx.DeviceList);;
AO.BPMx.Sum.HW2PhysicsParams = 1;
AO.BPMx.Sum.Physics2HWParams = 1;
AO.BPMx.Sum.Units        = 'Hardware';
AO.BPMx.Sum.HWUnits      = 'ADC Counts';
AO.BPMx.Sum.PhysicsUnits = 'ADC Counts';
AO.BPMx.Sum.SpecialFunctionGet = 'getbpmsum';  % Returns the BPM button voltage sum


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = BPMlist;
AO.BPMy.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMy.Position    = [];
% AO.BPMy.CommonNames = '';

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_bessy2(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';

AO.BPMy.Cross.MemberOf = {'BPMy'; 'Cross';};
AO.BPMy.Cross.Mode = 'Simulator';
AO.BPMy.Cross.DataType = 'Vector';
AO.BPMy.Cross.DataTypeIndex = [1:size(AO.BPMy.DeviceList,1)];
AO.BPMy.Cross.ChannelNames = getname_bessy2(AO.BPMy.FamilyName, 'Cross', AO.BPMy.DeviceList);
AO.BPMy.Cross.HW2PhysicsParams = 1e-3;
AO.BPMy.Cross.Physics2HWParams = 1000;
AO.BPMy.Cross.Units        = 'Hardware';
AO.BPMy.Cross.HWUnits      = 'mm';
AO.BPMy.Cross.PhysicsUnits = 'meter';
AO.BPMy.Cross.SpecialFunctionGet = 'getbpmq';

AO.BPMy.Sum.MemberOf = {'BPMy'; 'Sum';};
AO.BPMy.Sum.Mode = 'Simulator';
AO.BPMy.Sum.DataType = 'Vector';
AO.BPMy.Sum.DataTypeIndex = [1:size(AO.BPMy.DeviceList,1)];
AO.BPMy.Sum.ChannelNames = getname_bessy2(AO.BPMy.FamilyName, 'Sum', AO.BPMy.DeviceList);
AO.BPMy.Sum.HW2PhysicsParams = 1;
AO.BPMy.Sum.Physics2HWParams = 1;
AO.BPMy.Sum.Units        = 'Hardware';
AO.BPMy.Sum.HWUnits      = 'ADC Counts';
AO.BPMy.Sum.PhysicsUnits = 'ADC Counts';
AO.BPMy.Sum.SpecialFunctionGet = 'getbpmsum';  % Returns the BPM button voltage sum



%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = HCMlist;
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];
% AO.HCM.CommonNames = '';

AO.HCM.Monitor.MemberOf = {'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Monitor';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_bessy2(AO.HCM.FamilyName, 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @bessy2at;
AO.HCM.Monitor.Physics2HWFcn = @at2bessy;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_bessy2(AO.HCM.FamilyName, 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2bessy;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-Inf Inf];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 100-6;
 

% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = VCMlist;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
% AO.VCM.CommonNames = '';

AO.VCM.Monitor.MemberOf = {'COR'; 'Vertical'; 'VCM'; 'Magnet'; 'Monitor';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_bessy2(AO.VCM.FamilyName, 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @bessy2at;
AO.VCM.Monitor.Physics2HWFcn = @at2bessy;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'Vertical'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_bessy2(AO.VCM.FamilyName, 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2bessy;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-Inf Inf];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = 100e-6;



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%
AO.Q1.FamilyName  = 'Q1';
AO.Q1.MemberOf    = {'PlotFamily'; 'Q1'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.Q1.DeviceList  = TwoPerSector;
AO.Q1.ElementList = (1:size(AO.Q1.DeviceList,1))';
AO.Q1.Status      = ones(size(AO.Q1.DeviceList,1),1);
AO.Q1.Position    = [];
% AO.Q1.CommonNames = '';

AO.Q1.Monitor.MemberOf = {};
AO.Q1.Monitor.Mode = 'Simulator';
AO.Q1.Monitor.DataType = 'Scalar';
AO.Q1.Monitor.ChannelNames = getname_bessy2(AO.Q1.FamilyName, 'Monitor', AO.Q1.DeviceList);
AO.Q1.Monitor.HW2PhysicsFcn = @bessy2at;
AO.Q1.Monitor.Physics2HWFcn = @at2bessy;
AO.Q1.Monitor.Units        = 'Hardware';
AO.Q1.Monitor.HWUnits      = 'Ampere';
AO.Q1.Monitor.PhysicsUnits = 'meter^-2';

AO.Q1.Setpoint.MemberOf = {'MachineConfig';};
AO.Q1.Setpoint.Mode = 'Simulator';
AO.Q1.Setpoint.DataType = 'Scalar';
AO.Q1.Setpoint.ChannelNames = getname_bessy2(AO.Q1.FamilyName, 'Setpoint', AO.Q1.DeviceList);
AO.Q1.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.Q1.Setpoint.Physics2HWFcn = @at2bessy;
AO.Q1.Setpoint.Units        = 'Hardware';
AO.Q1.Setpoint.HWUnits      = 'Ampere';
AO.Q1.Setpoint.PhysicsUnits = 'meter^-2';
AO.Q1.Setpoint.Range        = [-Inf Inf];
AO.Q1.Setpoint.Tolerance    = .1;
AO.Q1.Setpoint.DeltaRespMat = .01;


% Q2
AO.Q2.FamilyName  = 'Q2';
AO.Q2.MemberOf    = {'PlotFamily'; 'Q2'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.Q2.DeviceList  = TwoPerSector;
AO.Q2.ElementList = (1:size(AO.Q2.DeviceList,1))';
AO.Q2.Status      = ones(size(AO.Q2.DeviceList,1),1);
AO.Q2.Position    = [];
% AO.Q2.CommonNames = '';

AO.Q2.Monitor.MemberOf = {};
AO.Q2.Monitor.Mode = 'Simulator';
AO.Q2.Monitor.DataType = 'Scalar';
AO.Q2.Monitor.ChannelNames = getname_bessy2(AO.Q2.FamilyName, 'Monitor', AO.Q2.DeviceList);
AO.Q2.Monitor.HW2PhysicsFcn = @bessy2at;
AO.Q2.Monitor.Physics2HWFcn = @at2bessy;
AO.Q2.Monitor.Units        = 'Hardware';
AO.Q2.Monitor.HWUnits      = 'Ampere';
AO.Q2.Monitor.PhysicsUnits = 'meter^-2';

AO.Q2.Setpoint.MemberOf = {'MachineConfig';};
AO.Q2.Setpoint.Mode = 'Simulator';
AO.Q2.Setpoint.DataType = 'Scalar';
AO.Q2.Setpoint.ChannelNames = getname_bessy2(AO.Q2.FamilyName, 'Setpoint', AO.Q2.DeviceList);
AO.Q2.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.Q2.Setpoint.Physics2HWFcn = @at2bessy;
AO.Q2.Setpoint.Units        = 'Hardware';
AO.Q2.Setpoint.HWUnits      = 'Ampere';
AO.Q2.Setpoint.PhysicsUnits = 'meter^-2';
AO.Q2.Setpoint.Range        = [-Inf Inf];
AO.Q2.Setpoint.Tolerance    = .1;
AO.Q2.Setpoint.DeltaRespMat = .01;


% Q3
AO.Q3.FamilyName  = 'Q3';
AO.Q3.MemberOf    = {'PlotFamily'; 'Q3'; 'QUAD'; 'Magnet'; 'Dispersion Corrector';};
AO.Q3.DeviceList  = TwoPerSector;
AO.Q3.ElementList = (1:size(AO.Q3.DeviceList,1))';
AO.Q3.Status      = ones(size(AO.Q3.DeviceList,1),1);
AO.Q3.Position    = [];
% AO.Q3.CommonNames = '';

AO.Q3.Monitor.MemberOf = {};
AO.Q3.Monitor.Mode = 'Simulator';
AO.Q3.Monitor.DataType = 'Scalar';
AO.Q3.Monitor.ChannelNames = getname_bessy2(AO.Q3.FamilyName, 'Monitor', AO.Q3.DeviceList);
AO.Q3.Monitor.HW2PhysicsFcn = @bessy2at;
AO.Q3.Monitor.Physics2HWFcn = @at2bessy;
AO.Q3.Monitor.Units        = 'Hardware';
AO.Q3.Monitor.HWUnits      = 'Ampere';
AO.Q3.Monitor.PhysicsUnits = 'meter^-2';

AO.Q3.Setpoint.MemberOf = {'MachineConfig';};
AO.Q3.Setpoint.Mode = 'Simulator';
AO.Q3.Setpoint.DataType = 'Scalar';
AO.Q3.Setpoint.ChannelNames = getname_bessy2(AO.Q3.FamilyName, 'Setpoint', AO.Q3.DeviceList);
AO.Q3.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.Q3.Setpoint.Physics2HWFcn = @at2bessy;
AO.Q3.Setpoint.Units        = 'Hardware';
AO.Q3.Setpoint.HWUnits      = 'Ampere';
AO.Q3.Setpoint.PhysicsUnits = 'meter^-2';
AO.Q3.Setpoint.Range        = [-Inf Inf];
AO.Q3.Setpoint.Tolerance    = .1;
AO.Q3.Setpoint.DeltaRespMat = .01;


% Q4
AO.Q4.FamilyName  = 'Q4';
AO.Q4.MemberOf    = {'PlotFamily'; 'Q4'; 'QUAD'; 'Magnet'; 'Dispersion Corrector';};
AO.Q4.DeviceList  = TwoPerSector;
AO.Q4.ElementList = (1:size(AO.Q4.DeviceList,1))';
AO.Q4.Status      = ones(size(AO.Q4.DeviceList,1),1);
AO.Q4.Position    = [];
% AO.Q4.CommonNames = '';

AO.Q4.Monitor.MemberOf = {};
AO.Q4.Monitor.Mode = 'Simulator';
AO.Q4.Monitor.DataType = 'Scalar';
AO.Q4.Monitor.ChannelNames = getname_bessy2(AO.Q4.FamilyName, 'Monitor', AO.Q4.DeviceList);
AO.Q4.Monitor.HW2PhysicsFcn = @bessy2at;
AO.Q4.Monitor.Physics2HWFcn = @at2bessy;
AO.Q4.Monitor.Units        = 'Hardware';
AO.Q4.Monitor.HWUnits      = 'Ampere';
AO.Q4.Monitor.PhysicsUnits = 'meter^-2';

AO.Q4.Setpoint.MemberOf = {'MachineConfig';};
AO.Q4.Setpoint.Mode = 'Simulator';
AO.Q4.Setpoint.DataType = 'Scalar';
AO.Q4.Setpoint.ChannelNames = getname_bessy2(AO.Q4.FamilyName, 'Setpoint', AO.Q4.DeviceList);
AO.Q4.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.Q4.Setpoint.Physics2HWFcn = @at2bessy;
AO.Q4.Setpoint.Units        = 'Hardware';
AO.Q4.Setpoint.HWUnits      = 'Ampere';
AO.Q4.Setpoint.PhysicsUnits = 'meter^-2';
AO.Q4.Setpoint.Range        = [-Inf Inf];
AO.Q4.Setpoint.Tolerance    = .1;
AO.Q4.Setpoint.DeltaRespMat = .01;


% Q5
AO.Q5.FamilyName  = 'Q5';
AO.Q5.MemberOf    = {'PlotFamily'; 'Q5'; 'QUAD'; 'Magnet'; 'Dispersion Corrector';};
AO.Q5.DeviceList  = OnePerSector;
AO.Q5.ElementList = (1:size(AO.Q5.DeviceList,1))';
AO.Q5.Status      = ones(size(AO.Q5.DeviceList,1),1);
AO.Q5.Position    = [];
% AO.Q5.CommonNames = '';

AO.Q5.Monitor.MemberOf = {};
AO.Q5.Monitor.Mode = 'Simulator';
AO.Q5.Monitor.DataType = 'Scalar';
AO.Q5.Monitor.ChannelNames = getname_bessy2(AO.Q5.FamilyName, 'Monitor', AO.Q5.DeviceList);
AO.Q5.Monitor.HW2PhysicsFcn = @bessy2at;
AO.Q5.Monitor.Physics2HWFcn = @at2bessy;
AO.Q5.Monitor.Units        = 'Hardware';
AO.Q5.Monitor.HWUnits      = 'Ampere';
AO.Q5.Monitor.PhysicsUnits = 'meter^-2';

AO.Q5.Setpoint.MemberOf = {'MachineConfig';};
AO.Q5.Setpoint.Mode = 'Simulator';
AO.Q5.Setpoint.DataType = 'Scalar';
AO.Q5.Setpoint.ChannelNames = getname_bessy2(AO.Q5.FamilyName, 'Setpoint', AO.Q5.DeviceList);
AO.Q5.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.Q5.Setpoint.Physics2HWFcn = @at2bessy;
AO.Q5.Setpoint.Units        = 'Hardware';
AO.Q5.Setpoint.HWUnits      = 'Ampere';
AO.Q5.Setpoint.PhysicsUnits = 'meter^-2';
AO.Q5.Setpoint.Range        = [-Inf Inf];
AO.Q5.Setpoint.Tolerance    = .1;
AO.Q5.Setpoint.DeltaRespMat = .01;



%===========
% Sextupoles
%===========

% S1
AO.S1.FamilyName  = 'S1';
AO.S1.MemberOf    = {'PlotFamily'; 'S1'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.S1.DeviceList  = OnePerSector;
AO.S1.ElementList = (1:size(AO.S1.DeviceList,1))';
AO.S1.Status      = ones(size(AO.S1.DeviceList,1),1);
AO.S1.Position    = [];
% AO.S1.CommonNames = '';

AO.S1.Monitor.MemberOf = {};
AO.S1.Monitor.Mode = 'Simulator';
AO.S1.Monitor.DataType = 'Scalar';
AO.S1.Monitor.ChannelNames = getname_bessy2(AO.S1.FamilyName, 'Monitor', AO.S1.DeviceList);
AO.S1.Monitor.HW2PhysicsFcn = @bessy2at;
AO.S1.Monitor.Physics2HWFcn = @at2bessy;
AO.S1.Monitor.Units        = 'Hardware';
AO.S1.Monitor.HWUnits      = 'Ampere';
AO.S1.Monitor.PhysicsUnits = 'meter^-3';

AO.S1.Setpoint.MemberOf = {'MachineConfig';};
AO.S1.Setpoint.Mode = 'Simulator';
AO.S1.Setpoint.DataType = 'Scalar';
AO.S1.Setpoint.ChannelNames = getname_bessy2(AO.S1.FamilyName, 'Setpoint', AO.S1.DeviceList);
AO.S1.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.S1.Setpoint.Physics2HWFcn = @at2bessy;
AO.S1.Setpoint.Units        = 'Hardware';
AO.S1.Setpoint.HWUnits      = 'Ampere';
AO.S1.Setpoint.PhysicsUnits = 'meter^-3';
AO.S1.Setpoint.Range        = [-Inf Inf];
AO.S1.Setpoint.Tolerance    = .1;
AO.S1.Setpoint.DeltaRespMat = .01;


% S2
AO.S2.FamilyName  = 'S2';
AO.S2.MemberOf    = {'PlotFamily'; 'S2'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.S2.DeviceList  = TwoPerSector;
AO.S2.ElementList = (1:size(AO.S2.DeviceList,1))';
AO.S2.Status      = ones(size(AO.S2.DeviceList,1),1);
AO.S2.Position    = [];
% AO.S2.CommonNames = '';

AO.S2.Monitor.MemberOf = {};
AO.S2.Monitor.Mode = 'Simulator';
AO.S2.Monitor.DataType = 'Scalar';
AO.S2.Monitor.ChannelNames = getname_bessy2(AO.S2.FamilyName, 'Monitor', AO.S2.DeviceList);
AO.S2.Monitor.HW2PhysicsFcn = @bessy2at;
AO.S2.Monitor.Physics2HWFcn = @at2bessy;
AO.S2.Monitor.Units        = 'Hardware';
AO.S2.Monitor.HWUnits      = 'Ampere';
AO.S2.Monitor.PhysicsUnits = 'meter^-3';

AO.S2.Setpoint.MemberOf = {'MachineConfig';};
AO.S2.Setpoint.Mode = 'Simulator';
AO.S2.Setpoint.DataType = 'Scalar';
AO.S2.Setpoint.ChannelNames = getname_bessy2(AO.S2.FamilyName, 'Setpoint', AO.S2.DeviceList);
AO.S2.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.S2.Setpoint.Physics2HWFcn = @at2bessy;
AO.S2.Setpoint.Units        = 'Hardware';
AO.S2.Setpoint.HWUnits      = 'Ampere';
AO.S2.Setpoint.PhysicsUnits = 'meter^-3';
AO.S2.Setpoint.Range        = [-Inf Inf];
AO.S2.Setpoint.Tolerance    = .1;
AO.S2.Setpoint.DeltaRespMat = .01;


% S3
AO.S3.FamilyName  = 'S3';
AO.S3.MemberOf    = {'PlotFamily'; 'S3'; 'HSD'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole';};
AO.S3.DeviceList  = TwoPerSector;
AO.S3.ElementList = (1:size(AO.S3.DeviceList,1))';
AO.S3.Status      = ones(size(AO.S3.DeviceList,1),1);
AO.S3.Position    = [];
% AO.S3.CommonNames = '';

AO.S3.Monitor.MemberOf = {};
AO.S3.Monitor.Mode = 'Simulator';
AO.S3.Monitor.DataType = 'Scalar';
AO.S3.Monitor.ChannelNames = getname_bessy2(AO.S3.FamilyName, 'Monitor', AO.S3.DeviceList);
AO.S3.Monitor.HW2PhysicsFcn = @bessy2at;
AO.S3.Monitor.Physics2HWFcn = @at2bessy;
AO.S3.Monitor.Units        = 'Hardware';
AO.S3.Monitor.HWUnits      = 'Ampere';
AO.S3.Monitor.PhysicsUnits = 'meter^-3';

AO.S3.Setpoint.MemberOf = {'MachineConfig';};
AO.S3.Setpoint.Mode = 'Simulator';
AO.S3.Setpoint.DataType = 'Scalar';
AO.S3.Setpoint.ChannelNames = getname_bessy2(AO.S3.FamilyName, 'Setpoint', AO.S3.DeviceList);
AO.S3.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.S3.Setpoint.Physics2HWFcn = @at2bessy;
AO.S3.Setpoint.Units        = 'Hardware';
AO.S3.Setpoint.HWUnits      = 'Ampere';
AO.S3.Setpoint.PhysicsUnits = 'meter^-3';
AO.S3.Setpoint.Range        = [-Inf Inf];
AO.S3.Setpoint.Tolerance    = .1;
AO.S3.Setpoint.DeltaRespMat = .01;


% S4
AO.S4.FamilyName  = 'S4';
AO.S4.MemberOf    = {'PlotFamily'; 'S4'; 'HSD'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole';};
AO.S4.DeviceList  = TwoPerSector;
AO.S4.ElementList = (1:size(AO.S4.DeviceList,1))';
AO.S4.Status      = ones(size(AO.S4.DeviceList,1),1);
AO.S4.Position    = [];
% AO.S4.CommonNames = '';

AO.S4.Monitor.MemberOf = {};
AO.S4.Monitor.Mode = 'Simulator';
AO.S4.Monitor.DataType = 'Scalar';
AO.S4.Monitor.ChannelNames = getname_bessy2(AO.S4.FamilyName, 'Monitor', AO.S4.DeviceList);
AO.S4.Monitor.HW2PhysicsFcn = @bessy2at;
AO.S4.Monitor.Physics2HWFcn = @at2bessy;
AO.S4.Monitor.Units        = 'Hardware';
AO.S4.Monitor.HWUnits      = 'Ampere';
AO.S4.Monitor.PhysicsUnits = 'meter^-3';

AO.S4.Setpoint.MemberOf = {'MachineConfig';};
AO.S4.Setpoint.Mode = 'Simulator';
AO.S4.Setpoint.DataType = 'Scalar';
AO.S4.Setpoint.ChannelNames = getname_bessy2(AO.S4.FamilyName, 'Setpoint', AO.S4.DeviceList);
AO.S4.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.S4.Setpoint.Physics2HWFcn = @at2bessy;
AO.S4.Setpoint.Units        = 'Hardware';
AO.S4.Setpoint.HWUnits      = 'Ampere';
AO.S4.Setpoint.PhysicsUnits = 'meter^-3';
AO.S4.Setpoint.Range        = [-Inf Inf];
AO.S4.Setpoint.Tolerance    = .1;
AO.S4.Setpoint.DeltaRespMat = .01;



%%%%%%%%%%
%  BEND  %
%%%%%%%%%%
AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BEND.DeviceList  = TwoPerSector;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status      = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position    = [];
% AO.BEND.CommonNames = '';

AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_bessy2(AO.BEND.FamilyName, 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @bend2gev;
AO.BEND.Monitor.Physics2HWFcn = @gev2bend;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_bessy2(AO.BEND.FamilyName, 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn = @gev2bend;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.Range        = [-Inf Inf];
AO.BEND.Setpoint.Tolerance    = .1;
AO.BEND.Setpoint.DeltaRespMat = .01;



%%%%%%%%%%%%%
% Skew Quad %
%%%%%%%%%%%%%
AO.CQS.FamilyName  = 'CQS';
AO.CQS.MemberOf    = {'PlotFamily'; 'CQS'; 'SKEWQUAD'; 'Magnet';};
AO.CQS.DeviceList  = CQSlist;
AO.CQS.ElementList = (1:size(AO.CQS.DeviceList,1))';
AO.CQS.Status      = ones(size(AO.CQS.DeviceList,1),1);
AO.CQS.Position    = [];
% AO.CQS.CommonNames = '';

AO.CQS.Monitor.MemberOf = {};
AO.CQS.Monitor.Mode = 'Simulator';
AO.CQS.Monitor.DataType = 'Scalar';
AO.CQS.Monitor.ChannelNames = getname_bessy2(AO.CQS.FamilyName, 'Monitor', AO.CQS.DeviceList);
AO.CQS.Monitor.HW2PhysicsFcn = @bessy2at;
AO.CQS.Monitor.Physics2HWFcn = @at2bessy;
AO.CQS.Monitor.Units        = 'Hardware';
AO.CQS.Monitor.HWUnits      = 'Ampere';
AO.CQS.Monitor.PhysicsUnits = 'meter^-2';

AO.CQS.Setpoint.MemberOf = {'MachineConfig';};
AO.CQS.Setpoint.Mode = 'Simulator';
AO.CQS.Setpoint.DataType = 'Scalar';
AO.CQS.Setpoint.ChannelNames = getname_bessy2(AO.CQS.FamilyName, 'Setpoint', AO.CQS.DeviceList);
AO.CQS.Setpoint.HW2PhysicsFcn = @bessy2at;
AO.CQS.Setpoint.Physics2HWFcn = @at2bessy;
AO.CQS.Setpoint.Units        = 'Hardware';
AO.CQS.Setpoint.HWUnits      = 'Ampere';
AO.CQS.Setpoint.PhysicsUnits = 'meter^-2';
AO.CQS.Setpoint.Range        = [-Inf Inf];
AO.CQS.Setpoint.Tolerance    = .1;
AO.CQS.Setpoint.DeltaRespMat = .01;



%%%%%%%%%
%   RF  %
%%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;
% AO.RF.CommonNames               = 'RF';

AO.RF.Monitor.MemberOf         = {};
AO.RF.Monitor.Mode             = 'Simulator';
AO.RF.Monitor.DataType         = 'Scalar';
AO.RF.Monitor.ChannelNames     = '';
AO.RF.Monitor.HW2PhysicsParams = 1e+6;
AO.RF.Monitor.Physics2HWParams = 1e-6;
AO.RF.Monitor.Units            = 'Hardware';
AO.RF.Monitor.HWUnits          = 'MHz';
AO.RF.Monitor.PhysicsUnits     = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.ChannelNames     = '';
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [0 500000];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.VoltageCtrl.MemberOf         = {};
AO.RF.VoltageCtrl.Mode             = 'Simulator';
AO.RF.VoltageCtrl.DataType         = 'Scalar';
AO.RF.VoltageCtrl.ChannelNames     = 'PAHRP:setVoltCav';
AO.RF.VoltageCtrl.HW2PhysicsParams = 1;
AO.RF.VoltageCtrl.Physics2HWParams = 1;
AO.RF.VoltageCtrl.Units            = 'Hardware';
AO.RF.VoltageCtrl.HWUnits          = 'Volts';
AO.RF.VoltageCtrl.PhysicsUnits     = 'Volts';



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 23.2555;
% AO.DCCT.CommonNames              = 'DCCT';

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = '';    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'milli-ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'ampere';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
% AO.TUNE.CommonNames = 'TUNE';

AO.TUNE.Monitor.MemberOf   = {'TUNE';};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.ChannelNames = '';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_bessy2';


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Convert to hardware units
% 'NoEnergyScaling' is needed so that the BEND is not read to get the energy (this is a setup file)  
AO.HCM.Setpoint.DeltaRespMat  = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat,  AO.HCM.DeviceList,  'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat  = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat,  AO.VCM.DeviceList,  'NoEnergyScaling');
AO.Q1.Setpoint.DeltaRespMat   = physics2hw('Q1',  'Setpoint', AO.Q1.Setpoint.DeltaRespMat,   AO.Q1.DeviceList,   'NoEnergyScaling');
AO.Q2.Setpoint.DeltaRespMat   = physics2hw('Q2',  'Setpoint', AO.Q2.Setpoint.DeltaRespMat,   AO.Q2.DeviceList,   'NoEnergyScaling');
AO.Q3.Setpoint.DeltaRespMat   = physics2hw('Q3',  'Setpoint', AO.Q3.Setpoint.DeltaRespMat,   AO.Q3.DeviceList,   'NoEnergyScaling');
AO.Q4.Setpoint.DeltaRespMat   = physics2hw('Q4',  'Setpoint', AO.Q4.Setpoint.DeltaRespMat,   AO.Q4.DeviceList,   'NoEnergyScaling');
AO.Q5.Setpoint.DeltaRespMat   = physics2hw('Q5', 'Setpoint',  AO.Q5.Setpoint.DeltaRespMat,   AO.Q5.DeviceList,   'NoEnergyScaling');
AO.CQS.Setpoint.DeltaRespMat  = physics2hw('CQS', 'Setpoint', AO.CQS.Setpoint.DeltaRespMat,  AO.CQS.DeviceList,  'NoEnergyScaling');
AO.S1.Setpoint.DeltaRespMat   = physics2hw('S1',  'Setpoint', AO.S1.Setpoint.DeltaRespMat,   AO.S1.DeviceList,   'NoEnergyScaling');
AO.S2.Setpoint.DeltaRespMat   = physics2hw('S2',  'Setpoint', AO.S2.Setpoint.DeltaRespMat,   AO.S2.DeviceList,   'NoEnergyScaling');
AO.S3.Setpoint.DeltaRespMat   = physics2hw('S3', ' Setpoint', AO.S3.Setpoint.DeltaRespMat,   AO.S3.DeviceList,   'NoEnergyScaling');
AO.S4.Setpoint.DeltaRespMat   = physics2hw('S4', ' Setpoint', AO.S4.Setpoint.DeltaRespMat,   AO.S4.DeviceList,   'NoEnergyScaling');
setao(AO);


