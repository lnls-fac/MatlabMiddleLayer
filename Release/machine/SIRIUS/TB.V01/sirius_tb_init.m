function sirius_tb_init(OperationalMode)
%SIRIUS_TB_INIT - MML initialization file for the TB at sirius
% 
%  See also setoperationalmode

% 2013-12-02 Inicio (Ximenes)


setao([]);
setad([]);

% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));

AD.Directory.ExcDataDir  = '/home/fac_files/siriusdb/excitation_curves';

%AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];

setad(AD);


% BENDS
AO.spec.FamilyName  = 'spec';
AO.spec.MemberOf    = {'PlotFamily'; 'spec'; 'BEND'; 'Magnet';};
AO.spec.DeviceList  = getDeviceList(1,1);
AO.spec.ElementList = (1:size(AO.spec.DeviceList,1))';
AO.spec.Status      = ones(size(AO.spec.DeviceList,1),1);
AO.spec.Position    = [];
AO.spec.ExcitationCurves = sirius_getexcdata(repmat('tbma-bend', size(AO.spec.DeviceList,1), 1)); 

AO.spec.Monitor.MemberOf = {};
AO.spec.Monitor.Mode = 'Simulator';
AO.spec.Monitor.DataType = 'Scalar';
AO.spec.Monitor.ChannelNames = sirius_tb_getname(AO.spec.FamilyName, 'Monitor', AO.spec.DeviceList);
AO.spec.Monitor.HW2PhysicsFcn = @bend2gev;
AO.spec.Monitor.Physics2HWFcn = @gev2bend;
AO.spec.Monitor.Units        = 'Hardware';
AO.spec.Monitor.HWUnits      = 'Ampere';
AO.spec.Monitor.PhysicsUnits = 'GeV';

AO.spec.Setpoint.MemberOf = {'MachineConfig';};
AO.spec.Setpoint.Mode = 'Simulator';
AO.spec.Setpoint.DataType = 'Scalar';
AO.spec.Setpoint.ChannelNames = sirius_tb_getname(AO.spec.FamilyName, 'Setpoint', AO.spec.DeviceList);
AO.spec.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.spec.Setpoint.Physics2HWFcn = @gev2bend;
AO.spec.Setpoint.Units        = 'Hardware';
AO.spec.Setpoint.HWUnits      = 'Ampere';
AO.spec.Setpoint.PhysicsUnits = 'GeV';
AO.spec.Setpoint.Range        = [0 300];
AO.spec.Setpoint.Tolerance    = .1;
AO.spec.Setpoint.DeltaRespMat = .01;

AO.bp.FamilyName  = 'bp';
AO.bp.MemberOf    = {'PlotFamily'; 'bp'; 'BEND'; 'Magnet';};
AO.bp.DeviceList  = getDeviceList(1,2);
AO.bp.ElementList = (1:size(AO.bp.DeviceList,1))';
AO.bp.Status      = ones(size(AO.bp.DeviceList,1),1);
AO.bp.Position    = [];
AO.bp.ExcitationCurves = sirius_getexcdata(repmat('tbma-bend', size(AO.bp.DeviceList,1), 1));

AO.bp.Monitor.MemberOf = {};
AO.bp.Monitor.Mode = 'Simulator';
AO.bp.Monitor.DataType = 'Scalar';
AO.bp.Monitor.ChannelNames = sirius_tb_getname(AO.bp.FamilyName, 'Monitor', AO.bp.DeviceList);
AO.bp.Monitor.HW2PhysicsFcn = @bend2gev;
AO.bp.Monitor.Physics2HWFcn = @gev2bend;
AO.bp.Monitor.Units        = 'Hardware';
AO.bp.Monitor.HWUnits      = 'Ampere';
AO.bp.Monitor.PhysicsUnits = 'GeV';

AO.bp.Setpoint.MemberOf = {'MachineConfig';};
AO.bp.Setpoint.Mode = 'Simulator';
AO.bp.Setpoint.DataType = 'Scalar';
AO.bp.Setpoint.ChannelNames = sirius_tb_getname(AO.bp.FamilyName, 'Setpoint', AO.bp.DeviceList);
AO.bp.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.bp.Setpoint.Physics2HWFcn = @gev2bend;
AO.bp.Setpoint.Units        = 'Hardware';
AO.bp.Setpoint.HWUnits      = 'Ampere';
AO.bp.Setpoint.PhysicsUnits = 'GeV';
AO.bp.Setpoint.Range        = [0 300];
AO.bp.Setpoint.Tolerance    = .1;
AO.bp.Setpoint.DeltaRespMat = .01;

