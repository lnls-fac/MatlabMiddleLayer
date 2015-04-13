function h = drawlattice(Offset, Scaling, varargin)
%DRAWLATTICE - Draws the AT lattice to a figure
%  h = drawlattice(Offset {0}, Scaling {1}, hAxes {gca}, Ldraw, thering)
%
%  h - handle to each element drawn
%
%  Programmers Notes
%  1. The AT index is stored in the Userdata of each symbol.
%     get(h(i),'Userdata')
%  2. To set a callback on an element use:
%     set(h(i),'ButtonDownFcn', FunctionName);
%  3. To set a context menu (right mouse menu) on an element use:
%     hcmenu = uicontextmenu;
%     set(h(i),'UIContextMenu', hcmenu);
%     cb = 'locogui(''ContextMenuPlot_Callback'',gcbo,[],[])';
%     h1 = uimenu(hcmenu, 'Label', 'Run #1', 'Callback', 'disp(''Run #1'');');
%     h2 = uimenu(hcmenu, 'Label', 'Run #2', 'Callback', 'disp(''Run #2'');');
%     h3 = uimenu(hcmenu, 'Label', 'Run #3', 'Callback', 'disp(''Run #3'');');
%
%  See also drawlattice2d

%  Written by Greg Portmann


% Minimum icon width in meters (also in drawquadrupolelocal)
MinIconWidth = .03;

if nargin < 1
    Offset = 0;
end
Offset = Offset(1);
if nargin < 2
    Scaling = 1;
end
Scaling = Scaling(1);

for ii=1:length(varargin)
    if iscell(varargin{ii})
        thering = varargin{ii};
    elseif ishandle(varargin{ii})
        hAxes = varargin{ii};
    elseif isnumeric(varargin{ii})
        Ldraw = varargin{ii};
    end
end

if ~exist('hAxes','var')
    hAxes = gca;
end
if ~exist('thering','var')
    global THERING;
    thering = THERING;
end

SPositions = findspos(thering, 1:length(thering)+1);
L = SPositions(end);

if ~exist('Ldraw','var')
    Ldraw = L;
end

plot(hAxes, [0 min([L Ldraw])], [0 0]+Offset, 'k');

% Remember the hold state then turn hold on
HoldState = ishold(hAxes);
hold(hAxes, 'on');

try
    ATIndexHCM = family2atindex(gethcmfamily);
catch
    ATIndexHCM = [];
end

try
    ATIndexVCM = family2atindex(getvcmfamily);
catch
    ATIndexVCM = [];
end


