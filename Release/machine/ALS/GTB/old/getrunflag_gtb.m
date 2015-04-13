function [RunFlag, Delta, Tol] = getrunflag_gtb(Family, Field, DeviceList)
%GETRUNFLAG_GTB - Returns the run flag for the QF & QD families
% [RunFlag, Delta, Tol] = getrunflag_gtb(Family, Field, DeviceList)
%

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

if nargin < 3
    DeviceList = [];
end

SP_Table = getfamilydata(Family, 'Setpoint', 'SP_Table', DeviceList);
AM_Table = getfamilydata(Family, 'Setpoint', 'AM_Table', DeviceList);

SP  = getpv(Family, 'Setpoint' , DeviceList);
if isempty(SP)
    RunFlag = [];
    Delta = [];
    Tol = [];
    return;
end

AM  = getpv(Family, 'Monitor' , DeviceList);
if isempty(AM)
    RunFlag = [];
    Delta = [];
    return;
end

% The tolerances are stored in the 'Setpoint' field
Tol = family2tol(Family, 'Setpoint', DeviceList);
if isempty(Tol)
    RunFlag = [];
    Delta = [];
    return;
end


% Base runflag on SP-AM
for i = 1:length(SP)
    AMcal(i,1) = interp1(AM_Table(i,:), SP_Table(i,:), AM(i), 'linear', 'extrap');
    Delta(i,1) = SP(i,1) - AMcal(i,1);
    RunFlag(i,1) = abs(Delta(i,1)) > Tol(i);
end


