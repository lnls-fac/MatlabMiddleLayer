function lnls1_init
%LNLS1_INIT - MML initialization file for the VUV ring at LNLS1
%
%  lnls1_init
%
%  See also setoperationalmode
%
%  History:
%
% 2012-01-23    adiciona folder 'modes' ao path do Matlab
% 2011-04-30    reestrutura fam???lia AON11 (X.R.R.)


setao([]);
setad([]);


% Base on the location of this file
[LNLS1_ROOT, tmp1, tmp2] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir = [LNLS1_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [LNLS1_ROOT, filesep, 'lattices_def'];
setad(AD);

% Add additional directories with LNLS1 specific stuff.
MMLROOT = getmmlroot('IgnoreTheAD');
addpath(fullfile(MMLROOT,'machine','LNLS1','StorageRing','scripts'), '-begin');
addpath(fullfile(MMLROOT,'machine','LNLS1','StorageRing','scripts','FOFB'), '-begin');
addpath(fullfile(MMLROOT,'machine','LNLS1','StorageRing','modes'), '-begin');



%% Symmetry Families
%  -----------------

AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BEND.DeviceList  = build_devicelist(6,2); 
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status      = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position    = [];
AO.BEND.CommonNames  = ['ADI01'; 'ADI02'; 'ADI03'; 'ADI04'; 'ADI05'; 'ADI06'; 'ADI07'; 'ADI08'; 'ADI09'; 'ADI10'; 'ADI11'; 'ADI12']; 
BendCorrectionFactor = (1.37 / 1.371517170879213);
% integrated field in excitation curves for dipoles are measured on wrong approximate paths 
% (arc of circle till physical magnet bordar + straight section.
% The factor should correct it.
AO.BEND.ExcitationCurves = lnls1_getexcdata(AO.BEND.CommonNames, BendCorrectionFactor);
AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = lnls1_getname('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @bend2gev;
AO.BEND.Monitor.Physics2HWFcn = @gev2bend;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.MemberOf = {'Save/Restore' ;};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = lnls1_getname('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn = @gev2bend;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.Range        = [0 300];
AO.BEND.Setpoint.Tolerance    = .1;
AO.BEND.Setpoint.DeltaRespMat = .2;

AO.QF.FamilyName             = 'QF';
AO.QF.MemberOf               = {'PlotFamily'; 'QF'; 'QUAD'; 'Tune Corrector'};
AO.QF.DeviceList             = build_devicelist(6,2);
AO.QF.ElementList            = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status                 = ones(size(AO.QF.DeviceList,1),1); 
AO.QF.CommonNames            = ['AQF01B'; 'AQF03A'; 'AQF03B'; 'AQF05A'; 'AQF05B'; 'AQF07A'; 'AQF07B';'AQF09A'; 'AQF09B'; 'AQF11A'; 'AQF11B'; 'AQF01A';];
AO.QF.ExcitationCurves       = lnls1_getexcdata(['A2QF01'; 'A2QF03'; 'A2QF03'; 'A2QF05'; 'A2QF05'; 'A2QF07'; 'A2QF07';'A2QF09'; 'A2QF09'; 'A2QF11'; 'A2QF11'; 'A2QF01';], 1);
AO.QF.Monitor.MemberOf       = {};
AO.QF.Monitor.Mode           = 'Simulator';
AO.QF.Monitor.DataType       = 'Scalar';
AO.QF.Monitor.ChannelNames   = lnls1_getname(AO.QF.FamilyName, 'Monitor');
AO.QF.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.QF.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.QF.Monitor.Units          = 'Hardware';
AO.QF.Monitor.HWUnits        = 'Ampere';
AO.QF.Monitor.PhysicsUnits   = 'meter^-2';
AO.QF.Monitor.SpecialFunctionGet = @lnls1_quadget;
AO.QF.Monitor.SpecialFunctionSet = @lnls1_quadset;
AO.QF.Setpoint.MemberOf      = {'Save'};
AO.QF.Setpoint.Mode          = 'Simulator';
AO.QF.Setpoint.DataType      = 'Scalar';
AO.QF.Setpoint.ChannelNames  = lnls1_getname(AO.QF.FamilyName, 'Setpoint');
AO.QF.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.QF.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.QF.Setpoint.Units         = 'Hardware';
AO.QF.Setpoint.HWUnits       = 'Ampere';
AO.QF.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF.Setpoint.Range         = [0 225];
%AO.QF.Setpoint.Tolerance     = 0.10;
AO.QF.Setpoint.DeltaRespMat  = 0.15; 
AO.QF.Setpoint.SpecialFunctionGet = @lnls1_quadget;
AO.QF.Setpoint.SpecialFunctionSet = @lnls1_quadset;

AO.QD.FamilyName             = 'QD';
AO.QD.MemberOf               = {'PlotFamily'; 'QD'; 'QUAD'; 'Tune Corrector'};
AO.QD.DeviceList             = build_devicelist(6,2);
AO.QD.ElementList            = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status                 = ones(size(AO.QD.DeviceList,1),1); 
AO.QD.CommonNames            = ['AQD01B'; 'AQD03A'; 'AQD03B'; 'AQD05A'; 'AQD05B'; 'AQD07A'; 'AQD07B';'AQD09A'; 'AQD09B'; 'AQD11A'; 'AQD11B'; 'AQD01A';];
AO.QD.ExcitationCurves       = lnls1_getexcdata(['A2QD01'; 'A2QD03'; 'A2QD03'; 'A2QD05'; 'A2QD05'; 'A2QD07'; 'A2QD07';'A2QD09'; 'A2QD09'; 'A2QD11'; 'A2QD11'; 'A2QD01';], 1);
AO.QD.Monitor.MemberOf       = {};
AO.QD.Monitor.Mode           = 'Simulator';
AO.QD.Monitor.DataType       = 'Scalar';
AO.QD.Monitor.ChannelNames   = lnls1_getname(AO.QD.FamilyName, 'Monitor');
AO.QD.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.QD.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.QD.Monitor.Units          = 'Hardware';
AO.QD.Monitor.HWUnits        = 'Ampere';
AO.QD.Monitor.PhysicsUnits   = 'meter^-2';
AO.QD.Monitor.SpecialFunctionGet = @lnls1_quadget;
AO.QD.Monitor.SpecialFunctionSet = @lnls1_quadset;
AO.QD.Setpoint.MemberOf      = {'Save'};
AO.QD.Setpoint.Mode          = 'Simulator';
AO.QD.Setpoint.DataType      = 'Scalar';
AO.QD.Setpoint.ChannelNames  = lnls1_getname(AO.QD.FamilyName, 'Setpoint');
AO.QD.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.QD.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.QD.Setpoint.Units         = 'Hardware';
AO.QD.Setpoint.HWUnits       = 'Ampere';
AO.QD.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD.Setpoint.Range         = [0 225];
%AO.QD.Setpoint.Tolerance     = 0.10;
AO.QD.Setpoint.DeltaRespMat  = 0.15; 
AO.QD.Setpoint.SpecialFunctionGet = @lnls1_quadget;
AO.QD.Setpoint.SpecialFunctionSet = @lnls1_quadset;

AO.QFC.FamilyName             = 'QFC';
AO.QFC.MemberOf               = {'PlotFamily'; 'QFC'; 'QUAD';};
AO.QFC.DeviceList             = build_devicelist(6,2);
AO.QFC.ElementList            = (1:size(AO.QFC.DeviceList,1))';
AO.QFC.Status                 = ones(size(AO.QFC.DeviceList,1),1); 
AO.QFC.CommonNames            = ['AQF02A'; 'AQF02B'; 'AQF04A'; 'AQF04B'; 'AQF06A'; 'AQF06B'; 'AQF08A'; 'AQF08B';'AQF10A'; 'AQF10B'; 'AQF12A'; 'AQF12B';];
AO.QFC.ExcitationCurves       = lnls1_getexcdata(['A6QF01'; 'A6QF02'; 'A6QF02'; 'A6QF01'; 'A6QF01'; 'A6QF02'; 'A6QF02';'A6QF01'; 'A6QF01'; 'A6QF02'; 'A6QF02'; 'A6QF01';], 1);
AO.QFC.Monitor.MemberOf       = {};
AO.QFC.Monitor.Mode           = 'Simulator';
AO.QFC.Monitor.DataType       = 'Scalar';
AO.QFC.Monitor.ChannelNames   = lnls1_getname(AO.QFC.FamilyName, 'Monitor');
AO.QFC.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.QFC.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.QFC.Monitor.Units          = 'Hardware';
AO.QFC.Monitor.HWUnits        = 'Ampere';
AO.QFC.Monitor.PhysicsUnits   = 'meter^-2';
AO.QFC.Monitor.SpecialFunctionGet = @lnls1_quadget;
AO.QFC.Monitor.SpecialFunctionSet = @lnls1_quadset;
AO.QFC.Setpoint.MemberOf      = {'Save'};
AO.QFC.Setpoint.Mode          = 'Simulator';
AO.QFC.Setpoint.DataType      = 'Scalar';
AO.QFC.Setpoint.ChannelNames  = lnls1_getname(AO.QFC.FamilyName, 'Setpoint');
AO.QFC.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.QFC.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.QFC.Setpoint.Units         = 'Hardware';
AO.QFC.Setpoint.HWUnits       = 'Ampere';
AO.QFC.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QFC.Setpoint.Range         = [0 155];
%AO.QFC.Setpoint.Tolerance     = 0.10;
AO.QFC.Setpoint.DeltaRespMat  = 0.15; 
AO.QFC.Setpoint.SpecialFunctionGet = @lnls1_quadget;
AO.QFC.Setpoint.SpecialFunctionSet = @lnls1_quadset;

AO.SF.FamilyName             = 'SF';
AO.SF.MemberOf               = {'PlotFamily'; 'SF'; 'SEXT'; 'Chromaticity Corrector'};
AO.SF.DeviceList             = build_devicelist(6,1);
AO.SF.ElementList            = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status                 = ones(size(AO.SF.DeviceList,1),1);
AO.SF.CommonNames            = ['ASF02'; 'ASF04'; 'ASF06'; 'ASF08'; 'ASF10'; 'ASF12']; 
AO.SF.ExcitationCurves       = lnls1_getexcdata(['A6SF';'A6SF';'A6SF';'A6SF';'A6SF';'A6SF';], 1);
AO.SF.Monitor.MemberOf       = {};
AO.SF.Monitor.Mode           = 'Simulator';
AO.SF.Monitor.DataType       = 'Scalar';
AO.SF.Monitor.ChannelNames   = lnls1_getname(AO.SF.FamilyName, 'Monitor', AO.SF.DeviceList);
AO.SF.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.SF.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.SF.Monitor.Units          = 'Hardware';
AO.SF.Monitor.HWUnits        = 'Ampere';
AO.SF.Monitor.PhysicsUnits   = 'meter^-3';
AO.SF.Setpoint.MemberOf      = {'Save'};
AO.SF.Setpoint.Mode          = 'Simulator';
AO.SF.Setpoint.DataType      = 'Scalar';
AO.SF.Setpoint.ChannelNames  = lnls1_getname(AO.SF.FamilyName, 'Setpoint', AO.SF.DeviceList);
AO.SF.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.SF.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.SF.Setpoint.Units         = 'Hardware';
AO.SF.Setpoint.HWUnits       = 'Ampere';
AO.SF.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SF.Setpoint.Range         = [0 220];
AO.SF.Setpoint.Tolerance     = 1.0; % 2015-10-16  currently there is a big diff between setpoint and readback
AO.SF.Setpoint.DeltaRespMat  = .1;

AO.SD.FamilyName             = 'SD';
AO.SD.MemberOf               = {'PlotFamily'; 'SD'; 'SEXT'; 'Chromaticity Corrector'};
AO.SD.DeviceList             = build_devicelist(6,2);
AO.SD.ElementList            = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status                 = ones(size(AO.SD.DeviceList,1),1);
AO.SD.CommonNames            = ['ASD02A'; 'ASD02B'; 'ASD04A'; 'ASD04B'; 'ASD06A'; 'ASD06B'; 'ASD08A'; 'ASD08B'; 'ASD10A'; 'ASD10B'; 'ASD12A'; 'ASD12B']; 
AO.SD.ExcitationCurves       = lnls1_getexcdata(['A6SD01';'A6SD02';'A6SD02';'A6SD01';'A6SD01';'A6SD02';'A6SD02';'A6SD01';'A6SD01';'A6SD02';'A6SD02';'A6SD01';], 1);
AO.SD.Monitor.MemberOf       = {};
AO.SD.Monitor.Mode           = 'Simulator';
AO.SD.Monitor.DataType       = 'Scalar';
AO.SD.Monitor.ChannelNames   = lnls1_getname(AO.SD.FamilyName, 'Monitor', AO.SD.DeviceList);
AO.SD.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.SD.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.SD.Monitor.Units          = 'Hardware';
AO.SD.Monitor.HWUnits        = 'Ampere';
AO.SD.Monitor.PhysicsUnits   = 'meter^-3';
AO.SD.Setpoint.MemberOf      = {'Save' ;};
AO.SD.Setpoint.Mode          = 'Simulator';
AO.SD.Setpoint.DataType      = 'Scalar';
AO.SD.Setpoint.ChannelNames  = lnls1_getname(AO.SD.FamilyName, 'Setpoint', AO.SD.DeviceList);
AO.SD.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.SD.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.SD.Setpoint.Units         = 'Hardware';
AO.SD.Setpoint.HWUnits       = 'Ampere';
AO.SD.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SD.Setpoint.Range         = [0 125];
AO.SD.Setpoint.Tolerance     = 0.1;    
AO.SD.Setpoint.DeltaRespMat  = .1;


%% Hardware Families

% Leitura e Ajustes nestas fam???lias n???o acessam/modificam setpoints de shunts!


AO.A2QF01.FamilyName             = 'A2QF01';
AO.A2QF01.MemberOf               = {'A2QF01'; 'QUAD'; 'Magnet'; };
AO.A2QF01.DeviceList             = [1 1; 6 1];
AO.A2QF01.ElementList            = (1:size(AO.A2QF01.DeviceList,1))';
AO.A2QF01.Status                 = ones(size(AO.A2QF01.DeviceList,1),1); 
AO.A2QF01.CommonNames            = ['AQF01B'; 'AQF01A';];
%AO.A2QF01.ExcitationCurves       = lnls1_getexcdata(AO.A2QF01.CommonNames, 1);
AO.A2QF01.ExcitationCurves       = lnls1_getexcdata(['A2QF01';'A2QF01'], 1);
AO.A2QF01.Monitor.MemberOf       = {};
AO.A2QF01.Monitor.Mode           = 'Simulator';
AO.A2QF01.Monitor.DataType       = 'Scalar';
AO.A2QF01.Monitor.ChannelNames   = lnls1_getname(AO.A2QF01.FamilyName, 'Monitor');
AO.A2QF01.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QF01.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QF01.Monitor.Units          = 'Hardware';
AO.A2QF01.Monitor.HWUnits        = 'Ampere';
AO.A2QF01.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QF01.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QF01.Setpoint.Mode          = 'Simulator';
AO.A2QF01.Setpoint.DataType      = 'Scalar';
AO.A2QF01.Setpoint.ChannelNames  = lnls1_getname(AO.A2QF01.FamilyName, 'Setpoint');
AO.A2QF01.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QF01.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QF01.Setpoint.Units         = 'Hardware';
AO.A2QF01.Setpoint.HWUnits       = 'Ampere';
AO.A2QF01.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QF01.Setpoint.Range         = [0 225];
AO.A2QF01.Setpoint.Tolerance     = 0.1;

AO.A2QF03.FamilyName             = 'A2QF03';
AO.A2QF03.MemberOf               = {'A2QF03'; 'QUAD'; 'Magnet';};
AO.A2QF03.DeviceList             = [1 1; 2 1];
AO.A2QF03.ElementList            = (1:size(AO.A2QF03.DeviceList,1))';
AO.A2QF03.Status                 = ones(size(AO.A2QF03.DeviceList,1),1); 
AO.A2QF03.CommonNames            = ['AQF03A'; 'AQF03B'];
%AO.A2QF03.ExcitationCurves       = lnls1_getexcdata(AO.A2QF03.CommonNames, 1);
AO.A2QF03.ExcitationCurves       = lnls1_getexcdata(['A2QF03';'A2QF03'], 1);
AO.A2QF03.Monitor.MemberOf       = {};
AO.A2QF03.Monitor.Mode           = 'Simulator';
AO.A2QF03.Monitor.DataType       = 'Scalar';
AO.A2QF03.Monitor.ChannelNames   = lnls1_getname(AO.A2QF03.FamilyName, 'Monitor');
AO.A2QF03.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QF03.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QF03.Monitor.Units          = 'Hardware';
AO.A2QF03.Monitor.HWUnits        = 'Ampere';
AO.A2QF03.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QF03.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QF03.Setpoint.Mode          = 'Simulator';
AO.A2QF03.Setpoint.DataType      = 'Scalar';
AO.A2QF03.Setpoint.ChannelNames  = lnls1_getname(AO.A2QF03.FamilyName, 'Setpoint');
AO.A2QF03.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QF03.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QF03.Setpoint.Units         = 'Hardware';
AO.A2QF03.Setpoint.HWUnits       = 'Ampere';
AO.A2QF03.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QF03.Setpoint.Range         = [0 225];
AO.A2QF03.Setpoint.Tolerance     = 0.2;
AO.A2QF03.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QF05.FamilyName             = 'A2QF05';
AO.A2QF05.MemberOf               = {'A2QF05'; 'QUAD'; 'Magnet';};
AO.A2QF05.DeviceList             = [2 1; 3 1];
AO.A2QF05.ElementList            = (1:size(AO.A2QF05.DeviceList,1))';
AO.A2QF05.Status                 = ones(size(AO.A2QF05.DeviceList,1),1); 
AO.A2QF05.CommonNames            = ['AQF05A'; 'AQF05B'];
%AO.A2QF05.ExcitationCurves       = lnls1_getexcdata(AO.A2QF05.CommonNames, 1);
AO.A2QF05.ExcitationCurves       = lnls1_getexcdata(['A2QF05';'A2QF05'], 1);
AO.A2QF05.Monitor.MemberOf       = {};
AO.A2QF05.Monitor.Mode           = 'Simulator';
AO.A2QF05.Monitor.DataType       = 'Scalar';
AO.A2QF05.Monitor.ChannelNames   = lnls1_getname(AO.A2QF05.FamilyName, 'Monitor');
AO.A2QF05.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QF05.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QF05.Monitor.Units          = 'Hardware';
AO.A2QF05.Monitor.HWUnits        = 'Ampere';
AO.A2QF05.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QF05.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QF05.Setpoint.Mode          = 'Simulator';
AO.A2QF05.Setpoint.DataType      = 'Scalar';
AO.A2QF05.Setpoint.ChannelNames  = lnls1_getname(AO.A2QF05.FamilyName, 'Setpoint');
AO.A2QF05.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QF05.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QF05.Setpoint.Units         = 'Hardware';
AO.A2QF05.Setpoint.HWUnits       = 'Ampere';
AO.A2QF05.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QF05.Setpoint.Range         = [0 225];
AO.A2QF05.Setpoint.Tolerance     = 0.1;
AO.A2QF05.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QF07.FamilyName             = 'A2QF07';
AO.A2QF07.MemberOf               = {'A2QF07'; 'QUAD'; 'Magnet';};
AO.A2QF07.DeviceList             = [3 1; 4 1];
AO.A2QF07.ElementList            = (1:size(AO.A2QF07.DeviceList,1))';
AO.A2QF07.Status                 = ones(size(AO.A2QF07.DeviceList,1),1); 
AO.A2QF07.CommonNames            = ['AQF07A'; 'AQF07B'];
%AO.A2QF07.ExcitationCurves       = lnls1_getexcdata(AO.A2QF07.CommonNames, 1);
AO.A2QF07.ExcitationCurves       = lnls1_getexcdata(['A2QF07';'A2QF07'], 1);
AO.A2QF07.Monitor.MemberOf       = {};
AO.A2QF07.Monitor.Mode           = 'Simulator';
AO.A2QF07.Monitor.DataType       = 'Scalar';
AO.A2QF07.Monitor.ChannelNames   = lnls1_getname(AO.A2QF07.FamilyName, 'Monitor');
AO.A2QF07.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QF07.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QF07.Monitor.Units          = 'Hardware';
AO.A2QF07.Monitor.HWUnits        = 'Ampere';
AO.A2QF07.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QF07.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QF07.Setpoint.Mode          = 'Simulator';
AO.A2QF07.Setpoint.DataType      = 'Scalar';
AO.A2QF07.Setpoint.ChannelNames  = lnls1_getname(AO.A2QF07.FamilyName, 'Setpoint');
AO.A2QF07.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QF07.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QF07.Setpoint.Units         = 'Hardware';
AO.A2QF07.Setpoint.HWUnits       = 'Ampere';
AO.A2QF07.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QF07.Setpoint.Range         = [0 225];
AO.A2QF07.Setpoint.Tolerance     = 0.1;
AO.A2QF07.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QF09.FamilyName             = 'A2QF09';
AO.A2QF09.MemberOf               = {'A2QF09'; 'QUAD'; 'Magnet';};
AO.A2QF09.DeviceList             = [4 1; 5 1];
AO.A2QF09.ElementList            = (1:size(AO.A2QF09.DeviceList,1))';
AO.A2QF09.Status                 = ones(size(AO.A2QF09.DeviceList,1),1); 
AO.A2QF09.CommonNames            = ['AQF09A'; 'AQF09B'];
%AO.A2QF09.ExcitationCurves       = lnls1_getexcdata(AO.A2QF09.CommonNames, 1);
AO.A2QF09.ExcitationCurves       = lnls1_getexcdata(['A2QF09';'A2QF09'], 1);
AO.A2QF09.Monitor.MemberOf       = {};
AO.A2QF09.Monitor.Mode           = 'Simulator';
AO.A2QF09.Monitor.DataType       = 'Scalar';
AO.A2QF09.Monitor.ChannelNames   = lnls1_getname(AO.A2QF09.FamilyName, 'Monitor');
AO.A2QF09.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QF09.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QF09.Monitor.Units          = 'Hardware';
AO.A2QF09.Monitor.HWUnits        = 'Ampere';
AO.A2QF09.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QF09.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QF09.Setpoint.Mode          = 'Simulator';
AO.A2QF09.Setpoint.DataType      = 'Scalar';
AO.A2QF09.Setpoint.ChannelNames  = lnls1_getname(AO.A2QF09.FamilyName, 'Setpoint');
AO.A2QF09.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QF09.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QF09.Setpoint.Units         = 'Hardware';
AO.A2QF09.Setpoint.HWUnits       = 'Ampere';
AO.A2QF09.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QF09.Setpoint.Range         = [0 225];
AO.A2QF09.Setpoint.Tolerance     = 0.1;
AO.A2QF09.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QF11.FamilyName             = 'A2QF11';
AO.A2QF11.MemberOf               = {'A2QF11'; 'QUAD'; 'Magnet';};
AO.A2QF11.DeviceList             = [5 1; 6 1];
AO.A2QF11.ElementList            = (1:size(AO.A2QF11.DeviceList,1))';
AO.A2QF11.Status                 = ones(size(AO.A2QF11.DeviceList,1),1); 
AO.A2QF11.CommonNames            = ['AQF11A'; 'AQF11B'];
%AO.A2QF11.ExcitationCurves       = lnls1_getexcdata(AO.A2QF11.CommonNames, 1);
AO.A2QF11.ExcitationCurves       = lnls1_getexcdata(['A2QF11';'A2QF11'], 1);
AO.A2QF11.Monitor.MemberOf       = {};
AO.A2QF11.Monitor.Mode           = 'Simulator';
AO.A2QF11.Monitor.DataType       = 'Scalar';
AO.A2QF11.Monitor.ChannelNames   = lnls1_getname(AO.A2QF11.FamilyName, 'Monitor');
AO.A2QF11.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QF11.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QF11.Monitor.Units          = 'Hardware';
AO.A2QF11.Monitor.HWUnits        = 'Ampere';
AO.A2QF11.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QF11.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QF11.Setpoint.Mode          = 'Simulator';
AO.A2QF11.Setpoint.DataType      = 'Scalar';
AO.A2QF11.Setpoint.ChannelNames  = lnls1_getname(AO.A2QF11.FamilyName, 'Setpoint');
AO.A2QF11.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QF11.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QF11.Setpoint.Units         = 'Hardware';
AO.A2QF11.Setpoint.HWUnits       = 'Ampere';
AO.A2QF11.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QF11.Setpoint.Range         = [0 225];
AO.A2QF11.Setpoint.Tolerance     = 0.1;
AO.A2QF11.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QD01.FamilyName             = 'A2QD01';
AO.A2QD01.MemberOf               = {'A2QD01'; 'QUAD'; 'Magnet'; };
AO.A2QD01.DeviceList             = [1 1; 6 1];
AO.A2QD01.ElementList            = (1:size(AO.A2QD01.DeviceList,1))';
AO.A2QD01.Status                 = ones(size(AO.A2QD01.DeviceList,1),1); 
AO.A2QD01.CommonNames            = ['AQD01B'; 'AQD01A'];
%AO.A2QD01.ExcitationCurves       = lnls1_getexcdata(AO.A2QD01.CommonNames, 1);
AO.A2QD01.ExcitationCurves       = lnls1_getexcdata(['A2QD01';'A2QD01'], 1);
AO.A2QD01.Monitor.MemberOf       = {};
AO.A2QD01.Monitor.Mode           = 'Simulator';
AO.A2QD01.Monitor.DataType       = 'Scalar';
AO.A2QD01.Monitor.ChannelNames   = lnls1_getname(AO.A2QD01.FamilyName, 'Monitor');
AO.A2QD01.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QD01.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QD01.Monitor.Units          = 'Hardware';
AO.A2QD01.Monitor.HWUnits        = 'Ampere';
AO.A2QD01.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QD01.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QD01.Setpoint.Mode          = 'Simulator';
AO.A2QD01.Setpoint.DataType      = 'Scalar';
AO.A2QD01.Setpoint.ChannelNames  = lnls1_getname(AO.A2QD01.FamilyName, 'Setpoint');
AO.A2QD01.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QD01.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QD01.Setpoint.Units         = 'Hardware';
AO.A2QD01.Setpoint.HWUnits       = 'Ampere';
AO.A2QD01.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QD01.Setpoint.Range         = [0 225];
AO.A2QD01.Setpoint.Tolerance     = 0.2;
AO.A2QD01.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QD03.FamilyName             = 'A2QD03';
AO.A2QD03.MemberOf               = {'A2QD03'; 'QUAD'; 'Magnet'; };
AO.A2QD03.DeviceList             = [1 1; 2 1];
AO.A2QD03.ElementList            = (1:size(AO.A2QD03.DeviceList,1))';
AO.A2QD03.Status                 = ones(size(AO.A2QD03.DeviceList,1),1); 
AO.A2QD03.CommonNames            = ['AQD03A'; 'AQD03B'];
%AO.A2QD03.ExcitationCurves       = lnls1_getexcdata(AO.A2QD03.CommonNames, 1);
AO.A2QD03.ExcitationCurves       = lnls1_getexcdata(['A2QD03';'A2QD03'], 1);
AO.A2QD03.Monitor.MemberOf       = {};
AO.A2QD03.Monitor.Mode           = 'Simulator';
AO.A2QD03.Monitor.DataType       = 'Scalar';
AO.A2QD03.Monitor.ChannelNames   = lnls1_getname(AO.A2QD03.FamilyName, 'Monitor');
AO.A2QD03.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QD03.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QD03.Monitor.Units          = 'Hardware';
AO.A2QD03.Monitor.HWUnits        = 'Ampere';
AO.A2QD03.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QD03.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QD03.Setpoint.Mode          = 'Simulator';
AO.A2QD03.Setpoint.DataType      = 'Scalar';
AO.A2QD03.Setpoint.ChannelNames  = lnls1_getname(AO.A2QD03.FamilyName, 'Setpoint');
AO.A2QD03.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QD03.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QD03.Setpoint.Units         = 'Hardware';
AO.A2QD03.Setpoint.HWUnits       = 'Ampere';
AO.A2QD03.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QD03.Setpoint.Range         = [0 225];
AO.A2QD03.Setpoint.Tolerance     = 0.1;
AO.A2QD03.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QD05.FamilyName             = 'A2QD05';
AO.A2QD05.MemberOf               = {'A2QD05'; 'QUAD'; 'Magnet'; };
AO.A2QD05.DeviceList             = [2 1; 3 1];
AO.A2QD05.ElementList            = (1:size(AO.A2QD05.DeviceList,1))';
AO.A2QD05.Status                 = ones(size(AO.A2QD05.DeviceList,1),1); 
AO.A2QD05.CommonNames            = ['AQD05A'; 'AQD05B'];
%AO.A2QD05.ExcitationCurves       = lnls1_getexcdata(AO.A2QD05.CommonNames, 1);
AO.A2QD05.ExcitationCurves       = lnls1_getexcdata(['A2QD05';'A2QD05'], 1);
AO.A2QD05.Monitor.MemberOf       = {};
AO.A2QD05.Monitor.Mode           = 'Simulator';
AO.A2QD05.Monitor.DataType       = 'Scalar';
AO.A2QD05.Monitor.ChannelNames   = lnls1_getname(AO.A2QD05.FamilyName, 'Monitor');
AO.A2QD05.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QD05.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QD05.Monitor.Units          = 'Hardware';
AO.A2QD05.Monitor.HWUnits        = 'Ampere';
AO.A2QD05.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QD05.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QD05.Setpoint.Mode          = 'Simulator';
AO.A2QD05.Setpoint.DataType      = 'Scalar';
AO.A2QD05.Setpoint.ChannelNames  = lnls1_getname(AO.A2QD05.FamilyName, 'Setpoint');
AO.A2QD05.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QD05.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QD05.Setpoint.Units         = 'Hardware';
AO.A2QD05.Setpoint.HWUnits       = 'Ampere';
AO.A2QD05.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QD05.Setpoint.Range         = [0 225];
AO.A2QD05.Setpoint.Tolerance     = 0.1;
AO.A2QD05.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QD07.FamilyName             = 'A2QD07';
AO.A2QD07.MemberOf               = {'A2QD07'; 'QUAD'; 'Magnet'; };
AO.A2QD07.DeviceList             = [3 1; 4 1];
AO.A2QD07.ElementList            = (1:size(AO.A2QD07.DeviceList,1))';
AO.A2QD07.Status                 = ones(size(AO.A2QD07.DeviceList,1),1); 
AO.A2QD07.CommonNames            = ['AQD07A'; 'AQD07B'];
%AO.A2QD07.ExcitationCurves       = lnls1_getexcdata(AO.A2QD07.CommonNames, 1);
AO.A2QD07.ExcitationCurves       = lnls1_getexcdata(['A2QD07';'A2QD07'], 1);
AO.A2QD07.Monitor.MemberOf       = {};
AO.A2QD07.Monitor.Mode           = 'Simulator';
AO.A2QD07.Monitor.DataType       = 'Scalar';
AO.A2QD07.Monitor.ChannelNames   = lnls1_getname(AO.A2QD07.FamilyName, 'Monitor');
AO.A2QD07.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QD07.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QD07.Monitor.Units          = 'Hardware';
AO.A2QD07.Monitor.HWUnits        = 'Ampere';
AO.A2QD07.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QD07.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QD07.Setpoint.Mode          = 'Simulator';
AO.A2QD07.Setpoint.DataType      = 'Scalar';
AO.A2QD07.Setpoint.ChannelNames  = lnls1_getname(AO.A2QD07.FamilyName, 'Setpoint');
AO.A2QD07.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QD07.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QD07.Setpoint.Units         = 'Hardware';
AO.A2QD07.Setpoint.HWUnits       = 'Ampere';
AO.A2QD07.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QD07.Setpoint.Range         = [0 225];
AO.A2QD07.Setpoint.Tolerance     = 0.1;
AO.A2QD07.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QD09.FamilyName             = 'A2QD09';
AO.A2QD09.MemberOf               = {'A2QD09'; 'QUAD'; 'Magnet'; };
AO.A2QD09.DeviceList             = [4 1; 5 1];
AO.A2QD09.ElementList            = (1:size(AO.A2QD09.DeviceList,1))';
AO.A2QD09.Status                 = ones(size(AO.A2QD09.DeviceList,1),1); 
AO.A2QD09.CommonNames            = ['AQD09A'; 'AQD09B'];
%AO.A2QD09.ExcitationCurves       = lnls1_getexcdata(AO.A2QD09.CommonNames, 1);
AO.A2QD09.ExcitationCurves       = lnls1_getexcdata(['A2QD09';'A2QD09'], 1);
AO.A2QD09.Monitor.MemberOf       = {};
AO.A2QD09.Monitor.Mode           = 'Simulator';
AO.A2QD09.Monitor.DataType       = 'Scalar';
AO.A2QD09.Monitor.ChannelNames   = lnls1_getname(AO.A2QD09.FamilyName, 'Monitor');
AO.A2QD09.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QD09.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QD09.Monitor.Units          = 'Hardware';
AO.A2QD09.Monitor.HWUnits        = 'Ampere';
AO.A2QD09.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QD09.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QD09.Setpoint.Mode          = 'Simulator';
AO.A2QD09.Setpoint.DataType      = 'Scalar';
AO.A2QD09.Setpoint.ChannelNames  = lnls1_getname(AO.A2QD09.FamilyName, 'Setpoint');
AO.A2QD09.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QD09.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QD09.Setpoint.Units         = 'Hardware';
AO.A2QD09.Setpoint.HWUnits       = 'Ampere';
AO.A2QD09.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QD09.Setpoint.Range         = [0 225];
AO.A2QD09.Setpoint.Tolerance     = 0.1;
AO.A2QD09.Setpoint.DeltaRespMat  = 0.5; 

AO.A2QD11.FamilyName             = 'A2QD11';
AO.A2QD11.MemberOf               = {'A2QD11'; 'QUAD'; 'Magnet'; };
AO.A2QD11.DeviceList             = [5 1; 6 1];
AO.A2QD11.ElementList            = (1:size(AO.A2QD11.DeviceList,1))';
AO.A2QD11.Status                 = ones(size(AO.A2QD11.DeviceList,1),1); 
AO.A2QD11.CommonNames            = ['AQD11A'; 'AQD11B'];
%AO.A2QD11.ExcitationCurves       = lnls1_getexcdata(AO.A2QD11.CommonNames, 1);
AO.A2QD11.ExcitationCurves       = lnls1_getexcdata(['A2QD11';'A2QD11'], 1);
AO.A2QD11.Monitor.MemberOf       = {};
AO.A2QD11.Monitor.Mode           = 'Simulator';
AO.A2QD11.Monitor.DataType       = 'Scalar';
AO.A2QD11.Monitor.ChannelNames   = lnls1_getname(AO.A2QD11.FamilyName, 'Monitor');
AO.A2QD11.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A2QD11.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A2QD11.Monitor.Units          = 'Hardware';
AO.A2QD11.Monitor.HWUnits        = 'Ampere';
AO.A2QD11.Monitor.PhysicsUnits   = 'meter^-2';
AO.A2QD11.Setpoint.MemberOf      = {'Save/Restore' };
AO.A2QD11.Setpoint.Mode          = 'Simulator';
AO.A2QD11.Setpoint.DataType      = 'Scalar';
AO.A2QD11.Setpoint.ChannelNames  = lnls1_getname(AO.A2QD11.FamilyName, 'Setpoint');
AO.A2QD11.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QD11.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QD11.Setpoint.Units         = 'Hardware';
AO.A2QD11.Setpoint.HWUnits       = 'Ampere';
AO.A2QD11.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A2QD11.Setpoint.Range         = [0 225];
AO.A2QD11.Setpoint.Tolerance     = 0.1;
AO.A2QD11.Setpoint.DeltaRespMat  = 0.5; 

AO.A6QF01.FamilyName             = 'A6QF01';
AO.A6QF01.MemberOf               = {'PlotFamily'; 'A6QF01'; 'QUAD'; 'Magnet'};
AO.A6QF01.DeviceList             = build_devicelist(6,1);
AO.A6QF01.ElementList            = (1:size(AO.A6QF01.DeviceList,1))';
AO.A6QF01.Status                 = ones(size(AO.A6QF01.DeviceList,1),1); 
AO.A6QF01.CommonNames            = ['AQF02A'; 'AQF04B'; 'AQF06A'; 'AQF08B'; 'AQF10A'; 'AQF12B'];
%AO.A6QF01.ExcitationCurves       = lnls1_getexcdata(AO.A6QF01.CommonNames, 1);
AO.A6QF01.ExcitationCurves       = lnls1_getexcdata(['A6QF01';'A6QF01';'A6QF01';'A6QF01';'A6QF01';'A6QF01';], 1);
AO.A6QF01.Monitor.MemberOf       = {};
AO.A6QF01.Monitor.Mode           = 'Simulator';
AO.A6QF01.Monitor.DataType       = 'Scalar';
AO.A6QF01.Monitor.ChannelNames   = lnls1_getname(AO.A6QF01.FamilyName, 'Monitor');
AO.A6QF01.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A6QF01.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A6QF01.Monitor.Units          = 'Hardware';
AO.A6QF01.Monitor.HWUnits        = 'Ampere';
AO.A6QF01.Monitor.PhysicsUnits   = 'meter^-2';
AO.A6QF01.Setpoint.MemberOf      = {'Save/Restore' };
AO.A6QF01.Setpoint.Mode          = 'Simulator';
AO.A6QF01.Setpoint.DataType      = 'Scalar';
AO.A6QF01.Setpoint.ChannelNames  = lnls1_getname(AO.A6QF01.FamilyName, 'Setpoint');
AO.A6QF01.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A6QF01.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A6QF01.Setpoint.Units         = 'Hardware';
AO.A6QF01.Setpoint.HWUnits       = 'Ampere';
AO.A6QF01.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A6QF01.Setpoint.Range         = [0 155];
AO.A6QF01.Setpoint.Tolerance     = 0.1;
AO.A6QF01.Setpoint.DeltaRespMat  = 0.5; 

AO.A6QF02.FamilyName             = 'A6QF02';
AO.A6QF02.MemberOf               = {'PlotFamily'; 'A6QF02'; 'QUAD'; 'Magnet'};
AO.A6QF02.DeviceList             = build_devicelist(6,1);
AO.A6QF02.ElementList            = (1:size(AO.A6QF02.DeviceList,1))';
AO.A6QF02.Status                 = ones(size(AO.A6QF02.DeviceList,1),1); 
AO.A6QF02.CommonNames            = ['AQF02B'; 'AQF04A'; 'AQF06B'; 'AQF08A'; 'AQF10B'; 'AQF12A'];
%AO.A6QF02.ExcitationCurves       = lnls1_getexcdata(AO.A6QF02.CommonNames, 1);
AO.A6QF02.ExcitationCurves       = lnls1_getexcdata(['A6QF02';'A6QF02';'A6QF02';'A6QF02';'A6QF02';'A6QF02';], 1);
AO.A6QF02.Monitor.MemberOf       = {};
AO.A6QF02.Monitor.Mode           = 'Simulator';
AO.A6QF02.Monitor.DataType       = 'Scalar';
AO.A6QF02.Monitor.ChannelNames   = lnls1_getname(AO.A6QF02.FamilyName, 'Monitor');
AO.A6QF02.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A6QF02.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A6QF02.Monitor.Units          = 'Hardware';
AO.A6QF02.Monitor.HWUnits        = 'Ampere';
AO.A6QF02.Monitor.PhysicsUnits   = 'meter^-2';
AO.A6QF02.Setpoint.MemberOf      = {'Save/Restore' };
AO.A6QF02.Setpoint.Mode          = 'Simulator';
AO.A6QF02.Setpoint.DataType      = 'Scalar';
AO.A6QF02.Setpoint.ChannelNames  = lnls1_getname(AO.A6QF02.FamilyName, 'Setpoint');
AO.A6QF02.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A6QF02.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A6QF02.Setpoint.Units         = 'Hardware';
AO.A6QF02.Setpoint.HWUnits       = 'Ampere';
AO.A6QF02.Setpoint.PhysicsUnits  = 'meter^-2';
AO.A6QF02.Setpoint.Range         = [0 155];
AO.A6QF02.Setpoint.Tolerance     = 0.1;
AO.A6QF02.Setpoint.DeltaRespMat  = 0.5; 

AO.A6SF.FamilyName             = 'A6SF';
AO.A6SF.MemberOf               = {'A6SF'; 'SEXT'; 'Magnet';};
AO.A6SF.DeviceList             = build_devicelist(6,1);
AO.A6SF.ElementList            = (1:size(AO.A6SF.DeviceList,1))';
AO.A6SF.Status                 = ones(size(AO.A6SF.DeviceList,1),1);
AO.A6SF.CommonNames            = ['ASF02'; 'ASF04'; 'ASF06'; 'ASF08'; 'ASF10'; 'ASF12']; 
AO.A6SF.ExcitationCurves       = lnls1_getexcdata(['A6SF';'A6SF';'A6SF';'A6SF';'A6SF';'A6SF';], 1);
AO.A6SF.Monitor.MemberOf       = {};
AO.A6SF.Monitor.Mode           = 'Simulator';
AO.A6SF.Monitor.DataType       = 'Scalar';
AO.A6SF.Monitor.ChannelNames   = lnls1_getname(AO.A6SF.FamilyName, 'Monitor', AO.A6SF.DeviceList);
AO.A6SF.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A6SF.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A6SF.Monitor.Units          = 'Hardware';
AO.A6SF.Monitor.HWUnits        = 'Ampere';
AO.A6SF.Monitor.PhysicsUnits   = 'meter^-3';
AO.A6SF.Setpoint.MemberOf      = {'Save/Restore' ;};
AO.A6SF.Setpoint.Mode          = 'Simulator';
AO.A6SF.Setpoint.DataType      = 'Scalar';
AO.A6SF.Setpoint.ChannelNames  = lnls1_getname(AO.A6SF.FamilyName, 'Setpoint', AO.A6SF.DeviceList);
AO.A6SF.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A6SF.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A6SF.Setpoint.Units         = 'Hardware';
AO.A6SF.Setpoint.HWUnits       = 'Ampere';
AO.A6SF.Setpoint.PhysicsUnits  = 'meter^-3';
AO.A6SF.Setpoint.Range         = [0 220];
AO.A6SF.Setpoint.Tolerance     = 1.0; % 2015-10-16  currently there is a big diff between setpoint and readback
AO.A6SF.Setpoint.DeltaRespMat  = .1;

AO.A6SD01.FamilyName             = 'A6SD01';
AO.A6SD01.MemberOf               = {'A6SD01'; 'SEXT'; 'Magnet';};
AO.A6SD01.DeviceList             = build_devicelist(6,1);
AO.A6SD01.ElementList            = (1:size(AO.A6SD01.DeviceList,1))';
AO.A6SD01.Status                 = ones(size(AO.A6SD01.DeviceList,1),1);
AO.A6SD01.CommonNames            = ['ASD02A'; 'ASD04B'; 'ASD06A'; 'ASD08B'; 'ASD10A'; 'ASD12B']; 
%AO.A6SD01.ExcitationCurves       = lnls1_getexcdata(AO.A6SD01.CommonNames, 1);
AO.A6SD01.ExcitationCurves       = lnls1_getexcdata(['A6SD01';'A6SD01';'A6SD01';'A6SD01';'A6SD01';'A6SD01';], 1);
AO.A6SD01.Monitor.MemberOf       = {};
AO.A6SD01.Monitor.Mode           = 'Simulator';
AO.A6SD01.Monitor.DataType       = 'Scalar';
AO.A6SD01.Monitor.ChannelNames   = lnls1_getname(AO.A6SD01.FamilyName, 'Monitor', AO.A6SD01.DeviceList);
AO.A6SD01.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A6SD01.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A6SD01.Monitor.Units          = 'Hardware';
AO.A6SD01.Monitor.HWUnits        = 'Ampere';
AO.A6SD01.Monitor.PhysicsUnits   = 'meter^-3';
AO.A6SD01.Setpoint.MemberOf      = {'Save/Restore' ;};
AO.A6SD01.Setpoint.Mode          = 'Simulator';
AO.A6SD01.Setpoint.DataType      = 'Scalar';
AO.A6SD01.Setpoint.ChannelNames  = lnls1_getname(AO.A6SD01.FamilyName, 'Setpoint', AO.A6SD01.DeviceList);
AO.A6SD01.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A6SD01.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A6SD01.Setpoint.Units         = 'Hardware';
AO.A6SD01.Setpoint.HWUnits       = 'Ampere';
AO.A6SD01.Setpoint.PhysicsUnits  = 'meter^-3';
AO.A6SD01.Setpoint.Range         = [0 125];
AO.A6SD01.Setpoint.Tolerance     = .1;
AO.A6SD01.Setpoint.DeltaRespMat  = .1;

AO.A6SD02.FamilyName             = 'A6SD02';
AO.A6SD02.MemberOf               = {'A6SD02'; 'SEXT'; 'Magnet';};
AO.A6SD02.DeviceList             = build_devicelist(6,1);
AO.A6SD02.ElementList            = (1:size(AO.A6SD02.DeviceList,1))';
AO.A6SD02.Status                 = ones(size(AO.A6SD02.DeviceList,1),1);
AO.A6SD02.CommonNames            = ['ASD02B'; 'ASD04A'; 'ASD06B'; 'ASD08A'; 'ASD10B'; 'ASD12A']; 
%AO.A6SD02.ExcitationCurves       = lnls1_getexcdata(AO.A6SD02.CommonNames, 1);
AO.A6SD02.ExcitationCurves       = lnls1_getexcdata(['A6SD02';'A6SD02';'A6SD02';'A6SD02';'A6SD02';'A6SD02';], 1);
AO.A6SD02.Monitor.MemberOf       = {};
AO.A6SD02.Monitor.Mode           = 'Simulator';
AO.A6SD02.Monitor.DataType       = 'Scalar';
AO.A6SD02.Monitor.ChannelNames   = lnls1_getname(AO.A6SD02.FamilyName, 'Monitor', AO.A6SD02.DeviceList);
AO.A6SD02.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.A6SD02.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.A6SD02.Monitor.Units          = 'Hardware';
AO.A6SD02.Monitor.HWUnits        = 'Ampere';
AO.A6SD02.Monitor.PhysicsUnits   = 'meter^-3';
AO.A6SD02.Setpoint.MemberOf      = {'Save/Restore' ;};
AO.A6SD02.Setpoint.Mode          = 'Simulator';
AO.A6SD02.Setpoint.DataType      = 'Scalar';
AO.A6SD02.Setpoint.ChannelNames  = lnls1_getname(AO.A6SD02.FamilyName, 'Setpoint', AO.A6SD02.DeviceList);
AO.A6SD02.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A6SD02.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A6SD02.Setpoint.Units         = 'Hardware';
AO.A6SD02.Setpoint.HWUnits       = 'Ampere';
AO.A6SD02.Setpoint.PhysicsUnits  = 'meter^-3';
AO.A6SD02.Setpoint.Range         = [0 125];
AO.A6SD02.Setpoint.Tolerance     = .1;
AO.A6SD02.Setpoint.DeltaRespMat  = .1;

AO.A2QS05.FamilyName  = 'A2QS05';
AO.A2QS05.MemberOf    = {'PlotFamily'; 'A2QS05'; 'Magnet'; 'Coupling Corrector'};
AO.A2QS05.DeviceList  = [2 1; 3 1;];
AO.A2QS05.CommonNames = ['AQS05A';'AQS05B'];
AO.A2QS05.ElementList = (1:size(AO.A2QS05.DeviceList,1))';
AO.A2QS05.Status      = [1 1]';
AO.A2QS05.Position    = [];
AO.A2QS05.ExcitationCurves = lnls1_getexcdata(['A2QS05';'A2QS05'], 1);
AO.A2QS05.Monitor.MemberOf = {};
AO.A2QS05.Monitor.Mode = 'Simulator';
AO.A2QS05.Monitor.DataType = 'Scalar';
AO.A2QS05.Monitor.ChannelNames = lnls1_getname(AO.A2QS05.FamilyName, 'Monitor', AO.A2QS05.DeviceList);
AO.A2QS05.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QS05.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QS05.Monitor.Units        = 'Hardware';
AO.A2QS05.Monitor.HWUnits      = 'Ampere';
AO.A2QS05.Monitor.PhysicsUnits = 'meter^-2';
AO.A2QS05.Setpoint.MemberOf = {'Save/Restore' ;};
AO.A2QS05.Setpoint.Mode = 'Simulator';
AO.A2QS05.Setpoint.DataType = 'Scalar';
AO.A2QS05.Setpoint.ChannelNames = lnls1_getname(AO.A2QS05.FamilyName, 'Setpoint', AO.A2QS05.DeviceList);
AO.A2QS05.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.A2QS05.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.A2QS05.Setpoint.Units        = 'Hardware';
AO.A2QS05.Setpoint.HWUnits      = 'Ampere';
AO.A2QS05.Setpoint.PhysicsUnits = 'meter^-2';
AO.A2QS05.Setpoint.Range        = [-10 10];
AO.A2QS05.Setpoint.Tolerance    = .1;
AO.A2QS05.Setpoint.DeltaRespMat = .05;

AO.SKEWCORR.FamilyName  = 'SKEWCORR';
AO.SKEWCORR.MemberOf    = {'PlotFamily'; 'SKEWCORR'; 'Magnet'; 'Coupling Corrector'};
AO.SKEWCORR.DeviceList  = [ 3 1; 6 1; 6 2;];
AO.SKEWCORR.CommonNames = [ 'AQS09'; 'AQS11'; 'AQS01';];
AO.SKEWCORR.ElementList = (1:size(AO.SKEWCORR.DeviceList,1))';
AO.SKEWCORR.Status      = [1 1 1]';
AO.SKEWCORR.Position    = [];
AO.SKEWCORR.ExcitationCurves = lnls1_getexcdata(['SKEWCORR'; 'SKEWCORR'; 'SKEWCORR'], 1);
AO.SKEWCORR.Monitor.MemberOf = {};
AO.SKEWCORR.Monitor.Mode = 'Simulator';
AO.SKEWCORR.Monitor.DataType = 'Scalar';
AO.SKEWCORR.Monitor.ChannelNames = lnls1_getname(AO.SKEWCORR.FamilyName, 'Monitor', AO.SKEWCORR.DeviceList);
AO.SKEWCORR.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.SKEWCORR.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.SKEWCORR.Monitor.Units        = 'Hardware';
AO.SKEWCORR.Monitor.HWUnits      = 'Ampere';
AO.SKEWCORR.Monitor.PhysicsUnits = 'meter^-2';
AO.SKEWCORR.Setpoint.MemberOf = {'Save/Restore' ;};
AO.SKEWCORR.Setpoint.Mode = 'Simulator';
AO.SKEWCORR.Setpoint.DataType = 'Scalar';
AO.SKEWCORR.Setpoint.ChannelNames = lnls1_getname(AO.SKEWCORR.FamilyName, 'Setpoint', AO.SKEWCORR.DeviceList);
AO.SKEWCORR.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.SKEWCORR.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.SKEWCORR.Setpoint.Units        = 'Hardware';
AO.SKEWCORR.Setpoint.HWUnits      = 'Ampere';
AO.SKEWCORR.Setpoint.PhysicsUnits = 'meter^-2';
AO.SKEWCORR.Setpoint.Range        = [-5 5];
AO.SKEWCORR.Setpoint.Tolerance    = .1;
AO.SKEWCORR.Setpoint.DeltaRespMat = .05;



AO.QUADSHUNT.FamilyName  = 'QUADSHUNT';
AO.QUADSHUNT.MemberOf    = {'Shunt'};
AO.QUADSHUNT.DeviceList  = build_devicelist(6,6);
AO.QUADSHUNT.ElementList = (1:size(AO.QUADSHUNT.DeviceList,1))';
AO.QUADSHUNT.Status      = ones(size(AO.QUADSHUNT.DeviceList,1),1);
AO.QUADSHUNT.CommonNames = [ ...
    'AQF01B'; 'AQD01B'; 'AQF02A'; 'AQF02B'; 'AQD03A'; 'AQF03A'; ...
    'AQF03B'; 'AQD03B'; 'AQF04A'; 'AQF04B'; 'AQD05A'; 'AQF05A'; ...
    'AQF05B'; 'AQD05B'; 'AQF06A'; 'AQF06B'; 'AQD07A'; 'AQF07A'; ...
    'AQF07B'; 'AQD07B'; 'AQF08A'; 'AQF08B'; 'AQD09A'; 'AQF09A'; ...
    'AQF09B'; 'AQD09B'; 'AQF10A'; 'AQF10B'; 'AQD11A'; 'AQF11A'; ...
    'AQF11B'; 'AQD11B'; 'AQF12A'; 'AQF12B'; 'AQD01A'; 'AQF01A'; ...
];
AO.QUADSHUNT.Position    = [];
AO.QUADSHUNT.OnOffSP.MemberOf = {'Save'};
AO.QUADSHUNT.OnOffSP.Mode = 'Simulator';
AO.QUADSHUNT.OnOffSP.DataType = 'Scalar';
AO.QUADSHUNT.OnOffSP.ChannelNames = lnls1_getname(AO.QUADSHUNT.FamilyName, 'ON');
AO.QUADSHUNT.OnOffSP.Units = 'Hardware';
AO.QUADSHUNT.OnOffSP.HWUnits = 'on/off';
AO.QUADSHUNT.Monitor.MemberOf = {};
AO.QUADSHUNT.Monitor.Mode = 'Simulator';
AO.QUADSHUNT.Monitor.DataType = 'Scalar';
AO.QUADSHUNT.Monitor.ChannelNames  = lnls1_getname('QUADSHUNT', 'Monitor', AO.QUADSHUNT.DeviceList);
AO.QUADSHUNT.Monitor.Units         = 'Hardware';
AO.QUADSHUNT.Monitor.HWUnits       = 'Ampere';
AO.QUADSHUNT.Setpoint.MemberOf     = {'Save'};
AO.QUADSHUNT.Setpoint.Mode         = 'Simulator';
AO.QUADSHUNT.Setpoint.DataType     = 'Scalar';
AO.QUADSHUNT.Setpoint.ChannelNames = lnls1_getname('QUADSHUNT', 'Setpoint', AO.QUADSHUNT.DeviceList);
AO.QUADSHUNT.Setpoint.Units        = 'Hardware';
AO.QUADSHUNT.Setpoint.HWUnits      = 'Ampere';
AO.QUADSHUNT.Setpoint.PhysicsUnits = 'meter^-2';
AO.QUADSHUNT.Setpoint.Range        = [-5 5];
AO.QUADSHUNT.Setpoint.Tolerance    = .1;


%%%%%%%
% IDs %
%%%%%%%

AO.AWG01.FamilyName = 'AWG01';
AO.AWG01.MemberOf = {};
AO.AWG01.DeviceList  = [1 1;];
AO.AWG01.Status = ones(size(AO.AWG01.DeviceList,1),1);
AO.AWG01.CommonNames = ['AWG01';];
AO.AWG01.Position = [];
AO.AWG01.Monitor.MemberOf = {};
AO.AWG01.Monitor.Mode = 'Simulator';
AO.AWG01.Monitor.DataType = 'Scalar';
AO.AWG01.Monitor.ChannelNames  = lnls1_getname('AWG01', 'Monitor', AO.AWG01.DeviceList);
AO.AWG01.Monitor.Units = 'Hardware';
AO.AWG01.Monitor.HWUnits      = 'mm';
AO.AWG01.Monitor.PhysicsUnits = 'mm';
%AO.AWG01.Monitor.SpecialFunctionGet = @lnls1_getepu;
AO.AWG01.Setpoint.MemberOf = {'Save/Restore'};
AO.AWG01.Setpoint.Mode = 'Simulator';
AO.AWG01.Setpoint.DataType = 'Scalar';
AO.AWG01.Setpoint.ChannelNames  = lnls1_getname('AWG01', 'Setpoint', AO.AWG01.DeviceList);
AO.AWG01.Setpoint.Units = 'Hardware';
AO.AWG01.Setpoint.HWUnits      = 'mm';
AO.AWG01.Setpoint.PhysicsUnits = 'T';
AO.AWG01.Setpoint.Range        = [22 180];
AO.AWG01.Setpoint.Tolerance    = .1;

AO.AWG09.FamilyName = 'AWG09';
AO.AWG09.MemberOf = {};
AO.AWG09.DeviceList  = [4 1;];
AO.AWG09.Status = ones(size(AO.AWG09.DeviceList,1),1);
AO.AWG09.CommonNames = ['AWG09';];
AO.AWG09.Position = [];
AO.AWG09.Monitor.MemberOf = {};
AO.AWG09.Monitor.Mode = 'Simulator';
AO.AWG09.Monitor.DataType = 'Scalar';
AO.AWG09.Monitor.ChannelNames  = lnls1_getname('AWG09', 'Monitor', AO.AWG09.DeviceList);
AO.AWG09.Monitor.Units = 'Hardware';
AO.AWG09.Monitor.HWUnits      = 'T';
AO.AWG09.Monitor.PhysicsUnits = 'T';
AO.AWG09.Setpoint.MemberOf = {'Save/Restore'};
AO.AWG09.Setpoint.Mode = 'Simulator';
AO.AWG09.Setpoint.DataType = 'Scalar';
AO.AWG09.Setpoint.ChannelNames  = lnls1_getname('AWG09', 'Setpoint', AO.AWG09.DeviceList);
AO.AWG09.Setpoint.Units = 'Hardware';
AO.AWG09.Setpoint.HWUnits      = 'mm';
AO.AWG09.Setpoint.PhysicsUnits = 'mm';
AO.AWG09.Setpoint.Range        = [0 4.1];
AO.AWG09.Setpoint.Tolerance    = .1;



AO.AON11.FamilyName = 'AON11';
AO.AON11.MemberOf = {};
AO.AON11.DeviceList  = [5 1;];
AO.AON11.Status = ones(size(AO.AON11.DeviceList,1),1);
AO.AON11.CommonNames = ['AON11';];
AO.AON11.Position = [];
AO.AON11.Monitor.MemberOf = {};
AO.AON11.Monitor.Mode = 'Simulator';
AO.AON11.Monitor.DataType = 'Scalar';
AO.AON11.Monitor.ChannelNames  = lnls1_getname('AON11', 'Monitor', AO.AON11.DeviceList);
AO.AON11.Monitor.Units = 'Hardware';
AO.AON11.Monitor.HWUnits      = 'mm';
AO.AON11.Monitor.PhysicsUnits = 'T';
%AO.AON11.Monitor.SpecialFunctionGet = @lnls1_getepu;
AO.AON11.Setpoint.MemberOf = {'Save/Restore'};
AO.AON11.Setpoint.Mode = 'Simulator';
AO.AON11.Setpoint.DataType = 'Scalar';
AO.AON11.Setpoint.ChannelNames  = lnls1_getname('AON11', 'Setpoint', AO.AON11.DeviceList);
AO.AON11.Setpoint.Units = 'Hardware';
AO.AON11.Setpoint.HWUnits      = 'mm';
AO.AON11.Setpoint.PhysicsUnits = 'mm';
%AO.AON11.Setpoint.SpecialFunctionGet = @lnls1_getepu;
%AO.AON11.Setpoint.SpecialFunctionSet = @lnls1_setepu;
AO.AON11.Setpoint.Range        = [22 300];
AO.AON11.Setpoint.Tolerance    = .1;


AO.AON11.GapSpeedAM.MemberOf = {};
AO.AON11.GapSpeedAM.Mode = 'Simulator';
AO.AON11.GapSpeedAM.DataType = 'Scalar';
AO.AON11.GapSpeedAM.ChannelNames  = lnls1_getname('AON11', 'GapSpeedAM', AO.AON11.DeviceList);
AO.AON11.GapSpeedAM.Units = 'Hardware';
AO.AON11.GapSpeedAM.HWUnits = 'mm/min';
AO.AON11.GapSpeedSP.MemberOf = {'Save/Restore'};
AO.AON11.GapSpeedSP.Mode = 'Simulator';
AO.AON11.GapSpeedSP.DataType = 'Scalar';
AO.AON11.GapSpeedSP.ChannelNames  = lnls1_getname('AON11', 'GapSpeedSP', AO.AON11.DeviceList);
AO.AON11.GapSpeedSP.Units = 'Hardware';
AO.AON11.GapSpeedSP.HWUnits = 'mm/min';

AO.AON11.PhaseSpeedAM.MemberOf = {};
AO.AON11.PhaseSpeedAM.Mode = 'Simulator';
AO.AON11.PhaseSpeedAM.DataType = 'Scalar';
AO.AON11.PhaseSpeedAM.ChannelNames  = lnls1_getname('AON11', 'PhaseSpeedAM', AO.AON11.DeviceList);
AO.AON11.PhaseSpeedAM.Units = 'Hardware';
AO.AON11.PhaseSpeedAM.HWUnits = 'mm/min';
AO.AON11.PhaseSpeedSP.MemberOf = {'Save/Restore'};
AO.AON11.PhaseSpeedSP.Mode = 'Simulator';
AO.AON11.PhaseSpeedSP.DataType = 'Scalar';
AO.AON11.PhaseSpeedSP.ChannelNames  = lnls1_getname('AON11', 'PhaseSpeedSP', AO.AON11.DeviceList);
AO.AON11.PhaseSpeedSP.Units = 'Hardware';
AO.AON11.PhaseSpeedSP.HWUnits = 'mm/min';

AO.AON11.PhaseAM.MemberOf = {};
AO.AON11.PhaseAM.Mode = 'Simulator';
AO.AON11.PhaseAM.DataType = 'Scalar';
AO.AON11.PhaseAM.ChannelNames  = lnls1_getname('AON11', 'PhaseAM', AO.AON11.DeviceList);
AO.AON11.PhaseAM.Units = 'Hardware';
AO.AON11.PhaseAM.HWUnits      = 'mm';
AO.AON11.PhaseSP.MemberOf = {'Save/Restore'};
AO.AON11.PhaseSP.Mode = 'Simulator';
AO.AON11.PhaseSP.DataType = 'Scalar';
AO.AON11.PhaseSP.ChannelNames  = lnls1_getname('AON11', 'PhaseSP', AO.AON11.DeviceList);
AO.AON11.PhaseSP.Units = 'Hardware';
AO.AON11.PhaseSP.HWUnits      = 'mm';


%%%%%%%%
% FOFB %
%%%%%%%%

AO.FOFB.FamilyName = 'FOFB';
AO.FOFB.MemberOf   = {};
AO.FOFB.DeviceList = [1 1];
AO.FOFB.Status = ones(size(AO.FOFB.DeviceList,1),1);
AO.FOFB.CommonNames = ['FOFB';];
AO.FOFB.Setpoint.MemberOf = {'Save/Restore'};
AO.FOFB.Setpoint.Mode = 'Simulator';
AO.FOFB.Setpoint.DataType = 'Scalar';
AO.FOFB.Setpoint.ChannelNames  = lnls1_getname('FOFB', 'Setpoint', AO.FOFB.DeviceList);
AO.FOFB.Setpoint.Units = 'Hardware';
AO.FOFB.Setpoint.HWUnits = '';
AO.FOFB.Monitor.MemberOf = {};
AO.FOFB.Monitor.Mode = 'Simulator';
AO.FOFB.Monitor.DataType = 'Scalar';
AO.FOFB.Monitor.ChannelNames  = lnls1_getname('FOFB', 'Monitor', AO.FOFB.DeviceList);
AO.FOFB.Monitor.Units = 'Hardware';
AO.FOFB.Monitor.HWUnits = '';

AO.FOFB.ExcitationFlag.MemberOf = {'Save/Restore'};
AO.FOFB.ExcitationFlag.Mode = 'Simulator';
AO.FOFB.ExcitationFlag.DataType = 'Scalar';
AO.FOFB.ExcitationFlag.ChannelNames  = lnls1_getname('FOFB', 'ExcitationFlag', AO.FOFB.DeviceList);
AO.FOFB.ExcitationFlag.Units = 'Hardware';
AO.FOFB.ExcitationFlag.HWUnits = '';

AO.FOFB.CorrectionMatrixSP.MemberOf = {'Save/Restore'};
AO.FOFB.CorrectionMatrixSP.Mode = 'Simulator';
AO.FOFB.CorrectionMatrixSP.DataType = 'Scalar';
AO.FOFB.CorrectionMatrixSP.ChannelNames  = lnls1_getname('FOFB', 'CorrectionMatrixSP', AO.FOFB.DeviceList);
AO.FOFB.CorrectionMatrixSP.Units = 'Hardware';
AO.FOFB.CorrectionMatrixSP.HWUnits = '';
AO.FOFB.CorrectionMatrixAM.MemberOf = {};
AO.FOFB.CorrectionMatrixAM.Mode = 'Simulator';
AO.FOFB.CorrectionMatrixAM.DataType = 'Scalar';
AO.FOFB.CorrectionMatrixAM.ChannelNames  = lnls1_getname('FOFB', 'CorrectionMatrixAM', AO.FOFB.DeviceList);
AO.FOFB.CorrectionMatrixAM.Units = 'Hardware';
AO.FOFB.CorrectionMatrixAM.HWUnits = '';

AO.FOFB.ReferenceOrbitSP.MemberOf = {'Save/Restore'};
AO.FOFB.ReferenceOrbitSP.Mode = 'Simulator';
AO.FOFB.ReferenceOrbitSP.DataType = 'Scalar';
AO.FOFB.ReferenceOrbitSP.ChannelNames  = lnls1_getname('FOFB', 'ReferenceOrbitSP', AO.FOFB.DeviceList);
AO.FOFB.ReferenceOrbitSP.Units = 'Hardware';
AO.FOFB.ReferenceOrbitSP.HWUnits = '';
AO.FOFB.ReferenceOrbitAM.MemberOf = {};
AO.FOFB.ReferenceOrbitAM.Mode = 'Simulator';
AO.FOFB.ReferenceOrbitAM.DataType = 'Scalar';
AO.FOFB.ReferenceOrbitAM.ChannelNames  = lnls1_getname('FOFB', 'ReferenceOrbitAM', AO.FOFB.DeviceList);
AO.FOFB.ReferenceOrbitAM.Units = 'Hardware';
AO.FOFB.ReferenceOrbitAM.HWUnits = '';

AO.FOFB.HorizontalOrbiThresholdSP.MemberOf = {'Save/Restore'};
AO.FOFB.HorizontalOrbiThresholdSP.Mode = 'Simulator';
AO.FOFB.HorizontalOrbiThresholdSP.DataType = 'Scalar';
AO.FOFB.HorizontalOrbiThresholdSP.ChannelNames  = lnls1_getname('FOFB', 'HorizontalOrbiThresholdSP', AO.FOFB.DeviceList);
AO.FOFB.HorizontalOrbiThresholdSP.Units = 'Hardware';
AO.FOFB.HorizontalOrbiThresholdSP.HWUnits = '';
AO.FOFB.HorizontalOrbiThresholdAM.MemberOf = {};
AO.FOFB.HorizontalOrbiThresholdAM.Mode = 'Simulator';
AO.FOFB.HorizontalOrbiThresholdAM.DataType = 'Scalar';
AO.FOFB.HorizontalOrbiThresholdAM.ChannelNames  = lnls1_getname('FOFB', 'HorizontalOrbiThresholdAM', AO.FOFB.DeviceList);
AO.FOFB.HorizontalOrbiThresholdAM.Units = 'Hardware';
AO.FOFB.HorizontalOrbiThresholdAM.HWUnits = '';

AO.FOFB.VerticalOrbiThresholdSP.MemberOf = {'Save/Restore'};
AO.FOFB.VerticalOrbiThresholdSP.Mode = 'Simulator';
AO.FOFB.VerticalOrbiThresholdSP.DataType = 'Scalar';
AO.FOFB.VerticalOrbiThresholdSP.ChannelNames  = lnls1_getname('FOFB', 'VerticalOrbiThresholdSP', AO.FOFB.DeviceList);
AO.FOFB.VerticalOrbiThresholdSP.Units = 'Hardware';
AO.FOFB.VerticalOrbiThresholdSP.HWUnits = '';
AO.FOFB.VerticalOrbiThresholdAM.MemberOf = {};
AO.FOFB.VerticalOrbiThresholdAM.Mode = 'Simulator';
AO.FOFB.VerticalOrbiThresholdAM.DataType = 'Scalar';
AO.FOFB.VerticalOrbiThresholdAM.ChannelNames  = lnls1_getname('FOFB', 'VerticalOrbiThresholdAM', AO.FOFB.DeviceList);
AO.FOFB.VerticalOrbiThresholdAM.Units = 'Hardware';
AO.FOFB.VerticalOrbiThresholdAM.HWUnits = '';

AO.FOFB.HorizontalGainSP.MemberOf = {'Save/Restore'};
AO.FOFB.HorizontalGainSP.Mode = 'Simulator';
AO.FOFB.HorizontalGainSP.DataType = 'Scalar';
AO.FOFB.HorizontalGainSP.ChannelNames  = lnls1_getname('FOFB', 'HorizontalGainSP', AO.FOFB.DeviceList);
AO.FOFB.HorizontalGainSP.Units = 'Hardware';
AO.FOFB.HorizontalGainSP.HWUnits = '';
AO.FOFB.HorizontalGainAM.MemberOf = {};
AO.FOFB.HorizontalGainAM.Mode = 'Simulator';
AO.FOFB.HorizontalGainAM.DataType = 'Scalar';
AO.FOFB.HorizontalGainAM.ChannelNames  = lnls1_getname('FOFB', 'HorizontalGainAM', AO.FOFB.DeviceList);
AO.FOFB.HorizontalGainAM.Units = 'Hardware';
AO.FOFB.HorizontalGainAM.HWUnits = '';

AO.FOFB.VerticalGainSP.MemberOf = {'Save/Restore'};
AO.FOFB.VerticalGainSP.Mode = 'Simulator';
AO.FOFB.VerticalGainSP.DataType = 'Scalar';
AO.FOFB.VerticalGainSP.ChannelNames  = lnls1_getname('FOFB', 'VerticalGainSP', AO.FOFB.DeviceList);
AO.FOFB.VerticalGainSP.Units = 'Hardware';
AO.FOFB.VerticalGainSP.HWUnits = '';
AO.FOFB.VerticalGainAM.MemberOf = {};
AO.FOFB.VerticalGainAM.Mode = 'Simulator';
AO.FOFB.VerticalGainAM.DataType = 'Scalar';
AO.FOFB.VerticalGainAM.ChannelNames  = lnls1_getname('FOFB', 'HorizontalGainAM', AO.FOFB.DeviceList);
AO.FOFB.VerticalGainAM.Units = 'Hardware';
AO.FOFB.VerticalGainAM.HWUnits = '';

%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = build_devicelist(6,3);
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];
AO.HCM.CommonNames = [
            'ACH01B'; ...
            'ACH02 ';  'ACH03A'; 'ACH03B'; 'ACH04 ';  'ACH05A'; 'ACH05B'; ...
            'ACH06 ';  'ACH07A'; 'ACH07B'; 'ACH08 ';  'ACH09A'; 'ACH09B'; ...
            'ACH10 ';  'ACH11A'; 'ACH11B'; 'ACH12 '; ...
            'ACH01A'];
AO.HCM.ExcitationCurves = lnls1_getexcdata(AO.HCM.CommonNames, 1);



AO.HCM.Monitor.MemberOf = {'Horizontal'; 'COR'; 'HCM'; 'Magnet';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = lnls1_getname(AO.HCM.FamilyName, 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.HCM.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'Save/Restore' ; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = lnls1_getname(AO.HCM.FamilyName, 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.HCM.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-10 10];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 0.651; % @1.37Gev: 0.651 Amp -> 0.1 mrad -> DeltaXMax ~ 1mm
 
% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = build_devicelist(6,4);
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
AO.VCM.CommonNames = [
            'ACV01B'; ...
            'ALV02A'; 'ALV02B'; 'ACV03A'; 'ACV03B'; ...
            'ALV04A'; 'ALV04B'; 'ACV05A'; 'ACV05B'; ...
            'ALV06A'; 'ALV06B'; 'ACV07A'; 'ACV07B'; ...
            'ALV08A'; 'ALV08B'; 'ACV09A'; 'ACV09B'; ...
            'ALV10A'; 'ALV10B'; 'ACV11A'; 'ACV11B'; ...
            'ALV12A'; 'ALV12B'; ...
            'ACV01A'];
AO.VCM.ExcitationCurves = lnls1_getexcdata(AO.VCM.CommonNames, 1);


AO.VCM.Monitor.MemberOf = {'Vertical'; 'COR'; 'ACV'; 'VCM'; 'Magnet';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = lnls1_getname(AO.VCM.FamilyName, 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.VCM.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'Save/Restore' ; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = lnls1_getname(AO.VCM.FamilyName, 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.VCM.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-10 10];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = [0.654 2.0 2.0 0.654 0.654 2.0 2.0 0.654 0.654 2.0 2.0 0.654 0.654 2.0 2.0 0.654 0.654 2.0 2.0 0.654 0.654 2.0 2.0 0.654]';  % 0.654 Amp -> 0.1 mrad @ 1.37GeV



Orbit = lnls1_goldenorbit;


% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 2 3; 2 4; 2 5; 3 1; 3 2; 3 3; 3 4; 4 1; 4 2; 4 3; 4 4; 5 1; 5 2; 5 3; 5 4; 6 1; 6 2; 6 3; 6 4];
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
%AO.BPMx.Status([20 23])  = [0 0]; % AMP11A and AMP11B OFF
AO.BPMx.Offset      = Orbit.OffsetOrbit(:,1);
AO.BPMx.Golden      = Orbit.GoldenOrbit(:,1);
%AO.BPMx.Status(6)   = 0; % Desliga AMP03C   



AO.BPMx.Position    = [];
AO.BPMx.CommonNames = [
    'AMP01B'; ...
    'AMP02A'; 'AMP02B'; 'AMP03A'; 'AMP03C'; 'AMP03B'; ...
    'AMP04A'; 'AMP04B'; 'AMP05A'; 'AMP05B'; ...
    'AMP06A'; 'AMP06B'; 'AMP07A'; 'AMP07B'; ...
    'AMP08A'; 'AMP08B'; 'AMP09A'; 'AMP09B'; ...
    'AMP10A'; 'AMP10B'; 'AMU11A'; ...
    'AMU11B'; 'AMP12A'; 'AMP12B'; ...
    'AMP01A'
];

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = lnls1_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';
AO.BPMx.Monitor.SpecialFunctionGet = @getbpmlnls;


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
%AO.BPMy.Status([20 23])  = [0 0]; % AMP11A and AMP11B OFF
AO.BPMy.Offset      = Orbit.OffsetOrbit(:,2);
AO.BPMy.Golden      = Orbit.GoldenOrbit(:,2);
AO.BPMy.Position    = [];
AO.BPMy.CommonNames = AO.BPMx.CommonNames;
%AO.BPMy.Status(6)   = 0; % Desliga AMP03C   

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = lnls1_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';
AO.BPMy.Monitor.SpecialFunctionGet = @getbpmlnls;



%%%%%%%%%%%%%%%%%%%%%
% Injection Kickers %
%%%%%%%%%%%%%%%%%%%%%

AO.KICKER.FamilyName  = 'KICKER';
AO.KICKER.MemberOf    = {'PlotFamily'; 'Injection'; };
AO.KICKER.DeviceList  = [1 1; 1 2; 2 1];
AO.KICKER.ElementList = (1:size(AO.KICKER.DeviceList,1))';
AO.KICKER.Status      = ones(size(AO.KICKER.DeviceList,1),1);
AO.KICKER.Position    = [];
AO.KICKER.CommonNames = ['AKC02'; 'AKC03'; 'AKC04'];
AO.KICKER.ExcitationCurves = lnls1_getexcdata(AO.KICKER.CommonNames, 1);

AO.KICKER.Setpoint.MemberOf = {'Save/Restore' ; 'KICKER'; 'Setpoint';};
AO.KICKER.Setpoint.Mode     = 'Simulator';
AO.KICKER.Setpoint.DataType      = 'Scalar';
AO.KICKER.Setpoint.ChannelNames  = lnls1_getname(AO.KICKER.FamilyName, 'Setpoint', AO.KICKER.DeviceList);
AO.KICKER.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.KICKER.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.KICKER.Setpoint.Units        = 'Hardware';
AO.KICKER.Setpoint.HWUnits      = 'KiloVolt';
AO.KICKER.Setpoint.PhysicsUnits = 'Radian';
AO.KICKER.Setpoint.Range        = [0 25];
AO.KICKER.Setpoint.Tolerance    = .1;

AO.KICKER.Monitor.MemberOf = {'KICKER'; 'Setpoint';};
AO.KICKER.Monitor.Mode     = 'Simulator';
AO.KICKER.Monitor.DataType      = 'Scalar';
AO.KICKER.Monitor.ChannelNames  = lnls1_getname(AO.KICKER.FamilyName, 'Monitor', AO.KICKER.DeviceList);
AO.KICKER.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.KICKER.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.KICKER.Monitor.Units        = 'Hardware';
AO.KICKER.Monitor.HWUnits      = 'KiloVolt';
AO.KICKER.Monitor.PhysicsUnits = 'Radian';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'; 'TuneS'];

AO.TUNE.Monitor.MemberOf         = {'TUNE'; 'Monitor'; 'Save';};
AO.TUNE.Monitor.Mode             = 'Simulator'; 
AO.TUNE.Monitor.DataType         = 'Scalar';
AO.TUNE.Monitor.ChannelNames     = lnls1_getname('TUNE', '');
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units            = 'Hardware';
AO.TUNE.Monitor.HWUnits          = 'Tune';
AO.TUNE.Monitor.PhysicsUnits     = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = @lnls1_gettune;
AO.TUNE.Monitor.Golden = [0.27 0.17 NaN];




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
AO.RF.Monitor.ChannelNames      = lnls1_getname('RF', 'Monitor');
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'Save/Restore' ;};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.ChannelNames     = lnls1_getname('RF', 'Setpoint');
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [476.062 476.068];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.OpMode.Memberof           = {'Save/Restore' ;};
AO.RF.OpMode.Mode               = 'Simulator';
AO.RF.OpMode.DataType           = 'Scalar';
AO.RF.OpMode.ChannelNames       = lnls1_getname('RF', 'OperationMode');
AO.RF.OpMode.Units              = '1|2';

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

AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'Save/Restore' ;
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



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 23.2555;

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'AMC03';    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'Ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';



setao(AO);


 
function r = build_devicelist(NSector, NDevices)

r = [];
for i=1:NSector
    for j=1:NDevices
        r = [r; i j];
    end
end

