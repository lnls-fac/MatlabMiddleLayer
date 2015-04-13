function [Data, tout, DataTime, ErrorFlag] = readattribute(tangolist, varargin)
%READATTRIBUTE - Reads a list of Tango attributes
%  val = readattribute(tangolist,varargin)
%
%  INPUTS
%  1. tangolist - list of tango attributes
%  2. field (optional) - 'Monitor' for readback value
%                        'Setpoint' for setpoint value
%  3. t - Time vector of when to start taking data (t can not be a cell) {Default: 0}
%
%  OUTPUTS
%  1. Data - readvalue or setvalue
%  2. tout - Local computer timer on finish of data read
%  3. DataTime - Time stamp retrieved from TANGO
%  4. ErrorFlag - Return number of Error (non Valid Tango value)
%
%  NOTES
%  1. default field is 'Monitor'
%  2. For a spectrum returns just first element
%
%  See also writeattribute

%
% Written by Laurent S. Nadolski, SOLEIL, 2004
% 12/12/05 - Modified extra output argument tout
% 28 September 2009 - Add Flag for retry if exception TANGO

% TODO group

t0 = clock;

ErrorFlag = 0;
RetryFlag = 0; % Retry Flag
RetryTime = 1; % Pause between retries
RetryNumber =3; % number of times to try connection

if isempty(varargin)
    field = 'Monitor';
else
    field = varargin{1};
end

if strcmpi(field,'Monitor')
    index = 1;
elseif strcmpi(field,'Setpoint')
    index = 2;
else % Monitor
    index = 1;
end

% look for extra argument
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Retry')
        RetryFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoRetry')
        RetryFlag = 0;
        varargin(i) = [];
    end
end

if length(varargin) >=2
    % Only first sample delay is recognized
    t = varargin{2}(1);
else
    t = 0;
end

T = t - etime(clock,t0);
if T > 0
    pause(T)
end

%% get attribute name
[attribute device]  = getattribute(tangolist);

Data = [];

for k = 1:size(attribute,1)
    [attr_val error] = tango_read_attribute2(device{k}, attribute{k});
    if (error == -1) && RetryFlag
        for ik=1:RetryNumber,
            fprintf('Try %2d Communication issue, pause %f s\n',ik, RetryTime);
            pause(RetryTime);
            [attr_val error] = tango_read_attribute2(device{k}, attribute{k});
            if error ~=-1
                break;
            end
        end
    end

    if error ~= -1
        %% get attribute value
        switch lower(class(attr_val(1).value(index)))
            case 'char'
                Data{k} = attr_val(1).value(:)';
            otherwise
                Data(k) = attr_val(1).value(index);
        end

        %% Get real TANGO time stamp
        DataTime(k,:) = tango_shift_time(attr_val(1).time);

        %% Get Valid field
        if ~strcmpi(attr_val(1).quality_str, 'VALID')
            ErrorFlag = ErrorFlag + 1;
        end
    else
        ErrorFlag = ErrorFlag + 1;
        Data(k) = NaN;
        DataTime(k,:) = tango_shift_time(0);
    end


end

tout = etime(clock,t0);