AO.bn.FamilyName  = 'bn';
AO.bn.MemberOf    = {'PlotFamily'; 'bn'; 'BEND'; 'Magnet';};
AO.bn.DeviceList  = getDeviceList(1,1);
AO.bn.ElementList = (1:size(AO.bn.DeviceList,1))';
AO.bn.Status      = ones(size(AO.bn.DeviceList,1),1);
AO.bn.Position    = [];
AO.bn.ExcitationCurves = sirius_getexcdata(repmat('tbma-bend', size(AO.bn.DeviceList,1), 1));

AO.bn.Monitor.MemberOf = {};
AO.bn.Monitor.Mode = 'Simulator';
AO.bn.Monitor.DataType = 'Scalar';
AO.bn.Monitor.ChannelNames = sirius_tb_getname(AO.bn.FamilyName, 'Monitor', AO.bn.DeviceList);
AO.bn.Monitor.HW2PhysicsFcn = @bend2gev;
AO.bn.Monitor.Physics2HWFcn = @gev2bend;
AO.bn.Monitor.Units        = 'Hardware';
AO.bn.Monitor.HWUnits      = 'Ampere';
AO.bn.Monitor.PhysicsUnits = 'GeV';

AO.bn.Setpoint.MemberOf = {'MachineConfig';};
AO.bn.Setpoint.Mode = 'Simulator';
AO.bn.Setpoint.DataType = 'Scalar';
AO.bn.Setpoint.ChannelNames = sirius_tb_getname(AO.bn.FamilyName, 'Setpoint', AO.bn.DeviceList);
AO.bn.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.bn.Setpoint.Physics2HWFcn = @gev2bend;
AO.bn.Setpoint.Units        = 'Hardware';
AO.bn.Setpoint.HWUnits      = 'Ampere';
AO.bn.Setpoint.PhysicsUnits = 'GeV';
AO.bn.Setpoint.Range        = [0 300];
AO.bn.Setpoint.Tolerance    = .1;
AO.bn.Setpoint.DeltaRespMat = .01;

AO.septin.FamilyName  = 'septin';
AO.septin.MemberOf    = {'PlotFamily'; 'septin'; 'SEPTUM'; 'Magnet';};
AO.septin.DeviceList  = getDeviceList(1,1);
AO.septin.ElementList = (1:size(AO.septin.DeviceList,1))';
AO.septin.Status      = ones(size(AO.septin.DeviceList,1),1);
AO.septin.Position    = [];
AO.septin.ExcitationCurves = sirius_getexcdata(repmat('tbpm-sep', size(AO.septin.DeviceList,1), 1));

AO.septin.Monitor.MemberOf = {};
AO.septin.Monitor.Mode = 'Simulator';
AO.septin.Monitor.DataType = 'Scalar';
AO.septin.Monitor.ChannelNames = sirius_tb_getname(AO.septin.FamilyName, 'Monitor', AO.septin.DeviceList);
AO.septin.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.septin.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.septin.Monitor.Units        = 'Hardware';
AO.septin.Monitor.HWUnits      = 'Ampere';
AO.septin.Monitor.PhysicsUnits = 'Radian';

AO.septin.Setpoint.MemberOf = {'MachineConfig';};
AO.septin.Setpoint.Mode = 'Simulator';
AO.septin.Setpoint.DataType = 'Scalar';
AO.septin.Setpoint.ChannelNames = sirius_tb_getname(AO.septin.FamilyName, 'Setpoint', AO.septin.DeviceList);
AO.septin.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.septin.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.septin.Setpoint.Units        = 'Hardware';
AO.septin.Setpoint.HWUnits      = 'Ampere';
AO.septin.Setpoint.PhysicsUnits = 'Radian';
AO.septin.Setpoint.Range        = [0 300];
AO.septin.Setpoint.Tolerance    = .1;
AO.septin.Setpoint.DeltaRespMat = .01;


