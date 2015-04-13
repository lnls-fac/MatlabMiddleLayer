function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%


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
    ModeNumber = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'CAMD';              % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 1.3;      % make sure this is the same as bend2gev at the production lattice!
AD.InjectionEnergy = 1.3;
AD.HarmonicNumber = 92;

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
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
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = lower(AD.Machine);
if ModeNumber == 1
    % User mode
    AD.OperationalMode = '1.3 GeV';
    ModeName = 'User';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'camdat';
    camdat;

    % Golden TUNE
    AO = getao;
    AO.TUNE.Monitor.Golden = [
    0.1900
    0.2300
        NaN];
    setao(AO);
    
    % Golden chromaticity is in the AD (must be in Physics units!)
    AD.Chromaticity.Golden = [.5; .5];

    % This is a bit of a cluge to know if the user is on the CAMD filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'SomeDirectoryAtCAMD'))
        switch2sim;
    else
        switch2online;
    end
    switch2hw;

else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n'); 


% Momentum compaction factor
MCF = getmcf('Model');
evalin('base','clear LOSSFLAG');  % Calculating mcf puts LOSSFLAG in the workspace
if isnan(MCF)
    AD.MCF = 0.03319680774710;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
% if ModeNumber == 1
%     % 3.0 GeV
%     setlocodata('Nominal');
% else
%     setlocodata('Nominal');
% end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);


