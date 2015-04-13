function  [xmax, ymax, TitleBar]= mml2edm(Family, varargin)

if nargin < 1
    error('Family input must exist');
end

% Initialize
OnSleepTime = .1;
xBorder = 3;
yBorder = 2;
yHeight = 20;

BMWidth = 30;
BCWidth = 70;
MonitorWidth = 70;
ControlWidth = 70;

CommonNameWidth = [];

% Inputs and defaults
TitleBar = '';
TableTitle = '';
FileName = '';
Fields = '';
BC_SetAllButton = 'On';
SP_SetAllButton = 'On';
WindowLocation = [60 60];
AppendFlag = 0;
xStart = 0;
yStart = 0;
EyeAide = 'Off';
MotifWidget = '';
HorizontalAlignment = 'right';  % 'left', 'center', 'right'
Precision = 3; 
FieldLength = [];
DeviceList = [];

for i = length(varargin):-1:1
    if ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'TitleBar')
            TitleBar = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'TableTitle')
            TableTitle = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Fields')
            Fields = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'BC_SetAllButton')
            BC_SetAllButton = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'SP_SetAllButton')
            SP_SetAllButton = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'EyeAide')
            EyeAide = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'MotifWidget')
            MotifWidget = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'WindowLocation')
            WindowLocation = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Append')
            AppendFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'CommonNameWidth')
            CommonNameWidth = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'xStart')
            xStart = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'yStart')
            yStart = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontSize')
            FontSize = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontWeight')
            FontWeight = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontName')
            FontName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'HorizontalAlignment')
            HorizontalAlignment = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Precision')
            Precision = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FieldLength')
            FieldLength = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'DeviceList')
            DeviceList = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end

if isempty(FileName)
    FileName = sprintf('MML2EDM_%s.edl', Family);
end
if isempty(TitleBar)
    TitleBar = Family;
end
if isempty(TitleBar)
    TableTitle = Family;
end


[FamilyFlag, AOStruct] = isfamily(Family);
if ~FamilyFlag
    disp('   Not a family.');
    return
end

if isempty(DeviceList)
    DeviceList = family2dev(Family, 1, 1);
end

CommonNames = family2common(Family, DeviceList);
L = size(CommonNames,2);
CommonNames = deblank(mat2cell(CommonNames, ones(1,size(CommonNames,1)),size(CommonNames,2)));

if isempty(CommonNameWidth)
    CommonNameWidth = 9*L;
end


[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation);


if AppendFlag
    fid = fopen(FileName, 'r+', 'b');
    status = fseek(fid, 0, 'eof');
else
    fid = fopen(FileName, 'w', 'b');
    WriteEDMFile(fid, Header);
end


if isempty(Fields)
    if any(strcmpi(Family, {'HCM','VCM'}))
        Fields = {
            'Monitor'
            'Setpoint'
            'Trim'
            'FF1'
            'FF2'
            %'FFMultiplier'
            'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            'Reset'
            };
        
    elseif any(strcmpi(Family, {'QF','QD'}))
        Fields = {
            'Monitor'
            'Setpoint'
            'FF'
            %'FFMultiplier'
            %'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            'Reset'
            };
        
    elseif any(strcmpi(Family, {'QFA','QDA','Q'}))
        Fields = {
            'Monitor'
            'Setpoint'
            %'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            'Reset'
            };
        
    elseif any(strcmpi(Family, {'SQSF','SQSD'}))
        Fields = {
            'Monitor'
            'Setpoint'
            %'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            'Reset'
            };
        
    elseif any(strcmpi(Family, {'BEND','SF','SD'}))
        Fields = {
            'Monitor'
            'Setpoint'
            %'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            'Reset'
            };
    elseif any(strcmpi(Family, {'SOL'}))
        Fields = {
            'Monitor'
            'Setpoint'
            'On1'
            'On2'
            'OnControl'
            };
    end
end

if isempty(Fields)
    Fields = fieldnames(AOStruct);
end

% Initialize
xStart = xStart + xBorder;
yStart = yStart + yBorder;
x = xStart;
y = yStart + 30;  % Leave room for a title
yTable = y;

xmax = x;
ymax = y;