AO.q1a.FamilyName  = 'q1a';
AO.q1a.MemberOf    = {'PlotFamily'; 'q1a'; 'QUAD'; 'Magnet';};
AO.q1a.DeviceList  = getDeviceList(1,2);
AO.q1a.ElementList = (1:size(AO.q1a.DeviceList,1))';
AO.q1a.Status      = ones(size(AO.q1a.DeviceList,1),1);
AO.q1a.Position    = [];
AO.q1a.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.q1a.DeviceList,1), 1));
AO.q1a.Monitor.MemberOf = {};
AO.q1a.Monitor.Mode = 'Simulator';
AO.q1a.Monitor.DataType = 'Scalar';
AO.q1a.Monitor.ChannelNames = sirius_tb_getname(AO.q1a.FamilyName, 'Monitor', AO.q1a.DeviceList);
AO.q1a.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.q1a.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.q1a.Monitor.Units        = 'Hardware';
AO.q1a.Monitor.HWUnits      = 'Ampere';
AO.q1a.Monitor.PhysicsUnits = 'meter^-2';
AO.q1a.Setpoint.MemberOf      = {'MachineConfig'};
AO.q1a.Setpoint.Mode          = 'Simulator';
AO.q1a.Setpoint.DataType      = 'Scalar';
AO.q1a.Setpoint.ChannelNames = sirius_tb_getname(AO.q1a.FamilyName, 'Setpoint', AO.q1a.DeviceList);
AO.q1a.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.q1a.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.q1a.Setpoint.Units         = 'Hardware';
AO.q1a.Setpoint.HWUnits       = 'Ampere';
AO.q1a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.q1a.Setpoint.Range         = [0 225];
AO.q1a.Setpoint.Tolerance     = 0.2;
AO.q1a.Setpoint.DeltaRespMat  = 0.5; 

AO.q1b.FamilyName  = 'q1b';
AO.q1b.MemberOf    = {'PlotFamily'; 'q1b'; 'QUAD'; 'Magnet';};
AO.q1b.DeviceList  = getDeviceList(1,1);
AO.q1b.ElementList = (1:size(AO.q1b.DeviceList,1))';
AO.q1b.Status      = ones(size(AO.q1b.DeviceList,1),1);
AO.q1b.Position    = [];
AO.q1b.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.q1b.DeviceList,1), 1));
AO.q1b.Monitor.MemberOf = {};
AO.q1b.Monitor.Mode = 'Simulator';
AO.q1b.Monitor.DataType = 'Scalar';
AO.q1b.Monitor.ChannelNames = sirius_tb_getname(AO.q1b.FamilyName, 'Monitor', AO.q1b.DeviceList);
AO.q1b.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.q1b.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.q1b.Monitor.Units        = 'Hardware';
AO.q1b.Monitor.HWUnits      = 'Ampere';
AO.q1b.Monitor.PhysicsUnits = 'meter^-2';
AO.q1b.Setpoint.MemberOf      = {'MachineConfig'};
AO.q1b.Setpoint.Mode          = 'Simulator';
AO.q1b.Setpoint.DataType      = 'Scalar';
AO.q1b.Setpoint.ChannelNames = sirius_tb_getname(AO.q1b.FamilyName, 'Setpoint', AO.q1b.DeviceList);
AO.q1b.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.q1b.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.q1b.Setpoint.Units         = 'Hardware';
AO.q1b.Setpoint.HWUnits       = 'Ampere';
AO.q1b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.q1b.Setpoint.Range         = [0 225];
AO.q1b.Setpoint.Tolerance     = 0.2;
AO.q1b.Setpoint.DeltaRespMat  = 0.5; 

AO.q1c.FamilyName  = 'q1c';
AO.q1c.MemberOf    = {'PlotFamily'; 'q1c'; 'QUAD'; 'Magnet';};
AO.q1c.DeviceList  = getDeviceList(1,1);
AO.q1c.ElementList = (1:size(AO.q1c.DeviceList,1))';
AO.q1c.Status      = ones(size(AO.q1c.DeviceList,1),1);
AO.q1c.Position    = [];
AO.q1c.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.q1c.DeviceList,1), 1));
AO.q1c.Monitor.MemberOf = {};
AO.q1c.Monitor.Mode = 'Simulator';
AO.q1c.Monitor.DataType = 'Scalar';
AO.q1c.Monitor.ChannelNames = sirius_tb_getname(AO.q1c.FamilyName, 'Monitor', AO.q1c.DeviceList);
AO.q1c.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.q1c.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.q1c.Monitor.Units        = 'Hardware';
AO.q1c.Monitor.HWUnits      = 'Ampere';
AO.q1c.Monitor.PhysicsUnits = 'meter^-2';
AO.q1c.Setpoint.MemberOf      = {'MachineConfig'};
AO.q1c.Setpoint.Mode          = 'Simulator';
AO.q1c.Setpoint.DataType      = 'Scalar';
AO.q1c.Setpoint.ChannelNames = sirius_tb_getname(AO.q1c.FamilyName, 'Setpoint', AO.q1c.DeviceList);
AO.q1c.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.q1c.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.q1c.Setpoint.Units         = 'Hardware';
AO.q1c.Setpoint.HWUnits       = 'Ampere';
AO.q1c.Setpoint.PhysicsUnits  = 'meter^-2';
AO.q1c.Setpoint.Range         = [0 225];
AO.q1c.Setpoint.Tolerance     = 0.2;
AO.q1c.Setpoint.DeltaRespMat  = 0.5; 

