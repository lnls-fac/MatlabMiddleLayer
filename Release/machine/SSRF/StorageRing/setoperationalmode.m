function setoperationalmode(ModeNumber)
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 3.5 GeV, User Mode
%               2. 3.5 GeV, Model


% To do:
% 1. Golden tune and chromaticity?



global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeCell = {'High Tune', 'Low Tune', 'Model'};
    [ModeNumber, OKFlag] = listdlg('Name','SSRF','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'SSRF';              % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.5;
AD.InjectionEnergy = 3.5;
AD.HarmonicNumber = 720;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 500e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.TuneDelay = 0.0;


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % High Tune
    AD.OperationalMode = '3.5 GeV, High Tune';
    ModeName = 'HighTune';
    OpsFileExtension = '_HighTune';
    
    % AT lattice
    AD.ATModel = 'ssrf_hightune';
    ssrf_hightune;
    
    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.22
        0.32
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];

elseif ModeNumber == 2
    % Low Tune
    AD.OperationalMode = '3.5 GeV, Low Tune';
    ModeName = 'LowTune';
    OpsFileExtension = '_LowTune';
    
    % AT lattice
    AD.ATModel = 'ssrf_lowtune';
    ssrf_lowtune;
    
    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.2213
        0.3196
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

elseif ModeNumber == 3
    % Model mode
    AD.OperationalMode = '3.5 GeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';

    % AT lattice
    AD.ATModel = 'ssrf_hightune';
    ssrf_hightune;

    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.22
        0.32
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

else
    error('Operational mode unknown');
end


% Hardware units
switch2hw;


% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING, length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);
    

% Cavity and radiation
setcavity off; 
setradiation off;  
fprintf('   Radiation and Cavities are off.  Use setcavity/setradiation to modify. \n'); 


% Momentum compaction factor
try
    MCF = getmcf('Model');
    if isnan(MCF)
        AD.MCF = 0.000547;
        fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
    else
        AD.MCF = MCF;
        fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
    end
catch
    AD.MCF = 0.000547;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
end
setad(AD);


% DataRoot Location
% This is a bit of a cluge to know if the user is on the ALS filer
% If so, the location of DataRoot will be different from the middle layer default
if isempty(findstr(lower(MMLROOT),'Some Direcotry at Shanghai'))
    % Keep the normal middle layer directory structure
    switch2sim;
else
    % Local MML
    switch2online;
end


% Final mode changes
if ModeNumber == 1
    % High Tune

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetGains',[LocoFileDirectory,'LOCOData']);
    %setlocodata('LOCO2Model',[LocoFileDirectory,'LOCOData']);
    setlocodata('Nominal');

elseif ModeNumber == 2
    % Low Tune

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetGains',[LocoFileDirectory,'LOCOData']);
    %setlocodata('LOCO2Model',[LocoFileDirectory,'LOCOData']);
    setlocodata('Nominal');

elseif ModeNumber == 3
    % Model Mode
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    setsp('HCM', 0, 'Simulator', 'Physics');
    setsp('VCM', 0, 'Simulator', 'Physics');
end



fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);