% Make default icons for elements of different physical types
h = [];
for i = 1:length(thering)
    NumberOfFinds = 0;
    
    SPos = SPositions(i);

    if SPos > Ldraw
        break
    end

    %if (isfield(thering{i},'BendingAngle') && thering{i}.BendingAngle) || strcmpi(thering{i}.FamName,'BEND')
    if isfield(thering{i},'BendingAngle') || strcmpi(thering{i}.FamName,'BEND')
        % make icons for bending magnets
        NumberOfFinds = NumberOfFinds + 1;
        IconHeight = .3;
        IconColor = [1 1 0];
        IconWidth = thering{i}.Length;
        if IconWidth < MinIconWidth    % meters
            IconWidth = MinIconWidth;
            SPos = SPos - IconWidth/2 + thering{i}.Length/2;
        end
        vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);

        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        %set(h(end), 'EdgeColor', IconColor);

    elseif strcmpi(thering{i}.FamName, 'ID') %&& KickTable
        
        NumberOfFinds = NumberOfFinds + 1;
        IconHeight = .25;
        IconColor = [0.3 0.3 0.3];
        IconWidth = thering{i}.Length;
        if IconWidth < MinIconWidth    % meters
            IconWidth = MinIconWidth;
            SPos = SPos - IconWidth/2 + thering{i}.Length/2;
        end
        vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        
        
    elseif isfield(thering{i},'K') %&& thering{i}.K
        % Quadrupole
        NumberOfFinds = NumberOfFinds + 1;
        if thering{i}.K == 0
            % Is it a skew quad?
            %if thering{i}.PolynomA(2) ~= 0
                h(length(h)+1) = drawquadrupole_local(hAxes, 'SkewQuad', SPos, thering{i}.Length, Offset, Scaling);
            %else
                % Call it a QF
            %    h(length(h)+1) = drawquadrupole_local(hAxes, 'QF', SPos, thering{i}.Length, Offset, Scaling);
            %end
        elseif thering{i}.K >= 0
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QF', SPos, thering{i}.Length, Offset, Scaling);
        else
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QD', SPos, thering{i}.Length, Offset, Scaling);
        end
        set(h(end), 'UserData', i);

    elseif isfield(thering{i},'M66') && any(strcmpi(thering{i}.FamName,{'QUAD','Q','QF','QD'}))
        % Quadrupole
        NumberOfFinds = NumberOfFinds + 1;
        if thering{i}.M66(1,1) <= 0
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QF', SPos, thering{i}.Length, Offset, Scaling);
        else
            h(length(h)+1) = drawquadrupole_local(hAxes, 'QD', SPos, thering{i}.Length, Offset, Scaling);
        end
        set(h(end), 'UserData', i);

    elseif isfield(thering{i},'PolynomB') && length(thering{i}.PolynomB)>2 && (thering{i}.PolynomB(3) || any(strcmpi(thering{i}.FamName,{'SF','SFF','SD','SDD','HSF','HSD'})))
        % Sextupole
        %Shrinkage = .05;
        NumberOfFinds = NumberOfFinds + 1;
        if thering{i}.PolynomB(3)>0 || any(strcmpi(thering{i}.FamName,{'SF','SFF','HSF'}))
            % Focusing sextupole
            IconHeight = .7;
            IconColor = [1 0 1];
            IconWidth = thering{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + thering{i}.Length/2;
            end
            %LShrinkage = Shrinkage * IconWidth;
            %vx = [SPos+LShrinkage          SPos+.33*IconWidth+LShrinkage  SPos+.66*IconWidth-LShrinkage  SPos+IconWidth-LShrinkage  SPos+IconWidth-LShrinkage  SPos+.66*IconWidth-LShrinkage   SPos+.33*IconWidth+LShrinkage  SPos+LShrinkage  SPos+LShrinkage];
            %vy = [IconHeight/3                      IconHeight                     IconHeight                   IconHeight/3               -IconHeight/3                -IconHeight                      -IconHeight           -IconHeight/3     IconHeight/3 ];
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing sextupole
            IconHeight = .7;
            IconColor = [0 1 0];
            IconWidth = thering{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + thering{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
            %vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            %vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        %set(h(end), 'EdgeColor', IconColor);

    elseif isfield(thering{i},'PolynomB') && length(thering{i}.PolynomB)>3 && (thering{i}.PolynomB(4) || any(strcmpi(thering{i}.FamName,{'Octupole','OCTU'})))
        % Octupole
        NumberOfFinds = NumberOfFinds + 1;
        if thering{i}.PolynomB(4)>0
            % Focusing octupole
            IconHeight = .6;
            IconColor = [0 .5 .5];
            IconWidth = thering{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + thering{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing octupole
            IconHeight = .6;
            IconColor = [.5 .5 0];
            IconWidth = thering{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + thering{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        %set(h(end), 'EdgeColor', IconColor);

    elseif (isfield(thering{i},'Frequency') && isfield(thering{i},'Voltage')) || any(strcmpi(thering{i}.FamName,{'Cavity','RFCavity'}))
        % RF cavity
        NumberOfFinds = NumberOfFinds + 1;
        IconColor = [1 0.5 0];
        if thering{i}.Length == 0
            h(length(h)+1) = plot(hAxes, SPos, 0+Offset, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 4);
        else
            IconHeight = .15;
            IconWidth = thering{i}.Length;
            if IconWidth < MinIconWidth    % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + thering{i}.Length/2;
            end
            vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
            vy = [IconHeight IconHeight -IconHeight -IconHeight];
            h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
            set(h(end), 'EdgeColor', IconColor);
        end
        set(h(end), 'UserData', i);

    elseif strcmpi(thering{i}.FamName,'BPM')
        % BPM
        NumberOfFinds = NumberOfFinds + 1;
        IconColor = 'k';
        h(length(h)+1) = plot(hAxes, SPos, 0+Offset, '.', 'Color', IconColor);
        %h(length(h)+1) = plot(hAxes, SPos, 0, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 1.5)
        set(h(end), 'UserData', i);
        
    elseif strcmpi(thering{i}.FamName,'TV')
        % TV screen
        NumberOfFinds = NumberOfFinds + 1;
        IconHeight = .7;
        IconColor = [.5 0 0];  %'k';
        %h(length(h)+1) = plot(hAxes, SPos, 0+Offset, 'x', 'Color', IconColor);
        h(length(h)+1) = plot(hAxes, SPos, Scaling*IconHeight+Offset, 'Marker','Square', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 3.5);
        set(h(end), 'UserData', i);
    end
    
    % Since correctors could be a combined function magnet, test separately
    if any(strcmpi(thering{i}.FamName,{'COR','XCOR','YCOR','HCOR','VCOR','HCM','VCM'})) || isfield(thering{i},'KickAngle')
        % Corrector
        NumberOfFinds = NumberOfFinds + 1;
        
        if NumberOfFinds > 1
            IconWidth = 0;
        else
            IconWidth = thering{i}.Length;
        end
        IconHeight = 1.1;  % was .8
        vx = [SPos   SPos];

        % Draw a line above for a HCM and below for a VCM
        % If it's not in the ML, then draw a line above and below
        CMFound = 1;
        if any(i == ATIndexVCM)
            IconColor = [0 0 0];
            vy = [-IconHeight 0];
            if IconWidth < MinIconWidth
                h(length(h)+1) = plot(hAxes, vx, Scaling*vy+Offset, 'Color', IconColor, 'LineWidth', 1.5);
            else
                IconWidth = thering{i}.Length;
                vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
                vy = [0 0 -IconHeight -IconHeight];
                %vy = [IconHeight IconHeight -IconHeight -IconHeight];
                h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor, 'LineStyle', '-', 'Parent',hAxes);
                if IconWidth < MinIconWidth*2 % meters
                    set(h(end), 'EdgeColor', IconColor);
                end
            end
            set(h(end), 'UserData', i);
            CMFound = 0;
        end

        if any(i == ATIndexHCM)
            IconColor = [0 0 0];
            vy = [0 IconHeight];
            if IconWidth < MinIconWidth
                h(length(h)+1) = plot(hAxes, vx, Scaling*vy+Offset, 'Color', IconColor, 'LineWidth', 1.5);
            else
                IconWidth = thering{i}.Length;
                vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
                vy = [IconHeight IconHeight 0 0];
                %vy = [IconHeight IconHeight -IconHeight -IconHeight];
                h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor, 'LineStyle', '-', 'Parent',hAxes);
                if IconWidth < MinIconWidth*2 % meters
                    set(h(end), 'EdgeColor', IconColor);
                end
            end
            set(h(end), 'UserData', i);
            CMFound = 0;
        end
        
        if CMFound
            IconColor = [0 0 0];
            vy = [-IconHeight IconHeight];
            if IconWidth < MinIconWidth
                h(length(h)+1) = plot(hAxes, vx, Scaling*vy+Offset, 'Color', IconColor, 'LineWidth', 1.5);
            else
                IconWidth = thering{i}.Length;
                vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
                vy = [IconHeight IconHeight -IconHeight -IconHeight];
                h(length(h)+1) = patch(vx, Scaling*vy+Offset, IconColor, 'LineStyle', '-', 'Parent',hAxes);
                if IconWidth < MinIconWidth*2 % meters
                    set(h(end), 'EdgeColor', IconColor);
                end
            end
            set(h(end), 'UserData', i);
            CMFound = 0;
        end
    end
end


% Leave the hold state as it was at the start
if ~HoldState
    hold(hAxes, 'off');
end

a = axis(hAxes);
axis(hAxes, [0 min([L Ldraw]) a(3:4)]);



function h = drawquadrupole_local(hAxes, QuadType, SPos, L, Offset, Scaling)

% Minimum icon width in meters
MinIconWidth = .03;

if strcmpi(QuadType, 'SkewQuad')
    % Focusing quadrupole
    IconHeight = .55;
    IconColor = [1 0 0];
    IconWidth = L;
    if IconWidth < MinIconWidth % meters
        IconWidth = MinIconWidth;
        SPos = SPos - IconWidth/2 + L/2;
    end
    vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
    vy = [0          IconHeight               0      -IconHeight    0];
elseif strcmpi(QuadType, 'QF')
    % Focusing quadrupole
    IconHeight = .8;
    IconColor = [1 0 0];
    IconWidth = L;
    if IconWidth < MinIconWidth % meters
        IconWidth = MinIconWidth;
        SPos = SPos - IconWidth/2 + L/2;
    end
    vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
    vy = [0          IconHeight               0      -IconHeight    0];
else
    % Defocusing quadrupole
    IconHeight = .7;
    IconColor = [0 0 1];
    IconWidth = L;
    if IconWidth < MinIconWidth % meters
        % Center about starting point
        IconWidth = MinIconWidth;
        SPos = SPos - IconWidth/2 + L/2;
    end
    vx = [SPos+.4*IconWidth    SPos    SPos+IconWidth  SPos+.6*IconWidth  SPos+IconWidth    SPos      SPos+.4*IconWidth];
    vy = [     0            IconHeight   IconHeight          0              -IconHeight  -IconHeight    0];
end
h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-', 'Parent',hAxes);
%set(h, 'EdgeColor', IconColor);
