function [Setpoint, Monitor, FileName] = getlattice_als(varargin)
%GETLATTICE_ALS - Get data from a StorageRingOpsData lattice file
%  [ConfigSetpoint, ConfigMonitor, FileName] = getlattice_als(Field1, Field2, ...)
%

DirectoryName = getfamilydata('Directory', 'OpsData');

FileName = menu('Load which lattice?','Production lattice','Injection lattice','Load from file','Exit');

% if isstr(FileName)
%    DirName = [];

if FileName == 1
    fprintf('   Loading production lattice.\n');
    FileName = getfamilydata('OpsData','LatticeFile');

elseif FileName == 2
    fprintf('   Loading injection lattice.\n');
    FileName = getfamilydata('OpsData','InjectionFile');

elseif FileName == 3
    cd(DirectoryName);
    pause(0.01)
    [FileName, DirectoryName] = uigetfile('*Config*.mat', 'Select a configuration file');
    if FileName == 0
        Setpoint = [];
        Monitor = [];
        return
    end

elseif FileName == 4
    Setpoint = [];
    return
else
    error('FileName did not make sense.');
end


load([DirectoryName FileName]);
FileName = [DirectoryName FileName];

if nargin == 0
    Setpoint = ConfigSetpoint;
else
    for i = 1:length(varargin)
        if isfield(ConfigSetpoint, varargin{i})
            Setpoint.(varargin{i}) = ConfigSetpoint.(varargin{i});
        end
    end
end

if nargout >= 2
    if nargin == 0
        Monitor = ConfigMonitor;
    else
        for i = 1:length(varargin)
            if isfield(ConfigMonitor, varargin{i})
                ConfigMonitor.(varargin{i}) = ConfigMonitor.(varargin{i});
            end
        end
    end
end
