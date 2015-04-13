function boosterinit(OperationalMode)
% Initialize parameters for ALBA Booster control in MATLAB
% 20 Nov 06: 44 BPMs, Horiz. Correctors 44, Vert. Corr. 28
% Names still need to be fixed

if nargin < 1
    OperationalMode = 1;
end

Mode = 'SIMULATOR';

% Build common devicelist
% BPMlist=[];
for Sector = 1:4:16
%     BPMlist = [
%         BPMlist;
%         Sector 1;
%         Sector 2;
%         Sector 3;
%         Sector 4;
%         Sector 5;
%         Sector 6;
%         Sector 7;
%         ];
% 
%     BPMlist = [
%         BPMlist;
%         Sector+1 1;
%         Sector+1 2;
%         Sector+1 3;
%         Sector+1 4;
%         Sector+1 5;
%         Sector+1 6;
%         Sector+1 7;
%         Sector+1 8;
%         ];
% 
%     BPMlist = [
%         BPMlist;
%         Sector+2 1;
%         Sector+2 2;
%         Sector+2 3;
%         Sector+2 4;
%         Sector+2 5;
%         Sector+2 6;
%         Sector+2 7;
%         Sector+2 8;
%         ];
% 
%     BPMlist = [
%         BPMlist;
%         Sector+3 1;
%         Sector+3 2;
%         Sector+3 3;
%         Sector+3 4;
%         Sector+3 5;
%         Sector+3 6;
%         Sector+3 7;
%         ];
 end
% 
% HCMlist=BPMlist;
% VCMlist=BPMlist;
% 
OnePerSectorList=[];
TwoPerSectorList=[];
FourPerSectorList=[];
% for Sector = 1:16
% %     HCMlist = [HCMlist;
% %         Sector 1;
% %         Sector 2;
% %         Sector 3;
% %         Sector 4;
% %         Sector 5;
% %         Sector 6;
% %         Sector 7;];
% %     
% %     VCMlist = [VCMlist;
% %         Sector 1;
% %         Sector 2;
% %         Sector 3;
% %         Sector 4;
% %         Sector 5;
% %         Sector 6;
% %         Sector 7;];
%     
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
% end
% 
% 
% 
% %=============================================
% %BPM data: status field designates if BPM in use
% %=============================================
% AO.BPMx.FamilyName               = 'BPMx';
% AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
% AO.BPMx.DeviceList               = BPMlist;   
% AO.BPMx.ElementList              = (1:size(AO.BPMx.DeviceList,1))';
% AO.BPMx.Status                   = ones(size(AO.BPMx.DeviceList,1),1);
% AO.BPMx.Monitor.Mode             = Mode;
% AO.BPMx.Monitor.DataType         = 'Scalar';
% AO.BPMx.Monitor.Units            = 'Hardware';
% AO.BPMx.Monitor.HWUnits          = 'mm';
% AO.BPMx.Monitor.PhysicsUnits     = 'meter';
% AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
% AO.BPMx.Monitor.Physics2HWParams = 1000;
% 
% AO.BPMy.FamilyName               = 'BPMy';
% AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
% AO.BPMy.DeviceList               = BPMlist;
% AO.BPMy.ElementList              = (1:size(AO.BPMy.DeviceList,1))';
% AO.BPMy.Status                   = ones(size(AO.BPMy.DeviceList,1),1);
% AO.BPMy.Monitor.Mode             = Mode;
% AO.BPMy.Monitor.DataType         = 'Scalar';
% AO.BPMy.Monitor.Units            = 'Hardware';
% AO.BPMy.Monitor.HWUnits          = 'mm';
% AO.BPMy.Monitor.PhysicsUnits     = 'meter';
% AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
% AO.BPMy.Monitor.Physics2HWParams = 1000;
% 
% 
% 
% %===========================================================
% %Corrector data: status field designates if corrector in use
% %===========================================================
% AO.HCM.FamilyName               = 'HCM';
% AO.HCM.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'HCM'; 'Magnet'};
% AO.HCM.DeviceList               = HCMlist;   
% AO.HCM.ElementList              = (1:size(AO.HCM.DeviceList,1))';
% AO.HCM.Status                   = ones(size(AO.HCM.DeviceList,1),1);
% 
% AO.HCM.Monitor.Mode             = Mode;
% AO.HCM.Monitor.DataType         = 'Scalar';
% AO.HCM.Monitor.Units            = 'Hardware';
% AO.HCM.Monitor.HWUnits          = 'ampere';           
% AO.HCM.Monitor.PhysicsUnits     = 'radian';
% AO.HCM.Monitor.HW2PhysicsFcn    = @amp2k;
% AO.HCM.Monitor.Physics2HWFcn    = @k2amp;
% 
% AO.HCM.Setpoint.Mode            = Mode;
% AO.HCM.Setpoint.DataType        = 'Scalar';
% AO.HCM.Setpoint.Units           = 'Hardware';
% AO.HCM.Setpoint.HWUnits         = 'ampere';           
% AO.HCM.Setpoint.PhysicsUnits    = 'radian';
% AO.HCM.Setpoint.HW2PhysicsFcn   = @amp2k;
% AO.HCM.Setpoint.Physics2HWFcn   = @k2amp;
% 
% 
% AO.VCM.FamilyName               = 'VCM';
% AO.VCM.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'VCM'; 'Magnet'};
% AO.VCM.DeviceList               = VCMlist;   
% AO.VCM.ElementList              = (1:size(AO.VCM.DeviceList,1))';
% AO.VCM.Status                   = ones(size(AO.VCM.DeviceList,1),1);
% 
% AO.VCM.Monitor.Mode             = Mode;
% AO.VCM.Monitor.DataType         = 'Scalar';
% AO.VCM.Monitor.Units            = 'Hardware';
% AO.VCM.Monitor.HWUnits          = 'ampere';           
% AO.VCM.Monitor.PhysicsUnits     = 'radian';
% AO.VCM.Monitor.HW2PhysicsFcn    = @amp2k;
% AO.VCM.Monitor.Physics2HWFcn    = @k2amp;
% 
% AO.VCM.Setpoint.Mode            = Mode;
% AO.VCM.Setpoint.DataType        = 'Scalar';
% AO.VCM.Setpoint.Units           = 'Hardware';
% AO.VCM.Setpoint.HWUnits         = 'ampere';           
% AO.VCM.Setpoint.PhysicsUnits    = 'radian';
% AO.VCM.Setpoint.HW2PhysicsFcn   = @amp2k;
% AO.VCM.Setpoint.Physics2HWFcn   = @k2amp;
% 
%=============================================
%BPM data: status field designates if BPM in use
%=============================================
ntbpm=44;
AO.BPMx.FamilyName               = 'BPMx';
AO.BPMx.FamilyType               = 'BPM';
AO.BPMx.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.BPMx.Monitor.Mode             = Mode;
AO.BPMx.Monitor.DataType         = 'Vector';
AO.BPMx.Monitor.DataTypeIndex    = [1:ntbpm];
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'meter';

AO.BPMy.FamilyName               = 'BPMy';
AO.BPMy.FamilyType               = 'BPM';
AO.BPMy.MemberOf                 = {'PlotFamily'; 'BPM'; 'Diagnostics'};
AO.BPMy.Monitor.Mode             = Mode;
AO.BPMy.Monitor.DataType         = 'Vector';
AO.BPMy.Monitor.DataTypeIndex    = [1:ntbpm];
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'meter';

