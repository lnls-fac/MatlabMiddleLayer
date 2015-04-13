function [RunFlag, Delta, Tol] = tangogetrunflag(Family, Field, DeviceList)
% function TANGOGETRUNFLAG
%
%
%  NOTES
%  1. This function look at the tango state since if getpv, getam is too fast they return the samme value before the PS
%  start moving!

TangoName = family2tangodev(Family, DeviceList);

% 2. If Field = 'Setpoint', base on SP-AM tolerance
if strcmp(Field, 'Setpoint')
    % Base runflag on abs(Setpoint-Monitor) > Tol
    Tol = family2tol(Family, Field, DeviceList, 'Hardware');
    if isempty(Tol)
        return;
    end

    RunFlag = zeros(size(Tol));
    
    % Check for first power supply still in running state
    for k=1:length(TangoName),
        val = readattribute([TangoName{k} '/State']);
        if val == 10 % running state
            RunFlag(k) = 1;       
        end
    end
    
        % Use the "real" Setpoint value 
    SP  = getpv(Family, 'TangoSetpoint', DeviceList, 'Hardware');    
    
    if isempty(SP)
        return;
    end
    %SP = raw2real(Family, 'Monitor', SP, DeviceList); % Laurent

    % Use the "real" Monitor value 
    AM  = getpv(Family, 'Monitor', DeviceList, 'Hardware');
    if isempty(AM)
        return;
    end
    %AM = raw2real(Family, 'Monitor', AM, DeviceList); % Laurent
    
    % Condition is now Tango Step + Tolerance
    RunFlag = RunFlag | abs(SP-AM) > Tol;

    %fprintf('SP=%f AM=%f\n', SP,AM);
    Delta = SP-AM;

end
