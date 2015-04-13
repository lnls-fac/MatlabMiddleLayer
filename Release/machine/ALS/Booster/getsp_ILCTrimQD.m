function [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQD(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQD(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
% The following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe
%

setpv('HN:BR:QDRAQ', 0);
setpv('HN:BR:QDRRQ', 0);
pause(.3);
setpv('HN:BR:QDRRQ', 1);
%pause(2);

tic
for i = 1:100
    %fprintf('HN:BR:QDRAQ = %d, %f\n',getpv('HN:BR:QDRAQ'), toc);
    pause(.1);
    if getpv('HN:BR:QDRAQ') == 1
        break;
    end
end

if getpv('HN:BR:QDRAQ') ~= 1
    error('HN:BR:QDRAQ is not 1');
end

for i = 1:100
    PVnames(i,:) = sprintf('HN:BR:QD%02d', i-1);
end

[AM, tout, DataTime, ErrorFlag] = getpv(PVnames);

setpv('HN:BR:QDRAQ', 0);
setpv('HN:BR:QDRRQ', 0);


% Row vector
AM = AM(:)';
DataTime = DataTime(:)';


% Convert to amps
AM = AM * (1.18 / 10);