AO.qd2.FamilyName  = 'qd2';
AO.qd2.MemberOf    = {'PlotFamily'; 'qd2'; 'QUAD'; 'Magnet';};
AO.qd2.DeviceList  = getDeviceList(1,1);
AO.qd2.ElementList = (1:size(AO.qd2.DeviceList,1))';
AO.qd2.Status      = ones(size(AO.qd2.DeviceList,1),1);
AO.qd2.Position    = [];
AO.qd2.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qd2.DeviceList,1), 1));
AO.qd2.Monitor.MemberOf = {};
AO.qd2.Monitor.Mode = 'Simulator';
AO.qd2.Monitor.DataType = 'Scalar';
AO.qd2.Monitor.ChannelNames = sirius_tb_getname(AO.qd2.FamilyName, 'Monitor', AO.qd2.DeviceList);
AO.qd2.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd2.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd2.Monitor.Units        = 'Hardware';
AO.qd2.Monitor.HWUnits      = 'Ampere';
AO.qd2.Monitor.PhysicsUnits = 'meter^-2';
AO.qd2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd2.Setpoint.Mode          = 'Simulator';
AO.qd2.Setpoint.DataType      = 'Scalar';
AO.qd2.Setpoint.ChannelNames = sirius_tb_getname(AO.qd2.FamilyName, 'Setpoint', AO.qd2.DeviceList);
AO.qd2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd2.Setpoint.Units         = 'Hardware';
AO.qd2.Setpoint.HWUnits       = 'Ampere';
AO.qd2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd2.Setpoint.Range         = [0 225];
AO.qd2.Setpoint.Tolerance     = 0.2;
AO.qd2.Setpoint.DeltaRespMat  = 0.5; 

AO.qf2.FamilyName  = 'qf2';
AO.qf2.MemberOf    = {'PlotFamily'; 'qf2'; 'QUAD'; 'Magnet';};
AO.qf2.DeviceList  = getDeviceList(1,1);
AO.qf2.ElementList = (1:size(AO.qf2.DeviceList,1))';
AO.qf2.Status      = ones(size(AO.qf2.DeviceList,1),1);
AO.qf2.Position    = [];
AO.qf2.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qf2.DeviceList,1), 1));
AO.qf2.Monitor.MemberOf = {};
AO.qf2.Monitor.Mode = 'Simulator';
AO.qf2.Monitor.DataType = 'Scalar';
AO.qf2.Monitor.ChannelNames = sirius_tb_getname(AO.qf2.FamilyName, 'Monitor', AO.qf2.DeviceList);
AO.qf2.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf2.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf2.Monitor.Units        = 'Hardware';
AO.qf2.Monitor.HWUnits      = 'Ampere';
AO.qf2.Monitor.PhysicsUnits = 'meter^-2';
AO.qf2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf2.Setpoint.Mode          = 'Simulator';
AO.qf2.Setpoint.DataType      = 'Scalar';
AO.qf2.Setpoint.ChannelNames = sirius_tb_getname(AO.qf2.FamilyName, 'Setpoint', AO.qf2.DeviceList);
AO.qf2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf2.Setpoint.Units         = 'Hardware';
AO.qf2.Setpoint.HWUnits       = 'Ampere';
AO.qf2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf2.Setpoint.Range         = [0 225];
AO.qf2.Setpoint.Tolerance     = 0.2;
AO.qf2.Setpoint.DeltaRespMat  = 0.5; 

AO.qd3a.FamilyName  = 'qd3a';
AO.qd3a.MemberOf    = {'PlotFamily'; 'qd3a'; 'QUAD'; 'Magnet';};
AO.qd3a.DeviceList  = getDeviceList(1,1);
AO.qd3a.ElementList = (1:size(AO.qd3a.DeviceList,1))';
AO.qd3a.Status      = ones(size(AO.qd3a.DeviceList,1),1);
AO.qd3a.Position    = [];
AO.qd3a.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qd3a.DeviceList,1), 1));
AO.qd3a.Monitor.MemberOf = {};
AO.qd3a.Monitor.Mode = 'Simulator';
AO.qd3a.Monitor.DataType = 'Scalar';
AO.qd3a.Monitor.ChannelNames = sirius_tb_getname(AO.qd3a.FamilyName, 'Monitor', AO.qd3a.DeviceList);
AO.qd3a.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd3a.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd3a.Monitor.Units        = 'Hardware';
AO.qd3a.Monitor.HWUnits      = 'Ampere';
AO.qd3a.Monitor.PhysicsUnits = 'meter^-2';
AO.qd3a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd3a.Setpoint.Mode          = 'Simulator';
AO.qd3a.Setpoint.DataType      = 'Scalar';
AO.qd3a.Setpoint.ChannelNames = sirius_tb_getname(AO.qd3a.FamilyName, 'Setpoint', AO.qd3a.DeviceList);
AO.qd3a.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd3a.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd3a.Setpoint.Units         = 'Hardware';
AO.qd3a.Setpoint.HWUnits       = 'Ampere';
AO.qd3a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd3a.Setpoint.Range         = [0 225];
AO.qd3a.Setpoint.Tolerance     = 0.2;
AO.qd3a.Setpoint.DeltaRespMat  = 0.5; 