% x-name      x-chname   xstat y-name       y-chname ystat DevList Elem  Type 
%                                                                  (Bergoz/Ecotek)
bpm={
 '1BPM01   '    '01G-BPM01:U   '  1  '1BPM01   '    '01G-BPM01:V   '  1  [1, 1]    1        ; ...
 '1BPM02   '    '01G-BPM02:U   '  1  '1BPM02   '    '01G-BPM02:V   '  1  [1, 2]    2        ; ...
 '1BPM03   '    '01G-BPM03:U   '  1  '1BPM03   '    '01G-BPM03:V   '  1  [1, 3]    3        ; ...
 '1BPM04   '    '01G-BPM04:U   '  1  '1BPM04   '    '01G-BPM04:V   '  1  [1, 4]    4        ; ...
 '1BPM05   '    '01G-BPM05:U   '  1  '1BPM05   '    '01G-BPM05:V   '  1  [1, 5]    5        ; ...
 '1BPM06   '    '01G-BPM06:U   '  1  '1BPM06   '    '01G-BPM06:V   '  1  [1, 6]    6        ; ...
 '1BPM07   '    '01G-BPM07:U   '  1  '1BPM07   '    '01G-BPM07:V   '  1  [1, 7]    7        ; ...
 '1BPM08   '    '01G-BPM08:U   '  1  '1BPM08   '    '01G-BPM08:V   '  1  [1, 8]    8        ; ...
 '1BPM09   '    '01G-BPM09:U   '  1  '1BPM09   '    '01G-BPM09:V   '  1  [1, 9]    9        ; ...
 '1BPM10   '    '01G-BPM10:U   '  1  '1BPM10   '    '01G-BPM10:V   '  1  [1,10]   10        ; ...
 '1BPM11   '    '01G-BPM11:U   '  1  '1BPM11   '    '01G-BPM11:V   '  1  [1,11]   11        ; ...
 '2BPM01   '    '02G-BPM01:U   '  1  '2BPM01   '    '02G-BPM01:V   '  1  [2, 1]   12        ; ...
 '2BPM02   '    '02G-BPM02:U   '  1  '2BPM02   '    '02G-BPM02:V   '  1  [2, 2]   13        ; ...
 '2BPM03   '    '02G-BPM03:U   '  1  '2BPM03   '    '02G-BPM03:V   '  1  [2, 3]   14        ; ...
 '2BPM04   '    '02G-BPM04:U   '  1  '2BPM04   '    '02G-BPM04:V   '  1  [2, 4]   15        ; ...
 '2BPM05   '    '02G-BPM05:U   '  1  '2BPM05   '    '02G-BPM05:V   '  1  [2, 5]   16        ; ...
 '2BPM06   '    '02G-BPM06:U   '  1  '2BPM06   '    '02G-BPM06:V   '  1  [2, 6]   17        ; ...
 '2BPM07   '    '02G-BPM07:U   '  1  '2BPM07   '    '02G-BPM07:V   '  1  [2, 7]   18        ; ...
 '2BPM08   '    '02G-BPM08:U   '  1  '2BPM08   '    '02G-BPM08:V   '  1  [2, 8]   19        ; ...
 '2BPM09   '    '02G-BPM09:U   '  1  '2BPM09   '    '02G-BPM09:V   '  1  [2, 9]   20        ; ...
 '2BPM10   '    '02G-BPM10:U   '  1  '2BPM10   '    '02G-BPM10:V   '  1  [2,10]   21        ; ...
 '2BPM11   '    '02G-BPM11:U   '  1  '2BPM11   '    '02G-BPM11:V   '  1  [2,11]   22        ; ...
 '3BPM01   '    '03G-BPM01:U   '  1  '3BPM01   '    '03G-BPM01:V   '  1  [3, 1]   23        ; ...
 '3BPM02   '    '03G-BPM02:U   '  1  '3BPM02   '    '03G-BPM02:V   '  1  [3, 2]   24        ; ...
 '3BPM03   '    '03G-BPM03:U   '  1  '3BPM03   '    '03G-BPM03:V   '  1  [3, 3]   25        ; ...
 '3BPM04   '    '03G-BPM04:U   '  1  '3BPM04   '    '03G-BPM04:V   '  1  [3, 4]   26        ; ...
 '3BPM05   '    '03G-BPM05:U   '  1  '3BPM05   '    '03G-BPM05:V   '  1  [3, 5]   27        ; ...
 '3BPM06   '    '03G-BPM06:U   '  1  '3BPM06   '    '03G-BPM06:V   '  1  [3, 6]   28        ; ...
 '3BPM07   '    '03G-BPM07:U   '  1  '3BPM07   '    '03G-BPM07:V   '  1  [3, 7]   29        ; ...
 '3BPM08   '    '03G-BPM08:U   '  1  '3BPM08   '    '03G-BPM08:V   '  1  [3, 8]   30        ; ...
 '3BPM09   '    '03G-BPM09:U   '  1  '3BPM09   '    '03G-BPM09:V   '  1  [3, 9]   31        ; ...
 '3BPM10   '    '03G-BPM10:U   '  1  '3BPM10   '    '03G-BPM10:V   '  1  [3,10]   32        ; ...
 '3BPM11   '    '03G-BPM11:U   '  1  '3BPM11   '    '03G-BPM11:V   '  1  [3,11]   33        ; ...
 '4BPM01   '    '04G-BPM01:U   '  1  '4BPM01   '    '04G-BPM01:V   '  1  [4, 1]   34        ; ...
 '4BPM02   '    '04G-BPM02:U   '  1  '4BPM02   '    '04G-BPM02:V   '  1  [4, 2]   35        ; ...
 '4BPM03   '    '04G-BPM03:U   '  1  '4BPM03   '    '04G-BPM03:V   '  1  [4, 3]   36        ; ...
 '4BPM04   '    '04G-BPM04:U   '  1  '4BPM04   '    '04G-BPM04:V   '  1  [4, 4]   37        ; ...
 '4BPM05   '    '04G-BPM05:U   '  1  '4BPM05   '    '04G-BPM05:V   '  1  [4, 5]   38        ; ...
 '4BPM06   '    '04G-BPM06:U   '  1  '4BPM06   '    '04G-BPM06:V   '  1  [4, 6]   39        ; ...
 '4BPM07   '    '04G-BPM07:U   '  1  '4BPM07   '    '04G-BPM07:V   '  1  [4, 7]   40        ; ...
 '4BPM08   '    '04G-BPM08:U   '  1  '4BPM08   '    '04G-BPM08:V   '  1  [4, 8]   41        ; ...
 '4BPM09   '    '04G-BPM09:U   '  1  '4BPM09   '    '04G-BPM09:V   '  1  [4, 9]   42        ; ...
 '4BPM10   '    '04G-BPM10:U   '  1  '4BPM10   '    '04G-BPM10:V   '  1  [4,10]   43        ; ...
 '4BPM11   '    '04G-BPM11:U   '  1  '4BPM11   '    '04G-BPM11:V   '  1  [4,11]   44        ; ...
};

%Load fields from data block
for ii=1:size(bpm,1)
name=bpm{ii,1};      AO.BPMx.CommonNames(ii,:)         = name;
name=bpm{ii,2};      AO.BPMx.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,3};      AO.BPMx.Status(ii,:)              = val;  
name=bpm{ii,4};      AO.BPMy.CommonNames(ii,:)         = name;
name=bpm{ii,5};      AO.BPMy.Monitor.ChannelNames(ii,:)= name;
val =bpm{ii,6};      AO.BPMy.Status(ii,:)              = val;  
val =bpm{ii,7};      AO.BPMx.DeviceList(ii,:)          = val;   
                     AO.BPMy.DeviceList(ii,:)          = val;
val =bpm{ii,8};      AO.BPMx.ElementList(ii,:)         = val;   
                     AO.BPMy.ElementList(ii,:)         = val;
%                      AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
%                      AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1000;
%                      AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1e-3;
%                      AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1000;
                     AO.BPMx.Monitor.HW2PhysicsParams(ii,:) = 1;
                     AO.BPMx.Monitor.Physics2HWParams(ii,:) = 1;
                     AO.BPMy.Monitor.HW2PhysicsParams(ii,:) = 1;
                     AO.BPMy.Monitor.Physics2HWParams(ii,:) = 1;
end

AO.BPMx.Status = AO.BPMx.Status(:);
AO.BPMy.Status = AO.BPMy.Status(:);

    % Scalar channel method
    AO.BPMx.Monitor.DataType = 'Scalar';
    AO.BPMy.Monitor.DataType = 'Scalar';

    AO.BPMx.Monitor = rmfield(AO.BPMx.Monitor, 'DataTypeIndex');
    AO.BPMy.Monitor = rmfield(AO.BPMy.Monitor, 'DataTypeIndex');
    
    AO.BPMx.Monitor.Handles = NaN * ones(size(AO.BPMx.DeviceList,1),1);
    AO.BPMy.Monitor.Handles = NaN * ones(size(AO.BPMx.DeviceList,1),1);

%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================
%horizontal corrector windings on SPEAR 3 cores 1,3,4
%vertical   corrector windings on SPEAR 3 cores 1,2,4

% NOTE: HCMGain and VCMGain are not used anymore!!!
%       k2amp and amp2k are use so that energy scaling works
HCMGain                        = 1; %0.0015/30.0;                  %0.0015  radian/30 ampere @ 3.0 GeV
VCMGain                        = 1; %0.00075/30.0;                 %0.00075 radian/30 ampere @ 3.0 GeV

AO.HCM.FamilyName               = 'HCM';
AO.HCM.FamilyType               = 'COR';
AO.HCM.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'MCOR'; 'HCM'; 'Magnet'};

AO.HCM.Monitor.Mode             = Mode;
AO.HCM.Monitor.DataType         = 'Scalar';
AO.HCM.Monitor.Units            = 'Hardware';
AO.HCM.Monitor.HWUnits          = 'ampere';           
AO.HCM.Monitor.PhysicsUnits     = 'radian';
AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCM.Monitor.Physics2HWFcn = @k2amp;

AO.HCM.Setpoint.Mode            = Mode;
AO.HCM.Setpoint.DataType        = 'Scalar';
AO.HCM.Setpoint.Units           = 'Hardware';
AO.HCM.Setpoint.HWUnits         = 'ampere';           
AO.HCM.Setpoint.PhysicsUnits    = 'radian';
AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn = @k2amp;

