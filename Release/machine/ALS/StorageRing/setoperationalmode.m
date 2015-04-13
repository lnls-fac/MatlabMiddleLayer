function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 1.9 GeV, Top Off
%               2. 1.9 GeV, Ramping from 1.353 GeV
%               3. 1.9 GeV, Ramping from 1.230 GeV
%               4. 1.9 GeV, High Tune
%               5. 1.9 GeV, Low  Tune
%               6. 1.9 GeV, 2-Bunch
%               7. 1.5 GeV, High Tune
%               8. 1.5 GeV, Isochronous Sections
%               9. 1.5 GeV, Ramping from 1.353 GeV
%             101. 1.9 GeV, Model
%
%             999. Greg's Mode
%            9999. Tom's Mode
%             100. Christoph's Mode
%             200. Walter's Mode
%
%  See also aoinit, updateatindex, alsinit


global THERING

% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeNumber = [];
end
if isempty(ModeNumber)
    ModeCell = {'1.9 GeV, Top Off', '1.9 GeV, Inject at 1.353 GeV', '1.9 GeV, Inject at 1.230 GeV', '1.9 Gev, High Tune', '1.9 Gev, Low Tune', '1.9 Gev, 2-Bunch','1.5 Gev, High Tune', '1.5 GeV, Isochronous Sections', '1.5 GeV, Inject at 1.353 GeV', '1.9 GeV, Model', 'Greg''s Mode', 'Tom''s Mode', 'Christoph''s Mode', 'Walter''s Mode'};
    [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
    if ModeNumber == 10
        ModeNumber = 101;  % Model
    elseif ModeNumber == 11
        ModeNumber = 999;  % Greg
    elseif ModeNumber == 12
        ModeNumber = 9999; % Tom
    elseif ModeNumber == 13
        ModeNumber = 100;  % Christoph
    elseif ModeNumber == 14
        ModeNumber = 200;  % Walter
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'ALS';               % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.HarmonicNumber = 328;
AD.BSCRampRate = 0.8;

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.TuneDelay = 5.0;


% The offset and golden orbits are stored at the end of this file
BuildOffsetAndGoldenOrbits;  % Local function


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;


% Set the status of all the corrector on
% This is needed because some operational modes may have changed the .Status field
%setfamilydata(ones(size(family2dev('HCM',0),1),1),'HCM','Status');   Remove the HCM converted to skew quad before uncommenting this.
%setfamilydata(ones(size(family2dev('VCM',0),1),1),'VCM','Status');

%i = findrowindex([3 10; 5 10; 10 10], HCMlist);
% i = findrowindex([5 10], HCMlist);
% AO.HCM.Status(i) = 0;
% i = findrowindex([10 10], HCMlist);
% AO.HCM.Status(i) = 0;

%i = findrowindex([3 10; 5 10; 10 10], VCMlist);
% i = findrowindex([5 10], VCMlist);
% AO.VCM.Status(i) = 0;
% i = findrowindex([10 10], VCMlist);
% AO.VCM.Status(i) = 0;



%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '1.9 GeV, TopOff';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    ModeName = 'TopOff';
    OpsFileExtension = '_TopOff';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 2
    % High Tune, 1.353 Injection
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.353; %changed during 9-10-07 physics when BR was tuned for higher injection energy - T.Scarvie,C.Steier
    AD.OperationalMode = '1.9 GeV, Inject at 1.353';  % Keep the mode name the same since it's used in srcontrol, etc.
    ModeName = 'HighTune_Inj1p353';
    OpsFileExtension = '_LowEnergyInj';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 3
    % High Tune, 1.23 Injection
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.230;
    AD.OperationalMode = '1.9 GeV, Inject at 1.23';
    ModeName = 'HighTune_Inj1p230';
    OpsFileExtension = '_LowEnergyInj';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix


elseif ModeNumber == 4
    % High Tune, 1.522 Injection
    AD.OperationalMode = '1.9 GeV, High Tune';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'HighTune';
    OpsFileExtension = '_HighTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    %AD.ATModel = 'alslat_122bpmsInQuads';
    %alslat_122bpmsInQuads;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 5
    % 1.9 GeV - Low Tune
    AD.OperationalMode = '1.9 GeV, Low Tune';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'LowTune';
    OpsFileExtension = '_LowTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family (This could have been in alsphysdata)
    % 14.25 / 8.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

elseif ModeNumber == 6
    % 1.9 GeV, 2-Bunch
    AD.OperationalMode = '1.9 GeV, Two-Bunch';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;  %%% changed to 1.522 for use with old BR Bend supply - 3-17-08 - T.Scarvie
%    AD.InjectionEnergy = 1.522;
    %AD.InjectionEnergy = 1.353;
    ModeName = 'TwoBunch';
    OpsFileExtension = '_TwoBunch';
    
    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];  
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [3; 3];

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

elseif ModeNumber == 7
    % 1.5 - High Tune
    AD.OperationalMode = '1.5 GeV, High Tune';
    AD.Energy = 1.522;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    ModeName = '1_5HighTune';
    OpsFileExtension = '_15HighTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Upper';

    switch2hw;

elseif ModeNumber == 8
    % 1.522 GeV, Isochronous Sections
    AD.OperationalMode = '1.5 GeV, Isochronous Sections';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'IsochronousSections';
    OpsFileExtension = '_IsochronousSections';

    if 1
        % AT lattice
        AD.ATModel = 'alslat_isochronous_sections_122bpms';
        alslat_isochronous_sections_122bpms;

        % Golden TUNE is with the TUNE family
        % 8.39 / 7.15
        AO = getao;
        AO.TUNE.Monitor.Golden = [
            0.39
            0.15
            NaN];
        setao(AO);

    else
        AD.ATModel = 'alslat_isochronous_sections_122bpms_2520tune';
        alslat_isochronous_sections_122bpms_2520tune;

        % Golden TUNE is with the TUNE family
        % 8.25 / 7.20
        AO = getao;
        AO.TUNE.Monitor.Golden = [
            0.25
            0.20
            NaN];
        setao(AO);
    end

    AD.Energy = 1.522;
    AD.InjectionEnergy = 1.522;


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];

    % Hysteresis branch
    AD.HysteresisBranch = 'Upper';

    switch2hw;

elseif ModeNumber == 9
    % 1.5 GeV High Tune, 1.353 Injection
    AD.Energy = 1.52322;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.353;
    AD.OperationalMode = '1.5 GeV, Inject at 1.353';
    ModeName = '15_HighTuneLowEnergyInj';
    OpsFileExtension = '_15LowEnergyInj';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

    
elseif ModeNumber == 101
    % Model mode
    AD.OperationalMode = '1.9 GeV, Model';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
    %AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    %alslat_loco_3sb_disp_nuy9_122bpms;

    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms_splitdipole';
    alslat_loco_3sb_disp_nuy9_122bpms_splitdipole;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

elseif ModeNumber == 999
    % Greg's mode
    AD.OperationalMode = '1.9 GeV, Greg Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Greg';
    OpsFileExtension = '';

    % AT lattice
    %AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    %alslat_loco_3sb_disp_nuy9_122bpms;

    AD.ATModel = 'alslat_MultipleRings';
    alslat_MultipleRings(1);  % Concatenation occurs later

    %AD.ATModel = 'alslat_symp_3sb_disp_ID';
    %alslat_symp_3sb_disp_ID

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

    % SP-AM Error level
    % AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
    %                       -1 -> SP-AM errors are Matlab warnings
    %                       -2 -> SP-AM errors prompt a dialog box
    %                       -3 -> SP-AM errors are ignored
    AD.ErrorWarningLevel = 0;

elseif ModeNumber == 9999
    % Tom's mode
    AD.OperationalMode = '1.9 GeV, Tom Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Tom';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

elseif ModeNumber == 100
    % Christoph's mode
    AD.OperationalMode = '1.9 GeV, Christoph Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Christoph';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

elseif ModeNumber == 200
    % Walter's mode

    disp('   This mode switches HCM(5,4) & HCM(6,4) to SQSF(5,1) & SQSF(6,1)');

    AD.OperationalMode = '1.9 GeV, Walter Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Walter';
    OpsFileExtension = '_HighTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];  % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

else
    error('Operational mode unknown');
end



% Set MMLRoot to the standard local path when in standalone mode (must end in a file separator)
% Otherwise it will be set to someplace in the standalone directory location
if isdeployed_local
    if ispc
        AD.MMLRoot = 'N:\';
    else
        AD.MMLRoot = '/home/als/physbase/';
    end
end
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% ALS specific path changes

% Hysteresis loop files
%if any(ModeNumber == 1)     %  2-Bunch on old BR Bend supply
if any(ModeNumber == [1 6])  %  2-Bunch, injecting at 1.9
    % On-energy injection needs a different lattice for magnet cycling
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, 'InjectionConfig_HighTune'];
    AD.HysteresisLoopUpperEnergy = AD.Energy;
    AD.HysteresisLoopLowerEnergy = 1.522;
elseif ModeNumber == 7
    % 1.5 GeV injection needs a different lattice for magnet cycling
    % Hysteresis loop files: 1.5 GeV modes use the 1.9 High Tune upper lattice
    %AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, 'TopOff', filesep, 'GoldenConfig_TopOff'];   % Uses the TopOff mode file
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.InjectionFile];
    AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    AD.HysteresisLoopUpperEnergy = 1.89086196873342;
    AD.HysteresisLoopLowerEnergy = 1.522;
else
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.InjectionFile];
    AD.HysteresisLoopUpperEnergy = AD.Energy;
    AD.HysteresisLoopLowerEnergy = AD.InjectionEnergy;
end

% TFB
AD.OpsData.TFBFile = ['TFBConfig', OpsFileExtension];
AD.Default.TFBArchiveFile = 'TFBConfig';

AD.Default.ChicaneRespFile  = 'ChicaneRespMat'; % File in AD.Directory.BPMResponse    BPM/Chicane response matrice
AD.OpsData.ChicaneRespFile = ['GoldenChicaneResp', OpsFileExtension];
AD.OpsData.RespFiles{length(AD.OpsData.RespFiles)+1} = {[AD.Directory.OpsData, AD.OpsData.ChicaneRespFile]};