AO.qf3a.FamilyName  = 'qf3a';
AO.qf3a.MemberOf    = {'PlotFamily'; 'qf3a'; 'QUAD'; 'Magnet';};
AO.qf3a.DeviceList  = getDeviceList(1,1);
AO.qf3a.ElementList = (1:size(AO.qf3a.DeviceList,1))';
AO.qf3a.Status      = ones(size(AO.qf3a.DeviceList,1),1);
AO.qf3a.Position    = [];
AO.qf3a.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qf3a.DeviceList,1), 1));
AO.qf3a.Monitor.MemberOf = {};
AO.qf3a.Monitor.Mode = 'Simulator';
AO.qf3a.Monitor.DataType = 'Scalar';
AO.qf3a.Monitor.ChannelNames = sirius_tb_getname(AO.qf3a.FamilyName, 'Monitor', AO.qf3a.DeviceList);
AO.qf3a.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3a.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf3a.Monitor.Units        = 'Hardware';
AO.qf3a.Monitor.HWUnits      = 'Ampere';
AO.qf3a.Monitor.PhysicsUnits = 'meter^-2';
AO.qf3a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf3a.Setpoint.Mode          = 'Simulator';
AO.qf3a.Setpoint.DataType      = 'Scalar';
AO.qf3a.Setpoint.ChannelNames = sirius_tb_getname(AO.qf3a.FamilyName, 'Setpoint', AO.qf3a.DeviceList);
AO.qf3a.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3a.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf3a.Setpoint.Units         = 'Hardware';
AO.qf3a.Setpoint.HWUnits       = 'Ampere';
AO.qf3a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3a.Setpoint.Range         = [0 225];
AO.qf3a.Setpoint.Tolerance     = 0.2;
AO.qf3a.Setpoint.DeltaRespMat  = 0.5; 

AO.qf3b.FamilyName  = 'qf3b';
AO.qf3b.MemberOf    = {'PlotFamily'; 'qf3b'; 'QUAD'; 'Magnet';};
AO.qf3b.DeviceList  = getDeviceList(1,1);
AO.qf3b.ElementList = (1:size(AO.qf3b.DeviceList,1))';
AO.qf3b.Status      = ones(size(AO.qf3b.DeviceList,1),1);
AO.qf3b.Position    = [];
AO.qf3b.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qf3b.DeviceList,1), 1));
AO.qf3b.Monitor.MemberOf = {};
AO.qf3b.Monitor.Mode = 'Simulator';
AO.qf3b.Monitor.DataType = 'Scalar';
AO.qf3b.Monitor.ChannelNames = sirius_tb_getname(AO.qf3b.FamilyName, 'Monitor', AO.qf3b.DeviceList);
AO.qf3b.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3b.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf3b.Monitor.Units        = 'Hardware';
AO.qf3b.Monitor.HWUnits      = 'Ampere';
AO.qf3b.Monitor.PhysicsUnits = 'meter^-2';
AO.qf3b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf3b.Setpoint.Mode          = 'Simulator';
AO.qf3b.Setpoint.DataType      = 'Scalar';
AO.qf3b.Setpoint.ChannelNames = sirius_tb_getname(AO.qf3b.FamilyName, 'Setpoint', AO.qf3b.DeviceList);
AO.qf3b.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3b.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf3b.Setpoint.Units         = 'Hardware';
AO.qf3b.Setpoint.HWUnits       = 'Ampere';
AO.qf3b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3b.Setpoint.Range         = [0 225];
AO.qf3b.Setpoint.Tolerance     = 0.2;
AO.qf3b.Setpoint.DeltaRespMat  = 0.5; 