% HW in ampere, Physics in radian                                                                                                      ** radian units converted to ampere below ***
%x-common      x-monitor           x-setpoint     xstat y-common      y-monitor          y-setpoint      ystat devlist elem range (ampere) tol   x-kick    y-kick    y-phot   H2P_X          P2H_X          H2P_Y        P2H_Y 
hcor={
'1COR01   '	'01G-COR01:U   '	'01G-COR01:U   '	1	'1COR01   '	'01G-COR01:V   '	'01G-COR01:V   '	0	[1, 1]	1	[-1000.0 1000.0];	...
'1COR02   '	'01G-COR02:U   '	'01G-COR02:U   '	1	'1COR02   '	'01G-COR02:V   '	'01G-COR02:V   '	0	[1, 2]	2	[-1000.0 1000.0];	...
'1COR03   '	'01G-COR03:U   '	'01G-COR03:U   '	1	'1COR03   '	'01G-COR03:V   '	'01G-COR03:V   '	0	[1, 3]	3	[-1000.0 1000.0];	...
'1COR04   '	'01G-COR04:U   '	'01G-COR04:U   '	1	'1COR04   '	'01G-COR04:V   '	'01G-COR04:V   '	0	[1, 4]	4	[-1000.0 1000.0];	...
'1COR05   '	'01G-COR05:U   '	'01G-COR05:U   '	1	'1COR05   '	'01G-COR05:V   '	'01G-COR05:V   '	0	[1, 5]	5	[-1000.0 1000.0];	...
'1COR06   '	'01G-COR06:U   '	'01G-COR06:U   '	1	'1COR06   '	'01G-COR06:V   '	'01G-COR06:V   '	0	[1, 6]	6	[-1000.0 1000.0];	...
'1COR07   '	'01G-COR07:U   '	'01G-COR07:U   '	1	'1COR07   '	'01G-COR07:V   '	'01G-COR07:V   '	0	[1, 7]	7	[-1000.0 1000.0];	...
'1COR08   '	'01G-COR08:U   '	'01G-COR08:U   '	1	'1COR08   '	'01G-COR08:V   '	'01G-COR08:V   '	0	[1, 8]	8	[-1000.0 1000.0];	...
'1COR09   '	'01G-COR09:U   '	'01G-COR09:U   '	1	'1COR09   '	'01G-COR09:V   '	'01G-COR09:V   '	0	[1, 9]	9	[-1000.0 1000.0];	...
'1COR10   '	'01G-COR10:U   '	'01G-COR10:U   '	1	'1COR10   '	'01G-COR10:V   '	'01G-COR10:V   '	0	[1,10]	10	[-1000.0 1000.0];	...
'1COR11   '	'01G-COR11:U   '	'01G-COR11:U   '	1	'1COR11   '	'01G-COR11:V   '	'01G-COR11:V   '	0	[1,11]	11	[-1000.0 1000.0];	...
'2COR01   '	'02G-COR01:U   '	'02G-COR01:U   '	1	'2COR01   '	'02G-COR01:V   '	'02G-COR01:V   '	0	[2, 1]	12	[-1000.0 1000.0];	...
'2COR02   '	'02G-COR02:U   '	'02G-COR02:U   '	1	'2COR02   '	'02G-COR02:V   '	'02G-COR02:V   '	0	[2, 2]	13	[-1000.0 1000.0];	...
'2COR03   '	'02G-COR03:U   '	'02G-COR03:U   '	1	'2COR03   '	'02G-COR03:V   '	'02G-COR03:V   '	0	[2, 3]	14	[-1000.0 1000.0];	...
'2COR04   '	'02G-COR04:U   '	'02G-COR04:U   '	1	'2COR04   '	'02G-COR04:V   '	'02G-COR04:V   '	0	[2, 4]	15	[-1000.0 1000.0];	...
'2COR05   '	'02G-COR05:U   '	'02G-COR05:U   '	1	'2COR05   '	'02G-COR05:V   '	'02G-COR05:V   '	0	[2, 5]	16	[-1000.0 1000.0];	...
'2COR06   '	'02G-COR06:U   '	'02G-COR06:U   '	1	'2COR06   '	'02G-COR06:V   '	'02G-COR06:V   '	0	[2, 6]	17	[-1000.0 1000.0];	...
'2COR07   '	'02G-COR07:U   '	'02G-COR07:U   '	1	'2COR07   '	'02G-COR07:V   '	'02G-COR07:V   '	0	[2, 7]	18	[-1000.0 1000.0];	...
'2COR08   '	'02G-COR08:U   '	'02G-COR08:U   '	1	'2COR08   '	'02G-COR08:V   '	'02G-COR08:V   '	0	[2, 8]	19	[-1000.0 1000.0];	...
'2COR09   '	'02G-COR09:U   '	'02G-COR09:U   '	1	'2COR09   '	'02G-COR09:V   '	'02G-COR09:V   '	0	[2, 9]	20	[-1000.0 1000.0];	...
'2COR10   '	'02G-COR10:U   '	'02G-COR10:U   '	1	'2COR10   '	'02G-COR10:V   '	'02G-COR10:V   '	0	[2,10]	21	[-1000.0 1000.0];	...
'2COR11   '	'02G-COR11:U   '	'02G-COR11:U   '	1	'2COR11   '	'02G-COR11:V   '	'02G-COR11:V   '	0	[2,11]	22	[-1000.0 1000.0];	...
'3COR01   '	'03G-COR01:U   '	'03G-COR01:U   '	1	'3COR01   '	'03G-COR01:V   '	'03G-COR01:V   '	0	[3, 1]	23	[-1000.0 1000.0];	...
'3COR02   '	'03G-COR02:U   '	'03G-COR02:U   '	1	'3COR02   '	'03G-COR02:V   '	'03G-COR02:V   '	0	[3, 2]	24	[-1000.0 1000.0];	...
'3COR03   '	'03G-COR03:U   '	'03G-COR03:U   '	1	'3COR03   '	'03G-COR03:V   '	'03G-COR03:V   '	0	[3, 3]	25	[-1000.0 1000.0];	...
'3COR04   '	'03G-COR04:U   '	'03G-COR04:U   '	1	'3COR04   '	'03G-COR04:V   '	'03G-COR04:V   '	0	[3, 4]	26	[-1000.0 1000.0];	...
'3COR05   '	'03G-COR05:U   '	'03G-COR05:U   '	1	'3COR05   '	'03G-COR05:V   '	'03G-COR05:V   '	0	[3, 5]	27	[-1000.0 1000.0];	...
'3COR06   '	'03G-COR06:U   '	'03G-COR06:U   '	1	'3COR06   '	'03G-COR06:V   '	'03G-COR06:V   '	0	[3, 6]	28	[-1000.0 1000.0];	...
'3COR07   '	'03G-COR07:U   '	'03G-COR07:U   '	1	'3COR07   '	'03G-COR07:V   '	'03G-COR07:V   '	0	[3, 7]	29	[-1000.0 1000.0];	...
'3COR08   '	'03G-COR08:U   '	'03G-COR08:U   '	1	'3COR08   '	'03G-COR08:V   '	'03G-COR08:V   '	0	[3, 8]	30	[-1000.0 1000.0];	...
'3COR09   '	'03G-COR09:U   '	'03G-COR09:U   '	1	'3COR09   '	'03G-COR09:V   '	'03G-COR09:V   '	0	[3, 9]	31	[-1000.0 1000.0];	...
'3COR10   '	'03G-COR10:U   '	'03G-COR10:U   '	1	'3COR10   '	'03G-COR10:V   '	'03G-COR10:V   '	0	[3,10]	32	[-1000.0 1000.0];	...
'3COR11   '	'03G-COR11:U   '	'03G-COR11:U   '	1	'3COR11   '	'03G-COR11:V   '	'03G-COR11:V   '	0	[3,11]	33	[-1000.0 1000.0];	...
'4COR01   '	'04G-COR01:U   '	'04G-COR01:U   '	1	'4COR01   '	'04G-COR01:V   '	'04G-COR01:V   '	0	[4, 1]	34	[-1000.0 1000.0];	...
'4COR02   '	'04G-COR02:U   '	'04G-COR02:U   '	1	'4COR02   '	'04G-COR02:V   '	'04G-COR02:V   '	0	[4, 2]	35	[-1000.0 1000.0];	...
'4COR03   '	'04G-COR03:U   '	'04G-COR03:U   '	1	'4COR03   '	'04G-COR03:V   '	'04G-COR03:V   '	0	[4, 3]	36	[-1000.0 1000.0];	...
'4COR04   '	'04G-COR04:U   '	'04G-COR04:U   '	1	'4COR04   '	'04G-COR04:V   '	'04G-COR04:V   '	0	[4, 4]	37	[-1000.0 1000.0];	...
'4COR05   '	'04G-COR05:U   '	'04G-COR05:U   '	1	'4COR05   '	'04G-COR05:V   '	'04G-COR05:V   '	0	[4, 5]	38	[-1000.0 1000.0];	...
'4COR06   '	'04G-COR06:U   '	'04G-COR06:U   '	1	'4COR06   '	'04G-COR06:V   '	'04G-COR06:V   '	0	[4, 6]	39	[-1000.0 1000.0];	...
'4COR07   '	'04G-COR07:U   '	'04G-COR07:U   '	1	'4COR07   '	'04G-COR07:V   '	'04G-COR07:V   '	0	[4, 7]	40	[-1000.0 1000.0];	...
'4COR08   '	'04G-COR08:U   '	'04G-COR08:U   '	1	'4COR08   '	'04G-COR08:V   '	'04G-COR08:V   '	0	[4, 8]	41	[-1000.0 1000.0];	...
'4COR09   '	'04G-COR09:U   '	'04G-COR09:U   '	1	'4COR09   '	'04G-COR09:V   '	'04G-COR09:V   '	0	[4, 9]	42	[-1000.0 1000.0];	...
'4COR10   '	'04G-COR10:U   '	'04G-COR10:U   '	1	'4COR10   '	'04G-COR10:V   '	'04G-COR10:V   '	0	[4,10]	43	[-1000.0 1000.0];	...
'4COR11   '	'04G-COR11:U   '	'04G-COR11:U   '	1	'4COR11   '	'04G-COR11:V   '	'04G-COR11:V   '	0	[4,11]	44	[-1000.0 1000.0];	...
};

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, HCMcoefficients] = magnetcoefficients('HCM');
HCMcoefficients = [HCMcoefficients 0];
% [C, Leff, MagnetType, VCMcoefficients] = magnetcoefficients('VCM');
% VCMcoefficients = [VCMcoefficients 0];
% 
for ii=1:size(hcor,1)
    name=hcor{ii,1};     AO.HCM.CommonNames(ii,:)           = name;
    name=hcor{ii,3};     AO.HCM.Setpoint.ChannelNames(ii,:) = name;
    name=hcor{ii,2};     AO.HCM.Monitor.ChannelNames(ii,:)  = name;
    val =hcor{ii,4};     AO.HCM.Status(ii,1)                = val;

%     name=cor{ii,5};     AO.VCM.CommonNames(ii,:)           = name;
%     name=cor{ii,7};     AO.VCM.Setpoint.ChannelNames(ii,:) = name;
%     name=cor{ii,6};     AO.VCM.Monitor.ChannelNames(ii,:)  = name;
%     val =cor{ii,8};     AO.VCM.Status(ii,1)                = val;

    val =hcor{ii,9};     AO.HCM.DeviceList(ii,:)            = val;
