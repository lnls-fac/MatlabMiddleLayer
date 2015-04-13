function [Setpoint, Monitor, FileName] = getlattice_als(varargin)
%GETLATTICE_ALS - Get data from a StorageRingOpsData lattice file 
%  [ConfigSetpoint, ConfigMonitor, FileName] = getlattice_als(Field1, Field2, ...)
%

DirectoryName = getfamilydata('Directory', 'OpsData');
[FileName, DirectoryName] = uigetfile('*Config*.mat', 'Select a configuration file', DirectoryName);
if FileName == 0
    Setpoint = [];
    Monitor = [];
    return
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