AO.qd3b.FamilyName  = 'qd3b';
AO.qd3b.MemberOf    = {'PlotFamily'; 'qd3b'; 'QUAD'; 'Magnet';};
AO.qd3b.DeviceList  = getDeviceList(1,1);
AO.qd3b.ElementList = (1:size(AO.qd3b.DeviceList,1))';
AO.qd3b.Status      = ones(size(AO.qd3b.DeviceList,1),1);
AO.qd3b.Position    = [];
AO.qd3b.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qd3b.DeviceList,1), 1));
AO.qd3b.Monitor.MemberOf = {};
AO.qd3b.Monitor.Mode = 'Simulator';
AO.qd3b.Monitor.DataType = 'Scalar';
AO.qd3b.Monitor.ChannelNames = sirius_tb_getname(AO.qd3b.FamilyName, 'Monitor', AO.qd3b.DeviceList);
AO.qd3b.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd3b.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd3b.Monitor.Units        = 'Hardware';
AO.qd3b.Monitor.HWUnits      = 'Ampere';
AO.qd3b.Monitor.PhysicsUnits = 'meter^-2';
AO.qd3b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd3b.Setpoint.Mode          = 'Simulator';
AO.qd3b.Setpoint.DataType      = 'Scalar';
AO.qd3b.Setpoint.ChannelNames = sirius_tb_getname(AO.qd3b.FamilyName, 'Setpoint', AO.qd3b.DeviceList);
AO.qd3b.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd3b.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd3b.Setpoint.Units         = 'Hardware';
AO.qd3b.Setpoint.HWUnits       = 'Ampere';
AO.qd3b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd3b.Setpoint.Range         = [0 225];
AO.qd3b.Setpoint.Tolerance     = 0.2;
AO.qd3b.Setpoint.DeltaRespMat  = 0.5; 

AO.qf4.FamilyName  = 'qf4';
AO.qf4.MemberOf    = {'PlotFamily'; 'qf4'; 'QUAD'; 'Magnet';};
AO.qf4.DeviceList  = getDeviceList(1,1);
AO.qf4.ElementList = (1:size(AO.qf4.DeviceList,1))';
AO.qf4.Status      = ones(size(AO.qf4.DeviceList,1),1);
AO.qf4.Position    = [];
AO.qf4.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qf4.DeviceList,1), 1));
AO.qf4.Monitor.MemberOf = {};
AO.qf4.Monitor.Mode = 'Simulator';
AO.qf4.Monitor.DataType = 'Scalar';
AO.qf4.Monitor.ChannelNames  = sirius_tb_getname(AO.qf4.FamilyName, 'Monitor', AO.qf4.DeviceList);
AO.qf4.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf4.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf4.Monitor.Units        = 'Hardware';
AO.qf4.Monitor.HWUnits      = 'Ampere';
AO.qf4.Monitor.PhysicsUnits = 'meter^-2';
AO.qf4.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf4.Setpoint.Mode          = 'Simulator';
AO.qf4.Setpoint.DataType      = 'Scalar';
AO.qf4.Setpoint.ChannelNames  = sirius_tb_getname(AO.qf4.FamilyName, 'Setpoint', AO.qf4.DeviceList);
AO.qf4.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf4.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf4.Setpoint.Units         = 'Hardware';
AO.qf4.Setpoint.HWUnits       = 'Ampere';
AO.qf4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf4.Setpoint.Range         = [0 225];
AO.qf4.Setpoint.Tolerance     = 0.2;
AO.qf4.Setpoint.DeltaRespMat  = 0.5; 

AO.qd4.FamilyName  = 'qd4';
AO.qd4.MemberOf    = {'PlotFamily'; 'qd4'; 'QUAD'; 'Magnet';};
AO.qd4.DeviceList  = getDeviceList(1,1);
AO.qd4.ElementList = (1:size(AO.qd4.DeviceList,1))';
AO.qd4.Status      = ones(size(AO.qd4.DeviceList,1),1);
AO.qd4.Position    = [];
AO.qd4.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qd4.DeviceList,1), 1));
AO.qd4.Monitor.MemberOf = {};
AO.qd4.Monitor.Mode = 'Simulator';
AO.qd4.Monitor.DataType = 'Scalar';
AO.qd4.Monitor.ChannelNames  = sirius_tb_getname(AO.qd4.FamilyName, 'Monitor', AO.qd4.DeviceList);
AO.qd4.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd4.Monitor.Units        = 'Hardware';
AO.qd4.Monitor.HWUnits      = 'Ampere';
AO.qd4.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4.Setpoint.Mode          = 'Simulator';
AO.qd4.Setpoint.DataType      = 'Scalar';
AO.qd4.Setpoint.ChannelNames  = sirius_tb_getname(AO.qd4.FamilyName, 'Setpoint', AO.qd4.DeviceList);
AO.qd4.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd4.Setpoint.Units         = 'Hardware';
AO.qd4.Setpoint.HWUnits       = 'Ampere';
AO.qd4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4.Setpoint.Range         = [0 225];
AO.qd4.Setpoint.Tolerance     = 0.2;
AO.qd4.Setpoint.DeltaRespMat  = 0.5; 