% DataRoot Location
% This is a bit of a cluge to know if the user is on the ALS filer
% If so, the location of DataRoot will be different from the middle layer default
if isempty(findstr(lower(MMLROOT),'physbase')) && isempty(findstr(lower(MMLROOT),'n:\'))
    % Keep the normal middle layer directory structure
    switch2sim;

else
    % Use MMLROOT and DataRoot on the ALS filer
    if ispc
        AD.Directory.DataRoot = ['m:\matlab\', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    else
        AD.Directory.DataRoot = ['/home/als/physdata/matlab/', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    end

    % Data Archive Directories
    AD.Directory.BPMData        = [AD.Directory.DataRoot, 'BPM', filesep];
    AD.Directory.TuneData       = [AD.Directory.DataRoot, 'Tune', filesep];
    AD.Directory.ChroData       = [AD.Directory.DataRoot, 'Chromaticity', filesep];
    AD.Directory.DispData       = [AD.Directory.DataRoot, 'Dispersion', filesep];
    AD.Directory.ConfigData     = [AD.Directory.DataRoot, 'MachineConfig', filesep];
    AD.Directory.TFBData        = [AD.Directory.DataRoot, 'TFB', filesep];

    % Response Matrix Directories
    AD.Directory.BPMResponse    = [AD.Directory.DataRoot, 'Response', filesep, 'BPM', filesep];
    AD.Directory.TuneResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Tune', filesep];
    AD.Directory.ChroResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Chromaticity', filesep];
    AD.Directory.DispResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Dispersion', filesep];
    AD.Directory.SkewResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Skew', filesep];
        
    % If using the ALS filer, I'm assuming you want to be online
    switch2online;

    % Change defaults for LabCA if using it
    try
        if exist('lcaSetSeverityWarnLevel','file')
            % read dummy pv to initialize labca
            % ChannelName = family2channel('BPMx');
            % lcaGet(family2channel(ChannelName(1,:));

            % Retry count
            RetryCountNew = 200;  % 599-old labca, 149-labca_2_1_beta
            RetryCount = lcaGetRetryCount;
            lcaSetRetryCount(RetryCountNew);
            if RetryCount ~= RetryCountNew
                fprintf('   Setting LabCA retry count to %d (was %d) (LabCA)\n', RetryCountNew, RetryCount);
            end

            % Timeout
            Timeout = lcaGetTimeout;
            TimeoutNew = .1;  % was .005  Default: .05-old labca, .1-labca_2_1_beta
            lcaSetTimeout(TimeoutNew);
            if abs(Timeout - TimeoutNew) > 1e-5
                fprintf('   Setting LabCA TimeOut to %f (was %f) (LabCA)\n', TimeoutNew, Timeout);
            end
            %fprintf('   LabCA TimeOut = %f\n', Timeout);
            
            % To avoid UDF errors, set the WarnLevel to 4 (Default is 3)
            lcaSetSeverityWarnLevel(4);
            fprintf('   Setting lcaSetSeverityWarnLevel to 4 to avoid annoying UDF errors (LabCA).\n');
        end
    catch
        fprintf('   Error setting lcaSetSeverityWarnLevel (LabCA).\n');
        %fprintf('   LabCA Timeout not set, need to run lcaSetRetryCount(1000), lcaSetTimeout(.01).\n');
    end
end



% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;
setradiation off;
fprintf('   Radiation and cavities are off.  Use setradiation / setcavity to modify. \n');


% Momentum compaction factor
try
    %AD.MCF = 0.00137038;  % was 0.0013884;
    MCF = getmcf('Model');
    if isnan(MCF)
        AD.MCF = 0.00137038;  % was 0.0013884;
        fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
    else
        AD.MCF = MCF;
        fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
    end
catch
    AD.MCF = 0.00137038;  % was 0.0013884;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
end
setad(AD);



% Add Gain & Offsets for magnet family
fprintf('   Magnet gains set based on the production lattice settings.\n');
setgainsandoffsets;



%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if any(ModeNumber == [1 2 3 4])
    % User mode - 1.9 GeV, High Tune

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
    %     'SetGains'   - Set gains/coupling from a LOCO file.
    %     'SetModel'   - Set the model from a LOCO file.  But it only changes
    %                    the part of the model that does not get corrected
    %                    in 'Symmetrize' (also does a SetGains).
    %     'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
    %                    This uses the LOCO AT model!!! And sets all lattice 
    %                    machines fit in the LOCO run to the model.
    %
    % Basically, use 'SetGains' or 'SetModel' if the LOCO run was applied to the accelerator
    %            use 'LOCO2Model' if the LOCO run was made after the final setup

    % Store the LOCO file in the opsdata directory
    %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_1Bend'];
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
    setad(AD);

    try
        %setlocodata('SetGains', AD.OpsData.LOCOFile);
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
        %buildramptable;

        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end

    
elseif ModeNumber == 5
    % 1.9 GeV, Low Tune

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %setlocodata('Nominal');
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetModel',[LocoFileDirectory,'LocoData']);

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    %setsp('HCM',  0, 'Simulator', 'Physics');
    %setsp('VCM',  0, 'Simulator', 'Physics');

elseif ModeNumber == 6
    % 1.9 GeV, 2-Bunch

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Store the LOCO file in the opsdata directory
    %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LocoData_PostSymmetrize'];
    %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_1Bend'];
    %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LocoData'];
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
    
    setad(AD);

    try
        %setlocodata('SetGains', AD.OpsData.LOCOFile);
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
        %buildramptable;

        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end

    
    %buildramptable;

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    %setsp('HCM',  0, 'Simulator', 'Physics');
    %setsp('VCM',  0, 'Simulator', 'Physics');

elseif ModeNumber == 7
    % 1.5 GeV, High Tune
    %SP = getinjectionlattice;
    %SP = rmfield(SP, 'BEND');
    %setmachineconfig(SP, 'Simulator');

    % Set energy in the model
    setenergymodel(1.522);

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    %setsp('HCM', 0, 'Simulator', 'Physics');
    %setsp('VCM', 0, 'Simulator', 'Physics');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
    setad(AD);
    try
        %setlocodata('SetGains', AD.OpsData.LOCOFile);
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
        %buildramptable;

        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end

elseif ModeNumber == 8
    % Isochronous Sections

    % Hysteresis loop files: 1.5 GeV modes use the 1.9 High Tune upper lattice
    AD = getad;
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, 'ALS', filesep, 'StorageRingOpsData', filesep, 'HighTune', filesep, 'GoldenConfig_HighTune'];
    setad(AD);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Change the response matrix kicks

    % Start with nominal gains
    setlocodata('Nominal');

    AO = getao;
    AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .15e-3 / 3 / 1, AO.HCM.DeviceList);
    AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .15e-3 / 3 / 2, AO.VCM.DeviceList);
    %AO.HCM.Setpoint.DeltaRespMat = AO.HCM.Setpoint.DeltaRespMat/4;
    %AO.VCM.Setpoint.DeltaRespMat = AO.VCM.Setpoint.DeltaRespMat/4;
    setao(AO);

    setfamilydata(200e-6,'DeltaRFDisp');


    % Set the gains from LOCO data
    LocoFileDirectory = getfamilydata('Directory','OpsData');
    setlocodata('SetGains',[LocoFileDirectory,'LocoData_IsochronousSections']);

    %     %setenergy(1.522,'Simulator');
    %     %setsp('BEND', gev2bend(1.522), 'Simulator');
    %     SP = getinjectionlattice;
    %     SP = rmfield(SP, 'BEND');

    % Set energy in the model
    setenergymodel(1.522);
    setfamilydata(1.522, 'Energy');

    %     setmachineconfig(SP, 'Simulator');
    %
    %     %setsp('SQSF', 0, 'Simulator', 'Physics');
    %     %setsp('SQSD', 0, 'Simulator', 'Physics');
    %     setsp('HCM', 0, 'Simulator', 'Physics');
    %     setsp('VCM', 0, 'Simulator', 'Physics');

elseif ModeNumber == 101
    % Model mode

    % Activate all HCMs
    Status = getfamilydata('HCM', 'Status');
    setfamilydata(ones(size(Status)), 'HCM', 'Status');

    % Set gains, offsets, and golden values
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    setsp('SQSF', 0, 'Simulator', 'Physics');
    setsp('SQSD', 0, 'Simulator', 'Physics');
    setsp('HCM',  0, 'Simulator', 'Physics');
    setsp('VCM',  0, 'Simulator', 'Physics');

    % Default to simulator mode
    switch2sim;

elseif ModeNumber == 999
    % Greg's mode

    % Calibrate lattice to the 1.9 TopOff loco run (this changes the model, no source points)
    %OpsDataDirectory = getfamilydata('Directory','OpsData');
    %i = strfind(OpsDataDirectory, 'Greg');
    %LOCODirectory = [OpsDataDirectory(1:i(1)-1), 'TopOff', OpsDataDirectory(i(1)+4)];
    %AD.OpsData.LOCOFile = [LOCODirectory, 'LOCO_Production_72SkewQuads_4Bends'];
    %setlocodata('LOCO2Model', AD.OpsData.LOCOFile);

    % For the pseudo single bunch operations, concatenate rings
%    concatenaterings;
    
    % SP = getproductionlattice;
    % SP = rmfield(SP, 'BEND');
    % SP = rmfield(SP, 'RF');
    % SP = rmfield(SP, 'HCMCHICANE');
    % SP = rmfield(SP, 'VCMCHICANE');
    % SP = rmfield(SP, 'HCMCHICANEM');
    % setmachineconfig(SP, 'Simulator');

elseif ModeNumber == 200
    % Walter's mode
    LocoFileDirectory = getfamilydata('Directory','OpsData');
    setlocodata('SetGains',[LocoFileDirectory,'LocoData']);

else
    setlocodata('Nominal');
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetModel',[LocoFileDirectory,'LocoData_PostSymmetrize']);
    %setlocodata('SetModel',[LocoFileDirectory,'LocoData']);
end



% Build a new ramp table to force the present AT-model
% to be matched to the production and injection lattice files
%buildramptable;
fprintf('   Remember to run buildramptable if the production and/or injection\n');
fprintf('   lattice files have changed or if the AT lattice has changed.\n');


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);



function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end



function BuildOffsetAndGoldenOrbits

%  2005-07-27 Changed the [5 11] & [5 12] offset and golden orbits to values during a user run. (GJP)
%             The offsets were zero and the golden values were:
%             5  11   -2.371746    0.318056
%             5  12   -1.915190    0.482681
%
%             The golden orbit agreement with the old middle layer is not as good as
%             it needs to be.  For instance, [6 1] horizontal is .67 new and 1.016 old.
%
%  2006-01-06 New offsets measured.  The large difference in location 4 and 7 is due to new buttons.
%

% Note: you can view this by >> help setoperationalmode>BuildOffsetAndGoldenOrbits

%                          2008-06-04         2007-06-15          2007-01-06         2005-05-12
%      DeviceList          X         Y        X        Y          X        Y         X         Y
Offset = [
    1.0000    2.0000   -0.1198    1.0236   -0.1540    1.0386   -0.3029    0.9601   -0.3332    0.9621
    1.0000    3.0000    0.1969    0.0141   -0.1214   -0.3793   -0.0804   -0.1250   -0.0213   -0.1887
    1.0000    4.0000       NaN   -0.0656    0.1899   -0.2022    0.6410   -0.2695    0.6410   -0.7228
    1.0000    5.0000       NaN       NaN       NaN       NaN   -0.3117    1.2317   -0.3117    1.2317
    1.0000    6.0000       NaN       NaN       NaN       NaN    0.2868    0.1347    0.2868    0.1347
    1.0000    7.0000       NaN    0.0142   -0.0219   -0.0720    0.1294   -0.3856    0.1294    0.2557
    1.0000    8.0000   -0.2819   -0.1573   -0.1808   -0.2673   -0.2606   -0.3423   -0.2235   -0.1922
    1.0000    9.0000    0.2516    0.4336    0.0986    0.2805   -0.0144    0.3451   -0.0639    0.3583
    1.0000   10.0000       NaN       NaN       NaN       NaN    1.4372   -0.1518    1.4372   -0.1518
    2.0000    1.0000       NaN       NaN       NaN       NaN    0.3365    0.0489    0.3365    0.0489
    2.0000    2.0000    0.4304   -0.4414    0.3321   -0.6269    0.3349   -0.4719    0.3029   -0.4988
    2.0000    3.0000    0.4084    0.3753    0.2252    0.2625    0.3260    0.2452    0.2920    0.1946
    2.0000    4.0000       NaN   -0.1013    0.0382   -0.1314    0.3743   -0.1043    0.3743    0.5221
    2.0000    5.0000       NaN       NaN       NaN       NaN   -0.0128   -0.0542   -0.0128   -0.0542
    2.0000    6.0000       NaN       NaN       NaN       NaN    1.0025   -1.0075    1.0025   -1.0075
    2.0000    7.0000       NaN   -0.2359    0.1653   -0.2635   -0.0173   -0.2703   -0.0173    0.5229
    2.0000    8.0000    0.1839   -0.0829    0.0736   -0.3550    0.1902   -0.2211    0.2433   -0.1423
    2.0000    9.0000    0.1371    0.4968   -0.0113    0.3960   -0.2460    0.3486   -0.1620    0.2160
    3.0000    2.0000   -0.1181    0.1733   -0.2045    0.1067   -0.3086    0.0952   -0.2826    0.1080
    3.0000    3.0000    0.4289    0.3250    0.2871    0.2895    0.3677    0.3745    0.3313    0.3497
    3.0000    4.0000       NaN   -0.4011    0.3965   -0.3447   -0.3568   -0.8973   -0.3568    0.2155
    3.0000    5.0000       NaN       NaN       NaN       NaN   -0.0402    0.0603   -0.0402    0.0603
    3.0000    6.0000       NaN       NaN       NaN       NaN    0.2722    0.0824    0.2722    0.0824
    3.0000    7.0000       NaN   -0.1148    0.7024   -0.1234    0.3131   -0.3190    0.3131    0.7647
    3.0000    8.0000   -0.1856    0.4579   -0.0985    0.4559   -0.1004    0.5151    0.0275    0.5267
    3.0000    9.0000    0.3552    0.5019    0.5186   -0.0231    0.4228    0.1727    0.4782    0.0919
    3.0000   10.0000       NaN       NaN       NaN       NaN    0.7001    0.2774    0.7001    0.2774
    3.0000   11.0000       NaN       NaN       NaN       NaN   -0.5243   -0.4578   -0.5243   -0.4578
    3.0000   12.0000       NaN       NaN       NaN       NaN   -0.1391    0.0454   -0.1391    0.0454
    4.0000    1.0000       NaN       NaN       NaN       NaN    0.9000    0.8040    0.9000    0.8040
    4.0000    2.0000   -0.1051    0.9750   -0.2236    0.9806   -0.2389    0.9517   -0.2736    1.0024
    4.0000    3.0000    0.6024   -0.4900    0.6484   -0.3606    0.5399   -0.3708    0.5481   -0.3316
    4.0000    4.0000       NaN    0.4393    0.2514    0.2447   -0.6150    0.4217   -0.6150    0.2945
    4.0000    5.0000   -0.1373   -0.2723   -0.0899   -0.1984    0.1066   -0.1455   -0.1270    0.1668
    4.0000    6.0000    0.9022    0.4704    0.9520    0.3985    1.0549    0.5268    0.8027    0.7899
% 4,5 and 4,6 Bergoz cards swapped several times due to EEBI problems - redid BBA and these are the results - changed goldenorbit values by the deltas in the BBA data - 6-22-08 T.Scarvie
%     4.0000    5.0000    0.0180   -0.1811   -0.0899   -0.1984    0.1066   -0.1455   -0.1270    0.1668
%     4.0000    6.0000    0.9546    0.3564    0.9520    0.3985    1.0549    0.5268    0.8027    0.7899
    4.0000    7.0000       NaN   -0.7539   -0.0272   -0.8070   -0.5092   -0.2730   -0.5092    0.1823
    4.0000    8.0000   -0.5884    0.6205   -0.6642    0.3888   -0.6119    0.6313   -0.4890    0.5291
    4.0000    9.0000   -0.2841   -0.3300   -0.6090   -0.3532   -0.5624   -0.3060   -0.4998   -0.3415
    4.0000   10.0000       NaN       NaN       NaN       NaN   -0.4352    1.3991   -0.4352    1.3991
    5.0000    1.0000       NaN       NaN       NaN       NaN    0.6527    0.2707    0.6527    0.2707
    5.0000    2.0000    0.1048    0.6311   -0.0489    0.6029    0.0368    0.6351   -0.0318    0.6071
    5.0000    3.0000    0.1813    0.5786    0.1164    0.5500    0.2613    0.5279    0.1690    0.4812
    5.0000    4.0000       NaN    0.3754   -0.0824    0.4140   -0.2422    0.1545   -0.2422    0.6403
    5.0000    5.0000       NaN       NaN       NaN       NaN   -0.3649    0.5744   -0.3649    0.5744
    5.0000    6.0000       NaN       NaN       NaN       NaN   -0.3961    0.5409   -0.3961    0.5409
    5.0000    7.0000       NaN   -0.6321   -0.2576   -0.8496    0.1861   -0.6341    0.1861    0.4875
    5.0000    8.0000   -0.5469    0.6792   -0.5953    0.6480   -0.4308    0.6563   -0.4611    0.5928
    5.0000    9.0000    0.3213    0.7955    0.3942    0.7882    0.2031    0.9099    0.4392    0.7018
    5.0000   10.0000       NaN       NaN       NaN       NaN    0.4052    0.9371    0.4052    0.9371
    5.0000   11.0000       NaN       NaN       NaN       NaN    0.2860    0.4667    0.2860    0.4667
    5.0000   12.0000       NaN       NaN       NaN       NaN    0.7625    0.4750    0.7625    0.4750
    6.0000    1.0000       NaN       NaN       NaN       NaN   -0.1765    0.4277   -0.1765    0.4277
    6.0000    2.0000   -0.1161    0.1354       NaN       NaN   -0.5470    0.1162   -0.4925    0.1608
    6.0000    3.0000    0.6536   -0.0736    0.6580   -0.0962    0.5579   -0.0764    0.4926   -0.0228
    6.0000    4.0000       NaN    0.2559    0.0950    0.2593    0.1200    0.1259    0.1200    0.9682  %was 0.9420, 0.4485 - changed 7-30-07 due to changing Bergoz card - T.Scarvie
    6.0000    5.0000       NaN       NaN       NaN       NaN    0.0815   -0.2318    0.0815   -0.2318
    6.0000    6.0000       NaN       NaN       NaN       NaN   -0.5071    0.4360   -0.5071    0.4360
    6.0000    7.0000       NaN   -0.2781    0.3660   -0.1818   -0.0400   -0.3844   -0.0400    0.5079
    6.0000    8.0000    0.1382    0.8562   -0.0038    0.8238    0.0326    0.8366    0.0851    0.7527
    6.0000    9.0000   -0.3015    0.7351   -0.3228    0.6993   -0.3196    0.7598   -0.2962    0.7587
    6.0000   10.0000       NaN       NaN       NaN       NaN    0.4473   -0.1545    0.4473   -0.1545
    7.0000    1.0000       NaN       NaN       NaN       NaN    0.6227    0.3264    0.6227    0.3264
    7.0000    2.0000   -0.0838    0.6303   -0.1331    0.5823   -0.1306    0.5463   -0.1513    0.6347
    7.0000    3.0000    0.3614    0.6868    0.4716    0.6017    0.4098    0.6411    0.2288    0.5024
    7.0000    4.0000       NaN    0.3684   -0.1470    0.3133   -0.2808    0.0358   -0.2808    0.5664
    7.0000    5.0000       NaN       NaN       NaN       NaN    0.2972    0.3924    0.2972    0.3924
    7.0000    6.0000       NaN       NaN       NaN       NaN   -0.1378    0.6702   -0.1378    0.6702
    7.0000    7.0000       NaN    0.6660    0.0756    0.4459    0.0613    0.5088    0.0613    0.8434
    7.0000    8.0000   -0.1009    0.7124   -0.1205    0.6658    0.0291    0.6676   -0.0196    0.6397
    7.0000    9.0000   -1.4026   -0.7524   -1.4073   -0.6661   -1.3782   -0.6406    0.1663    0.8314
    7.0000   10.0000       NaN       NaN       NaN       NaN    0.4593    0.2569    0.4593    0.2569
    8.0000    1.0000       NaN       NaN       NaN       NaN    0.2270    0.4960    0.2270    0.4960
    8.0000    2.0000   -0.0591   -0.0576   -0.1114    0.0405   -0.1231    0.0635   -0.1059    0.0297
    8.0000    3.0000    0.0865    1.2956    0.0862    1.4383    0.2116    1.3395    0.1908    1.0542
    8.0000    4.0000       NaN   -0.2333   -0.8683   -0.1559    0.0812   -0.5635    0.0812    0.6840
    8.0000    5.0000   -0.0904    0.3483   -0.1542    0.3089   -0.1798    0.4131   -0.0830    0.6125
    8.0000    6.0000   -0.1221    0.2915   -0.1743    0.3894   -0.1083    0.3420   -0.2474    0.8791
    8.0000    7.0000       NaN    0.3050    0.6952    0.2835    0.3828    0.0519    0.3828    1.7969
    8.0000    8.0000   -0.1356    1.7784   -0.2045    1.5762   -0.0812    1.6180   -0.0460    1.7202
    8.0000    9.0000   -1.7868   -0.2850   -1.8191   -0.3515   -1.6868   -0.3611   -1.5201   -0.3296
    8.0000   10.0000       NaN       NaN       NaN       NaN    0.5377   -0.0202    0.5377   -0.0202
    9.0000    1.0000       NaN       NaN       NaN       NaN    0.1161   -0.0240    0.1161   -0.0240
    9.0000    2.0000    1.6638    1.2109    1.4939    1.0447    1.7898    1.3374    0.4622    0.0734
    9.0000    3.0000    0.2476    0.5877    0.2326    0.4554    0.4083    0.5453    0.3516    0.4305
    9.0000    4.0000       NaN    0.2286    0.1507    0.1189    0.1929   -0.3953    0.1929   -0.0981
    9.0000    5.0000       NaN       NaN       NaN       NaN   -0.3339    0.0797   -0.3339    0.0797
    9.0000    6.0000       NaN       NaN       NaN       NaN    0.1332   -0.0086    0.1332   -0.0086
    9.0000    7.0000       NaN    0.8753    0.1835    0.6688    0.3534    0.5847    0.3534   -0.0021
    9.0000    8.0000    1.0477    0.2575    0.9189    0.2861    1.0863    0.2838    1.0286    0.2349
    9.0000    9.0000    0.8289    0.2337    0.7994    0.1987    0.9717    0.2159    0.8841    0.3314
    9.0000   10.0000       NaN       NaN       NaN       NaN    0.3272   -0.0581    0.3272   -0.0581
   10.0000    1.0000       NaN       NaN       NaN       NaN    0.4990    0.4044    0.4990    0.4044
   10.0000    2.0000    0.3266   -1.3318    0.2261   -1.3064    0.3332   -1.2594    0.3588   -1.2207
   10.0000    3.0000   -0.1001    0.2217   -0.1474    0.1990   -0.0812    0.2540    0.0714    0.1528
   10.0000    4.0000       NaN    0.0773    0.0750    0.0609   -0.2064    0.1349   -0.2064    0.9781
   10.0000    5.0000       NaN       NaN       NaN       NaN   -0.5240    0.7222   -0.5240    0.7222
   10.0000    6.0000       NaN       NaN       NaN       NaN    0.4499    0.7862    0.4499    0.7862
   10.0000    7.0000       NaN   -0.3604    0.7592   -0.3641    0.3624   -0.2649    0.3624    0.5027
   10.0000    8.0000    0.5101    0.3623    0.5239    0.4681    0.7216    0.4301    0.7240    0.5122
   10.0000    9.0000    0.7365    0.4268    0.7038    0.4284    0.8702    0.4267    0.7826    0.4394
   10.0000   10.0000       NaN       NaN       NaN       NaN    0.4979   -0.1694    0.4979   -0.1694
   10.0000   11.0000       NaN       NaN       NaN       NaN    0.6556   -0.4005    0.6556   -0.4005
   10.0000   12.0000       NaN       NaN       NaN       NaN    0.7335   -0.2444    0.7335   -0.2444
   11.0000    1.0000       NaN       NaN       NaN       NaN    0.6382   -0.2382    0.6382   -0.2382
   11.0000    2.0000    0.8822   -0.1005    0.7680   -0.0261    0.8438   -0.1025    0.8078   -0.1432
   11.0000    3.0000    0.1696    0.8237    0.0039    0.9302    0.1660    0.7432    0.2741    0.7241
   11.0000    4.0000       NaN   -0.6083    0.9590   -0.8161   -0.2598   -0.6969   -0.2598    0.3842
   11.0000    5.0000       NaN       NaN       NaN       NaN    0.0997    0.5364    0.0997    0.5364
   11.0000    6.0000       NaN       NaN       NaN       NaN    0.7115    0.5330    0.7115    0.5330
   11.0000    7.0000       NaN   -0.0158    0.5438   -0.2171    0.5070   -0.2151    0.5070    0.5740
   11.0000    8.0000    0.1566   -0.1658    0.0503   -0.1881   -0.1281   -0.0106   -0.0038   -0.0113
   11.0000    9.0000    0.2368   -0.5027    0.1907   -0.3105    0.0638   -0.5505   -0.0390   -0.5956
   11.0000   10.0000       NaN       NaN       NaN       NaN    0.7015   -0.2305    0.7015   -0.2305
   12.0000    1.0000       NaN       NaN       NaN       NaN   -0.2370   -0.4183   -0.2370   -0.4183
   12.0000    2.0000    0.2487   -1.5517    0.1341   -1.2611    0.1376   -1.0998    0.3036   -1.1286
   12.0000    3.0000    0.3152   -0.0346    0.1835   -0.0610    0.1754    0.0098    0.3032   -0.0342
   12.0000    4.0000       NaN   -1.8415    0.9430   -1.8453   -0.0736   -1.7539   -0.0736   -0.7078
   12.0000    5.0000   -0.5968   -0.6715   -0.7679   -0.6057   -0.6584   -0.5037   -0.6623   -0.1190
   12.0000    6.0000    0.2972   -0.0735    0.3659   -0.0725    0.4741    0.0259    0.2439    0.4729
   12.0000    7.0000       NaN   -0.0741    0.2231   -0.1530   -0.0655   -0.1893   -0.0655   -0.0279
   12.0000    8.0000    0.0701    0.2030   -0.0373   -0.5285    0.0293   -0.1884   -0.0317   -0.1047
   12.0000    9.0000    0.2447   -0.1965    0.2502   -0.2326    0.2470   -0.2015    0.2964   -0.0672
];


% iNoOffset = find(isnan(Offset(:,3)));
% Offset(iNoOffset,3) = Offset(iNoOffset,5);
% 
% iNoOffset = find(isnan(Offset(:,4)));
% Offset(iNoOffset,4) = Offset(iNoOffset,6);


% L = getfamilydata('Circumference');
% figure;
% subplot(2,2,1);
% plot(getspos('BPMx', Offset(:,1:2)), [Offset(:,3) Offset(:,5) Offset(:,7) Offset(:,9)]);
% ylabel('Horizontal [mm]');
% xaxis([0 L]);
% title('BPM Offset');
% 
% subplot(2,2,2);
% plot(getspos('BPMx', Offset(:,1:2)), [Offset(:,3)-Offset(:,5) Offset(:,3)-Offset(:,7) Offset(:,3)-Offset(:,9)]);
% ylabel('Horizontal Difference[mm]');
% xaxis([0 L]);
% title('BPM Offset');
% 
% subplot(2,2,3);
% plot(getspos('BPMy', Offset(:,1:2)), [Offset(:,4) Offset(:,6) Offset(:,8) Offset(:,10)]);
% xlabel('BPM Position [meters]');
% ylabel('Vertical [mm]');
% xaxis([0 L]);
% 
% subplot(2,2,4);
% plot(getspos('BPMy', Offset(:,1:2)), [Offset(:,4)-Offset(:,6) Offset(:,4)-Offset(:,8) Offset(:,4)-Offset(:,10)]);
% xlabel('BPM Position [meters]');
% ylabel('Vertical Difference [mm]');
% xaxis([0 L]);
% 
% addlabel(0,0,'2008-06-04 2007-06-15 2007-01-06 2005-05-12');
% addlabel(1,0,'(2008-06-04)-(2007-06-15)  (2008-06-04)-(2007-01-06)  (2008-06-04)-(2005-05-12');
% orient landscape


% Golden orbit 2008-06-06, Christoph Steier
% Taken at 45 mA, 276 bunches, 1.9 GeV
% Established based on old golden orbit in 78 Bergoz BPMs
% 1.) RF frequency set with 48 horizontal SVs, 92 HCMs, 
%     chicanes at nominal, center chicanes at 0, sum(HCM3456)=0
% 2.) Horizontal orbit correction using 24 SVs, 92 HCMs
% 3.) Vertical orbit correction using 24 SVs, 70 VCMs
%
% Golden orbit 2008-10-05, Christoph Steier
% Is only a small change from the 2008-06-06 orbit
% Basically the orbit was corrected using the 2008-06-06 values
% with the center BPMs and correctors in sector 6 straight removed.

