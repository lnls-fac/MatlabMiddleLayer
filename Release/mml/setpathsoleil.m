function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsoleil(varargin)
%SETPATHSOLEIL - Initializes the Matlab Middle Layer (MML) for SOLEIL
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathsoleil(SubMachineName)
%
%  INPUTS
%  1. SubMachineName - 'StorageRing', 'Booster', 'LT2', 'LT1'
%
%  See Also setoperationalmode, setpathsoleil, aoinit, soleilinit

%
%  Written by Gregory J. Portmann
%  Adapted by Laurent S. Nadolski

Machine = 'SOLEIL';

%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%

% First strip-out the link method (although it should not be there)
LinkFlag = '';
for i = length(varargin):-1:1
    if ~ischar(varargin{i})
        % Ignore input
    elseif strcmpi(varargin{i},'LabCA')
        LinkFlag = 'LabCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA')
        LinkFlag = 'MCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SCA')
        LinkFlag = 'SCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SLC')
        LinkFlag = 'SLC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Tango')
        LinkFlag = 'Tango';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UCODE')
        LinkFlag = 'UCODE';
        varargin(i) = [];
    end
end

if isempty(LinkFlag)
    LinkFlag = 'Tango';
end


% Get the submachine name
if length(varargin) >= 1
    SubMachineName = varargin{1};
else
    SubMachineName = 'StorageRing';
end

if isempty(SubMachineName)
    SubMachineNameCell = {'LT1', 'Booster', 'LT2', 'Storage Ring'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'SOLEIL', ...
        'ListString', SubMachineNameCell,'ListSize', [160 60]);
    if ok
        SubMachineName = SubMachineNameCell{i};
    else
        fprintf('Initialization cancelled (no path change).\n');
        return;
    end
end

if any(strcmpi(SubMachineName, {'Storage Ring','Ring'}))
    SubMachineName = 'StorageRing';
end

% Common path at SOLEIL
   try
       MMLROOT = getmmlroot;
       [status servername] = system('uname -n');
       if strcmp(servername(1:5), 'metis'),
           addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'CommunHyperion'));
       end
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'naff', 'naffutils'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'naff', 'naffutils', 'touscheklifetime'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'naff', 'nafflib'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'archiving'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'database'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'geophone'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'synchro'));
       addpath(fullfile(MMLROOT, 'mml', 'plotfamily')); % greg version
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'plotfamily'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'configurations'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'cycling'));
       addpath(fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'diag', 'DserverBPM'));
       addpath(fullfile(MMLROOT, 'applications', 'mmlviewer'));
       ToolboxPath = fullfile(MMLROOT, 'machine', 'SOLEIL', 'common', 'toolbox');
       % "inverse" INTERP1
       addpath(fullfile(ToolboxPath, 'findX'))
       % nonlinear optimization toolbox
       addpath(fullfile(ToolboxPath, 'optimize'))
       % FMINSEARCH, but with bound constraints by transformation
       addpath(fullfile(ToolboxPath, 'fminsearchbnd/fminsearchbnd'))
       % FMINSEARCHCON extension of FMINSEARCH
       addpath(fullfile(ToolboxPath, 'FMINSEARCHCON/FMINSEARCHCON'))
       % Integration
       addpath(fullfile(ToolboxPath,'quadgr'))
       addpath(fullfile(ToolboxPath,'gaussquad'))
       % 2 fitting toolbox
       addpath(fullfile(ToolboxPath,'ezyfit/ezyfit'))
       % requiredsymbolic toolbox
       addpath(fullfile(ToolboxPath,'PolyfitnTools/PolyfitnTools'))
       addpath(fullfile(ToolboxPath,'SymbolicPolynomials/SymbolicPolynomials'))
       % chebychev
       addpath(fullfile(ToolboxPath,'chebfun_v2_0501'));
   catch
       disp('Path loading failed');
   end
   
   
if strcmpi(SubMachineName,'StorageRing')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName,'LT1')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'LT1',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName,'Booster')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Booster',     'Booster',     LinkFlag);
elseif strcmpi(SubMachineName,'LT2')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'LT2',         'Transport',   LinkFlag);
else
    error('SubMachineName %s unknown', SubMachineName);
end

try
  %% Proprietes par defauts
    %% Impression
    set(0,'DefaultFigurePaperType','a4');
    set(0,'DefaultFigurePaperUnits','centimeters');
    % commande type pour imprimer
    % print
    % l'imprimante Color
    % print -Pcolor
    % postcript level 2 en couleur
    % print -dps2c -Pcolor

    warning off MATLAB:dispatcher:InexactMatch

    % cycling over 15 different color
    set(0,'DefaultAxesColorOrder',(colordg(1:15)));

    % Global options
    set(0,'DefaultAxesXgrid', 'On');
    set(0,'DefaultAxesYgrid', 'On')

    %format long

    % Repertoire par defaut
    if ispc
        cd(getenv('HOME_OPERATION'));
    else
        % default starting directory
        cd(getenv('HOME'));
    end
    disp('Ready')
catch
    disp('Error')
end
