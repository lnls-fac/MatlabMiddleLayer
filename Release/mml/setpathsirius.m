function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsirius(varargin)
%SETPATHLNLS - Initializes the Matlab Middle Layer (MML) for Brazilian Sources (LNLS1 or SIRIUS)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathlnls(OnlineLinkMethod)
%
%  INPUTS
%  1. Machine - 'LNLS1' {Default}
%  1. OnlineLinkMethod - 'lnls1Link' {Default}

%  Written by Greg Portmann
%             Ximenes.

% Input parsing
if nargin>0
    Machine = varargin{1};
end;
if nargin>1, 
    SubMachine = varargin{2}; 
end;
if nargin>2, 
    LinkFlag = varargin{3}; 
end;

if ~isempty(strfind(SubMachine, 'SI.'))
    MachineType = 'StorageRing';
elseif ~isempty(strfind(SubMachine, 'BO.'))
    MachineType = 'Booster';
elseif ~isempty(strfind(SubMachine, 'TB.'))
    MachineType = 'TransportLine';
elseif ~isempty(strfind(SubMachine, 'TS.'))
    MachineType = 'TransportLine';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, SubMachine, MachineType, LinkFlag);