% First lay down the lines (or rectangles)
if strcmpi(EyeAide, 'On')
    yTmp = y;
    Width = CommonNameWidth + xBorder;
    % Need the total Width
    for j = 1:length(Fields)
        if isfield(AOStruct,Fields{j}) && isfield(AOStruct.(Fields{j}),'MemberOf') && isfield(AOStruct.(Fields{j}),'ChannelNames') && ~isempty(AOStruct.(Fields{j}).ChannelNames)
            if ismemberof(Family, Fields{j},'Boolean Monitor') || ismemberof(Family, Fields{j},'BooleanMonitor')
                % Boolean Monitor
                Width = Width + BMWidth + xBorder;
            elseif ismemberof(Family, Fields{j},'Boolean Control') || ismemberof(Family, Fields{j},'BooleanControl')
                % Boolean Control
                Width = Width + BCWidth + xBorder;
            elseif ismemberof(Family, Fields{j},'Monitor')
                % Monitor
                Width = Width + MonitorWidth + xBorder;
            else
                % Control
                Width = Width + ControlWidth + xBorder;
            end
        end
    end
    %Width = Width + 2*xBorder;
    
    for i = 1:length(CommonNames)+1
        y = y + yHeight + yBorder;
        EDMLine([x x+Width], [y-round(yBorder/2) y-round(yBorder/2)], 'FileName', fid, 'Width', Width, 'Height', 0, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %if rem(i,2) == 1
        %    EDMRectangle(x, y, 'FileName', fid, 'Width', Width, 'Height', yHeight, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %end
    end
    y = yTmp;
end


% Common name column
WriteEDMFile(fid, EDMStaticText('Name', x, y));
y = y + yHeight + yBorder;
for i = 1:length(CommonNames)
    if ~isempty(CommonNames{i})
        WriteEDMFile(fid, EDMStaticText(CommonNames{i}, x, y, 'HorizontalAlignment', 'left', 'Width', CommonNameWidth));
    end
    y = y + yHeight + yBorder;
end
x = x + CommonNameWidth + xBorder;
y = yTable;


for j = 1:length(Fields)
    % Is it a "real" field
    if isfield(AOStruct,Fields{j}) && isfield(AOStruct.(Fields{j}),'MemberOf') && isfield(AOStruct.(Fields{j}),'ChannelNames') && ~isempty(AOStruct.(Fields{j}).ChannelNames)
        %ColumnNames = sprintf('%s', Fields{j});
        
        PVCell = family2channel(Family, Fields{j}, DeviceList);
        %PVCell = AOStruct.(Fields{j}).ChannelNames;
        %PVCell = unique(PVCell, 'rows');
        
        if ~iscell(PVCell)
            PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
        end
        
        % Column header
        %if ismemberof(Family, Fields{j},'Boolean Monitor') || ismemberof(Family, Fields{j},'BooleanMonitor')
        %    WriteEDMFile(fid, EDMStaticText(Fields{j}, x, y, 'HorizontalAlignment', 'left'));
        %else
        %    WriteEDMFile(fid, EDMStaticText(Fields{j}, x, y, 'HorizontalAlignment', 'center'));
        %end       
        %y = y + yHeight + yBorder;
        
        if ismemberof(Family, Fields{j},'Boolean Monitor') || ismemberof(Family, Fields{j},'BooleanMonitor')
            % Boolean Monitor
            if strcmpi(Fields{j},'Ready')
                HeaderName = 'Rdy';
            else
                HeaderName = Fields{j};
            end
            WriteEDMFile(fid, EDMStaticText(HeaderName, x-3, y, 'Width', BMWidth+6, 'HorizontalAlignment', 'center'));
            y = y + yHeight + yBorder;
            
            for i = 1:length(PVCell)
                if ~isempty(PVCell{i})
                    WriteEDMFile(fid, EDMRectangle(x+6, y+1, 'AlarmPV', PVCell{i}, 'Width', BMWidth-12, 'Height', 18));
                end
                y = y + yHeight + yBorder;
            end
            x = x + BMWidth + xBorder;
            
        elseif ismemberof(Family, Fields{j},'Boolean Control') || ismemberof(Family, Fields{j},'BooleanControl')
            % Boolean Control
            WriteEDMFile(fid, EDMStaticText(Fields{j}, x-3, y, 'Width', BCWidth+6, 'HorizontalAlignment', 'center'));
            y = y + yHeight + yBorder;
            
            for i = 1:length(PVCell)
                if ~isempty(PVCell{i})
                    if  strcmpi(Fields{j}, 'Reset')
                        WriteEDMFile(fid, EDMResetButton(PVCell{i}, x, y, 'Width', BCWidth));
                    else
                        %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y, 'Width', BCWidth, 'ButtonType', 'Push'));
                        %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y, 'Width', BCWidth, 'ButtonType', 'Toggle'));
                        WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Width', BCWidth));
                    end
                end
                y = y + yHeight + yBorder;
            end
            
            if strcmpi(BC_SetAllButton,'On') && length(PVCell) > 1
                % Make the shell command
                if strcmpi(Fields{j}, 'OnControl');
                    FileName = mml2caput(Family, Fields{j}, '', [], '', OnSleepTime);
                else
                    FileName = mml2caput(Family, Fields{j});
                end
                
                WriteEDMFile(fid, EDMShellCommand( ...
                    {sprintf('%s 1',FileName),sprintf('%s 0',FileName)}, x, y, 'Width', BCWidth, 'ButtonLabel', 'ALL', ...
                    'CommandLabel', {sprintf('%s.%s On',Family, Fields{j}),sprintf('%s.%s Off',Family, Fields{j})}));
                y = y + yHeight + yBorder;
            end
            
            x = x + BCWidth + xBorder;

        elseif ismemberof(Family, Fields{j},'Monitor')
            % Monitor
            WriteEDMFile(fid, EDMStaticText(Fields{j}, x-3, y, 'Width', MonitorWidth+6, 'HorizontalAlignment', 'center'));
            y = y + yHeight + yBorder;
            
            for i = 1:length(PVCell)
                if ~isempty(PVCell{i})
                    if strcmpi(HorizontalAlignment, 'right')
                        TextMonitor = EDMTextMonitor(PVCell{i}, x,   y, 'Width', MonitorWidth-7, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    elseif strcmpi(HorizontalAlignment, 'left')
                        TextMonitor = EDMTextMonitor(PVCell{i}, x+5, y, 'Width', MonitorWidth-5, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    else
                        TextMonitor = EDMTextMonitor(PVCell{i}, x,   y, 'Width', MonitorWidth,   'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    end
                    %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Precision',3);
                    WriteEDMFile(fid, TextMonitor);
                end
                y = y + yHeight + yBorder;
            end
            x = x + MonitorWidth + xBorder;
        else
            % Control
            WriteEDMFile(fid, EDMStaticText(Fields{j}, x-3, y, 'Width', ControlWidth+6, 'HorizontalAlignment', 'center'));
            y = y + yHeight + yBorder;

            for i = 1:length(PVCell)
                if ~isempty(PVCell{i})
                    % MotifWidget
                    if any(strcmpi(MotifWidget,{'On','Yes'}))
                        TextControl = EDMTextControl(PVCell{i}, x, y, 'Width', ControlWidth, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'MotifWidget', 'On');
                    else
                        if strcmpi(HorizontalAlignment, 'right')
                            TextControl = EDMTextControl(PVCell{i}, x, y, 'Width', ControlWidth-7, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'MotifWidget', MotifWidget);
                        elseif strcmpi(HorizontalAlignment, 'left')
                            TextControl = EDMTextControl(PVCell{i}, x, y, 'Width', ControlWidth-5, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'MotifWidget', MotifWidget);
                        else
                            TextControl = EDMTextControl(PVCell{i}, x, y, 'Width', ControlWidth, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'MotifWidget', MotifWidget);
                        end
                        WriteEDMFile(fid, TextControl);
                    end
                end
                y = y + yHeight + yBorder;
            end
            
            if strcmpi(SP_SetAllButton,'On') && length(PVCell) > 1
                % Make the shell command for Max, Save, Min
                if strcmpi(Fields{j}, 'Setpoint');
                    FileNameSaved = sprintf('%s_%s_MachineSave.sh', Family, Fields{j});
                    if exist(FileNameSaved, 'file')
                        FileNameMax   = mml2caput(Family, Fields{j}, 'Max', [], '', 0);
                        FileNameZero  = mml2caput(Family, Fields{j}, 0, [], sprintf('%s_%s_Zero.sh', Family, Fields{j}), 0);
                        if all(minpv(Family, Fields{j}) == 0)
                            WriteEDMFile(fid, EDMShellCommand( ...
                                {FileNameMax, FileNameSaved, FileNameZero}, x, y, 'Width', ControlWidth, 'ButtonLabel', 'ALL', ...
                                'CommandLabel', {'Maximum','Restore the Matlab Machine Save', 'Zero'}));
                            y = y + yHeight + yBorder;
                        else
                            FileNameMin   = mml2caput(Family, Fields{j}, 'Min', [], '', 0);
                            WriteEDMFile(fid, EDMShellCommand( ...
                                {FileNameMax, FileNameSaved, FileNameZero, FileNameMin}, x, y, 'Width', ControlWidth, 'ButtonLabel', 'ALL', ...
                                'CommandLabel', {'Maximum','Restore the Matlab Machine Save', 'Zero', 'Minimum'}));
                            y = y + yHeight + yBorder;
                        end
                    end
                end
            end
            
            x = x + ControlWidth + xBorder;
        end

        if x > xmax
            xmax = x;
        end
        if y > ymax
            ymax = y;
        end

        y = yTable;
    end
end


% Add a title across the top
%L = 8*length(Fields);  % Just a guess 
%xTitle = round((xmax-xStart)/2 + xStart - L/2);
%StaticText = EDMStaticText(sprintf('%s', Family), xTitle, yStart+2, 'Width', round(L)+25, 'FontSize',18, 'FontWeight','bold', 'HorizontalAlignment','center');
L = 12*length(TableTitle);  % Just a guess 
xTitle = round((xmax-xStart)/2 + xStart - L/2);
StaticText = EDMStaticText(sprintf('%s', TableTitle), xTitle, yStart+2, 'Width', round(L)+25, 'Height', 30, 'FontSize',24, 'FontWeight','bold', 'HorizontalAlignment','center');
WriteEDMFile(fid, StaticText);


if  ymax > 1500   %  I'm not sure when the slider appears
    % To account for a window slider
    Width  = xmax+30;
    Height = 1220;
else
    Width  = xmax + 10;
    Height = ymax + 10;
end
EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', Width, 'Height', Height);


fclose(fid);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');