% %     AO.VCM.DeviceList(ii,:)            = val;
     val =hcor{ii,10};    AO.HCM.ElementList(ii,1)           = val;
% %     AO.VCM.ElementList(ii,1)           = val;
     val =hcor{ii,11};    AO.HCM.Setpoint.Range(ii,:)        = val;
% %     AO.VCM.Setpoint.Range(ii,:)        = val;
%     % val =cor{ii,12};    AO.HCM.Setpoint.Tolerance(ii,1)    = val;
     AO.HCM.Setpoint.Tolerance(ii,1)    = 1;
%     %
%     %                     AO.VCM.Setpoint.Tolerance(ii,1)    = val;
% %     AO.VCM.Setpoint.Tolerance(ii,1)    = 1;
%     %val =cor{ii,13};    AO.HCM.Setpoint.DeltaRespMat(ii,1) = val;
     AO.HCM.Setpoint.DeltaRespMat(ii,1) = 1;
%     %val =cor{ii,14};    AO.VCM.Setpoint.DeltaRespMat(ii,1) = val;
%     AO.VCM.Setpoint.DeltaRespMat(ii,1) = 1;
%     %val =cor{ii,15};    AO.VCM.Setpoint.PhotResp(ii,1)     = val;
% %     AO.VCM.Setpoint.PhotResp(ii,1)     = 1;


    AO.HCM.Monitor.HW2PhysicsParams{1}(ii,:)  = HCMcoefficients;
    AO.HCM.Monitor.Physics2HWParams{1}(ii,:)  = HCMcoefficients;
    AO.HCM.Setpoint.HW2PhysicsParams{1}(ii,:) = HCMcoefficients;
    AO.HCM.Setpoint.Physics2HWParams{1}(ii,:) = HCMcoefficients;

%     AO.VCM.Monitor.HW2PhysicsParams{1}(ii,:)  = VCMcoefficients;
%     AO.VCM.Monitor.Physics2HWParams{1}(ii,:)  = VCMcoefficients;
%     AO.VCM.Setpoint.HW2PhysicsParams{1}(ii,:) = VCMcoefficients;
%     AO.VCM.Setpoint.Physics2HWParams{1}(ii,:) = VCMcoefficients;

    % AO.HCM.Monitor.HW2PhysicsParams(ii,:)    = cor{ii,16}(1);
    % AO.HCM.Monitor.Physics2HWParams(ii,:)    = cor{ii,17}(1);
    % AO.HCM.Setpoint.HW2PhysicsParams(ii,:)   = cor{ii,16}(1);
    % AO.HCM.Setpoint.Physics2HWParams(ii,:)   = cor{ii,17}(1);
    %
    % AO.VCM.Monitor.HW2PhysicsParams(ii,:)    = cor{ii,18}(1);          %
    % AO.VCM.Monitor.Physics2HWParams(ii,:)    = cor{ii,19}(1);
    % AO.VCM.Setpoint.HW2PhysicsParams(ii,:)   = cor{ii,18}(1);
    % AO.VCM.Setpoint.Physics2HWParams(ii,:)   = cor{ii,19}(1);

    AO.HCM.Monitor.Handles(ii,1)    = NaN;
    AO.HCM.Setpoint.Handles(ii,1)   = NaN;
%     AO.VCM.Monitor.Handles(ii,1)    = NaN;
%     AO.VCM.Setpoint.Handles(ii,1)   = NaN;
end

AO.HCM.Status=AO.HCM.Status(:);

%===========================================================
%Corrector data: status field designates if corrector in use
%===========================================================
%horizontal corrector windings on SPEAR 3 cores 1,3,4
%vertical   corrector windings on SPEAR 3 cores 1,2,4

% NOTE: HCMGain and VCMGain are not used anymore!!!
%       k2amp and amp2k are use so that energy scaling works
HCMGain                        = 1; %0.0015/30.0;                  %0.0015  radian/30 ampere @ 3.0 GeV
VCMGain                        = 1; %0.00075/30.0;                 %0.00075 radian/30 ampere @ 3.0 GeV

AO.VCM.FamilyName               = 'VCM';
AO.VCM.FamilyType               = 'COR';
AO.VCM.MemberOf                 = {'MachineConfig'; 'PlotFamily';  'COR'; 'MCOR'; 'VCM'; 'Magnet'};

AO.VCM.Monitor.Mode             = Mode;
AO.VCM.Monitor.DataType         = 'Scalar';
AO.VCM.Monitor.Units            = 'Hardware';
AO.VCM.Monitor.HWUnits          = 'ampere';           
AO.VCM.Monitor.PhysicsUnits     = 'radian';
AO.VCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.VCM.Monitor.Physics2HWFcn = @k2amp;

AO.VCM.Setpoint.Mode            = Mode;
AO.VCM.Setpoint.DataType        = 'Scalar';
AO.VCM.Setpoint.Units           = 'Hardware';
AO.VCM.Setpoint.HWUnits         = 'ampere';           
AO.VCM.Setpoint.PhysicsUnits    = 'radian';
AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.VCM.Setpoint.Physics2HWFcn = @k2amp;

