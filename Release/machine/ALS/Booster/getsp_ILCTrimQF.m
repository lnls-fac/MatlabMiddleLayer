function [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQF(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQF(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
% The following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe
%


setpv('HN:BR:QFRAQ', 0);
setpv('HN:BR:QFRRQ', 0);
pause(.3);
setpv('HN:BR:QFRRQ', 1);
%pause(2);


for i = 1:100
    %fprintf('HN:BR:QFRAQ = %d, %f\n',getpv('HN:BR:QFRAQ'), toc);
    pause(.1);
    if getpv('HN:BR:QFRAQ') == 1
        break;
    end
end

if getpv('HN:BR:QFRAQ') ~= 1
    error('HN:BR:QFRAQ is not 1');
end

for i = 1:100
    PVnames(i,:) = sprintf('HN:BR:QF%02d', i-1);
end

[AM, tout, DataTime, ErrorFlag] = getpv(PVnames);

setpv('HN:BR:QFRAQ', 0);
setpv('HN:BR:QFRRQ', 0);


% Row vector
AM = AM(:)';
DataTime = DataTime(:)';


% Convert to amps
AM = AM * (1.36 / 10);