AO.qf5.FamilyName  = 'qf5';
AO.qf5.MemberOf    = {'PlotFamily'; 'qf5'; 'QUAD'; 'Magnet';};
AO.qf5.DeviceList  = getDeviceList(1,1);
AO.qf5.ElementList = (1:size(AO.qf5.DeviceList,1))';
AO.qf5.Status      = ones(size(AO.qf5.DeviceList,1),1);
AO.qf5.Position    = [];
AO.qf5.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qf5.DeviceList,1), 1));
AO.qf5.Monitor.MemberOf = {};
AO.qf5.Monitor.Mode = 'Simulator';
AO.qf5.Monitor.DataType = 'Scalar';
AO.qf5.Monitor.ChannelNames = sirius_tb_getname(AO.qf5.FamilyName, 'Monitor', AO.qf5.DeviceList);
AO.qf5.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf5.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf5.Monitor.Units        = 'Hardware';
AO.qf5.Monitor.HWUnits      = 'Ampere';
AO.qf5.Monitor.PhysicsUnits = 'meter^-2';
AO.qf5.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf5.Setpoint.Mode          = 'Simulator';
AO.qf5.Setpoint.DataType      = 'Scalar';
AO.qf5.Setpoint.ChannelNames = sirius_tb_getname(AO.qf5.FamilyName, 'Setpoint', AO.qf5.DeviceList);
AO.qf5.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf5.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf5.Setpoint.Units         = 'Hardware';
AO.qf5.Setpoint.HWUnits       = 'Ampere';
AO.qf5.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf5.Setpoint.Range         = [0 225];
AO.qf5.Setpoint.Tolerance     = 0.2;
AO.qf5.Setpoint.DeltaRespMat  = 0.5; 

AO.qd5.FamilyName  = 'qd5';
AO.qd5.MemberOf    = {'PlotFamily'; 'qd5'; 'QUAD'; 'Magnet';};
AO.qd5.DeviceList  = getDeviceList(1,1);
AO.qd5.ElementList = (1:size(AO.qd5.DeviceList,1))';
AO.qd5.Status      = ones(size(AO.qd5.DeviceList,1),1);
AO.qd5.Position    = [];
AO.qd5.ExcitationCurves = sirius_getexcdata(repmat('tbma-q', size(AO.qd5.DeviceList,1), 1));
AO.qd5.Monitor.MemberOf = {};
AO.qd5.Monitor.Mode = 'Simulator';
AO.qd5.Monitor.DataType = 'Scalar';
AO.qd5.Monitor.ChannelNames = sirius_tb_getname(AO.qd5.FamilyName, 'Monitor', AO.qd5.DeviceList);
AO.qd5.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd5.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd5.Monitor.Units        = 'Hardware';
AO.qd5.Monitor.HWUnits      = 'Ampere';
AO.qd5.Monitor.PhysicsUnits = 'meter^-2';
AO.qd5.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd5.Setpoint.Mode          = 'Simulator';
AO.qd5.Setpoint.DataType      = 'Scalar';
AO.qd5.Setpoint.ChannelNames = sirius_tb_getname(AO.qd5.FamilyName, 'Setpoint', AO.qd5.DeviceList);
AO.qd5.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd5.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd5.Setpoint.Units         = 'Hardware';
AO.qd5.Setpoint.HWUnits       = 'Ampere';
AO.qd5.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd5.Setpoint.Range         = [0 225];
AO.qd5.Setpoint.Tolerance     = 0.2;
AO.qd5.Setpoint.DeltaRespMat  = 0.5; 