% HW in ampere, Physics in radian                                                                                                      ** radian units converted to ampere below ***
%x-common      x-monitor           x-setpoint     xstat y-common      y-monitor          y-setpoint      ystat devlist elem range (ampere) tol   x-kick    y-kick    y-phot   H2P_X          P2H_X          H2P_Y        P2H_Y 
vcor={
'1COR01   '	'01G-COR01:U   '	'01G-COR01:U   '	0	'1COR01   '	'01G-COR01:V   '	'01G-COR01:V   '	1	[1, 1]	1	[-1000.0 1000.0];	...
'1COR02   '	'01G-COR02:U   '	'01G-COR02:U   '	0	'1COR02   '	'01G-COR02:V   '	'01G-COR02:V   '	1	[1, 2]	2	[-1000.0 1000.0];	...
'1COR03   '	'01G-COR03:U   '	'01G-COR03:U   '	0	'1COR03   '	'01G-COR03:V   '	'01G-COR03:V   '	1	[1, 3]	3	[-1000.0 1000.0];	...
'1COR04   '	'01G-COR04:U   '	'01G-COR04:U   '	0	'1COR04   '	'01G-COR04:V   '	'01G-COR04:V   '	1	[1, 4]	4	[-1000.0 1000.0];	...
'1COR05   '	'01G-COR05:U   '	'01G-COR05:U   '	0	'1COR05   '	'01G-COR05:V   '	'01G-COR05:V   '	1	[1, 5]	5	[-1000.0 1000.0];	...
'1COR06   '	'01G-COR06:U   '	'01G-COR06:U   '	0	'1COR06   '	'01G-COR06:V   '	'01G-COR06:V   '	1	[1, 6]	6	[-1000.0 1000.0];	...
'1COR07   '	'01G-COR07:U   '	'01G-COR07:U   '	0	'1COR07   '	'01G-COR07:V   '	'01G-COR07:V   '	1	[1, 7]	7	[-1000.0 1000.0];	...
'1COR08   '	'01G-COR08:U   '	'01G-COR08:U   '	0	'1COR08   '	'01G-COR08:V   '	'01G-COR08:V   '	1	[1, 8]	8	[-1000.0 1000.0];	...
'1COR09   '	'01G-COR09:U   '	'01G-COR09:U   '	0	'1COR09   '	'01G-COR09:V   '	'01G-COR09:V   '	1	[1, 9]	9	[-1000.0 1000.0];	...
'1COR10   '	'01G-COR10:U   '	'01G-COR10:U   '	0	'1COR10   '	'01G-COR10:V   '	'01G-COR10:V   '	1	[1,10]	10	[-1000.0 1000.0];	...
'1COR11   '	'01G-COR11:U   '	'01G-COR11:U   '	0	'1COR11   '	'01G-COR11:V   '	'01G-COR11:V   '	1	[1,11]	11	[-1000.0 1000.0];	...
'2COR01   '	'02G-COR01:U   '	'02G-COR01:U   '	0	'2COR01   '	'02G-COR01:V   '	'02G-COR01:V   '	1	[2, 1]	12	[-1000.0 1000.0];	...
'2COR02   '	'02G-COR02:U   '	'02G-COR02:U   '	0	'2COR02   '	'02G-COR02:V   '	'02G-COR02:V   '	1	[2, 2]	13	[-1000.0 1000.0];	...
'2COR03   '	'02G-COR03:U   '	'02G-COR03:U   '	0	'2COR03   '	'02G-COR03:V   '	'02G-COR03:V   '	1	[2, 3]	14	[-1000.0 1000.0];	...
'2COR04   '	'02G-COR04:U   '	'02G-COR04:U   '	0	'2COR04   '	'02G-COR04:V   '	'02G-COR04:V   '	1	[2, 4]	15	[-1000.0 1000.0];	...
'2COR05   '	'02G-COR05:U   '	'02G-COR05:U   '	0	'2COR05   '	'02G-COR05:V   '	'02G-COR05:V   '	1	[2, 5]	16	[-1000.0 1000.0];	...
'2COR06   '	'02G-COR06:U   '	'02G-COR06:U   '	0	'2COR06   '	'02G-COR06:V   '	'02G-COR06:V   '	1	[2, 6]	17	[-1000.0 1000.0];	...
'2COR07   '	'02G-COR07:U   '	'02G-COR07:U   '	0	'2COR07   '	'02G-COR07:V   '	'02G-COR07:V   '	1	[2, 7]	18	[-1000.0 1000.0];	...
'2COR08   '	'02G-COR08:U   '	'02G-COR08:U   '	0	'2COR08   '	'02G-COR08:V   '	'02G-COR08:V   '	1	[2, 8]	19	[-1000.0 1000.0];	...
'2COR09   '	'02G-COR09:U   '	'02G-COR09:U   '	0	'2COR09   '	'02G-COR09:V   '	'02G-COR09:V   '	1	[2, 9]	20	[-1000.0 1000.0];	...
'2COR10   '	'02G-COR10:U   '	'02G-COR10:U   '	0	'2COR10   '	'02G-COR10:V   '	'02G-COR10:V   '	1	[2,10]	21	[-1000.0 1000.0];	...
'2COR11   '	'02G-COR11:U   '	'02G-COR11:U   '	0	'2COR11   '	'02G-COR11:V   '	'02G-COR11:V   '	1	[2,11]	22	[-1000.0 1000.0];	...
'3COR01   '	'03G-COR01:U   '	'03G-COR01:U   '	0	'3COR01   '	'03G-COR01:V   '	'03G-COR01:V   '	1	[3, 1]	23	[-1000.0 1000.0];	...
'3COR02   '	'03G-COR02:U   '	'03G-COR02:U   '	0	'3COR02   '	'03G-COR02:V   '	'03G-COR02:V   '	1	[3, 2]	24	[-1000.0 1000.0];	...
'3COR03   '	'03G-COR03:U   '	'03G-COR03:U   '	0	'3COR03   '	'03G-COR03:V   '	'03G-COR03:V   '	1	[3, 3]	25	[-1000.0 1000.0];	...
'3COR04   '	'03G-COR04:U   '	'03G-COR04:U   '	0	'3COR04   '	'03G-COR04:V   '	'03G-COR04:V   '	1	[3, 4]	26	[-1000.0 1000.0];	...
'3COR05   '	'03G-COR05:U   '	'03G-COR05:U   '	0	'3COR05   '	'03G-COR05:V   '	'03G-COR05:V   '	1	[3, 5]	27	[-1000.0 1000.0];	...
'3COR06   '	'03G-COR06:U   '	'03G-COR06:U   '	0	'3COR06   '	'03G-COR06:V   '	'03G-COR06:V   '	1	[3, 6]	28	[-1000.0 1000.0];	...
'3COR07   '	'03G-COR07:U   '	'03G-COR07:U   '	0	'3COR07   '	'03G-COR07:V   '	'03G-COR07:V   '	1	[3, 7]	29	[-1000.0 1000.0];	...
'3COR08   '	'03G-COR08:U   '	'03G-COR08:U   '	0	'3COR08   '	'03G-COR08:V   '	'03G-COR08:V   '	1	[3, 8]	30	[-1000.0 1000.0];	...
'3COR09   '	'03G-COR09:U   '	'03G-COR09:U   '	0	'3COR09   '	'03G-COR09:V   '	'03G-COR09:V   '	1	[3, 9]	31	[-1000.0 1000.0];	...
'3COR10   '	'03G-COR10:U   '	'03G-COR10:U   '	0	'3COR10   '	'03G-COR10:V   '	'03G-COR10:V   '	1	[3,10]	32	[-1000.0 1000.0];	...
'3COR11   '	'03G-COR11:U   '	'03G-COR11:U   '	0	'3COR11   '	'03G-COR11:V   '	'03G-COR11:V   '	1	[3,11]	33	[-1000.0 1000.0];	...
'4COR01   '	'04G-COR01:U   '	'04G-COR01:U   '	0	'4COR01   '	'04G-COR01:V   '	'04G-COR01:V   '	1	[4, 1]	34	[-1000.0 1000.0];	...
'4COR02   '	'04G-COR02:U   '	'04G-COR02:U   '	0	'4COR02   '	'04G-COR02:V   '	'04G-COR02:V   '	1	[4, 2]	35	[-1000.0 1000.0];	...
'4COR03   '	'04G-COR03:U   '	'04G-COR03:U   '	0	'4COR03   '	'04G-COR03:V   '	'04G-COR03:V   '	1	[4, 3]	36	[-1000.0 1000.0];	...
'4COR04   '	'04G-COR04:U   '	'04G-COR04:U   '	0	'4COR04   '	'04G-COR04:V   '	'04G-COR04:V   '	1	[4, 4]	37	[-1000.0 1000.0];	...
'4COR05   '	'04G-COR05:U   '	'04G-COR05:U   '	0	'4COR05   '	'04G-COR05:V   '	'04G-COR05:V   '	1	[4, 5]	38	[-1000.0 1000.0];	...
'4COR06   '	'04G-COR06:U   '	'04G-COR06:U   '	0	'4COR06   '	'04G-COR06:V   '	'04G-COR06:V   '	1	[4, 6]	39	[-1000.0 1000.0];	...
'4COR07   '	'04G-COR07:U   '	'04G-COR07:U   '	0	'4COR07   '	'04G-COR07:V   '	'04G-COR07:V   '	1	[4, 7]	40	[-1000.0 1000.0];	...
'4COR08   '	'04G-COR08:U   '	'04G-COR08:U   '	0	'4COR08   '	'04G-COR08:V   '	'04G-COR08:V   '	1	[4, 8]	41	[-1000.0 1000.0];	...
'4COR09   '	'04G-COR09:U   '	'04G-COR09:U   '	0	'4COR09   '	'04G-COR09:V   '	'04G-COR09:V   '	1	[4, 9]	42	[-1000.0 1000.0];	...
'4COR10   '	'04G-COR10:U   '	'04G-COR10:U   '	0	'4COR10   '	'04G-COR10:V   '	'04G-COR10:V   '	1	[4,10]	43	[-1000.0 1000.0];	...
'4COR11   '	'04G-COR11:U   '	'04G-COR11:U   '	0	'4COR11   '	'04G-COR11:V   '	'04G-COR11:V   '	1	[4,11]	44	[-1000.0 1000.0];	...
};

%Load fields from datablock
% AT use the "A-coefficients" for correctors plus an offset
[C, Leff, MagnetType, VCMcoefficients] = magnetcoefficients('VCM');
VCMcoefficients = [VCMcoefficients 0];

for ii=1:size(vcor,1)

    name=vcor{ii,5};     AO.VCM.CommonNames(ii,:)           = name;
    name=vcor{ii,7};     AO.VCM.Setpoint.ChannelNames(ii,:) = name;
    name=vcor{ii,6};     AO.VCM.Monitor.ChannelNames(ii,:)  = name;
    val =vcor{ii,8};     AO.VCM.Status(ii,1)                = val;

    val =vcor{ii,9};    
    AO.VCM.DeviceList(ii,:)            = val;
    val =vcor{ii,10};   
    AO.VCM.ElementList(ii,1)           = val;
    val =vcor{ii,11};   
    AO.VCM.Setpoint.Range(ii,:)        = val;
    % val =cor{ii,12};    AO.HCM.Setpoint.Tolerance(ii,1)    = val;
    %                     AO.VCM.Setpoint.Tolerance(ii,1)    = val;
    AO.VCM.Setpoint.Tolerance(ii,1)    = 1;
    %val =cor{ii,13};    AO.HCM.Setpoint.DeltaRespMat(ii,1) = val;
    AO.VCM.Setpoint.DeltaRespMat(ii,1) = 1;
    %val =cor{ii,15};    AO.VCM.Setpoint.PhotResp(ii,1)     = val;
    AO.VCM.Setpoint.PhotResp(ii,1)     = 1;
    AO.VCM.Monitor.HW2PhysicsParams{1}(ii,:)  = VCMcoefficients;
    AO.VCM.Monitor.Physics2HWParams{1}(ii,:)  = VCMcoefficients;
    AO.VCM.Setpoint.HW2PhysicsParams{1}(ii,:) = VCMcoefficients;
    AO.VCM.Setpoint.Physics2HWParams{1}(ii,:) = VCMcoefficients;

    AO.VCM.Monitor.Handles(ii,1)    = NaN;
    AO.VCM.Setpoint.Handles(ii,1)   = NaN;
end

AO.VCM.Status=AO.VCM.Status(:);

%=============================
%        MAIN MAGNETS
%=============================

%===========
%Dipole data
%===========
% *** BEND ***
% AO.BEND.FamilyName                 = 'BEND';
% AO.BEND.MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet';};
% AO.BEND.DeviceList                 = TwoPerSectorList;
% AO.BEND.ElementList                = ones(size(AO.BEND.DeviceList,1),1);
% AO.BEND.Status = 1;
% 
% AO.BEND.Monitor.Mode               = Mode;
% AO.BEND.Monitor.DataType           = 'Scalar';
% AO.BEND.Monitor.ChannelNames       = '';
% AO.BEND.Monitor.Units              = 'Hardware';
% AO.BEND.Monitor.HW2PhysicsFcn      = @amp2k;
% AO.BEND.Monitor.Physics2HWFcn      = @k2amp;
% AO.BEND.Monitor.HWUnits            = 'ampere';           
% AO.BEND.Monitor.PhysicsUnits       = 'radian';
% 
% AO.BEND.Setpoint.Mode              = Mode;
% AO.BEND.Setpoint.DataType          = 'Scalar';
% AO.BEND.Monitor.ChannelNames       = '';
% AO.BEND.Setpoint.Units             = 'Hardware';
% AO.BEND.Setpoint.HW2PhysicsFcn     = @amp2k;
% AO.BEND.Setpoint.Physics2HWFcn     = @k2amp;
% AO.BEND.Setpoint.HWUnits           = 'ampere';           
% AO.BEND.Setpoint.PhysicsUnits      = 'radian';
% *** BEND ***
AO.BEND.FamilyName                 = 'BEND';
AO.BEND.MemberOf                   = {'MachineConfig'; 'BEND'; 'Magnet';};

AO.BEND.Monitor.Mode               = Mode;
AO.BEND.Monitor.DataType           = 'Scalar';
AO.BEND.Monitor.Units              = 'Hardware';
AO.BEND.Monitor.HW2PhysicsFcn      = @amp2k;
AO.BEND.Monitor.Physics2HWFcn      = @k2amp;
AO.BEND.Monitor.HWUnits            = 'ampere';           
AO.BEND.Monitor.PhysicsUnits       = 'radian';

