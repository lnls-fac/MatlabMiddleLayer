function FileName = mml2caput(Family, Field, Setpoint, DeviceList, FileName, SleepTime, SleepTimeBetweenFamilies)
%MML2CAPUT - Generates a Unix script file to set various EPICS variables
%   mml2caput(Family, Field, Setpoint, DeviceList, FileName, SleepTime)
%
%   INPUTS
%   1. Family
%   2. Field - {Default: 'Setpoint'}
%   3. Setpoint - Value, [], 'Max', or 'Min' {Default: [], the first input ($1)}
%   4. DeviceList
%   5. FileName
%   6. SleepTime - Time to sleep after each caput [seconds]
%
%   OUTPUTS
%   1. FileName
%
%   NOTES
%   1. Family, Field, Setpoint, DeviceList can be cell arrays
%
%   EXAMPLES
%   1. Script to turn on the ID Gap Control
%      >> mml2caput('ID', 'GapEnableControl');
%      Creates a script called ID_GapEnableControl.sh
%      ID_GapEnableControl.sh 1
%      will turn on Enable on the ID gaps
%   2. Script to set all the insertion devices to the maximum
%      >>mml2caput('ID', 'Setpoint', 'max');
%      Creates a script called ID_Setpoint_Max.sh
%

% Written by Greg Portmann


if nargin < 1 || isempty(Family)
    Family = 'ID';
end
if nargin < 2 || isempty(Field)
    Field{1} = '';
end
if nargin < 3 || isempty(Setpoint)
    Setpoint{1} = '';
end
if nargin < 4 || isempty(DeviceList)
    DeviceList{1} = [];
end
if nargin < 5
    FileName = '';
end
if nargin < 6 || isempty(SleepTime)
    SleepTime = 0;
end
if nargin < 7 || isempty(SleepTimeBetweenFamilies)
    SleepTimeBetweenFamilies = 0;
end


% Convert to cells, if not already
if ~iscell(Family)
    Family = mat2cell(Family, 1, size(Family,2));
end
if ~iscell(Field)
    Field = mat2cell(Field, 1, size(Field,2));
end
if ~iscell(Setpoint)
    tmp = Setpoint;
    clear Setpoint
    Setpoint{1} = tmp;
end
if ~iscell(DeviceList)
    tmp = DeviceList;
    clear DeviceList
    DeviceList{1} = tmp;
    %DeviceList = mat2cell(DeviceList, 1, size(DeviceList,2));
    %DeviceList = num2cell(DeviceList,1,2);
end


% Defaults
for i = 1:length(Family)
    if length(Field)<i || isempty(Field{i})
        Field{i} = 'Setpoint';
    end
    if length(DeviceList)<i || isempty(DeviceList{i})
        DeviceList{i} = family2dev(Family{i}, Field{i}, 1, 1);
    end
    if length(Setpoint)<i || isempty(Setpoint{i})
        Setpoint{i} = '$1';
    end
    if isnumeric(Setpoint{i}) && size(Setpoint{i},1)==1
        Setpoint{i} = ones(size(DeviceList{i},1),1) * Setpoint{i};
    end
end


% Max, Min conversions
for i = 1:length(Family)
    if ischar(Setpoint{i}) && strcmpi(Setpoint{i}, 'max')
        Setpoint{i} = maxpv(Family{i}, Field{i}, DeviceList{i});
        MaxFlag{i} = '_Max';
    elseif ischar(Setpoint{i}) && strcmpi(Setpoint{i}, 'min')
        Setpoint{i} = minpv(Family{i}, Field{i}, DeviceList{i});
        MaxFlag{i} = '_Min';
    else
        MaxFlag{i} = '';
    end
end

    
% Build the file name
if isempty(FileName)
    for i = 1:length(Family)
        if i == 1
            FileName = sprintf('%s_%s%s', Family{i}, Field{i}, MaxFlag{i});
        else
            FileName = sprintf('%s_%s_%s%s', FileName, Family{i}, Field{i}, MaxFlag{i});
        end
    end
    FileName = sprintf('%s.sh', FileName);
end


fid = fopen(FileName, 'w', 'b');

% Shell type
fprintf(fid, '#!/bin/sh -f\n\n');


for i = 1:length(Family)
    ChannelNames = family2channel(Family{i}, Field{i}, DeviceList{i});
    
    if ~isempty(ChannelNames)
        if ~iscell(ChannelNames)
            ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
        end
        
        
        for j = 1:length(ChannelNames)
            if ischar(Setpoint{i})
                fprintf(fid, 'caput %s %s\n', ChannelNames{j}, Setpoint{i});
            else
                if rem(Setpoint{i}, 1) == 0
                    fprintf(fid, 'caput %s %d\n', ChannelNames{j}, Setpoint{i}(j));
                else
                    fprintf(fid, 'caput %s %f\n', ChannelNames{j}, Setpoint{i}(j));
                end
            end
            
            if SleepTime > 0
                fprintf(fid, 'sleep %fs\n', SleepTime);
            end
        end
        
        if SleepTimeBetweenFamilies > 0
            fprintf(fid, 'sleep %fs\n', SleepTimeBetweenFamilies);
        end
    end
end

fclose(fid);





% #!/bin/sh
% 
% # Comment
% echo "hello world"
% 
% # Just to print to the screen
% caget ztec:UtilID
% 
% # caput
% caput ztec:UtilReset 1