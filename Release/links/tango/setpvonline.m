function ErrorFlag = setpvonline(TangoNames, NewSP, varargin)
%SETPVONLINE - Set value to online machine
%  ErrorFlag = setpvonline(ChannelNames, NewSP, DataType);
%
%  INPUTS
%  1. TangoNames - Tango attribute names
%  2. NewSP - Setpoint value
%  Optional
%      1. DataType - 'double' or 'string'
%      2. 'Retry' - try several time if tango communication is down
%
%  OUTPUTS
%  1. ErrorFlag
%
% See also getpvonline

%
%  Written for by Laurent S. Nadolski
%  29 Sept. 2009 - Add Retry flag

% TODO group

RetryFlag   = 0; % Retry Flag
RetryTime   = 1; % Pause between retries
RetryNumber = 3; % number of times to try connection


for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Retry')
        RetryFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoRetry')
        RetryFlag = 0;
        varargin(i) = [];
    end
end

if ~exist('TangoNames', 'var') || ~exist('NewSP', 'var')
    error('Must have at least two inputs');
end

if length(varargin) > 2
   if length(varargin) < 2
      DataType = varargin{1};
   end
end

ErrorFlag = 0;

[attribute device]  = getattribute(TangoNames);

for k = 1:size(attribute,1)
    tango_write_attribute2(device{k},attribute{k},NewSP(k));
    ErrorFlag = tango_error;
    %% if error retry several time if RetryFlag is on
    if (ErrorFlag == -1) && RetryFlag
        for ik=1:RetryNumber,
            fprintf('Try %2d Communication issue, pause %f s\n',ik, RetryTime);
            pause(RetryTime);
            tango_write_attribute2(device{k},attribute{k},NewSP(k));
            if ErrorFlag ~=-1
                break;
            end
        end
    end
end    