%    1.0000    7.0000   -0.8430    0.0559 %-0.6111    0.0559 % big X discrepancy with new golden orbit

% 4,5 and 4,6 Bergoz cards swapped several times due to EEBI problems - redid BBA and added the deltas to the values - 6-22-08 T.Scarvie
%    4.0000    5.0000   -0.1272-0.155   -0.1849-0.091
%    4.0000    6.0000    0.6381-0.052    0.3711+0.114

%   12.0000    8.0000   -0.0064   -0.5312 %0.5570 %-0.5312 % Y value seems to bounce between these values

%                          2008-10-04           2008-06-06 
%      DeviceList        Xnew      Ynew      Xold      Yold
Golden = [
    1.0000    2.0000   -0.2796    1.1198   -0.2698    1.1241
    1.0000    3.0000   -0.0595    0.0683   -0.0790    0.0106
    1.0000    4.0000   -0.2094    0.1335   -0.2125    0.1385
    1.0000    5.0000   -0.3489    0.6749   -0.3546    0.6540
    1.0000    6.0000   -0.1015    0.0488   -0.0680    0.0648
    1.0000    7.0000   -0.8972    0.0480   -0.8430    0.0559
    1.0000    8.0000   -0.2436   -0.8442   -0.3561   -0.7487
    1.0000    9.0000    0.2577    0.2061    0.2153    0.2220
    1.0000   10.0000    1.4624   -0.1609    1.4477   -0.1685
    2.0000    1.0000    0.1929    0.0611    0.2313    0.0609
    2.0000    2.0000    0.4731   -0.3858    0.4707   -0.3659
    2.0000    3.0000    0.2285    0.3956    0.2248    0.4213
    2.0000    4.0000   -0.5074    0.1097   -0.5078    0.1153
    2.0000    5.0000   -0.0607    0.0252   -0.0698    0.0137
    2.0000    6.0000    0.6728   -0.9578    0.6806   -0.9390
    2.0000    7.0000   -0.5510    0.0029   -0.5443   -0.0119
    2.0000    8.0000    0.1295   -0.2141    0.0879   -0.8827
    2.0000    9.0000    0.1026    0.1205    0.1092    0.1305
    3.0000    2.0000   -0.3024    0.0387   -0.3003    0.0389
    3.0000    3.0000    0.1661    0.0060    0.1228    0.0050
    3.0000    4.0000   -0.1724   -0.1870   -0.1876   -0.1942
    3.0000    5.0000   -0.1831   -0.2794   -0.1697   -0.2784
    3.0000    6.0000   -0.0615   -0.1473   -0.0519   -0.1441
    3.0000    7.0000    0.1384   -0.0235    0.1293   -0.0209
    3.0000    8.0000   -0.2140    0.6375   -0.1385    0.6867
    3.0000    9.0000    0.3063    0.4160    0.3498    0.1526
    3.0000   10.0000    0.7038    0.1916    0.6847    0.1979
    3.0000   11.0000    0.0031   -0.3206    0.0199   -0.3160
    3.0000   12.0000    0.1415    0.0522    0.1433    0.0481
    4.0000    1.0000    0.8316   -0.0334    0.7974   -0.0484
    4.0000    2.0000   -0.1905    0.9802   -0.2596    0.9579
    4.0000    3.0000    0.6917   -0.4980    0.5727   -0.4057
    4.0000    4.0000    0.0684    0.3840    0.0726    0.3972
    4.0000    5.0000   -0.2830   -0.2485   -0.2822   -0.2759
    4.0000    6.0000    0.5761    0.4671    0.5861    0.4851
    4.0000    7.0000   -0.3651   -0.2481   -0.3672   -0.2587
    4.0000    8.0000   -0.6539    0.3237   -0.7147    0.2570
    4.0000    9.0000   -0.6352   -0.3743   -0.6463   -0.3208
    4.0000   10.0000   -0.3679    1.2377   -0.3782    1.2453
    5.0000    1.0000    0.5631    0.1531    0.5509    0.1660
    5.0000    2.0000   -0.1754    0.8318   -0.1352    0.6900
    5.0000    3.0000   -0.0136    0.6049   -0.0510    0.5426
    5.0000    4.0000   -0.6382    0.3337   -0.6381    0.3232
    5.0000    5.0000   -0.2997    0.3487   -0.2983    0.3544
    5.0000    6.0000   -0.9149    0.3383   -0.8903    0.3457
    5.0000    7.0000   -1.4151   -0.3048   -1.4295   -0.3106
    5.0000    8.0000   -0.3189   -0.3706   -0.5638   -0.3560
    5.0000    9.0000    0.9894    0.2480    0.5224    0.3280
    5.0000   10.0000    0.4751    1.5559   -0.0225    1.1575
    5.0000   11.0000    0.7277    1.1314    0.8749    0.5424
    5.0000   12.0000    1.1199    1.1185    1.2474    0.5978
    6.0000    1.0000    1.5486    0.2394    1.2275    0.3050
    6.0000    2.0000    0.4376    0.1821    0.0853    0.1787
    6.0000    3.0000    0.7856   -0.1798    0.6363   -0.1285
    6.0000    4.0000   -0.3247    0.4839   -0.2865    0.4855
    6.0000    5.0000   -0.0241   -0.3958   -0.0298   -0.3940
    6.0000    6.0000   -0.2894    0.1036   -0.3351    0.1130
    6.0000    7.0000   -0.2594    0.1596   -0.2087    0.1530
    6.0000    8.0000   -0.0649    0.5258   -0.0762    0.5145
    6.0000    9.0000   -0.5495    0.6255   -0.5608    0.6311
    6.0000   10.0000    0.4174   -0.3732    0.4130   -0.3652
    7.0000    1.0000    0.7372    0.0473    0.7342    0.0460
    7.0000    2.0000   -0.1030    0.4196   -0.0877    0.4471
    7.0000    3.0000    0.4970    0.1701    0.3266    0.2160
    7.0000    4.0000   -0.6016    0.2874   -0.5939    0.2794
    7.0000    5.0000    0.4168    0.3823    0.4247    0.3857
    7.0000    6.0000   -0.0565    0.7341   -0.0724    0.7366
    7.0000    7.0000   -0.4501    0.6519   -0.4407    0.6546
    7.0000    8.0000   -0.1301    0.8147   -0.1381    0.8414
    7.0000    9.0000   -1.4989   -0.5155   -1.4726   -0.5306
    7.0000   10.0000    0.4954    0.0768    0.5023    0.0809
    8.0000    1.0000    0.2236    0.3399    0.2276    0.3399
    8.0000    2.0000   -0.1319    0.0567   -0.1564    0.0645
    8.0000    3.0000   -0.1516    1.1096   -0.0510    0.9477
    8.0000    4.0000   -1.4478    0.0213   -1.4379    0.0198
    8.0000    5.0000   -0.2844    0.3457   -0.3109    0.3546
    8.0000    6.0000   -0.3246    0.7568   -0.3000    0.7273
    8.0000    7.0000    0.3647    0.3934    0.3486    0.4167
    8.0000    8.0000   -0.2407    1.3982   -0.1866    1.5726
    8.0000    9.0000   -1.6811   -0.2790   -1.6248   -0.2784
    8.0000   10.0000    0.3900   -0.2337    0.3960   -0.2521
    9.0000    1.0000   -0.1760   -0.0426   -0.1688   -0.0355
    9.0000    2.0000    1.4876    1.2695    1.4191    1.2022
    9.0000    3.0000    0.1120    0.6317    0.1168    0.5905
    9.0000    4.0000   -0.3358    0.3754   -0.3440    0.3749
    9.0000    5.0000   -1.1472    0.6727   -1.1510    0.6999
    9.0000    6.0000    0.0512   -0.0585    0.0607   -0.0523
    9.0000    7.0000   -0.4784    0.5318   -0.4851    0.5205
    9.0000    8.0000    0.9689    0.0723    0.8737   -0.0328
    9.0000    9.0000    1.0303    0.1346    0.8248    0.1138
    9.0000   10.0000    0.1344   -0.0468    0.1356   -0.0440
   10.0000    1.0000    0.3482    0.4256    0.3509    0.4234
   10.0000    2.0000    0.2033   -1.2608    0.1175   -1.1726
   10.0000    3.0000   -0.2458    0.1277   -0.2655    0.1351
   10.0000    4.0000   -0.2769    0.3804   -0.2814    0.3859
   10.0000    5.0000   -0.4648    0.4147   -0.4577    0.4111
   10.0000    6.0000   -0.2007    0.2935   -0.2010    0.2960
   10.0000    7.0000   -0.0425   -0.2513   -0.0380   -0.2508
   10.0000    8.0000    0.6061    0.4202    0.5105    0.3316
   10.0000    9.0000    0.8594    0.3760    0.7536    0.3803
   10.0000   10.0000    0.7133   -0.1719    0.7070   -0.1721
   10.0000   11.0000    0.8119   -0.3844    0.8108   -0.3887
   10.0000   12.0000    0.9309   -0.3400    0.9322   -0.3444
   11.0000    1.0000    0.4382   -0.3957    0.4305   -0.3921
   11.0000    2.0000    0.6555   -0.1244    0.4920   -0.1860
   11.0000    3.0000   -0.1454    0.3099   -0.1244    0.3226
   11.0000    4.0000    0.2792   -0.6352    0.2805   -0.6409
   11.0000    5.0000    0.0542    0.2767    0.0525    0.2806
   11.0000    6.0000    0.7388    0.2585    0.7528    0.2589
   11.0000    7.0000    0.2834    0.2345    0.2785    0.2377
   11.0000    8.0000   -0.0787   -0.1026   -0.1528   -0.1111
   11.0000    9.0000    0.1408   -0.2866    0.0737   -0.2000
   11.0000   10.0000    0.6881   -0.0046    0.6842   -0.0023
   12.0000    1.0000   -0.6591   -0.3063   -0.6633   -0.3198
   12.0000    2.0000    0.1305   -1.4056    0.0701   -1.3306
   12.0000    3.0000    0.1560   -0.4228    0.2070   -0.4244
   12.0000    4.0000    0.5121   -1.8153    0.5339   -1.8029
   12.0000    5.0000   -0.6113   -0.4292   -0.6237   -0.4491
   12.0000    6.0000    0.1854    0.1319    0.1815    0.1345
   12.0000    7.0000   -0.3846    0.2937   -0.3709    0.3026
   12.0000    8.0000    0.0258   -0.5402   -0.0064   -0.5312
   12.0000    9.0000    0.3215   -0.2489    0.3139   -0.2543
   ];