%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% hcm
AO.hcm.FamilyName  = 'hcm';
AO.hcm.MemberOf    = {'PlotFamily'; 'COR'; 'hcm'; 'Magnet'};
AO.hcm.DeviceList  = getDeviceList(1,1);
AO.hcm.ElementList = (1:size(AO.hcm.DeviceList,1))';
AO.hcm.Status      = ones(size(AO.hcm.DeviceList,1),1);
AO.hcm.Position    = [];
AO.hcm.ExcitationCurves = sirius_getexcdata(repmat('tbma-ch', size(AO.hcm.DeviceList,1), 1));
AO.hcm.Monitor.MemberOf = {'Horizontal'; 'COR'; 'hcm'; 'Magnet';};
AO.hcm.Monitor.ChannelNames = sirius_tb_getname(AO.hcm.FamilyName, 'Monitor', AO.hcm.DeviceList);
AO.hcm.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.hcm.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.hcm.Monitor.Mode = 'Simulator';
AO.hcm.Monitor.DataType = 'Scalar';
AO.hcm.Monitor.Units        = 'Physics';
AO.hcm.Monitor.HWUnits      = 'Ampere';
AO.hcm.Monitor.PhysicsUnits = 'Radian';
AO.hcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.hcm.Setpoint.ChannelNames = sirius_tb_getname(AO.hcm.FamilyName, 'Setpoint', AO.hcm.DeviceList);
AO.hcm.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.hcm.Setpoint.Physics2HWFcn = @sirius_ph2hw;
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
AO.vcm.DeviceList  = getDeviceList(1,5);
AO.vcm.ElementList = (1:size(AO.vcm.DeviceList,1))';
AO.vcm.Status      = ones(size(AO.vcm.DeviceList,1),1);
AO.vcm.Position    = [];
AO.vcm.ExcitationCurves = sirius_getexcdata(repmat('tbma-cv', size(AO.vcm.DeviceList,1), 1));
AO.vcm.Monitor.MemberOf = {'Vertical'; 'COR'; 'vcm'; 'Magnet';};
AO.vcm.Monitor.ChannelNames = sirius_tb_getname(AO.vcm.FamilyName, 'Monitor', AO.vcm.DeviceList);
AO.vcm.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.vcm.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.vcm.Monitor.Mode = 'Simulator';
AO.vcm.Monitor.DataType = 'Scalar';
AO.vcm.Monitor.Units        = 'Physics';
AO.vcm.Monitor.HWUnits      = 'Ampere';
AO.vcm.Monitor.PhysicsUnits = 'Radian';
AO.vcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.vcm.Setpoint.ChannelNames = sirius_tb_getname(AO.vcm.FamilyName, 'Setpoint', AO.vcm.DeviceList);
AO.vcm.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.vcm.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.vcm.Setpoint.Mode = 'Simulator';
AO.vcm.Setpoint.DataType = 'Scalar';
AO.vcm.Setpoint.Units        = 'Physics';
AO.vcm.Setpoint.HWUnits      = 'Ampere';
AO.vcm.Setpoint.PhysicsUnits = 'Radian';
AO.vcm.Setpoint.Range        = [-10 10];
AO.vcm.Setpoint.Tolerance    = 0.00001;
AO.vcm.Setpoint.DeltaRespMat = 0.0005; 


% bpmx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(1,5);
AO.bpmx.ElementList = (1:size(AO.bpmx.DeviceList,1))';
AO.bpmx.Status      = ones(size(AO.bpmx.DeviceList,1),1);
AO.bpmx.Position    = [];
AO.bpmx.Golden      = zeros(length(AO.bpmx.ElementList),1);
AO.bpmx.Offset      = zeros(length(AO.bpmx.ElementList),1);

AO.bpmx.Monitor.MemberOf = {'bpmx'; 'Monitor';};
AO.bpmx.Monitor.ChannelNames = sirius_tb_getname(AO.bpmx.FamilyName, 'Monitor', AO.bpmx.DeviceList);
AO.bpmx.Monitor.Mode = 'Simulator';
AO.bpmx.Monitor.DataType = 'Scalar';
AO.bpmx.Monitor.HW2PhysicsParams = 1e-6;  % HW [um], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams =  1e6;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'um';
AO.bpmx.Monitor.PhysicsUnits = 'meter';

% bpmy
AO.bpmy.FamilyName  = 'bpmy';
AO.bpmy.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(1,5);
AO.bpmy.ElementList = (1:size(AO.bpmy.DeviceList,1))';
AO.bpmy.Status      = ones(size(AO.bpmy.DeviceList,1),1);
AO.bpmy.Position    = [];
AO.bpmy.Golden      = zeros(length(AO.bpmy.ElementList),1);
AO.bpmy.Offset      = zeros(length(AO.bpmy.ElementList),1);

AO.bpmy.Monitor.MemberOf = {'bpmy'; 'Monitor';};
AO.bpmy.Monitor.ChannelNames = sirius_tb_getname(AO.bpmy.FamilyName, 'Monitor', AO.bpmy.DeviceList);
AO.bpmy.Monitor.Mode = 'Simulator';
AO.bpmy.Monitor.DataType = 'Scalar';
AO.bpmy.Monitor.HW2PhysicsParams = 1e-6;  % HW [um], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams =  1e6;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'um';
AO.bpmy.Monitor.PhysicsUnits = 'meter';

% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);

 
function DList = getDeviceList(NSector,NDevices)

DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end