AO.BEND.Setpoint.Mode              = Mode;
AO.BEND.Setpoint.DataType          = 'Scalar';
AO.BEND.Setpoint.Units             = 'Hardware';
AO.BEND.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.BEND.Setpoint.Physics2HWFcn     = @k2amp;
AO.BEND.Setpoint.HWUnits           = 'ampere';           
AO.BEND.Setpoint.PhysicsUnits      = 'radian';
%                                                                                                        delta-k
%common                monitor         setpoint           stat devlist elem   scalefactor    range    tol   respkick
bend={
'BO-MA-BM05-S0101'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 1]   1       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0101'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 2]   2       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0102'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 3]   3       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0103'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 4]   4       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0104'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 5]   5       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0105'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 6]   6       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0106'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 7]   7       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0107'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 8]   8       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0108'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 9]   9       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0102'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1,10]  10       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0201'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 1]  11       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0201'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 2]  12       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0202'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 3]  13       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0203'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 4]  14       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0204'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 5]  15       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0205'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 6]  16       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0206'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 7]  17       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0207'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 8]  18       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0208'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 9]  19       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0202'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1,10]  20       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0301'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 1]  21       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0301'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 2]  22       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0302'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 3]  23       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0303'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 4]  24       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0304'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 5]  25       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0305'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 6]  26       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0306'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 7]  27       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0307'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 8]  28       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0308'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 9]  29       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0302'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1,10]  30       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0401'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 1]  31       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0401'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 2]  32       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0402'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 3]  33       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0403'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 4]  34       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0404'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 5]  35       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0405'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 6]  36       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0406'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 7]  37       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0407'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 8]  38       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM10-S0408'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1, 9]  39       1.0        [0, 500] 0.050   0.05     ; ...
'BO-MA-BM05-S0402'   'MS1-BD:Curr'    'MS1-BD:CurrSetpt'  1    [1,10]  40       1.0        [0, 500] 0.050   0.05     ; ...
};

for ii=1:size(bend,1)
name=bend{ii,1};      AO.BEND.CommonNames(ii,:)           = name;
name=bend{ii,2};      AO.BEND.Monitor.ChannelNames(ii,:)  = name;
name=bend{ii,3};      AO.BEND.Setpoint.ChannelNames(ii,:) = name;
val =bend{ii,4};      AO.BEND.Status(ii,1)                = val;
val =bend{ii,5};      AO.BEND.DeviceList(ii,:)            = val;
val =bend{ii,6};      AO.BEND.ElementList(ii,1)           = val;

    HW2PhysicsParams = magnetcoefficients('BEND');
    Physics2HWParams = HW2PhysicsParams;

val =bend{ii,7};
AO.BEND.Monitor.HW2PhysicsParams{1}(ii,:)                 = HW2PhysicsParams;
AO.BEND.Monitor.HW2PhysicsParams{2}(ii,:)                 = val;
AO.BEND.Setpoint.HW2PhysicsParams{1}(ii,:)                = HW2PhysicsParams;
AO.BEND.Setpoint.HW2PhysicsParams{2}(ii,:)                = val;
AO.BEND.Monitor.Physics2HWParams{1}(ii,:)                 = Physics2HWParams;
AO.BEND.Monitor.Physics2HWParams{2}(ii,:)                 = val;
AO.BEND.Setpoint.Physics2HWParams{1}(ii,:)                = Physics2HWParams;
AO.BEND.Setpoint.Physics2HWParams{2}(ii,:)                = val;
val =bend{ii,8};      AO.BEND.Setpoint.Range(ii,:)        = val;
val =bend{ii,9};      AO.BEND.Setpoint.Tolerance(ii,1)    = val;
val =bend{ii,10};     AO.BEND.Setpoint.DeltaRespMat(ii,1) = val;

AO.BEND.Monitor.Handles(ii,1)    = NaN;
AO.BEND.Setpoint.Handles(ii,1)   = NaN;
end


%QUADRUPOLES
% *** QF1 ***
AO.QF1.FamilyName                 = 'QF1';
AO.QF1.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};

AO.QF1.Monitor.Mode               = Mode;
AO.QF1.Monitor.DataType           = 'Scalar';
AO.QF1.Monitor.Units              = 'Hardware';
AO.QF1.Monitor.HW2PhysicsFcn      = @amp2k;
AO.QF1.Monitor.Physics2HWFcn      = @k2amp;
AO.QF1.Monitor.HWUnits            = 'ampere';           
AO.QF1.Monitor.PhysicsUnits       = 'meter^-2';

AO.QF1.Setpoint.Mode              = Mode;
AO.QF1.Setpoint.DataType          = 'Scalar';
AO.QF1.Setpoint.Units             = 'Hardware';
AO.QF1.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.QF1.Setpoint.Physics2HWFcn     = @k2amp;
AO.QF1.Setpoint.HWUnits           = 'ampere';           
AO.QF1.Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common             monitor                setpoint           stat devlist  elem        range   tol  respkick
qf1={  
 '1QF11     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '1QF12     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [1  ,1]  2         [0 500]  0.050    0.05; ...
 '2QF11     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [2  ,1]  3         [0 500]  0.050    0.05; ...
 '2QF12     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [2  ,1]  4         [0 500]  0.050    0.05; ...
 '3QF11     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [3  ,1]  5         [0 500]  0.050    0.05; ...
 '3QF12     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [3  ,1]  6         [0 500]  0.050    0.05; ...
 '4QF11     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [4  ,1]  7         [0 500]  0.050    0.05; ...
 '4QF12     '    'MS1-qf1:Curr     '     'MS1-qf1:CurrSetpt   '  1   [4  ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qf1,1)
name=qf1{ii,1};     AO.QF1.CommonNames(ii,:)          = name;            
name=qf1{ii,2};     AO.QF1.Monitor.ChannelNames(ii,:) = name; 
name=qf1{ii,3};     AO.QF1.Setpoint.ChannelNames(ii,:)= name;     
val =qf1{ii,4};     AO.QF1.Status(ii,1)               = val;
val =qf1{ii,5};     AO.QF1.DeviceList(ii,:)           = val;
val =qf1{ii,6};     AO.QF1.ElementList(ii,1)          = val;
val =qf1{ii,7};     AO.QF1.Setpoint.Range(ii,:)       = val;
val =qf1{ii,8};    AO.QF1.Setpoint.Tolerance(ii,1)   = val;
val =qf1{ii,9};    AO.QF1.Setpoint.DeltaRespMat(ii,1)= val;
end

% *** QF4 ***
AO.QF4.FamilyName                 = 'QF4';
AO.QF4.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; };

AO.QF4.Monitor.Mode               = Mode;
AO.QF4.Monitor.DataType           = 'Scalar';
AO.QF4.Monitor.Units              = 'Hardware';
AO.QF4.Monitor.HW2PhysicsFcn      = @amp2k;
AO.QF4.Monitor.Physics2HWFcn      = @k2amp;
AO.QF4.Monitor.HWUnits            = 'ampere';           
AO.QF4.Monitor.PhysicsUnits       = 'meter^-2';

AO.QF4.Setpoint.Mode              = Mode;
AO.QF4.Setpoint.DataType          = 'Scalar';
AO.QF4.Setpoint.Units             = 'Hardware';
AO.QF4.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.QF4.Setpoint.Physics2HWFcn     = @k2amp;
AO.QF4.Setpoint.HWUnits           = 'ampere';           
AO.QF4.Setpoint.PhysicsUnits      = 'meter^-2';

%                                                                                                               delta-k
%common                 monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qf4={  
 '1QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '1QF42     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,2]  2         [0 500]  0.050    0.05; ...
 '1QF43     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,3]  3         [0 500]  0.050    0.05; ...
 '1QF44     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,4]  4         [0 500]  0.050    0.05; ...
 '1QF45     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,5]  5         [0 500]  0.050    0.05; ...
 '1QF46     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,6]  6         [0 500]  0.050    0.05; ...
 '1QF47     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,7]  7         [0 500]  0.050    0.05; ...
 '1QF48     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,8]  8         [0 500]  0.050    0.05; ...
 '1QF49     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [1  ,9]  9         [0 500]  0.050    0.05; ...
 '2QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,1]  1         [0 500]  0.050    0.05; ...
 '2QF42     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,2]  2         [0 500]  0.050    0.05; ...
 '2QF43     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,3]  3         [0 500]  0.050    0.05; ...
 '2QF44     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,4]  4         [0 500]  0.050    0.05; ...
 '2QF45     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,5]  5         [0 500]  0.050    0.05; ...
 '2QF46     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,6]  6         [0 500]  0.050    0.05; ...
 '2QF47     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,7]  7         [0 500]  0.050    0.05; ...
 '2QF48     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,8]  8         [0 500]  0.050    0.05; ...
 '2QF49     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [2  ,9]  9         [0 500]  0.050    0.05; ...
 '3QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,1]  1         [0 500]  0.050    0.05; ...
 '3QF42     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,2]  2         [0 500]  0.050    0.05; ...
 '3QF43     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,3]  3         [0 500]  0.050    0.05; ...
 '3QF44     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,4]  4         [0 500]  0.050    0.05; ...
 '3QF45     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,5]  5         [0 500]  0.050    0.05; ...
 '3QF46     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,6]  6         [0 500]  0.050    0.05; ...
 '3QF47     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,7]  7         [0 500]  0.050    0.05; ...
 '3QF48     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,8]  8         [0 500]  0.050    0.05; ...
 '3QF49     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [3  ,9]  9         [0 500]  0.050    0.05; ...
 '4QF41     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,1]  1         [0 500]  0.050    0.05; ...
 '4QF42     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,2]  2         [0 500]  0.050    0.05; ...
 '4QF43     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,3]  3         [0 500]  0.050    0.05; ...
 '4QF44     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,4]  4         [0 500]  0.050    0.05; ...
 '4QF45     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,5]  5         [0 500]  0.050    0.05; ...
 '4QF46     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,6]  6         [0 500]  0.050    0.05; ...
 '4QF47     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,7]  7         [0 500]  0.050    0.05; ...
 '4QF48     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,8]  8         [0 500]  0.050    0.05; ...
 '4QF49     '        'MS1-qf4:Curr     '     'MS1-qf4:CurrSetpt   '  1   [4  ,9]  9         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qf4,1)