%                          2007-06-15           2007-01-06 
%      DeviceList        Xnew      Ynew      Xold      Yold
% Golden = [
%     1.0000    2.0000   -0.1164    1.1118   -0.0905    0.9270
%     1.0000    3.0000   -0.3206   -0.2798   -0.1560   -0.1728
%     1.0000    4.0000   -0.2206    0.1521   -0.0075   -0.0597
%     1.0000    5.0000   -0.3231    0.6461   -0.3723    1.4058
%     1.0000    6.0000    0.0209    0.0860    0.1567    0.3048 % three broken BPM cables fixed 7-23-07 - T.Scarvie Xold=0.0235, Yold=0.0991 
%     1.0000    7.0000   -0.6995    0.0287   -0.3353   -0.0694
%     1.0000    8.0000   -0.2767   -0.7159   -0.3620   -0.4516
%     1.0000    9.0000    0.1418    0.2101    0.2470    0.3653
%     1.0000   10.0000    1.4237   -0.1909    1.4424   -0.2583 % -1.2077, 6.6760 - broken cable fixed 10-30-07 - T.Scarvie
%     2.0000    1.0000    0.1813    0.1247    0.3866   -0.1324
%     2.0000    2.0000    0.3349   -0.5164    0.5617   -0.5684
%     2.0000    3.0000    0.2200    0.4180    0.2629    0.1806
%     2.0000    4.0000   -0.4819    0.0637   -0.1558    0.1406
%     2.0000    5.0000    0.0124   -0.0094   -0.0634    0.1124
%     2.0000    6.0000    0.8025   -0.9006    1.0105   -0.8803 % one broken BPM cable fixed 7-23-07 - T.Scarvie Xold=0.8090, Yold=-1.0049 
%     2.0000    7.0000   -0.4425    0.0289   -0.2299    0.2139
%     2.0000    8.0000    0.0140   -0.5773    0.1148   -0.2362
%     2.0000    9.0000   -0.0024    0.0779   -0.1342    0.0144
%     3.0000    2.0000   -0.1644    0.0590   -0.1886    0.0369
%     3.0000    3.0000    0.1728    0.0144    0.1387    0.1647
%     3.0000    4.0000   -0.2566   -0.1845   -0.0843   -0.3441
%     3.0000    5.0000   -0.2174   -0.2986   -0.1278   -0.1503
%     3.0000    6.0000   -0.0498   -0.1577    0.0638    0.0034
%     3.0000    7.0000    0.1708    0.0183    0.5082   -0.3062
%     3.0000    8.0000   -0.0608    0.7555   -0.1019    0.6271
%     3.0000    9.0000    0.5188   -0.0548    0.4280   -0.0073
%     3.0000   10.0000    0.6894    0.1611    0.6763    0.1403
%     3.0000   11.0000    0.0267   -0.3336    0.0245   -0.4586
%     3.0000   12.0000    0.1506    0.0429    0.1478   -0.0725
%     4.0000    1.0000    0.8131    0.0974    0.7799    0.0331
%     4.0000    2.0000   -0.1926    0.8527   -0.2336    0.9362
%     4.0000    3.0000    0.5383   -0.7841    0.5620   -0.4577
%     4.0000    4.0000    0.1399    0.2569   -0.1769    0.5789
%     4.0000    5.0000   -0.0579   -0.1571    0.1013   -0.0718
%     4.0000    6.0000    0.6869    0.4266    1.0632    0.6690 %was 0.6769, 0.4766 - changed 7-30-07 due to changing Bergoz card - T.Scarvie
%     4.0000    7.0000   -0.3127   -0.1996    0.0751    0.3001
%     4.0000    8.0000   -0.8090    0.2218   -0.6185    0.3929
%     4.0000    9.0000   -0.5722   -0.3312   -0.5918   -0.4112
%     4.0000   10.0000   -0.3650    1.1224   -0.4259    1.2825
%     5.0000    1.0000    0.5914    0.2199    1.0252    0.1134
%     5.0000    2.0000   -0.0654    0.7898    0.1353    0.6211
%     5.0000    3.0000    0.0109    0.6031   -0.0297    0.4792
%     5.0000    4.0000   -0.6197    0.3611   -0.7689    0.3487
%     5.0000    5.0000   -0.2871    0.3102   -0.6357    0.7139
%     5.0000    6.0000   -0.8664    0.2819   -0.2995    0.6825
%     5.0000    7.0000   -1.4360   -0.1984   -0.2062   -0.1643
%     5.0000    8.0000   -0.6783   -0.0500   -0.5811    0.4796
%     5.0000    9.0000    0.4560    0.5540    0.2395    0.7904
%     5.0000   10.0000    0.0030    1.0187   -0.0983    1.1972
%     5.0000   11.0000    0.8074    0.6420    0.3662    0.2982
%     5.0000   12.0000    1.2291    0.6390    0.8378    0.2751
%     6.0000    1.0000    1.2242    0.3311    1.1062    0.3945
%     6.0000    2.0000    0.7337   -0.6179   -0.4532    0.1640
%     6.0000    3.0000    0.6009   -0.1658    0.4640   -0.2254
%     6.0000    4.0000   -0.3989    0.4334    0.0279    0.4018
%     6.0000    5.0000   -0.0950   -0.4062   -0.0122   -0.4458
%     6.0000    6.0000   -0.3644    0.1094   -0.4341    0.3551
%     6.0000    7.0000   -0.3061    0.2173    0.0505    0.0695
%     6.0000    8.0000   -0.0087    0.6355    0.0724    0.6455
%     6.0000    9.0000   -0.3327    0.7777   -0.2040    0.6862
%     6.0000   10.0000    0.4036   -0.4307    0.5751   -0.3754
%     7.0000    1.0000    0.7321    0.0467    0.9940    0.1602
%     7.0000    2.0000   -0.0733    0.4845    0.1602    0.5734
%     7.0000    3.0000    0.3613    0.2853    0.3448    0.5149
%     7.0000    4.0000   -0.5473    0.3019   -0.2024    0.2997
%     7.0000    5.0000    0.4386    0.3786    0.3256    0.4723
%     7.0000    6.0000   -0.1010    0.7061   -0.2265    0.7548
%     7.0000    7.0000   -0.4437    0.6924   -0.2314    0.4434
%     7.0000    8.0000   -0.1459    0.8676    0.0055    0.7587
%     7.0000    9.0000   -1.4295   -0.5051   -1.0471   -0.6419
%     7.0000   10.0000    0.5307    0.0572    0.7784    0.0477
%     8.0000    1.0000    0.1367    0.3429    0.4653    0.3253
%     8.0000    2.0000   -0.1248    0.0356    0.2355    0.0610 %added -0.05mm, 0.05mm vertical bump to BPMs 8,5 and 8,6 so changing golden values to what they read after installing the bump
%     8.0000    3.0000    0.0487    1.1771    0.1225    1.0581
%     8.0000    4.0000   -1.5810    0.0236   -1.2181   -0.2084
%     8.0000    5.0000   -0.3341    0.2598   -0.2268    0.5857
%     8.0000    6.0000   -0.3421    0.7522   -0.1818    0.8391
%     8.0000    7.0000    0.2459    0.4019    0.5672   -0.0758 % 0.3349, 0.3401 - fitting tightened 10-15-07 - T.Scarvie
%     8.0000    8.0000   -0.2651    1.4821   -0.0246    1.6463
%     8.0000    9.0000   -1.8364   -0.3467   -1.5009   -0.4652
% %     8.0000    2.0000   -0.1248    0.1270    0.2355    0.0610
% %     8.0000    3.0000    0.0487    0.9742    0.1225    1.0581
% %     8.0000    4.0000   -1.5810    0.0980   -1.2181   -0.2084
% %     8.0000    5.0000   -0.3341    0.2824   -0.2268    0.5857
% %     8.0000    6.0000   -0.3421    0.7272   -0.1818    0.8391
% %     8.0000    7.0000    0.2459    0.3779    0.5672   -0.0758 % 0.3349, 0.3401 - fitting tightened 10-15-07 - T.Scarvie
% %     8.0000    8.0000   -0.2651    1.4210   -0.0246    1.6463
% %     8.0000    9.0000   -1.8364   -0.4120   -1.5009   -0.4652
%     8.0000   10.0000    0.2715   -0.2286    0.6915   -0.3086
%     9.0000    1.0000   -0.0777   -0.0662    0.3128   -0.0750
%     9.0000    2.0000    1.5025    1.2110    2.0458    1.3817
%     9.0000    3.0000    0.1389    0.5968    0.3151    0.5734
%     9.0000    4.0000   -0.3410    0.3957   -0.1206   -0.2816
%     9.0000    5.0000   -1.1201    0.7091   -0.3879    0.1111 % -1.2782 0.8355 - adjusted golden orbit 10-30-07
%     9.0000    6.0000    0.1340   -0.0589    0.0292   -0.0051
%     9.0000    7.0000   -0.3855    0.4947   -0.3161    0.4980
%     9.0000    8.0000    0.9610    0.0456    1.0139    0.2976
%     9.0000    9.0000    0.7791    0.0588    1.0325    0.3200
%     9.0000   10.0000    0.0948   -0.0164    0.4193   -0.0683
%    10.0000    1.0000    0.3913    0.4174    0.4968    0.1272
%    10.0000    2.0000    0.2516   -1.2953    0.3301   -1.3297
%    10.0000    3.0000   -0.1787    0.2017   -0.2107    0.0034
%    10.0000    4.0000   -0.3542    0.3949   -0.2981    0.6957
%    10.0000    5.0000   -0.5252    0.3975   -0.5290    0.7303
%    10.0000    6.0000   -0.2114    0.3008    0.3664    0.6748
%    10.0000    7.0000   -0.0283   -0.2467    0.4620   -0.1321
%    10.0000    8.0000    0.4726    0.3341    0.6358    0.3907
%    10.0000    9.0000    0.7135    0.3762    0.8666    0.3835
%    10.0000   10.0000    0.6035   -0.1710    0.6846   -0.1846
%    10.0000   11.0000    0.7857   -0.3919    0.7601   -0.3101
%    10.0000   12.0000    0.9208   -0.3487    0.8949   -0.2490
%    11.0000    1.0000    0.5366   -0.4139    0.5186   -0.2121
%    11.0000    2.0000    0.8223   -0.1215    0.8820   -0.0889
%    11.0000    3.0000   -0.0889    0.5780    0.1352    0.5922
%    11.0000    4.0000    0.3019   -0.6016    0.4249   -0.4161
%    11.0000    5.0000    0.0179    0.2657   -0.0124    0.8161
%    11.0000    6.0000    0.6549    0.2317    0.6921    0.6852
%    11.0000    7.0000    0.2079    0.2648    0.0476    0.2143
%    11.0000    8.0000    0.0910   -0.1828   -0.0686   -0.1559
%    11.0000    9.0000    0.2325   -0.0519    0.1918   -0.5955
%    11.0000   10.0000    0.6873   -0.0136    0.7356   -0.3074
%    12.0000    1.0000   -0.6645   -0.3193   -0.3790   -0.4959
%    12.0000    2.0000    0.1340   -1.4477    0.3250   -1.1212
%    12.0000    3.0000    0.1950   -0.4437    0.2516   -0.0820
%    12.0000    4.0000    0.5128   -1.8074    0.5054   -1.7032
%    12.0000    5.0000   -0.5833   -0.4367   -0.6323   -0.2853
%    12.0000    6.0000    0.2588    0.1180    0.2759    0.3523
%    12.0000    7.0000   -0.3140    0.3242   -0.2178    0.0293
%    12.0000    8.0000    0.0463    0.1200    0.0065   -0.9847 %BPM jumped vertically? was 0.0463, -0.8258, changed vert. value 12-10-07 - T.Scarvie
%    12.0000    9.0000    0.2396   -0.2649    0.5101   -0.5973];
%    
% % Bergoz golden orbit set to 2007-12-16 orbit averaged between 2 - 4 am
% BergozGolden = [
%     1.0000    2.0000   -0.1178    1.1221
%     1.0000    4.0000   -0.2270    0.1391
%     1.0000    5.0000   -0.3168    0.6576
%     1.0000    6.0000    0.0121    0.0763
%     1.0000    7.0000   -0.6969    0.0342
% % BPM [1,10] had some problems and seems to have jumped, 2008-1-15
% %    1.0000   10.0000    1.4124   -0.2237
%     1.0000   10.0000    1.5487   -0.1641
%     2.0000    1.0000    0.1803    0.1264
%     2.0000    4.0000   -0.4859    0.0568
%     2.0000    5.0000    0.0200   -0.0020
%     2.0000    6.0000    0.7851   -0.8996
%     2.0000    7.0000   -0.4337    0.0232
%     2.0000    9.0000   -0.0033    0.0792
%     3.0000    2.0000   -0.1657    0.0587
%     3.0000    4.0000   -0.2639   -0.2023
%     3.0000    5.0000   -0.2101   -0.3027
%     3.0000    6.0000   -0.0440   -0.1280
%     3.0000    7.0000    0.1709    0.0082
%     3.0000   10.0000    0.6852    0.1368
%     3.0000   11.0000    0.0334   -0.3083
%     3.0000   12.0000    0.1627    0.0507
%     4.0000    1.0000    0.7974    0.0181
%     4.0000    4.0000    0.1334    0.3599
%     4.0000    5.0000   -0.0467   -0.2683
%     4.0000    6.0000    0.6869    0.4444
%     4.0000    7.0000   -0.3023   -0.1990
%     4.0000   10.0000   -0.3544    1.1508
%     5.0000    1.0000    0.5872    0.2094
%     5.0000    4.0000   -0.6497    0.3132
%     5.0000    5.0000   -0.2850    0.3084
%     5.0000    6.0000   -0.8209    0.3810
%     5.0000    7.0000   -1.4789   -0.2855
%     5.0000   10.0000   -0.0318    1.0489
%     5.0000   11.0000    0.8644    0.6095
%     5.0000   12.0000    1.2483    0.6372
%     6.0000    1.0000    1.1957    0.3338
%     6.0000    4.0000   -0.3648    0.4310
%     6.0000    5.0000   -0.1209   -0.4023
%     6.0000    6.0000   -0.3816    0.1308
%     6.0000    7.0000   -0.2780    0.1936
%     6.0000   10.0000    0.4023   -0.4222
%     7.0000    1.0000    0.7350    0.0439
%     7.0000    4.0000   -0.5645    0.2985
%     7.0000    5.0000    0.4449    0.3702
%     7.0000    6.0000   -0.0724    0.7275
%     7.0000    7.0000   -0.4761    0.6776
%     7.0000   10.0000    0.5281    0.0616
%     8.0000    1.0000    0.1343    0.3420
% %     8.0000    4.0000   -1.5823    0.0894 %added -0.05mm, 0.05mm vertical bump to BPMs 8,5 and 8,6 so changing golden values to what they read after installing the bump
% %     8.0000    5.0000   -0.3486    0.3113
% %     8.0000    6.0000   -0.3241    0.7048
% %     8.0000    7.0000    0.2327    0.3826
%     8.0000    4.0000   -1.5823    0.0242
% %     8.0000    5.0000   -0.3486    0.2605 %SR08 BBPM cables worked on to install top-off interlock chassis - changed offsets to compensate - 4-28-08 T.Scarvie
% %     8.0000    6.0000   -0.3241    0.7534
% %     8.0000    7.0000    0.2327    0.4028
%     8.0000    5.0000   -0.3486-0.025    0.2605+0.063
%     8.0000    6.0000   -0.3241-0.006    0.7534+0.011
%     8.0000    7.0000    0.2327+0.018    0.4028-0.009
%     8.0000   10.0000    0.2725   -0.2297
%     9.0000    1.0000   -0.0764   -0.0691
%     9.0000    4.0000   -0.3521    0.4035
%     9.0000    5.0000   -1.1111    0.7013
%     9.0000    6.0000    0.1360   -0.0595
%     9.0000    7.0000   -0.3983    0.4981
%     9.0000   10.0000    0.0906   -0.0167
%    10.0000    1.0000    0.3926    0.4190
%    10.0000    4.0000   -0.3182    0.3899
%    10.0000    5.0000   -0.5583    0.4006
%    10.0000    6.0000   -0.2338    0.3039
%    10.0000    7.0000   -0.0008   -0.2493
%    10.0000   10.0000    0.5982   -0.1730
%    10.0000   11.0000    0.7891   -0.3890
%    10.0000   12.0000    0.9206   -0.3510
%    11.0000    1.0000    0.5366   -0.4102
%    11.0000    4.0000    0.3036   -0.6124
%    11.0000    5.0000    0.0111    0.2634
%    11.0000    6.0000    0.6587    0.2501
%    11.0000    7.0000    0.2002    0.2541
%    11.0000   10.0000    0.6835   -0.0149
%    12.0000    1.0000   -0.6629   -0.3188
%    12.0000    4.0000    0.5313   -1.8064
%    12.0000    5.0000   -0.5935   -0.4437
%    12.0000    6.0000    0.2372    0.1288
%    12.0000    7.0000   -0.2933    0.3113
%    12.0000    9.0000    0.2369   -0.2565];
%    
% i = findrowindex(BergozGolden(:,1:2), Golden(:,1:2));
% Golden(i,3:4) = BergozGolden(:,3:4);
% 
% Golden = [
%   1   2   -0.040511-0.05    1.006040-0.079 %adjusted values for (1 2,1 5,1 6,1 10,11 10,12 1,11 10,12 1,12 5,12 6,12 9) due to tightening BPM fittings 2-25-07, T.Scarvie
%   1   3   -0.155995   -0.172802
%   1   4   -0.007489   -0.059690
%   1   5   -0.382271+0.01    1.420774-0.015
%   1   6    0.132685+0.024    0.319805-0.015
%   1   7   -0.335328   -0.069386
%   1   8   -0.361984   -0.451644
%   1   9    0.247050    0.365270
%   1  10    1.448368-0.006   -0.186320-0.072
%   2   1    0.386556   -0.132429
%   2   2    0.561730   -0.568448
%   2   3    0.262944    0.180594
%   2   4   -0.155815    0.140550
%   2   5   -0.063373    0.112443
%   2   6    1.010452   -0.880251
%   2   7   -0.229883    0.213915
%   2   8    0.114837   -0.236195
%   2   9   -0.134172    0.014436
%   3   2   -0.188554    0.036926
%   3   3    0.138737    0.164742
%   3   4   -0.084294   -0.344108
%   3   5   -0.127760   -0.150261
%   3   6    0.063810    0.003429
%   3   7    0.508240   -0.306222
%   3   8   -0.101938    0.627142
%   3   9    0.427999   -0.007273
%   3  10    0.676310    0.140286
%   3  11    0.024469   -0.458603
%   3  12    0.147821   -0.072459
%   4   1    0.779875    0.033131
%   4   2   -0.233599    0.936216
%   4   3    0.562033   -0.457749
%   4   4   -0.176911    0.578941
%   4   5    0.101312   -0.071837
%   4   6    1.063168    0.668993
%   4   7    0.075097    0.300069
%   4   8   -0.618454    0.392932
%   4   9   -0.591781   -0.411174
%   4  10   -0.425909    1.282475
%   5   1    1.025209    0.113385
%   5   2    0.135306    0.621053
%   5   3   -0.029729    0.479160
%   5   4   -0.768940    0.348716
%   5   5   -0.635675    0.713942
%   5   6   -0.299507    0.682519
%   5   7   -0.206233   -0.164313
%   5   8   -0.581095    0.479630
%   5   9    0.239507    0.790378
%   5  10   -0.098328    1.197237
%   5  11    0.366152    0.298180
%   5  12    0.837822    0.275068
%   6   1    1.106152    0.394482
%   6   2   -0.453220    0.163968
%   6   3    0.464006   -0.225373
%   6   4    0.027866    0.401828
%   6   5   -0.012178   -0.445797
%   6   6   -0.434149    0.355110
%   6   7    0.050542    0.069546
%   6   8    0.072386    0.645455
%   6   9   -0.204027    0.686178
%   6  10    0.575066   -0.375350
%   7   1    0.993970    0.160223
%   7   2    0.160180    0.573360
%   7   3    0.344765    0.514882
%   7   4   -0.202377    0.299711
%   7   5    0.325589    0.472323
%   7   6   -0.226487    0.754825
%   7   7   -0.231378    0.443379
%   7   8    0.005455    0.758709
%   7   9   -1.047132   -0.641851
%   7  10    0.778378    0.047654
%   8   1    0.465304    0.325339
%   8   2    0.235478    0.060970
%   8   3    0.122504    1.058132
%   8   4   -1.218061   -0.208418
%   8   5   -0.226804    0.585689
%   8   6   -0.181759    0.839125
%   8   7    0.567193   -0.075760
%   8   8   -0.024555    1.646280
%   8   9   -1.500939   -0.465201
%   8  10    0.691539   -0.308552
%   9   1    0.312845   -0.074984
%   9   2    2.045828    1.381672
%   9   3    0.315071    0.573403
%   9   4   -0.120628   -0.281603
%   9   5   -0.387893    0.111066
%   9   6    0.029225   -0.005092
%   9   7   -0.316135    0.498034
%   9   8    1.013853    0.297556
%   9   9    1.032522    0.320033
%   9  10    0.419298   -0.068294
%  10   1    0.496764    0.127194
%  10   2    0.330079   -1.329703
%  10   3   -0.210684    0.003378
%  10   4   -0.298091    0.695728
%  10   5   -0.528987    0.730280
%  10   6    0.366418    0.674756
%  10   7    0.462025   -0.132051
%  10   8    0.635811    0.390677
%  10   9    0.866625    0.383491
%  10  10    0.684558   -0.184594
%  10  11    0.760086   -0.310084
%  10  12    0.894935   -0.249016
%  11   1    0.518637   -0.212083
%  11   2    0.881954   -0.088936
%  11   3    0.135216    0.592178
%  11   4    0.424927   -0.416077
%  11   5   -0.012425    0.816148
%  11   6    0.692062    0.685239
%  11   7    0.047561    0.214277
%  11   8   -0.068567   -0.155911
%  11   9    0.191816   -0.595530
%  11  10    0.770551-0.035   -0.363433+0.056
%  12   1   -0.348044-0.031   -0.484946-0.011
%  12   2    0.324973   -1.121244
%  12   3    0.251555   -0.081986
%  12   4    0.505429   -1.703241
%  12   5   -0.620302-0.012   -0.268309-0.017
%  12   6    0.243871+0.032    0.352266
%  12   7   -0.217819    0.029310
%  12   8    0.006538   -0.9847 %-0.133392 looks like this BPM took a jump - changed value to prevent orbit correction from distorting 12,9 orbit
%  12   9    0.535114-0.025   -0.570344-0.027
%  ];


