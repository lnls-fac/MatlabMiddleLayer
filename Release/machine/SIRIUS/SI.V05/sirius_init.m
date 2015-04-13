function sirius_init(OperationalMode)
%LNLSINIT - MML initialization file for the VUV ring at sirius3
%  lnlsinit(OperationalMode)
%
%  See also setoperationalmode

% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso




if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);



% Base on the location of this file
[SIRIUS_ROOT, FileName, ExtentionName] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);

% Add additional directories with SIRIUS_V03 specific stuff.
MMLROOT = getmmlroot('IgnoreTheAD');
%addpath(fullfile(MMLROOT,'machine','SIRIUS_V03','StorageRing','scripts'), '-begin');

% Get the device lists (local function)
%[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists;


% BENDS

AO.b1.FamilyName  = 'b1';
AO.b1.MemberOf    = {'PlotFamily'; 'b1'; 'BEND'; 'Magnet';};
AO.b1.DeviceList  = getDeviceList(10,4);
AO.b1.ElementList = (1:size(AO.b1.DeviceList,1))';
AO.b1.Status      = ones(size(AO.b1.DeviceList,1),1);
AO.b1.Position    = [];

AO.b1.Monitor.MemberOf = {};
AO.b1.Monitor.Mode = 'Simulator';
AO.b1.Monitor.DataType = 'Scalar';
AO.b1.Monitor.ChannelNames = sirius_getname(AO.b1.FamilyName, 'Monitor', AO.b1.DeviceList);
AO.b1.Monitor.HW2PhysicsParams = 1;
AO.b1.Monitor.Physics2HWParams = 1;
AO.b1.Monitor.Units        = 'Hardware';
AO.b1.Monitor.HWUnits      = 'Ampere';
AO.b1.Monitor.PhysicsUnits = 'GeV';

AO.b1.Setpoint.MemberOf = {'MachineConfig';};
AO.b1.Setpoint.Mode = 'Simulator';
AO.b1.Setpoint.DataType = 'Scalar';
AO.b1.Setpoint.ChannelNames = sirius_getname(AO.b1.FamilyName, 'Setpoint', AO.b1.DeviceList);
AO.b1.Setpoint.HW2PhysicsParams = 1;
AO.b1.Setpoint.Physics2HWParams = 1;
AO.b1.Setpoint.Units        = 'Hardware';
AO.b1.Setpoint.HWUnits      = 'Ampere';
AO.b1.Setpoint.PhysicsUnits = 'GeV';
AO.b1.Setpoint.Range        = [0 300];
AO.b1.Setpoint.Tolerance    = .1;
AO.b1.Setpoint.DeltaRespMat = .01;


AO.b2.FamilyName  = 'b2';
AO.b2.MemberOf    = {'PlotFamily'; 'b2'; 'BEND'; 'Magnet';};
AO.b2.DeviceList  = getDeviceList(10,4);
AO.b2.ElementList = (1:size(AO.b2.DeviceList,1))';
AO.b2.Status      = ones(size(AO.b2.DeviceList,1),1);
AO.b2.Position    = [];

AO.b2.Monitor.MemberOf = {};
AO.b2.Monitor.Mode = 'Simulator';
AO.b2.Monitor.DataType = 'Scalar';
AO.b2.Monitor.ChannelNames = sirius_getname(AO.b2.FamilyName, 'Monitor', AO.b2.DeviceList);
AO.b2.Monitor.HW2PhysicsParams = 1;
AO.b2.Monitor.Physics2HWParams = 1;
AO.b2.Monitor.Units        = 'Hardware';
AO.b2.Monitor.HWUnits      = 'Ampere';
AO.b2.Monitor.PhysicsUnits = 'GeV';

AO.b2.Setpoint.MemberOf = {'MachineConfig';};
AO.b2.Setpoint.Mode = 'Simulator';
AO.b2.Setpoint.DataType = 'Scalar';
AO.b2.Setpoint.ChannelNames = sirius_getname(AO.b2.FamilyName, 'Setpoint', AO.b2.DeviceList);
AO.b2.Setpoint.HW2PhysicsParams = 1;
AO.b2.Setpoint.Physics2HWParams = 1;
AO.b2.Setpoint.Units        = 'Hardware';
AO.b2.Setpoint.HWUnits      = 'Ampere';
AO.b2.Setpoint.PhysicsUnits = 'GeV';
AO.b2.Setpoint.Range        = [0 300];
AO.b2.Setpoint.Tolerance    = .1;
AO.b2.Setpoint.DeltaRespMat = .01;


AO.b3.FamilyName  = 'b3';
AO.b3.MemberOf    = {'PlotFamily'; 'b3'; 'BEND'; 'Magnet';};
AO.b3.DeviceList  = getDeviceList(10,4);
AO.b3.ElementList = (1:size(AO.b3.DeviceList,1))';
AO.b3.Status      = ones(size(AO.b3.DeviceList,1),1);
AO.b3.Position    = [];

AO.b3.Monitor.MemberOf = {};
AO.b3.Monitor.Mode = 'Simulator';
AO.b3.Monitor.DataType = 'Scalar';
AO.b3.Monitor.ChannelNames = sirius_getname(AO.b3.FamilyName, 'Monitor', AO.b3.DeviceList);
AO.b3.Monitor.HW2PhysicsParams = 1;
AO.b3.Monitor.Physics2HWParams = 1;
AO.b3.Monitor.Units        = 'Hardware';
AO.b3.Monitor.HWUnits      = 'Ampere';
AO.b3.Monitor.PhysicsUnits = 'GeV';

AO.b3.Setpoint.MemberOf = {'MachineConfig';};
AO.b3.Setpoint.Mode = 'Simulator';
AO.b3.Setpoint.DataType = 'Scalar';
AO.b3.Setpoint.ChannelNames = sirius_getname(AO.b3.FamilyName, 'Setpoint', AO.b3.DeviceList);
AO.b3.Setpoint.HW2PhysicsParams = 1;
AO.b3.Setpoint.Physics2HWParams = 1;
AO.b3.Setpoint.Units        = 'Hardware';
AO.b3.Setpoint.HWUnits      = 'Ampere';
AO.b3.Setpoint.PhysicsUnits = 'GeV';
AO.b3.Setpoint.Range        = [0 300];
AO.b3.Setpoint.Tolerance    = .1;
AO.b3.Setpoint.DeltaRespMat = .01;


AO.bc.FamilyName  = 'bc';
AO.bc.MemberOf    = {'PlotFamily'; 'bc'; 'BEND'; 'Magnet';};
AO.bc.DeviceList  = getDeviceList(10,2);
AO.bc.ElementList = (1:size(AO.bc.DeviceList,1))';
AO.bc.Status      = ones(size(AO.bc.DeviceList,1),1);
AO.bc.Position    = [];

AO.bc.Monitor.MemberOf = {};
AO.bc.Monitor.Mode = 'Simulator';
AO.bc.Monitor.DataType = 'Scalar';
AO.bc.Monitor.ChannelNames = sirius_getname(AO.bc.FamilyName, 'Monitor', AO.bc.DeviceList);
AO.bc.Monitor.HW2PhysicsParams = 1;
AO.bc.Monitor.Physics2HWParams = 1;
AO.bc.Monitor.Units        = 'Hardware';
AO.bc.Monitor.HWUnits      = 'Ampere';
AO.bc.Monitor.PhysicsUnits = 'GeV';

AO.bc.Setpoint.MemberOf = {'MachineConfig';};
AO.bc.Setpoint.Mode = 'Simulator';
AO.bc.Setpoint.DataType = 'Scalar';
AO.bc.Setpoint.ChannelNames = sirius_getname(AO.bc.FamilyName, 'Setpoint', AO.bc.DeviceList);
AO.bc.Setpoint.HW2PhysicsParams = 1;
AO.bc.Setpoint.Physics2HWParams = 1;
AO.bc.Setpoint.Units        = 'Hardware';
AO.bc.Setpoint.HWUnits      = 'Ampere';
AO.bc.Setpoint.PhysicsUnits = 'GeV';
AO.bc.Setpoint.Range        = [0 300];
AO.bc.Setpoint.Tolerance    = .1;
AO.bc.Setpoint.DeltaRespMat = .01;


AO.qfa.FamilyName = 'qfa';
AO.qfa.MemberOf    = {'PlotFamily'; 'qfa'; 'QUAD'; 'Magnet';};
AO.qfa.DeviceList  = getDeviceList(10,2);
AO.qfa.ElementList = (1:size(AO.qfa.DeviceList,1))';
AO.qfa.Status      = ones(size(AO.qfa.DeviceList,1),1);
AO.qfa.Position    = [];
AO.qfa.Monitor.MemberOf = {};
AO.qfa.Monitor.Mode = 'Simulator';
AO.qfa.Monitor.DataType = 'Scalar';
AO.qfa.Monitor.Units        = 'Hardware';
AO.qfa.Monitor.HWUnits      = 'Ampere';
AO.qfa.Monitor.PhysicsUnits = 'meter^-2';
AO.qfa.Setpoint.MemberOf      = {'MachineConfig'};
AO.qfa.Setpoint.Mode          = 'Simulator';
AO.qfa.Setpoint.DataType      = 'Scalar';
AO.qfa.Setpoint.Units         = 'Hardware';
AO.qfa.Setpoint.HWUnits       = 'Ampere';
AO.qfa.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qfa.Setpoint.Range         = [0 225];
AO.qfa.Setpoint.Tolerance     = 0.2;
AO.qfa.Setpoint.DeltaRespMat  = 0.5; 

AO.qdb2.FamilyName = 'qdb2';
AO.qdb2.MemberOf    = {'PlotFamily'; 'qdb2'; 'QUAD'; 'Magnet';};
AO.qdb2.DeviceList  = getDeviceList(10,2);
AO.qdb2.ElementList = (1:size(AO.qdb2.DeviceList,1))';
AO.qdb2.Status      = ones(size(AO.qdb2.DeviceList,1),1);
AO.qdb2.Position    = [];
AO.qdb2.Monitor.MemberOf = {};
AO.qdb2.Monitor.Mode = 'Simulator';
AO.qdb2.Monitor.DataType = 'Scalar';
AO.qdb2.Monitor.Units        = 'Hardware';
AO.qdb2.Monitor.HWUnits      = 'Ampere';
AO.qdb2.Monitor.PhysicsUnits = 'meter^-2';
AO.qdb2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qdb2.Setpoint.Mode          = 'Simulator';
AO.qdb2.Setpoint.DataType      = 'Scalar';
AO.qdb2.Setpoint.Units         = 'Hardware';
AO.qdb2.Setpoint.HWUnits       = 'Ampere';
AO.qdb2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qdb2.Setpoint.Range         = [0 225];
AO.qdb2.Setpoint.Tolerance     = 0.2;
AO.qdb2.Setpoint.DeltaRespMat  = 0.5; 

AO.qfb.FamilyName = 'qfb';
AO.qfb.MemberOf    = {'PlotFamily'; 'qfb'; 'QUAD'; 'Magnet';};
AO.qfb.DeviceList  = getDeviceList(10,2);
AO.qfb.ElementList = (1:size(AO.qfb.DeviceList,1))';
AO.qfb.Status      = ones(size(AO.qfb.DeviceList,1),1);
AO.qfb.Position    = [];
AO.qfb.Monitor.MemberOf = {};
AO.qfb.Monitor.Mode = 'Simulator';
AO.qfb.Monitor.DataType = 'Scalar';
AO.qfb.Monitor.Units        = 'Hardware';
AO.qfb.Monitor.HWUnits      = 'Ampere';
AO.qfb.Monitor.PhysicsUnits = 'meter^-2';
AO.qfb.Setpoint.MemberOf      = {'MachineConfig'};
AO.qfb.Setpoint.Mode          = 'Simulator';
AO.qfb.Setpoint.DataType      = 'Scalar';
AO.qfb.Setpoint.Units         = 'Hardware';
AO.qfb.Setpoint.HWUnits       = 'Ampere';
AO.qfb.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qfb.Setpoint.Range         = [0 225];
AO.qfb.Setpoint.Tolerance     = 0.2;
AO.qfb.Setpoint.DeltaRespMat  = 0.5; 

AO.qdb1.FamilyName = 'qdb1';
AO.qdb1.MemberOf    = {'PlotFamily'; 'qdb1'; 'QUAD'; 'Magnet';};
AO.qdb1.DeviceList  = getDeviceList(10,2);
AO.qdb1.ElementList = (1:size(AO.qdb1.DeviceList,1))';
AO.qdb1.Status      = ones(size(AO.qdb1.DeviceList,1),1);
AO.qdb1.Position    = [];
AO.qdb1.Monitor.MemberOf = {};
AO.qdb1.Monitor.Mode = 'Simulator';
AO.qdb1.Monitor.DataType = 'Scalar';
AO.qdb1.Monitor.Units        = 'Hardware';
AO.qdb1.Monitor.HWUnits      = 'Ampere';
AO.qdb1.Monitor.PhysicsUnits = 'meter^-2';
AO.qdb1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qdb1.Setpoint.Mode          = 'Simulator';
AO.qdb1.Setpoint.DataType      = 'Scalar';
AO.qdb1.Setpoint.Units         = 'Hardware';
AO.qdb1.Setpoint.HWUnits       = 'Ampere';
AO.qdb1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qdb1.Setpoint.Range         = [0 225];
AO.qdb1.Setpoint.Tolerance     = 0.2;
AO.qdb1.Setpoint.DeltaRespMat  = 0.5; 

AO.qda.FamilyName = 'qda';
AO.qda.MemberOf    = {'PlotFamily'; 'qda'; 'QUAD'; 'Magnet';};
AO.qda.DeviceList  = getDeviceList(10,2);
AO.qda.ElementList = (1:size(AO.qda.DeviceList,1))';
AO.qda.Status      = ones(size(AO.qda.DeviceList,1),1);
AO.qda.Position    = [];
AO.qda.Monitor.MemberOf = {};
AO.qda.Monitor.Mode = 'Simulator';
AO.qda.Monitor.DataType = 'Scalar';
AO.qda.Monitor.Units        = 'Hardware';
AO.qda.Monitor.HWUnits      = 'Ampere';
AO.qda.Monitor.PhysicsUnits = 'meter^-2';
AO.qda.Setpoint.MemberOf      = {'MachineConfig'};
AO.qda.Setpoint.Mode          = 'Simulator';
AO.qda.Setpoint.DataType      = 'Scalar';
AO.qda.Setpoint.Units         = 'Hardware';
AO.qda.Setpoint.HWUnits       = 'Ampere';
AO.qda.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qda.Setpoint.Range         = [0 225];
AO.qda.Setpoint.Tolerance     = 0.2;
AO.qda.Setpoint.DeltaRespMat  = 0.5;


AO.qf1.FamilyName = 'qf1';
AO.qf1.MemberOf    = {'PlotFamily'; 'qf1'; 'QUAD'; 'Magnet';};
AO.qf1.DeviceList  = getDeviceList(10,4);
AO.qf1.ElementList = (1:size(AO.qf1.DeviceList,1))';
AO.qf1.Status      = ones(size(AO.qf1.DeviceList,1),1);
AO.qf1.Position    = [];
AO.qf1.Monitor.MemberOf = {};
AO.qf1.Monitor.Mode = 'Simulator';
AO.qf1.Monitor.DataType = 'Scalar';
AO.qf1.Monitor.Units        = 'Hardware';
AO.qf1.Monitor.HWUnits      = 'Ampere';
AO.qf1.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1.Setpoint.Mode          = 'Simulator';
AO.qf1.Setpoint.DataType      = 'Scalar';
AO.qf1.Setpoint.Units         = 'Hardware';
AO.qf1.Setpoint.HWUnits       = 'Ampere';
AO.qf1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1.Setpoint.Range         = [0 225];
AO.qf1.Setpoint.Tolerance     = 0.2;
AO.qf1.Setpoint.DeltaRespMat  = 0.5;

AO.qf2.FamilyName = 'qf2';
AO.qf2.MemberOf    = {'PlotFamily'; 'qf2'; 'QUAD'; 'Magnet';};
AO.qf2.DeviceList  = getDeviceList(10,4);
AO.qf2.ElementList = (1:size(AO.qf2.DeviceList,1))';
AO.qf2.Status      = ones(size(AO.qf2.DeviceList,1),1);
AO.qf2.Position    = [];
AO.qf2.Monitor.MemberOf = {};
AO.qf2.Monitor.Mode = 'Simulator';
AO.qf2.Monitor.DataType = 'Scalar';
AO.qf2.Monitor.Units        = 'Hardware';
AO.qf2.Monitor.HWUnits      = 'Ampere';
AO.qf2.Monitor.PhysicsUnits = 'meter^-2';
AO.qf2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf2.Setpoint.Mode          = 'Simulator';
AO.qf2.Setpoint.DataType      = 'Scalar';
AO.qf2.Setpoint.Units         = 'Hardware';
AO.qf2.Setpoint.HWUnits       = 'Ampere';
AO.qf2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf2.Setpoint.Range         = [0 225];
AO.qf2.Setpoint.Tolerance     = 0.2;
AO.qf2.Setpoint.DeltaRespMat  = 0.5;

AO.qf3.FamilyName = 'qf3';
AO.qf3.MemberOf    = {'PlotFamily'; 'qf3'; 'QUAD'; 'Magnet';};
AO.qf3.DeviceList  = getDeviceList(10,4);
AO.qf3.ElementList = (1:size(AO.qf3.DeviceList,1))';
AO.qf3.Status      = ones(size(AO.qf3.DeviceList,1),1);
AO.qf3.Position    = [];
AO.qf3.Monitor.MemberOf = {};
AO.qf3.Monitor.Mode = 'Simulator';
AO.qf3.Monitor.DataType = 'Scalar';
AO.qf3.Monitor.Units        = 'Hardware';
AO.qf3.Monitor.HWUnits      = 'Ampere';
AO.qf3.Monitor.PhysicsUnits = 'meter^-2';
AO.qf3.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf3.Setpoint.Mode          = 'Simulator';
AO.qf3.Setpoint.DataType      = 'Scalar';
AO.qf3.Setpoint.Units         = 'Hardware';
AO.qf3.Setpoint.HWUnits       = 'Ampere';
AO.qf3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3.Setpoint.Range         = [0 225];
AO.qf3.Setpoint.Tolerance     = 0.2;
AO.qf3.Setpoint.DeltaRespMat  = 0.5;

AO.qf4.FamilyName = 'qf4';
AO.qf4.MemberOf    = {'PlotFamily'; 'qf4'; 'QUAD'; 'Magnet';};
AO.qf4.DeviceList  = getDeviceList(10,4);
AO.qf4.ElementList = (1:size(AO.qf4.DeviceList,1))';
AO.qf4.Status      = ones(size(AO.qf4.DeviceList,1),1);
AO.qf4.Position    = [];
AO.qf4.Monitor.MemberOf = {};
AO.qf4.Monitor.Mode = 'Simulator';
AO.qf4.Monitor.DataType = 'Scalar';
AO.qf4.Monitor.Units        = 'Hardware';
AO.qf4.Monitor.HWUnits      = 'Ampere';
AO.qf4.Monitor.PhysicsUnits = 'meter^-2';
AO.qf4.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf4.Setpoint.Mode          = 'Simulator';
AO.qf4.Setpoint.DataType      = 'Scalar';
AO.qf4.Setpoint.Units         = 'Hardware';
AO.qf4.Setpoint.HWUnits       = 'Ampere';
AO.qf4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf4.Setpoint.Range         = [0 225];
AO.qf4.Setpoint.Tolerance     = 0.2;
AO.qf4.Setpoint.DeltaRespMat  = 0.5;
%%

AO.sda.FamilyName = 'sda';
AO.sda.MemberOf    = {'PlotFamily'; 'sda'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sda.DeviceList  = getDeviceList(10,2);
AO.sda.ElementList = (1:size(AO.sda.DeviceList,1))';
AO.sda.Status      = ones(size(AO.sda.DeviceList,1),1);
AO.sda.Position    = [];
AO.sda.Monitor.MemberOf = {};
AO.sda.Monitor.Mode = 'Simulator';
AO.sda.Monitor.DataType = 'Scalar';
AO.sda.Monitor.Units        = 'Hardware';
AO.sda.Monitor.HWUnits      = 'Ampere';
AO.sda.Monitor.PhysicsUnits = 'meter^-3';
AO.sda.Setpoint.MemberOf      = {'MachineConfig'};
AO.sda.Setpoint.Mode          = 'Simulator';
AO.sda.Setpoint.DataType      = 'Scalar';
AO.sda.Setpoint.Units         = 'Hardware';
AO.sda.Setpoint.HWUnits       = 'Ampere';
AO.sda.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sda.Setpoint.Range         = [0 225];
AO.sda.Setpoint.Tolerance     = 0.2;
AO.sda.Setpoint.DeltaRespMat  = 0.5; 

AO.sfa.FamilyName = 'sfa';
AO.sfa.MemberOf    = {'PlotFamily'; 'sfa'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sfa.DeviceList  = getDeviceList(10,2);
AO.sfa.ElementList = (1:size(AO.sfa.DeviceList,1))';
AO.sfa.Status      = ones(size(AO.sfa.DeviceList,1),1);
AO.sfa.Position    = [];
AO.sfa.Monitor.MemberOf = {};
AO.sfa.Monitor.Mode = 'Simulator';
AO.sfa.Monitor.DataType = 'Scalar';
AO.sfa.Monitor.Units        = 'Hardware';
AO.sfa.Monitor.HWUnits      = 'Ampere';
AO.sfa.Monitor.PhysicsUnits = 'meter^-3';
AO.sfa.Setpoint.MemberOf      = {'MachineConfig'};
AO.sfa.Setpoint.Mode          = 'Simulator';
AO.sfa.Setpoint.DataType      = 'Scalar';
AO.sfa.Setpoint.Units         = 'Hardware';
AO.sfa.Setpoint.HWUnits       = 'Ampere';
AO.sfa.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sfa.Setpoint.Range         = [0 225];
AO.sfa.Setpoint.Tolerance     = 0.2;
AO.sfa.Setpoint.DeltaRespMat  = 0.5; 

AO.sd1.FamilyName = 'sd1';
AO.sd1.MemberOf    = {'PlotFamily'; 'sd1'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sd1.DeviceList  = getDeviceList(10,2);
AO.sd1.ElementList = (1:size(AO.sd1.DeviceList,1))';
AO.sd1.Status      = ones(size(AO.sd1.DeviceList,1),1);
AO.sd1.Position    = [];
AO.sd1.Monitor.MemberOf = {};
AO.sd1.Monitor.Mode = 'Simulator';
AO.sd1.Monitor.DataType = 'Scalar';
AO.sd1.Monitor.Units        = 'Hardware';
AO.sd1.Monitor.HWUnits      = 'Ampere';
AO.sd1.Monitor.PhysicsUnits = 'meter^-3';
AO.sd1.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd1.Setpoint.Mode          = 'Simulator';
AO.sd1.Setpoint.DataType      = 'Scalar';
AO.sd1.Setpoint.Units         = 'Hardware';
AO.sd1.Setpoint.HWUnits       = 'Ampere';
AO.sd1.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd1.Setpoint.Range         = [0 225];
AO.sd1.Setpoint.Tolerance     = 0.2;
AO.sd1.Setpoint.DeltaRespMat  = 0.5;

AO.sf1.FamilyName = 'sf1';
AO.sf1.MemberOf    = {'PlotFamily'; 'sf1'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sf1.DeviceList  = getDeviceList(10,2);
AO.sf1.ElementList = (1:size(AO.sf1.DeviceList,1))';
AO.sf1.Status      = ones(size(AO.sf1.DeviceList,1),1);
AO.sf1.Position    = [];
AO.sf1.Monitor.MemberOf = {};
AO.sf1.Monitor.Mode = 'Simulator';
AO.sf1.Monitor.DataType = 'Scalar';
AO.sf1.Monitor.Units        = 'Hardware';
AO.sf1.Monitor.HWUnits      = 'Ampere';
AO.sf1.Monitor.PhysicsUnits = 'meter^-3';
AO.sf1.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf1.Setpoint.Mode          = 'Simulator';
AO.sf1.Setpoint.DataType      = 'Scalar';
AO.sf1.Setpoint.Units         = 'Hardware';
AO.sf1.Setpoint.HWUnits       = 'Ampere';
AO.sf1.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf1.Setpoint.Range         = [0 225];
AO.sf1.Setpoint.Tolerance     = 0.2;
AO.sf1.Setpoint.DeltaRespMat  = 0.5; 

AO.sd2.FamilyName = 'sd2';
AO.sd2.MemberOf    = {'PlotFamily'; 'sd2'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sd2.DeviceList  = getDeviceList(10,2);
AO.sd2.ElementList = (1:size(AO.sd2.DeviceList,1))';
AO.sd2.Status      = ones(size(AO.sd2.DeviceList,1),1);
AO.sd2.Position    = [];
AO.sd2.Monitor.MemberOf = {};
AO.sd2.Monitor.Mode = 'Simulator';
AO.sd2.Monitor.DataType = 'Scalar';
AO.sd2.Monitor.Units        = 'Hardware';
AO.sd2.Monitor.HWUnits      = 'Ampere';
AO.sd2.Monitor.PhysicsUnits = 'meter^-3';
AO.sd2.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd2.Setpoint.Mode          = 'Simulator';
AO.sd2.Setpoint.DataType      = 'Scalar';
AO.sd2.Setpoint.Units         = 'Hardware';
AO.sd2.Setpoint.HWUnits       = 'Ampere';
AO.sd2.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd2.Setpoint.Range         = [0 225];
AO.sd2.Setpoint.Tolerance     = 0.2;
AO.sd2.Setpoint.DeltaRespMat  = 0.5; 

AO.sd3.FamilyName = 'sd3';
AO.sd3.MemberOf    = {'PlotFamily'; 'sd3'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sd3.DeviceList  = getDeviceList(10,2);
AO.sd3.ElementList = (1:size(AO.sd3.DeviceList,1))';
AO.sd3.Status      = ones(size(AO.sd3.DeviceList,1),1);
AO.sd3.Position    = [];
AO.sd3.Monitor.MemberOf = {};
AO.sd3.Monitor.Mode = 'Simulator';
AO.sd3.Monitor.DataType = 'Scalar';
AO.sd3.Monitor.Units        = 'Hardware';
AO.sd3.Monitor.HWUnits      = 'Ampere';
AO.sd3.Monitor.PhysicsUnits = 'meter^-3';
AO.sd3.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd3.Setpoint.Mode          = 'Simulator';
AO.sd3.Setpoint.DataType      = 'Scalar';
AO.sd3.Setpoint.Units         = 'Hardware';
AO.sd3.Setpoint.HWUnits       = 'Ampere';
AO.sd3.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd3.Setpoint.Range         = [0 225];
AO.sd3.Setpoint.Tolerance     = 0.2;
AO.sd3.Setpoint.DeltaRespMat  = 0.5; 

AO.sf2.FamilyName = 'sf2';
AO.sf2.MemberOf    = {'PlotFamily'; 'sf2'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sf2.DeviceList  = getDeviceList(10,2);
AO.sf2.ElementList = (1:size(AO.sf2.DeviceList,1))';
AO.sf2.Status      = ones(size(AO.sf2.DeviceList,1),1);
AO.sf2.Position    = [];
AO.sf2.Monitor.MemberOf = {};
AO.sf2.Monitor.Mode = 'Simulator';
AO.sf2.Monitor.DataType = 'Scalar';
AO.sf2.Monitor.Units        = 'Hardware';
AO.sf2.Monitor.HWUnits      = 'Ampere';
AO.sf2.Monitor.PhysicsUnits = 'meter^-3';
AO.sf2.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf2.Setpoint.Mode          = 'Simulator';
AO.sf2.Setpoint.DataType      = 'Scalar';
AO.sf2.Setpoint.Units         = 'Hardware';
AO.sf2.Setpoint.HWUnits       = 'Ampere';
AO.sf2.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf2.Setpoint.Range         = [0 225];
AO.sf2.Setpoint.Tolerance     = 0.2;
AO.sf2.Setpoint.DeltaRespMat  = 0.5; 

AO.sd6.FamilyName = 'sd6';
AO.sd6.MemberOf    = {'PlotFamily'; 'sd6'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sd6.DeviceList  = getDeviceList(10,2);
AO.sd6.ElementList = (1:size(AO.sd6.DeviceList,1))';
AO.sd6.Status      = ones(size(AO.sd6.DeviceList,1),1);
AO.sd6.Position    = [];
AO.sd6.Monitor.MemberOf = {};
AO.sd6.Monitor.Mode = 'Simulator';
AO.sd6.Monitor.DataType = 'Scalar';
AO.sd6.Monitor.Units        = 'Hardware';
AO.sd6.Monitor.HWUnits      = 'Ampere';
AO.sd6.Monitor.PhysicsUnits = 'meter^-3';
AO.sd6.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd6.Setpoint.Mode          = 'Simulator';
AO.sd6.Setpoint.DataType      = 'Scalar';
AO.sd6.Setpoint.Units         = 'Hardware';
AO.sd6.Setpoint.HWUnits       = 'Ampere';
AO.sd6.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd6.Setpoint.Range         = [0 225];
AO.sd6.Setpoint.Tolerance     = 0.2;
AO.sd6.Setpoint.DeltaRespMat  = 0.5;

AO.sf4.FamilyName = 'sf4';
AO.sf4.MemberOf    = {'PlotFamily'; 'sf4'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sf4.DeviceList  = getDeviceList(10,2);
AO.sf4.ElementList = (1:size(AO.sf4.DeviceList,1))';
AO.sf4.Status      = ones(size(AO.sf4.DeviceList,1),1);
AO.sf4.Position    = [];
AO.sf4.Monitor.MemberOf = {};
AO.sf4.Monitor.Mode = 'Simulator';
AO.sf4.Monitor.DataType = 'Scalar';
AO.sf4.Monitor.Units        = 'Hardware';
AO.sf4.Monitor.HWUnits      = 'Ampere';
AO.sf4.Monitor.PhysicsUnits = 'meter^-3';
AO.sf4.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf4.Setpoint.Mode          = 'Simulator';
AO.sf4.Setpoint.DataType      = 'Scalar';
AO.sf4.Setpoint.Units         = 'Hardware';
AO.sf4.Setpoint.HWUnits       = 'Ampere';
AO.sf4.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf4.Setpoint.Range         = [0 225];
AO.sf4.Setpoint.Tolerance     = 0.2;
AO.sf4.Setpoint.DeltaRespMat  = 0.5; 

AO.sd5.FamilyName = 'sd5';
AO.sd5.MemberOf    = {'PlotFamily'; 'sd5'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sd5.DeviceList  = getDeviceList(10,2);
AO.sd5.ElementList = (1:size(AO.sd5.DeviceList,1))';
AO.sd5.Status      = ones(size(AO.sd5.DeviceList,1),1);
AO.sd5.Position    = [];
AO.sd5.Monitor.MemberOf = {};
AO.sd5.Monitor.Mode = 'Simulator';
AO.sd5.Monitor.DataType = 'Scalar';
AO.sd5.Monitor.Units        = 'Hardware';
AO.sd5.Monitor.HWUnits      = 'Ampere';
AO.sd5.Monitor.PhysicsUnits = 'meter^-3';
AO.sd5.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd5.Setpoint.Mode          = 'Simulator';
AO.sd5.Setpoint.DataType      = 'Scalar';
AO.sd5.Setpoint.Units         = 'Hardware';
AO.sd5.Setpoint.HWUnits       = 'Ampere';
AO.sd5.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd5.Setpoint.Range         = [0 225];
AO.sd5.Setpoint.Tolerance     = 0.2;
AO.sd5.Setpoint.DeltaRespMat  = 0.5; 

AO.sd4.FamilyName = 'sd4';
AO.sd4.MemberOf    = {'PlotFamily'; 'sd4'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sd4.DeviceList  = getDeviceList(10,2);
AO.sd4.ElementList = (1:size(AO.sd4.DeviceList,1))';
AO.sd4.Status      = ones(size(AO.sd4.DeviceList,1),1);
AO.sd4.Position    = [];
AO.sd4.Monitor.MemberOf = {};
AO.sd4.Monitor.Mode = 'Simulator';
AO.sd4.Monitor.DataType = 'Scalar';
AO.sd4.Monitor.Units        = 'Hardware';
AO.sd4.Monitor.HWUnits      = 'Ampere';
AO.sd4.Monitor.PhysicsUnits = 'meter^-3';
AO.sd4.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd4.Setpoint.Mode          = 'Simulator';
AO.sd4.Setpoint.DataType      = 'Scalar';
AO.sd4.Setpoint.Units         = 'Hardware';
AO.sd4.Setpoint.HWUnits       = 'Ampere';
AO.sd4.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd4.Setpoint.Range         = [0 225];
AO.sd4.Setpoint.Tolerance     = 0.2;
AO.sd4.Setpoint.DeltaRespMat  = 0.5; 

AO.sf3.FamilyName = 'sf3';
AO.sf3.MemberOf    = {'PlotFamily'; 'sf3'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sf3.DeviceList  = getDeviceList(10,2);
AO.sf3.ElementList = (1:size(AO.sf3.DeviceList,1))';
AO.sf3.Status      = ones(size(AO.sf3.DeviceList,1),1);
AO.sf3.Position    = [];
AO.sf3.Monitor.MemberOf = {};
AO.sf3.Monitor.Mode = 'Simulator';
AO.sf3.Monitor.DataType = 'Scalar';
AO.sf3.Monitor.Units        = 'Hardware';
AO.sf3.Monitor.HWUnits      = 'Ampere';
AO.sf3.Monitor.PhysicsUnits = 'meter^-3';
AO.sf3.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf3.Setpoint.Mode          = 'Simulator';
AO.sf3.Setpoint.DataType      = 'Scalar';
AO.sf3.Setpoint.Units         = 'Hardware';
AO.sf3.Setpoint.HWUnits       = 'Ampere';
AO.sf3.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf3.Setpoint.Range         = [0 225];
AO.sf3.Setpoint.Tolerance     = 0.2;
AO.sf3.Setpoint.DeltaRespMat  = 0.5; 

AO.sfb.FamilyName = 'sfb';
AO.sfb.MemberOf    = {'PlotFamily'; 'sfb'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sfb.DeviceList  = getDeviceList(10,2);
AO.sfb.ElementList = (1:size(AO.sfb.DeviceList,1))';
AO.sfb.Status      = ones(size(AO.sfb.DeviceList,1),1);
AO.sfb.Position    = [];
AO.sfb.Monitor.MemberOf = {};
AO.sfb.Monitor.Mode = 'Simulator';
AO.sfb.Monitor.DataType = 'Scalar';
AO.sfb.Monitor.Units        = 'Hardware';
AO.sfb.Monitor.HWUnits      = 'Ampere';
AO.sfb.Monitor.PhysicsUnits = 'meter^-3';
AO.sfb.Setpoint.MemberOf      = {'MachineConfig'};
AO.sfb.Setpoint.Mode          = 'Simulator';
AO.sfb.Setpoint.DataType      = 'Scalar';
AO.sfb.Setpoint.Units         = 'Hardware';
AO.sfb.Setpoint.HWUnits       = 'Ampere';
AO.sfb.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sfb.Setpoint.Range         = [0 225];
AO.sfb.Setpoint.Tolerance     = 0.2;
AO.sfb.Setpoint.DeltaRespMat  = 0.5; 

AO.sdb.FamilyName = 'sdb';
AO.sdb.MemberOf    = {'PlotFamily'; 'sdb'; 'SEXT'; 'Magnet'; 'Coupling Corrector'; 'Chromaticity Corrector'};
AO.sdb.DeviceList  = getDeviceList(10,2);
AO.sdb.ElementList = (1:size(AO.sdb.DeviceList,1))';
AO.sdb.Status      = ones(size(AO.sdb.DeviceList,1),1);
AO.sdb.Position    = [];
AO.sdb.Monitor.MemberOf = {};
AO.sdb.Monitor.Mode = 'Simulator';
AO.sdb.Monitor.DataType = 'Scalar';
AO.sdb.Monitor.Units        = 'Hardware';
AO.sdb.Monitor.HWUnits      = 'Ampere';
AO.sdb.Monitor.PhysicsUnits = 'meter^-3';
AO.sdb.Setpoint.MemberOf      = {'MachineConfig'};
AO.sdb.Setpoint.Mode          = 'Simulator';
AO.sdb.Setpoint.DataType      = 'Scalar';
AO.sdb.Setpoint.Units         = 'Hardware';
AO.sdb.Setpoint.HWUnits       = 'Ampere';
AO.sdb.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sdb.Setpoint.Range         = [0 225];
AO.sdb.Setpoint.Tolerance     = 0.2;
AO.sdb.Setpoint.DeltaRespMat  = 0.5; 


%%
%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% hcm
AO.hcm.FamilyName  = 'hcm';
AO.hcm.MemberOf    = {'PlotFamily'; 'COR'; 'hcm'; 'Magnet'};
AO.hcm.DeviceList  = getDeviceList(10,16);
AO.hcm.ElementList = (1:size(AO.hcm.DeviceList,1))';
AO.hcm.Status      = ones(size(AO.hcm.DeviceList,1),1);
%AO.hcm.Status      = repmat([0 1 0 1 1 0 1 0]',20,1);
AO.hcm.Position    = [];

AO.hcm.Monitor.MemberOf = {'Horizontal'; 'COR'; 'hcm'; 'Magnet';};
AO.hcm.Monitor.Mode = 'Simulator';
AO.hcm.Monitor.DataType = 'Scalar';
AO.hcm.Monitor.Units        = 'Physics';
AO.hcm.Monitor.HWUnits      = 'Ampere';
AO.hcm.Monitor.PhysicsUnits = 'Radian';

AO.hcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.hcm.Setpoint.Mode = 'Simulator';
AO.hcm.Setpoint.DataType = 'Scalar';
AO.hcm.Setpoint.Units        = 'Physics';
AO.hcm.Setpoint.HWUnits      = 'Ampere';
AO.hcm.Setpoint.PhysicsUnits = 'Radian';
AO.hcm.Setpoint.Range        = [-10 10];
AO.hcm.Setpoint.Tolerance    = 0.00001;
AO.hcm.Setpoint.DeltaRespMat = 0.0005; 

% vcm
AO.vcm.FamilyName  = 'vcm';
AO.vcm.MemberOf    = {'PlotFamily'; 'COR'; 'vcm'; 'Magnet'};
AO.vcm.DeviceList  = getDeviceList(10,12);
AO.vcm.ElementList = (1:size(AO.vcm.DeviceList,1))';
AO.vcm.Status      = ones(size(AO.vcm.DeviceList,1),1);
%AO.vcm.Status      = repmat([1 0 1 0 0 1 0 1]',20,1);
AO.vcm.Position    = [];
AO.vcm.Monitor.MemberOf = {'Vertical'; 'COR'; 'vcm'; 'Magnet';};
AO.vcm.Monitor.Mode = 'Simulator';
AO.vcm.Monitor.DataType = 'Scalar';
AO.vcm.Monitor.Units        = 'Physics';
AO.vcm.Monitor.HWUnits      = 'Ampere';
AO.vcm.Monitor.PhysicsUnits = 'Radian';

AO.vcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.vcm.Setpoint.Mode = 'Simulator';
AO.vcm.Setpoint.DataType = 'Scalar';
AO.vcm.Setpoint.Units        = 'Physics';
AO.vcm.Setpoint.HWUnits      = 'Ampere';
AO.vcm.Setpoint.PhysicsUnits = 'Radian';
AO.vcm.Setpoint.Range        = [-10 10];
AO.vcm.Setpoint.Tolerance    = 0.00001;
AO.vcm.Setpoint.DeltaRespMat = 0.0005; 


% skewcm

AO.skewcm.FamilyName  = 'skewcm';
AO.skewcm.MemberOf    = {'PlotFamily'; 'COR'; 'skewcm'; 'Magnet'};
AO.skewcm.DeviceList  = getDeviceList(10,28);
AO.skewcm.ElementList = (1:size(AO.skewcm.DeviceList,1))';
AO.skewcm.Status      = ones(size(AO.skewcm.DeviceList,1),1);

AO.skewcm.Position    = [];

AO.skewcm.Monitor.MemberOf = {'COR'; 'skewcm'; 'Magnet';};
AO.skewcm.Monitor.Mode = 'Simulator';
AO.skewcm.Monitor.DataType = 'Scalar';
AO.skewcm.Monitor.Units        = 'Physics';
AO.skewcm.Monitor.HWUnits      = 'Ampere';
AO.skewcm.Monitor.PhysicsUnits = 'Radian';

AO.skewcm.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'skewcm'; 'Magnet'; 'Setpoint';};
AO.skewcm.Setpoint.Mode = 'Simulator';
AO.skewcm.Setpoint.DataType = 'Scalar';
AO.skewcm.Setpoint.Units        = 'Physics';
AO.skewcm.Setpoint.HWUnits      = 'Ampere';
AO.skewcm.Setpoint.PhysicsUnits = 'm^-2';
AO.skewcm.Setpoint.Range        = [-10 10];
AO.skewcm.Setpoint.Tolerance    = 0.00001;


% bpmx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'bpm'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(10,18);
AO.bpmx.ElementList = (1:size(AO.bpmx.DeviceList,1))';
AO.bpmx.Status      = ones(size(AO.bpmx.DeviceList,1),1);
AO.bpmx.Position    = [];
AO.bpmx.Golden      = zeros(length(AO.bpmx.ElementList),1);
AO.bpmx.Offset      = zeros(length(AO.bpmx.ElementList),1);

AO.bpmx.Monitor.MemberOf = {'bpmx'; 'Monitor';};
AO.bpmx.Monitor.Mode = 'Simulator';
AO.bpmx.Monitor.DataType = 'Scalar';
AO.bpmx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams = 1000;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'mm';
AO.bpmx.Monitor.PhysicsUnits = 'meter';



% bpmy
AO.bpmy.FamilyName  = 'bpmy';
AO.bpmy.MemberOf    = {'PlotFamily'; 'bpm'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(10,18);
AO.bpmy.ElementList = (1:size(AO.bpmy.DeviceList,1))';
AO.bpmy.Status      = ones(size(AO.bpmy.DeviceList,1),1);
AO.bpmy.Position    = [];
AO.bpmy.Golden      = zeros(length(AO.bpmy.ElementList),1);
AO.bpmy.Offset      = zeros(length(AO.bpmy.ElementList),1);


AO.bpmy.Monitor.MemberOf = {'bpmy'; 'Monitor';};
AO.bpmy.Monitor.Mode = 'Simulator';
AO.bpmy.Monitor.DataType = 'Scalar';
AO.bpmy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams = 1000;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'mm';
AO.bpmy.Monitor.PhysicsUnits = 'meter';

%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'; 'TuneS'];

AO.TUNE.Monitor.MemberOf   = {'TUNE'};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'kHz';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = @bfreq2tune;


%%%%%%%%%%
%   RF   %
%%%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [400.0 600.0];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.VoltageCtrl.MemberOf          = {};
AO.RF.VoltageCtrl.Mode              = 'Simulator';
AO.RF.VoltageCtrl.DataType          = 'Scalar';
AO.RF.VoltageCtrl.ChannelNames      = '';
AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
AO.RF.VoltageCtrl.Physics2HWParams  = 1;
AO.RF.VoltageCtrl.Units             = 'Hardware';
AO.RF.VoltageCtrl.HWUnits           = 'Volts';
AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';

AO.RF.Voltage.MemberOf          = {};
AO.RF.Voltage.Mode              = 'Simulator';
AO.RF.Voltage.DataType          = 'Scalar';
AO.RF.Voltage.ChannelNames      = '';
AO.RF.Voltage.HW2PhysicsParams  = 1;
AO.RF.Voltage.Physics2HWParams  = 1;
AO.RF.Voltage.Units             = 'Hardware';
AO.RF.Voltage.HWUnits           = 'Volts';
AO.RF.Voltage.PhysicsUnits      = 'Volts';

AO.RF.Power.MemberOf          = {};
AO.RF.Power.Mode              = 'Simulator';
AO.RF.Power.DataType          = 'Scalar';
AO.RF.Power.ChannelNames      = '';          % ???
AO.RF.Power.HW2PhysicsParams  = 1;         
AO.RF.Power.Physics2HWParams  = 1;
AO.RF.Power.Units             = 'Hardware';
AO.RF.Power.HWUnits           = 'MWatts';           
AO.RF.Power.PhysicsUnits      = 'MWatts';
AO.RF.Power.Range             = [-inf inf];  % ???  
AO.RF.Power.Tolerance         = inf;  % ???  

AO.RF.Phase.MemberOf          = {'RF'; 'Phase'};
AO.RF.Phase.Mode              = 'Simulator';
AO.RF.Phase.DataType          = 'Scalar';
AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???  
AO.RF.Phase.Units             = 'Hardware';
AO.RF.Phase.HW2PhysicsParams  = 1; 
AO.RF.Phase.Physics2HWParams  = 1;
AO.RF.Phase.HWUnits           = 'Degrees';  
AO.RF.Phase.PhysicsUnits      = 'Degrees';

AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'MachineConfig';
AO.RF.PhaseCtrl.Mode              = 'Simulator';
AO.RF.PhaseCtrl.DataType          = 'Scalar';
AO.RF.PhaseCtrl.ChannelNames      = 'SRF1:STN:PHASE';    % ???     
AO.RF.PhaseCtrl.Units             = 'Hardware';
AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;         
AO.RF.PhaseCtrl.Physics2HWParams  = 1;
AO.RF.PhaseCtrl.HWUnits           = 'Degrees';  
AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees'; 
AO.RF.PhaseCtrl.Range             = [-200 200];    % ??? 
AO.RF.PhaseCtrl.Tolerance         = 10;    % ??? 



% %%%%%%%%%%%%%%
% %    DCCT    %
% %%%%%%%%%%%%%%
% AO.DCCT.FamilyName               = 'DCCT';
% AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
% AO.DCCT.DeviceList               = [1 1];
% AO.DCCT.ElementList              = 1;
% AO.DCCT.Status                   = 1;
% AO.DCCT.Position                 = 23.2555;
% 
% AO.DCCT.Monitor.MemberOf         = {};
% AO.DCCT.Monitor.Mode             = 'Simulator';
% AO.DCCT.Monitor.DataType         = 'Scalar';
% AO.DCCT.Monitor.ChannelNames     = 'AMC03';    
% AO.DCCT.Monitor.HW2PhysicsParams = 1;    
% AO.DCCT.Monitor.Physics2HWParams = 1;
% AO.DCCT.Monitor.Units            = 'Hardware';
% AO.DCCT.Monitor.HWUnits          = 'Ampere';     
% AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';






% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);




%sirius_comm_connect_inputdlg;
 
function DList = getDeviceList(NSector,NDevices)

DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end

function [OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists

NSector = 4;

OnePerSector=[];
TwoPerSector=[];
ThreePerSector=[];
FourPerSector=[];
FivePerSector=[];
SixPerSector=[];
EightPerSector=[];
TenPerSector=[];
TwelvePerSector=[];
FifteenPerSector=[];
SixteenPerSector=[];
EighteenPerSector=[];
TwentyFourPerSector=[];

for Sector =1:NSector  
    
    OnePerSector = [OnePerSector;
        Sector 1;];
    
    TwoPerSector = [TwoPerSector;
        Sector 1;
        Sector 2;];
    
    ThreePerSector = [ThreePerSector;
        Sector 1;
        Sector 2;
        Sector 3;];

    FourPerSector = [FourPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];	
    
    FivePerSector = [FivePerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;];	

    SixPerSector = [SixPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;];	
    
    EightPerSector = [EightPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];	
    
   TenPerSector = [TenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;];	
    
    TwelvePerSector = [TwelvePerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        ];	
    
     FifteenPerSector = [FifteenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        ];
    
    SixteenPerSector = [SixteenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        Sector 16;
        ];
    
     EighteenPerSector = [EighteenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        Sector 16;
        Sector 17;
        Sector 18;
        ];
     TwentyFourPerSector = [TwentyFourPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        Sector 16;
        Sector 17;
        Sector 18;
        Sector 19;
        Sector 20;
        Sector 21;
        Sector 22;
        Sector 23;
        Sector 24;
        ];
end