name=qf4{ii,1};     AO.QF4.CommonNames(ii,:)          = name;            
name=qf4{ii,2};     AO.QF4.Monitor.ChannelNames(ii,:) = name; 
name=qf4{ii,3};     AO.QF4.Setpoint.ChannelNames(ii,:)= name;     
val =qf4{ii,4};     AO.QF4.Status(ii,1)               = val;
val =qf4{ii,5};     AO.QF4.DeviceList(ii,:)           = val;
val =qf4{ii,6};     AO.QF4.ElementList(ii,1)          = val;
val =qf4{ii,7};     AO.QF4.Setpoint.Range(ii,:)       = val;
val =qf4{ii,8};     AO.QF4.Setpoint.Tolerance(ii,1)   = val;
val =qf4{ii,9};     AO.QF4.Setpoint.DeltaRespMat(ii,1)= val;
end

% *** QD2 ***
AO.QD2.FamilyName                 = 'QD2';
AO.QD2.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet';};

AO.QD2.Monitor.Mode               = Mode;
AO.QD2.Monitor.DataType           = 'Scalar';
AO.QD2.Monitor.Units              = 'Hardware';
AO.QD2.Monitor.HW2PhysicsFcn      = @amp2k;
AO.QD2.Monitor.Physics2HWFcn      = @k2amp;
AO.QD2.Monitor.HWUnits            = 'ampere';           
AO.QD2.Monitor.PhysicsUnits       = 'meter^-2';

AO.QD2.Setpoint.Mode              = Mode;
AO.QD2.Setpoint.DataType          = 'Scalar';
AO.QD2.Setpoint.Units             = 'Hardware';
AO.QD2.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.QD2.Setpoint.Physics2HWFcn     = @k2amp;
AO.QD2.Setpoint.HWUnits           = 'ampere';           
AO.QD2.Setpoint.PhysicsUnits      = 'meter^-2';
   
%                                                                                                               delta-k
%common              monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qd2={  
 '1QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '1QD22     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [1  ,1]  2         [0 500]  0.050    0.05; ...
 '2QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [2  ,1]  3         [0 500]  0.050    0.05; ...
 '2QD22     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [2  ,1]  4         [0 500]  0.050    0.05; ...
 '3QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [3  ,1]  5         [0 500]  0.050    0.05; ...
 '3QD22     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [3  ,1]  6         [0 500]  0.050    0.05; ...
 '4QD21     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [4  ,1]  7         [0 500]  0.050    0.05; ...
 '4QD22     '    'MS1-qd2:Curr     '     'MS1-qd2:CurrSetpt   '  1   [4  ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qd2,1)
name=qd2{ii,1};     AO.QD2.CommonNames(ii,:)          = name;            
name=qd2{ii,2};     AO.QD2.Monitor.ChannelNames(ii,:) = name; 
name=qd2{ii,3};     AO.QD2.Setpoint.ChannelNames(ii,:)= name;     
val =qd2{ii,4};     AO.QD2.Status(ii,1)               = val;
val =qd2{ii,5};     AO.QD2.DeviceList(ii,:)           = val;
val =qd2{ii,6};     AO.QD2.ElementList(ii,1)          = val;
val =qd2{ii,7};     AO.QD2.Setpoint.Range(ii,:)       = val;
val =qd2{ii,8};    AO.QD2.Setpoint.Tolerance(ii,1)   = val;
val =qd2{ii,9};    AO.QD2.Setpoint.DeltaRespMat(ii,1)= val;
end

% *** QD3 ***
AO.QD3.FamilyName                 = 'QD3';
AO.QD3.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'QUAD'; 'Magnet'; 'Tune Corrector';};

AO.QD3.Monitor.Mode               = Mode;
AO.QD3.Monitor.DataType           = 'Scalar';
AO.QD3.Monitor.Units              = 'Hardware';
AO.QD3.Monitor.HW2PhysicsFcn      = @amp2k;
AO.QD3.Monitor.Physics2HWFcn      = @k2amp;
AO.QD3.Monitor.HWUnits            = 'ampere';           
AO.QD3.Monitor.PhysicsUnits       = 'meter^-2';

AO.QD3.Setpoint.Mode              = Mode;
AO.QD3.Setpoint.DataType          = 'Scalar';
AO.QD3.Setpoint.Units             = 'Hardware';
AO.QD3.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.QD3.Setpoint.Physics2HWFcn     = @k2amp;
AO.QD3.Setpoint.HWUnits           = 'ampere';           
AO.QD3.Setpoint.PhysicsUnits      = 'meter^-2';
   