% Make the offset equal to the golden for BPMs without an offset measurement
Dev = getbpmlist('BPMx','NoXoffset', 'IgnoreStatus');
i = findrowindex(Dev, Offset(:,1:2));
Offset(i,3) = Golden(i,3);

Dev = getbpmlist('BPMy','NoYoffset', 'IgnoreStatus');
i = findrowindex(Dev, Offset(:,1:2));
Offset(i,4) = Golden(i,4);

% Convert NaN to zeroes
Offset(isnan(Offset(:,3)),3) = 0;
Offset(isnan(Offset(:,4)),4) = 0;



% fprintf('%3d %3d  %10.6f  %10.6f\n', [family2dev('BPMx'), getgolden('BPMx'), getgolden('BPMy')]');
% Golden = [
%     1   2   -0.2896      0.9742    %-0.0318      0.5181
%     1   3   -0.152378   -0.241254  %-0.152484   -0.241162
%     1   4    0.579553   -0.643002  % 0.579841   -0.643067
%     1   5   -0.2628      1.1619    %-0.264224    1.161546
%     1   6    0.3215      0.2230    % 0.323280    0.223281
%     1   7    0.083640    0.196757  % 0.082737    0.196420
%     1   8   -0.368952   -0.196831  %-0.368819   -0.196855
%     1   9   -0.003805    0.407082  %-0.003357    0.406456
%     1  10    1.3079     -0.1676    % 1.309478   -0.167377
%     2   1    0.1588      0.1513    % 0.160261    0.151036
%     2   2    0.344356   -0.520547  % 0.345754   -0.518623
%     2   3    0.187703    0.164975  % 0.187703    0.166062
%     2   4    0.352522    0.222951  % 0.351916    0.223096
%     2   5   -0.0208      0.1188    %-0.019400    0.119447
%     2   6    1.0050     -0.9880    % 1.007835   -0.988796
%     2   7   -0.030978    0.423587  %-0.030932    0.423312
%     2   8    0.133789   -0.6375    % 0.133789   -0.027414  % 0.135450   -0.027403
%     2   9   -0.2203     -0.1107    %-0.1255     -0.0075
%     3   2   -0.2273      0.1911    %-0.2273      0.1911
%     3   3    0.165441    0.436316  % 0.165322    0.434830
%     3   4   -0.343977    0.091995  %-0.344303    0.091896
%     3   5    0.0739     -0.0736    %-0.051844   -0.073605
%     3   6    0.2514      0.0204    % 0.6153      0.1983    % 0.614787    0.197967
%     3   7    0.304507    0.697537  % 0.305512    0.697387
%     3   8   -0.069038    0.528654  %-0.069111    0.528689
%     3   9    0.517497    0.228419  % 0.516663    0.229043
%     3  10    0.7444      0.2539    % 0.744410    0.253550
%     3  11    0.0840     -0.3383    % 0.082091   -0.337858
%     3  12    0.2215      0.0236    % 0.3156     -0.1570    % 0.313468   -0.156351
%     4   1    0.8042      0.2195    % 0.803902    0.219844
%     4   2   -0.240661    0.988501  %-0.242393    0.988339
%     4   3    0.454354   -0.226890  % 0.453473   -0.226213
%     4   4   -0.601477    0.102367  %-0.602129    0.102499
%     4   5   -0.2014     -0.0041    %-0.202549   -0.004284
%     4   6    0.8830      0.7256    % 0.882781    0.725510
%     4   7   -0.387219    0.086077  %-0.587016    0.426245
%     4   8   -0.545459    0.480851  %-0.547100    0.420096
%     4   9   -0.479635   -0.288631  %-0.480664   -0.288543
%     4  10   -0.4402      1.3105    %-0.440489    1.310593
%     5   1    0.8685      0.1611    % 0.868568    0.161346
%     5   2    0.021439    0.674611  % 0.021244    0.674683
%     5   3    0.047640    0.440063  % 0.047743    0.439180
%     5   4    0.190253    0.186037  % 0.190435    0.186583
%     5   5   -0.3593      0.5678    %-0.359901    0.567948
%     5   6   -0.3847      0.5690    %-0.383517    0.569024
%     5   7    0.171261    0.457279  % 0.170336    0.455384
%     5   8   -0.519706    0.591800  %-0.519345    0.591021
%     5   9    0.465190    0.700225  % 0.465078    0.700237
%     5  10   -0.2465      1.3429    %-0.2465      1.3429
%     5  11    0.2855      0.4594    % 0.2855      0.4594
%     5  12    0.7634      0.4516    % 0.7634      0.4516
%     6   1    1.0160      0.5698    % 1.0160      0.5698
%     6   2   -0.476022    0.231231  %-0.472465    0.231270
%     6   3    0.397318    0.004102  % 0.398645    0.004417
%     6   4    0.094072    0.862693  % 0.093460    0.862800
%     6   5    0.0295     -0.2916    % 0.030714   -0.291520
%     6   6   -0.4953      0.4451    %-0.494434    0.445159
%     6   7   -0.089162    0.484128  %-0.089119    0.484474
%     6   8    0.019608    0.759533  % 0.020663    0.759064
%     6   9   -0.271687    0.768308  %-0.269637    0.767830
%     6  10    0.4992     -0.4132    % 0.4992     -0.4132
%     7   1    0.6804      0.2674    % 0.681440    0.267552
%     7   2   -0.159098    0.658741  %-0.158171    0.658387
%     7   3    0.228716    0.502839  % 0.228906    0.502007
%     7   4   -0.295639    0.529897  %-0.295833    0.528664
%     7   5    0.3000      0.3931    % 0.300789    0.393356
%     7   6   -0.1463      0.6520    %-0.146880    0.651975
%     7   7    0.060125    0.793967  % 0.060168    0.794162
%     7   8   -0.086876    0.650777  %-0.087694    0.650625
%     7   9   -1.325525   -0.647836  %-0.0869      0.6508
%     7  10    0.4586      0.0892    % 0.458855    0.089469
%     8   1    0.1198      0.3707    % 0.119673    0.370762
%     8   2   -0.050046    0.096356  %-0.053612    0.096084
%     8   3    0.073770    0.994688  % 0.071804    0.994555
%     8   4    0.080614    0.692844  % 0.080223    0.692561
%     8   5   -0.0318      0.5181    %-0.083167    0.645776
%     8   6   -0.2839      0.9567    %-0.284171    0.956662
%     8   7    0.391907    1.953947  % 0.391689    1.951550
%     8   8   -0.140246    1.639606  %-0.140449    1.639649
%     8   9   -1.502310   -0.207432  %-1.504134   -0.207754
%     8  10    0.6255     -0.1201    % 0.625154   -0.120320
%     9   1    0.1121     -0.0814    % 0.111942   -0.081206
%     9   2    1.786463    1.335916  % 1.8313      1.3063
%     9   3    0.215602    0.387373  % 0.214896    0.387126
%     9   4    0.158785   -0.031891  % 0.159954   -0.031512
%     9   5   -0.3181      0.0526    %-0.318482    0.051950
%     9   6    0.1714     -0.0078    % 0.172962   -0.007577
%     9   7    0.316691   -0.006804  % 0.316407   -0.006569
%     9   8    0.880731    0.214732  % 0.880147    0.215338
%     9   9    0.949231    0.310896  % 0.950156    0.311014
%     9  10    0.2967     -0.0239    % 0.2967     -0.0239
%     10   1    0.5232      0.1526    % 0.523894    0.152474
%     10   2    0.437599   -1.142640  % 0.439782   -1.142138
%     10   3   -0.113803    0.135020  %-0.113791    0.135007
%     10   4   -0.199668    0.928557  %-0.199348    0.928702
%     10   5   -0.5163      0.7165    %-0.514913    0.715788
%     10   6    0.4600      0.7018    % 0.461318    0.702045
%     10   7    0.344444    0.464383  % 0.344225    0.464196
%     10   8    0.634820    0.560750  % 0.638157    0.563323
%     10   9    0.829263    0.420337  % 0.828490    0.420643
%     10  10    0.6593     -0.0171    % 0.659822   -0.017003
%     10  11    0.6464     -0.1530    % 0.647259   -0.152731
%     10  12    0.7818     -0.0988    % 0.782518   -0.098612
%     11   1    0.5147     -0.0634    % 0.515164   -0.063664
%     11   2    0.865802   -0.047039  % 0.865700   -0.047061
%     11   3    0.129104    0.657485  % 0.129908    0.656617
%     11   4   -0.245201    0.492669  %-0.246788    0.492489
%     11   5    0.0853      0.7688    % 0.0853      0.5688 % Y raised when fittings were tightened    % 0.086654    0.568875
%     11   6    0.7299      0.5752    % 0.729126    0.575185
%     11   7    0.488272    0.561293  % 0.489058    0.561000
%     11   8   -0.123974   -0.074137  %-0.124343   -0.072658
%     11   9    0.009679   -0.533941  % 0.010739   -0.533760
%     11  10    0.6304     -0.2759    % 0.630879   -0.275475
%     12   1   -0.3235     -0.3509    %-0.323108   -0.351090
%     12   2    0.315783   -1.050641  % 0.312953   -1.050924
%     12   3    0.262078   -0.018282  % 0.261234   -0.018941
%     12   4   -0.169038   -0.768199  %-0.168877   -0.767095
%     12   5   -0.6095     -0.2389    %-0.610702   -0.238594
%     12   6    0.2802      0.4385    % 0.279390    0.438482
%     12   7   -0.146203   -0.021551  %-0.146113   -0.020954
%     12   8   -0.133978   -0.059753  %-0.134942   -0.059710
%     12   9    0.3541     -0.1237
%     ];


% Save the data
AO = getao;


% Offset orbits
[i, iNotFound, iFoundList] = findrowindex(Offset(:,1:2), AO.BPMx.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMx offsets are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMx.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the offsets in the BPMx family are being specified (setoperationalmode)\n');
end
AO.BPMx.Offset = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Offset(i) = Offset(iFoundList,3);

[i, iNotFound, iFoundList] = findrowindex(Offset(:,1:2), AO.BPMy.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMy offsets are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMy.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the offsets in the BPMy family are being specified (setoperationalmode)\n');
end
AO.BPMy.Offset = zeros(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Offset(i) = Offset(iFoundList,4);


% Golden orbits
[i, iNotFound, iFoundList] = findrowindex(Golden(:,1:2), AO.BPMx.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMx golden values are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMx.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the golden orbits in the BPMx family are being specified (setoperationalmode)\n');
end
AO.BPMx.Golden = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Golden(i) = Golden(iFoundList,3);

[i, iNotFound, iFoundList] = findrowindex(Golden(:,1:2), AO.BPMy.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMy golden values are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMy.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the golden orbits in the BPMy family are being specified (setoperationalmode)\n');
end
AO.BPMy.Golden = zeros(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Golden(i) = Golden(iFoundList,4);

setao(AO);