%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
qd3={  
 '1QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '1QD32     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [1  ,1]  2         [0 500]  0.050    0.05; ...
 '2QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [2  ,1]  3         [0 500]  0.050    0.05; ...
 '2QD32     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [2  ,1]  4         [0 500]  0.050    0.05; ...
 '3QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [3  ,1]  5         [0 500]  0.050    0.05; ...
 '3QD32     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [3  ,1]  6         [0 500]  0.050    0.05; ...
 '4QD31     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [4  ,1]  7         [0 500]  0.050    0.05; ...
 '4QD32     '    'MS1-qd3:Curr     '     'MS1-qd3:CurrSetpt   '  1   [4  ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(qd3,1)
name=qd3{ii,1};     AO.QD3.CommonNames(ii,:)          = name;            
name=qd3{ii,2};     AO.QD3.Monitor.ChannelNames(ii,:) = name; 
name=qd3{ii,3};     AO.QD3.Setpoint.ChannelNames(ii,:)= name;     
val =qd3{ii,4};     AO.QD3.Status(ii,1)               = val;
val =qd3{ii,5};     AO.QD3.DeviceList(ii,:)           = val;
val =qd3{ii,6};     AO.QD3.ElementList(ii,1)          = val;
val =qd3{ii,7};     AO.QD3.Setpoint.Range(ii,:)       = val;
val =qd3{ii,8};    AO.QD3.Setpoint.Tolerance(ii,1)   = val;
val =qd3{ii,9};    AO.QD3.Setpoint.DeltaRespMat(ii,1)= val;
end

%===============
%Sextupole data
%===============

% *** SF2 ***
AO.SF2.FamilyName                 = 'SF2';
AO.SF2.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';'Chromaticity Corrector';};

AO.SF2.Monitor.Mode               = Mode;
AO.SF2.Monitor.DataType           = 'Scalar';
AO.SF2.Monitor.Units              = 'Hardware';
AO.SF2.Monitor.HW2PhysicsFcn      = @amp2k;
AO.SF2.Monitor.Physics2HWFcn      = @k2amp;
AO.SF2.Monitor.HWUnits            = 'ampere';           
AO.SF2.Monitor.PhysicsUnits       = 'meter^-2';

AO.SF2.Setpoint.Mode              = Mode;
AO.SF2.Setpoint.DataType          = 'Scalar';
AO.SF2.Setpoint.Units             = 'Hardware';
AO.SF2.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.SF2.Setpoint.Physics2HWFcn     = @k2amp;
AO.SF2.Setpoint.HWUnits           = 'ampere';           
AO.SF2.Setpoint.PhysicsUnits      = 'meter^-2';
   
%                                                                                                               delta-k
%common              monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sf2={  
 '1SF21     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '1SF22     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [1  ,1]  2         [0 500]  0.050    0.05; ...
 '2SF21     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [2  ,1]  3         [0 500]  0.050    0.05; ...
 '2SF22     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [2  ,1]  4         [0 500]  0.050    0.05; ...
 '3SF21     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [3  ,1]  5         [0 500]  0.050    0.05; ...
 '3SF22     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [3  ,1]  6         [0 500]  0.050    0.05; ...
 '4SF21     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [4  ,1]  7         [0 500]  0.050    0.05; ...
 '4SF22     '    'MS1-sf2:Curr     '     'MS1-sf2:CurrSetpt   '  1   [4  ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sf2,1)
name=sf2{ii,1};     AO.SF2.CommonNames(ii,:)          = name;            
name=sf2{ii,2};     AO.SF2.Monitor.ChannelNames(ii,:) = name; 
name=sf2{ii,3};     AO.SF2.Setpoint.ChannelNames(ii,:)= name;     
val =sf2{ii,4};     AO.SF2.Status(ii,1)               = val;
val =sf2{ii,5};     AO.SF2.DeviceList(ii,:)           = val;
val =sf2{ii,6};     AO.SF2.ElementList(ii,1)          = val;
val =sf2{ii,7};     AO.SF2.Setpoint.Range(ii,:)       = val;
val =sf2{ii,8};    AO.SF2.Setpoint.Tolerance(ii,1)   = val;
val =sf2{ii,9};    AO.SF2.Setpoint.DeltaRespMat(ii,1)= val;
end

% *** SD1 ***
AO.SD1.FamilyName                 = 'SD1';
AO.SD1.MemberOf                   = {'MachineConfig'; 'PlotFamily';  'SEXT'; 'Magnet';'Chromaticity Corrector';};

AO.SD1.Monitor.Mode               = Mode;
AO.SD1.Monitor.DataType           = 'Scalar';
AO.SD1.Monitor.Units              = 'Hardware';
AO.SD1.Monitor.HW2PhysicsFcn      = @amp2k;
AO.SD1.Monitor.Physics2HWFcn      = @k2amp;
AO.SD1.Monitor.HWUnits            = 'ampere';           
AO.SD1.Monitor.PhysicsUnits       = 'meter^-2';

AO.SD1.Setpoint.Mode              = Mode;
AO.SD1.Setpoint.DataType          = 'Scalar';
AO.SD1.Setpoint.Units             = 'Hardware';
AO.SD1.Setpoint.HW2PhysicsFcn     = @amp2k;
AO.SD1.Setpoint.Physics2HWFcn     = @k2amp;
AO.SD1.Setpoint.HWUnits           = 'ampere';           
AO.SD1.Setpoint.PhysicsUnits      = 'meter^-2';
   
%                                                                                                               delta-k
%common              monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
sd1={  
 '1SD11     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [1  ,1]  1         [0 500]  0.050    0.05; ...
 '1SD12     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [1  ,1]  2         [0 500]  0.050    0.05; ...
 '2SD11     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [2  ,1]  3         [0 500]  0.050    0.05; ...
 '2SD12     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [2  ,1]  4         [0 500]  0.050    0.05; ...
 '3SD11     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [3  ,1]  5         [0 500]  0.050    0.05; ...
 '3SD12     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [3  ,1]  6         [0 500]  0.050    0.05; ...
 '4SD11     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [4  ,1]  7         [0 500]  0.050    0.05; ...
 '4SD12     '    'MS1-sd1:Curr     '     'MS1-sd1:CurrSetpt   '  1   [4  ,1]  8         [0 500]  0.050    0.05; ...
  };

for ii=1:size(sd1,1)
name=sd1{ii,1};     AO.SD1.CommonNames(ii,:)          = name;            
name=sd1{ii,2};     AO.SD1.Monitor.ChannelNames(ii,:) = name; 
name=sd1{ii,3};     AO.SD1.Setpoint.ChannelNames(ii,:)= name;     
val =sd1{ii,4};     AO.SD1.Status(ii,1)               = val;
val =sd1{ii,5};     AO.SD1.DeviceList(ii,:)           = val;
val =sd1{ii,6};     AO.SD1.ElementList(ii,1)          = val;
val =sd1{ii,7};     AO.SD1.Setpoint.Range(ii,:)       = val;
val =sd1{ii,8};    AO.SD1.Setpoint.Tolerance(ii,1)   = val;
val =sd1{ii,9};    AO.SD1.Setpoint.DeltaRespMat(ii,1)= val;
end

%====
%DCCT
%====
AO.DCCT.FamilyName                     = 'DCCT';
AO.DCCT.MemberOf                       = {'DCCT'};
AO.DCCT.CommonNames                    = 'DCCT';
AO.DCCT.DeviceList                     = [1 1];
AO.DCCT.ElementList                    = [1]';
AO.DCCT.Status                         = AO.DCCT.ElementList;

AO.DCCT.Monitor.Mode                   = Mode;
AO.DCCT.Monitor.DataType               = 'Scalar';
AO.DCCT.Monitor.ChannelNames           = '';    
AO.DCCT.Monitor.Units                  = 'Hardware';
AO.DCCT.Monitor.HWUnits                = 'milli-ampere';           
AO.DCCT.Monitor.PhysicsUnits           = 'ampere';
AO.DCCT.Monitor.HW2PhysicsParams       = 1;          
AO.DCCT.Monitor.Physics2HWParams       = 1;


%====
%KICKER
%====





%============
%RF System
%============
AO.RF.FamilyName                  = 'RF';
AO.RF.MemberOf                    = {'MachineConfig'; 'PlotFamily';  'RF'; 'RFSystem'};
AO.RF.Status                      = 1;
AO.RF.CommonNames                 = 'RF';
AO.RF.DeviceList                  = [1 1];
AO.RF.ElementList                 = [1];

%Frequency Readback
AO.RF.Monitor.Mode                = Mode;
AO.RF.Monitor.DataType            = 'Scalar';
AO.RF.Monitor.Units               = 'Hardware';
AO.RF.Monitor.HW2PhysicsParams    = 1e+6;       %no hw2physics function necessary   
AO.RF.Monitor.Physics2HWParams    = 1e-6;
AO.RF.Monitor.HWUnits             = 'MHz';           
AO.RF.Monitor.PhysicsUnits        = 'Hz';
AO.RF.Monitor.ChannelNames        = '';     

%Frequency Setpoint
AO.RF.Setpoint.Mode               = Mode;
AO.RF.Setpoint.DataType           = 'Scalar';
AO.RF.Setpoint.Units              = 'Hardware';
AO.RF.Setpoint.HW2PhysicsParams   = 1e+6;         
AO.RF.Setpoint.Physics2HWParams   = 1e-6;
AO.RF.Setpoint.HWUnits            = 'MHz';           
AO.RF.Setpoint.PhysicsUnits       = 'Hz';
AO.RF.Setpoint.ChannelNames       = '';     
AO.RF.Setpoint.Range              = [0 Inf];
AO.RF.Setpoint.Tolerance          = 100.0;

%====
%TUNE
%====
AO.TUNE.FamilyName  = 'TUNE';
AO.TUNE.MemberOf    = {'Diagnostics'};
AO.TUNE.CommonNames = ['xtune';'ytune';'stune'];
AO.TUNE.DeviceList  = [ 1 1; 1 2; 1 3];
AO.TUNE.ElementList = [1 2 3]';
AO.TUNE.Status      = [1 1 0]';

AO.TUNE.Monitor.Mode                   = 'Simulator'; 
AO.TUNE.Monitor.DataType               = 'Scalar';
AO.TUNE.Monitor.ChannelNames           = 'MeasTune';
AO.TUNE.Monitor.Units                  = 'Hardware';
AO.TUNE.Monitor.HW2PhysicsParams       = 1;
AO.TUNE.Monitor.Physics2HWParams       = 1;
AO.TUNE.Monitor.HWUnits                = 'fractional tune';           
AO.TUNE.Monitor.PhysicsUnits           = 'fractional tune';

%                                                                                                               delta-k
%common               monitor                setpoint          stat devlist  elem   scalefactor   range   tol  respkick
ScaleFactor = 1.0;
HW2Physics=1.0;
for ii=1:4,
name=sprintf('IK0%d',ii) ;   
    AO.IK.CommonNames(ii,:)          = name;            
name=sprintf('CIK0%d',ii);     
    AO.IK.Monitor.ChannelNames(ii,:) = name; 
name=sprintf('CIK0%d',ii);    
    AO.IK.Setpoint.ChannelNames(ii,:)= name;     
val =1;                        AO.IK.Status(ii,1)               = val;
val =[ii i];                   AO.IK.DeviceList(ii,:)           = val;
val =ii;                       AO.IK.ElementList(ii,1)          = val;
val =[0 5E4];                  AO.IK.Setpoint.Range(ii,:)       = val;
val =5;                       AO.IK.Setpoint.Tolerance(ii,1)   = val;
val =100;                      AO.IK.Setpoint.DeltaRespMat(ii,1)= val;
                               AO.IK.HW2PhysicsParams(ii,:) = ScaleFactor*HW2Physics;
                               AO.IK.Physics2HWParams(ii,:) = ScaleFactor/HW2Physics;
end


% Marker for the id source. Behave like a bpm
% ntxrs=15;
% AO.XRS.FamilyName               = 'XRS';
% AO.XRS.FamilyType               = 'XR';
% AO.XRS.MemberOf                 = {'PlotFamily';  'Diagnostics'};
% AO.XRS.Monitor.Mode             = Mode;
% AO.XRS.Monitor.DataType         = 'Vector';
% AO.XRS.Monitor.DataTypeIndex    = [1:ntxrs];
% AO.XRS.Monitor.Units            = 'Hardware';
% AO.XRS.Monitor.HWUnits          = 'mm';
% AO.XRS.Monitor.PhysicsUnits     = 'meter';
% AO.XRS.Monitor.HW2PhysicsParams = 1e-3;
% AO.XRS.Monitor.Physics2HWParams = 1000;


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode2(1);
AO = getao;



% Response matrix kick size (must be in hardware units)
% Note #1: The AO must be setup for the BEND family for physics2hw to work
% Note #2: This is being done in simulate mode so that the BEND will not be
%          accessed to get the energy.  This can be problem when the BEND is 
%          not online or not at the proper setpoint
setao(AO);

AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', 1e-4, AO.HCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', 1e-4, AO.VCM.DeviceList);

AO.QF1.Setpoint.DeltaRespMat  = physics2hw('QF1', 'Setpoint', AO.QF1.Setpoint.DeltaRespMat,  AO.QF1.DeviceList);
AO.QF4.Setpoint.DeltaRespMat  = physics2hw('QF4', 'Setpoint', AO.QF4.Setpoint.DeltaRespMat,  AO.QF4.DeviceList);
AO.QD2.Setpoint.DeltaRespMat  = physics2hw('QD2', 'Setpoint', AO.QD2.Setpoint.DeltaRespMat,  AO.QD2.DeviceList);
AO.QD3.Setpoint.DeltaRespMat  = physics2hw('QD3', 'Setpoint', AO.QD3.Setpoint.DeltaRespMat,  AO.QD3.DeviceList);

AO.SF2.Setpoint.DeltaRespMat  = physics2hw('SF2', 'Setpoint', AO.SF2.Setpoint.DeltaRespMat,  AO.SF2.DeviceList);
AO.SD1.Setpoint.DeltaRespMat  = physics2hw('SD1', 'Setpoint', AO.SD1.Setpoint.DeltaRespMat,  AO.SD1.DeviceList);

setao(AO);

% reference values
global refOptic;
%disp '    Reference optics, tunes and AO stored in refOptic'
refOptic.AO=getao();
refOptic.twiss=gettwiss();
refOptic.tune= gettune();
